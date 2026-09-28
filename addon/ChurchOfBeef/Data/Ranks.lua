ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Bible §5 / Law 9. Six ranks, ids 1–6. No thresholds. No Beef Prophet.
-- The Pope is not a rank. Ranks are relationships, not a linear ladder —
-- `relationship` is the §5 heading word the player card paints under the
-- title. It is not a progression hint.
local LIST = {
  { id = 1, title = "Fresh Beef",   relationship = "Recruitment" },
  { id = 2, title = "Cooked Beef",  relationship = "Engagement" },
  { id = 3, title = "Beef Knight",  relationship = "Belonging" },
  { id = 4, title = "Beef Lord",    relationship = "Proven prestige" },
  -- Raid-team role designation; display-only this phase (Bible §5).
  { id = 5, title = "Beef Butcher", relationship = "The Raiding Team" },
  { id = 6, title = "Beef Council", relationship = "Trusted leadership" },
}

local BY_ID = {}
local BY_TITLE = {}
for _, r in ipairs(LIST) do
  BY_ID[r.id] = r
  BY_TITLE[string.lower(r.title)] = r.id
end

local function foldTitle(title)
  if type(title) ~= "string" then return nil end
  title = title:gsub("^%s+", ""):gsub("%s+$", "")
  if title == "" then return nil end
  return string.lower(title)
end

-- Guild rank index is public display only. Church store is truth (Bible §5).
-- No roster-index → Church-rank map. Do not treat GM as a Church rank.
-- Live guild rank *names* that exactly match a canon title may be shown
-- as display (IdForTitle). That is not a store write and not an index map.
local function churchRankIdForGuildIndex(_rankIndex)
  return nil
end

local function idForTitle(title)
  local key = foldTitle(title)
  if not key then return nil end
  return BY_TITLE[key]
end

COB.Ranks = {
  List = LIST,
  ById = BY_ID,
  Title = function(id)
    local r = BY_ID[id]
    return r and r.title or "Unknown"
  end,
  Relationship = function(id)
    local r = BY_ID[id]
    return r and r.relationship or nil
  end,
  IdForTitle = idForTitle,
  ChurchRankIdForGuildIndex = churchRankIdForGuildIndex,
}
