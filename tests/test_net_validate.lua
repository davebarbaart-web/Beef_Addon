-- BeefNet validation, login sync and outbound pacing. Everything the wire decides
-- before Core is asked is proven here: payload shape, the officer gate, the revision
-- merge, reply suppression and the one-message-per-half-second throttle.
-- Whether a real TBC client actually delivers CHAT_MSG_ADDON still needs the game.
local stub = require("wow_ui_stub")
local restore = stub.install()

ChurchOfBeef = ChurchOfBeef or {}
ChurchOfBeef._IN_TEST = true
dofile("addon/ChurchOfBeef/Data/Ranks.lua")
dofile("addon/ChurchOfBeef/Core/Ladder.lua")
dofile("addon/ChurchOfBeef/Core/Officer.lua")
dofile("addon/ChurchOfBeef/Net/BeefNet.lua")
dofile("addon/ChurchOfBeef/Net/Sync.lua")

local COB = ChurchOfBeef
local N = COB.Net
local S = COB.Sync
local L = COB.Ladder
local O = COB.Officer

-- Count SavedVariables writes instead of performing them: the batching claim is
-- "one Save per sync answer", which is only observable as a call count.
local realDB = COB.DB
local saves = 0
COB.DB = { Save = function() saves = saves + 1 return true end }

stub.playerName = "Beefina"

-- Officer+ is rank index <= 1 in canon; Pleb is a member, Ghost is not in the guild.
local function roster(name)
  if type(name) ~= "string" then return nil end
  local key = name:lower():match("^([^%-]+)") or name:lower()
  if key == "pope" then return 0 end
  if key == "cardinal" then return 1 end
  if key == "pleb" then return 4 end
  return nil
end

local function reset()
  N:ResetForTests()
  S:ResetForTests()
  L:ResetForTests()
  O:ResetForTests()
  N.rosterLookup = roster
  stub.timers = {}
  stub.addonMessages = {}
  saves = 0
end

local function commit(name, rankId, standing, revision, updatedAt, updatedBy)
  return N:Encode("RANK_COMMIT", name, rankId, standing, revision, updatedAt, updatedBy)
end

local function deliver(payload, sender)
  return N:OnAddonMessage(N.Prefix, payload, N.Channel, sender or "Pope")
end

reset()

--------------------------------------------------------------------------------
-- Wire format: VERSION:TYPE:fields...
--------------------------------------------------------------------------------
assert_eq(N.Prefix, "COB", "the prefix is COB")
assert_eq(N.Channel, "GUILD", "ladder state travels on GUILD, never PARTY")

local encoded = commit("Beefina", 3, 300, 4, 1700, "Pope")
assert_eq(encoded, "1:RANK_COMMIT:Beefina:3:300:4:1700:Pope", "payload is version, type, then fields")
assert_true(#encoded < 240, "a commit payload fits well inside the 255-byte body limit")

local message = N:Decode(encoded)
assert_eq(message.version, 1, "the version is read back")
assert_eq(message.type, "RANK_COMMIT", "the type is read back")
assert_eq(message.fields[1], "Beefina", "the first field is the subject")

assert_eq(N:Decode(""), nil, "an empty payload decodes to nothing")
assert_eq(N:Decode(nil), nil, "a nil payload decodes to nothing")
assert_eq(N:Decode("RANK_COMMIT:Beefina"), nil, "a payload with no version is refused")

--------------------------------------------------------------------------------
-- Parsing a valid RANK_COMMIT
--------------------------------------------------------------------------------
local parsed = N:ValidateRankCommit(N:Decode(encoded), "Pope", roster)
assert_true(parsed ~= nil, "an officer's well-formed commit validates")
assert_eq(parsed.name, "Beefina", "name survives the wire")
assert_eq(parsed.rankId, 3, "rank id survives the wire")
assert_eq(parsed.standing, 300, "standing survives the wire")
assert_eq(parsed.revision, 4, "revision survives the wire")
assert_eq(parsed.updatedAt, 1700, "timestamp survives the wire")
assert_eq(parsed.updatedBy, "Pope", "committing officer survives the wire")

--------------------------------------------------------------------------------
-- Shape refusals: rank id, standing, revision, name
--------------------------------------------------------------------------------
local function refuse(payload, sender)
  local record, err = N:ValidateRankCommit(N:Decode(payload), sender or "Pope", roster)
  return record, err
end

local _, err = refuse(commit("Beefina", 0, 300, 4, 1700, "Pope"))
assert_eq(err, "invalid rank id", "rank id 0 is not in canon")
_, err = refuse(commit("Beefina", 8, 300, 4, 1700, "Pope"))
assert_eq(err, "invalid rank id", "a rank past the ladder is refused")
_, err = refuse(commit("Beefina", "Prophet", 300, 4, 1700, "Pope"))
assert_eq(err, "invalid rank id", "a rank title in the id field is refused")

_, err = refuse(commit("Beefina", 3, -1, 4, 1700, "Pope"))
assert_eq(err, "invalid standing", "negative standing is refused")
_, err = refuse(commit("Beefina", 3, "lots", 4, 1700, "Pope"))
assert_eq(err, "invalid standing", "non-numeric standing is refused")
assert_true(refuse(commit("Beefina", 3, 0, 4, 1700, "Pope")) ~= nil,
  "zero standing is legal: a wipe is a real officer decision")

_, err = refuse(commit("Beefina", 3, 300, 0, 1700, "Pope"))
assert_eq(err, "invalid revision", "revision 0 never came from a commit")
_, err = refuse(commit("Beefina", 3, 300, -2, 1700, "Pope"))
assert_eq(err, "invalid revision", "a negative revision is refused")

_, err = refuse(commit("", 3, 300, 4, 1700, "Pope"))
assert_eq(err, "missing name", "a commit with no subject is refused")
_, err = refuse(commit("   ", 3, 300, 4, 1700, "Pope"))
assert_eq(err, "missing name", "a whitespace subject is refused")

_, err = N:ValidateRankCommit(N:Decode("2:RANK_COMMIT:Beefina:3:300:4:1700:Pope"), "Pope", roster)
assert_eq(err, "protocol mismatch", "another protocol major is discarded, not guessed at")
_, err = N:ValidateRankCommit(N:Decode(N:Encode("HELLO", "0.1.0")), "Pope", roster)
assert_eq(err, "not a rank commit", "only RANK_COMMIT validates as a commit")

--------------------------------------------------------------------------------
-- The officer gate: the sender's roster rank index, not their claim
--------------------------------------------------------------------------------
_, err = refuse(commit("Beefina", 5, 9999, 9, 1700, "Pleb"), "Pleb")
assert_eq(err, "sender is not an officer", "a member cannot forge a commit")
_, err = refuse(commit("Beefina", 5, 9999, 9, 1700, "Pope"), "Ghost")
assert_eq(err, "sender is not an officer", "a name the roster does not answer to is refused")
_, err = N:ValidateRankCommit(N:Decode(commit("Beefina", 3, 300, 4, 1700, "Pope")), nil, roster)
assert_eq(err, "no sender", "an unsigned message has no rank index to check")
assert_true(refuse(commit("Beefina", 3, 300, 4, 1700, "Pope"), "Cardinal") ~= nil,
  "the first officer tier is Officer+ too")
assert_true(refuse(commit("Beefina", 3, 300, 4, 1700, "Pope"), "Pope-Whitemane") ~= nil,
  "a realm suffix on the wire still matches the roster")

-- The forged commit must not reach Core at all.
reset()
assert_eq(deliver(commit("Pleb", 7, 5000, 3, 100, "Pleb"), "Pleb"), false,
  "a forged commit is refused at validation")
assert_eq(L:HasOfficialRecord("Pleb"), false, "and it writes nothing to the ladder")

--------------------------------------------------------------------------------
-- Envelope: wrong prefix, wrong channel, unknown type
--------------------------------------------------------------------------------
reset()
assert_eq(N:OnAddonMessage("XYZ", commit("Beefina", 3, 300, 4, 1700, "Pope"), "GUILD", "Pope"), false,
  "another addon's prefix is not our traffic")
assert_eq(N:OnAddonMessage(N.Prefix, commit("Beefina", 3, 300, 4, 1700, "Pope"), "RAID", "Pope"), false,
  "ladder state is not accepted off the guild channel")
assert_eq(N:OnAddonMessage(N.Prefix, N:Encode("SCORE_EVENT", "Beefina", 5), "GUILD", "Pope"), false,
  "SCORE_EVENT is not a V1 type")
assert_eq(L:HasOfficialRecord("Beefina"), false, "none of those touched the ladder")

--------------------------------------------------------------------------------
-- Applying and replaying: the revision merge decides
--------------------------------------------------------------------------------
reset()
assert_eq(deliver(commit("Beefina", 3, 300, 4, 1700, "Pope")), true, "a valid commit applies")
assert_eq(L:GetRecord("Beefina").rankId, 3, "the ladder holds the committed rank")
assert_eq(L:GetRecord("Beefina").revision, 4, "and the committed revision")

local applied, why = deliver(commit("Beefina", 3, 300, 4, 1700, "Pope"))
assert_eq(applied, false, "a replay of the same revision is ignored")
assert_eq(why, "record did not beat the local copy", "and says so")

applied, why = deliver(commit("Beefina", 1, 0, 2, 1700, "Pope"))
assert_eq(applied, false, "a stale lower revision cannot demote anyone")
assert_eq(why, "record did not beat the local copy", "and says so")
assert_eq(L:GetRecord("Beefina").rankId, 3, "the fresher rank survives the stale commit")

assert_eq(deliver(commit("Beefina", 4, 600, 5, 1800, "Cardinal"), "Cardinal"), true,
  "a higher revision from another officer applies")
assert_eq(L:GetRecord("Beefina").rankId, 4, "the newer commit wins")
assert_eq(L:GetRecord("Beefina").updatedBy, "Cardinal", "and records who committed it")

--------------------------------------------------------------------------------
-- Roster not loaded: hold, never apply unverified
--------------------------------------------------------------------------------
reset()
N.rosterLookup = nil
O:ResetForTests()
GetNumGuildMembers = function() return 0 end

applied, why = deliver(commit("Beefina", 3, 300, 4, 1700, "Pope"))
assert_eq(applied, false, "a commit arriving before the roster is not applied")
assert_eq(why, "roster not loaded", "and says why")
assert_eq(#N.held, 1, "it is held instead of dropped")
assert_eq(L:HasOfficialRecord("Beefina"), false, "nothing unverified reached the ladder")
assert_true(stub.rosterRequests > 0, "and the roster is requested")

local guild = {
  { "Pope-Whitemane", 0 },
  { "Cardinal", 1 },
  { "Pleb", 4 },
}
GetNumGuildMembers = function() return #guild end
GetGuildRosterInfo = function(index)
  local entry = guild[index]
  if not entry then return nil end
  return entry[1], "Beefling", entry[2]
end

assert_eq(N:OnRosterUpdate(), 1, "the held commit applies once the roster arrives")
assert_eq(#N.held, 0, "and the hold queue empties")
assert_eq(L:GetRecord("Beefina").rankId, 3, "the ladder catches up")

--------------------------------------------------------------------------------
-- Officer:GetRosterLookup — the live gate BeefNet uses
--------------------------------------------------------------------------------
O:ResetForTests()
assert_eq(O:HasRosterCache(), false, "the cache starts unread")
assert_true(O:RefreshRosterCache(), "a readable roster caches")
local lookup = O:GetRosterLookup()
assert_eq(lookup("Pope"), 0, "a realm suffix in the roster still matches a bare wire name")
assert_eq(lookup("pope-whitemane"), 0, "and matches case-insensitively with a suffix")
assert_eq(lookup("Cardinal"), 1, "the first officer tier reads back")
assert_eq(lookup("Pleb"), 4, "a member reads back their real index")
assert_eq(lookup("Ghost"), nil, "a stranger has no rank index")
assert_eq(O:IsOfficerName("Pope", lookup), true, "the cached lookup gates officers in")
assert_eq(O:IsOfficerName("Pleb", lookup), false, "and members out")

O:ResetForTests()
GetNumGuildMembers = function() return 0 end
assert_eq(O:RefreshRosterCache(), false, "an unread roster does not cache")
assert_eq(O:HasRosterCache(), false, "and stays unready rather than caching 'nobody is an officer'")
assert_eq(O:GetRosterLookup()("Pope"), nil, "so every name fails closed")

GetNumGuildMembers = function() return #guild end

--------------------------------------------------------------------------------
-- Login sync: merge higher revisions under a single Save
--------------------------------------------------------------------------------
reset()
L:Commit("Beefina", 3, 300, "Pope", 1700)
L:Commit("Steakina", 2, 60, "Pope", 1700)
assert_eq(L:GetRecord("Beefina").revision, 1, "a local commit starts at revision 1")
saves = 0

local peerState = S:Chunks({
  { name = "Beefina", rankId = 4, standing = 600, revision = 9, updatedAt = 1900, updatedBy = "Cardinal" },
  { name = "Steakina", rankId = 1, standing = 0, revision = 1, updatedAt = 100, updatedBy = "Pope" },
  { name = "Roastina", rankId = 2, standing = 80, revision = 3, updatedAt = 1500, updatedBy = "Pope" },
})
assert_eq(#peerState, 1, "three records fit in one SYNC_STATE chunk")

S.pendingRequest = "req1"
assert_eq(S:OnSyncState("req1", peerState[1], "Cardinal"), 2, "two of three records beat the local copy")
assert_eq(L:GetRecord("Beefina").rankId, 4, "a higher revision wins the merge")
assert_eq(L:GetRecord("Steakina").rankId, 2, "an equal revision does not overwrite local state")
assert_eq(L:GetRecord("Roastina").rankId, 2, "an unknown member is learned from the answer")
assert_eq(saves, 1, "a whole sync answer writes SavedVariables once, not once per record")

assert_eq(S:OnSyncState("otherReq", peerState[1], "Cardinal"), 0,
  "an answer to somebody else's request is not merged")

--------------------------------------------------------------------------------
-- Login sync: request once after the settle, and suppress duplicate answers
--------------------------------------------------------------------------------
reset()
S.rand = function(low) return low end
L:Commit("Beefina", 2, 60, "Pope", 1700)

local reqId = S:OnLogin()
assert_true(type(reqId) == "string" and reqId ~= "", "login schedules a request id")
assert_eq(N.sentCount, 0, "nothing is sent during the login settle window")
stub.flushTimers()
assert_eq(N.sentCount, 1, "one SYNC_REQUEST goes out after the settle")
assert_true(N.lastSent:find("SYNC_REQUEST", 1, true) ~= nil, "and it is a sync request")

reset()
S.rand = function(low) return low end
L:Commit("Beefina", 2, 60, "Pope", 1700)
assert_eq(S:OnSyncRequest("peerReq", "Beefina"), false, "we never answer our own request")
assert_true(S:OnSyncRequest("peerReq", "Steakina"), "a peer request schedules a jittered answer")
assert_eq(N.sentCount, 0, "the answer waits for the jitter")
assert_eq(S:OnSyncRequest("peerReq", "Steakina"), false, "a duplicate request does not double-schedule")

-- Another peer answers while our jitter is still running.
S:OnSyncState("peerReq", "", "Cardinal")
stub.flushTimers()
assert_eq(N.sentCount, 0, "our answer is suppressed once a peer has answered")

reset()
S.rand = function(low) return low end
L:Commit("Beefina", 2, 60, "Pope", 1700)
assert_true(S:OnSyncRequest("loneReq", "Steakina"), "a peer request is taken up")
stub.flushTimers()
assert_eq(N.sentCount, 1, "with nobody else answering, we answer once")
assert_true(N.lastSent:find("SYNC_STATE", 1, true) ~= nil, "and it is a sync state")

reset()
assert_eq(S:OnSyncRequest("emptyReq", "Steakina"), false,
  "an empty ladder stays silent and leaves the floor to a peer who has one")

-- Officers answer from a shorter window: their copy is the freshest in practice.
assert_true(S.OfficerReplyDelay[2] < S.MemberReplyDelay[1],
  "an officer's whole jitter window closes before a member's opens")

--------------------------------------------------------------------------------
-- Sync chunking stays inside the body limit
--------------------------------------------------------------------------------
reset()
local many = {}
for i = 1, 40 do
  many[i] = { name = "Beefling" .. i, rankId = 3, standing = 250, revision = i,
    updatedAt = 1700, updatedBy = "Cardinal" }
end
local chunks = S:Chunks(many)
assert_true(#chunks > 1, "a guild-sized answer is split across messages")
local widest = 0
for i = 1, #chunks do
  local payload = N:Encode("SYNC_STATE", "req1", i, #chunks, chunks[i])
  if #payload > widest then widest = #payload end
end
assert_true(widest <= 240, "every chunk fits inside the addon message body limit")

assert_eq(#S:Chunks({ { name = "Bad:Name", rankId = 3, standing = 1, revision = 1 } }), 0,
  "a record carrying a delimiter is dropped rather than corrupting the batch")

--------------------------------------------------------------------------------
-- Outbound throttle: one message per half second
--------------------------------------------------------------------------------
reset()
local clock = 0
N.clock = function() return clock end
local wire = {}
N.transmit = function(payload) wire[#wire + 1] = payload end

for i = 1, 5 do N:Send(N:Encode("HELLO", "0.1." .. i)) end
assert_eq(#wire, 1, "a burst of five sends only puts one on the wire")
assert_eq(#N.queue, 4, "the rest wait in the queue")

clock = 0.4
assert_eq(N:Pump(), 0, "pumping inside the interval sends nothing")
assert_eq(#wire, 1, "still one message on the wire")

clock = 0.5
assert_eq(N:Pump(), 1, "the interval opens the gate for exactly one more")
assert_eq(#wire, 2, "two messages after half a second")

clock = 1.0
N:Pump()
clock = 1.5
N:Pump()
clock = 2.0
N:Pump()
assert_eq(#wire, 5, "the queue drains at one message per interval")
assert_eq(#N.queue, 0, "and empties")
assert_eq(N:Pump(), 0, "an empty queue sends nothing")

--------------------------------------------------------------------------------
-- Sending: only Core-shaped records, and only inside a guild
--------------------------------------------------------------------------------
reset()
N.transmit = function() end
local committed = L:Commit("Beefina", 3, 300, "Pope", 1700)
assert_true(N:SendRankCommit(committed), "a record Core produced is sendable")
assert_true(N.lastSent:find("RANK_COMMIT", 1, true) ~= nil, "as a RANK_COMMIT")

assert_eq(N:SendRankCommit(nil), false, "there is nothing to broadcast without a record")
assert_eq(N:SendRankCommit({ name = "Ghostina", rankId = 99, standing = 0, revision = 1 }), false,
  "a record with a rank outside canon is not sendable")
assert_eq(N:SendRankCommit({ name = "Ghostina", rankId = 3, standing = 0, revision = 0 }), false,
  "an uncommitted record (revision 0) is not sendable")

stub.inGuild = false
assert_eq(N:Send(N:Encode("HELLO", "0.1.0")), false, "a guildless client sends nothing")
stub.inGuild = true

--------------------------------------------------------------------------------
-- Init: register the prefix, and only once
--------------------------------------------------------------------------------
reset()
assert_true(N:Init(), "Init wires the listener")
assert_true(stub.registeredPrefixes["COB"], "the COB prefix is registered")
assert_true(N.frame._events["CHAT_MSG_ADDON"], "and CHAT_MSG_ADDON is listened for")
assert_true(N.frame._events["GUILD_ROSTER_UPDATE"], "along with roster updates")
assert_eq(N:Init(), false, "a second Init is a no-op")

-- The event handler routes a real commit end to end through the frame script.
N.rosterLookup = roster
L:ResetForTests()
stub.fire(N.frame, "OnEvent", "CHAT_MSG_ADDON", N.Prefix,
  commit("Beefina", 5, 1200, 3, 1700, "Pope"), N.Channel, "Pope")
assert_eq(L:GetRecord("Beefina").rankId, 5, "an officer commit off the event handler reaches the ladder")

reset()
COB.DB = realDB
restore()
