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

local function copyPetition(entry)
  local out = { characterId = entry.characterId }
  if entry.namedOpponentId ~= nil then
    out.namedOpponentId = entry.namedOpponentId
  end
  return out
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

function Gora:Dismiss(characterId)
  self:_Expire()
  if not isId(characterId) or not self.petitions[characterId] then return false end
  self.petitions[characterId] = nil
  return true
end

function Gora:GetPetitions(presentAndAlive)
  self:_Expire()
  local out = {}
  if type(presentAndAlive) ~= "table" then return out end
  for id, entry in pairs(self.petitions) do
    if presentAndAlive[id] == true then
      out[#out + 1] = copyPetition(entry)
    end
  end
  table.sort(out, function(a, b)
    return a.characterId < b.characterId
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
  self.sanctioned = {
    fighterA = fighterA,
    fighterB = fighterB,
    stipulation = line,
    eventId = eventId,
  }
  return copySanctioned(self.sanctioned)
end

function Gora:GetSanctioned()
  self:_Expire()
  return copySanctioned(self.sanctioned)
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

local function writeBoth(idA, idB, ruling, wonA, wonB)
  if not COB.Store or not COB.Store.RecordGoraResult then
    return nil, "no store"
  end
  local fieldsA = { opponentId = idB, ruling = ruling }
  local fieldsB = { opponentId = idA, ruling = ruling }
  if ruling ~= "void" then
    fieldsA.won = wonA
    fieldsB.won = wonB
  end
  local ra, ea = COB.Store:RecordGoraResult(idA, fieldsA)
  if not ra then return nil, ea end
  local rb, eb = COB.Store:RecordGoraResult(idB, fieldsB)
  if not rb then return nil, eb end
  return true
end

local function clearLive(self)
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
  clearLive(self)
  return { ruling = "cowardice", fleerId = fleerId }
end

function Gora:Void()
  self:_Expire()
  if not self.sanctioned then return nil, "no sanctioned gora" end
  local a, b = self.sanctioned.fighterA, self.sanctioned.fighterB
  local ok, err = writeBoth(a, b, "void")
  if not ok then return nil, err end
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
  local ok, err = writeBoth(a, b, "free", false, false)
  if not ok then return nil, err end
  clearLive(self)
  return { ruling = "free", text = line }
end

-- Test-only, matching the rest of Core: never clear live state in game.
function Gora:ResetForTests()
  if not COB._IN_TEST then return false end
  self.pending = {}
  self.petitions = {}
  self.sanctioned = nil
  self.proposal = nil
  return true
end
