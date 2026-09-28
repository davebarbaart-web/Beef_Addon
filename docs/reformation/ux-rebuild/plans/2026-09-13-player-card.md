# Player Card Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the `/beef` main window with a compact **player card** — Church rank (with its Bible §5 relationship line), sanctioned Gora record, rivalries, distinctions held, and the next Gathering — and give the Records Book behind it a navigation that reads like a book instead of a tab bar.

**Architecture:** A new pure Core keeper `Core/Records.lua` owns the §10.9 superlative math (moved out of the UI) and adds per-character `Summary` / `HeldBy` reads, so both the card and the book share one computation that the desktop harness can test without widgets. A new theatrical surface `UI/PlayerCard.lua` (320×520, fixed size, movable) becomes the `/beef` destination; `UI/RecordsBook.lua` loses its Home spread and identity leaf, opens on the Chronicle, and gets a leaf-caption footer with edge-aware Previous/Next. `Data/Ranks.lua` gains the Bible §5 relationship line per rank so the card never hardcodes rank copy.

**Tech Stack:** Lua 5.1, plain global `ChurchOfBeef` / `COB`, TBC Classic Anniversary (`## Interface: 20506`), desktop harness `lua tests/run.lua` with `tests/wow_ui_stub.lua` (strict 2.5.x widget model).

**Plan location note:** saved under `docs/reformation/ux-rebuild/plans/` beside this wave's briefs. `docs/superpowers/specs/*` is retired pre-reformation law (`architecture-overview.mdc`); live plans do not go there.

## Global Constraints

- **Product law:** `docs/design/Game_Design_Bible_v1.1.1.md` wins. Law 1 (no points), Law 6 (Quiet Mode), Law 9 (six ranks, no thresholds), Law 10 (hybrid visual law). Bible §10.9: "A sorted '#1 rating' ladder is permanently rejected." The card shows **no position among members**. "How I compare" is Church rank + distinctions held + head-to-heads. Ranks are relationships, not a linear ladder (`records-not-points.mdc`) — no rank progression strip, no "next rank" copy.
- **Banned words in shipped source and copy** (`records-not-points.mdc` regression tells): `standing`, `Grant`, `threshold`, `suggestion`, `elo`, `leaderboard`, `prophet`. Also never `#1`, `rating`, `ranked`.
- **Mode:** the card and the book are `MODE = "QUIET"` player-opened identity/history (§14.2). No unbidden show, no sound, no toast, no pip.
- **Ink discipline (`ui-juice-standards.mdc`):** on parchment only `charcoal`, `iron`, or `oxblood` text; `gold`, `parchment`, and class color text only on `charcoal` plates; gold on parchment is ornament (rules, seals), never text. Class color on **names** only.
- **Dress:** every color, font, texture through `COB.Theme` (`Theme:Color`, `Theme:FontPath`, `Theme:Texture`, `Theme.Space`, `Theme.FontSize`). No `Interface\\` paths, no RGB literals, no font paths in surface files. Missing media must not fail load.
- **Copy:** clerical, human. The UI never narrates or jokes (Law 4, §19.3). Exact strings are in Task 3 `COPY`.
- **Lua 5.1:** multi-return errors (`nil, "reason"`), never `error()` for expected failures; getters return deep copies; Core never `CreateFrame`, never reads WoW APIs; UI may read `UnitName`/`UnitClass`/`UnitLevel`/`GetGuildInfo` behind `type()` + `pcall` guards (the harness stub lacks `UnitClass`/`UnitLevel`).
- **Layers:** UI→Core→Data. `UI/PlayerCard.lua` reads `COB.Store`, `COB.Records`, `COB.Ranks`, `COB.Decree`, `COB.Names`, `COB.Common`, `COB.Theme`; it calls `COB.RecordsBook:Show()` only from its one button.
- **TOC:** lists only existing files; `Data → Core → Net/UI → ChurchOfBeef.lua`; Interface stays `20506`.
- **Persist:** `ChurchOfBeefDB.ui.playerCard = { point = { point, relativePoint, x, y } }` only. Never touch `WTF/`.
- **Tests:** TDD per task — write the failing assertions, run, watch them fail, implement, run green. `lua tests/run.lua` exits 0 at the end of every task. Every `tests/test_*.lua` on disk must be listed in `tests/run.lua` (the runner enforces both directions).
- **Commits:** this workspace does not commit unless David asks. Where a step says "Commit", **instead** append one line to `.superpowers/sdd/progress.md` (`Task N: complete (harness M/0)`) unless David has authorized commits for this wave — then commit with the message shown.
- **Claims:** harness green is **POLISH:CANDIDATE** at most. In-game `/reload` smoke and David's screenshot pass are separate and human.

---

### Task 1: Rank relationship lines (Data)

**Files:**
- Modify: `addon/ChurchOfBeef/Data/Ranks.lua`
- Test: `tests/test_ranks.lua`

**Interfaces:**
- Produces: `COB.Ranks.List[i].relationship` (string) and `COB.Ranks.Relationship(id) → string | nil`. Exact Bible §5 heading words (also the README rank table): `"Recruitment"`, `"Engagement"`, `"Belonging"`, `"Proven prestige"`, `"The Raiding Team"`, `"Trusted leadership"`.

- [ ] **Step 1: Write the failing test**

Append to the end of `tests/test_ranks.lua`:

```lua
-- Bible §5: each rank is a kind of relationship with the Church, not a rung.
-- The player card paints this line under the rank; it never invents rank copy.
local RELATIONSHIPS = {
  "Recruitment",
  "Engagement",
  "Belonging",
  "Proven prestige",
  "The Raiding Team",
  "Trusted leadership",
}

assert_eq(type(R.Relationship), "function", "Relationship(id) exists")
for i, line in ipairs(RELATIONSHIPS) do
  assert_eq(R.List[i].relationship, line, "rank " .. i .. " relationship (Bible §5)")
  assert_eq(R.Relationship(i), line, "Relationship(" .. i .. ")")
end
assert_eq(R.Relationship(7), nil, "Relationship of a non-rank is nil")
assert_eq(R.Relationship(nil), nil, "Relationship(nil) is nil")
assert_eq(R.NextRank, nil, "no next-rank helper — ranks are not a ladder")
assert_eq(R.Progress, nil, "no progress helper")
```

- [ ] **Step 2: Run the harness to verify it fails**

Run: `lua tests/run.lua`
Expected: `FAIL: Relationship(id) exists expected function got nil` and six `rank N relationship` FAIL lines; `Tests finished: … 15 failed` (approximately), exit 1.

- [ ] **Step 3: Implement**

Replace the `LIST` table and the `COB.Ranks` export in `addon/ChurchOfBeef/Data/Ranks.lua`:

```lua
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
```

```lua
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
  ChurchRankIdForGuildIndex = churchRankIdForGuildIndex,
}
```

- [ ] **Step 4: Run the harness to verify it passes**

Run: `lua tests/run.lua`
Expected: `Tests finished: N passed, 0 failed`, exit 0 (N ≈ 15658).

- [ ] **Step 5: Commit (or ledger)**

```bash
git add addon/ChurchOfBeef/Data/Ranks.lua tests/test_ranks.lua
git commit -m "feat(ranks): Bible §5 relationship line per rank"
```

---

### Task 2: `Core/Records.lua` — superlatives, summary, held-by (pure Core)

**Files:**
- Create: `addon/ChurchOfBeef/Core/Records.lua`
- Create: `tests/test_records_core.lua`
- Modify: `addon/ChurchOfBeef/UI/RecordsBook.lua` (delegate `buildSuperlatives`; delete moved helpers)
- Modify: `addon/ChurchOfBeef/ChurchOfBeef.toc` (add `Core\Records.lua` after `Core\Store.lua`)
- Modify: `tests/run.lua` (add `test_records_core` after `test_store`)
- Modify: `tests/test_records.lua` (dofile `Core/Records.lua`; source pin that the book holds no superlative math)
- Modify: `tests/preview_dump.lua` (dofile `Core/Records.lua` after `Core/Store.lua`)

**Interfaces:**
- Produces:
  - `COB.Records.TITLES` — the nine §10.9 titles in canonical order.
  - `COB.Records:Pages() → { { title, entries = {...} } × 9 }` (deep copy; entries may be empty). Entry shapes are exactly those `UI/RecordsBook.lua` builds today (`characterId, name, wins | streak | defenses | fought | losses`; rivalry rows `characterIdA, characterIdB, nameA, nameB, fights, scoreA, scoreB`; upset rows `characterId, opponentId, name, opponentName, at`).
  - `COB.Records:Summary(characterId) → { characterId, name, humanId, wins, losses, fought, longestStreak, defenses, rivalries = { { opponentId, opponentName, wins, losses, fights } … } } | nil, err`. Rivalries sorted by `fights` desc, then `opponentName` asc.
  - `COB.Records:HeldBy(characterId) → { title, … }` in canonical order (a character "holds" a page when any entry's `characterId`, `characterIdA`, or `characterIdB` is that id).
- Consumes: `COB.Store:Snapshot()`, `COB.Store:GetCharacter(id)`, `COB.Store:CountDefenses(id)`, `COB.Store:GetHuman(id)`.

- [ ] **Step 1: Write the failing suite**

Create `tests/test_records_core.lua`:

```lua
-- Core/Records.lua — pure §10.9 superlative math plus per-character reads.
-- Isolated: Common + Ranks + Store + Records. No widgets, no UI.
ChurchOfBeef = ChurchOfBeef or {}
ChurchOfBeef._IN_TEST = true

local standalone = (type(assert_eq) ~= "function")
local passed, failed = 0, 0
if standalone then
  function assert_eq(a, b, msg)
    if a ~= b then
      failed = failed + 1
      print("FAIL: " .. (msg or "") .. " expected " .. tostring(b) .. " got " .. tostring(a))
    else
      passed = passed + 1
    end
  end
  function assert_true(v, msg) assert_eq(not not v, true, msg) end
end

dofile("addon/ChurchOfBeef/Core/Common.lua")
dofile("addon/ChurchOfBeef/Data/Ranks.lua")
dofile("addon/ChurchOfBeef/Core/Store.lua")
dofile("addon/ChurchOfBeef/Core/Records.lua")

local COB = ChurchOfBeef
local Store = COB.Store
local Records = COB.Records

local TITLES = {
  "Most Sanctioned Victories", "Longest Streak", "Most Successful Defenses",
  "The Iron Chin", "Greatest Rivalry", "Famous Upsets", "The Undefeated",
  "The Glorious Martyr", "Tournament Champions",
}

local function reset()
  assert_eq(Store:ResetForTests(), true, "Store resets under _IN_TEST")
end

local function pageNamed(title)
  local pages = Records:Pages()
  for i = 1, #pages do
    if pages[i].title == title then return pages[i] end
  end
  return nil
end

local function bout(a, b, winner, now)
  Store:RecordGoraResult(a.id, { opponentId = b.id, ruling = "victor", won = (winner == a) }, now)
  Store:RecordGoraResult(b.id, { opponentId = a.id, ruling = "victor", won = (winner == b) }, now)
end

--------------------------------------------------------------------------------
-- Module contract
--------------------------------------------------------------------------------
assert_true(Records ~= nil, "COB.Records exists")
assert_eq(type(Records.Pages), "function", "Pages()")
assert_eq(type(Records.Summary), "function", "Summary(characterId)")
assert_eq(type(Records.HeldBy), "function", "HeldBy(characterId)")
assert_eq(#Records.TITLES, 9, "nine canonical titles")
for i = 1, 9 do
  assert_eq(Records.TITLES[i], TITLES[i], "title " .. i .. " canonical order")
end
assert_eq(Records.Ladder, nil, "no ladder")
assert_eq(Records.Position, nil, "no position among members")
assert_eq(Records.Rank, nil, "no numeric rank")
assert_eq(Records.SortByWins, nil, "no sortable ladder")
assert_eq(Records.Rating, nil, "no rating")
assert_eq(Records.ComputeFamousUpsets, nil, "Famous Upsets are Pope-flagged, never computed")

local src = io.open("addon/ChurchOfBeef/Core/Records.lua", "r")
assert_true(src ~= nil, "Records.lua is readable")
local body = src:read("*a")
src:close()
assert_eq(body:find("CreateFrame", 1, true), nil, "Core never CreateFrame")
assert_eq(body:find("UnitName", 1, true), nil, "Core never reads WoW units")
assert_eq(body:find("SendAddonMessage", 1, true), nil, "Core never sends")
assert_eq(body:lower():find("standing", 1, true), nil, "no standing")
assert_eq(body:lower():find("leaderboard", 1, true), nil, "no leaderboard")

--------------------------------------------------------------------------------
-- Empty store: nine pages, every one empty; Summary refuses; HeldBy empty
--------------------------------------------------------------------------------
reset()
local pages = Records:Pages()
assert_eq(#pages, 9, "nine pages on an empty store")
for i = 1, 9 do
  assert_eq(pages[i].title, TITLES[i], "empty page " .. i .. " keeps its title")
  assert_eq(#pages[i].entries, 0, "empty page " .. i .. " has no entries")
end
local none, err = Records:Summary(1)
assert_eq(none, nil, "Summary of an unknown character is nil")
assert_eq(err, "unknown character", "Summary names the refusal")
local bad, badErr = Records:Summary("x")
assert_eq(bad, nil, "Summary of a non-id is nil")
assert_eq(badErr, "invalid character id", "Summary refuses non-ids")
assert_eq(#Records:HeldBy(1), 0, "HeldBy of an unknown character is empty")

--------------------------------------------------------------------------------
-- Two fighters, A beats B twice
--------------------------------------------------------------------------------
reset()
local a = Store:CreateCharacter({ name = "Chuckroast", class = "Warrior" })
local b = Store:CreateCharacter({ name = "Tendermage", class = "Mage" })
bout(a, b, a, 100)
bout(a, b, a, 200)

local victories = pageNamed("Most Sanctioned Victories")
assert_eq(#victories.entries, 1, "one victory holder")
assert_eq(victories.entries[1].characterId, a.id, "A holds Most Sanctioned Victories")
assert_eq(victories.entries[1].wins, 2, "with two wins")
assert_eq(pageNamed("Longest Streak").entries[1].streak, 2, "A holds Longest Streak at II")
assert_eq(#pageNamed("Most Successful Defenses").entries, 0, "no Lord, no defenses")
assert_eq(#pageNamed("The Iron Chin").entries, 2, "both fought twice — both hold The Iron Chin")
local rivalry = pageNamed("Greatest Rivalry").entries[1]
assert_eq(rivalry.fights, 2, "the pair fought twice")
assert_eq(rivalry.nameA, "Chuckroast", "rivalry names the lower id first")
assert_eq(rivalry.scoreA, 2, "A's side of the running score")
assert_eq(rivalry.scoreB, 0, "B's side of the running score")
assert_eq(#pageNamed("Famous Upsets").entries, 0, "no flagged upsets")
assert_eq(pageNamed("The Undefeated").entries[1].characterId, a.id, "A is undefeated")
assert_eq(pageNamed("The Glorious Martyr").entries[1].characterId, b.id, "B is the martyr")
assert_eq(#pageNamed("Tournament Champions").entries, 0, "no tournament engine")

local summary = Records:Summary(a.id)
assert_eq(summary.name, "Chuckroast", "Summary names the character")
assert_eq(summary.wins, 2, "Summary wins")
assert_eq(summary.losses, 0, "Summary losses")
assert_eq(summary.fought, 2, "Summary fought")
assert_eq(summary.longestStreak, 2, "Summary longest streak")
assert_eq(summary.defenses, 0, "Summary defenses without a Lord")
assert_eq(#summary.rivalries, 1, "one rival")
assert_eq(summary.rivalries[1].opponentId, b.id, "rival id")
assert_eq(summary.rivalries[1].opponentName, "Tendermage", "rival name")
assert_eq(summary.rivalries[1].wins, 2, "rival wins")
assert_eq(summary.rivalries[1].losses, 0, "rival losses")
assert_eq(summary.rivalries[1].fights, 2, "rival fights")

local heldA = Records:HeldBy(a.id)
assert_eq(table.concat(heldA, "|"),
  "Most Sanctioned Victories|Longest Streak|The Iron Chin|Greatest Rivalry|The Undefeated",
  "A's distinctions in canonical order")
local heldB = Records:HeldBy(b.id)
assert_eq(table.concat(heldB, "|"), "The Iron Chin|Greatest Rivalry|The Glorious Martyr",
  "B's distinctions in canonical order")

--------------------------------------------------------------------------------
-- Rivalries sort by fights desc then name; only the top matter to the card
--------------------------------------------------------------------------------
local c = Store:CreateCharacter({ name = "Brisketh", class = "Rogue" })
bout(a, c, c, 300)
local again = Records:Summary(a.id)
assert_eq(#again.rivalries, 2, "two rivals")
assert_eq(again.rivalries[1].opponentName, "Tendermage", "most-fought rival first")
assert_eq(again.rivalries[2].opponentName, "Brisketh", "then the newer rival")
assert_eq(again.losses, 1, "the loss counts")
assert_eq(again.longestStreak, 2, "longest streak survives the loss")

--------------------------------------------------------------------------------
-- Defenses: a sitting Lord's wins after elevation (OPEN_QUESTIONS #9)
--------------------------------------------------------------------------------
reset()
a = Store:CreateCharacter({ name = "Chuckroast", class = "Warrior" })
b = Store:CreateCharacter({ name = "Tendermage", class = "Mage" })
local human = Store:CreateHuman({ name = "Chuck" })
Store:LinkCharacter(a.id, human.id, 50)
Store:SetRank(human.id, 4, 100)
bout(a, b, a, 90)   -- before elevation: not a defense
bout(a, b, a, 150)  -- after: a defense
local lord = Records:Summary(a.id)
assert_eq(lord.defenses, 1, "one defense after elevation")
assert_eq(lord.humanId, human.id, "Summary carries the human id")
local defenses = pageNamed("Most Successful Defenses")
assert_eq(defenses.entries[1].characterId, a.id, "A holds Most Successful Defenses")
assert_eq(defenses.entries[1].defenses, 1, "with one defense")

--------------------------------------------------------------------------------
-- Getters return copies
--------------------------------------------------------------------------------
local copy = Records:Summary(a.id)
copy.wins = 99
copy.rivalries[1].wins = 99
assert_eq(Records:Summary(a.id).wins, 2, "mutating Summary does not change the record")
assert_eq(Records:Summary(a.id).rivalries[1].wins, 2, "mutating a rivalry copy does not leak")
local pagesCopy = Records:Pages()
pagesCopy[1].entries = {}
assert_eq(#Records:Pages()[1].entries, 1, "mutating Pages does not change the record")
local heldCopy = Records:HeldBy(a.id)
heldCopy[1] = "Fake"
assert_eq(Records:HeldBy(a.id)[1], "Most Sanctioned Victories", "mutating HeldBy does not leak")

if standalone then
  print(string.format("Tests finished: %d passed, %d failed", passed, failed))
  if failed > 0 then os.exit(1) end
end
```

- [ ] **Step 2: Run the suite standalone to verify it fails**

Run: `lua tests/test_records_core.lua`
Expected: a Lua error `cannot open addon/ChurchOfBeef/Core/Records.lua` (the module does not exist yet), exit 1.

- [ ] **Step 3: Create `Core/Records.lua`**

Create `addon/ChurchOfBeef/Core/Records.lua`. The superlative body is the existing `buildSuperlatives` from `UI/RecordsBook.lua` (lines ~260–563 at the time of writing: `emptyPages`, `longestWinStreak`, `foughtCount`, `charName`, `indexCharacters`, `deriveDefenses`, `countDefenses`, `maxHolders`, `pairKey`, `buildSuperlatives`) moved verbatim into this file as `local function`s, with `COB.Store` reads unchanged. Wrap them with:

```lua
ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Records keeper (Bible §10.9 / §12.5). Pure Core: derives the nine
-- superlative pages and per-character record summaries from the Pope's
-- Store. Superlatives, never a ranked ladder — there is no position, sort,
-- or rating here and none may be added (§10.9 permanent rejection).
-- Famous Upsets are Pope-flagged rows, never computed. Defenses are derived
-- (OPEN_QUESTIONS #9), never stored. Getters return copies.
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

-- >>> moved verbatim from UI/RecordsBook.lua: emptyPages, longestWinStreak,
-- >>> foughtCount, charName, indexCharacters, deriveDefenses, countDefenses,
-- >>> maxHolders, pairKey, buildSuperlatives  (keep their bodies unchanged)

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
```

Then in `addon/ChurchOfBeef/UI/RecordsBook.lua`:

1. Delete the moved `local function`s (`emptyPages`, `longestWinStreak`, `foughtCount`, `charName`, `indexCharacters`, `deriveDefenses`, `countDefenses`, `maxHolders`, `pairKey`, and the whole `buildSuperlatives` body).
2. Replace `local PAGE_TITLES = { … nine titles … }` with:

```lua
-- Canonical §10.9 order lives on the Core keeper; the book only presents.
local PAGE_TITLES = (COB.Records and COB.Records.TITLES) or {}
```

3. Add the delegate where `buildSuperlatives` was:

```lua
-- Superlative math is Core (Core/Records.lua). The book paints; it does not
-- compute. Missing keeper → no superlative pages (the Chronicle still shows).
local function buildSuperlatives()
  local Records = COB.Records
  if not (Records and type(Records.Pages) == "function") then return {} end
  return Records:Pages()
end
```

4. `addon/ChurchOfBeef/ChurchOfBeef.toc`: insert `Core\Records.lua` on the line after `Core\Store.lua`.
5. `tests/run.lua`: insert `"test_records_core",` after `"test_store",`.
6. `tests/test_records.lua`: after `dofile("addon/ChurchOfBeef/Core/Store.lua")` add `dofile("addon/ChurchOfBeef/Core/Records.lua")`. In the "Source contract" section add:

```lua
assert_eq(bookSrc:find("local function maxHolders", 1, true), nil, "the book holds no superlative math")
assert_eq(bookSrc:find("local function longestWinStreak", 1, true), nil, "streak math lives in Core/Records")
assert_true(bookSrc:find("COB.Records", 1, true) ~= nil, "the book reads Core/Records")
```

(`bookSrc` is whatever local that section already uses for the file body — reuse it.)

7. `tests/preview_dump.lua`: add `dofile("addon/ChurchOfBeef/Core/Records.lua")` on the line after `dofile("addon/ChurchOfBeef/Core/Store.lua")`.

- [ ] **Step 4: Run standalone, then the harness**

Run: `lua tests/test_records_core.lua`
Expected: `Tests finished: N passed, 0 failed` (N ≈ 95).

Run: `lua tests/run.lua`
Expected: `Tests finished: N passed, 0 failed`, exit 0. `test_records` still green (the book's behavior is unchanged).

Run: `COB_PREVIEW_DIR=$(mktemp -d) lua tests/preview_dump.lua`
Expected: `preview_dump finished: 13 scenarios …`, exit 0.

- [ ] **Step 5: Commit (or ledger)**

```bash
git add addon/ChurchOfBeef/Core/Records.lua addon/ChurchOfBeef/UI/RecordsBook.lua addon/ChurchOfBeef/ChurchOfBeef.toc tests/run.lua tests/test_records_core.lua tests/test_records.lua tests/preview_dump.lua
git commit -m "feat(records): pure Core keeper for superlatives, summary, held-by"
```

---

### Task 3: `UI/PlayerCard.lua` — the card

**Files:**
- Create: `addon/ChurchOfBeef/UI/PlayerCard.lua`
- Create: `tests/test_player_card.lua`
- Modify: `addon/ChurchOfBeef/ChurchOfBeef.toc` (add `UI\PlayerCard.lua` after `UI\RecordsBook.lua`)
- Modify: `tests/run.lua` (add `test_player_card` after `test_records`)

**Interfaces:**
- Consumes: Task 1 `COB.Ranks.Relationship(id)`; Task 2 `COB.Records:Summary(id)` and `COB.Records:HeldBy(id)`; `COB.Store:Snapshot()`; `COB.Decree:Get()`; `COB.Names.Key`; `COB.Common.RomanNumeral`; `COB.Theme`.
- Produces: `COB.PlayerCard` with `MODE = "QUIET"`, `COPY`, `Init`, `Show`, `Hide`, `Toggle`, `IsShown`, `Refresh`, `GetModel`, `OpenRecords`, `ResetForTests`; frame `ChurchOfBeefPlayerCard` (320×520, not resizable) with named children `TitleBand, Seal, ChurchLabel, CloseButton, FooterBand, DecreeSigil, DecreeText, Parchment, IdentityPlate, NameText, FormatLine, RankPlate, RankText, RelationshipText, KnightedText, GuildText, GoraLabel, RecordText, StreakText, DefensesText, RivalriesLabel, RivalryLines[1..3], DistinctionsLabel, DistinctionsText, RecordsButton, TitleBar`.
- `GetModel()` shape: `{ name, class, classFile, level, guildName, guildRank, entered, rankId, rankTitle, relationship, knightedAt, record = nil | { wins, losses, fought, longestStreak, defenses }, rivalries = { { name, wins, losses } … ≤3 }, distinctions = { title/honorific … }, decree = nil | { line, flavor } }`.

- [ ] **Step 1: Write the failing suite**

Create `tests/test_player_card.lua`:

```lua
-- Player card — `/beef`. Isolated: wow_ui_stub + Common + Theme + Ranks +
-- Store + Records + Decree + PlayerCard. Quiet, player-opened identity
-- (Bible §12.5, §14.2). Never a position among members (§10.9).
ChurchOfBeef = ChurchOfBeef or {}
ChurchOfBeef._IN_TEST = true

local standalone = (type(assert_eq) ~= "function")
local passed, failed = 0, 0
if standalone then
  package.path = package.path .. ";./tests/?.lua"
  function assert_eq(a, b, msg)
    if a ~= b then
      failed = failed + 1
      print("FAIL: " .. (msg or "") .. " expected " .. tostring(b) .. " got " .. tostring(a))
    else
      passed = passed + 1
    end
  end
  function assert_true(v, msg) assert_eq(not not v, true, msg) end
end

local stub = require("wow_ui_stub")
local restore = stub.install()

dofile("addon/ChurchOfBeef/Core/Common.lua")
dofile("addon/ChurchOfBeef/UI/Theme.lua")
dofile("addon/ChurchOfBeef/Data/Ranks.lua")
dofile("addon/ChurchOfBeef/Core/Store.lua")
dofile("addon/ChurchOfBeef/Core/Records.lua")
dofile("addon/ChurchOfBeef/Core/Decree.lua")
dofile("addon/ChurchOfBeef/UI/PlayerCard.lua")

local COB = ChurchOfBeef
local Store, Decree, Card = COB.Store, COB.Decree, COB.PlayerCard
local EN_DASH = "\226\128\147"

-- The 2.5.x stub does not model these; the card must guard them.
local savedUnitClass, savedUnitLevel = UnitClass, UnitLevel
UnitClass = function() return "Warrior", "WARRIOR" end
UnitLevel = function() return 70 end

local sounds = 0
PlaySound = function() sounds = sounds + 1 end
PlaySoundFile = function() sounds = sounds + 1 end

local function reset()
  assert_eq(Store:ResetForTests(), true, "Store resets")
  assert_eq(Decree:ResetForTests(), true, "Decree resets")
  assert_eq(Card:ResetForTests(), true, "PlayerCard resets")
  stub.playerName = "Beefina"
  stub.guildRankIndex = nil
  ChurchOfBeefDB = { ui = {} }
  sounds = 0
end

local function bout(a, b, winner, now)
  Store:RecordGoraResult(a.id, { opponentId = b.id, ruling = "victor", won = (winner == a) }, now)
  Store:RecordGoraResult(b.id, { opponentId = a.id, ruling = "victor", won = (winner == b) }, now)
end

-- Chuckroast: Beef Knight, knighted at 1700000000, 2–0 vs Tendermage,
-- one honorific, a posted Decree, guild rank shown.
local function seedKnight()
  local a = Store:CreateCharacter({ name = "Chuckroast", class = "Warrior", level = 70 })
  local b = Store:CreateCharacter({ name = "Tendermage", class = "Mage", level = 68 })
  local human = Store:CreateHuman({ name = "Chuck" })
  Store:LinkCharacter(a.id, human.id, 1699990000)
  Store:SetRank(human.id, 3, 1700000000)
  Store:AppendCeremony("Knighting", { human.id }, 1700000000)
  bout(a, b, a, 1700000100)
  bout(a, b, a, 1700000200)
  Store:AddHonorific(human.id, "Duke of the Fountain")
  Decree:Set({ line = "Goldshire Inn — Sunday, 7:00 PM", flavor = "The Gathering." })
  stub.playerName = "Chuckroast"
  stub.guildRankIndex = 6
  return a, b, human
end

local function countSpecial(name)
  local n = 0
  if type(UISpecialFrames) ~= "table" then return 0 end
  for i = 1, #UISpecialFrames do
    if UISpecialFrames[i] == name then n = n + 1 end
  end
  return n
end

local function collectText(widget, out, seen)
  if type(widget) ~= "table" or seen[widget] then return end
  seen[widget] = true
  if type(widget._text) == "string" then out[#out + 1] = widget._text end
  for _, kid in ipairs(widget._children or {}) do collectText(kid, out, seen) end
  for _, region in ipairs(widget._regions or {}) do collectText(region, out, seen) end
end

local function allText()
  local out = {}
  if Card.frame then collectText(Card.frame, out, {}) end
  return table.concat(out, "\n")
end

--------------------------------------------------------------------------------
-- Module contract
--------------------------------------------------------------------------------
assert_true(Card ~= nil, "COB.PlayerCard exists")
assert_eq(Card.MODE, "QUIET", "the card is player-opened Quiet identity")
for _, name in ipairs({ "Init", "Show", "Hide", "Toggle", "IsShown", "Refresh", "GetModel", "OpenRecords", "ResetForTests" }) do
  assert_eq(type(Card[name]), "function", name .. " exists")
end
assert_eq(Card.Position, nil, "no position among members")
assert_eq(Card.Ladder, nil, "no ladder")
assert_eq(Card.Rank, nil, "no numeric rank")
assert_eq(Card.NextRank, nil, "no next-rank hint")
assert_eq(type(SLASH_PLAYERCARD1), "nil", "the card registers no slash")

local f = io.open("addon/ChurchOfBeef/UI/PlayerCard.lua", "r")
assert_true(f ~= nil, "PlayerCard.lua is readable")
local src = f:read("*a")
f:close()
assert_eq(src:find("Interface\\\\", 1, true), nil, "no hardcoded media paths")
assert_eq(src:find("Fonts\\\\", 1, true), nil, "no hardcoded font paths")
assert_eq(src:find("SendChatMessage", 1, true), nil, "the card never talks in chat")
assert_eq(src:find("PlaySound", 1, true), nil, "the card never plays sound (Quiet)")
assert_eq(src:find("SetResizable(true)", 1, true), nil, "fixed size — no resize grip")
assert_eq(src:lower():find("standing", 1, true), nil, "no standing")
assert_eq(src:lower():find("leaderboard", 1, true), nil, "no leaderboard")
assert_eq(src:find("#1", 1, true), nil, "no #1")
assert_eq(src:find("Grant", 1, true), nil, "no Grant")
assert_eq(src:find("SetColorTexture(0", 1, true), nil, "no color literals")

--------------------------------------------------------------------------------
-- Empty store: honest, not a prototype
--------------------------------------------------------------------------------
reset()
local model = Card:GetModel()
assert_eq(model.name, "Beefina", "model names the local character")
assert_eq(model.class, "Warrior", "class from UnitClass")
assert_eq(model.classFile, "WARRIOR", "classFile from UnitClass")
assert_eq(model.level, 70, "level from UnitLevel")
assert_eq(model.entered, false, "not in the Church's record")
assert_eq(model.rankTitle, nil, "no rank")
assert_eq(model.relationship, nil, "no relationship line")
assert_eq(model.record, nil, "no record")
assert_eq(#model.rivalries, 0, "no rivalries")
assert_eq(#model.distinctions, 0, "no distinctions")
assert_eq(model.decree, nil, "no decree")
assert_eq(model.guildName, nil, "unguilded shows no guild")

assert_eq(Card:Show(), true, "empty card shows")
local frame = Card.frame
assert_true(frame ~= nil, "frame exists")
assert_eq(frame:GetWidth(), 320, "card is 320 wide")
assert_eq(frame:GetHeight(), 520, "card is 520 tall")
assert_eq(frame:IsResizable(), false, "card is not resizable")
assert_eq(frame.RankText:GetText(), "UNRECORDED", "unrecorded rank plate")
assert_eq(frame.RelationshipText:GetText(), "Not yet in the Church's record.", "honest identity line")
assert_eq(frame.RecordText:GetText(), "No sanctioned bouts.", "honest record")
assert_eq(frame.RivalryLines[1]:GetText(), "No rivalries yet.", "honest rivalries")
assert_eq(frame.DistinctionsText:GetText(), "None yet.", "honest distinctions")
assert_eq(frame.DecreeText:GetText(), "No gathering is posted.", "honest decree")
assert_eq(frame.FormatLine:GetText(), "Level 70 \194\183 Warrior", "format line")
assert_eq(frame.KnightedText:GetText(), "", "no knighting date")
assert_eq(frame.GuildText:GetText(), "", "no guild line when unguilded")
local text = allText()
for _, banned in ipairs({ "Roster", "Ceremonies", "Marked", "Gathering live", "QUIET", "ASSEMBLY", "RITE", "CONSEQUENCE", "#1" }) do
  assert_eq(text:find(banned, 1, true), nil, "card never paints '" .. banned .. "'")
end
assert_eq(sounds, 0, "Quiet: no sound on show")

--------------------------------------------------------------------------------
-- A Beef Knight with a record
--------------------------------------------------------------------------------
reset()
local a, b, human = seedKnight()
model = Card:GetModel()
assert_eq(model.entered, true, "entered")
assert_eq(model.rankId, 3, "rank id")
assert_eq(model.rankTitle, "Beef Knight", "rank title from Ranks")
assert_eq(model.relationship, "Belonging", "relationship from Ranks (Bible §5)")
assert_eq(model.knightedAt, 1700000000, "knighted at the Knighting ceremony's time")
assert_eq(model.guildName, "Church of Beef", "guild name")
assert_eq(model.guildRank, "Beefling", "Blizzard guild rank (display)")
assert_eq(model.record.wins, 2, "wins")
assert_eq(model.record.losses, 0, "losses")
assert_eq(model.record.fought, 2, "fought")
assert_eq(model.record.longestStreak, 2, "longest streak")
assert_eq(model.record.defenses, 0, "no defenses for a Knight")
assert_eq(#model.rivalries, 1, "one rivalry")
assert_eq(model.rivalries[1].name, "Tendermage", "rival name")
assert_eq(model.rivalries[1].wins, 2, "rival wins")
assert_eq(model.rivalries[1].losses, 0, "rival losses")
assert_eq(table.concat(model.distinctions, "|"),
  "Most Sanctioned Victories|Longest Streak|The Iron Chin|Greatest Rivalry|The Undefeated|Duke of the Fountain",
  "distinctions: held superlatives then honorifics")
assert_eq(model.decree.line, "Goldshire Inn — Sunday, 7:00 PM", "decree line")

assert_eq(Card:Show(), true, "knight card shows")
frame = Card.frame
assert_eq(frame.NameText:GetText(), "Chuckroast", "name")
local cr, cg, cb = COB.Theme:ClassColor("WARRIOR")
local nr, ng, nb = frame.NameText:GetTextColor()
assert_eq(nr, cr, "name is class-colored (r)")
assert_eq(ng, cg, "name is class-colored (g)")
assert_eq(nb, cb, "name is class-colored (b)")
assert_eq(frame.RankText:GetText(), "BEEF KNIGHT", "rank plate in caps")
assert_eq(frame.RelationshipText:GetText(), "Belonging", "relationship under the rank")
assert_true(frame.KnightedText:GetText():find("Knighted ", 1, true) == 1, "knighted date line")
assert_eq(frame.GuildText:GetText(), "Church of Beef \194\183 Beefling", "guild · Blizzard rank")
assert_eq(frame.RecordText:GetText(), "II" .. EN_DASH .. "N", "roman record with nulla for zero")
assert_eq(frame.StreakText:GetText(), "Longest streak II", "streak line")
assert_eq(frame.DefensesText:GetText(), "", "defenses hidden at zero")
assert_eq(frame.RivalryLines[1]:GetText(), "vs Tendermage  II" .. EN_DASH .. "N", "rivalry line")
assert_eq(frame.RivalryLines[2]:GetText(), "", "unused rivalry slot is blank")
assert_true(frame.DistinctionsText:GetText():find("Most Sanctioned Victories", 1, true) ~= nil, "distinctions name a held superlative")
assert_true(frame.DistinctionsText:GetText():find("Duke of the Fountain", 1, true) ~= nil, "distinctions name the honorific")
assert_eq(frame.DecreeText:GetText(), "Goldshire Inn — Sunday, 7:00 PM", "footer carries the Decree line")
text = allText()
assert_eq(text:find("2" .. EN_DASH, 1, true), nil, "no arabic record on the theatrical card")
assert_eq(text:find("of 2", 1, true), nil, "no position copy")

-- Ink discipline: parchment ground carries charcoal / iron / oxblood only.
for _, fs in ipairs({ frame.RelationshipText, frame.KnightedText, frame.GuildText, frame.GoraLabel,
  frame.RecordText, frame.StreakText, frame.RivalriesLabel, frame.RivalryLines[1], frame.DistinctionsLabel, frame.DistinctionsText }) do
  local role = fs._cobColorRole
  assert_true(role == "charcoal" or role == "iron" or role == "oxblood", "parchment ink is charcoal/iron/oxblood, got " .. tostring(role))
end
assert_eq(frame.RankText._cobColorRole, "gold", "rank is gold on the charcoal plate")
assert_eq(frame.DecreeText._cobColorRole, "gold", "decree is gold on the charcoal footer")
assert_eq(frame.ChurchLabel._cobColorRole, "gold", "church label is gold on the title band")
assert_eq(frame.RankPlate._cobColorRole, "charcoal", "rank plate is charcoal")
assert_eq(frame.IdentityPlate._cobColorRole, "charcoal", "identity plate is charcoal")
assert_eq(frame.Parchment._cobTextureName, "parchment_decree", "parchment art through Theme")
assert_eq(frame.Seal._cobTextureName, "seal_papal_small", "papal seal through Theme")
assert_eq(frame.DecreeSigil._cobTextureName, "sigil_gora_small", "gora sigil through Theme")
assert_eq(frame.RankText._cobFontRole, "display", "rank uses the display face")
assert_eq(frame.NameText._cobFontRole, "display", "name uses the display face")
assert_eq(frame.RecordText._cobFontRole, "display", "a real record uses the display face")
assert_eq(frame.RelationshipText._cobFontRole, "body", "relationship uses the body face")

--------------------------------------------------------------------------------
-- Refresh follows the store; a Lord shows defenses
--------------------------------------------------------------------------------
bout(a, b, b, 1700000300)
assert_eq(Card:Refresh(), true, "Refresh repaints")
assert_eq(frame.RecordText:GetText(), "II" .. EN_DASH .. "I", "record follows the store")
assert_eq(frame.RivalryLines[1]:GetText(), "vs Tendermage  II" .. EN_DASH .. "I", "rivalry follows the store")
Store:SetRank(human.id, 4, 1700000400)
bout(a, b, a, 1700000500)
Card:Refresh()
assert_eq(frame.RankText:GetText(), "BEEF LORD", "rank follows the store")
assert_eq(frame.RelationshipText:GetText(), "Proven prestige", "Lord relationship line")
assert_eq(frame.DefensesText:GetText(), "Defenses I", "a Lord's defense appears")

--------------------------------------------------------------------------------
-- Entered but unranked human (Store paths other than Knighting)
--------------------------------------------------------------------------------
reset()
local c = Store:CreateCharacter({ name = "Beefina", class = "Priest" })
local h2 = Store:CreateHuman({ name = "Bee" })
Store:LinkCharacter(c.id, h2.id)
Card:Show()
frame = Card.frame
assert_eq(frame.RankText:GetText(), "UNRANKED", "entered without a rank")
assert_eq(frame.RelationshipText:GetText(), "Recorded, no rank yet.", "honest unranked line")

--------------------------------------------------------------------------------
-- Lifecycle: toggle, ESC, persist, the one path out
--------------------------------------------------------------------------------
reset()
assert_eq(Card:Init(), Card:Init(), "Init is idempotent")
assert_eq(Card:IsShown(), false, "hidden after Init")
assert_eq(Card:Toggle(), true, "Toggle shows")
assert_eq(Card:IsShown(), true, "shown")
assert_eq(Card:Toggle(), true, "Toggle hides")
assert_eq(Card:IsShown(), false, "hidden")
assert_eq(countSpecial("ChurchOfBeefPlayerCard"), 1, "ESC-listed once")
Card:Show()
Card.frame:Hide()
assert_eq(countSpecial("ChurchOfBeefPlayerCard"), 1, "widget Hide re-lists without duplicating")
assert_eq(Card:IsShown(), false, "widget Hide is seen by IsShown")

Card:Show()
frame = Card.frame
assert_true(stub.fire(frame.CloseButton, "OnClick"), "CLOSE is wired")
assert_eq(Card:IsShown(), false, "CLOSE hides the card")
assert_eq(frame.CloseButton:GetText(), "CLOSE", "close label")

Card:Show()
assert_true(stub.fire(frame.TitleBar, "OnDragStart"), "title bar drags")
assert_true(stub.fire(frame.TitleBar, "OnDragStop"), "drag stop saves")
local slot = ChurchOfBeefDB.ui.playerCard
assert_true(type(slot) == "table" and type(slot.point) == "table", "position persists to ui.playerCard")
assert_eq(slot.point.point, "CENTER", "default anchor persisted")
assert_eq(ChurchOfBeefDB.ui.playerCard.w, nil, "no size persisted — the card is fixed")

local shows = 0
local savedBook = COB.RecordsBook
COB.RecordsBook = { Show = function() shows = shows + 1; return true end }
assert_eq(frame.RecordsButton:GetText(), "CHURCH RECORDS", "the one path out")
assert_true(stub.fire(frame.RecordsButton, "OnClick"), "records button wired")
assert_eq(shows, 1, "records button opens the Records Book")
assert_eq(Card:IsShown(), false, "the card steps aside for the book")
COB.RecordsBook = nil
Card:Show()
assert_eq(Card:OpenRecords(), false, "no book → guarded false")
assert_eq(Card:IsShown(), true, "without a book the card stays")
COB.RecordsBook = savedBook

--------------------------------------------------------------------------------
-- Missing optional modules never fail load or paint
--------------------------------------------------------------------------------
reset()
local savedRecords, savedRanks, savedDecree = COB.Records, COB.Ranks, COB.Decree
COB.Records, COB.Ranks, COB.Decree = nil, nil, nil
seedKnight()
assert_eq(Card:Show(), true, "card shows without Records/Ranks/Decree")
assert_eq(Card.frame.RecordText:GetText(), "No sanctioned bouts.", "no Records keeper → honest record")
assert_eq(Card.frame.DecreeText:GetText(), "No gathering is posted.", "no Decree keeper → honest footer")
COB.Records, COB.Ranks, COB.Decree = savedRecords, savedRanks, savedDecree

--------------------------------------------------------------------------------
-- ResetForTests is inert outside the harness
--------------------------------------------------------------------------------
Card:Show()
ChurchOfBeef._IN_TEST = false
assert_eq(Card:ResetForTests(), false, "ResetForTests refuses outside tests")
assert_eq(Card:IsShown(), true, "refused reset leaves the card")
ChurchOfBeef._IN_TEST = true
assert_eq(Card:ResetForTests(), true, "ResetForTests runs under _IN_TEST")
assert_eq(Card:IsShown(), false, "reset hides the card")

UnitClass, UnitLevel = savedUnitClass, savedUnitLevel
restore()

if standalone then
  print(string.format("Tests finished: %d passed, %d failed", passed, failed))
  if failed > 0 then os.exit(1) end
end
```

- [ ] **Step 2: Run standalone to verify it fails**

Run: `lua tests/test_player_card.lua`
Expected: Lua error `cannot open addon/ChurchOfBeef/UI/PlayerCard.lua`, exit 1.

- [ ] **Step 3: Create `UI/PlayerCard.lua`**

```lua
ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Player card — `/beef`. Bible §12.5 (the profile aggregates the character's
-- story), §14.2 (player-opened Quiet identity/history), §22.1 item 7.
-- MODE QUIET: opened by the player, never unbidden. In five seconds: who am
-- I in the Church (rank and its §5 relationship line), my sanctioned Gora
-- record, my rivalries, the distinctions I hold, and when the Church gathers.
-- It never shows a position among members — §10.9 permanently rejects a
-- sorted ladder. Comparison is Church rank, distinctions held, head-to-heads.
-- Theatrical parchment via Theme (Law 10). Ink discipline: charcoal / iron /
-- oxblood text on parchment; gold, parchment, and class color only on
-- charcoal plates. Clerical copy only. The UI never narrates, never jokes.
local PlayerCard = { MODE = "QUIET" }
COB.PlayerCard = PlayerCard

local FRAME_NAME = "ChurchOfBeefPlayerCard"
local CARD_W, CARD_H = 320, 520
local MAX_RIVALRIES = 3
local MAX_DISTINCTION_LINES = 4
local EN_DASH = "\226\128\147"
local MIDDLE_DOT = " \194\183 "
-- Full-surface parchment masters keep a 12% transparent safety margin.
local SURFACE_U0, SURFACE_U1 = 0.12, 0.88

local COPY = {
  church = "CHURCH OF BEEF",
  unrecorded = "UNRECORDED",
  unrecordedLine = "Not yet in the Church's record.",
  unranked = "UNRANKED",
  unrankedLine = "Recorded, no rank yet.",
  goraLabel = "SANCTIONED GORA",
  noBouts = "No sanctioned bouts.",
  streak = "Longest streak ",
  defenses = "Defenses ",
  rivalriesLabel = "RIVALRIES",
  noRivalries = "No rivalries yet.",
  distinctionsLabel = "DISTINCTIONS",
  noDistinctions = "None yet.",
  noDecree = "No gathering is posted.",
  records = "CHURCH RECORDS",
  close = "CLOSE",
  knighted = "Knighted ",
  level = "Level ",
}
PlayerCard.COPY = COPY

local ANCHORS = {
  TOPLEFT = true, TOP = true, TOPRIGHT = true,
  LEFT = true, CENTER = true, RIGHT = true,
  BOTTOMLEFT = true, BOTTOM = true, BOTTOMRIGHT = true,
}

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------

local function deepcopy(value)
  if type(value) ~= "table" then return value end
  local out = {}
  for k, v in pairs(value) do out[deepcopy(k)] = deepcopy(v) end
  return out
end

local function themeColor(role)
  local Theme = COB.Theme
  if not (Theme and type(Theme.Color) == "function") then return nil end
  return Theme:Color(role)
end

local function classColor(classFile)
  local Theme = COB.Theme
  if not (Theme and type(Theme.ClassColor) == "function") then return nil end
  return Theme:ClassColor(classFile)
end

local function themeFont(role)
  local Theme = COB.Theme
  if not (Theme and type(Theme.FontPath) == "function") then return nil end
  return Theme:FontPath(role)
end

local function themeTexture(name)
  local Theme = COB.Theme
  if not (Theme and type(Theme.Texture) == "function") then return nil end
  return Theme:Texture(name)
end

local function space(key, fallback)
  local sizes = COB.Theme and COB.Theme.Space
  if type(sizes) == "table" and type(sizes[key]) == "number" then return sizes[key] end
  return fallback
end

local function fontSize(key, fallback)
  local sizes = COB.Theme and COB.Theme.FontSize
  if type(sizes) == "table" and type(sizes[key]) == "number" then return sizes[key] end
  return fallback
end

local function fillRole(tex, role, alpha)
  if not tex then return end
  local r, g, b = themeColor(role)
  if type(r) ~= "number" then return end
  if tex.SetColorTexture then
    tex:SetColorTexture(r, g, b, alpha or 1)
  elseif tex.SetVertexColor then
    tex:SetVertexColor(r, g, b, alpha or 1)
  end
  tex._cobColorRole = role
end

local function applyInk(fs, role)
  if not fs then return end
  local r, g, b = themeColor(role)
  if type(r) ~= "number" then return end
  if fs.SetTextColor then fs:SetTextColor(r, g, b, 1) end
  fs._cobColorRole = role
end

local function applyTexture(tex, name)
  if not tex then return false end
  local path = themeTexture(name)
  tex._cobTextureName = name
  tex._cobTexture = path
  if type(path) ~= "string" or not tex.SetTexture then return false end
  local ok = pcall(tex.SetTexture, tex, path)
  return ok and true or false
end

local function applyFont(fs, template, role, size)
  if not fs then return end
  local path = role and themeFont(role) or nil
  local used = false
  if path and fs.SetFont then
    local ok, applied = pcall(fs.SetFont, fs, path, size or fontSize("body", 12), "")
    used = ok and applied and true or false
  end
  if not used and fs.SetFontObject then
    local font = type(template) == "string" and _G[template] or template
    if font then pcall(fs.SetFontObject, fs, font) end
  end
  fs._cobFontRole = role
  fs._cobFontPath = path
  fs._cobFontSize = size
end

local function romanCount(n)
  if type(n) ~= "number" or n < 1 then return "N" end -- nulla, as on the fighter card
  local roman = COB.Common and COB.Common.RomanNumeral
  if type(roman) == "function" then
    local s = roman(math.floor(n))
    if type(s) == "string" then return s end
  end
  return tostring(math.floor(n))
end

local function romanPair(a, b)
  return romanCount(a) .. EN_DASH .. romanCount(b)
end

local function stamp(at)
  if type(at) ~= "number" then return nil end
  local fn = type(date) == "function" and date or (type(os) == "table" and os.date) or nil
  if type(fn) ~= "function" then return nil end
  local ok, s = pcall(fn, "%b %d, %Y", at)
  if ok and type(s) == "string" then return s end
  return nil
end

local function safeCall(fn, ...)
  if type(fn) ~= "function" then return nil end
  local ok, a, b = pcall(fn, ...)
  if not ok then return nil end
  return a, b
end

local function rememberSpecial(name)
  if type(UISpecialFrames) ~= "table" then return end
  for i = 1, #UISpecialFrames do
    if UISpecialFrames[i] == name then return end
  end
  UISpecialFrames[#UISpecialFrames + 1] = name
end

local function wireCardOnHide(widget)
  if not widget or type(widget.SetScript) ~= "function" then return end
  local existing = type(widget.GetScript) == "function" and widget:GetScript("OnHide")
  if existing then return end
  widget:SetScript("OnHide", function() rememberSpecial(FRAME_NAME) end)
end

local function uiSlot()
  if type(ChurchOfBeefDB) ~= "table" or type(ChurchOfBeefDB.ui) ~= "table" then return nil end
  if type(ChurchOfBeefDB.ui.playerCard) ~= "table" then ChurchOfBeefDB.ui.playerCard = {} end
  return ChurchOfBeefDB.ui.playerCard
end

local function savePoint(frame)
  local slot = uiSlot()
  if not slot then return end
  local point, _, relativePoint, x, y = frame:GetPoint(1)
  if type(point) ~= "string" or type(x) ~= "number" or type(y) ~= "number" then return end
  slot.point = { point = point, relativePoint = relativePoint or point, x = x, y = y }
end

local function restorePoint(frame)
  local slot = uiSlot()
  local p = slot and slot.point
  frame:ClearAllPoints()
  local relative = type(p) == "table" and (p.relativePoint or p.point) or nil
  if type(p) == "table" and ANCHORS[p.point] and ANCHORS[relative]
      and type(p.x) == "number" and type(p.y) == "number" then
    frame:SetPoint(p.point, UIParent, relative, p.x, p.y)
  else
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
  end
end

--------------------------------------------------------------------------------
-- Model: derived from the Store, Records, Ranks, Decree, and the local unit
--------------------------------------------------------------------------------

local function nameKey(name)
  if not (COB.Names and type(COB.Names.Key) == "function") then return nil end
  return COB.Names.Key(name)
end

local function playerIdentity()
  local name = safeCall(UnitName, "player")
  if type(name) ~= "string" or name == "" then name = nil end
  local class, classFile = safeCall(UnitClass, "player")
  if type(class) ~= "string" then class = nil end
  if type(classFile) ~= "string" then classFile = nil end
  local level = safeCall(UnitLevel, "player")
  if type(level) ~= "number" then level = nil end
  local guildName, guildRank = safeCall(GetGuildInfo, "player")
  if type(guildName) ~= "string" then guildName = nil end
  if type(guildRank) ~= "string" then guildRank = nil end
  return name, class, classFile, level, guildName, guildRank
end

local function findCharacter(snapshot, name)
  local key = nameKey(name)
  if not key then return nil end
  local list = type(snapshot) == "table" and snapshot.characters or nil
  if type(list) ~= "table" then return nil end
  for i = 1, #list do
    local row = list[i]
    if type(row) == "table" and nameKey(row.name) == key then return row end
  end
  return nil
end

local function findHuman(snapshot, humanId)
  if type(humanId) ~= "number" then return nil end
  local list = type(snapshot) == "table" and snapshot.humans or nil
  if type(list) ~= "table" then return nil end
  for i = 1, #list do
    local row = list[i]
    if type(row) == "table" and row.id == humanId then return row end
  end
  return nil
end

-- Latest Knighting ceremony naming this human (Core/Knighting.lua appends
-- type "Knighting" with { humanId }).
local function knightedAt(snapshot, humanId)
  if type(humanId) ~= "number" then return nil end
  local log = type(snapshot) == "table" and snapshot.ceremonyLog or nil
  if type(log) ~= "table" then return nil end
  local at = nil
  for i = 1, #log do
    local row = log[i]
    if type(row) == "table" and row.type == "Knighting"
        and type(row.participantIds) == "table" and row.participantIds[1] == humanId
        and type(row.at) == "number" then
      if at == nil or row.at > at then at = row.at end
    end
  end
  return at
end

local function buildModel()
  local name, class, classFile, level, guildName, guildRank = playerIdentity()
  local snapshot = {}
  if COB.Store and type(COB.Store.Snapshot) == "function" then
    snapshot = COB.Store:Snapshot() or {}
  end
  local model = {
    name = name, class = class, classFile = classFile, level = level,
    guildName = guildName, guildRank = guildRank,
    entered = false, rankId = nil, rankTitle = nil, relationship = nil, knightedAt = nil,
    record = nil, rivalries = {}, distinctions = {}, decree = nil,
  }

  local character = findCharacter(snapshot, name)
  if character then
    if not model.class and type(character.class) == "string" then model.class = character.class end
    if not model.classFile and type(model.class) == "string" then model.classFile = string.upper(model.class) end
    if not model.level and type(character.level) == "number" then model.level = character.level end

    local human = findHuman(snapshot, character.humanId)
    local honorifics = {}
    if human then
      model.entered = true
      local Ranks = COB.Ranks
      if type(human.rankId) == "number" and type(Ranks) == "table" then
        model.rankId = human.rankId
        if type(Ranks.Title) == "function" then model.rankTitle = Ranks.Title(human.rankId) end
        if type(Ranks.Relationship) == "function" then model.relationship = Ranks.Relationship(human.rankId) end
      end
      model.knightedAt = knightedAt(snapshot, human.id)
      if type(human.honorifics) == "table" then
        for i = 1, #human.honorifics do
          if type(human.honorifics[i]) == "string" then honorifics[#honorifics + 1] = human.honorifics[i] end
        end
      end
    end

    local Records = COB.Records
    if type(Records) == "table" and type(Records.Summary) == "function" then
      local summary = Records:Summary(character.id)
      if type(summary) == "table" then
        model.record = {
          wins = summary.wins, losses = summary.losses, fought = summary.fought,
          longestStreak = summary.longestStreak, defenses = summary.defenses,
        }
        local rivals = type(summary.rivalries) == "table" and summary.rivalries or {}
        for i = 1, math.min(#rivals, MAX_RIVALRIES) do
          model.rivalries[i] = { name = rivals[i].opponentName, wins = rivals[i].wins, losses = rivals[i].losses }
        end
      end
    end
    -- Distinctions: superlatives held (canonical order), then honorifics.
    if type(Records) == "table" and type(Records.HeldBy) == "function" then
      local held = Records:HeldBy(character.id)
      if type(held) == "table" then
        for i = 1, #held do model.distinctions[#model.distinctions + 1] = held[i] end
      end
    end
    for i = 1, #honorifics do model.distinctions[#model.distinctions + 1] = honorifics[i] end
  end

  if COB.Decree and type(COB.Decree.Get) == "function" then
    local row = COB.Decree:Get()
    if type(row) == "table" and type(row.line) == "string" and row.line ~= "" then
      model.decree = { line = row.line, flavor = row.flavor }
    end
  end
  return model
end

local function paintStrings(model)
  local s = {}
  s.name = model.name or ""
  local format = {}
  if model.level then format[#format + 1] = COPY.level .. tostring(model.level) end
  if model.class then format[#format + 1] = model.class end
  s.format = table.concat(format, MIDDLE_DOT)
  if model.rankTitle then
    s.rank = string.upper(model.rankTitle)
    s.relationship = model.relationship or ""
  elseif model.entered then
    s.rank = COPY.unranked
    s.relationship = COPY.unrankedLine
  else
    s.rank = COPY.unrecorded
    s.relationship = COPY.unrecordedLine
  end
  local when = stamp(model.knightedAt)
  s.knighted = when and (COPY.knighted .. when) or ""
  local guild = {}
  if model.guildName then guild[#guild + 1] = model.guildName end
  if model.guildRank then guild[#guild + 1] = model.guildRank end
  s.guild = table.concat(guild, MIDDLE_DOT)
  local record = model.record
  s.fought = (record and type(record.fought) == "number") and record.fought or 0
  if s.fought > 0 then
    s.record = romanPair(record.wins, record.losses)
    s.streak = COPY.streak .. romanCount(record.longestStreak)
    if (record.defenses or 0) > 0 then s.defenses = COPY.defenses .. romanCount(record.defenses) else s.defenses = "" end
  else
    s.record = COPY.noBouts
    s.streak = ""
    s.defenses = ""
  end
  s.rivalries = {}
  for i = 1, MAX_RIVALRIES do
    local r = model.rivalries[i]
    if r and type(r.name) == "string" then
      s.rivalries[i] = "vs " .. r.name .. "  " .. romanPair(r.wins, r.losses)
    else
      s.rivalries[i] = ""
    end
  end
  if #model.rivalries == 0 then s.rivalries[1] = COPY.noRivalries end
  if #model.distinctions == 0 then s.distinctions = COPY.noDistinctions
  else s.distinctions = table.concat(model.distinctions, "\n") end
  s.decree = model.decree and model.decree.line or COPY.noDecree
  return s
end

--------------------------------------------------------------------------------
-- Frame
--------------------------------------------------------------------------------

local function plate(frame, layer, role, alpha)
  local tex = frame:CreateTexture(nil, layer or "ARTWORK")
  fillRole(tex, role, alpha or 1)
  return tex
end

local function label(frame, template, role, size, ink, justify)
  local fs = frame:CreateFontString(nil, "OVERLAY", template)
  applyFont(fs, template, role, size)
  applyInk(fs, ink)
  if fs.SetJustifyH then fs:SetJustifyH(justify or "LEFT") end
  if fs.SetWordWrap then fs:SetWordWrap(false) end
  fs:SetText("")
  return fs
end

local function plateButton(parent, text, w, h)
  local btn = CreateFrame("Button", nil, parent)
  btn:SetWidth(w)
  btn:SetHeight(h)
  local bg = btn:CreateTexture(nil, "ARTWORK")
  if bg.SetAllPoints then bg:SetAllPoints(btn) end
  fillRole(bg, "charcoal", 1)
  btn._cobPlate = bg
  local fs = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  applyFont(fs, "GameFontNormal", "label", 12)
  applyInk(fs, "gold")
  if fs.SetAllPoints then fs:SetAllPoints(btn) end
  if fs.SetJustifyH then fs:SetJustifyH("CENTER") end
  fs:SetText(text)
  if btn.SetFontString then btn:SetFontString(fs) end
  btn:SetText(text)
  return btn
end

local function buildFrame()
  local frame = CreateFrame("Frame", FRAME_NAME, UIParent)
  frame:SetFrameStrata("DIALOG")
  if frame.SetToplevel then frame:SetToplevel(true) end
  frame:EnableMouse(true)
  frame:SetMovable(true)
  frame:SetClampedToScreen(true)
  frame:SetWidth(CARD_W)
  frame:SetHeight(CARD_H)
  frame:Hide()
  wireCardOnHide(frame)

  local xs, sm, md = space("xs", 4), space("sm", 8), space("md", 16)
  local ruleH = space("rule", 2)
  local bandH = space("band", 48)
  local footerH = space("footer", 40)
  local sealPx = space("seal", 28)

  local iron = plate(frame, "BACKGROUND", "iron", 0.96)
  iron:SetAllPoints(frame)
  frame.Iron = iron
  local gold = plate(frame, "BORDER", "gold", 1)
  gold:SetPoint("TOPLEFT", frame, "TOPLEFT", ruleH, -ruleH)
  gold:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -ruleH, ruleH)
  frame.GoldEdge = gold

  -- Title band: seal, church label, CLOSE.
  local titleBand = plate(frame, "ARTWORK", "charcoal", 1)
  titleBand:SetPoint("TOPLEFT", frame, "TOPLEFT", xs, -xs)
  titleBand:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -xs, -xs)
  titleBand:SetHeight(bandH)
  frame.TitleBand = titleBand

  local seal = frame:CreateTexture(nil, "OVERLAY")
  seal:SetWidth(sealPx)
  seal:SetHeight(sealPx)
  seal:SetPoint("LEFT", titleBand, "LEFT", md, 0)
  applyTexture(seal, "seal_papal_small")
  frame.Seal = seal

  local church = label(frame, "GameFontNormal", "label", 12, "gold")
  church:SetPoint("LEFT", seal, "RIGHT", sm, 0)
  church:SetText(COPY.church)
  frame.ChurchLabel = church

  local close = plateButton(frame, COPY.close, 56, 24)
  close:SetPoint("RIGHT", titleBand, "RIGHT", -sm, 0)
  close:SetScript("OnClick", function() PlayerCard:Hide() end)
  frame.CloseButton = close

  -- Footer band: when we gather.
  local footerBand = plate(frame, "ARTWORK", "charcoal", 1)
  footerBand:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", xs, xs)
  footerBand:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -xs, xs)
  footerBand:SetHeight(footerH)
  frame.FooterBand = footerBand

  local sigil = frame:CreateTexture(nil, "OVERLAY")
  sigil:SetWidth(20)
  sigil:SetHeight(20)
  sigil:SetPoint("LEFT", footerBand, "LEFT", md, 0)
  applyTexture(sigil, "sigil_gora_small")
  frame.DecreeSigil = sigil

  local decree = label(frame, "GameFontNormal", "label", 12, "gold")
  decree:SetPoint("LEFT", sigil, "RIGHT", sm, 0)
  decree:SetPoint("RIGHT", footerBand, "RIGHT", -md, 0)
  if decree.SetMaxLines then decree:SetMaxLines(1) end
  frame.DecreeText = decree

  -- Parchment between the bands (safety margin cropped).
  local parchment = frame:CreateTexture(nil, "ARTWORK")
  parchment:SetPoint("TOPLEFT", titleBand, "BOTTOMLEFT", 0, 0)
  parchment:SetPoint("BOTTOMRIGHT", footerBand, "TOPRIGHT", 0, 0)
  if applyTexture(parchment, "parchment_decree") then
    if parchment.SetTexCoord then
      pcall(parchment.SetTexCoord, parchment, SURFACE_U0, SURFACE_U1, SURFACE_U0, SURFACE_U1)
    end
  else
    fillRole(parchment, "parchment", 0.94)
  end
  frame.Parchment = parchment

  -- Identity plate: class-colored name on charcoal.
  local identity = plate(frame, "ARTWORK", "charcoal", 1)
  identity:SetPoint("TOPLEFT", parchment, "TOPLEFT", md, -md)
  identity:SetPoint("TOPRIGHT", parchment, "TOPRIGHT", -md, -md)
  identity:SetHeight(56)
  frame.IdentityPlate = identity

  local name = label(frame, "GameFontNormalLarge", "display", fontSize("name", 18), "parchment")
  name:SetPoint("TOPLEFT", identity, "TOPLEFT", md, -sm)
  name:SetPoint("RIGHT", identity, "RIGHT", -md, 0)
  frame.NameText = name

  local format = label(frame, "GameFontNormalSmall", "label", 12, "parchment")
  format:SetPoint("BOTTOMLEFT", identity, "BOTTOMLEFT", md, sm)
  format:SetPoint("RIGHT", identity, "RIGHT", -md, 0)
  frame.FormatLine = format

  -- Rank plate: the hero.
  local rankPlate = plate(frame, "ARTWORK", "charcoal", 1)
  rankPlate:SetPoint("TOPLEFT", identity, "BOTTOMLEFT", 0, -sm)
  rankPlate:SetPoint("TOPRIGHT", identity, "BOTTOMRIGHT", 0, -sm)
  rankPlate:SetHeight(40)
  frame.RankPlate = rankPlate

  local rank = label(frame, "GameFontNormalHuge", "display", fontSize("headline", 22), "gold", "CENTER")
  rank:SetPoint("TOPLEFT", rankPlate, "TOPLEFT", sm, 0)
  rank:SetPoint("BOTTOMRIGHT", rankPlate, "BOTTOMRIGHT", -sm, 0)
  frame.RankText = rank

  local relationship = label(frame, "GameFontNormal", "body", 12, "charcoal", "CENTER")
  relationship:SetPoint("TOPLEFT", rankPlate, "BOTTOMLEFT", 0, -xs)
  relationship:SetPoint("RIGHT", rankPlate, "RIGHT", 0, 0)
  frame.RelationshipText = relationship

  local knighted = label(frame, "GameFontNormalSmall", "label", 12, "iron", "CENTER")
  knighted:SetPoint("TOPLEFT", relationship, "BOTTOMLEFT", 0, -xs)
  knighted:SetPoint("RIGHT", rankPlate, "RIGHT", 0, 0)
  frame.KnightedText = knighted

  local guild = label(frame, "GameFontNormalSmall", "label", 12, "iron", "CENTER")
  guild:SetPoint("TOPLEFT", knighted, "BOTTOMLEFT", 0, -xs)
  guild:SetPoint("RIGHT", rankPlate, "RIGHT", 0, 0)
  frame.GuildText = guild

  -- Gold hairline + oxblood rubric for each section on the parchment.
  local function section(anchor, text)
    local rule = plate(frame, "OVERLAY", "gold", 1)
    rule:SetHeight(ruleH)
    rule:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -sm)
    rule:SetPoint("RIGHT", rankPlate, "RIGHT", 0, 0)
    local head = label(frame, "GameFontNormalSmall", "label", 12, "oxblood")
    head:SetPoint("TOPLEFT", rule, "BOTTOMLEFT", 0, -xs)
    head:SetPoint("RIGHT", rankPlate, "RIGHT", 0, 0)
    head:SetText(text)
    return rule, head
  end

  local goraRule, goraLabel = section(guild, COPY.goraLabel)
  frame.GoraRule, frame.GoraLabel = goraRule, goraLabel
  local record = label(frame, "GameFontNormalHuge", "display", fontSize("headline", 22), "charcoal")
  record:SetPoint("TOPLEFT", goraLabel, "BOTTOMLEFT", 0, -xs)
  record:SetPoint("RIGHT", rankPlate, "RIGHT", 0, 0)
  frame.RecordText = record
  local streak = label(frame, "GameFontNormalSmall", "label", 12, "iron")
  streak:SetPoint("TOPLEFT", record, "BOTTOMLEFT", 0, -xs)
  frame.StreakText = streak
  local defenses = label(frame, "GameFontNormalSmall", "label", 12, "iron")
  defenses:SetPoint("LEFT", streak, "RIGHT", md, 0)
  frame.DefensesText = defenses

  local rivalRule, rivalLabel = section(streak, COPY.rivalriesLabel)
  frame.RivalriesRule, frame.RivalriesLabel = rivalRule, rivalLabel
  frame.RivalryLines = {}
  local prev = rivalLabel
  for i = 1, MAX_RIVALRIES do
    local line = label(frame, "GameFontNormal", "body", 12, "charcoal")
    line:SetPoint("TOPLEFT", prev, "BOTTOMLEFT", 0, -xs)
    line:SetPoint("RIGHT", rankPlate, "RIGHT", 0, 0)
    frame.RivalryLines[i] = line
    prev = line
  end

  local distRule, distLabel = section(prev, COPY.distinctionsLabel)
  frame.DistinctionsRule, frame.DistinctionsLabel = distRule, distLabel
  local distinctions = label(frame, "GameFontNormal", "body", 12, "charcoal")
  distinctions:SetPoint("TOPLEFT", distLabel, "BOTTOMLEFT", 0, -xs)
  distinctions:SetPoint("RIGHT", rankPlate, "RIGHT", 0, 0)
  if distinctions.SetWordWrap then distinctions:SetWordWrap(true) end
  if distinctions.SetMaxLines then distinctions:SetMaxLines(MAX_DISTINCTION_LINES) end
  if distinctions.SetJustifyV then distinctions:SetJustifyV("TOP") end
  frame.DistinctionsText = distinctions

  -- The one path out.
  local records = plateButton(frame, COPY.records, 176, 28)
  records:SetPoint("BOTTOM", footerBand, "TOP", 0, sm)
  records:SetScript("OnClick", function() PlayerCard:OpenRecords() end)
  frame.RecordsButton = records

  -- Drag from the title band (left of CLOSE).
  local titleBar = CreateFrame("Frame", nil, frame)
  titleBar:SetPoint("TOPLEFT", titleBand, "TOPLEFT", 0, 0)
  titleBar:SetPoint("BOTTOMRIGHT", titleBand, "BOTTOMRIGHT", -(56 + md), 0)
  titleBar:EnableMouse(true)
  titleBar:RegisterForDrag("LeftButton")
  titleBar:SetScript("OnDragStart", function() frame:StartMoving() end)
  titleBar:SetScript("OnDragStop", function()
    frame:StopMovingOrSizing()
    savePoint(frame)
  end)
  frame.TitleBar = titleBar

  restorePoint(frame)
  rememberSpecial(FRAME_NAME)
  return frame
end

local function paint(frame, model)
  local s = paintStrings(model)
  frame.NameText:SetText(s.name)
  local r, g, b = classColor(model.classFile)
  if type(r) == "number" and frame.NameText.SetTextColor then
    frame.NameText:SetTextColor(r, g, b, 1)
    frame.NameText._cobColorRole = "class"
  else
    applyInk(frame.NameText, "parchment")
  end
  frame.FormatLine:SetText(s.format)
  frame.RankText:SetText(s.rank)
  frame.RelationshipText:SetText(s.relationship)
  frame.KnightedText:SetText(s.knighted)
  frame.GuildText:SetText(s.guild)
  if s.fought > 0 then
    applyFont(frame.RecordText, "GameFontNormalHuge", "display", fontSize("headline", 22))
    applyInk(frame.RecordText, "charcoal")
  else
    applyFont(frame.RecordText, "GameFontNormal", "body", 12)
    applyInk(frame.RecordText, "iron")
  end
  frame.RecordText:SetText(s.record)
  frame.StreakText:SetText(s.streak)
  frame.DefensesText:SetText(s.defenses)
  for i = 1, MAX_RIVALRIES do
    frame.RivalryLines[i]:SetText(s.rivalries[i] or "")
  end
  applyInk(frame.RivalryLines[1], (#model.rivalries == 0) and "iron" or "charcoal")
  frame.DistinctionsText:SetText(s.distinctions)
  applyInk(frame.DistinctionsText, (#model.distinctions == 0) and "iron" or "charcoal")
  frame.DecreeText:SetText(s.decree)
end

--------------------------------------------------------------------------------
-- Public
--------------------------------------------------------------------------------

function PlayerCard:Init()
  if self.frame then
    wireCardOnHide(self.frame)
    rememberSpecial(FRAME_NAME)
    return self.frame
  end
  if type(CreateFrame) ~= "function" then return nil end
  self.frame = buildFrame()
  return self.frame
end

function PlayerCard:GetModel()
  return deepcopy(buildModel())
end

function PlayerCard:IsShown()
  return self.frame ~= nil and self.frame:IsShown() == true
end

function PlayerCard:Refresh()
  if not self.frame then return false end
  paint(self.frame, buildModel())
  return true
end

function PlayerCard:Show()
  local frame = self:Init()
  if not frame then return false end
  wireCardOnHide(frame)
  rememberSpecial(FRAME_NAME)
  paint(frame, buildModel())
  frame:Show()
  return true
end

function PlayerCard:Hide()
  if self.frame then
    wireCardOnHide(self.frame)
    rememberSpecial(FRAME_NAME)
    self.frame:Hide()
  end
  return true
end

function PlayerCard:Toggle()
  if self:IsShown() then return self:Hide() end
  return self:Show()
end

-- The card steps aside for the book; without a book it stays.
function PlayerCard:OpenRecords()
  local book = COB.RecordsBook
  if not (type(book) == "table" and type(book.Show) == "function") then return false end
  self:Hide()
  return book:Show()
end

function PlayerCard:ResetForTests()
  if not COB._IN_TEST then return false end
  if self.frame then self.frame:Hide() end
  return true
end
```

Then: `addon/ChurchOfBeef/ChurchOfBeef.toc` — insert `UI\PlayerCard.lua` on the line after `UI\RecordsBook.lua`. `tests/run.lua` — insert `"test_player_card",` after `"test_records",`.

- [ ] **Step 4: Run standalone, then the harness**

Run: `lua tests/test_player_card.lua`
Expected: `Tests finished: N passed, 0 failed` (N ≈ 150).

Run: `lua tests/run.lua`
Expected: `Tests finished: N passed, 0 failed`, exit 0.

- [ ] **Step 5: Commit (or ledger)**

```bash
git add addon/ChurchOfBeef/UI/PlayerCard.lua addon/ChurchOfBeef/ChurchOfBeef.toc tests/test_player_card.lua tests/run.lua
git commit -m "feat(ui): player card — rank, record, rivalries, distinctions, decree"
```

---

### Task 4: `/beef` opens the card; the book loses its Home spread

**Files:**
- Modify: `addon/ChurchOfBeef/ChurchOfBeef.lua` (initUi order; slash; InspectProgress)
- Modify: `addon/ChurchOfBeef/UI/Minimap.lua` (left-click → card)
- Modify: `addon/ChurchOfBeef/UI/Decree.lua` (book button → card; label)
- Modify: `addon/ChurchOfBeef/UI/RecordsBook.lua` (remove Home / overview / identity leaf; open on Chronicle)
- Modify: `tests/test_wire_glue.lua`, `tests/test_minimap.lua`, `tests/test_decree_ui.lua`, `tests/test_records.lua`, `tests/preview_dump.lua`

**Interfaces:**
- Consumes: Task 3 `COB.PlayerCard:Toggle()` / `:Show()` / `:ResetForTests()`.
- Produces: `RecordsBook` public API becomes exactly `Init, Show, Hide, Toggle, IsShown, GetPages, ResetForTests, toRoman` (+ `MODE`). `ShowHome`, `ToggleHome`, `GetOverview` are removed. `Show()` opens on the Chronicle (`pageIndex ≥ 1`).

- [ ] **Step 1: Write the failing assertions**

`tests/test_wire_glue.lua` — in the initUi block, change the expected order string to include the card after the book:

```lua
"Minimap,RecordsBook,PlayerCard,Hud,Console,Toasts,DecreeBanner,Sound,FighterCard,Inputs,Markers"
```

and add `PlayerCard` to the ten (now eleven) stubbed modules with save/restore. In the slash section, replace the `RecordsBook.ToggleHome` spy with a `PlayerCard.Toggle` spy:

```lua
local cardToggles = 0
local savedCard = COB.PlayerCard
COB.PlayerCard = { Toggle = function() cardToggles = cardToggles + 1; return true end }
SlashCmdList["CHURCHOFBEEF"]("")
assert_eq(cardToggles, 1, "/beef toggles the player card")
SlashCmdList["CHURCHOFBEEF"]("anything")
assert_eq(cardToggles, 2, "unrecognised arguments toggle the player card")
SlashCmdList["CHURCHOFBEEF"]("petition")
assert_eq(cardToggles, 3, "retired subcommands fall through to the card")
COB.PlayerCard = savedCard
```

`tests/test_minimap.lua` — every `RecordsBook.ToggleHome` spy becomes a `PlayerCard.Toggle` spy; the three assertion messages become `"a plain click drives PlayerCard:Toggle"` / `"after Clear, a plain click still drives PlayerCard:Toggle"`.

`tests/test_decree_ui.lua` — the `bookOpens` spy moves from `COB.RecordsBook.ToggleHome` to `COB.PlayerCard.Show`; messages `"Church book action drives PlayerCard:Show"`, `"left-click always opens the player card"`; add `assert_eq(frame.BookButton:GetText(), "YOUR CARD", "the Decree's action names the card")`.

`tests/test_records.lua` — retire the Home surface:

```lua
assert_eq(Book.ShowHome, nil, "the book has no Home spread — /beef is the player card")
assert_eq(Book.ToggleHome, nil, "no ToggleHome")
assert_eq(Book.GetOverview, nil, "no overview model — identity lives on the player card")
Book:Show()
assert_eq(Book.frame.PageTitle:GetText(), "Chronicle", "Show opens on the Chronicle")
assert_eq(rawget(Book.frame, "OverviewWidgets"), nil, "no overview widgets")
assert_eq(rawget(Book.frame, "IdentityTitle"), nil, "no identity leaf — the card owns identity")
assert_eq(rawget(Book.frame, "Honorifics"), nil, "no honorifics leaf")
assert_eq(allText():find("Your Record", 1, true), nil, "the book never says Your Record")
assert_eq(allText():find("THE DECREE", 1, true), nil, "the book never paints the Decree block")
```

Every existing pin that references `ShowHome`, `ToggleHome`, `GetOverview`, `OverviewWidgets`, `Overview*`, `HomeRibbon`, `IdentityTitle`, `HonorificsHeading`, `Honorifics`, `localHonorifics`, `identityText`, `guildIdentity`, "The Gathering", "Your Record", or `pageIndex == 0` is a retired-surface pin: delete it (do not weaken anything else). `runHomePaintPerf` becomes a Chronicle-paint perf pin: `Book:Show()` performs at most **two** `Store:Snapshot` calls (one for pages, one for the chronicle log read).

`tests/preview_dump.lua` — add `dofile("addon/ChurchOfBeef/UI/PlayerCard.lua")` after the RecordsBook dofile; add `UnitClass = function() return "Warrior", "WARRIOR" end` and `UnitLevel = function() return 70 end` after `stub.install()`; add `if COB.PlayerCard and COB.PlayerCard.ResetForTests then COB.PlayerCard:ResetForTests() end` to `resetCores`; replace the `dashboard` scenario with two scenarios and drop `ShowHome`/`GetOverview` from `records_empty`:

```lua
  {
    -- The player card: a Beef Knight with a record, a rival, a distinction,
    -- and a posted Decree.
    name = "card",
    run = function()
      local a, b = twoChars()
      local humanA = rankBoth(a, b, 3, 1)
      COB.Store:AppendCeremony("Knighting", { humanA.id }, 1700000000)
      recordBout(a, b, a)
      recordBout(a, b, a)
      COB.Store:AddHonorific(humanA.id, "Duke of the Fountain")
      COB.Decree:Set({ line = "Goldshire Inn — Sunday, 7:00 PM", flavor = "The Gathering." })
      stub.playerName = "Chuckroast"
      stub.guildRankIndex = 6
      assert(COB.PlayerCard:Show() == true, "card shown")
      local model = COB.PlayerCard:GetModel()
      assert(model.rankTitle == "Beef Knight", "card rank")
      assert(model.record and model.record.wins == 2, "card record")
      assert(COB.PlayerCard.frame.RankText:GetText() == "BEEF KNIGHT", "rank plate")
    end,
  },
  {
    -- Empty store: the card's honest empty states.
    name = "card_empty",
    run = function()
      stub.playerName = "Beefina"
      assert(COB.PlayerCard:Show() == true, "empty card shown")
      local model = COB.PlayerCard:GetModel()
      assert(model.entered == false, "not entered")
      assert(model.decree == nil, "no decree")
      assert(COB.PlayerCard.frame.RankText:GetText() == "UNRECORDED", "unrecorded plate")
    end,
  },
```

In `records_empty`, delete the `COB.RecordsBook:ShowHome()` line and the four `overview.*` asserts; keep the Chronicle asserts (the scenario now rests on the Chronicle directly after `Show()`).

- [ ] **Step 2: Run the harness to verify it fails**

Run: `lua tests/run.lua`
Expected: FAIL lines from `test_wire_glue` (order string, `/beef toggles the player card`), `test_minimap`, `test_decree_ui` (`YOUR CARD`), and `test_records` (`no Home spread`, `no overview widgets`, …); exit 1.

- [ ] **Step 3: Implement**

`addon/ChurchOfBeef/ChurchOfBeef.lua`:

1. In `initUi`, after the `RecordsBook` Init call, add the same shape for the card (bare like RecordsBook — the card's Init is guarded internally):

```lua
  if COB.PlayerCard and COB.PlayerCard.Init then
    COB.PlayerCard:Init()
  end
```

2. Replace the slash fall-through (the block beginning `-- The Quiet shell is retired: bare /beef …` through the `DEFAULT_CHAT_FRAME:AddMessage(… Records Book not ready …)` line) with:

```lua
  -- Bare /beef (and any unrecognised argument) toggles the player card —
  -- who I am in the Church and when we gather (Bible §12.5, §14.2). The
  -- Records Book opens from the card's one button, not from the slash.
  local card = COB.PlayerCard
  if card and card.Toggle then
    card:Toggle()
    return
  end
  DEFAULT_CHAT_FRAME:AddMessage("|cffffaa00Church of Beef|r: player card not ready yet. (" .. COB.VERSION .. ")")
```

Update the comment above the handler: `-- Unrecognised arguments open the player card.`

3. In `InspectProgress`, replace the `COB.RecordsBook:Show()` block with:

```lua
    if COB.PlayerCard and COB.PlayerCard.Show then
      COB.PlayerCard:Show()
    end
```

and change both chat notes from `"Records Book, Decree, and Director Console are open."` to `"Player card, Decree, and Director Console are open."`.

`addon/ChurchOfBeef/UI/Minimap.lua` — replace the left-click body:

```lua
    -- Left is stable navigation: the player card (Bible §14.2 identity).
    local card = COB.PlayerCard
    if card and type(card.Toggle) == "function" then
      card:Toggle()
    end
```

Update the header comment (`Left-click always opens /beef (Records Book)` → `Left-click always opens the player card`). Tooltip copy `"Left-click: Church overview"` becomes `"Left-click: your card"` (update the matching `assert_tip_line` pins in `test_minimap.lua` and `test_decree_ui.lua`).

`addon/ChurchOfBeef/UI/Decree.lua` — the `book` button: label string `"OPEN CHURCH BOOK"` → `"YOUR CARD"`; OnClick body:

```lua
    DecreeBanner:Hide()
    local card = COB.PlayerCard
    if card and type(card.Show) == "function" then
      card:Show()
    end
```

`addon/ChurchOfBeef/UI/RecordsBook.lua`:

1. Delete `overviewModel`, `paintOverview`, `guildIdentity`, `localHonorifics`, `identityText`, `jumpHome`, `RecordsBook:ShowHome`, `RecordsBook:ToggleHome`, `RecordsBook:GetOverview`.
2. In `buildFrame`, delete the right-leaf identity block (from `-- Right leaf is identity …` through `frame.Honorifics = honorifics`) and the whole overview block (from `-- \`/beef\` home: the Church card …` through the last `frame.Overview* = …` assignment). Keep `rightLeaf`, `frame.RightLeaf`, `body`, `frame.Body`, `rule`, `pageTitle`.
3. In `paint(pages)`: remove `isOverview` and every branch keyed on it (the `OverviewWidgets` loop, the `setShown(widget, not isOverview)` loop over `Body/HonorificsHeading/Honorifics`, the `if isOverview then … paintOverview(frame) return end` block, the `IdentityTitle` and `Honorifics` SetText calls). Pages always build: `if type(pages) ~= "table" then pages = buildPages() end`. Clamp `pageIndex` to `[1, n]` unconditionally. Ribbon/Prev/Next visibility lines are replaced in Task 5 — for now keep `setShown(frame.PrevButton, walkable)` / `setShown(frame.NextButton, walkable)` and drop the `activeRibbon` loop (the ribbons are deleted in Task 5; delete `frame.HomeRibbon` creation now and leave `ChronicleRibbon` until Task 5).
4. `turn(delta)`: lower clamp becomes `if nextIndex < 1 then nextIndex = 1 end`.
5. The `OnSizeChanged` hook: drop `if pageIndex == 0 and frame:IsShown() then paint() end`.
6. `RecordsBook:Show()`: before `paint()`, add `if pageIndex < 1 then pageIndex = 1 end`.
7. Header comment: the book is "the Church's records behind the player card — Chronicle first, superlatives only when held". Remove the "Your Record"/"identity leaf" sentences.

- [ ] **Step 4: Run the harness and the preview dump**

Run: `lua tests/run.lua`
Expected: `Tests finished: N passed, 0 failed`, exit 0.

Run: `COB_PREVIEW_DIR=$(mktemp -d) lua tests/preview_dump.lua`
Expected: `preview_dump finished: 14 scenarios …` (13 − dashboard + card + card_empty), exit 0.

Run: `rg -n "ToggleHome|ShowHome|GetOverview|OverviewWidgets" addon/ tests/`
Expected: only the three `== nil` retirement pins in `tests/test_records.lua`.

- [ ] **Step 5: Commit (or ledger)**

```bash
git add addon/ChurchOfBeef/ChurchOfBeef.lua addon/ChurchOfBeef/UI/Minimap.lua addon/ChurchOfBeef/UI/Decree.lua addon/ChurchOfBeef/UI/RecordsBook.lua tests/test_wire_glue.lua tests/test_minimap.lua tests/test_decree_ui.lua tests/test_records.lua tests/preview_dump.lua
git commit -m "feat(ui): /beef opens the player card; Records Book opens on the Chronicle"
```

---

### Task 5: Records Book navigation — leaf caption, edge-aware turns, two-leaf Chronicle

**Files:**
- Modify: `addon/ChurchOfBeef/UI/RecordsBook.lua`
- Modify: `tests/test_records.lua`
- Modify: `tests/preview_dump.lua` (`records` scenario stops firing `ChronicleRibbon`)

**Interfaces:**
- Produces: `frame.LeafCaption` (FontString, footer center, gold on charcoal) reading `"Leaf I of III \194\183 Chronicle"`; `frame.PrevButton` label `"\226\128\185 PREVIOUS"` visible only when `pageIndex > 1`; `frame.NextButton` label `"NEXT \226\128\186"` visible only when `pageIndex < n`; `frame.ChronicleEntries` has 14 slots — 1–7 anchored to the left `body`, 8–14 to `frame.RightLeaf`; `frame.RightSeal` (a large low-alpha papal seal watermark) shown on superlative leaves, hidden on the Chronicle. `frame.HomeRibbon` and `frame.ChronicleRibbon` no longer exist.

- [ ] **Step 1: Write the failing assertions**

Add to `tests/test_records.lua` (a new `runNavigation()` block, called where the other `run*` blocks are called):

```lua
local function runNavigation()
  reset()
  local a, b = char("Chuckroast", "Warrior"), char("Tendermage", "Mage")
  -- 9 Knightings so the Chronicle overflows the left leaf onto the right.
  local human = Store:CreateHuman({ name = "Chuck" })
  Store:LinkCharacter(a.id, human.id)
  for i = 1, 9 do Store:AppendCeremony("Knighting", { human.id }, 1700000000 + i * 100) end
  bout(a, b, a, 1700001000)
  Book:Show()
  local frame = Book.frame
  assert_eq(rawget(frame, "HomeRibbon"), nil, "no Home tab")
  assert_eq(rawget(frame, "ChronicleRibbon"), nil, "no Chronicle tab — the Chronicle is leaf I")
  assert_eq(type(frame.LeafCaption), "table", "footer carries a leaf caption")
  local n = #Book:GetPages()
  assert_true(n >= 2, "a held superlative makes a second leaf")
  assert_eq(frame.LeafCaption:GetText(), "Leaf I of " .. Book.toRoman(n) .. " \194\183 Chronicle", "caption names the leaf and page")
  assert_eq(frame.LeafCaption._cobColorRole, "gold", "caption is gold on the charcoal footer")
  assert_eq(frame.PrevButton:IsShown(), false, "no Previous on the first leaf")
  assert_eq(frame.NextButton:IsShown(), true, "Next on the first leaf")
  assert_eq(frame.PrevButton:GetText(), "\226\128\185 PREVIOUS", "previous label")
  assert_eq(frame.NextButton:GetText(), "NEXT \226\128\186", "next label")
  -- Chronicle spans both leaves: 14 slots, 8..14 on the right leaf.
  assert_eq(#frame.ChronicleEntries, 14, "fourteen chronicle slots")
  local _, rel8 = frame.ChronicleEntries[8]:GetPoint(1)
  assert_eq(rel8, frame.RightLeaf, "slot 8 hangs on the right leaf")
  local _, rel1 = frame.ChronicleEntries[1]:GetPoint(1)
  assert_true(rel1 ~= frame.RightLeaf, "slot 1 stays on the left leaf")
  local painted = paintedChronicle()
  assert_eq(#painted, 10, "ten ledger rows paint across both leaves")
  assert_eq(frame.RightSeal:IsShown(), false, "no watermark on the Chronicle")
  -- Turn to the last leaf.
  for _ = 1, n do stub.fire(frame.NextButton, "OnClick") end
  assert_eq(frame.NextButton:IsShown(), false, "no Next on the last leaf")
  assert_eq(frame.PrevButton:IsShown(), true, "Previous on the last leaf")
  assert_eq(frame.RightSeal:IsShown(), true, "superlative leaves carry the seal watermark")
  assert_eq(frame.RightSeal._cobTextureName, "seal_papal", "watermark is the papal seal through Theme")
  assert_true(frame.LeafCaption:GetText():find("^Leaf " .. Book.toRoman(n) .. " of ") == 1, "caption follows the turn")
  -- Wheel still turns; the footer chrome still forwards the wheel.
  stub.fire(frame.LeafCaption, "OnMouseWheel", 1)
  assert_true(frame.LeafCaption:GetText():find("^Leaf " .. Book.toRoman(n - 1) .. " of ") == 1, "wheel up turns back")
end
```

(If `frame.LeafCaption` is a FontString, the wheel pin must target the footer band frame instead — see Step 3: the caption sits on a `FooterBar` Frame that receives the wheel; fire on `frame.FooterBar`.)

Replace the `ChronicleRibbon` fires in `tests/preview_dump.lua` `records` with `for _ = 1, 3 do stub.fire(COB.RecordsBook.frame.PrevButton, "OnClick") end` and keep the `"rests on the Chronicle"` assert. Delete every remaining `ChronicleRibbon` / `HomeRibbon` reference in `tests/test_records.lua` (they were footer-tab pins).

- [ ] **Step 2: Run the harness to verify it fails**

Run: `lua tests/run.lua`
Expected: `FAIL: no Chronicle tab …`, `FAIL: footer carries a leaf caption …`, `FAIL: fourteen chronicle slots expected 14 got 7`; exit 1.

- [ ] **Step 3: Implement**

In `addon/ChurchOfBeef/UI/RecordsBook.lua`:

1. Constants: `local CHRONICLE_POOL = 7` → 

```lua
local CHRONICLE_POOL_PER_LEAF = 7
local CHRONICLE_POOL = CHRONICLE_POOL_PER_LEAF * 2
```

2. Delete `jumpToChronicle`, the `homeRibbon` and `chronicleRibbon` creation blocks, `tabW`/`tabPitch`, and their two `wireChildWheel` lines.
3. Chronicle slots: replace the pool loop with

```lua
  frame.ChronicleEntries = {}
  for i = 1, CHRONICLE_POOL do
    local slot = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    if i <= CHRONICLE_POOL_PER_LEAF then
      slot:SetPoint("TOPLEFT", body, "TOPLEFT", 0, -(i - 1) * CHRONICLE_STRIDE)
      slot:SetPoint("RIGHT", body, "RIGHT", 0, 0)
    else
      local row = i - CHRONICLE_POOL_PER_LEAF - 1
      slot:SetPoint("TOPLEFT", rightLeaf, "TOPLEFT", md, -(md + row * CHRONICLE_STRIDE))
      slot:SetPoint("RIGHT", rightLeaf, "RIGHT", -md, 0)
    end
    applyFont(slot, "GameFontNormal", "body", 14)
    applyInk(slot, "charcoal")
    if slot.SetJustifyH then slot:SetJustifyH("LEFT") end
    if slot.SetJustifyV then slot:SetJustifyV("TOP") end
    if slot.SetWordWrap then slot:SetWordWrap(true) end
    if slot.SetMaxLines then slot:SetMaxLines(2) end
    slot:SetText("")
    if slot.Hide then slot:Hide() end
    frame.ChronicleEntries[i] = slot
  end

  -- Superlative leaves: a quiet papal watermark on the right leaf.
  local rightSeal = frame:CreateTexture(nil, "ARTWORK")
  rightSeal:SetWidth(160)
  rightSeal:SetHeight(160)
  rightSeal:SetPoint("CENTER", rightLeaf, "CENTER", 0, 0)
  applyTexture(rightSeal, "seal_papal")
  if rightSeal.SetAlpha then rightSeal:SetAlpha(0.18) end
  rightSeal:Hide()
  frame.RightSeal = rightSeal
```

4. Footer: replace the Prev/Next creation with edge-labelled buttons and a caption bar:

```lua
  local footerBar = CreateFrame("Frame", nil, frame)
  footerBar:SetPoint("TOPLEFT", footerBand, "TOPLEFT", 0, 0)
  footerBar:SetPoint("BOTTOMRIGHT", footerBand, "BOTTOMRIGHT", 0, 0)
  footerBar:EnableMouse(true)
  frame.FooterBar = footerBar

  local caption = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  caption:SetPoint("CENTER", footerBand, "CENTER", 0, 0)
  applyFont(caption, "GameFontNormal", "label", 14)
  applyInk(caption, "gold")
  if caption.SetJustifyH then caption:SetJustifyH("CENTER") end
  caption:SetText("")
  frame.LeafCaption = caption

  local prev = CreateFrame("Button", nil, frame)
  prev:SetWidth(112)
  prev:SetHeight(xl)
  prev:SetPoint("LEFT", footerBand, "LEFT", md, 0)
  labelButton(prev, "\226\128\185 PREVIOUS")
  prev:SetScript("OnClick", function() turn(-1) end)
  frame.PrevButton = prev

  local nextBtn = CreateFrame("Button", nil, frame)
  nextBtn:SetWidth(112)
  nextBtn:SetHeight(xl)
  nextBtn:SetPoint("RIGHT", footerBand, "RIGHT", -md, 0)
  labelButton(nextBtn, "NEXT \226\128\186")
  nextBtn:SetScript("OnClick", function() turn(1) end)
  frame.NextButton = nextBtn

  wireChildWheel(frame.TitleBar)
  wireChildWheel(frame.CloseButton)
  wireChildWheel(frame.FooterBar)
  wireChildWheel(frame.PrevButton)
  wireChildWheel(frame.NextButton)
```

5. In `paint(pages)`, replace the visibility lines with:

```lua
  setShown(frame.PrevButton, pageIndex > 1)
  setShown(frame.NextButton, pageIndex < n)
  if frame.LeafCaption and frame.LeafCaption.SetText then
    local title = page and page.title or ""
    frame.LeafCaption:SetText("Leaf " .. toRoman(pageIndex) .. " of " .. toRoman(n) .. " \194\183 " .. title)
  end
  setShown(frame.RightSeal, not isChronicle)
```

(`page` and `isChronicle` are computed a few lines above in the existing paint; move the caption/seal lines after them.)

6. Update the header comment: footer = leaf caption + edge-aware Previous/Next; Chronicle spans both leaves.

- [ ] **Step 4: Run the harness and preview dump**

Run: `lua tests/run.lua`
Expected: `Tests finished: N passed, 0 failed`, exit 0.

Run: `COB_PREVIEW_DIR=$(mktemp -d) lua tests/preview_dump.lua`
Expected: 14 scenarios, exit 0.

- [ ] **Step 5: Commit (or ledger)**

```bash
git add addon/ChurchOfBeef/UI/RecordsBook.lua tests/test_records.lua tests/preview_dump.lua
git commit -m "feat(records): leaf caption, edge-aware turns, two-leaf Chronicle"
```

---

### Task 6: Honesty, rules, install

**Files:**
- Modify: `docs/phases/solo-smoke.md` (§3 and the Honesty table rows for `/beef`, Minimap, Decree)
- Modify: `docs/phases/v1-checklist.md` (Honesty bullet 1; §3 heading; component 7 and 8 "Today")
- Modify: `.cursor/rules/architecture-overview.mdc` (entry table: `/beef` → `COB.PlayerCard:Toggle()`)
- Modify: `README.md` (Usage bullets)
- Modify: `docs/design/OPEN_QUESTIONS.md` (append decided item 20)
- Modify: `docs/REFORMATION_LOG.md` (append a wave entry)

- [ ] **Step 1: Update the walk scripts**

`docs/phases/solo-smoke.md` Honesty rows:

```markdown
| `/beef` | Toggles the **player card** (320×520): your name and class on a dark plate, your **Church rank** on a gold plate with its Bible §5 relationship line ("Belonging", "Proven prestige" …) and Knighting date, guild and Blizzard rank in small type, your **sanctioned Gora record** in roman numerals with longest streak (and defenses for a Lord), up to three **rivalries** (head-to-head lines), your **distinctions** (superlatives you hold, then honorifics), and the active **Decree** in the footer. Honest empties: UNRECORDED / "No sanctioned bouts." / "No rivalries yet." / "None yet." / "No gathering is posted." One button: **CHURCH RECORDS** opens the book and the card steps aside. Never a position among members. |
| Minimap | Left-click toggles the player card. Right-click replays the active Decree. Tooltip: **GUILD GATHERING**, "Left-click: your card". |
| Records Book | Opens on the **Chronicle**, which now spans both leaves (14 dated rows). Footer: **‹ PREVIOUS**, "Leaf I of III · Chronicle", **NEXT ›** — Previous hides on the first leaf, Next on the last. Superlative leaves show only when held and carry a faint papal watermark on the right leaf. No tabs. |
| Decree | … **YOUR CARD** returns to the player card. … |
```

§3 heading → `### 3. \`/beef\` is the player card (§12.5, §14.2)` with boxes: the card reads in five seconds (rank plate, record, rivalries, distinctions, decree); no counters, no state words, no position; **CHURCH RECORDS** opens the book on the Chronicle; ESC closes; drag persists; `/beef` again closes.

`docs/phases/v1-checklist.md`: Honesty bullet 1 → "`/beef` is player-opened Quiet: the **player card** (rank, record, rivalries, distinctions, Decree) with the **Records Book** behind its one button." §3 heading and body → the card. Component 7 "Today" → "the player card shows identity, rank and relationship, record, rivalries, distinctions; alt-linking rite UI is parked." Component 8 "Today" → "hosted behind **CHURCH RECORDS** — Chronicle across both leaves, superlatives only when held, leaf caption navigation."

`.cursor/rules/architecture-overview.mdc` entry table row: ``| `/beef` | `COB.PlayerCard:Toggle()` (`/beef console` → `COB.Console:Show()`) |``.

`README.md` Usage:

```markdown
- `/beef` — your player card: Church rank, sanctioned Gora record, rivalries, distinctions, the next Gathering. **CHURCH RECORDS** on the card opens the Records Book. The minimap roundel toggles the same card.
- `/beef console` — the Director Console (listed Pope characters only).
- `/beef minimap` — show or hide the minimap roundel. Unrecognized arguments open the card.
```

`docs/design/OPEN_QUESTIONS.md` — append under the UX-rebuild list:

```markdown
20. **Player card comparison (decided):** the `/beef` card answers "how do I stand among the Church" with Church rank + its §5 relationship line, distinctions held (§10.9 superlatives), and head-to-head rivalries — never a sorted position, count-of-members-above, or rating (§10.9 permanent rejection). A rank census line ("one of seven Knights") was considered and not built; it is not open unless David asks for it.
```

`docs/REFORMATION_LOG.md` — append:

```markdown
### Player card (2026-09-13)

David: the `/beef` main window "doesn't serve any actual useful purpose … should be much more of a player card". Rebuilt as `UI/PlayerCard.lua` (320×520, fixed, movable, Quiet): class-colored name, Church rank plate with the Bible §5 relationship line (`Data/Ranks.lua` `relationship`), Knighting date, guild/Blizzard rank, roman Gora record + streak + defenses, three rivalries, distinctions (held superlatives then honorifics), the Decree in the footer, one button to the Records Book. Superlative math moved to pure `Core/Records.lua` (`Pages`, `Summary`, `HeldBy`). Records Book lost its Home spread and identity leaf; opens on a two-leaf Chronicle; footer is a leaf caption with edge-aware Previous/Next. No position among members (§10.9). POLISH:CANDIDATE — David's in-client pass is the close.
```

- [ ] **Step 2: Full verification and install**

Run: `lua tests/run.lua`
Expected: `Tests finished: N passed, 0 failed`, exit 0.

Run: `COB_PREVIEW_DIR=$(mktemp -d) lua tests/preview_dump.lua`
Expected: 14 scenarios, exit 0.

Run: `python3 - <<'PY'` TOC check (every listed file exists; `Core\Records.lua` and `UI\PlayerCard.lua` present):

```python
import os
for line in open("addon/ChurchOfBeef/ChurchOfBeef.toc"):
    line=line.strip()
    if not line or line.startswith("#"): continue
    p=os.path.join("addon/ChurchOfBeef", line.replace("\\","/"))
    assert os.path.isfile(p), p
print("TOC_OK")
PY
```

Expected: `TOC_OK`.

Run: `rg -n -i "standing|leaderboard|prophet|#1" addon/ChurchOfBeef/UI/PlayerCard.lua addon/ChurchOfBeef/Core/Records.lua`
Expected: no output.

Run: `./scripts/install-anniversary.sh && diff -rq addon/ChurchOfBeef "/Applications/World of Warcraft/_anniversary_/Interface/AddOns/ChurchOfBeef" && echo TREES_MATCH`
Expected: `Installed Church of Beef → …` then `TREES_MATCH`.

- [ ] **Step 3: Commit (or ledger)**

```bash
git add docs/phases/solo-smoke.md docs/phases/v1-checklist.md .cursor/rules/architecture-overview.mdc README.md docs/design/OPEN_QUESTIONS.md docs/REFORMATION_LOG.md
git commit -m "docs: player card honesty, rules, and log"
```

---

## Self-review

**Spec coverage.** Player card that clearly shows Church rank (Task 3 rank plate + relationship + Knighting date), Gora record (record/streak/defenses), "how they rank with others" reframed Bible-compliantly as distinctions held + rivalries (Tasks 2–3; recorded as OPEN_QUESTIONS #20 in Task 6), much less real estate (320×520 fixed vs 680×520 resizable), a purposeful layout (plates and rubrics, one action), and the bottom navigation redesigned (Task 5: leaf caption + edge-aware turns, no tab bar). Entry points all land on the card (Task 4).

**Placeholder scan.** Task 2 Step 3 references "moved verbatim" helpers by name with the exact list and the current line range; their bodies exist in `UI/RecordsBook.lua` today and are copied, not rewritten — the engineer copies the named functions. Task 4 Step 1's "every pin that references … is a retired-surface pin: delete it" is a deletion rule over a 1.9k-line suite with the exact symbol list; the replacement pins are given in full.

**Type consistency.** `Records:Summary` returns `longestStreak`, `fought`, `defenses`, `rivalries[].opponentName` — consumed by `PlayerCard.buildModel` under those exact names. `COB.Ranks.Relationship(id)` — defined Task 1, consumed Task 3. `PlayerCard:Toggle()` / `:Show()` — defined Task 3, consumed Task 4 (slash, minimap, Decree). `RecordsBook:Show()` — retained, consumed by `PlayerCard:OpenRecords`. `toRoman` — retained on `RecordsBook`, used by the Task 5 caption and its test.
