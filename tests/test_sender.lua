-- Registered-Pope sender (Phase 6 Lane H). Isolated: Common + Popes + Sender.
-- Workspace list + local SV override. No guild-rank reads or config UX.
-- No TOC / bootstrap / run.lua / BeefNet / Codec / Runtime / UI.
ChurchOfBeef = ChurchOfBeef or {}
ChurchOfBeef._IN_TEST = true

local standalone = (type(assert_eq) ~= "function")
local passed = 0
local failed = 0

if standalone then
  function assert_eq(a, b, msg)
    if a ~= b then
      failed = failed + 1
      print("FAIL: " .. (msg or "") .. " expected " .. tostring(b) .. " got " .. tostring(a))
    else
      passed = passed + 1
    end
  end
  function assert_true(v, msg)
    assert_eq(not not v, true, msg)
  end
end

dofile("addon/ChurchOfBeef/Core/Common.lua")
local priorPopes = ChurchOfBeef.Popes
dofile("addon/ChurchOfBeef/Data/Popes.lua")
dofile("addon/ChurchOfBeef/Data/Council.lua")
dofile("addon/ChurchOfBeef/Core/Sender.lua")

local COB = ChurchOfBeef
local Sender = COB.Sender

local guildReads = 0
local sent = 0
local framed = 0

GetNumGuildMembers = function()
  guildReads = guildReads + 1
  return 3
end
GetGuildRosterInfo = function()
  guildReads = guildReads + 1
  return "Pope", "Guild Master", 0
end
GetGuildInfo = function()
  guildReads = guildReads + 1
  return "Church of Beef", "Guild Master", 0
end
UnitIsGuildLeader = function()
  guildReads = guildReads + 1
  return true
end
GuildControlGetRankName = function()
  guildReads = guildReads + 1
  return "Guild Master"
end
CanEditOfficerNote = function()
  guildReads = guildReads + 1
  return true
end
IsGuildLeader = function()
  guildReads = guildReads + 1
  return true
end

SendAddonMessage = function()
  sent = sent + 1
end
C_ChatInfo = {
  SendAddonMessage = function()
    sent = sent + 1
  end,
}
CreateFrame = function()
  framed = framed + 1
end

local THEATER_KINDS = {
  "STATE",
  "SNAPSHOT",
  "THEATER",
  "PROCLAMATION",
  "Proclamation",
  "SANCTION",
  "VERDICT",
  "KNIGHTING",
  "Knighting",
  "HUD",
  "RITE",
  "CONSEQUENCE",
  "ASSEMBLY",
  "HELLO",
  "SUGGESTION",
  "SYNC_STATE",
  "SYNC_REQUEST",
  "RANK_COMMIT",
  "petition",
  "favor",
  "confession",
}

local OTHER_KINDS = {
  "THEATER",
  "PROCLAMATION",
  "Proclamation",
  "SANCTION",
  "VERDICT",
  "KNIGHTING",
  "Knighting",
  "HUD",
  "RITE",
  "CONSEQUENCE",
  "ASSEMBLY",
  "HELLO",
  "SUGGESTION",
  "SYNC_STATE",
  "SYNC_REQUEST",
  "RANK_COMMIT",
  "petition",
  "favor",
  "confession",
}

local function clearList()
  local list = COB.Popes.List
  for i = #list, 1, -1 do
    list[i] = nil
  end
end

local function restoreShipped()
  clearList()
  COB.Popes.List[1] = "Thedave"
end

--------------------------------------------------------------------------------
-- Isolated surface: predicate + workspace list. Not transport, not Runtime.
--------------------------------------------------------------------------------
assert_true(Sender ~= nil, "COB.Sender exists")
assert_true(COB.Popes ~= nil, "COB.Popes exists")
assert_eq(type(COB.Popes.List), "table", "Popes.List exists")
assert_eq(type(COB.Popes.IsListed), "function", "Popes.IsListed exists")
assert_eq(#COB.Popes.List, 1, "shipped List is Thedave")
assert_eq(COB.Names.Key(COB.Popes.List[1]), "thedave", "shipped name keys to thedave")
assert_eq(COB.Popes.IsListed("Thedave"), true, "Thedave is listed")
assert_eq(Sender:IsRegisteredPope("Thedave"), true, "Thedave is a registered Pope")
assert_eq(Sender:IsRegisteredPope("Thedave-Whitemane"), true, "realm suffix keys to Thedave")
if standalone then
  assert_eq(COB.Net, nil, "isolated suite does not load BeefNet")
  assert_eq(COB.Codec, nil, "isolated suite does not load Codec")
  assert_eq(COB.Store, nil, "isolated suite does not load Store")
  assert_eq(COB.Runtime, nil, "isolated suite does not load Runtime")
  assert_eq(COB.UI, nil, "isolated suite does not load UI")
  assert_eq(COB.Officer, nil, "isolated suite does not load Officer")
  assert_eq(COB.Roster, nil, "isolated suite does not load Roster")
end
assert_true(COB.Names ~= nil, "Common name law is loaded")
assert_eq(type(Sender.IsRegisteredPope), "function", "IsRegisteredPope exists")
assert_eq(type(Sender.Accept), "function", "Accept exists")

assert_eq(Sender.RegisterPope, nil, "no RegisterPope")
assert_eq(Sender.UnregisterPope, nil, "no UnregisterPope")
assert_eq(Sender.SetPope, nil, "no SetPope")
assert_eq(Sender.AddPope, nil, "no AddPope")
assert_eq(Sender.LoadPopes, nil, "no LoadPopes")
assert_eq(Sender.SavePopes, nil, "no SavePopes")
assert_eq(Sender.OverridePope, nil, "no override UX")
assert_eq(Sender.Configure, nil, "no config UX")
assert_eq(Sender.OpenConfig, nil, "no config frame")
assert_eq(Sender.popes, nil, "no pope table")
assert_eq(Sender.list, nil, "no pope list")
assert_eq(Sender.registered, nil, "no registered table")
assert_eq(COB.Popes.Register, nil, "no Popes.Register")
assert_eq(COB.Popes.Add, nil, "no Popes.Add")
assert_eq(COB.Popes.Set, nil, "no Popes.Set")

assert_eq(Sender.Send, nil, "no Send")
assert_eq(Sender.SendAddonMessage, nil, "no SendAddonMessage")
assert_eq(Sender.Transmit, nil, "no Transmit")
assert_eq(Sender.Whisper, nil, "no whisper routing")
assert_eq(Sender.SendWhisper, nil, "no whisper send")
assert_eq(Sender.Hold, nil, "no hold timer")
assert_eq(Sender.ReleaseHeld, nil, "no hold replay")
assert_eq(Sender.discarded, nil, "no discarded inbox")
assert_eq(Sender.held, nil, "no held queue")
assert_eq(Sender.inbox, nil, "no inbox")
assert_eq(Sender.queue, nil, "no queue")
assert_eq(Sender.pending, nil, "no pending store")
assert_eq(Sender.Grant, nil, "no Grant")
assert_eq(Sender.CreateFrame, nil, "Sender does not CreateFrame")
assert_eq(Sender.StartEvent, nil, "Runtime verbs are not this lane")
assert_eq(Sender.Encode, nil, "Codec is not this lane")
assert_eq(Sender.Decode, nil, "Codec is not this lane")

--------------------------------------------------------------------------------
-- Unlisted names: Beefina / Pope / GM / nil stay false. STATE / SNAPSHOT refuse.
-- Guild rank is not the Church. The name Pope is not a registered Pope.
--------------------------------------------------------------------------------
assert_eq(COB.Popes.IsListed("Beefina"), false, "Thedave does not list Beefina")
assert_eq(Sender:IsRegisteredPope("Beefina"), false, "a named sender is not a registered Pope")
assert_eq(Sender:IsRegisteredPope("Beefina-Whitemane"), false, "a realm-suffixed sender is not a registered Pope")
assert_eq(Sender:IsRegisteredPope("Pope"), false, "the name Pope is not a registered Pope")
assert_eq(Sender:IsRegisteredPope("GM"), false, "GM is not a registered Pope")
assert_eq(Sender:IsRegisteredPope("Guild Master"), false, "Guild Master is not a registered Pope")
assert_eq(Sender:IsRegisteredPope("Officer"), false, "Officer is not a registered Pope")
assert_eq(Sender:IsRegisteredPope("Council"), false, "Council is not a registered Pope")
assert_eq(Sender:IsRegisteredPope(nil), false, "missing sender is not a registered Pope")
assert_eq(Sender:IsRegisteredPope(""), false, "empty sender is not a registered Pope")
assert_eq(Sender:IsRegisteredPope("   "), false, "whitespace sender is not a registered Pope")
assert_eq(Sender:IsRegisteredPope(1), false, "a number is not a registered Pope")
assert_eq(Sender:IsRegisteredPope(true), false, "a bool is not a registered Pope")
assert_eq(Sender:IsRegisteredPope({ name = "Pope" }), false, "a table is not a registered Pope")
assert_eq(Sender:IsRegisteredPope(0), false, "rankIndex 0 is not a registered Pope")

for i = 1, #THEATER_KINDS do
  local kind = THEATER_KINDS[i]
  assert_eq(Sender:Accept("Beefina", kind), false, kind .. " from a named sender is discarded")
  assert_eq(Sender:Accept("Pope", kind), false, kind .. " from Pope-the-name is discarded")
  assert_eq(Sender:Accept("GM", kind), false, kind .. " from GM is discarded")
  assert_eq(Sender:Accept(nil, kind), false, kind .. " with a missing sender is discarded")
  assert_eq(Sender:Accept("", kind), false, kind .. " with an empty sender is discarded")
end

assert_eq(Sender:Accept("Beefina", "STATE"), false, "STATE is not congregation input")
assert_eq(Sender:Accept("Beefina", "SNAPSHOT"), false, "SNAPSHOT is not congregation input")
assert_eq(Sender:Accept("Thedave", "STATE"), true, "STATE from Thedave is accepted")
assert_eq(Sender:Accept("thedave", "SNAPSHOT"), true, "SNAPSHOT from thedave is accepted")
assert_eq(Sender:Accept("Thedave-Whitemane", "STATE"), true, "STATE from realm-suffixed Thedave is accepted")
assert_eq(Sender:Accept("Beefina", nil), false, "a missing kind is discarded")
assert_eq(Sender:Accept("Beefina", ""), false, "an empty kind is discarded")
assert_eq(Sender:Accept("Beefina", "input"), false, "lowercase input is not INPUT")
assert_eq(Sender:Accept("Beefina", "Input"), false, "mixed-case Input is not INPUT")

--------------------------------------------------------------------------------
-- Accept: congregation INPUT is not theater. Non-empty sender string may pass.
-- Missing sender is false. IsRegisteredPope stays independent of INPUT.
--------------------------------------------------------------------------------
assert_eq(Sender:Accept("Beefina", "INPUT"), true, "INPUT from a non-empty sender is accepted")
assert_eq(Sender:IsRegisteredPope("Beefina"), false, "an accepted INPUT sender is still not a registered Pope")
assert_eq(Sender:Accept("Beefina-Whitemane", "INPUT"), true, "INPUT from a realm-suffixed sender is accepted")
assert_eq(Sender:Accept("GM", "INPUT"), true, "INPUT from a sender named GM is still congregation input")
assert_eq(Sender:IsRegisteredPope("GM"), false, "Accepting INPUT does not make GM a Pope")
assert_eq(Sender:Accept("Pope", "INPUT"), true, "INPUT from a sender named Pope is still congregation input")
assert_eq(Sender:IsRegisteredPope("Pope"), false, "Accepting INPUT does not register a Pope")

assert_eq(Sender:Accept(nil, "INPUT"), false, "missing sender is false for INPUT")
assert_eq(Sender:Accept("", "INPUT"), false, "empty sender is false for INPUT")
assert_eq(Sender:Accept("   ", "INPUT"), false, "whitespace sender is false for INPUT")
assert_eq(Sender:Accept(1, "INPUT"), false, "a numeric sender is not a string")
assert_eq(Sender:Accept(true, "INPUT"), false, "a bool sender is not a string")
assert_eq(Sender:Accept({ name = "Beefina" }, "INPUT"), false, "a table sender is not a string")
assert_eq(Sender:Accept("Beefina"), false, "INPUT kind must be named")

local trimmed = COB.Names.Trim("  Chuckroast  ")
assert_eq(trimmed, "Chuckroast", "Common trim is the identity law")
assert_eq(Sender:Accept("  Chuckroast  ", "INPUT"), true, "a padded sender string still has identity")
assert_eq(Sender:IsRegisteredPope("  Chuckroast  "), false, "a padded sender is still not a registered Pope")

--------------------------------------------------------------------------------
-- Listed name: Names.Key variants match. STATE / SNAPSHOT Accept. Other kinds
-- still die. INPUT stays open for any present sender, including non-Popes.
--------------------------------------------------------------------------------
COB.Popes.List[#COB.Popes.List + 1] = COB.Names.Key("Beefina")
assert_eq(COB.Popes.IsListed("Beefina"), true, "listed key is listed")
assert_eq(COB.Popes.IsListed("Beefina-Whitemane"), true, "realm suffix keys to the list")
assert_eq(COB.Popes.IsListed("  BEEFINA  "), true, "padded case keys to the list")
assert_eq(COB.Popes.IsListed("beefina"), true, "lowercase key is listed")
assert_eq(COB.Popes.IsListed("Pope"), false, "listing Beefina does not list Pope")
assert_eq(COB.Popes.IsListed("GM"), false, "listing Beefina does not list GM")
assert_eq(COB.Popes.IsListed(nil), false, "missing name is not listed")

assert_eq(Sender:IsRegisteredPope("Beefina"), true, "a listed sender is a registered Pope")
assert_eq(Sender:IsRegisteredPope("Beefina-Whitemane"), true, "a realm-suffixed listed sender is a registered Pope")
assert_eq(Sender:IsRegisteredPope("  Beefina  "), true, "a padded listed sender is a registered Pope")
assert_eq(Sender:IsRegisteredPope("BEEFINA"), true, "a case variant listed sender is a registered Pope")
assert_eq(Sender:IsRegisteredPope("Pope"), false, "the name Pope is still not a registered Pope")
assert_eq(Sender:IsRegisteredPope("GM"), false, "GM is still not a registered Pope")
assert_eq(Sender:IsRegisteredPope("Chuckroast"), false, "an unlisted sender is not a registered Pope")

assert_eq(Sender:Accept("Beefina", "STATE"), true, "STATE from a listed Pope is accepted")
assert_eq(Sender:Accept("Beefina-Whitemane", "STATE"), true, "STATE from a realm-suffixed listed Pope is accepted")
assert_eq(Sender:Accept("  beefina  ", "SNAPSHOT"), true, "SNAPSHOT from a keyed listed Pope is accepted")
assert_eq(Sender:Accept("BEEFINA", "SNAPSHOT"), true, "SNAPSHOT from a case-variant listed Pope is accepted")
assert_eq(Sender:Accept("Chuckroast", "STATE"), false, "STATE from an unlisted sender is discarded")
assert_eq(Sender:Accept("Chuckroast", "SNAPSHOT"), false, "SNAPSHOT from an unlisted sender is discarded")
assert_eq(Sender:Accept("Pope", "STATE"), false, "STATE from Pope-the-name is discarded")
assert_eq(Sender:Accept(nil, "STATE"), false, "STATE with a missing sender is discarded")

for i = 1, #OTHER_KINDS do
  local kind = OTHER_KINDS[i]
  assert_eq(Sender:Accept("Beefina", kind), false, kind .. " from a listed Pope is still discarded")
end

assert_eq(Sender:Accept("Beefina", "INPUT"), true, "INPUT from a listed Pope is still congregation input")
assert_eq(Sender:Accept("Chuckroast", "INPUT"), true, "INPUT from a non-Pope is still accepted")
assert_eq(Sender:Accept("GM", "INPUT"), true, "INPUT from GM is still congregation input")
assert_eq(Sender:IsRegisteredPope("Chuckroast"), false, "INPUT does not register a non-Pope")

clearList()
COB.Popes.List[1] = "Beefina"
assert_eq(COB.Popes.IsListed("Beefina"), true, "Display-case List entry is re-keyed")
assert_eq(Sender:IsRegisteredPope("beefina"), true, "Display-case List entry registers")
restoreShipped()
assert_eq(#COB.Popes.List, 1, "List restored to Thedave")
assert_eq(COB.Popes.IsListed("Thedave"), true, "restored List lists Thedave")
assert_eq(COB.Popes.IsListed("Beefina"), false, "restored List does not list Beefina")
assert_eq(Sender:IsRegisteredPope("Beefina"), false, "Beefina is still not a registered Pope")
assert_eq(Sender:Accept("Beefina", "STATE"), false, "STATE dies again after List restore")
assert_eq(Sender:Accept("Beefina", "SNAPSHOT"), false, "SNAPSHOT dies again after List restore")

--------------------------------------------------------------------------------
-- Override: ChurchOfBeefDB.ui.popeOverrides. Popes.lua does not
-- read SV. Clear after. Missing ui / override is ignored.
--------------------------------------------------------------------------------
clearList()
local priorDB = ChurchOfBeefDB
ChurchOfBeefDB = { ui = { popeOverrides = { "Beefina" } } }
assert_eq(#COB.Popes.List, 0, "override does not write List")
assert_eq(COB.Popes.IsListed("Beefina"), false, "Popes.lua does not read the override")
assert_eq(Sender:IsRegisteredPope("Beefina"), true, "Sender reads popeOverrides")
assert_eq(Sender:IsRegisteredPope("Beefina-Whitemane"), true, "override compares via Names.Key")
assert_eq(Sender:IsRegisteredPope("  BEEFINA  "), true, "override keys padded case")
assert_eq(Sender:IsRegisteredPope("Pope"), false, "override does not make Pope-the-name a Pope")
assert_eq(Sender:Accept("Beefina", "STATE"), true, "STATE from an override Pope is accepted")
assert_eq(Sender:Accept("Beefina", "SNAPSHOT"), true, "SNAPSHOT from an override Pope is accepted")
assert_eq(Sender:Accept("Beefina", "THEATER"), false, "THEATER from an override Pope is still discarded")
assert_eq(Sender:Accept("Chuckroast", "INPUT"), true, "INPUT is still independent of the override")
ChurchOfBeefDB = priorDB
assert_eq(Sender:IsRegisteredPope("Beefina"), false, "cleared override is not a registered Pope")
assert_eq(Sender:Accept("Beefina", "STATE"), false, "STATE dies after override clear")

ChurchOfBeefDB = {}
assert_eq(Sender:IsRegisteredPope("Beefina"), false, "missing ui is ignored")
ChurchOfBeefDB = { ui = {} }
assert_eq(Sender:IsRegisteredPope("Beefina"), false, "missing popeOverrides is ignored")
ChurchOfBeefDB = { ui = { popeOverrides = "Beefina" } }
assert_eq(Sender:IsRegisteredPope("Beefina"), false, "a non-array override is ignored")
ChurchOfBeefDB = priorDB
restoreShipped()
assert_eq(Sender:IsRegisteredPope("Thedave"), true, "shipped Thedave survives override tests")

--------------------------------------------------------------------------------
-- Discarded theater is not stored for later paint. No send. No frames.
--------------------------------------------------------------------------------
Sender:Accept("Spoof", "STATE")
Sender:Accept("Spoof", "SNAPSHOT")
Sender:Accept("Spoof", "PROCLAMATION")
Sender:Accept(nil, "STATE")
assert_eq(Sender.discarded, nil, "rejected STATE is not stored")
assert_eq(Sender.held, nil, "rejected SNAPSHOT is not held")
assert_eq(Sender.inbox, nil, "rejected theater is not queued")
assert_eq(Sender.queue, nil, "no later-paint queue")
assert_eq(Sender.pending, nil, "no pending discarded body")

assert_eq(Sender:CanWriteStub("Thedave"), true, "the registered Pope may write stubs")
assert_eq(Sender:IsListedCouncil("Beefina"), false, "empty Council list lists no one")
assert_eq(Sender:CanWriteStub("Beefina"), false, "unlisted Beefina cannot write stubs")
assert_eq(Sender:Accept("Beefina", "STUB"), false, "STUB from an unlisted sender is discarded")
assert_eq(Sender:Accept("Beefina", "NIGHTS"), false, "NIGHTS from congregation is discarded")
assert_eq(Sender:Accept("Thedave", "NIGHTS"), true, "NIGHTS from Thedave is accepted")
assert_eq(Sender:Accept("Thedave", "STUB"), true, "STUB from Thedave is accepted")

local priorCouncilDB = ChurchOfBeefDB
ChurchOfBeefDB = { ui = { councilOverrides = { "Beefina" } } }
assert_eq(Sender:IsListedCouncil("Beefina"), true, "councilOverrides lists Beefina")
assert_eq(Sender:CanWriteStub("Beefina"), true, "listed Council may write stubs")
assert_eq(Sender:Accept("Beefina", "STUB"), true, "STUB from listed Council is accepted")
assert_eq(Sender:Accept("Beefina", "STUB_WITHDRAW"), true, "STUB_WITHDRAW from listed Council is accepted")
assert_eq(Sender:Accept("Beefina", "NIGHTS"), false, "listed Council still cannot send NIGHTS")
assert_eq(Sender:IsRegisteredPope("Beefina"), false, "Council override is not a Pope")
ChurchOfBeefDB = priorCouncilDB

assert_eq(guildReads, 0, "Sender does not read guild rank")
assert_eq(sent, 0, "Sender does not SendAddonMessage")
assert_eq(framed, 0, "Sender does not CreateFrame")

if not standalone then
  COB.Popes = priorPopes
end

if standalone then
  print(string.format("Tests finished: %d passed, %d failed", passed, failed))
  if failed > 0 then os.exit(1) end
end
