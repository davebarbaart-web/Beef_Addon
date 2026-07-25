# Church of Beef V1 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship a TBC Classic Anniversary addon that shows a 7-rank Church of Beef ladder, accrues standing from thin Gora/ceremony/instance co-play, suggests promotions, and lets Officer+ commit official ranks over BeefNet with login sync.

**Architecture:** Pure Core modules own ladder state, scoring, and officer checks (testable offline). UI and Net are thin adapters over Core. Machine canon lives in `addon/ChurchOfBeef/Data/Ranks.lua`. Official state is officer-committed records with revision numbers, reconciled on login.

**Tech Stack:** Lua 5.1 (WoW), XML optional (Lua `CreateFrame` primary), SavedVariablesPerCharacter, `C_ChatInfo.SendAddonMessage` / Classic-safe addon messaging on `GUILD` with prefix `COB`, Interface `20506`.

**Spec:** `docs/superpowers/specs/2026-07-25-church-of-beef-design.md`

## Global Constraints

- Platform: TBC Classic Anniversary only for V1 (`## Interface: 20506`); Classic+ is a future port.
- No Retail-only / Dragonflight-era APIs.
- Lua/XML only; fully in-game; no bots, injection, automated movement/targeting/casting, or protected-action circumvention.
- Addon may announce, track, record, display, coordinate, sync allowed data; must not play the game for anyone.
- Ranks (low→high): Fresh Beef, Cooked Beef, Beef Knight, Beef Lord, Beef Butcher, Beef Council, Beef Prophet.
- Ranks 1–5 point-driven; Beef Council seat-limited appointed; Beef Prophet bestowed unique.
- Hybrid advancement: addon suggests; real WoW guild Officer+ (roster rank-index check) approves.
- Standings are self-reported advisory testimony; officer approval is the anti-cheat.
- Machine canon path: `addon/ChurchOfBeef/Data/Ranks.lua` only (not a top-level `canon/`).
- SavedVariables: per-character `ChurchOfBeefDB`.
- BeefNet prefix `COB`, channel `GUILD`; commits carry per-player revision numbers; login sync required.
- Filename casing: `ChurchOfBeef*.lua` consistently.
- Each Dreamscythe / Doomhowl guild runs an independent ladder (no cross-realm state).

---

## File structure (locked)

```
Beef_Addon/
  README.md
  docs/
    canon/ranks.md
    phases/v1-checklist.md
    superpowers/specs/2026-07-25-church-of-beef-design.md
    superpowers/plans/2026-07-25-church-of-beef-v1.md
  tests/
    wow_stub.lua
    run.lua
    test_ranks.lua
    test_ladder.lua
    test_scoring.lua
    test_officer.lua
    test_net_validate.lua
  addon/ChurchOfBeef/
    ChurchOfBeef.toc
    ChurchOfBeef.lua          # bootstrap, slash, DB load/save hooks
    Data/Ranks.lua            # machine canon
    Core/DB.lua               # SavedVariables shape + defaults
    Core/Officer.lua          # roster rank-index gate
    Core/Scoring.lua          # points, caps, anti-AFK buckets
    Core/Ladder.lua           # records, suggestions, commits, demote, seats
    Core/Gora.lua             # thin challenge/result → scoring
    Core/Ceremony.lua         # thin start/close → scoring
    Core/Instance.lua         # shared instance co-play tracker
    Net/BeefNet.lua           # send/receive, validate, dispatch
    Net/Sync.lua              # SYNC_REQUEST / SYNC_STATE
    UI/MainFrame.lua          # frame shell, tabs
    UI/LadderTab.lua
    UI/StandingTab.lua
    UI/OfficerTab.lua
    UI/Minimap.lua
    UI/Toasts.lua
    UI/Announce.lua           # guild-chat promotion lines
```

---

### Task 1: Repo scaffold, TOC, bootstrap, offline test harness

**Files:**
- Create: `README.md`
- Create: `addon/ChurchOfBeef/ChurchOfBeef.toc`
- Create: `addon/ChurchOfBeef/ChurchOfBeef.lua`
- Create: `tests/wow_stub.lua`
- Create: `tests/run.lua`
- Create: `docs/phases/v1-checklist.md` (stub header only; filled in Task 12)

**Interfaces:**
- Consumes: nothing
- Produces: global table `ChurchOfBeef` (`COB`); `COB:OnLoad()`; slash `/beef`; test runner entry `tests/run.lua`

- [ ] **Step 1: Install Lua 5.1 for offline Core tests**

```bash
brew install lua@5.1 || brew install lua
lua -v
```

Expected: a Lua version prints (5.1 preferred; 5.4 is acceptable for our pure-logic tests).

- [ ] **Step 2: Write TOC**

Create `addon/ChurchOfBeef/ChurchOfBeef.toc`:

```toc
## Interface: 20506
## Title: Church of Beef
## Notes: Social rank ladder and guild spectacle for the Church of Beef.
## Author: Church of Beef
## Version: 0.1.0
## SavedVariablesPerCharacter: ChurchOfBeefDB

Data\Ranks.lua
Core\DB.lua
Core\Officer.lua
Core\Scoring.lua
Core\Ladder.lua
Core\Gora.lua
Core\Ceremony.lua
Core\Instance.lua
Net\BeefNet.lua
Net\Sync.lua
UI\Toasts.lua
UI\Announce.lua
UI\LadderTab.lua
UI\StandingTab.lua
UI\OfficerTab.lua
UI\Minimap.lua
UI\MainFrame.lua
ChurchOfBeef.lua
```

Note: later tasks create the listed files; until then, keep TOC listing only files that exist, expanding the TOC as each task lands. **For this task only**, use a minimal TOC:

```toc
## Interface: 20506
## Title: Church of Beef
## Notes: Social rank ladder and guild spectacle for the Church of Beef.
## Author: Church of Beef
## Version: 0.1.0
## SavedVariablesPerCharacter: ChurchOfBeefDB

ChurchOfBeef.lua
```

- [ ] **Step 3: Write bootstrap**

Create `addon/ChurchOfBeef/ChurchOfBeef.lua`:

```lua
ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef
COB.VERSION = "0.1.0"
COB.ADDON_MSG_PREFIX = "COB"

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")

frame:SetScript("OnEvent", function(_, event, arg1)
  if event == "ADDON_LOADED" and arg1 == "ChurchOfBeef" then
    if COB.DB and COB.DB.Init then
      COB.DB:Init()
    end
    COB.loaded = true
  elseif event == "PLAYER_LOGIN" then
    if COB.UI and COB.UI.Init then
      COB.UI:Init()
    end
    if COB.Net and COB.Net.Init then
      COB.Net:Init()
    end
    if COB.Sync and COB.Sync.OnLogin then
      COB.Sync:OnLogin()
    end
  end
end)

SLASH_CHURCHOFBEEF1 = "/beef"
SlashCmdList["CHURCHOFBEEF"] = function(msg)
  msg = (msg or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
  if COB.UI and COB.UI.Toggle then
    COB.UI:Toggle()
    return
  end
  DEFAULT_CHAT_FRAME:AddMessage("|cffffaa00Church of Beef|r: UI not ready yet. (" .. COB.VERSION .. ")")
end
```

- [ ] **Step 4: Write README**

Create `README.md` covering: what Church of Beef is, install path (`Interface/AddOns/ChurchOfBeef` from `addon/ChurchOfBeef/`), `/beef`, link to the design spec, hard safety rules (no automation), TBC Anniversary first.

- [ ] **Step 5: Write offline stub + runner**

Create `tests/wow_stub.lua`:

```lua
-- Minimal stubs so Core modules can load under desktop Lua.
CreateFrame = CreateFrame or function()
  return {
    RegisterEvent = function() end,
    SetScript = function() end,
    Hide = function() end,
    Show = function() end,
  }
end
DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME or { AddMessage = function(_, m) print(m) end }
SlashCmdList = SlashCmdList or {}
```

Create `tests/run.lua`:

```lua
package.path = package.path .. ";./tests/?.lua;./addon/ChurchOfBeef/?.lua;./addon/ChurchOfBeef/?/?.lua"

require("wow_stub")

local failed = 0
local passed = 0

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

-- Individual suites register themselves by calling their file when required.
local suites = {
  "test_ranks",
  "test_ladder",
  "test_scoring",
  "test_officer",
  "test_net_validate",
}

for _, name in ipairs(suites) do
  local ok, err = pcall(function() require(name) end)
  if not ok then
    -- Suites appear as tasks land; missing suite is OK until created.
    if not tostring(err):find("module '" .. name .. "' not found") then
      failed = failed + 1
      print("FAIL suite " .. name .. ": " .. tostring(err))
    end
  end
end

print(string.format("Tests finished: %d passed, %d failed", passed, failed))
if failed > 0 then os.exit(1) end
```

- [ ] **Step 6: Smoke-load in game (manual)**

Copy `addon/ChurchOfBeef` into the TBC Anniversary `Interface/AddOns/` folder. Launch client. Confirm addon appears as **Church of Beef**. Type `/beef`. Expected chat: `Church of Beef: UI not ready yet. (0.1.0)`.

- [ ] **Step 7: Commit**

```bash
git add README.md addon/ChurchOfBeef/ChurchOfBeef.toc addon/ChurchOfBeef/ChurchOfBeef.lua tests/wow_stub.lua tests/run.lua docs/phases/v1-checklist.md
git commit -m "chore: scaffold Church of Beef addon and test harness"
```

---

### Task 2: Machine canon ranks data

**Files:**
- Create: `addon/ChurchOfBeef/Data/Ranks.lua`
- Create: `tests/test_ranks.lua`
- Create: `docs/canon/ranks.md`
- Modify: `addon/ChurchOfBeef/ChurchOfBeef.toc` (add `Data\Ranks.lua` before bootstrap)

**Interfaces:**
- Consumes: nothing
- Produces: `COB.Ranks` table with `List`, `ById`, `Threshold`, `IsPointDriven`, `CouncilSeats`, `ProphetUnique`, `OfficerRankIndexMax`

- [ ] **Step 1: Write failing test**

Create `tests/test_ranks.lua`:

```lua
-- Load ranks the same way the addon will: as a chunk setting COB.Ranks
ChurchOfBeef = ChurchOfBeef or {}
dofile("addon/ChurchOfBeef/Data/Ranks.lua")
local R = ChurchOfBeef.Ranks

assert_eq(#R.List, 7, "seven ranks")
assert_eq(R.List[1].title, "Fresh Beef", "rank 1 title")
assert_eq(R.List[7].title, "Beef Prophet", "rank 7 title")
assert_eq(R.Threshold(2), 50, "Cooked Beef threshold")
assert_true(R.IsPointDriven(5), "Butcher point-driven")
assert_eq(R.IsPointDriven(6), false, "Council not point-driven")
assert_eq(R.IsPointDriven(7), false, "Prophet not point-driven")
assert_eq(R.CouncilSeats, 4, "default council seats")
assert_eq(R.ProphetUnique, true, "prophet unique")
assert_eq(R.OfficerRankIndexMax, 1, "GM + top officer")
```

- [ ] **Step 2: Run test to verify it fails**

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon && lua tests/run.lua
```

Expected: FAIL (file missing or `ChurchOfBeef.Ranks` nil).

- [ ] **Step 3: Implement ranks data**

Create `addon/ChurchOfBeef/Data/Ranks.lua`:

```lua
ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

local LIST = {
  { id = 1, title = "Fresh Beef",   threshold = 0,    kind = "points" },
  { id = 2, title = "Cooked Beef",  threshold = 50,   kind = "points" },
  { id = 3, title = "Beef Knight",  threshold = 200,  kind = "points" },
  { id = 4, title = "Beef Lord",    threshold = 500,  kind = "points" },
  { id = 5, title = "Beef Butcher", threshold = 1000, kind = "points" },
  { id = 6, title = "Beef Council", threshold = nil,  kind = "council" },
  { id = 7, title = "Beef Prophet", threshold = nil,  kind = "prophet" },
}

local BY_ID = {}
for _, r in ipairs(LIST) do BY_ID[r.id] = r end

COB.Ranks = {
  List = LIST,
  ById = BY_ID,
  CouncilSeats = 4,
  ProphetUnique = true,
  -- Guild rank index 0 = GM, 1 = first officer tier; approve if index <= this.
  OfficerRankIndexMax = 1,
  Threshold = function(id)
    local r = BY_ID[id]
    return r and r.threshold or nil
  end,
  IsPointDriven = function(id)
    local r = BY_ID[id]
    return r and r.kind == "points"
  end,
  Title = function(id)
    local r = BY_ID[id]
    return r and r.title or "Unknown"
  end,
}
```

- [ ] **Step 4: Write prose mirror**

Create `docs/canon/ranks.md` describing each title in Church voice (1–2 sentences each). **Do not duplicate numeric thresholds** — point readers at `Data/Ranks.lua`.

- [ ] **Step 5: Update TOC + run tests**

Add `Data\Ranks.lua` above `ChurchOfBeef.lua` in the TOC. Run:

```bash
lua tests/run.lua
```

Expected: ranks assertions pass.

- [ ] **Step 6: Commit**

```bash
git add addon/ChurchOfBeef/Data/Ranks.lua addon/ChurchOfBeef/ChurchOfBeef.toc tests/test_ranks.lua docs/canon/ranks.md
git commit -m "feat: add Church of Beef rank canon data"
```

---

### Task 3: Ladder core (records, suggestions, commits, demote, seats)

**Files:**
- Create: `addon/ChurchOfBeef/Core/Ladder.lua`
- Create: `tests/test_ladder.lua`
- Modify: TOC to include `Core\Ladder.lua`

**Interfaces:**
- Consumes: `COB.Ranks`
- Produces:
  - `COB.Ladder:GetRecord(name) -> { name, rankId, standing, revision, updatedAt, updatedBy }`
  - `COB.Ladder:SetStanding(name, standing)` (local advisory)
  - `COB.Ladder:MaybeSuggest(name) -> suggestion|nil` (only for point-driven next rank)
  - `COB.Ladder:GetSuggestions() -> array`
  - `COB.Ladder:RejectSuggestion(name)`
  - `COB.Ladder:Commit(name, rankId, standing, officerName, now) -> record|nil, err`
  - `COB.Ladder:ApplyRemoteCommit(record) -> boolean` (revision rules)
  - `COB.Ladder:Demote(name, rankId, officerName, now)`
  - `COB.Ladder:AppointCouncil(name, officerName, now)`
  - `COB.Ladder:BestowProphet(name, officerName, now)`
  - `COB.Ladder:GetLadderView() -> array of records sorted by rankId desc then name`
  - `COB.Ladder:ImportState(records)` / `ExportState() -> records`

- [ ] **Step 1: Write failing tests**

Create `tests/test_ladder.lua`:

```lua
ChurchOfBeef = ChurchOfBeef or {}
dofile("addon/ChurchOfBeef/Data/Ranks.lua")
dofile("addon/ChurchOfBeef/Core/Ladder.lua")
local L = ChurchOfBeef.Ladder
L:ResetForTests()

L:SetStanding("Beefina", 50)
local sug = L:MaybeSuggest("Beefina")
assert_true(sug ~= nil, "suggestion at threshold")
assert_eq(sug.toRankId, 2, "suggest Cooked Beef")

local rec, err = L:Commit("Beefina", 2, 50, "Pope", 1000)
assert_true(rec ~= nil, "commit ok: " .. tostring(err))
assert_eq(rec.revision, 1, "revision starts at 1")
assert_eq(rec.rankId, 2, "committed rank")

-- Older revision must not overwrite
local applied = L:ApplyRemoteCommit({
  name = "Beefina", rankId = 1, standing = 0, revision = 1,
  updatedAt = 999, updatedBy = "Other",
})
assert_eq(applied, false, "same revision rejected")

applied = L:ApplyRemoteCommit({
  name = "Beefina", rankId = 3, standing = 200, revision = 2,
  updatedAt = 2000, updatedBy = "Pope",
})
assert_eq(applied, true, "higher revision applied")
assert_eq(L:GetRecord("Beefina").rankId, 3, "remote promote")

-- Council seat limit
L:ResetForTests()
for i = 1, 4 do
  local r, e = L:AppointCouncil("C"..i, "Pope", i)
  assert_true(r ~= nil, "appoint " .. i .. " " .. tostring(e))
end
local r, e = L:AppointCouncil("C5", "Pope", 5)
assert_true(r == nil, "fifth council blocked")
assert_true(type(e) == "string", "error string")

-- Prophet unique
L:ResetForTests()
assert_true(L:BestowProphet("A", "Pope", 1) ~= nil, "first prophet")
assert_true(select(1, L:BestowProphet("B", "Pope", 2)) == nil, "second prophet blocked")
```

- [ ] **Step 2: Run to verify fail**

```bash
lua tests/run.lua
```

Expected: FAIL on missing `Core/Ladder.lua`.

- [ ] **Step 3: Implement Ladder.lua**

Implement `addon/ChurchOfBeef/Core/Ladder.lua` matching the interfaces above:

- Internal store: `self.records[name]`, `self.suggestions[name]`
- `Commit` / `Demote` / `AppointCouncil` / `BestowProphet` always bump `revision`, set `updatedAt`/`updatedBy`, clear suggestion for that name
- `AppointCouncil` counts current `rankId == 6`; reject if `>= COB.Ranks.CouncilSeats`
- `BestowProphet` rejects if any record has `rankId == 7` and `ProphetUnique`
- `MaybeSuggest`: only if current official `rankId` is point-driven and standing >= next point-driven threshold; never suggests 6/7
- `ApplyRemoteCommit`: apply only if `revision > local.revision`, or equal revision with `(updatedAt > local)` or `(updatedAt == local and updatedBy > local.updatedBy)`
- `ResetForTests` clears stores (tests only; no-op harmful in game if called — gate with `COB._IN_TEST`)

Set `COB._IN_TEST = true` at top of `tests/run.lua` before requiring suites.

- [ ] **Step 4: Run tests**

```bash
lua tests/run.lua
```

Expected: ladder suite passes.

- [ ] **Step 5: Commit**

```bash
git add addon/ChurchOfBeef/Core/Ladder.lua tests/test_ladder.lua tests/run.lua addon/ChurchOfBeef/ChurchOfBeef.toc
git commit -m "feat: add ladder core with revisions and seat limits"
```

---

### Task 4: Scoring core (caps, sources, anti-AFK buckets)

**Files:**
- Create: `addon/ChurchOfBeef/Core/Scoring.lua`
- Create: `tests/test_scoring.lua`
- Modify: TOC

**Interfaces:**
- Consumes: `COB.Ladder`, `COB.Ranks`
- Produces:
  - `COB.Scoring:Grant(name, source, amount, now) -> grantedAmount`
  - `COB.Scoring:GrantInstanceBucket(name, now, inCombat) -> grantedAmount` (0 if not inCombat)
  - `COB.Scoring:GrantInstanceComplete(name, now) -> grantedAmount`
  - `COB.Scoring:GrantGora(name, outcome, now)` outcome = `"win"|"loss"|"draw"`
  - `COB.Scoring:GrantCeremony(name, now)`
  - `COB.Scoring:GetDayKey(now) -> string`
  - Constants in module: instance bucket 5 pts, complete 20, ceremony 40, gora win 25 / draw 10 / loss 8; daily caps instance 60, ceremony 80, gora 100

- [ ] **Step 1: Write failing tests**

```lua
ChurchOfBeef = ChurchOfBeef or {}
COB._IN_TEST = true
dofile("addon/ChurchOfBeef/Data/Ranks.lua")
dofile("addon/ChurchOfBeef/Core/Ladder.lua")
dofile("addon/ChurchOfBeef/Core/Scoring.lua")
local S = ChurchOfBeef.Scoring
local L = ChurchOfBeef.Ladder
L:ResetForTests()
S:ResetForTests()

assert_eq(S:GrantInstanceBucket("A", 1000, false), 0, "AFK bucket pays 0")
assert_eq(S:GrantInstanceBucket("A", 1000, true), 5, "combat bucket pays")
assert_eq(L:GetRecord("A").standing, 5, "standing updated")

-- Cap: 60/day instance → 12 buckets max
for i = 1, 20 do S:GrantInstanceBucket("A", 1000 + i, true) end
assert_true(L:GetRecord("A").standing <= 60, "instance daily cap")

L:ResetForTests(); S:ResetForTests()
S:GrantGora("B", "loss", 1)
assert_eq(L:GetRecord("B").standing, 8, "loss still pays")
```

- [ ] **Step 2: Run fail, implement Scoring.lua, run pass**

`Grant` must clamp to remaining daily cap for that `source`, then `Ladder:SetStanding` and `Ladder:MaybeSuggest`.

- [ ] **Step 3: Commit**

```bash
git add addon/ChurchOfBeef/Core/Scoring.lua tests/test_scoring.lua addon/ChurchOfBeef/ChurchOfBeef.toc
git commit -m "feat: add capped standing scoring with anti-AFK buckets"
```

---

### Task 5: Officer gate

**Files:**
- Create: `addon/ChurchOfBeef/Core/Officer.lua`
- Create: `tests/test_officer.lua`
- Modify: TOC

**Interfaces:**
- Consumes: `COB.Ranks.OfficerRankIndexMax`
- Produces:
  - `COB.Officer:IsOfficerIndex(rankIndex) -> bool`
  - `COB.Officer:IsOfficerName(name, rosterLookup) -> bool`
  - `rosterLookup(name) -> rankIndex|nil` injected for testability; in game wrap `GetGuildInfo` / `GetGuildRosterInfo` after `GuildRoster()`

- [ ] **Step 1: Tests**

```lua
dofile("addon/ChurchOfBeef/Data/Ranks.lua")
dofile("addon/ChurchOfBeef/Core/Officer.lua")
local O = ChurchOfBeef.Officer
assert_eq(O:IsOfficerIndex(0), true, "GM")
assert_eq(O:IsOfficerIndex(1), true, "officer")
assert_eq(O:IsOfficerIndex(2), false, "member")
local function roster(name)
  if name == "Pope" then return 0 end
  if name == "Cardinal" then return 1 end
  if name == "Pleb" then return 4 end
  return nil
end
assert_eq(O:IsOfficerName("Pope", roster), true, "pope")
assert_eq(O:IsOfficerName("Pleb", roster), false, "pleb")
assert_eq(O:IsOfficerName("Ghost", roster), false, "missing")
```

- [ ] **Step 2: Implement + commit**

```lua
-- Core/Officer.lua sketch
function COB.Officer:IsOfficerIndex(rankIndex)
  if rankIndex == nil then return false end
  return rankIndex <= COB.Ranks.OfficerRankIndexMax
end
```

In-game helper `COB.Officer:LocalIsOfficer()` uses live roster; never approve if roster unavailable.

```bash
git commit -m "feat: add guild rank-index officer gate"
```

---

### Task 6: SavedVariables DB

**Files:**
- Create: `addon/ChurchOfBeef/Core/DB.lua`
- Modify: `ChurchOfBeef.lua` (already calls `COB.DB:Init`)
- Modify: TOC

**Interfaces:**
- Produces: `COB.DB:Init()`, `COB.DB:Save()`, loads into `Ladder`/`Scoring`/`UI` prefs
- DB shape:

```lua
ChurchOfBeefDB = {
  version = 1,
  ui = { point = nil, shown = false, announce = true },
  ladder = { records = {}, suggestions = {} },
  scoring = { dayKey = "", granted = {} }, -- granted[dayKey][name][source] = amount
}
```

- [ ] **Step 1: Implement Init** — if `ChurchOfBeefDB` nil, create defaults; call `Ladder:ImportState` / scoring import; never wipe unknown future keys.

- [ ] **Step 2: In-game verify** — `/reload` preserves standing after a `/beef` session once UI exists (full verify after Task 7). For now, unit-level: after Init with a fake global, records round-trip.

- [ ] **Step 3: Commit**

```bash
git commit -m "feat: add per-character SavedVariables persistence"
```

---

### Task 7: Main UI shell, tabs, minimap, toasts

**Files:**
- Create: `UI/MainFrame.lua`, `UI/Minimap.lua`, `UI/Toasts.lua`
- Create: stub tab files that register empty panels: `UI/LadderTab.lua`, `UI/StandingTab.lua`, `UI/OfficerTab.lua`
- Modify: TOC (all UI files), bootstrap already calls `COB.UI:Init`

**Interfaces:**
- `COB.UI:Init()`, `COB.UI:Toggle()`, `COB.UI:ShowTab(name)`
- `COB.Toasts:Show(text)`
- Frame: movable title bar, `StartMoving`/`StopMovingOrSizing`, `SetClampedToScreen(true)`, save position into `ChurchOfBeefDB.ui.point`

- [ ] **Step 1: Implement MainFrame** with three tab buttons (Ladder / My Standing / Officer). Officer tab button hidden unless `COB.Officer:LocalIsOfficer()`.

- [ ] **Step 2: Minimap button** toggles frame (use a basic `Minimap` child button; no external lib).

- [ ] **Step 3: In-game verify**

1. `/beef` opens a visible frame (not chat-only).
2. Frame is movable and stays on screen.
3. `/reload` restores position.
4. Minimap button toggles frame.
5. Non-officer does not see Officer tab.

- [ ] **Step 4: Commit**

```bash
git commit -m "feat: add movable Church of Beef UI shell"
```

---

### Task 8: Ladder tab + Standing tab

**Files:**
- Modify: `UI/LadderTab.lua`, `UI/StandingTab.lua`

**Interfaces:**
- Consumes: `COB.Ladder:GetLadderView()`, `GetRecord(UnitName("player"))`, scoring event log if present
- Produces: rendered lines for all 7 ranks with occupants; local highlight; standing + next threshold + recent grants

- [ ] **Step 1: Implement LadderTab** — for each rank id 7→1, show title and comma-separated occupants (or "—"). Highlight player line.

- [ ] **Step 2: Implement StandingTab** — show standing, current title, next point-driven threshold (or "Appointed ranks only" if already Butcher+), last ~10 grant lines from `COB.Scoring:GetHistory(name)`.

Add `GetHistory` to Scoring if missing (ring buffer max 20).

- [ ] **Step 3: In-game verify** — with forced test standing via a temp `/beef debug standing 50` **dev-only** command behind `COB.DEBUG = true` default false; document enabling it. Prefer officer commit path once Task 9 exists; for this task, a debug grant is acceptable if removed or gated before release.

- [ ] **Step 4: Commit**

```bash
git commit -m "feat: render ladder and personal standing tabs"
```

---

### Task 9: Officer tab (approve, reject, correct, demote, appoint, bestow)

**Files:**
- Modify: `UI/OfficerTab.lua`
- Create: `UI/Announce.lua`

**Interfaces:**
- Consumes: suggestions list; `Ladder:Commit/Reject/Demote/AppointCouncil/BestowProphet`; `Officer:LocalIsOfficer`; `Announce:Promotion(name, title)`
- On approve: `Commit` then `COB.Net:SendRankCommit(record)` then `Announce:Promotion`

- [ ] **Step 1: Implement officer list UI** with Approve / Reject per suggestion; separate controls for Demote (dropdown rank 1–5), Appoint Council, Bestow Prophet, standing correction (+/− input).

- [ ] **Step 2: Implement Announce.lua**

```lua
function COB.Announce:Promotion(name, title)
  if ChurchOfBeefDB.ui.announce == false then return end
  if not COB.Officer:LocalIsOfficer() then return end
  SendChatMessage(
    string.format("The Church recognizes %s, elevated to %s.", name, title),
    "GUILD"
  )
end
```

Mirror demotion line: `"The Church excommunicates %s to %s."`

- [ ] **Step 3: In-game verify** (two characters if possible)

1. Member crosses threshold → suggestion appears for officer.
2. Approve → member rank updates; guild chat line appears once.
3. Non-officer cannot open actions (tab hidden).
4. Fifth Council appointment fails with visible error.
5. Second Prophet bestowal fails with visible error.

- [ ] **Step 4: Commit**

```bash
git commit -m "feat: officer approvals, appointments, and guild announcements"
```

---

### Task 10: Thin Gora + Ceremony stubs

**Files:**
- Create: `Core/Gora.lua`, `Core/Ceremony.lua`
- Modify: `UI/MainFrame.lua` or Standing/Officer area with stub buttons

**Interfaces:**
- `COB.Gora:Challenge(target)`, `COB.Gora:RecordResult(winner, loser, outcome)` → scoring grants both parties (winner win, loser loss)
- `COB.Ceremony:Start(label)`, `COB.Ceremony:Close()` → grant attendees present at close (party/raid guildmates tracked since Start)

- [ ] **Step 1: Implement minimal flows** — no spectacle art; buttons labeled "Record Gora Result" and "Start/Close Ceremony".

- [ ] **Step 2: In-game verify** — recording a loss increases standing by 8; ceremony close grants attendees.

- [ ] **Step 3: Commit**

```bash
git commit -m "feat: thin Gora and ceremony standing stubs"
```

---

### Task 11: Shared instance co-play tracker

**Files:**
- Create: `Core/Instance.lua`
- Modify: TOC, bootstrap to init tracker on login

**Interfaces:**
- On `PLAYER_ENTERING_WORLD` / zone changes: detect instance type dungeon/raid/pvp
- While in qualifying instance with ≥1 guildmate in party/raid: every N seconds (60s) if `UnitAffectingCombat("player")` was true since last bucket → `Scoring:GrantInstanceBucket`
- On dungeon complete / BG end events available on TBC Anniversary: `GrantInstanceComplete` (if event unreliable, skip bonus and keep buckets only — see spec open question #4)

- [ ] **Step 1: Implement with clear comments** isolating API calls for Classic+ port.

- [ ] **Step 2: In-game verify** — enter dungeon with guildmate, enter combat, wait one bucket; standing increases; AFK at entrance does not.

- [ ] **Step 3: Commit**

```bash
git commit -m "feat: track shared instance co-play standing"
```

---

### Task 12: BeefNet + login sync + commit validation

**Files:**
- Create: `Net/BeefNet.lua`, `Net/Sync.lua`, `tests/test_net_validate.lua`
- Modify: TOC, login bootstrap

**Interfaces:**
- `COB.Net:Init()` registers prefix `COB`, listens `CHAT_MSG_ADDON`
- Messages: `HELLO`, `SUGGESTION`, `RANK_COMMIT`, `SYNC_REQUEST`, `SYNC_STATE` (skip noisy `SCORE_EVENT` in V1)
- Payload: `VERSION|TYPE|fields...` colon-delimited, small
- `RANK_COMMIT` applied only if `Officer:IsOfficerName(sender, liveRoster)` and `Ladder:ApplyRemoteCommit` accepts revision
- `Sync:OnLogin` sends `SYNC_REQUEST`; peers answer with jittered `SYNC_STATE` once (suppress if another answered)

- [ ] **Step 1: Offline validation tests** for parse + reject bad rank ids / negative standing / non-officer path (inject roster).

- [ ] **Step 2: Implement Net + Sync** with ChatThrottle-style simple queue: max 1 message / 0.5s outbound.

- [ ] **Step 3: In-game verify**

1. Officer approves on client A → client B (online) updates.
2. Client C offline during commit → on login, sync brings correct rank.
3. Forged commit from member client (temporarily force-send in debug) is ignored by peers.

- [ ] **Step 4: Fill `docs/phases/v1-checklist.md`** with the success criteria from the spec as a checkable list.

- [ ] **Step 5: Commit**

```bash
git commit -m "feat: BeefNet commits and login ladder sync"
```

---

### Task 13: Final polish pass

**Files:**
- Modify: README, TOC file list completeness, remove or harden debug commands
- Modify: ensure missing-media fallbacks (default fonts only in V1 — no custom font required)

- [ ] **Step 1: Walk `docs/phases/v1-checklist.md`** against a real guild night or two-client test; fix blockers only.

- [ ] **Step 2: Confirm Global Constraints** — grep addon tree for Retail-only APIs (`C_Timer` is OK on TBC Anniversary; avoid Dragonflight-only unit APIs). Prefer Classic-safe calls used elsewhere in TBC addons.

- [ ] **Step 3: Commit**

```bash
git commit -m "chore: V1 polish and verification checklist"
```

---

## Self-review (plan vs spec)

| Spec requirement | Task |
|------------------|------|
| 7-rank ladder + titles | 2, 3, 8 |
| Point-driven 1–5; Council seats; unique Prophet | 2, 3, 9 |
| Hybrid suggest → Officer+ approve | 3, 5, 9 |
| Gora / ceremony / instance sources | 4, 10, 11 |
| Anti-AFK + caps | 4, 11 |
| Demotion + announcements | 9 |
| Per-character DB | 6 |
| BeefNet + revision sync | 12 |
| `/beef` visible UI + minimap | 7 |
| Hard safety / TBC-only | Global + 13 |
| Social success criterion | 12 checklist + 9 announce |
| docs canon prose | 2 |
| Classic+ port isolation | 11 comments + Global |

**Placeholder scan:** none intentional; threshold numbers copied from approved spec.

**Type consistency:** `rankId`, `revision`, `standing`, `updatedAt`, `updatedBy` used uniformly; message prefix `COB`.

---

## Execution handoff

Plan complete and saved to `docs/superpowers/plans/2026-07-25-church-of-beef-v1.md`.

**Two execution options:**

1. **Subagent-Driven (recommended)** — dispatch a fresh subagent per task, review between tasks, fast iteration  
2. **Inline Execution** — execute tasks in this session with checkpoints  

Which approach?
