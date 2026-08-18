Spec PASS

# B33-C — Gate refuse keeps remembered mark units (review)

**Quality:** Approved-with-nits

**Lane:** B33-C Gate refuse keeps remembered mark units
**Brief:** `docs/reformation/vestments/briefs/B33-C-markers-keep.md`
**Writer report:** `docs/reformation/vestments/briefs/B33-C-markers-keep-report.md`
**Diff:** `docs/reformation/vestments/briefs/B33-C-markers-keep.diff` (B33-C-only exclusive-pair packet; live `Markers.lua` / `test_markers.lua` are still untracked vs HEAD and also carry earlier Markers batches)
**Exclusive files:** `addon/ChurchOfBeef/UI/Markers.lua`, `tests/test_markers.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Markers.lua` (`refuse` copies omitted `unit` / `unitA` / `unitB` / `index` / `indexA` / `indexB` from `last` via `== nil` then `remember`; `clearPrior` / Mark* / `Clear` / `Target` / `resolveUnit` / `applyMark` unchanged), and `tests/test_markers.lua` (source `refuse` copies last units / indices and no `:Clear(`, first Quiet empty units, MarkCandidate A then Ghost keeps A's token, MarkCandidate B spies `{raid2, 0}` then `{raid3, 1}`, Ghost after fighters keeps `unitA` / `unitB`, successful Clear still records Clear, B32-D clearPrior / B16-D / B18-D / B22-C pins, isolation wrap); then ran `lua tests/test_markers.lua` (**491 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: B32-D leftover (`refuse` → `remember` replaced `last`, so a Ghost miss after A dropped `last.unit` and B could not `clearPrior`); Bible §8 (marks on the **current** candidate / fighters); Law 5 (Pope client); Law 6 (Quiet refuse). Ghost miss after A keeps A's unit so B can `clearPrior`. First Quiet refuse empty. No `UnitIsDead`. Do not call `Markers:Clear` from refuse. `clearPrior` stays. No SecureActionButton. No combat automation. Isolation wow_ui_stub + Common + Runtime + Markers only. Did not mutate `Markers.lua` or `test_markers.lua`. Did not commit. Did not edit glue, Console, TOC, bootstrap, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Ghost miss after A drops `last.unit` so B cannot `clearPrior` (missing keep) | **Pass. Verified.** `refuse` copies omitted unit / index fields from `last` (`== nil`) before `remember`. Pin: A then Ghost, `GetView().unit` stays `raid2`, index `1`; Ghost does not spy. Then Tendermage spies `{raid2, 0}` then `{raid3, 1}`. Reviewer probe: same sequence; runtime wrap of `Markers.Clear` stayed **0**. Quiet / ungrouped / unlisted Pope / invalid-name / Clear-Ghost / Target-Quiet after a live mark also keep A's token; a later Event remake still `clearPrior`s A. Fighters then Ghost keeps `unitA` / `unitB`; a later candidate clears both. |
| First Quiet / not-pope / ungrouped refuse invents units | **Pass. Verified.** Fresh `last` is `{ mode = "Event" }`. Copy of nil stays nil. Pins: first Quiet block (after Target / Mark* / Clear in the same reset) has no `unit` / `unitA` / `unitB`. Reviewer probe: first Quiet / first not-pope / first ungrouped are empty units and empty indices. |
| `refuse` calls `Markers:Clear` (overwrites `last` / clears in-world) | **Pass. Verified.** `refuse` body has no `:Clear(`, `Markers.Clear`, `self:Clear`, or `clearPrior`. It only copies then `remember`. `debug.getupvalue`: `clearPrior` is still an upvalue of Mark* only, not of `Clear`. Reviewer wrap of `Markers.Clear` stayed **0** across Ghost miss and the successful B remake. Fail-closed Ghost still does not `SetRaidTarget`. |
| `UnitIsDead` / SecureActionButton / combat automation | **Pass.** Source has none of `UnitIsDead`, `SecureActionButton`, `StartAttack`, `AttackTarget`, `AssistUnit`, `CastSpell`, `UseAction`, `GuildPromote`, `SetGuildMemberRank`, or `CreateFrame`. Suite `combatCalls` / chat / addon / sounds stay 0. Reviewer probe: combat flag + A then Ghost then B still `combatCalls == 0` and still spies `{raid2, 0}` then `{raid3, 1}`. |
| `clearPrior` / successful Mark* replace / successful Clear / player-token pins drop | **Pass.** Packet does not rewrite `clearPrior`, Mark* success, `Clear`, `Target`, or `resolveUnit`. B32-D A-then-B / remake / outsider / keep-set / player-prior / Quiet-after-live / ungrouped-after-live pins stay. Successful B after Ghost replaces last (`unit == raid3`). Successful Clear still records `verb == "Clear"`, unit, index `0`. Reviewer probe: Ghost after Clear keeps that unit and index `0` (`== nil` does not treat `0` as omitted). Caller-passed applyMark-fail fields win (`raid3`, 1), not the prior token. |
| Isolated suite not exit 0 | **Pass. Verified.** 491 passed, 0 failed. Writer-reported count matches. |
| Exclusive file breach | **Pass.** Provided packet is two hunks: `refuse` copy-from-last, and the test pins (first Quiet empty units, source extract, A then Ghost then B, fighters keep, successful Clear). Sibling dirt vs HEAD (Console, Inputs, BeefNet, TOC, bootstrap, `run.lua`) is other lanes, not this packet. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit glue / Console; no commit | **Pass.** Named-risk check. |
| Isolation stays wow_ui_stub + Common + Runtime + Markers | **Pass.** Three `dofile`s unchanged. Wrap is still **27** nil-module / slash pins under `if standalone then`. |
| `refuse` copies `last.unit` / `last.unitA` / `last.unitB` (and their indices) when the caller omitted them | **Pass.** Named-risk check. `== nil` so index `0` stays. |
| Then `remember`. Successful Mark* still replace last. Successful `Clear` still records Clear | **Pass.** Named-risk check. |
| Ghost miss after A keeps A's unit so B can `clearPrior` (`{A, 0}` then `{B, 1}`) | **Pass.** Named-risk check. B32-D leftover is closed on the path the brief named. |
| First Quiet / not-pope / ungrouped refuse of a first mark stays empty units | **Pass.** Named-risk check. Quiet is pinned; not-pope / ungrouped hold on probe. |
| No `Markers:Clear` from refuse. `clearPrior` stays | **Pass.** Named-risk check. |
| Existing clearPrior / player-token / Quiet / ungrouped / B16-D / B18-D / B22-C pins stay | **Pass.** Named-risk check. |
| No `UnitIsDead`; no SecureActionButton; no combat automation; existing `pcall(SetRaidTarget, …)` stays | **Pass.** Named-risk check. `applyMark` body is unchanged. |
| `lua tests/test_markers.lua` exit 0 | **Pass.** **491 / 0.** |

Bible §8 (marks on the current candidate / fighters) and Law 5 / Law 6 hold on the exclusive pair. The B32-D leftover (Ghost miss after A dropped `last.unit`) is closed. wow-api `classic_anniversary`: `SetRaidTarget(target, userIndex)` exists. Index `0` is the existing `Clear` path. No `UnitIsDead` is required for keep. Brief forbids `SecureActionButton` and `Markers:Clear` from refuse; they kept `pcall` and copy-then-`remember`.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; Anniversary `SetRaidTarget(unit, 0)` on a remembered prior token after a Ghost miss is unsmoked | **Not a miss.** Brief asked the isolated suite. Reviewer spy proves keep then `{A, 0}` `{B, 1}`; it does not prove pixels or raid-assist. |
| `GetView` name vs unit. Ghost refuse records `name = "Ghost"` while `unit` stays the prior token | **On contract.** Brief asked keep of units / indices so `clearPrior` can read tokens. `clearPrior` does not read names. |
| `clearPrior` ignores `applyMark(0)` failure and still applies the new mark | **On contract.** Pre-lane helper. Brief said `clearPrior` stays. |
| Remembered tokens, not names; roster shuffle may `applyMark` index `0` on a different person | **On contract.** Brief named `last.unit` / `last.unitA` / `last.unitB`. |
| Full `lua tests/run.lua` was not run | **Not a miss.** Brief asked the isolated suite. |
| Gate W / Gate V stay OPEN; not signed | **On contract.** This review does not sign the lane. |

B33-INT glue is not required. Mark* / Clear / Target already go through `refuse` / `remember`.

---

## Isolation / refuse / gates

**Isolation wrap — Pass.** Load list is still wow_ui_stub + Common + Runtime + Markers. No `dofile` of Knighting / Gora / Store / UI shell / Net / Console. Standalone wrap is still **27** nils (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Console, Sender, Store, Gora, Knighting, FighterCard, Confession, Inputs, ConsoleDock, Decree, slash). Wrap is load-time only (unchanged).

**refuse — Pass.** Helper is still `local function refuse`. It does not call `Markers:Clear` or `clearPrior`. Omitted unit / index fields are copied from `last` with `== nil` (index `0` is kept). Caller-passed applyMark-fail fields win. `remember` still replaces `last`. Successful Mark* / Clear still go through `remember` without that copy.

**Gates — Pass.** Quiet / missing Runtime / unlisted Pope / ungrouped / invalid name / unit-not-found still refuse before `clearPrior` / `applyMark`. Event + Pope + grouped still required. `"player"` resolve stays. First-mark refuse stays empty. Fail-closed remakes after a live mark now keep tokens and still do not spy.

---

## Strengths

- The leftover is closed on the existing remember path: six `== nil` copies inside `refuse`, then `remember`. `clearPrior` is left alone. `Markers:Clear` is not called from refuse, so a Ghost miss does not wipe in-world marks or clobber `last` into a Clear record.
- A then Ghost then B is pinned as keep plus `{raid2, 0}` `{raid3, 1}`. First Quiet empty units sit on the existing Quiet block. Fighters keep and successful Clear are pinned. Isolation wrap and B16-D / B18-D / B22-C / B32-D pins stay.
- `debug.getupvalue` shows `clearPrior` still on Mark* only. A runtime wrap of `Markers.Clear` stayed at 0 through Ghost and the remake.
- Packet does not rewrite `resolveUnit`, `applyMark`, `clearPrior`, `Clear`, `Target`, or `isGrouped`.
- Writer-reported **491 / 0** matched the re-run. Writer-reported red (**474 / 17**) matches a block that old `refuse` (no copy) would fail.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Client `SetRaidTarget(unit, 0)` on a remembered prior token after a Ghost miss is unsmoked.** The suite cannot prove Anniversary clears the old raid icon, or that the Pope client has raid-assist. `wow_ui_stub` `SetRaidTarget` is a spy list. Brief scoped this lane to the isolated suite. Reviewer spy proves keep then the `0` / new-index order; it does not prove pixels.

2. **Successful `Target` still replaces `last` without units.** After A, a successful Target, then MarkCandidate B spies only `{raid3, 1}` — A is not `clearPrior`'d. Reviewer probe. Out of this lane's `refuse` copy. Brief named refuse keep, not Target success `remember`.

### Nit

1. **`GetView` name vs unit.** Ghost refuse records `name = "Ghost"` (and drops `nameA` / `nameB` on a cross-verb refuse) while tokens stay. `clearPrior` reads tokens. Brief did not ask name copy.

2. **`clearPrior` ignores `applyMark(0)` failure** and still applies the new mark. If the new `applyMark` then fails, the caller-supplied unit/index win and the in-world prior is already index `0`. Pre-lane. Brief said `clearPrior` stays.

3. **Remembered tokens, not names.** If the raid roster shuffles, `last.unit` may `applyMark` index `0` on a different person.

4. **Source pins are substrings.** `fields.unit = last.unit` and no `:Clear(` would pass on a comment inside the extract. Live call is real (`== nil` then `remember`); reviewer upvalue + Clear wrap close the hole.

5. **First not-pope / first ungrouped empty units are unpinned.** Brief named them. Quiet is pinned. Reviewer probe: both stay empty.

6. **Quiet / ungrouped / unlisted / invalid-name / Clear-Ghost keep after a live mark, and fighters-then-Ghost-then-candidate clear, are unpinned.** Brief named Ghost after A then B, plus fighters GetView keep. Reviewer probe: those paths keep tokens and still `clearPrior`.

7. **Caller-passed applyMark-fail win is unpinned.** Report contract states it. Reviewer probe: A then failing B remembers `raid3` / 1, not A.

8. **Isolation wrap is load-only.** Twenty-seven pins under `if standalone then` at file load. Brief said the wrap stays; it did.

9. **Exclusive-pair diff is not a vs-HEAD Markers delta.** Both exclusive files are untracked. Packet is the B33-C-only `refuse` copy + pins. Report already says this.

10. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **491 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **491 passed, 0 failed.** Isolation wrap: **27**.

**Leftovers:**
- Client Anniversary `SetRaidTarget(unit, 0)` on a remembered prior token after a Ghost miss is unsmoked (Important, not must-fix).
- Successful `Target` replaces `last` without units; A then Target then B cannot clear A (Important, not must-fix; out of refuse).
- `GetView` name vs unit; Ghost records `name = "Ghost"` while `unit` stays the prior token.
- `clearPrior` ignores `applyMark(0)` failure; a failed new `applyMark` has already cleared the prior.
- Remembered tokens, not names; roster shuffle may clear the wrong person.
- Source pins are substrings, not a `SetRaidTarget` spy on `refuse`.
- First not-pope / first ungrouped empty units are unpinned (reviewer probed; they hold).
- Quiet / ungrouped / unlisted / invalid-name / Clear-Ghost keep after a live mark, and fighters-then-Ghost-then-candidate clear, are unpinned (reviewer probed; they hold).
- Caller-passed applyMark-fail win is unpinned (reviewer probed; it holds).
- Isolation wrap is load-only.
- Exclusive-pair packet is not a vs-HEAD Markers delta.
- Full `lua tests/run.lua` was not run.
- Gate W stays OPEN. Gate V stays OPEN.

`refuse` copies omitted `last.unit` / `last.unitA` / `last.unitB` and their indices (`== nil`) then `remember`. Ghost miss after A keeps A's token so B `clearPrior`s `{A, 0}` then marks `{B, 1}`. First Quiet refuse stays empty units. `refuse` does not call `Markers:Clear`. `clearPrior` stays. No `UnitIsDead`. No SecureActionButton. No combat automation. Isolated `lua tests/test_markers.lua` **491 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
