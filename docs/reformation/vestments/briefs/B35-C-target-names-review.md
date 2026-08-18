Spec PASS

# B35-C — keepLastUnits also keeps fighter names (review)

**Quality:** Approved-with-nits

**Lane:** B35-C keepLastUnits also copies omitted `nameA` / `nameB`
**Brief:** `docs/reformation/vestments/briefs/B35-C-target-names.md`
**Writer report:** `docs/reformation/vestments/briefs/B35-C-target-names-report.md`
**Diff:** `docs/reformation/vestments/briefs/B35-C-target-names.diff` (B35-C-only exclusive-pair packet vs the pre-lane B34-C tree; live `Markers.lua` / `test_markers.lua` are still untracked vs HEAD and also carry earlier Markers batches)
**Exclusive files:** `addon/ChurchOfBeef/UI/Markers.lua`, `tests/test_markers.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Markers.lua` (`keepLastUnits` also copies omitted `nameA` / `nameB` from `last` via `== nil`; it still does not copy singular `name`; successful `Target` is still `remember(keepLastUnits({ verb = "Target", ok = true, name = trimmed }))`; Mark* / `Clear` success still `remember` without that copy; `Target` does not call `Markers:Clear` or `clearPrior`; no `UnitIsDead`), and `tests/test_markers.lua` (B35-C block after the B34-C failed-Target pins; source extract `keepLastUnits` → `refuse` pins `fields.nameA = last.nameA` / `fields.nameB = last.nameB`; MarkFighters pair + Target Beefina keeps `nameA` / `nameB` and `unitA` / `unitB` with `name` the targeted name; MarkCandidate A + Target: `name` is the Target, prior `unit` stays; B34-C unit keep / B33-C refuse / Ghost / Clear pins; isolation wrap); then ran `lua tests/test_markers.lua` (**563 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: B34-C leftover (successful Target kept units and dropped fighter names); Bible §8 (marks on the **current** candidate / fighters); Law 5 (Pope client); Law 6 (Quiet refuse). Anniversary `TargetUnit([name], [exactMatch])`. `keepLastUnits` also copies omitted `nameA` / `nameB`. Target success still sets `name = trimmed`. Do not merge name vs unit. Mark* / Clear success still replace. First Quiet refuse stays empty names. Do not call `Markers:Clear` from Target. No `UnitIsDead`. No SecureActionButton. No combat automation. Isolation wow_ui_stub + Common + Runtime + Markers only. Did not mutate `Markers.lua` or `test_markers.lua`. Did not commit. Did not edit glue, Hud, Console, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Successful Target still drops `nameA` / `nameB` after a fighter pair (B34-C leftover) | **Pass. Verified.** Brief L11 vs `Markers.lua` L186–191 / L221: helper now copies omitted `nameA` / `nameB` (`== nil`). Success is still `remember(keepLastUnits({ verb = "Target", ok = true, name = trimmed }))`. Pin: MarkFighters Chuckroast / Tendermage then Target Beefina, `GetView()` keeps `nameA` / `nameB` and `unitA` / `unitB`; `name` is `"Beefina"`. `debug.getupvalue`: `keepLastUnits` is an upvalue of `Target` and of `refuse`. |
| Target success merges name vs unit (targeted name written onto a unit token, or a token written onto `name`) | **Pass.** Helper does not copy singular `name`. Target always passes `name = trimmed`. After fighters then Target, `name` is `"Beefina"` while `unitA` stays `"raid2"` and `nameA` stays `"Chuckroast"`. After MarkCandidate A then Target Tendermage, `name` is `"Tendermage"` and `unit` stays `"raid2"`; `nameA` / `nameB` stay nil. Reviewer probe: padded `"  Beefina  "` trims to `"Beefina"`; targeting fighter A leaves `name ~= unitA`. |
| Mark* / Clear success start using the keep helper and stop replacing last | **Pass.** Brief L11. MarkCandidate L246–252, MarkFighters L286–295, and Clear L319–325 still `remember({...})` with caller fields only. `debug.getupvalue`: `keepLastUnits` is not an upvalue of Mark* or `Clear`. Reviewer probe: fighters + Target + MarkCandidate nils `nameA` / `nameB`; fighters + Target + Clear nils them and records Clear / index `0`; fighters remake after Target replaces verb and does not keep the Target `name`. |
| `Markers:Clear` / `clearPrior` from Target | **Pass. Verified.** Brief L5. Target body (L203–221) has no `:Clear(`, `Markers.Clear`, `self:Clear`, or `clearPrior`. B34-C source pin still holds. `debug.getupvalue`: `clearPrior` is an upvalue of Mark* only, not of `Target`. Reviewer wrap of `Markers.Clear` was unchanged through fighters + Target. |
| First Quiet refuse invents `nameA` / `nameB` after the helper extract | **Pass.** Fresh `last` is `{ mode = "Event" }`. Copy of nil stays nil. Reviewer probe: first Quiet Target / MarkCandidate / Clear (each after `reset()`) stay empty `nameA` / `nameB`. First not-pope Target and first ungrouped MarkCandidate stay empty names. Existing first Quiet unit pins stay. |
| Failed Target drops fighter names | **Pass.** Failed Target still `refuse` (L218–219), and refuse already goes through `keepLastUnits`. Reviewer probe: fighters then `TargetUnit` error keeps `nameA` / `nameB` and `unitA`. Brief Tests named successful Target only. |
| `UnitIsDead` / SecureActionButton / combat automation / mark-on-Target | **Pass.** Source has none of `UnitIsDead`, `SecureActionButton`, `StartAttack`, `AttackTarget`, `AssistUnit`, `CastSpell`, `UseAction`, `GuildPromote`, `SetGuildMemberRank`, or `CreateFrame`. Target is `pcall(TargetUnit, trimmed, true)` only (L217). Suite `combatCalls` / chat / addon / sounds stay 0. Reviewer probe: combat flag + fighters then Target still `combatCalls == 0` and `#raidTargets` stays 2 through Target. |
| Isolated suite not exit 0 | **Pass. Verified.** 563 passed, 0 failed. Writer-reported count matches. |
| Exclusive file breach | **Pass.** Provided packet is two hunks: `keepLastUnits` `nameA` / `nameB` copy, and the B35-C test block after B34-C. Sibling dirt vs HEAD is other lanes, not this packet. Both exclusive files remain untracked vs HEAD. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit glue / Hud / Console; no commit | **Pass.** Named-risk check. Brief L5. |
| Isolation stays wow_ui_stub + Common + Runtime + Markers | **Pass.** Three `dofile`s unchanged. Wrap is still **27** nil-module / slash pins under `if standalone then`. Brief L15. |
| `keepLastUnits` also copies omitted `nameA` / `nameB` (`== nil`) | **Pass.** Brief L11 vs `Markers.lua` L186–191. Named-risk check. |
| Target success still sets `name = trimmed` (who was targeted) | **Pass.** Brief L11 vs `Markers.lua` L221. Reviewer probe: `"  Beefina  "` → `GetView().name == "Beefina"` and `TargetUnit` received `"Beefina"`. |
| Do not merge name vs unit | **Pass.** Brief L11. Named-risk check. |
| MarkCandidate / MarkFighters / Clear success still replace | **Pass.** Brief L11. Named-risk check. B34-C successful-B-after-Target and B33-C successful-Clear pins stay. |
| First Quiet refuse stays empty names | **Pass.** Brief L11. Copy of nil on a fresh `last`. Named-risk check. |
| No `Markers:Clear` from Target. No `UnitIsDead` | **Pass.** Brief L5. Named-risk check. |
| Tests after the B34-C block. Source pin: `keepLastUnits` copies `last.nameA` / `last.nameB` when omitted. MarkFighters pair + Target: GetView keeps `nameA` / `nameB` and `unitA` / `unitB`; `name` is the targeted name. MarkCandidate A + Target: `name` is the Target; prior `unit` stays | **Pass.** Brief L15. Block starts after the B34-C failed-Target pins (`test_markers.lua` L934). Source extract L940–947. Runtime L949–976. |
| `lua tests/test_markers.lua` exit 0 | **Pass.** Brief L17. **563 / 0.** |

Bible §8 (marks on the current candidate / fighters) and TargetUnit-only hold on the exclusive pair. The B34-C leftover (successful Target kept units and dropped fighter names) is closed. wow-api `classic_anniversary`: `TargetUnit([name], [exactMatch])` exists. Target still `pcall(TargetUnit, trimmed, true)`. Targeting is not a subject-mark change; remembered fighter names stay on `GetView` with the tokens so the current subjects remain identifiable. No `UnitIsDead` is required for keep. Brief forbids `Markers:Clear` from Target; they kept `TargetUnit` + keep-then-`remember`.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; Anniversary `TargetUnit(name, true)` after a live fighter pair, with `GetView` still showing those names, is unsmoked | **Not a miss.** Brief asked the isolated suite. Reviewer spy proves keep + trim + no `SetRaidTarget`; it does not prove pixels or raid-assist. |
| `GetView` name vs unit stays split. Successful Target records `name` as who was targeted while `unit` / `unitA` / `unitB` stay prior tokens | **On contract.** Brief L11: do not merge name vs unit. `clearPrior` still reads tokens. |
| `last.name` (singular) is still replaced. After MarkCandidate A → Target, A's name is not kept on `name` | **On contract.** Brief asked Target `name = trimmed`. Helper does not copy `last.name`. |
| Failed Target after fighters is not newly pinned for names | **On contract.** Brief Tests named successful Target. Reviewer probe: refuse keeps `nameA` / `nameB`. |
| First Quiet empty names are not a new assert. Existing first Quiet pins cover empty units; names stay empty because `last` is empty | **On contract as copy-of-nil.** Writer reason is sloppy for the existing four-verb Quiet block (see Nit). True first Target / MarkCandidate / Clear Quiet (fresh `last`) stay empty `nameA` / `nameB`. |
| `clearPrior` ignores `applyMark(0)` failure and still applies the new mark | **On contract.** Pre-lane helper. Brief did not retask `clearPrior`. |
| Remembered tokens, not names; roster shuffle may `applyMark` index `0` on a different person | **On contract.** Brief named keep of omitted `nameA` / `nameB` on `GetView`, not a rename of `clearPrior`. |
| Source pins are substrings | **On contract as a pin.** Live call is real (`== nil` then `remember`); reviewer upvalue + Clear wrap close the hole. |
| Full `lua tests/run.lua` was not run | **Not a miss.** Brief asked the isolated suite. |
| Gate W / Gate V stay OPEN; not signed | **On contract.** This review does not sign the lane. |

B35-INT glue is not required. Mark* / Clear / Target already go through `refuse` / `remember` / `keepLastUnits`.

---

## Isolation / Target / gates

**Isolation wrap — Pass.** Load list is still wow_ui_stub + Common + Runtime + Markers. No `dofile` of Knighting / Gora / Store / UI shell / Net / Console. Standalone wrap is still **27** nils (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Console, Sender, Store, Gora, Knighting, FighterCard, Confession, Inputs, ConsoleDock, Decree, slash). Wrap is load-time only (unchanged). Reviewer recount of the load-time pins: **27**.

**Target — Pass.** Helper `keepLastUnits` is `== nil` copy of units / indices / `nameA` / `nameB`, then return fields. It does not copy singular `name`. Successful Target omits the pair fields, so they come from `last`, and still sets `name = trimmed`. `Target` does not call `Markers:Clear` or `clearPrior`. `pcall(TargetUnit, trimmed, true)` stays. Event + Pope still required; group is not. First-mark Quiet refuse stays empty names.

**Gates — Pass.** Quiet / missing Runtime / unlisted Pope / invalid name still refuse before `TargetUnit`. Missing `TargetUnit` / `TargetUnit` error still refuse and keep. `"player"` resolve stays on Mark*. Successful Mark* / Clear still replace last.

---

## Strengths

- The leftover is closed on the existing remember path: two more `== nil` copies in `keepLastUnits`, used by refuse and by Target success. Singular `name` is left to the caller. `clearPrior` is left alone. `Markers:Clear` is not called from Target.
- Fighters then Target is pinned as name keep plus unit keep, with `name` the targeted name. MarkCandidate A then Target is pinned as `name` / `unit` split. Isolation wrap and B16-D / B18-D / B22-C / B32-D / B33-C / B34-C pins stay.
- `debug.getupvalue` shows `keepLastUnits` on refuse and Target, not on Mark* / Clear, and `clearPrior` still on Mark* only. A runtime wrap of `Markers.Clear` did not increment through Target.
- Packet does not rewrite `resolveUnit`, `applyMark`, `clearPrior`, Mark* success, or `Clear`.
- Writer-reported **563 / 0** matched the re-run. Writer-reported red (**559 / 4**) matches a block that old Target success (keep units, no `nameA` / `nameB` copy) would fail.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Client `TargetUnit(name, true)` after a live fighter pair, with `GetView` still showing those names, is unsmoked.** The suite cannot prove Anniversary targets the other name, or that the Pope client has raid-assist for a later `SetRaidTarget` on the remembered tokens. `wow_ui_stub` `TargetUnit` / `SetRaidTarget` are spy lists. Brief scoped this lane to the isolated suite. Reviewer spy proves keep + trim + no mark-on-Target; it does not prove pixels.

### Nit

1. **`GetView` name vs unit stays split.** Successful Target records `name = "Beefina"` (or `"Tendermage"`) while `unit` / `unitA` / `unitB` stay prior tokens. Brief forbade the merge.

2. **`last.name` (singular) is still replaced.** After MarkCandidate A → Target, the candidate's `name` is the Target string. Helper does not copy `last.name`. On contract.

3. **Writer leftover misstates the existing first Quiet block.** After the four-verb Quiet sequence (Target → MarkCandidate → MarkFighters → Clear, no `reset()`), `GetView().nameA` / `nameB` are `"Chuckroast"` / `"Tendermage"`: MarkFighters Quiet already recorded the attempted pair (pre-lane), and Clear Quiet now keeps them via the helper. Writer said names stay empty because `last` is empty. True first Quiet Target / MarkCandidate / Clear (fresh `last`) still have empty `nameA` / `nameB`. Brief Tests did not require a new first Quiet names pin.

4. **Failed Target after fighters is unpinned for names.** Refuse already keeps. Reviewer probed; it holds.

5. **Mark* / Clear success replacing `nameA` / `nameB` after a keep is unpinned.** Brief required replace. Reviewer probed; fighters + Target + MarkCandidate / Clear nil the pair; fighters remake after Target does not keep the Target `name`.

6. **MarkCandidate A + Target does not pin `nameA` / `nameB` nil.** Brief asked `name` / `unit` only. Reviewer probe: both stay nil (no invented pair).

7. **`clearPrior` ignores `applyMark(0)` failure** and still applies the new mark. If the new `applyMark` then fails, the caller-supplied unit/index win and the in-world prior is already index `0`. Pre-lane.

8. **Remembered tokens, not names.** If the raid roster shuffles, `last.unit` may `applyMark` index `0` on a different person. `clearPrior` still does not read `nameA` / `nameB`.

9. **Source pins are substrings.** `fields.nameA = last.nameA` would pass on a comment inside the extract. Live call is real (`== nil` then `remember`); reviewer upvalue + Clear wrap close the hole.

10. **B35-C Target of Beefina does not re-pin `exact == true`.** Existing Event + Pope Target pin still asserts `TargetUnit` exactMatch. Reviewer probe: B35-C path still passes `true`, and the padded name is trimmed before the call.

11. **Helper is still named `keepLastUnits`** while it also copies fighter names. Behavior matches the brief.

12. **Isolation wrap is load-only.** Twenty-seven pins under `if standalone then` at file load. Brief said the wrap stays; it did.

13. **Exclusive-pair diff is not a vs-HEAD Markers delta.** Both exclusive files were already untracked. Packet is the B35-C-only name copy + pins. Report already says this.

14. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **563 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**1. Spec PASS.** Brief L11 (`keepLastUnits` copies omitted `last.nameA` / `last.nameB` via `== nil`; Target success still `name = trimmed`; do not merge name vs unit; Mark* / Clear still replace; first Quiet refuse stays empty names) vs `Markers.lua` L166–193 / L200 / L221 / L246–252 / L286–295 / L319–325. Brief L5 (no `Markers:Clear` from Target; no `UnitIsDead`) vs Target L203–221 and source bans. Brief L15 (tests after B34-C; source `nameA` / `nameB` copy; fighters + Target keeps names and units with `name` the targeted name; A + Target: `name` is the Target, prior `unit` stays) vs `test_markers.lua` L934–976.

**2. Quality:** no must-fix. One Important leftover (client Target after a live fighter pair unsmoked). Nits as listed.

**3. Isolation count:** **563 passed, 0 failed.** Isolation wrap: **27**.

**4. Law:** Bible §8 current-subject marks hold: Target is targeting assist, not a subject-mark change; the current fighter / candidate names stay on `GetView` with the tokens. Target is `TargetUnit([name], [exactMatch])` only — no `SetRaidTarget` on the Target path. Law 5: Event + Pope still required. Law 6: first Quiet Target refuse stays empty `nameA` / `nameB`; no theater.

**Must-fix:** none.

**Leftovers:**
- Client Anniversary `TargetUnit(name, true)` after a live fighter pair, with `GetView` still showing those names, is unsmoked (Important, not must-fix).
- `GetView` name vs unit; Target records `name` as who was targeted while units stay prior tokens.
- `last.name` (singular) is still replaced.
- Writer leftover misstates the existing four-verb Quiet block (Clear Quiet now keeps MarkFighters Quiet names); true first Target / MarkCandidate / Clear Quiet stay empty `nameA` / `nameB`.
- Failed Target after fighters is unpinned for names (reviewer probed; they hold).
- Mark* / Clear success replacing `nameA` / `nameB` after a keep is unpinned (reviewer probed; they hold).
- MarkCandidate A + Target does not pin empty `nameA` / `nameB` (reviewer probed; they stay nil).
- `clearPrior` ignores `applyMark(0)` failure; a failed new `applyMark` has already cleared the prior.
- Remembered tokens, not names; roster shuffle may clear the wrong person.
- Source pins are substrings, not a `SetRaidTarget` spy on Target.
- B35-C Target of Beefina does not re-pin exactMatch (existing pin + probe hold).
- Helper name is still `keepLastUnits`.
- Isolation wrap is load-only.
- Exclusive-pair packet is not a vs-HEAD Markers delta.
- Full `lua tests/run.lua` was not run.
- Gate W stays OPEN. Gate V stays OPEN.

`keepLastUnits` also copies omitted `last.nameA` / `last.nameB` (`== nil`, shared helper) then `remember`. Successful Target still sets `name = trimmed`. After MarkFighters → Target, `GetView` keeps the fighter names and units; `name` is who was targeted. After MarkCandidate A → Target, `name` is the Target and `unit` stays A's token. Name vs unit stay split. First Quiet Target refuse stays empty names. Mark* / Clear success still replace. Target does not call `Markers:Clear`. No `UnitIsDead`. No SecureActionButton. No combat automation. Isolated `lua tests/test_markers.lua` **563 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
