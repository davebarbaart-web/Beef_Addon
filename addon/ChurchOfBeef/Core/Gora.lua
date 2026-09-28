ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Sanctioned Gora: Petition → (Recommend) → Sanction → Propose → Pope ruling.
-- Typed-result RecordResult, GrantGora, pair-pay cooldown, and goraLordWin stay
-- excised (Audit V4). Leftover Challenge pair-key notes remain for the old suite.
-- Combat is WoW's. Software proposes; the Pope ratifies. No ELO, no auto-elevate.
local Gora = {
  pending = {},
  petitions = {},
  sanctioned = nil,
  proposal = nil,
}
COB.Gora = Gora

-- Standing picks only. Latest replaces earlier. Never Store / Archive.
-- Pope SV persist is Gora:Snapshot → ChurchOfBeefDB.gora (schema 7).
-- Congregation must not flush this map over the shared account file.
-- Tagged to the event the picks belong to so leftovers die with that event,
-- not merely when sanctioned is nil (consequence beat still needs the map).
local favorPicks = {}
local favorEventId = nil

-- Cleared-bout snapshot for CONSEQUENCE / HUD persist. GetSanctioned stays
-- nil after a ruling; last pair is the just-cleared bout. Pope SV persist
-- is Gora:Snapshot (lastSanctioned + eventId). Congregation must not flush.
local lastSanctioned = nil
local lastFavorSplit = { a = 0, b = 0 }

local function wipeFavor()
  favorPicks = {}
  favorEventId = nil
end

local function wipeLast()
  lastSanctioned = nil
  lastFavorSplit = { a = 0, b = 0 }
end

-- A challenge nobody ever records is social noise, not state. Expiring and
-- capping the table keeps a night of trash talk from growing without bound.
local CHALLENGE_TTL = 1800
local PENDING_MAX = 20

local function normalizeName(name)
  return COB.Names and COB.Names.Display(name) or nil
end

local function nameKey(name)
  return COB.Names and COB.Names.Key(name) or nil
end

local function sameName(a, b)
  return COB.Names and COB.Names.Same(a, b) or false
end

local function resolveTime(now)
  return COB.Clock and COB.Clock.Wall(now) or (type(now) == "number" and now or 0)
end

local function localName()
  return COB.Group and COB.Group.PlayerName() or nil
end

local function isId(n)
  return type(n) == "number" and n == math.floor(n) and n >= 1
end

local function deepcopy(value)
  if type(value) ~= "table" then return value end
  local out = {}
  for k, v in pairs(value) do
    out[deepcopy(k)] = deepcopy(v)
  end
  return out
end

local function trimLine(text)
  if text == nil then return nil end
  if type(text) ~= "string" then return nil, "stipulation must be a line" end
  if COB.Names and COB.Names.Trim then return COB.Names.Trim(text) end
  text = text:gsub("^%s+", ""):gsub("%s+$", "")
  if text == "" then return nil end
  return text
end

local function liveEventId()
  if not COB.Runtime or not COB.Runtime.Snapshot then return nil end
  local snap = COB.Runtime:Snapshot()
  if type(snap) ~= "table" or snap.state == "QUIET" then return nil end
  if not isId(snap.eventId) then return nil end
  return snap.eventId
end

local function knownCharacter(id)
  if not isId(id) then return false end
  if COB.Store and COB.Store.GetCharacter then
    return COB.Store:GetCharacter(id) ~= nil
  end
  return true
end

-- Name → store id. Look up only. Never Ensure / CreateHuman / LinkCharacter.
local function lookupCharacterId(name)
  if not (COB.Store and type(COB.Store.Snapshot) == "function") then
    return nil
  end
  local snap = COB.Store:Snapshot()
  local chars = type(snap) == "table" and snap.characters or nil
  if type(chars) ~= "table" then return nil end
  for i = 1, #chars do
    local row = chars[i]
    if type(row) == "table" and sameName(row.name, name) then
      return row.id
    end
  end
  return nil
end

local function isUnsignedPetition(entry)
  return type(entry) == "table" and type(entry.senderKey) == "string" and not isId(entry.characterId)
end

local function copyPetition(entry)
  local out = {}
  if entry.characterId ~= nil then
    out.characterId = entry.characterId
  end
  if entry.namedOpponentId ~= nil then
    out.namedOpponentId = entry.namedOpponentId
  end
  if entry.senderKey ~= nil then
    out.senderKey = entry.senderKey
  end
  if entry.name ~= nil then
    out.name = entry.name
  end
  return out
end

local function copyPetitionPersist(entry)
  local out = copyPetition(entry)
  if type(entry) == "table" and entry.eventId ~= nil then
    out.eventId = entry.eventId
  end
  return out
end

local function copyMap(map)
  local out = {}
  if type(map) ~= "table" then return out end
  for k, v in pairs(map) do
    out[k] = v
  end
  return out
end

local function copyLastPair(row)
  if type(row) ~= "table" then return nil end
  if not isId(row.fighterA) or not isId(row.fighterB) then return nil end
  local out = { fighterA = row.fighterA, fighterB = row.fighterB }
  if isId(row.eventId) then out.eventId = row.eventId end
  return out
end

-- Snapshot gate: eventId is a ≥1 integer. Empty {} / missing is not a snapshot
-- (same shape as event.state / decree.line).
local function isGoraSnapshot(snap)
  return type(snap) == "table" and isId(snap.eventId)
end

local function deskEventId(self)
  if self.sanctioned and isId(self.sanctioned.eventId) then
    return self.sanctioned.eventId
  end
  if lastSanctioned and isId(lastSanctioned.eventId) then
    return lastSanctioned.eventId
  end
  if isId(favorEventId) then
    return favorEventId
  end
  for _, entry in pairs(self.petitions) do
    if type(entry) == "table" and isId(entry.eventId) then
      return entry.eventId
    end
  end
  return liveEventId()
end

local function copySanctioned(row)
  if not row then return nil end
  return {
    fighterA = row.fighterA,
    fighterB = row.fighterB,
    stipulation = row.stipulation,
  }
end

local function samePair(row, a, b)
  if not row then return false end
  return (row.fighterA == a and row.fighterB == b)
    or (row.fighterA == b and row.fighterB == a)
end

local function otherFighter(row, id)
  if not row then return nil end
  if row.fighterA == id then return row.fighterB end
  if row.fighterB == id then return row.fighterA end
  return nil
end

function Gora:_Expire()
  local eventId = liveEventId()
  if not eventId then
    self.petitions = {}
    self.sanctioned = nil
    self.proposal = nil
    wipeFavor()
    wipeLast()
    return
  end
  local drop = nil
  for id, entry in pairs(self.petitions) do
    if entry.eventId ~= eventId then
      drop = drop or {}
      drop[#drop + 1] = id
    end
  end
  if drop then
    for i = 1, #drop do self.petitions[drop[i]] = nil end
  end
  if self.sanctioned and self.sanctioned.eventId ~= eventId then
    self.sanctioned = nil
    self.proposal = nil
  end
  if favorEventId ~= eventId then
    wipeFavor()
  end
  if lastSanctioned and lastSanctioned.eventId ~= eventId then
    wipeLast()
  end
end

-- One note per pair regardless of who called it out.
local function pairKey(a, b)
  local x, y = nameKey(a), nameKey(b)
  if not x or not y then return nil end
  if x > y then x, y = y, x end
  return x .. "\0" .. y
end

local function copyChallenge(entry)
  return { challenger = entry.challenger, target = entry.target, at = entry.at }
end

function Gora:_Prune(at)
  local expired = nil
  for key, entry in pairs(self.pending) do
    if (at - entry.at) > CHALLENGE_TTL then
      expired = expired or {}
      expired[#expired + 1] = key
    end
  end
  if not expired then return 0 end
  for i = 1, #expired do self.pending[expired[i]] = nil end
  return #expired
end

local function countPending(pending)
  local n = 0
  for _ in pairs(pending) do n = n + 1 end
  return n
end

-- challenger defaults to the local player; it is a parameter so desktop tests
-- never need a UnitName stub.
function Gora:Challenge(target, challenger, now)
  local them = normalizeName(target)
  if not them then return nil, "name someone to challenge" end
  local me = normalizeName(challenger) or normalizeName(localName())
  if not me then return nil, "your character name is not known yet" end
  if sameName(me, them) then return nil, "a Gora needs two different combatants" end

  local at = resolveTime(now)
  self:_Prune(at)

  local key = pairKey(me, them)
  if not key then return nil, "a Gora needs two different combatants" end
  if not self.pending[key] and countPending(self.pending) >= PENDING_MAX then
    return nil, "too many challenges are already open"
  end

  self.pending[key] = { challenger = me, target = them, at = at }
  return copyChallenge(self.pending[key])
end

function Gora:Cancel(target, challenger)
  local them = normalizeName(target)
  local me = normalizeName(challenger) or normalizeName(localName())
  if not them or not me then return false end
  local key = pairKey(me, them)
  if not key or not self.pending[key] then return false end
  self.pending[key] = nil
  return true
end

function Gora:IsChallenged(a, b)
  local key = pairKey(a, b)
  if not key then return false end
  return self.pending[key] ~= nil
end

-- Copies, oldest first: the caller gets a list it can sort or mutate freely.
function Gora:GetPending(now)
  self:_Prune(resolveTime(now))
  local out = {}
  for _, entry in pairs(self.pending) do out[#out + 1] = copyChallenge(entry) end
  table.sort(out, function(a, b)
    if a.at ~= b.at then return a.at < b.at end
    if a.challenger ~= b.challenger then return a.challenger < b.challenger end
    return a.target < b.target
  end)
  return out
end

function Gora:Petition(characterId, namedOpponentId)
  self:_Expire()
  local eventId = liveEventId()
  if not eventId then return nil, "no event" end
  if not isId(characterId) then return nil, "invalid character id" end
  if not knownCharacter(characterId) then return nil, "unknown character" end
  if namedOpponentId ~= nil then
    if not isId(namedOpponentId) then return nil, "opponent must be a character id" end
    if namedOpponentId == characterId then
      return nil, "a Gora needs two different combatants"
    end
    if not knownCharacter(namedOpponentId) then return nil, "unknown opponent" end
  end
  local entry = { characterId = characterId, eventId = eventId }
  if namedOpponentId ~= nil then entry.namedOpponentId = namedOpponentId end
  self.petitions[characterId] = entry
  return copyPetition(entry)
end

-- INPUT apply. Ignore payload character ids. Known sender names resolve to a
-- store id; unknown senders sit as an unsigned name-key row. Unknown opponents
-- are dropped; the ask is still recorded. Never CreateHuman / Ensure / Link.
function Gora:PetitionFromSender(sender, namedOpponentId)
  self:_Expire()
  local eventId = liveEventId()
  if not eventId then return nil, "no event" end
  local key = nameKey(sender)
  if not key then return nil, "invalid sender" end
  local shown = normalizeName(sender)
  local characterId = lookupCharacterId(sender)
  local opponentId
  if namedOpponentId ~= nil and isId(namedOpponentId) and knownCharacter(namedOpponentId) then
    if not (characterId and namedOpponentId == characterId) then
      opponentId = namedOpponentId
    end
  end
  if characterId then
    return self:Petition(characterId, opponentId)
  end
  local entry = { senderKey = key, name = shown, eventId = eventId }
  if opponentId ~= nil then entry.namedOpponentId = opponentId end
  self.petitions[key] = entry
  return copyPetition(entry)
end

function Gora:Dismiss(characterId)
  self:_Expire()
  if isId(characterId) then
    if not self.petitions[characterId] then return false end
    self.petitions[characterId] = nil
    return true
  end
  local key = nameKey(characterId) or (type(characterId) == "string" and characterId or nil)
  if not key or not self.petitions[key] then return false end
  self.petitions[key] = nil
  return true
end

function Gora:GetPetitions(presentAndAlive)
  self:_Expire()
  local out = {}
  local present = type(presentAndAlive) == "table" and presentAndAlive or nil
  for id, entry in pairs(self.petitions) do
    if isUnsignedPetition(entry) then
      out[#out + 1] = copyPetition(entry)
    elseif present and present[id] == true then
      out[#out + 1] = copyPetition(entry)
    end
  end
  table.sort(out, function(a, b)
    local aId, bId = a.characterId, b.characterId
    local aKnown, bKnown = isId(aId), isId(bId)
    if aKnown and bKnown then return aId < bId end
    if aKnown then return true end
    if bKnown then return false end
    local aKey = a.senderKey or a.name or ""
    local bKey = b.senderKey or b.name or ""
    return aKey < bKey
  end)
  return out
end

function Gora:Recommend(fighterA, fighterB)
  self:_Expire()
  if not isId(fighterA) or not isId(fighterB) or fighterA == fighterB then
    return nil, "a Gora needs two different combatants"
  end
  local out = { namedOpponent = false }
  local pa = self.petitions[fighterA]
  local pb = self.petitions[fighterB]
  if pa and pa.namedOpponentId == fighterB then out.namedOpponent = true end
  if pb and pb.namedOpponentId == fighterA then out.namedOpponent = true end
  if COB.Store and COB.Store.GetCharacter then
    local ca = COB.Store:GetCharacter(fighterA)
    local cb = COB.Store:GetCharacter(fighterB)
    if ca then out.levelA = ca.level end
    if cb then out.levelB = cb.level end
    if ca and ca.gora and type(ca.gora.headToHeads) == "table" then
      for i = 1, #ca.gora.headToHeads do
        local row = ca.gora.headToHeads[i]
        if row.opponentId == fighterB then
          out.headToHead = deepcopy(row)
          break
        end
      end
    end
  end
  return out
end

function Gora:Sanction(fighterA, fighterB, stipulation)
  self:_Expire()
  local eventId = liveEventId()
  if not eventId then return nil, "no event" end
  if not isId(fighterA) or not isId(fighterB) or fighterA == fighterB then
    return nil, "a Gora needs two different combatants"
  end
  if not knownCharacter(fighterA) or not knownCharacter(fighterB) then
    return nil, "unknown character"
  end
  local line, lineErr = trimLine(stipulation)
  if lineErr then return nil, lineErr end
  if self.sanctioned and not samePair(self.sanctioned, fighterA, fighterB) then
    return nil, "a Gora is already sanctioned"
  end
  wipeLast()
  self.sanctioned = {
    fighterA = fighterA,
    fighterB = fighterB,
    stipulation = line,
    eventId = eventId,
  }
  wipeFavor()
  return copySanctioned(self.sanctioned)
end

function Gora:GetSanctioned()
  self:_Expire()
  return copySanctioned(self.sanctioned)
end

function Gora:GetLastSanctioned()
  self:_Expire()
  if not lastSanctioned then return nil end
  return {
    fighterA = lastSanctioned.fighterA,
    fighterB = lastSanctioned.fighterB,
  }
end

function Gora:Propose(proposal)
  self:_Expire()
  if proposal == nil then return nil, "proposal required" end
  if not self.sanctioned then return nil, "no sanctioned gora" end
  if type(proposal) == "table" then
    self.proposal = deepcopy(proposal)
    return deepcopy(self.proposal)
  end
  self.proposal = proposal
  return self.proposal
end

function Gora:GetProposal()
  self:_Expire()
  if self.proposal == nil then return nil end
  if type(self.proposal) == "table" then return deepcopy(self.proposal) end
  return self.proposal
end

-- A normal WoW duel ends at 1 hit point, not 0 / not percent == 0.
Gora.DUEL_FLOOR = 1

-- Winner *side* of the sanctioned pair: "A" or "B". Pure. No UnitHealth.
function Gora.GuessKnockout(curA, curB)
  if type(curA) ~= "number" or type(curB) ~= "number" then return nil end
  local a = math.floor(curA)
  local b = math.floor(curB)
  local floor = Gora.DUEL_FLOOR
  if a == floor and b > floor then return "B" end
  if b == floor and a > floor then return "A" end
  return nil
end

function Gora:ConsiderRaidHealth(curA, curB)
  self:_Expire()
  if not self.sanctioned then return nil, "no sanctioned gora" end
  local side = Gora.GuessKnockout(curA, curB)
  if not side then return nil, "no knockout" end
  local winnerId, loserId
  if side == "A" then
    winnerId, loserId = self.sanctioned.fighterA, self.sanctioned.fighterB
  else
    winnerId, loserId = self.sanctioned.fighterB, self.sanctioned.fighterA
  end
  local prev = self.proposal
  if type(prev) == "table"
      and prev.ruling == "victor"
      and prev.winnerId == winnerId
      and prev.source == "raid-health" then
    return nil, "already proposed"
  end
  return self:Propose({
    ruling = "victor",
    winnerId = winnerId,
    loserId = loserId,
    source = "raid-health",
  })
end

local function copyProposal(proposal)
  if type(proposal) ~= "table" then return nil end
  if proposal.ruling ~= "victor" or not isId(proposal.winnerId) then return nil end
  local out = {
    ruling = "victor",
    winnerId = proposal.winnerId,
    source = proposal.source,
  }
  if isId(proposal.loserId) then out.loserId = proposal.loserId end
  return out
end

local function writeBoth(idA, idB, ruling, wonA, wonB, text)
  if not COB.Store or not COB.Store.RecordGoraResult then
    return nil, "no store"
  end
  local fieldsA = { opponentId = idB, ruling = ruling }
  local fieldsB = { opponentId = idA, ruling = ruling }
  if ruling ~= "void" and ruling ~= "free" then
    fieldsA.won = wonA
    fieldsB.won = wonB
  end
  if text ~= nil then
    fieldsA.text = text
    fieldsB.text = text
  end
  local ra, ea = COB.Store:RecordGoraResult(idA, fieldsA)
  if not ra then return nil, ea end
  local rb, eb = COB.Store:RecordGoraResult(idB, fieldsB)
  if not rb then return nil, eb end
  return true
end

local function favorSplitFor(pair)
  local counts = { a = 0, b = 0 }
  if not pair then return counts end
  for _, pickId in pairs(favorPicks) do
    if pickId == pair.fighterA then
      counts.a = counts.a + 1
    elseif pickId == pair.fighterB then
      counts.b = counts.b + 1
    end
  end
  return counts
end

local function clearLive(self)
  local pair = self.sanctioned
  if pair then
    lastSanctioned = {
      fighterA = pair.fighterA,
      fighterB = pair.fighterB,
      eventId = pair.eventId,
    }
    lastFavorSplit = favorSplitFor(pair)
  end
  self.sanctioned = nil
  self.proposal = nil
end

function Gora:DeclareVictor(winnerId)
  self:_Expire()
  if not self.sanctioned then return nil, "no sanctioned gora" end
  local loserId = otherFighter(self.sanctioned, winnerId)
  if not loserId then return nil, "winner is not a fighter" end
  local ok, err = writeBoth(winnerId, loserId, "victor", true, false)
  if not ok then return nil, err end
  if COB.Store.AppendCeremony then
    COB.Store:AppendCeremony("victor", { winnerId, loserId }, resolveTime())
  end
  clearLive(self)
  return { ruling = "victor", winnerId = winnerId }
end

function Gora:CowardiceRecorded(fleerId)
  self:_Expire()
  if not self.sanctioned then return nil, "no sanctioned gora" end
  local otherId = otherFighter(self.sanctioned, fleerId)
  if not otherId then return nil, "fleer is not a fighter" end
  local ok, err = writeBoth(fleerId, otherId, "cowardice", false, true)
  if not ok then return nil, err end
  if COB.Store.AppendCeremony then
    COB.Store:AppendCeremony("cowardice", { fleerId, otherId }, resolveTime())
  end
  clearLive(self)
  return { ruling = "cowardice", fleerId = fleerId }
end

function Gora:Void()
  self:_Expire()
  if not self.sanctioned then return nil, "no sanctioned gora" end
  local a, b = self.sanctioned.fighterA, self.sanctioned.fighterB
  local ok, err = writeBoth(a, b, "void")
  if not ok then return nil, err end
  if COB.Store.AppendCeremony then
    COB.Store:AppendCeremony("void", { a, b }, resolveTime())
  end
  clearLive(self)
  return { ruling = "void" }
end

function Gora:FreeRuling(text)
  self:_Expire()
  if not self.sanctioned then return nil, "no sanctioned gora" end
  local line
  if text ~= nil then
    if type(text) ~= "string" then return nil, "ruling text must be a string" end
    line = trimLine(text)
  end
  local a, b = self.sanctioned.fighterA, self.sanctioned.fighterB
  local ok, err = writeBoth(a, b, "free", nil, nil, line)
  if not ok then return nil, err end
  if COB.Store.AppendCeremony then
    COB.Store:AppendCeremony("free", { a, b }, resolveTime(), line)
  end
  clearLive(self)
  return { ruling = "free", text = line }
end

function Gora:RecordFavor(characterId, pickId)
  self:_Expire()
  if not self.sanctioned then return nil, "no sanctioned gora" end
  if not isId(characterId) then return nil, "invalid character id" end
  if not isId(pickId) then return nil, "pick must be a character id" end
  if pickId ~= self.sanctioned.fighterA and pickId ~= self.sanctioned.fighterB then
    return nil, "pick must be a sanctioned fighter"
  end
  favorPicks[characterId] = pickId
  favorEventId = self.sanctioned.eventId
  return true
end

-- INPUT apply. Key by Names.Key(sender). Never write favorPicks[payloadId].
function Gora:RecordFavorFromSender(sender, pickId)
  self:_Expire()
  if not self.sanctioned then return nil, "no sanctioned gora" end
  local key = nameKey(sender)
  if not key then return nil, "invalid sender" end
  if not isId(pickId) then return nil, "pick must be a character id" end
  if pickId ~= self.sanctioned.fighterA and pickId ~= self.sanctioned.fighterB then
    return nil, "pick must be a sanctioned fighter"
  end
  favorPicks[key] = pickId
  favorEventId = self.sanctioned.eventId
  return true
end

function Gora:GetFavor()
  self:_Expire()
  local out = {}
  for memberId, pickId in pairs(favorPicks) do
    out[memberId] = pickId
  end
  return out
end

function Gora:GetFavorSplit()
  self:_Expire()
  return favorSplitFor(self.sanctioned)
end

function Gora:GetLastFavorSplit()
  self:_Expire()
  return { a = lastFavorSplit.a, b = lastFavorSplit.b }
end

-- Copy of the live desk. Does not call _Expire (no congregation Quiet wipe
-- as a Snapshot side effect). Missing eventId → {} (not a snapshot).
function Gora:Snapshot()
  local eventId = deskEventId(self)
  if not isId(eventId) then
    return {}
  end
  local petitions = {}
  for key, entry in pairs(self.petitions) do
    if type(entry) == "table" then
      petitions[key] = copyPetitionPersist(entry)
    end
  end
  local out = {
    eventId = eventId,
    petitions = petitions,
    favorPicks = copyMap(favorPicks),
  }
  if self.sanctioned then
    out.sanctioned = {
      fighterA = self.sanctioned.fighterA,
      fighterB = self.sanctioned.fighterB,
      stipulation = self.sanctioned.stipulation,
      eventId = self.sanctioned.eventId or eventId,
    }
  end
  local last = copyLastPair(lastSanctioned)
  if last then
    if not last.eventId then last.eventId = eventId end
    out.lastSanctioned = last
  end
  local proposal = copyProposal(self.proposal)
  if proposal then out.proposal = proposal end
  return out
end

-- Replace live desk from a snapshot. Empty {} / missing eventId is not a
-- snapshot and must not wipe memory. Caller Restores event first so the
-- next _Expire keeps the pair. Does not Save. Does not call _Expire.
function Gora:Restore(snap)
  if not isGoraSnapshot(snap) then
    return nil, "not a snapshot"
  end
  local eventId = snap.eventId
  self.petitions = {}
  if type(snap.petitions) == "table" then
    for key, entry in pairs(snap.petitions) do
      if type(entry) == "table" then
        local row = copyPetitionPersist(entry)
        if not isId(row.eventId) then row.eventId = eventId end
        self.petitions[key] = row
      end
    end
  end
  if type(snap.sanctioned) == "table" and isId(snap.sanctioned.fighterA)
      and isId(snap.sanctioned.fighterB) then
    self.sanctioned = {
      fighterA = snap.sanctioned.fighterA,
      fighterB = snap.sanctioned.fighterB,
      stipulation = snap.sanctioned.stipulation,
      eventId = isId(snap.sanctioned.eventId) and snap.sanctioned.eventId or eventId,
    }
  else
    self.sanctioned = nil
  end
  self.proposal = nil
  local proposal = copyProposal(snap.proposal)
  if proposal and self.sanctioned then
    if proposal.winnerId == self.sanctioned.fighterA
        or proposal.winnerId == self.sanctioned.fighterB then
      self.proposal = proposal
    end
  end
  wipeFavor()
  if type(snap.favorPicks) == "table" then
    favorPicks = copyMap(snap.favorPicks)
    favorEventId = eventId
  end
  local last = copyLastPair(snap.lastSanctioned)
  if last then
    last.eventId = isId(last.eventId) and last.eventId or eventId
    lastSanctioned = last
    lastFavorSplit = favorSplitFor(last)
  else
    wipeLast()
  end
  return true
end

-- Test-only, matching the rest of Core: never clear live state in game.
-- Must not call DB:Save (wraps never attach here).
function Gora:ResetForTests()
  if not COB._IN_TEST then return false end
  self.pending = {}
  self.petitions = {}
  self.sanctioned = nil
  self.proposal = nil
  wipeFavor()
  wipeLast()
  return true
end
