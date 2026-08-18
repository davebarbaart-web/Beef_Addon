Spec PASS

# B34-C — successful Target keeps last mark units (review)

**Quality:** Approved-with-nits

**Lane:** B34-C successful Target keeps last mark units
**Brief:** `docs/reformation/vestments/briefs/B34-C-target-keep.md`
**Writer report:** `docs/reformation/vestments/briefs/B34-C-target-keep-report.md`
**Diff:** `docs/reformation/vestments/briefs/B34-C-target-keep.diff` (B34-C-only exclusive-pair packet vs the pre-lane B33-C tree; live `Markers.lua` / `test_markers.lua` still carry earlier Markers batches)
**Exclusive files:** `addon/ChurchOfBeef/UI/Markers.lua`, `tests/test_markers.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Markers.lua` (`keepLastUnits` copies omitted `unit` / `unitA` / `unitB` / `index` / `indexA` / `indexB` from `last` via `== nil`; `refuse` is `remember(keepLastUnits(fields))`; successful `Target` is `remember(keepLastUnits({ verb = "Target", ok = true, name = trimmed }))`; Mark* / `Clear` success still `remember` without that copy; `Target` does not call `Markers:Clear` or `clearPrior`; no `UnitIsDead`), and `tests/test_markers.lua` (B34-C block after the B33-C Clear pins; source `Target` success `keepLastUnits` / `remember(keepLastUnits` and no `:Clear(` / `clearPrior`; MarkCandidate A then Target Tendermage keeps A's `unit` / `index`; MarkCandidate B spies `{raid2, 0}` then `{raid3, 1}`; MarkFighters pair + Target keeps `unitA` / `unitB`; failed Target after A still keeps; B33-C refuse / Ghost / Clear pins; isolation wrap); then ran `lua tests/test_markers.lua` (**543 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: B33-C leftover (successful `Target` `remember({ verb, ok, name })` replaced `last` wholesale and wiped the prior mark token); Bible §8 (marks on the **current** candidate / fighters); Law 5 (Pope client); Law 6 (Quiet refuse). Anniversary `TargetUnit([name], [exactMatch])`. Successful Target keeps omitted last units so the next Mark* can still `clearPrior` the current subject. `Target` is `TargetUnit` only. No `UnitIsDead`. Do not call `Markers:Clear` from Target. No SecureActionButton. No combat automation. Isolation wow_ui_stub + Common + Runtime + Markers only. Did not mutate `Markers.lua` or `test_markers.lua`. Did not commit. Did not edit glue, Hud, Console, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Successful Target still replaces `last` without units, so A → Target B → Mark C cannot `clearPrior` A (B33-C leftover) | **Pass. Verified.** Brief L11 vs `Markers.lua` L215: success is `remember(keepLastUnits({ verb = "Target", ok = true, name = trimmed }))`. Helper L166–186 is the same `== nil` copy as refuse (`unit` / `index` / `unitA` / `unitB` / `indexA` / `indexB`). Pin: A then Tendermage Target, `GetView().unit` stays `raid2`, index `1`; Target does not spy `SetRaidTarget`. Then Tendermage mark spies `{raid2, 0}` then `{raid3, 1}`. `debug.getupvalue`: `keepLastUnits` is an upvalue of `Target` and of `refuse`. Reviewer wrap of `Markers.Clear` stayed **0** through A → Target → B. |
| Target success copy is not the same `== nil` helper as refuse | **Pass.** Brief L11 allowed a small keep helper used by both. `refuse` is `remember(keepLastUnits(fields))` (L194). B33-C extract now starts at `keepLastUnits` so the six `fields.* = last.*` pins still see the helper. Index `0` is kept (`== nil`, not `or`). Reviewer probe: Clear then Target keeps `unit` and index `0`. |
| Mark* / Clear success start using the keep helper and stop replacing last | **Pass.** Brief L11. MarkCandidate L240–246, MarkFighters L280–289, and Clear L313–319 still `remember({...})` with caller units / indices. B33-C successful-B-after-Ghost and successful-Clear pins stay. B34-C successful B after Target replaces last (`unit == raid3`). |
| `Markers:Clear` / `clearPrior` from Target | **Pass. Verified.** Brief L5. Target body (L197–216) has no `:Clear(`, `Markers.Clear`, `self:Clear`, or `clearPrior`. Source pin. `debug.getupvalue`: `clearPrior` is an upvalue of Mark* only, not of `Target` or `Clear`. Reviewer wrap of `Markers.Clear` stayed **0**. |
| First Quiet refuse invents units after the helper extract | **Pass.** Fresh `last` is `{ mode = "Event" }`. Copy of nil stays nil. Existing first Quiet pins (no `unit` / `unitA` / `unitB`) stay. Reviewer probe: first Quiet / first not-pope / first ungrouped stay empty units and empty indices. |
| Failed Target drops A's token | **Pass.** Brief L11. Failed Target still `refuse` (L211–213). Pin: A then `TargetUnit` error, `GetView().unit` stays `raid2`. Already refuse; helper is shared. |
| `UnitIsDead` / SecureActionButton / combat automation / mark-on-Target | **Pass.** Source has none of `UnitIsDead`, `SecureActionButton`, `StartAttack`, `AttackTarget`, `AssistUnit`, `CastSpell`, `UseAction`, `GuildPromote`, `SetGuildMemberRank`, or `CreateFrame`. Target is `pcall(TargetUnit, trimmed, true)` only (L211). Suite `combatCalls` / chat / addon / sounds stay 0. Reviewer probe: combat flag + A then Target still `combatCalls == 0` and `#raidTargets` stays 1 through Target. |
| Isolated suite not exit 0 | **Pass. Verified.** 543 passed, 0 failed. Writer-reported count matches. |
| Exclusive file breach | **Pass.** Provided packet is two hunks: `keepLastUnits` extract + Target success `remember(keepLastUnits(...))`, and the B34-C test block after B33-C (plus the B33-C extract widen to the helper). Sibling dirt vs HEAD is other lanes, not this packet. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit glue / Hud / Console; no commit | **Pass.** Named-risk check. Brief L5. |
| Isolation stays wow_ui_stub + Common + Runtime + Markers | **Pass.** Three `dofile`s unchanged. Wrap is still **27** nil-module / slash pins under `if standalone then`. Brief L15. |
| Successful Target `remember` keeps omitted `last.unit` / `unitA` / `unitB` (+ indices), same `== nil` copy as refuse | **Pass.** Brief L11 vs `Markers.lua` L166–186 / L215. Named-risk check. |
| May extract a small keep helper used by both refuse and Target success | **Pass.** Brief L11. `keepLastUnits` is that helper. |
| MarkCandidate / MarkFighters / Clear success still replace | **Pass.** Brief L11. Named-risk check. B33-C pins stay. |
| First Quiet refuse stays empty units | **Pass.** Brief L11. Named-risk check. |
| Failed Target still keeps (already refuse) | **Pass.** Brief L11. Named-risk check. |
| No `Markers:Clear` from Target. No `UnitIsDead` | **Pass.** Brief L5. Named-risk check. |
| Tests after the B33-C block. Source pin: Target success copies last units when omitted. Runtime A → Target other name → GetView keeps A; then Mark B spies `{A, 0}` `{B, 1}`. Fighters + Target keeps `unitA` / `unitB` | **Pass.** Brief L15. Block starts after the B33-C Clear pins (`test_markers.lua` L840). Source extract L847–856. Runtime L858–932. |
| `lua tests/test_markers.lua` exit 0 | **Pass.** Brief L17. **543 / 0.** |

Bible §8 (marks on the current candidate / fighters) and TargetUnit-only hold on the exclusive pair. The B33-C leftover (successful Target wiped `last.unit`) is closed. wow-api `classic_anniversary`: `TargetUnit([name], [exactMatch])` exists. Target still `pcall(TargetUnit, trimmed, true)`. Targeting is not a subject-mark change; the remembered token stays so the next Mark* can clear the current marked subject. No `UnitIsDead` is required for keep. Brief forbids `Markers:Clear` from Target; they kept `TargetUnit` + keep-then-`remember`.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; Anniversary `TargetUnit(name, true)` after a live mark, and later `SetRaidTarget(unit, 0)` on the remembered prior token, are unsmoked | **Not a miss.** Brief asked the isolated suite. Reviewer spy proves keep then `{A, 0}` `{B, 1}`; it does not prove pixels or raid-assist. |
| `GetView` name vs unit. Successful Target records `name = "Tendermage"` while `unit` stays the prior token | **On contract.** Brief asked keep of units / indices so `clearPrior` can read tokens. `clearPrior` does not read names. |
| `nameA` / `nameB` drop on a cross-verb Target | **On contract.** Brief L11 named unit / index keep only. |
| `clearPrior` ignores `applyMark(0)` failure and still applies the new mark | **On contract.** Pre-lane helper. Brief did not retask `clearPrior`. |
| Remembered tokens, not names; roster shuffle may `applyMark` index `0` on a different person | **On contract.** Brief named `last.unit` / `last.unitA` / `last.unitB`. |
| Source pins are substrings | **On contract as a pin.** Live call is real (`== nil` then `remember`); reviewer upvalue + Clear wrap close the hole. |
| Full `lua tests/run.lua` was not run | **Not a miss.** Brief asked the isolated suite. |
| Gate W / Gate V stay OPEN; not signed | **On contract.** This review does not sign the lane. |

B34-INT glue is not required. Mark* / Clear / Target already go through `refuse` / `remember` / `keepLastUnits`.

---

## Isolation / Target / gates

**Isolation wrap — Pass.** Load list is still wow_ui_stub + Common + Runtime + Markers. No `dofile` of Knighting / Gora / Store / UI shell / Net / Console. Standalone wrap is still **27** nils (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Console, Sender, Store, Gora, Knighting, FighterCard, Confession, Inputs, ConsoleDock, Decree, slash). Wrap is load-time only (unchanged). Reviewer recount of the load-time pins: **27**.

**Target — Pass.** Helper `keepLastUnits` is `== nil` copy then return fields. Successful Target omits unit fields, so they come from `last`. `Target` does not call `Markers:Clear` or `clearPrior`. `pcall(TargetUnit, trimmed, true)` stays. Event + Pope still required; group is not. First-mark Quiet refuse stays empty.

**Gates — Pass.** Quiet / missing Runtime / unlisted Pope / invalid name still refuse before `TargetUnit`. Missing `TargetUnit` / `TargetUnit` error still refuse and keep. `"player"` resolve stays on Mark*. Successful Mark* / Clear still replace last.

---

## Strengths

- The leftover is closed on the existing remember path: six `== nil` copies in `keepLastUnits`, used by refuse and by Target success. `clearPrior` is left alone. `Markers:Clear` is not called from Target, so a successful Target does not wipe in-world marks or clobber `last` into a Clear record.
- A then Target then B is pinned as keep plus `{raid2, 0}` `{raid3, 1}`. Fighters keep and failed Target keep are pinned. Isolation wrap and B16-D / B18-D / B22-C / B32-D / B33-C pins stay.
- `debug.getupvalue` shows `keepLastUnits` on refuse and Target, and `clearPrior` still on Mark* only. A runtime wrap of `Markers.Clear` stayed at 0 through Target and the remake.
- Packet does not rewrite `resolveUnit`, `applyMark`, `clearPrior`, Mark* success, or `Clear`.
- Writer-reported **543 / 0** matched the re-run. Writer-reported red (**530 / 13**) matches a block that old Target success (`remember({ verb, ok, name })` with no keep) would fail.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Client `TargetUnit(name, true)` after a live mark, and later `SetRaidTarget(unit, 0)` on the remembered prior token, are unsmoked.** The suite cannot prove Anniversary targets the other name, or that the Pope client has raid-assist to clear the old raid icon. `wow_ui_stub` `TargetUnit` / `SetRaidTarget` are spy lists. Brief scoped this lane to the isolated suite. Reviewer spy proves keep then the `0` / new-index order; it does not prove pixels.

### Nit

1. **`GetView` name vs unit.** Successful Target records `name = "Tendermage"` while `unit` stays A's token. `clearPrior` reads tokens. Brief did not ask name copy.

2. **`nameA` / `nameB` drop on a cross-verb Target.** After fighters, Target keeps `unitA` / `unitB` and drops the fighter names. Brief asked unit / index keep only. Reviewer probe: `nameA` / `nameB` are nil after fighters then Target; a later MarkCandidate of A still `clearPrior`s B (`{raid3, 0}` then `{raid2, 1}`).

3. **`clearPrior` ignores `applyMark(0)` failure** and still applies the new mark. If the new `applyMark` then fails, the caller-supplied unit/index win and the in-world prior is already index `0`. Pre-lane. Reviewer probe: A then Target then failing B remembers `raid3` / 1, not A.

4. **Remembered tokens, not names.** If the raid roster shuffles, `last.unit` may `applyMark` index `0` on a different person.

5. **Source pins are substrings.** `keepLastUnits` / `remember(keepLastUnits` and no `:Clear(` would pass on a comment inside the extract. Live call is real (`== nil` then `remember`); reviewer upvalue + Clear wrap close the hole.

6. **B34-C Target of Tendermage does not re-pin `exact == true`.** Existing Event + Pope Target pin still asserts `TargetUnit` exactMatch. Reviewer probe: B34-C path still passes `true`.

7. **First not-pope / first ungrouped empty units are unpinned.** Brief named first Quiet. Quiet is pinned. Reviewer probe: both stay empty after the helper extract.

8. **Clear-then-Target keep of index `0`, and fighters-then-Target-then-candidate clear of the other fighter, are unpinned.** Brief named A then Target then B, plus fighters GetView keep. Reviewer probe: those paths keep tokens and still `clearPrior`.

9. **Isolation wrap is load-only.** Twenty-seven pins under `if standalone then` at file load. Brief said the wrap stays; it did.

10. **Exclusive-pair diff is not a vs-HEAD Markers delta.** Both exclusive files were already dirty. Packet is the B34-C-only keep extract + Target success + pins. Report already says this.

11. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **543 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**1. Spec PASS.** Brief L11 (successful Target keep omitted `last.unit` / `unitA` / `unitB` + indices, same `== nil` as refuse; Mark* / Clear still replace) vs `Markers.lua` L166–186 / L194 / L215 / L240–246 / L280–289 / L313–319. Brief L5 (no `Markers:Clear` from Target; no `UnitIsDead`) vs Target L197–216 and source bans. Brief L15 (tests after B33-C; A → Target other name keeps A; then B spies `{A, 0}` `{B, 1}`; fighters keep) vs `test_markers.lua` L840–932.

**2. Quality:** no must-fix. One Important leftover (client Target / later `SetRaidTarget(0)` unsmoked). Nits as listed.

**3. Isolation count:** **543 passed, 0 failed.** Isolation wrap: **27**.

**4. Law:** Bible §8 current-subject marks hold: Target is targeting assist, not a subject-mark change; the current candidate / fighter tokens stay so the next Mark* can still clear them. Target is `TargetUnit([name], [exactMatch])` only — no `SetRaidTarget` on the Target path.

**Must-fix:** none.

**Leftovers:**
- Client Anniversary `TargetUnit(name, true)` after a live mark, and later `SetRaidTarget(unit, 0)` on the remembered prior token, are unsmoked (Important, not must-fix).
- `GetView` name vs unit; Target records `name = "Tendermage"` while `unit` stays the prior token.
- `nameA` / `nameB` drop on a cross-verb Target (brief asked unit / index keep only).
- `clearPrior` ignores `applyMark(0)` failure; a failed new `applyMark` has already cleared the prior.
- Remembered tokens, not names; roster shuffle may clear the wrong person.
- Source pins are substrings, not a `SetRaidTarget` spy on Target.
- B34-C Target of Tendermage does not re-pin exactMatch (existing pin + probe hold).
- First not-pope / first ungrouped empty units are unpinned (reviewer probed; they hold).
- Clear-then-Target keep of index `0`, and fighters-then-Target-then-candidate clear, are unpinned (reviewer probed; they hold).
- Isolation wrap is load-only.
- Exclusive-pair packet is not a vs-HEAD Markers delta.
- Full `lua tests/run.lua` was not run.
- Gate W stays OPEN. Gate V stays OPEN.

Successful Target `remember` keeps omitted `last.unit` / `last.unitA` / `last.unitB` and their indices (`== nil`, shared `keepLastUnits`) then `remember`. After MarkCandidate A → Target B → MarkCandidate C, `clearPrior` still clears A (`{A, 0}` then `{C, 1}`). MarkFighters pair + Target keeps `unitA` / `unitB`. Failed Target still keeps. First Quiet refuse stays empty units. Mark* / Clear success still replace. Target does not call `Markers:Clear`. No `UnitIsDead`. No SecureActionButton. No combat automation. Isolated `lua tests/test_markers.lua` **543 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
