Spec PASS

# B31-A — Refresh in QUIET drops a leftover Recommend line (review)

**Quality:** Approved-with-nits

**Lane:** B31-A Refresh in QUIET drops a leftover Recommend line
**Brief:** `docs/reformation/vestments/briefs/B31-A-quiet-recommend.md`
**Writer report:** `docs/reformation/vestments/briefs/B31-A-quiet-recommend-report.md`
**Diff:** `docs/reformation/vestments/briefs/B31-A-quiet-recommend.diff` (B31-A-only exclusive-pair packet; live `Console.lua` also carries earlier console batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Console.lua` (`Refresh` ~1083–1109 / `paintRecommendation` / `StartEvent` / `EndEvent` / `Continue` / `Recommend` / `ResetForTests` / `after()`), and `tests/test_console.lua` (isolation wrap, B24-A leftover pin updated in place, nested `runB31A()` inside `runB8E()` after `runB29A()`); then ran `lua tests/test_console.lua` (**2145 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: Bible §20 QUIET has no event pair; B26-A selection/recommend dies with the event; B24 leftover (`Runtime:EndEvent` / InspectProgress / glue EndEvent bypass the desk and left `lastRecommendation`, so mute `"  names  "` survived); `Refresh` in QUIET (or nil Runtime state) nils `lastRecommendation` only, before `paintRecommendation`; do **not** nil `selectedFighterA` / `selectedFighterB` here; Start / End pair-clear stay; Continue still does not clear; `SaveNote` stays nil; no SUMMON. Runtime has no `GetState`; writer used `Snapshot().state`. That is a correct adaptation, not a FAIL. Did not mutate `Console.lua` or `test_console.lua`. Did not commit. Did not edit Dock, glue, TOC, bootstrap, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Refresh in QUIET (or nil Runtime state) does not drop `lastRecommendation` (B24 leftover; mute `"  names  "` survives InspectProgress / glue `Runtime:EndEvent`) | **Pass. Verified.** Live `Refresh` reads `Snapshot().state` and sets `lastRecommendation = nil` when that state is nil or `"QUIET"`, then `paintRecommendation`. B24-A leftover pin updated in place: `Runtime:EndEvent` + `Refresh` is `""`. Nested B31-A: same leftover + no names token. Reviewer probe: glue-style EndEvent leaves the painted line until `Refresh`; `Refresh` then blanks it. |
| Refresh nils `selectedFighterA` / `selectedFighterB` (Pope cannot pick a pair in QUIET before Start Event) | **Pass. Verified.** Refresh body does not name the selected pair. Pin: QUIET `SelectFighters` then `Refresh` keeps both ids. Reviewer probe: pair also survives `Runtime:EndEvent` + `Refresh` after a live Recommend. |
| StartEvent / EndEvent pair-clear dropped | **Pass.** Live success blocks still nil `lastRecommendation` then both selected ids before `after()`. Nested source pins match those exact blocks. Reviewer probe: later `StartEvent` and desk `EndEvent` still nil the pair. |
| Continue clears `lastRecommendation` | **Pass.** Live `Continue` is still `return after(self, result, err)` with no nil write. B24-A keep pin stays. Reviewer probe: Continue → ASSEMBLY `Refresh` still paints the live names line. |
| Live Recommend no longer paints; ASSEMBLY / RITE / CONSEQUENCE Refresh drops the line | **Pass. Verified.** Nested pin: live named Recommend paints `"  names  "` + both names; `Refresh` while ASSEMBLY keeps that text. Reviewer probe: RITE and CONSEQUENCE `Refresh` also keep. |
| `SaveNote` defined; SUMMON / parchment / tabs / `DEMANDED` | **Pass.** `Console.SaveNote` nil before and after the nested block. Source has no `function Console:SaveNote`, no `SUMMON THE FAITHFUL`, no `Parchment`, no `PanelTabButtonTemplate`, no `DEMANDED`. Reviewer walk: no SUMMON button. |
| Used `GetState` that does not exist; or added `GetState` on Runtime (exclusive breach) | **Pass.** Runtime has no `GetState` (reviewer grep + probe). Refresh uses the existing `Snapshot().state` path already used by `paintRuntime` / `currentEventId`. No Runtime edit. Correct adaptation, not a FAIL. |
| New main-chunk locals / not nested in `runB8E()` after `runB29A()` | **Pass.** `runB31A()` is a nested `local function` inside `runB8E()` after `runB29A()`. Packet adds no main-chunk `local`. Header comment only at file top. No new file locals in `Console.lua` (`local state` / `local snap` are Refresh-scoped). |
| Isolated suite not exit 0 / isolation wrap rewritten | **Pass. Verified.** 2145 passed, 0 failed. Writer-reported count matches. Isolation wrap stays under the first `if standalone then` (**17** nil pins). `runB31A()` re-pins 4 of them plus `COB.Popes`. |
| Exclusive file breach | **Pass.** Lane implementation is the two named files. Packet is header note + Refresh Quiet drop; B24-A leftover pin flipped to `""`; nested `runB31A()`. Dock / glue have no `lastRecommendation`. Sibling dirt in this workspace is other lanes (earlier Console batches vs HEAD). |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Dock, glue; no commit | **Pass.** Named-risk check. Reviewer did not commit. |
| `Refresh`: if Runtime state is nil or `"QUIET"`, `lastRecommendation = nil` before `paintRecommendation` | **Pass.** Named-risk check. Writer used `Snapshot().state` because Runtime has no `GetState`. Correct adaptation. |
| Do **not** nil `selectedFighterA` / `selectedFighterB` in Refresh | **Pass.** Named-risk check. |
| StartEvent / EndEvent pair-clear stay | **Pass.** Named-risk check. |
| Continue still does not clear | **Pass.** Named-risk check. |
| `SaveNote` stays nil | **Pass.** Named-risk check. |
| No SUMMON | **Pass.** Named-risk check. |
| B24-A leftover pin updated in place: `Runtime:EndEvent` + `Refresh` is `""`; StartEvent-clears pin stays | **Pass.** Live pin expects `""`. StartEvent-clears pin still immediately after. |
| Source pin: Refresh nils `lastRecommendation` when state is QUIET | **Pass.** Nested `refreshFn` find: `state == nil or state == "QUIET"`, `lastRecommendation = nil` before `paintRecommendation`, no selected-pair names. |
| Recommend during a live event still paints | **Pass.** Nested pin + reviewer probe (ASSEMBLY / RITE / CONSEQUENCE). |
| Nest `runB31A()` inside `runB8E()` after `runB29A()`; no new main-chunk locals | **Pass.** Named-risk check. |
| Isolation wrap stays; `lua tests/test_console.lua` exit 0 | **Pass.** **2145 / 0.** |

Bible §20 holds on the exclusive pair: QUIET has no event pair, so the mute Recommend line dies on Refresh once the machine is QUIET (or state is unreadable). Law 6 holds: Quiet after End does not keep Event suggestion chrome on this line. B26-A selected-pair lifetime stays on Start / End; Refresh is not a second pair wipe. Law 4 holds: the desk does not invent SUMMON, `SaveNote`, or “DEMANDED.”

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Runtime has no `GetState`; Refresh uses `Snapshot().state` | **Correct adaptation. Not a FAIL.** Exclusive pair cannot add `GetState`. Same read as `paintRuntime` / `currentEventId`. |
| No client smoke. InspectProgress / glue EndEvent on Anniversary unproven | **Not a miss.** Brief asked the isolated suite and a Refresh drop. Glue `afterEndEvent` still does not call `Console:Refresh` — painted leftover can linger until the next Refresh. Allowed leftover; do not expand exclusive to glue. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Continue still does not clear while the event is live | **On contract.** Brief said Continue does not clear. |
| A QUIET selected pair survives Refresh | **On contract.** Brief said do not nil the selected pair so a Pope may pick before Start Event. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

---

## Isolation / drop / keep

**Isolation wrap — Pass.** Load list is still Common + Ranks + Runtime + Store + Gora + Knighting + Sender + Decree + Console. No `dofile` of Dock, glue, UI shell, Net, DB, or Confession. Standalone wrap is still **17** nils (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Confession). Reviewer probe: those keys are nil at load. Wrap is load-time only (unchanged). Nested B31-A re-pins Archive / UI / Toasts / Confession / Popes after restore.

**Quiet drop — Pass.** `Refresh` snapshots Runtime, then nils `lastRecommendation` when `state == nil or state == "QUIET"`, then paints. `paintRecommendation` still reads the table only. B24 leftover (`Runtime:EndEvent` then `Refresh` still showing `"  names  "`) is closed. Reviewer probe: missing `Snapshot` is treated as nil state and also drops (fail-closed). `Show` hits `Refresh`, so a later Show in QUIET also blanks the line.

**Keep — Pass.** ASSEMBLY / RITE / CONSEQUENCE `Refresh` leaves `lastRecommendation`. Failed Start (already live) / failed End from RITE keep the line. Continue keeps. Selected pair is untouched by Refresh: QUIET pick survives; leftover pair after `Runtime:EndEvent` + `Refresh` survives. Start / End still nil the pair before `after()`. `Recommend` still stores the names token on a live event.

---

## Strengths

- The delta is the brief: one Quiet/nil drop in `Refresh` immediately before `paintRecommendation`. Selected pair, Start / End pair-clear, Continue, `Recommend`, and `paintRecommendation` were left alone.
- B24 leftover (`Runtime:EndEvent` then `Refresh` left `"  names  "`) is closed on the same named-petition fixture, not a second paint language. The leftover pin was updated in place; the StartEvent-clears pin stays.
- Live Recommend keep sits next to the Quiet drop, so a blanket nil on every `Refresh` would fail. QUIET selected-pair keep sits next to the drop, so a Refresh that also niled the pair would fail.
- `Snapshot().state` matches `paintRuntime` / `currentEventId`. Adding `GetState` would have been an exclusive breach.
- `SaveNote` nil, no SUMMON / parchment / tabs / `DEMANDED`. Isolation wrap was not rewritten. `runB31A()` is nested inside `runB8E()` after `runB29A()`. Writer-reported **2145 / 0** matched the re-run. Writer-reported red (**2139 / 6**) matches leftover `"  names  "` plus a missing Quiet-drop source pin.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Glue `afterEndEvent` / InspectProgress still do not call `Console:Refresh`.** Reviewer probe: `Runtime:EndEvent` leaves the painted `"  names  "` until `Refresh`. Brief scoped the drop to `Refresh`, not glue. A desk that is already shown can keep a stale line until the next Show / verb / explicit Refresh. Do not expand this exclusive pair to glue.

### Nit

1. **B24-A StartEvent leftover-clear pin is now already-empty from the Quiet drop.** `successful StartEvent clears leftover Recommendation` no longer independently proves StartEvent's own write; `Refresh` already niled the table. Brief said keep the pin. The Start / End source pins still prove clear-before-`after`. Reviewer probe: StartEvent still nils the selected pair.

2. **B31-A does not pin the selected pair after `Runtime:EndEvent` + `Refresh`.** QUIET pick-before-Start is pinned. Reviewer probe closed the leftover-drop path: both ids stay.

3. **Recommend in QUIET is immediately wiped by `after()` Refresh.** `Gora:Recommend` is not event-gated. The Pope can still seat a pair; the mute line does not persist in QUIET. On contract with this lane, not a miss.

4. **`Refresh` now calls `Snapshot()` a third time** (`paintRuntime`, `currentEventId` via `syncCongregationToggle`, then the Quiet drop). Same fail-closed pattern as `paintRuntime` (`COB.Runtime.Snapshot` truthy, not `type == "function"`).

5. **Several “does not X” pins are string finds on the Refresh body.** They would miss `self.selectedFighterA = nil` written as a computed field. Reviewer probe on live ids closes that hole.

6. **Isolation wrap is load-only.** Seventeen pins under the first `if standalone then`. Nested B31-A re-pins four of them plus Popes. Brief said the wrap stays; it did.

7. **Exclusive-pair diff is not a vs-HEAD Console delta.** Packet is the B31-A-only Quiet drop + leftover-pin flip + nested pins. `git diff HEAD` on the two files still includes earlier console batches. Report already says this.

8. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **2145 / 0** was re-run here. Live InspectProgress / glue EndEvent then a visible leftover until Refresh is unproven on Anniversary.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **2145 passed, 0 failed.** Isolation wrap: **17**.

`Refresh` nils `lastRecommendation` when `Snapshot().state` is nil or `"QUIET"`, before `paintRecommendation`. It does not nil the selected pair. Start / End pair-clear stay. Continue does not clear. Live Recommend still paints. The B24-A leftover pin now expects `""` after `Runtime:EndEvent` + `Refresh`. `SaveNote` stays nil. No SUMMON. `Snapshot().state` is the correct `GetState` adaptation. Isolated `lua tests/test_console.lua` **2145 passed, 0 failed**, exit 0.

Leftovers: glue / InspectProgress still do not `Console:Refresh` (painted leftover can linger until the next Refresh; do not expand exclusive to glue); Runtime has no `GetState` (allowed); Continue keep and QUIET selected-pair keep are intentional; no client smoke; full harness not run.

Do not claim V1 / MVP complete. This review does not sign the lane.
