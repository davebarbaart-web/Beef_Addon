Spec PASS

# B38-C — Quiet Forget sweeps leftover raid marks (review)

**Quality:** Approved-with-nits

**Lane:** B38-C Quiet Forget sweeps leftover raid marks
**Brief:** `docs/reformation/vestments/briefs/B38-C-mark-forget.md`
**Writer report:** `docs/reformation/vestments/briefs/B38-C-mark-forget-report.md`
**Diff:** `docs/reformation/vestments/briefs/B38-C-mark-forget.diff` (B38-C-only exclusive-pair packet vs the pre-lane B35-C tree; live `Markers.lua` / `test_markers.lua` also carry earlier Markers batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Markers.lua`, `tests/test_markers.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Markers.lua` (`Forget` ~328–358 / `Clear` ~298–326 / `clearPrior` ~126–142 / `remember` ~144–164 / `applyMark` ~112–122 / `isLocalPope` ~57–63 / `refuse` / `keepLastUnits` / `eventLive` / `isGrouped`), and `tests/test_markers.lua` (isolation wrap under the first `if standalone then`, B38-C block after B35-C ~981, surface `type(Markers.Forget)`, source `function Markers:Forget`, nested extract requires `applyMark` and no `:Clear(`, MarkCandidate A + EndEvent + Forget spies `{raid2, 0}` and nil units, Quiet Clear still refuses, MarkFighters pair + Forget spies clear A and B, empty Quiet Forget is true with no `SetRaidTarget`, unlisted Pope refuses, leftover + missing `SetRaidTarget` fail-closed); then ran `lua tests/test_markers.lua` (**634 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: Bible §8 current-subject marks; Law 5 (Pope client); Law 6 (Quiet Clear refuse stays — Forget is the Quiet leftover sweep, not a Clear exception). Anniversary `SetRaidTarget(target, userIndex)` — index `0` clears. `Clear` still refuses Quiet. `clearPrior` still only runs on new Mark\*. After End, leftover `last.unit` / `unitA` / `unitB` stay marked until `Forget`. `Markers:Forget()` works in Quiet. Pope-gated (same `isLocalPope` as Mark\*). `applyMark(unit, 0)` on leftover tokens, then remember empty (`verb = "Forget"`, no units). Does **not** call `Markers:Clear`. Missing `SetRaidTarget` fail-closed when leftovers exist. Mark\* / Clear success still replace. No `UnitIsDead`. Did not mutate `Markers.lua` or `test_markers.lua`. Did not commit. Did not edit glue, Hud, Console, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG.

This review does not sign the lane. Do not claim Gate W / Gate V / **POLISH:PASS**.

---

## Named risks

| Risk | Verdict |
|---|---|
| Forget refuses Quiet (it must work in Quiet) | **Pass. Verified.** Live `Forget` has no `eventLive` / `isGrouped` gate. `debug.getupvalue`: `Forget` closes `isLocalPope`, `applyMark`, `remember`, and `refuse` — not `eventLive`, `isGrouped`, or `clearPrior`. Body has none of those names. Nested: MarkCandidate A + `EndEvent` → `QUIET`, then Forget is true and spies `{raid2, 0}`. Reviewer probe: MarkFighters pair + `EndEvent` + Forget also sweeps A and B in Quiet. |
| Forget calls `Markers:Clear` (forbidden — Clear Quiet refuse must stay) | **Pass. Verified.** Extract pin: Forget body has no `:Clear(`. Live sweep is a local `applyMark(unit, 0)` over `last.unit` / `unitA` / `unitB`. Reviewer wrap of `Markers.Clear` stayed **0** through leftover A + End + Forget and through Quiet pair Forget. Quiet `Clear("Chuckroast")` after Forget (and after leftover without Forget) still `false, "quiet"` and does not `SetRaidTarget`. `Clear` ~300–301 still `eventLive()` first. Diff does not touch `Clear`. |
| Forget not Pope-gated | **Pass. Verified.** First line is `if not isLocalPope() then return refuse("Forget", "not a registered pope")`. Same writer as Mark\*. Nested: empty unlisted is false and spies nothing; leftover + unlisted is false, spies nothing, keeps `unit == "raid2"`. |
| Empty Quiet Forget still `SetRaidTarget` | **Pass. Verified.** Nested: fresh last, Pope, Quiet Forget is true, `#raidTargets == 0`, view `verb = "Forget"`, units nil. No leftover → `leftover` stays false → no `applyMark`. Reviewer probe: empty + missing `SetRaidTarget` still true (fail-closed is only when leftovers exist). |
| Unlisted Pope still sweeps | **Pass. Verified.** Pope gate runs before the sweep. Nested leftover + `popeFlag = false`: `false, "not a registered pope"`, `#raidTargets == 0`, `GetView().unit` stays `"raid2"`. Empty unlisted also spies nothing. |
| Missing `SetRaidTarget` with leftovers throws or succeeds | **Pass. Verified.** `applyMark` still `type(SetRaidTarget) ~= "function" → false`. Leftover + failed apply → `refuse("Forget", nil)` via `keepLastUnits`. Nested after End: `pcall` does not throw, return is false, `GetView().unit` stays `"raid2"`. |
| MarkCandidate A + EndEvent + Forget does not spy `SetRaidTarget(A, 0)` / GetView units not nil | **Pass. Verified.** Nested: A marks `raid2`; End → QUIET; spy list wiped; Forget spies one `{raid2, 0}`; view `ok` / `verb = "Forget"`; `unit` / `unitA` / `unitB` nil. Reviewer wrap: Clear count 0; view `name` / `index` / `nameA` also nil. |
| MarkFighters pair Forget does not clear A and B | **Pass. Verified.** Nested (Event, as the brief allowed): spies `{raid2, 0}` then `{raid3, 0}`; view units nil. Reviewer probe: same pair after `EndEvent` (Quiet leftover) also spies A then B at `0` and nils the view. Dedup `seen[unit]` would collapse a repeated token. |
| `UnitIsDead` / `GuildPromote` / `SecureActionButton` / Core `CreateFrame` introduced | **Pass.** Source has none of `UnitIsDead`, `GuildPromote`, `SetGuildMemberRank`, `SecureActionButton`, `CreateFrame`, `StartAttack`, `AttackTarget`, `AssistUnit`, `CastSpell`, or `UseAction`. Forget / Mark\* / Clear stay in `UI/Markers.lua`. No Core file in the packet. Suite `combatCalls` / chat / addon / sounds stay 0. |
| Isolation wrap rewritten / suite not exit 0 / exclusive breach (especially glue) | **Pass. Verified.** **634 / 0.** Writer-reported count matches. Isolation wrap stays **27** under the first `if standalone then`. Three `dofile`s unchanged (Common + Runtime + Markers). No new main-chunk locals (`ok` / `err` / `view` reused; extract / leftover-missing-API locals are `do`/`end`). Packet is the two named files. Live glue `afterEndEvent` still does not name `Markers:Forget` (B38-INT). Sibling dirt vs HEAD (glue / TOC / `run.lua`) is other lanes, not this packet. Reviewer did not commit. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit glue (integrator owns `afterEndEvent`); no commit | **Pass.** Named-risk check. Reviewer did not commit. |
| `Markers:Forget()` works in Quiet. No Quiet / group gate | **Pass.** Brief vs `Markers.lua` ~328–358. Named-risk check. |
| Pope-gated (same writer as Mark\*) | **Pass.** Named-risk check. |
| `applyMark(unit, 0)` on leftover `last.unit` / `unitA` / `unitB`, then remember empty (`verb = "Forget"`, no units) | **Pass.** Sweep then `remember({ verb = "Forget", ok = true })`. Nested + reviewer spy. |
| Do **not** call `Markers:Clear`. Clear Quiet refuse stays | **Pass.** Named-risk check. `Clear` ~300–301 unchanged. |
| Missing `SetRaidTarget` fail-closed when leftovers exist | **Pass.** Named-risk check. Empty last does not need the API. |
| Mark\* / Clear success still replace | **Pass.** Those success paths still `remember({...})` with caller fields only. Reviewer probe: Forget then MarkCandidate replaces verb / unit; Event Clear still records `Clear` / index `0`. |
| `clearPrior` stays; only runs on new Mark\* | **Pass.** Helper body unchanged. Forget does not close `clearPrior`. Mark\* still call it; `Clear` / `Target` / `Forget` do not. |
| No `UnitIsDead`. Isolation wrap stays. Tests after the B35-C block | **Pass.** Block starts at `test_markers.lua` ~981. Named-risk check. |
| `lua tests/test_markers.lua` exit 0 | **Pass.** **634 / 0.** Wrap **27**. |

Bible §8 holds on the exclusive pair: after End, leftover raid marks are no longer current-subject marks; Quiet `Forget` sweeps remembered tokens at index `0` so they do not linger as if they were still the subject. Law 3 / Law 4 hold: the sweep is Pope-commanded leftover cleanup, not an auto-ritual or narration. Law 5 holds: same `isLocalPope` as Mark\*; unlisted Pope does not `SetRaidTarget`. Law 6 holds: `Clear` still refuses Quiet; Forget is a new verb, not a Clear exception; empty Quiet Forget does not touch the world. Anniversary `SetRaidTarget(target, 0)` is the existing clear index inside `applyMark`.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; Anniversary leftover marks after End, then Forget on the Pope client, is unsmoked. Integrator still owns `afterEndEvent` → `Markers:Forget` (B38-INT) | **Not a miss.** Brief forbade editing glue and asked the isolated suite. Live `afterEndEvent` still does not call Forget. |
| Remembered tokens, not names. Roster shuffle may `applyMark` index `0` on a different person (same as `clearPrior`) | **On contract.** Brief named leftover `last.unit` / `unitA` / `unitB`, not `resolveUnit`. |
| Partial world sweep on apply fail. One leftover `applyMark(0)` can succeed before a later one fails; refuse keeps last so a retry can sweep again | **On contract.** Brief asked fail-closed + keep, not transactional world rollback. Reviewer probe: second `SetRaidTarget` error → Forget false, `unitA` / `unitB` kept. |
| Empty Quiet Forget does not need `SetRaidTarget`. Missing-API fail-closed is only when leftovers exist | **On contract.** Brief tests: empty Quiet Forget is true and does not `SetRaidTarget`. Reviewer probe: empty + missing API is true. |
| Player-token leftover Forget is not newly pinned | **On contract.** Brief pins raid2 / raid3 leftovers. Reviewer probe: `"player"` leftover after End spies `SetRaidTarget("player", 0)` and nils the view. |
| Forget view still `mode = "Event"`. `remember` always writes Event. Markers.MODE stays Event | **On contract.** Brief asked remember empty (`verb = "Forget"`, no units), not a Quiet mode redeclaration. |
| MarkFighters Forget is pinned in Event. Brief did not require EndEvent on that case | **On contract.** Quiet leftover sweep is the MarkCandidate A + EndEvent pin. Reviewer probe: fighters + End + Forget also clears A and B. |
| Extract guard is TDD leftover. Source pins are substrings | **On contract as a pin.** Live call is real (`applyMark(unit, 0)` then `remember`); reviewer upvalue + Clear wrap close the hole. |
| Full `lua tests/run.lua` was not run | **Not a miss.** Brief asked the isolated suite. |
| Gate W / Gate V stay OPEN; not signed | **On contract.** This review does not sign the lane. |

The leftover (after End, `last.unit` / `unitA` / `unitB` stay marked in the world because `Clear` refuses Quiet and `clearPrior` only runs on new Mark\*) is this lane's spec. It is closed on the exclusive pair. Wiring `afterEndEvent` → `Forget` is B38-INT.

---

## Isolation / Forget / keep

**Isolation wrap — Pass.** Load list is still wow_ui_stub + Common + Runtime + Markers. No `dofile` of Knighting / Gora / Store / UI shell / Net / Console / glue. Standalone wrap is still **27** nils (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Console, Sender, Store, Gora, Knighting, FighterCard, Confession, Inputs, ConsoleDock, Decree, slash). Wrap is load-time only (unchanged). Reviewer recount of the load-time pins: **27**.

**Forget — Pass.** Pope gate first. No Quiet / group gate. Local `sweep` marks `leftover` on any non-empty string token, dedups via `seen`, and `applyMark(unit, 0)`. Leftover + failed apply → `refuse("Forget", nil)` (keeps last). Success `remember({ verb = "Forget", ok = true })` — units / names / indices omitted, so they become nil. Does not call `Markers:Clear` or `clearPrior`. `pcall(SetRaidTarget, …)` stays inside `applyMark`.

**Keep — Pass.** `Clear` still refuses Quiet (`"quiet"`). Event + Pope + grouped still required for Mark\* / Clear (Target still ungrouped-ok). `clearPrior` stays on Mark\* only. `"player"` resolve stays. B16-D / B18-D / B22-C / B32-D / B33-C / B34-C / B35-C pins stay ahead of the new block. Mark\* / Clear success still replace. No GuildPromote / SetGuildMemberRank / StartAttack / AttackTarget / AssistUnit / UnitIsDead / SecureActionButton / CreateFrame. No new main-chunk locals.

---

## Strengths

- Forget is a new verb beside `Clear`, not a Quiet hole in `Clear`. The leftover sweep reuses `applyMark(unit, 0)` and `remember` empty, so Clear's Event + name + group gates stay intact.
- Pope gate is the first line, so unlisted Pope cannot sweep. Empty last does not touch `SetRaidTarget`. Leftover + missing API refuses and keeps the token.
- The A + EndEvent pin is the product path: world leftover after Quiet, then one `{A, 0}` and a nil view. Quiet Clear is re-asserted on the same fixture so a Clear exception would fail.
- Fighters pair, empty Quiet, unlisted (empty and leftover), and leftover + missing API sit next to that path, so a Quiet refuse, a Clear call, an always-`SetRaidTarget`, or a wipe-on-fail would fail.
- `run` order is after B35-C. Isolation wrap stays **27**. No new main-chunk locals. Writer-reported **634 / 0** matched the re-run. Writer-reported red (surface / source / first live `Forget` nil) matches a missing verb.

---

## Issues

### Critical

None.

### Important leftover — not must-fix

1. **Client leftover marks after End, then Pope `Forget`, is unsmoked.** Isolated spies prove `{unit, 0}` and a nil view. They do not prove Anniversary raid-assist actually clears the world icon. Glue `afterEndEvent` still does not call `Markers:Forget` — that is B38-INT, and the brief forbade editing glue.

2. **Partial world sweep on apply fail.** If one leftover `applyMark(0)` succeeds and a later one fails, some marks are already `0` in the world; refuse keeps last so a retry can sweep again. Brief asked fail-closed + keep, not rollback. Same class of leftover as `clearPrior` ignoring `applyMark(0)` failure.

### Nit

1. **Forget view still `mode = "Event"`.** `remember` always writes Event. `Markers.MODE` stays Event. Brief asked empty units, not a Quiet redeclaration. Reviewer spy confirmed.

2. **MarkFighters Forget is pinned in Event.** Brief did not require EndEvent on that case. Reviewer probe: fighters + End + Forget also clears A and B in Quiet.

3. **Player-token leftover Forget is not newly pinned.** Reviewer probe: `"player"` leftover after End spies `SetRaidTarget("player", 0)` and nils the view.

4. **Unlisted leftover pin is still Event** (`popeFlag = false` after MarkCandidate, no EndEvent). Same `isLocalPope` gate; Quiet unlisted leftover would refuse the same way.

5. **Remembered tokens, not names.** Roster shuffle may clear a different person. Same as `clearPrior`. Brief named leftover tokens.

6. **Extract guard is TDD leftover.** `if forgetStart and viewStart then` avoids `src:sub(nil, …)` when the verb is missing. Live call is real.

7. **Source pins are substrings.** `applyMark` inside the Forget extract would pass on a comment. Reviewer upvalue + Clear wrap + `SetRaidTarget` spies close the hole.

8. **Empty + missing `SetRaidTarget` succeeds.** On contract. Fail-closed is leftover-only. Not a new suite pin.

9. **Missing-API leftover pin does not assert `err`.** Live `refuse("Forget", nil)` so `err` is nil. Brief asked fail-closed, not a named error string.

10. **Isolation wrap is load-only.** Twenty-seven pins under the first `if standalone then`. Brief said the wrap stays; it did.

11. **Exclusive-pair diff is not a vs-HEAD Markers delta.** Both exclusive files were already untracked. Packet is the B38-C-only `Forget` + pins. Report already says this.

12. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **634 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**1. Spec PASS.** Brief: `Markers:Forget()` works in Quiet; Pope-gated; `applyMark(unit, 0)` on leftover `last.unit` / `unitA` / `unitB`; then remember empty (`verb = "Forget"`, no units); do not call `Markers:Clear`; Clear Quiet refuse stays; missing `SetRaidTarget` fail-closed when leftovers exist; Mark\* / Clear success still replace; tests after B35-C. Live `Forget` ~328–358 matches. Brief test pins sit after the B35-C Target-name block (`test_markers.lua` ~981).

**2. Quality: Approved-with-nits.** Must-fix none. Important leftovers: client leftover sweep unsmoked (glue `afterEndEvent` → Forget is B38-INT); partial world sweep on apply fail. Nits listed above.

**3. Isolation count:** **634 passed, 0 failed.** Isolation wrap: **27**.

**4. Law:** Bible §8 holds. After End, leftover tokens are swept only when the Pope calls Forget; they are no longer presented as current-subject marks. Law 3 / Law 4 hold: leftover cleanup is a Pope verb, not an auto-ritual or narration. Law 5 holds: unlisted Pope does not `SetRaidTarget`. Law 6 holds: `Clear` still refuses Quiet; empty Quiet Forget does not touch the world; Forget is not a Clear exception.

**Leftovers:**
- Client Anniversary leftover marks after End, then Pope Forget, is unsmoked (Important, not must-fix). Glue `afterEndEvent` → `Markers:Forget` is B38-INT.
- Partial world sweep on apply fail (Important, not must-fix; refuse keeps last).
- Forget view still `mode = "Event"`.
- MarkFighters Forget is pinned in Event (reviewer probe: Quiet pair leftover also clears A and B).
- Player-token leftover Forget is not newly pinned (reviewer probe: `"player", 0`).
- Unlisted leftover pin is Event, not Quiet-after-End.
- Remembered tokens, not names; roster shuffle may clear the wrong person.
- Extract guard is TDD leftover; source pins are substrings.
- Empty + missing `SetRaidTarget` succeeds (on contract).
- Missing-API leftover pin does not assert `err`.
- Isolation wrap is load-only.
- Exclusive-pair packet is not a vs-HEAD Markers delta.
- Full `lua tests/run.lua` was not run.
- Gate W stays OPEN. Gate V stays OPEN.

`Markers:Forget()` works in Quiet. Pope-gated. Sweeps leftover `last.unit` / `unitA` / `unitB` through `applyMark(unit, 0)`, then remembers empty (`verb = "Forget"`, units nil). Does not call `Markers:Clear`. Clear Quiet refuse stays. Empty Quiet Forget does not `SetRaidTarget`. Unlisted Pope does not sweep. Leftover + missing `SetRaidTarget` is false and keeps the unit. MarkCandidate A + EndEvent + Forget spies `{A, 0}`. MarkFighters pair Forget spies clear A and B. Isolation wrap stays **27**. Isolated `lua tests/test_markers.lua` **634 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane. Do not claim Gate W, Gate V, or POLISH:PASS.
