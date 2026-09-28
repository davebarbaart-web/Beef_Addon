ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Records keeper (Bible §10.9 / §12.5). Pure Core: derives the nine
-- superlative pages and per-character record summaries from the Pope's
-- Store. Superlatives, never a ranked ladder — there is no position
-- or rating here and none may be added (§10.9 permanent rejection).
-- FighterStories lists characters who have a sanctioned result. Reading
-- order is wins, then current win run, then most recent result, then
-- name — not a rating and not a position among members. VictoryFront
-- is the first N of that list. ChroniclePreview is factual ceremony /
-- Pope scripture lines, never generated prose. Famous Upsets are Pope-flagged
-- rows, never computed. Defenses are derived (OPEN_QUESTIONS #9), never
-- stored. Getters return copies.
local Records = {}
COB.Records = Records

Records.TITLES = {
  "Most Sanctioned Victories",
  "Longest Streak",
  "Most Successful Defenses",
  "The Iron Chin",
  "Greatest Rivalry",
  "Famous Upsets",
  "The Undefeated",
  "The Glorious Martyr",
  "Tournament Champions",
}
local PAGE_TITLES = Records.TITLES

local function deepcopy(value)
  if type(value) ~= "table" then return value end
  local out = {}
  for k, v in pairs(value) do out[deepcopy(k)] = deepcopy(v) end
  return out
end

local function isId(v)
  return type(v) == "number" and v == math.floor(v) and v >= 1
end

local function count(n)
  if type(n) ~= "number" then return 0 end
  return n
end

local function emptyPages()
  local pages = {}
  for i = 1, #PAGE_TITLES do
    pages[i] = { title = PAGE_TITLES[i], entries = {} }
  end
  return pages
end

local function longestWinStreak(gora)
  local current, longest = 0, 0
  local results = gora and gora.results
  if type(results) ~= "table" then return 0 end
  for i = 1, #results do
    local won = results[i].won
    if won == true then
      current = current + 1
      if current > longest then longest = current end
    elseif won == false then
      current = 0
    end
  end
  return longest
end

local function foughtCount(gora)
  local results = gora and gora.results
  if type(results) ~= "table" then return 0 end
  return #results
end

local function charName(characters, id)
  local row = characters[id]
  return row and row.name or nil
end

local function indexCharacters(list)
  local byId = {}
  if type(list) ~= "table" then return byId end
  for i = 1, #list do
    local row = list[i]
    if type(row) == "table" and type(row.id) == "number" then
      byId[row.id] = row
    end
  end
  return byId
end

-- OPEN_QUESTIONS #9: sitting-Lord victories after elevationAt. Prefer Store.
-- Same walk if the method is missing. Never a stored increment.
local function deriveDefenses(gora, elevationAt)
  if type(elevationAt) ~= "number" then return 0 end
  local results = gora and gora.results
  if type(results) ~= "table" then return 0 end
  local n = 0
  for i = 1, #results do
    local result = results[i]
    if result and result.won == true then
      local at = result.at
      if type(at) == "number" and at >= elevationAt then
        n = n + 1
      end
    end
  end
  return n
end

local function countDefenses(characterId, gora, humanId)
  if COB.Store and type(COB.Store.CountDefenses) == "function" then
    local n = COB.Store:CountDefenses(characterId)
    if type(n) == "number" then return n end
    return 0
  end
  if type(humanId) ~= "number" then return 0 end
  local human = COB.Store and COB.Store.GetHuman and COB.Store:GetHuman(humanId)
  local elevationAt = human and human.elevationAt
  return deriveDefenses(gora, elevationAt)
end

local function maxHolders(rows, key)
  local best = nil
  for i = 1, #rows do
    local v = rows[i][key]
    if type(v) == "number" and (best == nil or v > best) then
      best = v
    end
  end
  if best == nil or best < 1 then return {} end
  local holders = {}
  for i = 1, #rows do
    if rows[i][key] == best then
      holders[#holders + 1] = rows[i]
    end
  end
  return holders
end

local function pairKey(a, b)
  if a < b then return a, b else return b, a end
end

-- All nine §10.9 categories with their computed entries (possibly empty).
-- buildPages keeps only the held ones.
local function buildSuperlatives()
  local pages = emptyPages()
  if not (COB.Store and COB.Store.Snapshot) then return pages end
  local snap = COB.Store:Snapshot()
  local list = snap and snap.characters
  if type(list) ~= "table" then return pages end

  local byId = indexCharacters(list)
  local measured = {}
  for i = 1, #list do
    local ch = list[i]
    local gora = ch.gora
    if type(ch) == "table" and type(gora) == "table" then
      local wins = gora.wins
      local losses = gora.losses
      if type(wins) ~= "number" then wins = 0 end
      if type(losses) ~= "number" then losses = 0 end
      measured[#measured + 1] = {
        characterId = ch.id,
        name = ch.name,
        humanId = ch.humanId,
        wins = wins,
        losses = losses,
        streak = longestWinStreak(gora),
        fought = foughtCount(gora),
        gora = gora,
      }
    end
  end

  local function put(title, entries)
    for i = 1, #pages do
      if pages[i].title == title then
        pages[i].entries = entries
        return
      end
    end
  end

  local victoryRows = {}
  for i = 1, #measured do
    victoryRows[i] = {
      characterId = measured[i].characterId,
      name = measured[i].name,
      wins = measured[i].wins,
    }
  end
  put("Most Sanctioned Victories", maxHolders(victoryRows, "wins"))

  local streakRows = {}
  for i = 1, #measured do
    streakRows[i] = {
      characterId = measured[i].characterId,
      name = measured[i].name,
      streak = measured[i].streak,
    }
  end
  put("Longest Streak", maxHolders(streakRows, "streak"))

  local defenseRows = {}
  for i = 1, #measured do
    defenseRows[i] = {
      characterId = measured[i].characterId,
      name = measured[i].name,
      defenses = countDefenses(measured[i].characterId, measured[i].gora, measured[i].humanId),
    }
  end
  put("Most Successful Defenses", maxHolders(defenseRows, "defenses"))

  local chinRows = {}
  for i = 1, #measured do
    chinRows[i] = {
      characterId = measured[i].characterId,
      name = measured[i].name,
      fought = measured[i].fought,
    }
  end
  put("The Iron Chin", maxHolders(chinRows, "fought"))

  local pairMap = {}
  local pairList = {}
  for i = 1, #measured do
    local ch = measured[i]
    local heads = ch.gora.headToHeads
    if type(heads) == "table" then
      for h = 1, #heads do
        local row = heads[h]
        local oppId = row and row.opponentId
        if type(oppId) == "number" and oppId ~= ch.characterId then
          local lo, hi = pairKey(ch.characterId, oppId)
          local key = tostring(lo) .. ":" .. tostring(hi)
          local pairing = pairMap[key]
          if not pairing then
            pairing = { lo = lo, hi = hi, fights = 0, scoreLo = 0, scoreHi = 0 }
            pairMap[key] = pairing
            pairList[#pairList + 1] = pairing
          end
          local fights = row.fights
          if type(fights) ~= "number" then fights = 0 end
          if fights > pairing.fights then pairing.fights = fights end
          local wins = row.wins
          local losses = row.losses
          if type(wins) ~= "number" then wins = 0 end
          if type(losses) ~= "number" then losses = 0 end
          if ch.characterId == lo then
            pairing.scoreLo = wins
            pairing.scoreHi = losses
          else
            pairing.scoreHi = wins
            pairing.scoreLo = losses
          end
        end
      end
    end
  end
  local bestFights = nil
  for i = 1, #pairList do
    local n = pairList[i].fights
    if type(n) == "number" and (bestFights == nil or n > bestFights) then
      bestFights = n
    end
  end
  local rivalries = {}
  if type(bestFights) == "number" and bestFights >= 1 then
    for i = 1, #pairList do
      local pairing = pairList[i]
      if pairing.fights == bestFights then
        rivalries[#rivalries + 1] = {
          characterIdA = pairing.lo,
          characterIdB = pairing.hi,
          nameA = charName(byId, pairing.lo),
          nameB = charName(byId, pairing.hi),
          fights = pairing.fights,
          scoreA = pairing.scoreLo,
          scoreB = pairing.scoreHi,
        }
      end
    end
  end
  put("Greatest Rivalry", rivalries)

  local seenUpset = {}
  local upsets = {}
  for i = 1, #measured do
    local ch = measured[i]
    local results = ch.gora.results
    if type(results) == "table" then
      for r = 1, #results do
        local result = results[r]
        if result and result.famousUpset == true and type(result.opponentId) == "number" then
          local lo, hi = pairKey(ch.characterId, result.opponentId)
          local at = result.at
          if type(at) ~= "number" then at = 0 end
          local key = tostring(at) .. ":" .. tostring(lo) .. ":" .. tostring(hi)
          if not seenUpset[key] then
            seenUpset[key] = true
            local winnerId, loserId = ch.characterId, result.opponentId
            if result.won == false then
              winnerId, loserId = result.opponentId, ch.characterId
            end
            upsets[#upsets + 1] = {
              characterId = winnerId,
              opponentId = loserId,
              name = charName(byId, winnerId),
              opponentName = charName(byId, loserId),
              at = result.at,
            }
          end
        end
      end
    end
  end
  put("Famous Upsets", upsets)

  local unbeaten = {}
  for i = 1, #measured do
    local row = measured[i]
    if row.wins >= 1 and row.losses == 0 then
      unbeaten[#unbeaten + 1] = {
        characterId = row.characterId,
        name = row.name,
        wins = row.wins,
      }
    end
  end
  put("The Undefeated", unbeaten)

  local martyrRows = {}
  for i = 1, #measured do
    martyrRows[i] = {
      characterId = measured[i].characterId,
      name = measured[i].name,
      losses = measured[i].losses,
    }
  end
  put("The Glorious Martyr", maxHolders(martyrRows, "losses"))

  -- Tournament Champions: empty until tournaments exist. Do not invent an engine.
  put("Tournament Champions", {})

  return pages
end

function Records:Pages()
  return deepcopy(buildSuperlatives())
end

function Records:Summary(characterId)
  if not isId(characterId) then return nil, "invalid character id" end
  local Store = COB.Store
  if not (Store and type(Store.GetCharacter) == "function") then
    return nil, "store is not available"
  end
  local ch = Store:GetCharacter(characterId)
  if type(ch) ~= "table" then return nil, "unknown character" end
  local gora = type(ch.gora) == "table" and ch.gora or {}

  local rivalries = {}
  local heads = gora.headToHeads
  if type(heads) == "table" then
    for i = 1, #heads do
      local row = heads[i]
      if type(row) == "table" and isId(row.opponentId) then
        local opp = Store:GetCharacter(row.opponentId)
        rivalries[#rivalries + 1] = {
          opponentId = row.opponentId,
          opponentName = type(opp) == "table" and opp.name or nil,
          wins = count(row.wins),
          losses = count(row.losses),
          fights = count(row.fights),
        }
      end
    end
  end
  table.sort(rivalries, function(x, y)
    if x.fights ~= y.fights then return x.fights > y.fights end
    return tostring(x.opponentName) < tostring(y.opponentName)
  end)

  return {
    characterId = ch.id,
    name = ch.name,
    humanId = ch.humanId,
    wins = count(gora.wins),
    losses = count(gora.losses),
    fought = foughtCount(gora),
    longestStreak = longestWinStreak(gora),
    defenses = countDefenses(ch.id, gora, ch.humanId),
    rivalries = rivalries,
  }
end

function Records:HeldBy(characterId)
  local held = {}
  if not isId(characterId) then return held end
  local pages = buildSuperlatives()
  for i = 1, #pages do
    local entries = pages[i].entries
    for e = 1, #entries do
      local row = entries[e]
      if row.characterId == characterId
        or row.characterIdA == characterId
        or row.characterIdB == characterId then
        held[#held + 1] = pages[i].title
        break
      end
    end
  end
  return held
end

local function lastCountedResult(gora)
  local results = gora and gora.results
  if type(results) ~= "table" or #results == 0 then return nil end
  local best = nil
  for i = 1, #results do
    local row = results[i]
    if type(row) == "table" then
      if best == nil then
        best = row
      elseif type(row.at) == "number" and (type(best.at) ~= "number" or row.at >= best.at) then
        best = row
      end
    end
  end
  return best
end

local function currentWinRun(gora)
  local signed = gora and gora.streak
  if type(signed) == "number" and signed > 0 then return signed end
  return 0
end

-- Characters who have at least one sanctioned result.
-- Reading order (Most Sanctioned Victories, then current win run, then
-- most recent result, then name). Not a rating and not a position.
local function storyLess(a, b)
  if a.wins ~= b.wins then return a.wins > b.wins end
  if a.currentStreak ~= b.currentStreak then return a.currentStreak > b.currentStreak end
  local atA = a.last and a.last.at
  local atB = b.last and b.last.at
  local aNum = type(atA) == "number"
  local bNum = type(atB) == "number"
  if aNum and bNum and atA ~= atB then return atA > atB end
  if aNum ~= bNum then return aNum end
  return tostring(a.name) < tostring(b.name)
end

function Records:FighterStories()
  local out = {}
  if not (COB.Store and COB.Store.Snapshot) then return out end
  local snap = COB.Store:Snapshot()
  local list = snap and snap.characters
  if type(list) ~= "table" then return out end
  local byId = indexCharacters(list)
  for i = 1, #list do
    local ch = list[i]
    local gora = type(ch) == "table" and ch.gora or nil
    if type(gora) == "table" and foughtCount(gora) >= 1 then
      local last = lastCountedResult(gora)
      local lastCopy = nil
      if last then
        local opp = last.opponentId and byId[last.opponentId] or nil
        lastCopy = {
          at = last.at,
          ruling = last.ruling,
          won = last.won,
          opponentId = last.opponentId,
          opponentName = opp and opp.name or nil,
        }
      end
      out[#out + 1] = {
        characterId = ch.id,
        name = ch.name,
        wins = count(gora.wins),
        losses = count(gora.losses),
        fought = foughtCount(gora),
        currentStreak = currentWinRun(gora),
        longestStreak = longestWinStreak(gora),
        last = lastCopy,
      }
    end
  end
  table.sort(out, storyLess)
  return deepcopy(out)
end

-- First `limit` rows of FighterStories. Default 3. Isolated so the card
-- and the ledger share one order without the UI sorting.
function Records:VictoryFront(limit)
  if type(limit) ~= "number" or limit < 1 then limit = 3 end
  limit = math.floor(limit)
  local stories = self:FighterStories()
  local out = {}
  for i = 1, math.min(limit, #stories) do
    out[i] = stories[i]
  end
  return deepcopy(out)
end

local function storeHumanName(id)
  if not isId(id) then return nil end
  if not (COB.Store and type(COB.Store.GetHuman) == "function") then return nil end
  local row = COB.Store:GetHuman(id)
  return row and row.name or nil
end

local function storeCharacterName(id)
  if not isId(id) then return nil end
  if not (COB.Store and type(COB.Store.GetCharacter) == "function") then return nil end
  local row = COB.Store:GetCharacter(id)
  return row and row.name or nil
end

-- Clerical rubric + record line. The software supplies the seal, never
-- the scripture (Bible §16). Canonized moments keep the Pope's words.
local function ceremonyPreview(entry)
  if type(entry) ~= "table" then return nil end
  local kind = type(entry.type) == "string" and entry.type or ""
  local ids = type(entry.participantIds) == "table" and entry.participantIds or {}
  local headline, body
  if kind == "Knighting" then
    headline = "A KNIGHTING"
    local name = storeHumanName(ids[1])
    body = name and (name .. " was Knighted.") or "A Knighting was held."
  elseif kind == "Elevation" then
    headline = "AN ELEVATION"
    local name = storeHumanName(ids[1])
    body = name and (name .. " rose to Beef Lord.") or "An elevation was held."
  elseif kind == "victor" then
    headline = "A VICTOR DECLARED"
    local winner = storeCharacterName(ids[1])
    local loser = storeCharacterName(ids[2])
    if winner and loser then
      body = winner .. " declared victor over " .. loser .. "."
    elseif winner then
      body = winner .. " declared victor."
    else
      body = "A victor was declared."
    end
  elseif kind == "cowardice" then
    headline = "COWARDICE RECORDED"
    local name = storeCharacterName(ids[1])
    body = name and ("Cowardice recorded: " .. name .. ".") or "Cowardice recorded."
  elseif kind == "void" then
    headline = "A BOUT VOIDED"
    local first = storeCharacterName(ids[1])
    local second = storeCharacterName(ids[2])
    if first and second then
      body = "A bout was voided: " .. first .. ", " .. second .. "."
    elseif first then
      body = "A bout was voided: " .. first .. "."
    else
      body = "A bout was voided."
    end
  elseif kind == "free" then
    headline = "A FREE RULING"
    local text = type(entry.text) == "string" and entry.text or nil
    body = (text and text ~= "") and ("Free ruling: " .. text) or "Free ruling."
  else
    if kind == "" then return nil end
    headline = string.upper(kind)
    body = kind .. "."
  end
  return {
    kind = kind,
    headline = headline,
    body = body,
    at = entry.at,
  }
end

function Records:ChroniclePreview(limit)
  if type(limit) ~= "number" or limit < 1 then limit = 2 end
  limit = math.floor(limit)
  local rows = {}
  local Store = COB.Store
  if Store and type(Store.GetMarkedMoments) == "function" then
    local marks = Store:GetMarkedMoments()
    if type(marks) == "table" then
      for i = 1, #marks do
        local mark = marks[i]
        if type(mark) == "table" and type(mark.scripture) == "string" and mark.scripture ~= "" then
          rows[#rows + 1] = {
            kind = "canonized",
            headline = "CANONIZED",
            body = mark.scripture,
            at = mark.at,
          }
        end
      end
    end
  end
  if Store and type(Store.GetCeremonyLog) == "function" then
    local log = Store:GetCeremonyLog()
    if type(log) == "table" then
      for i = 1, #log do
        local preview = ceremonyPreview(log[i])
        if preview then rows[#rows + 1] = preview end
      end
    end
  end
  table.sort(rows, function(a, b)
    local atA, atB = a.at, b.at
    local aNum = type(atA) == "number"
    local bNum = type(atB) == "number"
    if aNum and bNum and atA ~= atB then return atA > atB end
    if aNum ~= bNum then return aNum end
    return tostring(a.headline) < tostring(b.headline)
  end)
  local out = {}
  for i = 1, math.min(limit, #rows) do
    out[i] = rows[i]
  end
  return deepcopy(out)
end
