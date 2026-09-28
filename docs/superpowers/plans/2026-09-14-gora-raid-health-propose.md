# Gora raid-health proposer Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.
>
> **Do not start this plan until David explicitly approves it.** No addon Lua, no install, no commits until that approval.

**Goal:** While a Beef Gora is sanctioned, the Pope client treats a raid/party fighter sitting at **1 hit point** (the other still above 1) as a knockout suspect, stores that as `Gora:Propose`, and arms **DECLARE VICTOR** — without writing the record, announcing, or needing the loser to run the addon.

**Architecture:** Pure Core guess (`Gora.GuessKnockout` / `Gora:ConsiderRaidHealth`) calls existing `Gora:Propose`. The Fight HUD already binds raid tokens and reads `UnitHealth`; it passes **raw** current HP, never percent. Console reads `GetProposal()` and pre-selects the proposed winner. Bootstrap refreshes the console and persists the Pope desk; it does **not** `sendState` or `Proclaim` on Propose. Congregation HUD never paints a winner.

**Tech Stack:** Lua 5.1, `ChurchOfBeef` / `COB`, Interface `20506`, `lua tests/run.lua`, Anniversary install via `.agents/skills/church-of-beef-dev/SKILL.md`.

**Product law:** Bible §10.8 / Law 4 (propose, Pope ratifies); Law 5 (no peer self-reported authority); Law 8 (unmodified duel, no CLEU analytics); A02 Result stays **NOT RUN** (chat parser parked).

## Global Constraints

- Bible v1.1.1 wins. Do not invent OPEN_QUESTIONS answers.
- `Gora:DeclareVictor` / `CowardiceRecorded` / `Void` / `FreeRuling` remain the only Store writers for outcomes.
- `Gora.ParseDuel` / `ParseChat` / `AutoDeclare` stay nil. No `CHAT_MSG_SYSTEM`. No COMBAT_LOG. No `StartDuel` / `AcceptDuel`.
- No “I lost” INPUT this plan. Fighters without the addon are in scope via raid `UnitHealth` on the Pope (or any client that has a local sanctioned pair — only the Pope writer does).
- Knockout floor is **raw `UnitHealth == 1`**, not 0%, not `percent == 0`. Dead (`cur == 0`) is not a knockout propose.
- Proposal is Pope-local: no winner on BeefNet / STATE until the Pope ratifies.
- HUD `GetView().winner` stays nil unless a winner id is already on Pope STATE (it is not).
- UI → Core; Core never `CreateFrame` or `UnitHealth`.
- `lua tests/run.lua` exit 0 after every Core/UI/glue task. TOC unchanged. Interface `20506`.
- Never touch player `WTF/`. Agents do not tick A02 Result or claim POLISH:PASS / MVP complete.
- Commits only if David asked for commits in the execution session.

---

## Design (approved hybrid)

```
UNIT_HEALTH (HUD, raid/party tokens)
    → raw curA / curB
    → Gora:ConsiderRaidHealth(curA, curB)
        → GuessKnockout: exactly one side == 1, other > 1
        → Propose({ ruling = "victor", winnerId, loserId, source = "raid-health" })
    → wrapAfter Propose: persist gora blob + Console:Refresh
    → selectedWinnerId armed when nil
    → Pope taps DECLARE VICTOR
    → Store write + Proclaim + STATE (existing wrap)
```

**Best case:** both fighters in the local raid/party. Loser at 1 HP. Console already has the other name. Pope glances and taps.

**Misses (stay manual):** flee, disconnect, unbound fighter, both at 1, both above 1, either at 0 (dead), Pope not grouped with the pair.

**Parked (do not build):** loser “I lost” INPUT; `CHAT_MSG_SYSTEM` / A02 parser; congregation “proposed” HUD chrome.

**1 HP vs 1%:** a normal duel ends at one hit point (warcraft.wiki.gg/wiki/Dueling). Our HUD percent of `1/8000` already paints 0%. Detection must use raw current HP. In-game smoke dumps `UnitHealth` on the loser once; if Anniversary is not 1, stop and tell David — do not silently switch to 0.

---

## File map

| File | This plan |
|------|-----------|
| `addon/ChurchOfBeef/Core/Gora.lua` | `GuessKnockout`, `ConsiderRaidHealth`; Snapshot/Restore `proposal` |
| `tests/test_gora.lua` | Core pins; still no `ParseDuel` |
| `addon/ChurchOfBeef/UI/Console.lua` | Arm `selectedWinnerId`; target-line copy when a proposal exists |
| `tests/test_console.lua` | Target line + DeclareVictor without a new target |
| `addon/ChurchOfBeef/ChurchOfBeef.lua` | `wrapAfter(Propose)` refresh console only; `persistWrites` includes Propose |
| `tests/test_wire_glue.lua` | Propose does not Proclaim / send STATE |
| `addon/ChurchOfBeef/UI/Hud.lua` | Raw vitals; call `ConsiderRaidHealth` when both units bound |
| `tests/test_hud.lua` | 1 HP proposes; 20 HP does not; `cur == 0` does not |
| `docs/validation/A02-duel-messages.md` | Leftover only: raid-health proposer may ship; Result stays NOT RUN |

No new TOC file. Schema stays **7** (proposal is a field on the existing `db.gora` snapshot).

---

### Task 1: Core knockout guess and ConsiderRaidHealth

**Files:**
- Modify: `addon/ChurchOfBeef/Core/Gora.lua` (after `GetProposal`, before `writeBoth`)
- Test: `tests/test_gora.lua`

**Interfaces:**
- Consumes: `Gora:Propose` / `GetProposal` / `GetSanctioned` (existing)
- Produces: `Gora.GuessKnockout(curA, curB)` → `"A"` \| `"B"` \| `nil` (winner **side**); `Gora:ConsiderRaidHealth(curA, curB)` → proposal table or `nil, err`

- [x] **Step 1: Write the failing tests** in `tests/test_gora.lua` after the existing Propose block (~line 407). Keep `assert_eq(Gora.ParseDuel, nil, "no duel-chat parser")`.

```lua
assert_eq(type(Gora.GuessKnockout), "function", "GuessKnockout is a pure helper")
assert_eq(type(Gora.ConsiderRaidHealth), "function", "ConsiderRaidHealth is a verb")
assert_eq(Gora.GuessKnockout(1, 40), "B", "1 HP on A and living B proposes B")
assert_eq(Gora.GuessKnockout(40, 1), "A", "1 HP on B and living A proposes A")
assert_eq(Gora.GuessKnockout(0, 40), nil, "dead A is not a duel knockout")
assert_eq(Gora.GuessKnockout(1, 1), nil, "both at the floor is ambiguous")
assert_eq(Gora.GuessKnockout(20, 40), nil, "neither at the floor is not a knockout")
assert_eq(Gora.GuessKnockout(1, 0), nil, "dead partner is not a knockout")
assert_eq(Gora.GuessKnockout(nil, 40), nil, "missing reading A is not a knockout")
assert_eq(Gora.GuessKnockout(1.0, 40), "B", "integer 1.0 still counts as the floor")

Gora:ResetForTests()
assert_true(Runtime:StartEvent() ~= nil, "knockout event starts")
local ka = Store:CreateCharacter({ name = "KnockA", class = "Warrior", level = 70 })
local kb = Store:CreateCharacter({ name = "KnockB", class = "Mage", level = 70 })
assert_true(Gora:Sanction(ka.id, kb.id) ~= nil, "knockout pair is sanctioned")
local first, firstErr = Gora:ConsiderRaidHealth(1, 80)
assert_true(first ~= nil, "ConsiderRaidHealth proposes on a clean 1 HP")
assert_eq(firstErr, nil, "clean knockout has no error")
assert_eq(first.ruling, "victor", "raid-health proposal is a victor draft")
assert_eq(first.winnerId, kb.id, "the living fighter is the proposed winner")
assert_eq(first.loserId, ka.id, "the 1 HP fighter is the proposed loser")
assert_eq(first.source, "raid-health", "source is raid-health")
assert_eq(Store:GetCharacter(ka.id).gora.wins, 0, "ConsiderRaidHealth does not write wins")
assert_eq(Store:GetCharacter(ka.id).gora.losses, 0, "ConsiderRaidHealth does not write losses")
assert_eq(Gora:GetProposal().winnerId, kb.id, "GetProposal holds the draft")

local again, againErr = Gora:ConsiderRaidHealth(1, 80)
assert_eq(again, nil, "duplicate knockout does not re-Propose")
assert_eq(againErr, "already proposed", "duplicate knockout is already proposed")
assert_eq(Gora:GetProposal().winnerId, kb.id, "duplicate leaves the same draft")

local flip = Gora:ConsiderRaidHealth(80, 1)
assert_eq(flip.winnerId, ka.id, "a later opposite floor replaces the draft")
assert_eq(Gora:GetProposal().winnerId, ka.id, "GetProposal follows the later floor")

Gora:ResetForTests()
assert_eq(Gora:ConsiderRaidHealth(1, 80), nil, "no sanctioned pair refuses")
```

Use the suite’s existing `twoChars` / sanction helpers if they exist in `test_gora.lua`; do not invent a second Store. Collapse the flip case into one sanctioned pair as shown in the second block. Delete the contradictory “Wait” comments from the test file — they are plan notes only.

- [x] **Step 2: Run the Gora suite to verify it fails**

```bash
lua tests/test_gora.lua
```

Expected: FAIL — `GuessKnockout` / `ConsiderRaidHealth` are nil.

- [x] **Step 3: Implement the minimal Core**

In `addon/ChurchOfBeef/Core/Gora.lua`, after `GetProposal`:

```lua
Gora.DUEL_FLOOR = 1

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
```

Do not call `DeclareVictor`. Do not read `UnitHealth` in Core.

- [x] **Step 4: Run the Gora suite**

```bash
lua tests/test_gora.lua
```

Expected: `Tests finished: N passed, 0 failed`.

- [ ] **Step 5: Commit** (only if David asked for commits)

```bash
git add addon/ChurchOfBeef/Core/Gora.lua tests/test_gora.lua
git commit -m "$(cat <<'EOF'
feat: draft a Gora victor from raid 1 HP, without recording it

EOF
)"
```

---

### Task 2: Persist the proposal across Pope reload

**Files:**
- Modify: `addon/ChurchOfBeef/Core/Gora.lua` (`Snapshot` ~651, `Restore` ~686)
- Test: `tests/test_gora.lua` (Snapshot / Restore block ~897)

**Interfaces:**
- Consumes: Task 1 proposal table `{ ruling, winnerId, loserId, source }`
- Produces: `Gora:Snapshot().proposal` copy; `Restore` reapplies a table proposal whose `winnerId` is a sanctioned fighter

- [x] **Step 1: Write the failing tests** in the existing Snapshot / Restore section, while a pair is still sanctioned (before the `DeclareVictor after Restore` pins):

```lua
assert_true(Gora:ConsiderRaidHealth(1, 80) ~= nil, "snapshot fixture has a raid-health draft")
local deskWithProp = Gora:Snapshot()
assert_eq(deskWithProp.proposal.winnerId, snapB.id, "Snapshot copies the proposed winner")
assert_eq(deskWithProp.proposal.source, "raid-health", "Snapshot copies the proposal source")
local propCopy = deskWithProp.proposal
propCopy.winnerId = 999
assert_eq(Gora:GetProposal().winnerId, snapB.id, "mutating the snapshot proposal does not change live")

Gora:ResetForTests()
assert_eq(Runtime:Restore(liveEvent), true, "event Restore before proposal Restore")
assert_eq(Gora:Restore(deskWithProp), true, "Restore reapplies the desk plus proposal")
assert_eq(Gora:GetProposal().winnerId, snapB.id, "Reload keeps the proposed winner")
assert_eq(Gora:GetProposal().source, "raid-health", "Reload keeps raid-health source")
```

Adapt `snapA` / `snapB` / `liveEvent` to the names already in that block. If the current block sanctions `snapA`/`snapB` with A first, `ConsiderRaidHealth(1, 80)` proposes `snapB`.

Add a pin that a snapshot **without** a proposal still Restores `GetProposal() == nil` (today’s wipe behavior for missing key).

- [x] **Step 2: Run `lua tests/test_gora.lua`**

Expected: FAIL — `deskWithProp.proposal` is nil.

- [x] **Step 3: Snapshot / Restore proposal**

Helper next to the other copy helpers:

```lua
local function copyProposal(proposal)
  if type(proposal) ~= "table" then return nil end
  if proposal.ruling ~= "victor" or not isId(proposal.winnerId) then return nil end
  return {
    ruling = "victor",
    winnerId = proposal.winnerId,
    loserId = isId(proposal.loserId) and proposal.loserId or nil,
    source = proposal.source,
  }
end
```

In `Snapshot`, after building `out`:

```lua
  local proposal = copyProposal(self.proposal)
  if proposal then out.proposal = proposal end
```

In `Restore`, replace `self.proposal = nil` with:

```lua
  self.proposal = nil
  local proposal = copyProposal(snap.proposal)
  if proposal and self.sanctioned then
    if proposal.winnerId == self.sanctioned.fighterA
        or proposal.winnerId == self.sanctioned.fighterB then
      self.proposal = proposal
    end
  end
```

Do not persist string proposals. Do not bump `SCHEMA_VERSION`.

- [x] **Step 4: Run `lua tests/test_gora.lua`**

Expected: 0 failed.

- [ ] **Step 5: Commit** (only if asked)

```bash
git add addon/ChurchOfBeef/Core/Gora.lua tests/test_gora.lua
git commit -m "$(cat <<'EOF'
feat: persist a Gora victor draft across Pope reload

EOF
)"
```

---

### Task 3: Console arms DECLARE VICTOR from the draft

**Files:**
- Modify: `addon/ChurchOfBeef/UI/Console.lua` (`paintTargetLine` ~1108; `Refresh` / desk paint that already calls `paintTargetLine`)
- Test: `tests/test_console.lua`

**Interfaces:**
- Consumes: `Gora:GetProposal()` table with `winnerId`
- Produces: `selectedWinnerId` set when it is nil; target line `Proposed victor: <name>. DECLARE VICTOR to ratify.`; `Console:DeclareVictor()` with no target still records that id

- [x] **Step 1: Write the failing tests** in `tests/test_console.lua` (Pope stub + sanctioned pair, same pattern as the existing “Target the victor” refusal ~1038).

```lua
-- After Sanction, no target, no pair-name click:
Gora:Propose({
  ruling = "victor",
  winnerId = sideB.id,
  loserId = sideA.id,
  source = "raid-health",
})
Console:Refresh()
assert_eq(frame.TargetLine:GetText(),
  "Proposed victor: " .. sideB.name .. ". DECLARE VICTOR to ratify.",
  "raid-health draft names the proposed victor")
local recorded, recErr = Console:DeclareVictor()
assert_true(recorded ~= nil, "DECLARE VICTOR with a draft and no target records")
assert_eq(recErr, nil, "drafted DeclareVictor has no error")
assert_eq(recorded.winnerId, sideB.id, "the draft winner is the recorded winner")
```

Keep the existing pin that **without** a proposal and without a target, refusal is still `"Target the victor"`.

Do not change the no-proposal empty-subject line (`"Select the victor, then RECORD VERDICT."`) except when `GetProposal()` is a victor table.

- [x] **Step 2: Run `lua tests/test_console.lua`**

Expected: FAIL — target line still the generic select copy; `DeclareVictor()` refuses.

- [x] **Step 3: Apply the draft on paint**

Add a local helper in `Console.lua` (near `characterName`):

```lua
local function raidHealthProposal()
  if not (COB.Gora and type(COB.Gora.GetProposal) == "function") then
    return nil
  end
  local proposal = COB.Gora:GetProposal()
  if type(proposal) ~= "table" then return nil end
  if proposal.ruling ~= "victor" or not isId(proposal.winnerId) then return nil end
  return proposal
end

local function armProposedWinner()
  local proposal = raidHealthProposal()
  if not proposal then return end
  if selectedWinnerId == nil then
    selectedWinnerId = proposal.winnerId
  end
end
```

Call `armProposedWinner()` at the start of `Refresh` (or immediately before `paintTargetLine`).

In `paintTargetLine`, **before** the empty-subject branch, after the locked-fighters early return:

```lua
  local proposal = raidHealthProposal()
  if proposal then
    local name = characterName(proposal.winnerId) or "?"
    frame.TargetLine:SetText("Proposed victor: " .. name .. ". DECLARE VICTOR to ratify.")
    return
  end
```

`DeclareVictor` already uses `selectedWinnerId` before the target subject. Arming it is enough. Do not auto-call `DeclareVictor`.

- [x] **Step 4: Run `lua tests/test_console.lua`**

Expected: 0 failed.

- [ ] **Step 5: Commit** (only if asked)

```bash
git add addon/ChurchOfBeef/UI/Console.lua tests/test_console.lua
git commit -m "$(cat <<'EOF'
feat: arm DECLARE VICTOR from a raid-health Gora draft

EOF
)"
```

---

### Task 4: Wire — refresh the desk, do not broadcast the draft

**Files:**
- Modify: `addon/ChurchOfBeef/ChurchOfBeef.lua` (`InstallWire` Propose wrap; `persistWrites` Gora list ~689)
- Test: `tests/test_wire_glue.lua`

**Interfaces:**
- Consumes: `Gora:Propose` return table
- Produces: successful Propose → `Console:Refresh` + DB persist; **no** `proclaim`, **no** `sendState`

- [x] **Step 1: Write the failing tests** in `tests/test_wire_glue.lua` after a sanctioned pair (same spies as DeclareVictor ~1360).

```lua
local stateBefore = #stub.addonMessages
local proclaimAt = #proclaimSpy
Gora:Propose({
  ruling = "victor",
  winnerId = victorB.id,
  loserId = victorA.id,
  source = "raid-health",
})
assert_eq(#proclaimSpy, proclaimAt, "Propose does not Proclaim")
assert_eq(#stub.addonMessages, stateBefore, "Propose does not send STATE")
-- Console refresh is observable if the suite has a Refresh spy; if not,
-- pin GetProposal still held and InstallWire did not error.
assert_eq(Gora:GetProposal().winnerId, victorB.id, "wire leaves the draft in Gora")
```

Use the pair names already in that section. Count `proclaimSpy` / addon messages the same way the DeclareVictor pins do.

- [x] **Step 2: Run `lua tests/test_wire_glue.lua`**

Expected: PASS on “does not Proclaim” today (no wrap yet). After Step 3, still PASS. If you add a pin that Console refreshed, that pin FAILs until the wrap exists.

Add an explicit refresh spy if the suite already spies `Console.Refresh`; otherwise skip the spy and keep the no-STATE / no-Proclaim pins.

- [x] **Step 3: Wire Propose**

In `InstallWire`, after the Sanction wrap:

```lua
  wrapAfter(COB.Gora, "Propose", function()
    refreshConsole()
  end)
```

In `persistWrites(COB.Gora, { ... })` add `"Propose"` next to `"Sanction"`.

Do **not** wrap `ConsiderRaidHealth` (it returns nil on duplicates; Propose is the write).

- [x] **Step 4: Run `lua tests/test_wire_glue.lua` then `lua tests/run.lua`**

Expected: 0 failed.

- [ ] **Step 5: Commit** (only if asked)

```bash
git add addon/ChurchOfBeef/ChurchOfBeef.lua tests/test_wire_glue.lua
git commit -m "$(cat <<'EOF'
feat: persist and refresh a Gora draft without broadcasting it

EOF
)"
```

---

### Task 5: HUD feeds raw raid HP into ConsiderRaidHealth

**Files:**
- Modify: `addon/ChurchOfBeef/UI/Hud.lua` (`readGroupHealth` / `liveHealth.paint` / `liveHealth.sync`)
- Test: `tests/test_hud.lua`

**Interfaces:**
- Consumes: `liveHealth.unitA` / `unitB`; `UnitHealth` / `UnitHealthMax`; `Gora:ConsiderRaidHealth`
- Produces: bound 1 HP + living partner → one `ConsiderRaidHealth` call; view `health` percent unchanged; `GetView().winner` still nil

- [x] **Step 1: Write the failing tests** at the end of the existing raid-health block in `tests/test_hud.lua`.

Reuse the raid stub (`groupSize = 2`, `raid1 = Chuckroast`, `raid2 = Tendermage`). After sanction + Refresh:

```lua
assert_eq(Gora:GetProposal(), nil, "80/40 is not a knockout draft")

hp.raid1.cur = 1
assert_eq(stub.fire(raidHud, "OnEvent", "UNIT_HEALTH", "raid1"), true,
  "floor tick is received")
assert_eq(Gora:GetProposal() ~= nil, true, "1 HP proposes")
assert_eq(Gora:GetProposal().winnerId, raidB.id, "living raid2 is the draft winner")
assert_eq(Gora:GetProposal().source, "raid-health", "HUD draft source is raid-health")
assert_eq(Hud:GetView().winner, nil, "HUD does not invent a winner string")
assert_eq(Store:GetCharacter(raidA.id).gora.losses, 0, "HUD propose does not record")

hp.raid1.cur = 0
Gora:ResetForTests()
Runtime:StartEvent()
-- re-sanction the same two ids after Reset wipes Gora — recreate via twoChars/Sanction
```

Do **not** call `Gora:ResetForTests` mid-HUD without also re-sanctioning; prefer a **fresh** `reset()` + raid stub + pair for the dead-HP case:

```lua
reset()
stub.groupSize = 2
stub.inRaid = true
stub.group = { raid1 = { name = "Chuckroast" }, raid2 = { name = "Tendermage" } }
hp.raid1, hp.raid2 = { cur = 0, max = 100 }, { cur = 80, max = 100 }
-- restore the UnitHealth closures from the raid block
Runtime:StartEvent()
local deadA, liveB = twoChars()
Gora:Sanction(deadA.id, liveB.id)
Hud:Init()
Hud:Refresh()
assert_eq(Gora:GetProposal(), nil, "0 HP is not a duel knockout draft")
```

Keep the existing pin that `20` HP updates the bar and does not need a proposal.

- [x] **Step 2: Run `lua tests/test_hud.lua`**

Expected: FAIL — `GetProposal()` stays nil after `cur = 1`.

- [x] **Step 3: Raw vitals + consider**

Replace `readGroupHealth` with a vitals reader (same guards, still pcall `UnitExists`):

```lua
local function readGroupVitals(unit)
  if type(unit) ~= "string" or unit == "" then return nil end
  if type(UnitExists) == "function" then
    local ok, exists = pcall(UnitExists, unit)
    if ok and exists == false then return nil end
  end
  if type(UnitHealth) ~= "function" or type(UnitHealthMax) ~= "function" then
    return nil
  end
  local cur = UnitHealth(unit)
  local max = UnitHealthMax(unit)
  if type(cur) ~= "number" or type(max) ~= "number" or max <= 0 then
    return nil
  end
  if cur < 0 then cur = 0 end
  if cur > max then cur = max end
  return {
    cur = cur,
    max = max,
    pct = math.floor((100 * cur / max) + 0.5),
  }
end
```

In `liveHealth.paint`, use vitals for `paintHealthSide` (`vitals and vitals.pct`). After both sides paint, if both units are bound and `COB.Gora` has `ConsiderRaidHealth`:

```lua
  local vitA = readGroupVitals(liveHealth.unitA)
  local vitB = readGroupVitals(liveHealth.unitB)
  -- paint from vitA.pct / vitB.pct (nil → hideHealthSide)
  if vitA and vitB
      and COB.Gora
      and type(COB.Gora.ConsiderRaidHealth) == "function" then
    COB.Gora:ConsiderRaidHealth(vitA.cur, vitB.cur)
  end
```

Do not call `DeclareVictor`. Do not set `lastView.winner`. Unbound sides skip consider (missing vitals).

- [x] **Step 4: Run `lua tests/test_hud.lua` then `lua tests/run.lua`**

Expected: 0 failed. `ParseDuel` still nil. `countStatusBars` unchanged.

- [ ] **Step 5: Commit** (only if asked)

```bash
git add addon/ChurchOfBeef/UI/Hud.lua tests/test_hud.lua
git commit -m "$(cat <<'EOF'
feat: propose a Gora victor when raid HP hits the duel floor

EOF
)"
```

---

### Task 6: A02 leftover + in-game smoke (no Result tick)

**Files:**
- Modify: `docs/validation/A02-duel-messages.md` (Leftovers only)
- Install: skill §2 rsync to Anniversary AddOns

**Interfaces:**
- Consumes: shipped Tasks 1–5
- Produces: honest leftover; smoke checklist for David

- [x] **Step 1: Leftover paragraph** under A02 Leftovers. Do not touch **Result:** `NOT RUN`. Do not write PASS / FAIL / PARTIAL.

Add:

```
- Raid/party 1 HP proposer may ship (David 2026-09-14): raw UnitHealth == 1
  on one sanctioned fighter, partner > 1, Gora:Propose only. Not this item.
  This sheet remains system-message formats / range / locale.
- “I lost” INPUT and CHAT_MSG_SYSTEM parser stay parked.
```

- [x] **Step 2: Install**

```bash
: "${WOW_ADDONS_DIR:=/Applications/World of Warcraft/_anniversary_/Interface/AddOns}"
rsync -a --delete \
  "/Volumes/AI_Design_Drive/Beef_Addon/addon/ChurchOfBeef/" \
  "$WOW_ADDONS_DIR/ChurchOfBeef/"
```

Never touch `WTF/`.

- [ ] **Step 3: Smoke (human)**

1. `/console scriptErrors 1` → `/reload`
2. 40-man or party: both fighters grouped; one may have **no** addon
3. Sanction a Gora
4. Duel to a natural end
5. On the **loser**, immediately: `/dump UnitHealth("target")` (or the raid token). Expect **1**. If not 1, stop and report the number — do not change `DUEL_FLOOR` without David
6. Pope console: target line names the other fighter; **DECLARE VICTOR** records; congregation does not see a winner until that tap
7. Flee once: no draft (or a stale draft from an earlier 1 HP — VOID if needed)
8. `/reload` on the Pope after a 1 HP draft, before tapping: draft still armed

- [x] **Step 4: Full harness**

```bash
lua tests/run.lua
```

Expected: 0 failed.

- [ ] **Step 5: Commit** (only if asked; include the A02 leftover)

---

## Out of scope (named leftovers — not tasks)

| Leftover | Why it waits |
|----------|----------------|
| `CHAT_MSG_SYSTEM` / A02 parser | Owner David; Result NOT RUN; locale + range |
| Loser “I lost” INPUT | Law 5; addon-less fighters; not required for best case |
| Congregation HUD “proposed” | Slice is Pope desk only |
| Auto-declare / timers | Law 4 |
| Combat log / `UNIT_DIED` | A02 + Law 8 |
| `DUEL_FINISHED` as winner | No payload; local duelists only |

---

## Self-review

1. **Spec coverage:** 1 HP raw floor → Task 1+5. Addon-less fighters → HUD UnitHealth, no INPUT. Propose not record → Task 1+4. Console arm → Task 3. Persist reload → Task 2. No STATE/Proclaim → Task 4. A02 honest → Task 6. Parked items listed, not tasked.
2. **Placeholders:** none. Flip-test contradiction called out and resolved as a replace path.
3. **Types:** `GuessKnockout` returns winner side `"A"`\|`"B"`; proposal `{ ruling = "victor", winnerId, loserId, source = "raid-health" }` is the same table through Snapshot, Console, and HUD pins.
