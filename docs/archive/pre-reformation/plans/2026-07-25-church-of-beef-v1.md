# Church of Beef V1 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship a TBC Classic Anniversary addon that shows a 7-rank Church of Beef ladder, accrues standing from thin Gora/ceremony/instance co-play, and surfaces promote suggestions to Officer+.

**Architecture:** Pure Core modules own standing, scoring, and officer checks (testable offline). UI and Net are thin adapters over Core. Machine canon lives in `addon/ChurchOfBeef/Data/Ranks.lua`. Church titles come from the live guild roster (`rankIndex` → `Ranks.ChurchRankIdForGuildIndex`); standing is per-client testimony held in SavedVariables.

**Tech Stack:** Lua 5.1 (WoW), XML optional (Lua `CreateFrame` primary), SavedVariablesPerCharacter, `C_ChatInfo.SendAddonMessage` / Classic-safe addon messaging on `GUILD` with prefix `COB`, Interface `20506`.

**Spec:** `docs/superpowers/specs/2026-07-25-church-of-beef-design.md`

## Status of this document (truth pass, 2026-08-01)

This is the original V1 plan. It has been reality-checked against the shipped tree
and left in place as the record of how V1 was built — it is no longer the forward
roadmap. Read `docs/superpowers/plans/2026-08-01-church-of-beef-leap-forward.md` for
what happens next.

Three things changed under the product after this plan was written, and every stale
paragraph below has been rewritten or marked **Superseded** rather than deleted:

1. **Ranks are roster-backed.** Church titles are read from the live WoW guild roster.
   The addon never commits, demotes, appoints, or bestows a rank. `Ladder:Commit`,
   `Demote`, `AppointCouncil` and `BestowProphet` survive only as explicit refusals so
   stale callers fail closed. Officers promote in the Blizzard guild UI.
2. **The sync subsystem is gone.** `addon/ChurchOfBeef/Net/Sync.lua` was deleted along
   with `SYNC_REQUEST`, `SYNC_STATE` and `RANK_COMMIT`. Those three types are now
   recognized only so an older client's traffic is discarded quietly. There is no
   "syncing" or "synced" UI state; `UI/Status.lua` reports guild membership and roster
   readiness, which are the only mesh facts this client can actually check.
3. **Standing is not synchronized.** Each client keeps its own standing testimony.
   `SUGGESTION` petitions travel over the wire (bound to their sender); standing
   numbers do not. A standing figure that arrives with a petition is stored as
   `claimedStanding` and rendered by the Officer tab as an unverified claim, distinct
   from what the local client can vouch for.

How the checkboxes below were ticked: a box is ticked when the current tree carries
the evidence — the file exists and does the described job, the TOC lists it, the
harness covers it, or the commit is in `git log`. Commit steps are ticked when the
work reached `main`; the literal commit messages quoted below were not always the
ones used. Boxes that need a running client are **unticked**: no in-game walk has
happened yet (`docs/phases/solo-smoke.md` is entirely unticked, and
`docs/phases/v1-checklist.md` has one box filled). Historical "run the test and watch
it fail" steps are unticked too — a red run leaves no artifact in the tree, so there
is nothing here to verify it by.

Offline baseline at the time of this pass: `lua tests/run.lua` → `1468 passed, 0 failed`, exit 0.

## Global Constraints

- Platform: TBC Classic Anniversary only for V1 (`## Interface: 20506`); Classic+ is a future port.
- No Retail-only / Dragonflight-era APIs.
- Lua/XML only; fully in-game; no bots, injection, automated movement/targeting/casting, or protected-action circumvention.
- Addon may announce, track, record, display, coordinate, sync allowed data; must not play the game for anyone.
- Ranks (low→high): Fresh Beef, Cooked Beef, Beef Knight, Beef Lord, Beef Butcher, Beef Council, Beef Prophet.
- Ranks 1–5 point-driven; Beef Council seat-limited appointed; Beef Prophet bestowed unique. Which member holds which title is read from the guild's own rank structure, so seats and uniqueness are the guild's to enforce rather than the addon's.
- Hybrid advancement: addon suggests; a real WoW guild Officer+ promotes in the Blizzard guild UI. The addon never calls a guild promote or demote API.
- Standing is per-client advisory testimony and is never synchronized between clients; the officer reading it, and the guild UI they promote in, are the anti-cheat.
- Machine canon path: `addon/ChurchOfBeef/Data/Ranks.lua` only (not a top-level `canon/`).
- SavedVariables: per-character `ChurchOfBeefDB`.
- BeefNet prefix `COB`, channel `GUILD`. Two live message types: `HELLO` (version fanout) and `SUGGESTION` (a member's own petition). No rank commits, no state replication, no login sync — the guild roster is the authority and needs no protocol.
- Filename casing: `ChurchOfBeef*.lua` consistently.
- Each Dreamscythe / Doomhowl guild runs an independent ladder (no cross-realm state).
- **UI polish:** Tasks 7–10 stay Classic shell + edge toast + officer `/g` — no custom Media/SFX/WA center pulses. Polish claims need critique evidence (UI brief + skill § Polish loop); agents claim `POLISH:CANDIDATE` only. Kill-list governor: `docs/research/agent-polish-vision/49-adversarial-overengineering.md`. Polish evidence ≠ functional complete ≠ V1 complete.

---

## File structure (as shipped)

The original "locked" list is superseded: `Net/Sync.lua` was deleted, and Common,
Roster, Quest and Status were added. `Core/Common.lua` loads immediately after the
canon data and before every other Core module, because all of them read the shared
identity law (`COB.Names`), the two clocks (`COB.Clock`) and the party/raid helpers
(`COB.Group`) from it.

```
Beef_Addon/
  README.md
  docs/
    canon/ranks.md
    phases/v1-checklist.md
    phases/solo-smoke.md
    superpowers/specs/2026-07-25-church-of-beef-design.md
    superpowers/plans/2026-07-25-church-of-beef-v1.md
  tests/
    wow_stub.lua
    wow_ui_stub.lua           # strict widget stub: unknown method = failure
    run.lua
    test_ranks.lua  test_ladder.lua  test_roster.lua  test_scoring.lua
    test_officer.lua  test_db.lua  test_net_validate.lua  test_net_adversarial.lua
    test_ui.lua  test_officer_ui.lua  test_standing_ui.lua  test_minimap.lua
    test_gora_ceremony.lua  test_instance.lua  test_quest.lua
  addon/ChurchOfBeef/
    ChurchOfBeef.toc
    ChurchOfBeef.lua          # bootstrap, slash, event wiring, DB load/save hooks
    Data/Ranks.lua            # machine canon (+ guild rankIndex → Church rank map)
    Core/Common.lua           # NEW: shared names / clocks / group primitives; loads first
    Core/Ladder.lua           # standing records, rite flags, promote suggestions
    Core/Scoring.lua          # points, caps, anti-AFK buckets, history
    Core/Officer.lua          # roster rank-index gate
    Core/Roster.lua           # live guild snapshot → Church ladder view
    Core/Gora.lua             # thin challenge/result → scoring
    Core/Ceremony.lua         # thin start/close → scoring
    Core/Instance.lua         # shared instance co-play tracker
    Core/Quest.lua            # open-world quest fellowship tracker
    Core/DB.lua               # SavedVariables shape + defaults + migrations
    Net/BeefNet.lua           # send/receive, validate, dispatch (HELLO + SUGGESTION)
    UI/MainFrame.lua          # frame shell, tabs
    UI/Status.lua             # honest status chip: guild + roster readiness only
    UI/Announce.lua           # guild-chat liturgy; Deferred, not wired in V1
    UI/LadderTab.lua
    UI/StandingTab.lua
    UI/OfficerTab.lua
    UI/Minimap.lua
    UI/Toasts.lua
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

- [x] **Step 1: Install Lua 5.1 for offline Core tests**

```bash
brew install lua@5.1 || brew install lua
lua -v
```

Expected: a Lua version prints (5.1 preferred; 5.4 is acceptable for our pure-logic tests).

Verified: `lua -v` reports Lua 5.1.5.

- [x] **Step 2: Write TOC**

Create `addon/ChurchOfBeef/ChurchOfBeef.toc`. The load order below is what shipped;
it differs from the original draft because `Core/Common.lua` was added ahead of the
rest of Core, `Net/Sync.lua` was deleted, and `UI/MainFrame.lua` moved above the tabs
that register into it:

```toc
## Interface: 20506
## Title: Church of Beef
## Notes: Social rank ladder and guild spectacle for the Church of Beef.
## Author: Church of Beef
## Version: 0.1.0
## SavedVariablesPerCharacter: ChurchOfBeefDB

Data\Ranks.lua
Core\Common.lua
Core\Ladder.lua
Core\Scoring.lua
Core\Officer.lua
Core\Roster.lua
Core\Gora.lua
Core\Ceremony.lua
Core\Instance.lua
Core\Quest.lua
Core\DB.lua
Net\BeefNet.lua
UI\MainFrame.lua
UI\Status.lua
UI\Announce.lua
UI\LadderTab.lua
UI\StandingTab.lua
UI\OfficerTab.lua
UI\Minimap.lua
UI\Toasts.lua
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

- [x] **Step 3: Write bootstrap**

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

The `COB.Sync:OnLogin()` call the original draft had here is gone with the module.
The shipped bootstrap has since grown past this sketch: the event handler routes into
named `COB:OnLoad` / `OnLogin` / `OnLogout` methods, registers the Instance and Quest
client events on their behalf (Core owns no frames), wires `Ladder:SetOnSuggestion`
to Net so Core never reaches up into the wire, and parses exactly one slash argument
(`/beef minimap`). There is deliberately no debug or force-send subcommand.

- [x] **Step 4: Write README**

Create `README.md` covering: what Church of Beef is, install path (`Interface/AddOns/ChurchOfBeef` from `addon/ChurchOfBeef/`), `/beef`, link to the design spec, hard safety rules (no automation), TBC Anniversary first.

- [x] **Step 5: Write offline stub + runner**

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

The shipped runner has outgrown this sketch in one important way: a missing suite is
now a failure rather than a shrug, and any `tests/test_*.lua` on disk that is not in
the suite list is also a failure. The tolerant version above meant deleting a test
file turned the run green.

- [ ] **Step 6: Smoke-load in game (manual)**

Copy `addon/ChurchOfBeef` into the TBC Anniversary `Interface/AddOns/` folder. Launch client. Confirm addon appears as **Church of Beef**. Type `/beef`. Expected chat: `Church of Beef: UI not ready yet. (0.1.0)`.

Unticked: no in-game load has been recorded. The expected chat line no longer applies
either — the UI exists now, so `/beef` opens the frame. The current version of this
check is step 1 of `docs/phases/solo-smoke.md`, which is also unticked.

- [x] **Step 7: Commit**

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

Shipped canon has since gained two helpers this plan did not anticipate:
`ChurchRankIdForGuildIndex(rankIndex)`, the fixed guild-rank-to-Church-title map that
makes the ladder roster-backed, and `NeedsRite(toRankId)`, the advisory rite flag the
Officer tab shows as an eligibility checklist. Every number in the original test below
still holds.

- [x] **Step 1: Write failing test**

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

Unticked: a red run leaves nothing behind to verify it by. The green half is covered
by the harness passing today.

- [x] **Step 3: Implement ranks data**

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

- [x] **Step 4: Write prose mirror**

Create `docs/canon/ranks.md` describing each title in Church voice (1–2 sentences each). **Do not duplicate numeric thresholds** — point readers at `Data/Ranks.lua`.

- [x] **Step 5: Update TOC + run tests**

Add `Data\Ranks.lua` above `ChurchOfBeef.lua` in the TOC. Run:

```bash
lua tests/run.lua
```

Expected: ranks assertions pass.

- [x] **Step 6: Commit**

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

**Interfaces:** (as shipped — the commit/seat half below is superseded)
- Consumes: `COB.Ranks`, `COB.Names`/`COB.Clock` (Core/Common), `COB.Roster`
- Produces:
  - `COB.Ladder:GetRecord(name) -> { name, rankId, standing, knighted, goraLordWin, ... }` — `rankId` is read from the live roster, never from stored state
  - `COB.Ladder:GetStanding(name)` / `SetStanding(name, standing)` (local testimony)
  - `COB.Ladder:MaybeSuggest(name) -> suggestion|nil, isNew` (only for the point-driven rank above the member's mapped guild rank)
  - `COB.Ladder:ImportSuggestion(petition) -> suggestion|nil, isNew|err` — a petition heard over the wire; the wire's standing figure is kept as `claimedStanding`, never adopted
  - `COB.Ladder:GetSuggestions()` / `HasSuggestion(name)` / `RejectSuggestion(name)` (aliased `DismissSuggestion`)
  - `COB.Ladder:CorrectStanding(name, standing)` — officer correction; also drops a pending petition the correction disqualifies
  - `COB.Ladder:HasRiteFlag(name, flag)` / `SetRiteFlag(name, flag, value)` for the advisory `knighted` / `goraLordWin` checklists
  - `COB.Ladder:SetOnSuggestion(fn)` — observer wired by the bootstrap so Core never calls Net
  - `COB.Ladder:SweepDeparted(now)` — prunes standing for members gone from a complete roster past the grace period
  - `COB.Ladder:GetLadderView()` — a facade over `Roster:GetLadderView()`
  - `COB.Ladder:ImportState/ExportState` and `ImportSuggestions/ExportSuggestions`

**Superseded:** `Commit`, `ApplyRemoteCommit`, `Demote`, `AppointCouncil` and
`BestowProphet` no longer do anything. Church titles come from the live guild roster,
so the addon has no business writing one. All five survive as explicit refusals that
return `nil, "ranks come from the guild roster — promote in the guild UI"`, kept on
purpose so any stale caller or test fails closed instead of writing a fake rank into
SavedVariables. The revision-number machinery they existed to carry is gone with them.
Council seat limits and Prophet uniqueness are now expressed by the guild's own rank
structure rather than enforced here.

- [x] **Step 1: Write failing tests**

`tests/test_ladder.lua` exists and is comprehensive, but it was rewritten for the
roster-backed model: the commit / remote-revision / seat-limit assertions sketched
below have been replaced by ones covering suggestions, claimed-versus-verified
standing, casing-variant merges and the departed sweep.

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

Unticked for the same reason as Task 2 Step 2: a red run leaves no artifact behind.

- [x] **Step 3: Implement Ladder.lua**

Implement `addon/ChurchOfBeef/Core/Ladder.lua` matching the interfaces above:

- Internal store: `self.records[key]`, `self.suggestions[key]`, keyed by `COB.Names.Key` (trim → strip realm → lowercase) so one member cannot fragment into three records; the display spelling is kept alongside
- `MaybeSuggest`: only if the member's *roster-mapped* rank is point-driven and standing >= next point-driven threshold; never suggests 6/7; refuses entirely until the roster knows the member
- `ImportSuggestion`: re-derives the target rank from this client's own roster read, stores the wire's number as `claimedStanding`, and recomputes `standingMet` from the local record
- `CorrectStanding`: clears a pending petition the correction pushes back below threshold
- `ResetForTests` clears stores (tests only; no-op harmful in game if called — gate with `COB._IN_TEST`)

Set `COB._IN_TEST = true` at top of `tests/run.lua` before requiring suites.

**Superseded** in the shipped module: the revision / `updatedAt` / `updatedBy` bump on
commit, the `AppointCouncil` seat count against `rankId == 6`, the `BestowProphet`
uniqueness check, and the `ApplyRemoteCommit` merge rules. `GetRecord` still returns
`revision`, `updatedAt` and `updatedBy` fields, but they are inert zeros kept only so
older readers do not index nil.

- [x] **Step 4: Run tests**

```bash
lua tests/run.lua
```

Expected: ladder suite passes.

- [x] **Step 5: Commit**

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

**Interfaces:** (as shipped)
- Consumes: `COB.Ladder`, `COB.Ranks`, `COB.Names`/`COB.Clock`
- Produces:
  - `COB.Scoring:Grant(name, source, amount, now) -> grantedAmount, err`
  - `COB.Scoring:GrantInstanceBucket(name, now, inCombat, instanceType) -> grantedAmount` (0 if not inCombat; raids pay more per bucket)
  - `COB.Scoring:GrantBattlegroundEnd(name, now) -> grantedAmount`
  - `COB.Scoring:GrantQuestBucket(name, now, active) -> grantedAmount`
  - `COB.Scoring:GrantGora(name, outcome, now)` outcome = `"win"|"loss"|"draw"`
  - `COB.Scoring:GrantCeremony(name, now)`
  - `COB.Scoring:GetDayKey(now) -> string`, `GetGranted` / `GetRemaining`, `GetHistory(name)`
  - Constants in module: instance bucket 5 pts, raid bucket 12, battleground end 20, quest bucket 3, ceremony 40, gora win 15 / draw 8 / loss 5; daily caps instance 60, ceremony 80, gora 40, quest 24

**Superseded:** `Points.InstanceComplete` and `Points.RaidComplete` were both removed,
along with `GrantInstanceComplete`. TBC hands this client no dependable dungeon or
raid completion signal — there is no LFG completion reward, and a final boss kill is
not an end-of-run event — so a completion number for dungeons and raids was a payout
nothing could ever reach. `Points.BattlegroundEnd` is the one surviving completion
bonus, because a locked battleground scoreboard is readable via
`GetBattlefieldWinner()`. Dungeons and raids are paid entirely by their buckets.

The daily caps also moved from the draft: the gora ceiling dropped from 100 to 40 so
that playing together out-earns two members typing results at each other, and quest
fellowship was added as a separate, stricter source.

- [x] **Step 1: Write failing tests**

`tests/test_scoring.lua` exists. The numbers in the sketch below are stale — the suite
now asserts, among other things, that `Points.RaidComplete` and
`Points.InstanceComplete` are nil and that `GrantInstanceComplete` no longer exists.

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

A Gora loss now pays 5, not 8. The principle the assertion was written for — losses
must pay something, or members dodge challenges — still holds.

- [x] **Step 2: Run fail, implement Scoring.lua, run pass**

`Grant` must clamp to remaining daily cap for that `source`, then `Ladder:SetStanding` and `Ladder:MaybeSuggest`.

- [x] **Step 3: Commit**

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

- [x] **Step 1: Tests**

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

- [x] **Step 2: Implement + commit**

```lua
-- Core/Officer.lua sketch
function COB.Officer:IsOfficerIndex(rankIndex)
  if rankIndex == nil then return false end
  return rankIndex <= COB.Ranks.OfficerRankIndexMax
end
```

In-game helper `COB.Officer:LocalIsOfficer()` uses live roster; never approve if roster unavailable.

The shipped module also carries `IsGuildRosterName` (membership, not authority — rites
need to know a subject is a real person), a roster rank-index cache refreshed once per
`GUILD_ROSTER_UPDATE`, and `GetRosterLookup`, which reads the cache at call time rather
than at closure time so a lookup captured before a refresh cannot keep vouching for an
officer the guild has since demoted. Name matching goes through the shared identity law
in `Core/Common.lua`, which is what stops a realm suffix reading as "not an officer".

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
  version = 4,
  ui = { point = nil, shown = false, announce = true, minimapAngle = nil },
  ladder = { records = {}, suggestions = {} },
  scoring = { dayKey = "", granted = {}, history = nil },
}
```

Schema history, all handled by ordered migrations in `applyDefaults`: v2 stripped the
legacy official-rank fields from standing rows once ranks became roster-backed, v3
added the advisory rite flags, and v4 introduced the single identity law — duplicate
spellings of one member are merged on the way in by `Ladder:ImportState` (highest
standing wins, rites union), so nobody loses points to the migration. `ladder.records`
now hold standing and rite flags only; `scoring.history` persists the local player's
recent grants so the My Standing list survives a `/reload`.

- [x] **Step 1: Implement Init** — if `ChurchOfBeefDB` nil, create defaults; call `Ladder:ImportState` / scoring import; never wipe unknown future keys.

- [ ] **Step 2: In-game verify** — `/reload` preserves standing after a `/beef` session once UI exists (full verify after Task 7). For now, unit-level: after Init with a fake global, records round-trip.

Half done, so left unticked. The unit-level round-trip is covered by `tests/test_db.lua`
in the green harness; the `/reload` half needs a client and has not been walked.

- [x] **Step 3: Commit**

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

> Acceptance: offline (if Core/Data touched) + in-game `/reload` path + UI brief anti-patterns. No Media/SFX. Polish taste loops use skill § Polish loop — not “chore then claim polished.”

- [x] **Step 1: Implement MainFrame** with three tab buttons (Ladder / My Standing / Officer). Officer tab button hidden unless `COB.Officer:LocalIsOfficer()`.

All three tabs register themselves into `UI:RegisterTab`; the Officer definition
carries `officerOnly = true`. The frame is movable, clamped to screen, and writes its
position to `ChurchOfBeefDB.ui.point`. `UI/Status.lua` owns the status chip.

- [x] **Step 2: Minimap button** toggles frame (use a basic `Minimap` child button; no external lib).

The button also drags to reposition, persisting `ChurchOfBeefDB.ui.minimapAngle`, and
`/beef minimap` shows or hides it — without that, hiding the button would remove the
only way to bring it back.

- [ ] **Step 3: In-game verify**

1. `/beef` opens a visible frame (not chat-only).
2. Frame is movable and stays on screen.
3. `/reload` restores position.
4. Minimap button toggles frame.
5. Non-officer does not see Officer tab.

Unticked: needs a client. Covered offline only, by `tests/test_ui.lua` and
`tests/test_minimap.lua` under the strict widget stub. The live version of this list
is step 2 of `docs/phases/solo-smoke.md`.

- [x] **Step 4: Commit**

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

- [x] **Step 1: Implement LadderTab** — for each rank id 7→1, show title and occupants. Highlight player line.

Occupants come from `Roster:GetLadderView()`, not from stored records. The tab has
since grown well past comma-separated names: bands expand into a scrollable inline
list via a clickable `+N more`, a Find box narrows names, and band buckets are
memoized per roster generation so a large guild does not re-sort on every repaint.

- [x] **Step 2: Implement StandingTab** — show standing, current title, next point-driven threshold (or "Appointed ranks only" if already Butcher+), last ~10 grant lines from `COB.Scoring:GetHistory(name)`.

Add `GetHistory` to Scoring if missing (ring buffer max 20).

The tab also hosts the thin Gora and ceremony controls from Task 10, and gates itself
when the player is not in a guild.

- [ ] **Step 3: In-game verify** — with forced test standing via a temp `/beef debug standing 50` **dev-only** command behind `COB.DEBUG = true` default false; document enabling it. Prefer officer commit path once Task 9 exists; for this task, a debug grant is acceptable if removed or gated before release.

**Superseded, and unticked.** No debug command exists or will: the slash handler
deliberately parses exactly one argument (`/beef minimap`) and treats everything else
as "open the window", so no force-send or debug-grant path can ship noise to a guild.
The replacement way to move a member's standing is the Officer tab's standing
correction, or a real Gora or ceremony — which is what step 5 of
`docs/phases/solo-smoke.md` walks.

- [x] **Step 4: Commit**

```bash
git commit -m "feat: render ladder and personal standing tabs"
```

---

### Task 9: Officer tab (dismiss, correct standing, rite evidence)

> **This task's original prose predated the roster-backed ladder and has been
> rewritten.** The heading used to read "approve, reject, correct, demote, appoint,
> bestow". Approve, demote, appoint and bestow no longer exist anywhere in the addon:
> officers change ranks in the Blizzard guild UI, and the Ladder follows on the next
> roster refresh. What the tab does now is help an officer decide, then get out of the
> way. The original approve/announce design is preserved below under **Superseded**.

**Files:**
- Modify: `UI/OfficerTab.lua`
- Create: `UI/Announce.lua`

**Interfaces:** (as shipped)
- Consumes: `Ladder:GetSuggestions` (the promote queue); `Ladder:DismissSuggestion`; `Ladder:CorrectStanding`; `Ladder:HasRiteFlag`; `Officer:LocalIsOfficer`
- Produces: no wire traffic and no guild chat. Dismissing or correcting is a local act; the roster remains the only thing that moves a title.

- [x] **Step 1: Implement officer list UI**

A scrollable promote queue, one row per petition, each with **Dismiss** and copy
telling the officer to promote in the guild roster. Alongside it: a standing
correction control (+/− against a named subject), an evidence panel showing the
Knight/Lord rite checklist for the petition's target rank, and a recent-actions log.

The queue distinguishes what this client can vouch for from what it merely heard. A
petition raised locally carries verified standing; one that arrived over the wire
renders its number as a claim ("claims N"), because standing is per-client testimony
and the wire is not entitled to assert it.

**Superseded:** Approve-commit per suggestion, the Demote dropdown for ranks 1–5,
Appoint Council and Bestow Prophet. None of these are present, and the Core functions
behind them are refusals (see Task 3). `docs/phases/v1-checklist.md` criterion 7 is
the acceptance test for their absence.

- [x] **Step 2: Implement Announce.lua**

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

The file exists with its copy, its length check and its repeat throttle, but it is
**not wired in V1 and is gated so it cannot be wired by accident**: the module sets
`Deferred = true` and `IsEnabled()` returns false while that holds, whatever the
member's saved preference says. There is no promotion event on this client to
announce — an officer promotes in the guild UI, and the only honest trigger would be a
roster-diff announcer that does not exist yet. The Officer tab keeps the announce
checkbox hidden until that day. Shipped demotion copy is "The Church records the fall
of %s, returned to %s."

- [ ] **Step 3: In-game verify** (two characters if possible)

1. Member crosses threshold → suggestion appears for officer.
2. Officer promotes that member one step in the Blizzard guild roster → the Ladder moves the name on roster refresh and the suggestion auto-clears.
3. Non-officer cannot reach the actions (tab hidden).
4. Dismiss clears a petition and leaves standing untouched.
5. A petition whose subject does not match its sender never reaches the queue.

Unticked: needs a client, and items 1, 2 and 4 need `docs/phases/solo-smoke.md` steps
5–7 while item 5 needs the two-client walk. Rewritten from the original list, whose
items 2, 4 and 5 tested the approve-commit, Council-seat and Prophet-uniqueness paths
that no longer exist.

- [x] **Step 4: Commit**

```bash
git commit -m "feat: officer approvals, appointments, and guild announcements"
```

---

### Task 10: Thin Gora + Ceremony stubs

**Files:**
- Create: `Core/Gora.lua`, `Core/Ceremony.lua`
- Modify: `UI/MainFrame.lua` or Standing/Officer area with stub buttons

**Interfaces:** (as shipped)
- `COB.Gora:Challenge(target, challenger, now)`, `COB.Gora:RecordResult(winner, loser, outcome, now)` → scoring grants both parties (winner win, loser loss). Both names must be guildmates on a complete roster, and a pair pays at most once an hour: a Gora is two members typing at each other, so its integrity has to come from shape rather than proof.
- `COB.Ceremony:Start(label, roster, now, kind)`, `COB.Ceremony:Close(roster, now)` → grant attendees present at close (party/raid guildmates tracked since Start). `kind` is an explicit field (`Rite` or `Knighting`) rather than a substring match on the label, so a memorial cannot accidentally hand out a knighthood.

- [x] **Step 1: Implement minimal flows** — no spectacle art; buttons labeled "Record Gora Result" and "Start/Close Ceremony".

Both buttons live on the My Standing tab.

- [ ] **Step 2: In-game verify** — recording a loss increases standing by 5; ceremony close grants attendees.

Unticked: needs a client. A loss pays 5, not the 8 this step originally named. Covered
offline by `tests/test_gora_ceremony.lua`; the live version is step 5 of
`docs/phases/solo-smoke.md`.

- [x] **Step 3: Commit**

```bash
git commit -m "feat: thin Gora and ceremony standing stubs"
```

---

### Task 11: Shared instance co-play tracker

**Files:**
- Create: `Core/Instance.lua`
- Modify: TOC, bootstrap to init tracker on login

**Interfaces:** (as shipped)
- On `PLAYER_ENTERING_WORLD` / zone changes / `GROUP_ROSTER_UPDATE`: detect instance type dungeon/raid/pvp
- While in qualifying instance with ≥1 guildmate in party/raid: every closed 60s bucket the player fought in → `Scoring:GrantInstanceBucket`. The ticker samples twice per bucket on purpose; a ticker whose period equals the bucket length only has to fire a few milliseconds early for the elapsed check to miss, and an hour of play then pays for half an hour.
- On battleground end (`UPDATE_BATTLEFIELD_STATUS` with `GetBattlefieldWinner()` non-nil): `GrantCompletion`, paying `Points.BattlegroundEnd` out of the shared instance cap.

Spec open question #4 resolved the way the parenthetical anticipated: TBC has no
dependable dungeon or raid completion signal, so **dungeons and raids are paid
entirely by their buckets** and no completion number for them exists in `Points` to
promise a payout nothing can reach. A locked battleground scoreboard is the one run
this client can prove finished, so it is the only completion bonus.

- [x] **Step 1: Implement with clear comments** isolating API calls for Classic+ port.

`Core/Quest.lua` shipped alongside it on the same shape for open-world quest
fellowship. Both keep every client API behind a `type()` guard, listed in the file
header, so a host that renames one degrades to "never qualifies" instead of erroring
on a timer.

- [ ] **Step 2: In-game verify** — enter dungeon with guildmate, enter combat, wait one bucket; standing increases; AFK at entrance does not.

Unticked: needs a client and a guildmate. Covered offline by `tests/test_instance.lua`
and `tests/test_quest.lua`, which inject state rather than reading the client.

- [x] **Step 3: Commit**

```bash
git commit -m "feat: track shared instance co-play standing"
```

---

### Task 12: BeefNet + petition fanout + inbound validation

> **The sync half of this task is superseded.** `Net/Sync.lua` has been deleted, and
> with it `SYNC_REQUEST`, `SYNC_STATE`, `RANK_COMMIT`, `Sync:OnLogin`, the jittered
> reply-suppression dance, and `Net:SendRankCommit`. Under a roster-backed ladder
> there is no shared state to reconcile: every client reads the same guild roster, so
> a protocol that replicated ranks would be inventing an authority the guild already
> has. Login emits no `SYNC_REQUEST`. The original design is kept below so the
> reasoning behind its removal stays legible.

**Files:**
- Create: `Net/BeefNet.lua`, `tests/test_net_validate.lua` (plus `tests/test_net_adversarial.lua`)
- Modify: TOC, login bootstrap

**Interfaces:** (as shipped)
- `COB.Net:Init()` registers prefix `COB`, listens `CHAT_MSG_ADDON`, `GUILD_ROSTER_UPDATE` and `PLAYER_GUILD_UPDATE`
- Live messages: `HELLO` (version fanout) and `SUGGESTION` (a petition) only. `RANK_COMMIT`, `SYNC_REQUEST` and `SYNC_STATE` are listed as **retired types** purely so an older client's traffic is discarded quietly instead of counting as garbage; they are never acted on.
- Payload: `VERSION:TYPE:fields...` colon-delimited, ≤240 bytes of the 255-byte envelope
- `SUGGESTION` is accepted only if the subject matches the sender. `CHAT_MSG_ADDON` sender names come from the server and cannot be forged, so binding subject to sender is what stops any member putting an arbitrary name and an arbitrary number in front of every officer in the guild. The standing figure that rides along is stored as a claim, never adopted as fact.
- Petitions that arrive before the guild roster has finished streaming are held (bounded) and replayed once it can answer "is this a real member".

- [x] **Step 1: Offline validation tests** for parse + reject bad rank ids / negative standing / non-officer path (inject roster).

`tests/test_net_validate.lua` covers the parse surface and the quiet discard of the
three retired types. `tests/test_net_adversarial.lua` adds the attacks: a petition
whose subject is not its sender, a spoofed standing claim, a `SUGGESTION` flood
against the inbound limiter, and a realm-collision against the officer gate.

- [x] **Step 2: Implement Net** with ChatThrottle-style pacing.

Shipped pacing is a token bucket shaped like the thing it protects — burst 10,
refilling at one per second — rather than the fixed one-per-half-second gap this step
originally specified, which sustained twice the client's refill rate and eventually
got messages dropped with no way for us to know. There is also a per-sender inbound
bucket (burst 5, one per five seconds) so one client with a stuck loop cannot drive
every officer's toast queue, and UI repaints are coalesced to at most ten a second
instead of one full ladder rebuild per message. The `Net/Sync.lua` half of this step
is superseded and was deleted.

- [ ] **Step 3: In-game verify**

1. Member crosses a threshold on client A → an Officer+ on client B sees the petition and an edge toast.
2. A petition whose subject is not its sender is refused by the receiver.
3. A peer on a different protocol version produces one soft version warning, not a stream.

Unticked: this is the two-client walk, and it has not happened. Rewritten from the
original list, whose three items all tested rank commits and login sync — client B
receiving a commit, client C catching up on login, and a forged commit being ignored.
None of those paths exist: no rank ever travels the wire, so there is nothing to
catch up on and no commit to forge. The forged-input concern survives as item 2,
against petitions instead of commits.

- [x] **Step 4: Fill `docs/phases/v1-checklist.md`** with the success criteria from the spec as a checkable list.

Filled, and rewritten against the roster-backed amendment. Filling it is not walking
it — that is Task 13 Step 1, and its boxes are still open.

- [x] **Step 5: Commit**

```bash
git commit -m "feat: BeefNet commits and login ladder sync"
```

---

### Task 13: Final polish pass

**Files:**
- Modify: README, TOC file list completeness, remove or harden debug commands
- Modify: ensure missing-media fallbacks (default fonts only in V1 — no custom font required)

> Not an art/Media commission. Gated polish slices + human social check (§13.11). Agent polish evidence (`POLISH:CANDIDATE`) does not tick V1 complete — walk the checklist with a human.

- [ ] **Step 1: Walk `docs/phases/v1-checklist.md`** against a real guild night or two-client test; fix blockers only.

Unticked, and this is the load-bearing one: the checklist has a single box filled (the
vacuous missing-media check) out of twenty-odd. `docs/phases/solo-smoke.md` is the
single-client pack to walk first.

- [ ] **Step 2: Confirm Global Constraints** — grep addon tree for Retail-only APIs (`C_Timer` is OK on TBC Anniversary; avoid Dragonflight-only unit APIs). Prefer Classic-safe calls used elsewhere in TBC addons.

Partly covered, so left unticked. `tests/wow_ui_stub.lua` is now a strict widget stub
that whitelists known 2.5.x widget methods and fails on anything else, which catches
Retail widget-API misuse as the UI is written rather than in the client. That is not
the same as a deliberate sweep of the whole tree, and it says nothing about non-widget
globals.

- [x] **Step 3: Commit**

```bash
git commit -m "chore: V1 polish and verification checklist"
```

---

## Self-review (plan vs spec)

Requirements marked **superseded** were satisfied differently, or dropped, under the
roster-backed amendment.

| Spec requirement | Task |
|------------------|------|
| 7-rank ladder + titles | 2, 3, 8 |
| Point-driven 1–5; Council seats; unique Prophet | 2, 3 (superseded: seats and uniqueness are the guild's rank structure, not addon rules) |
| Hybrid suggest → Officer+ promotes in the guild UI | 3, 5, 9 |
| Gora / ceremony / instance sources | 4, 10, 11 |
| Anti-AFK + caps | 4, 11 |
| Demotion + announcements | superseded: demotion happens in the guild UI; announce is deferred until a roster-diff announcer exists |
| Per-character DB | 6 |
| BeefNet petition fanout | 12 (superseded: no revision sync) |
| `/beef` visible UI + minimap | 7 |
| Hard safety / TBC-only | Global + 13 |
| Social success criterion | 12 checklist + criterion 11 (a suggestion acted on in the guild UI, Ladder visibly moves) |
| docs canon prose | 2 |
| Classic+ port isolation | 11 comments + Global |

**Placeholder scan:** none intentional; threshold numbers copied from approved spec.

**Type consistency:** `rankId`, `standing`, `toRankId`, `claimedStanding` used uniformly; message prefix `COB`. `revision`, `updatedAt` and `updatedBy` survive only as inert fields on `GetRecord` output (see Task 3).

---

## Execution handoff

Plan complete and saved to `docs/superpowers/plans/2026-07-25-church-of-beef-v1.md`.

**Two execution options:**

1. **Subagent-Driven (recommended)** — dispatch a fresh subagent per task, review between tasks, fast iteration  
2. **Inline Execution** — execute tasks in this session with checkpoints  

Which approach?
