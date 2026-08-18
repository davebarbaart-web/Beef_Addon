Spec PASS

# B34-B — leftover Presence buttons reset alpha (review)

**Quality:** Approved-with-nits

**Lane:** B34-B leftover Presence buttons reset alpha
**Brief:** `docs/reformation/vestments/briefs/B34-B-presence-alpha.md`
**Writer report:** `docs/reformation/vestments/briefs/B34-B-presence-alpha-report.md`
**Diff:** `docs/reformation/vestments/briefs/B34-B-presence-alpha.diff` (B34-B-only exclusive-pair packet; live `Console.lua` also carries earlier console batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Console.lua` (`acquireRows` leftover tail ~468–473 / `paintPresence` ~839–878 / `presenceLine` / `paintRowButtons` / empty Presence `acquireRows(..., 0)` / `GetPresence` / `paintPetitions` / `paintConfessions` / `paintKnightingLine` / `SaveNote`), and `tests/test_console.lua` (isolation wrap, nested `runB34B()` inside `runB8E()` after `runB33B()`); then ran `lua tests/test_console.lua` (**2398 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: Bible §18.1 Presence is who is here; B33-B dims visible `here == false` with stock `SetAlpha(0.45)`; leftover hide (`count + 1` tail, including count `0`) must `SetAlpha(1)` if present so a dim leftover does not keep `0.45`; visible `here == false` stays `0.45`; visible `here ~= false` stays `1`; no new Presence copy; petitions / confessions / knighting stay undimmed; `SaveNote` stays nil; no `UnitIsDead`; no SUMMON. Did not mutate `Console.lua` or `test_console.lua`. Did not commit. Did not edit Roster, Inputs, glue, TOC, bootstrap, `ChurchOfBeef.lua`, OPEN_QUESTIONS, REFORMATION_LOG, or `tests/run.lua`.

This review does not sign the lane. Do not claim Gate W / Gate V / **POLISH:PASS**.

---

## Named risks

| Risk | Verdict |
|---|---|
| Leftover Presence hide (`count + 1` tail, including count `0`) keeps last alpha | **Pass. Verified.** `acquireRows` leftover loop Hides, then type-guards `SetAlpha(1)` (brief L11 vs `Console.lua` ~468–473). Empty Presence goes through `acquireRows(..., 0)` (`paintPresence` ~848–852). Nested: nil Roster → `#GetPresence() == 0`; leftover Presence buttons hidden and `GetAlpha() == 1`. Reviewer probe matched count `0` and a 2→1 complete-roster leftover. |
| Visible `here == false` no longer `0.45` after leftover reset | **Pass. Verified.** `paintPresence` still walks `#rows` only after `paintRowButtons` (brief L11 vs ~868–876). Nested: fail-open Store ~0.45; after empty leftover reset, re-paint Store ~0.45. Reviewer probe matched. |
| Visible `here ~= false` no longer `1` | **Pass.** Else branch still `SetAlpha(1)`. Nested + probe: roster here stays 1 through fail-open, empty leftover, and re-paint. |
| New words: mute suffix / "offline" / "away" / "not here" | **Pass. Verified.** `presenceLine` is still name / rank / needs Knighting. Empty copy stays `"No one on the roster yet."` Nested: Store-only label keeps the name and has no offline / away / not-here suffix. Live `Console.lua` has no `offline` / `away` / `UnitIsDead`. |
| Petitions dimmed by leftover reset or by shared `paintRowButtons` | **Pass. Verified.** `paintRowButtons` has no `SetAlpha`. `paintPetitions` has no `SetAlpha`. Shared leftover reset to 1 is a no-op on lists that never dim. Nested: petition stays 1 beside a dim Store row and after re-paint. |
| Confessions / knighting grayed | **Pass.** Those painters have no `SetAlpha`. In-lane pins are source-only. Reviewer probe: confession inbox row stays 1 under the same fail-open Refresh. |
| Fail-open membership changed (Store-only hidden or roster `here` rewritten) | **Pass.** `GetPresence` is unchanged. Nested: incomplete roster still lists member + Store-only; roster `here == true`; Store-only `here == false`; missing Roster still `{}`. |
| `SaveNote` defined; SUMMON / `UnitIsDead` / parchment / tabs | **Pass.** `Console.SaveNote` is nil before and after the nested block. Source has no `function Console:SaveNote`, no `SUMMON THE FAITHFUL`, no `UnitIsDead`, no `Parchment`, no `PanelTabButtonTemplate`. |
| New main-chunk locals / not nested in `runB8E()` after `runB33B()` | **Pass.** `runB34B()` is a nested `local function` inside `runB8E()` after `runB33B()` (brief L15 vs `test_console.lua` ~4831–4840 / ~5077–5078). Packet adds no main-chunk `local`. Header comment only at file top. `local leftover` is `acquireRows`-scoped. No new file locals in `Console.lua`. |
| Isolated suite not exit 0 / isolation wrap rewritten | **Pass. Verified.** 2398 passed, 0 failed. Writer-reported count matches. Isolation wrap stays under the first `if standalone then` (**17** nil pins). `runB34B()` re-pins 4 of them plus `COB.Popes`. |
| Exclusive file breach | **Pass.** Lane implementation is the two named files. Packet is header note + leftover `acquireRows` `SetAlpha(1)` + nested `runB34B()`. Roster / Inputs / glue have no leftover alpha reset. Sibling dirt vs HEAD is other lanes. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Roster, Inputs, glue; no commit | **Pass.** Named-risk check. Reviewer did not commit. |
| Leftover Presence hide (`count + 1`, including count `0`) → `SetAlpha(1)` if present | **Pass.** Brief L11 vs `acquireRows` ~468–473. Empty path uses count `0`. |
| Visible `here == false` stays `0.45` after `paintPresence` | **Pass.** Brief L11 vs `paintPresence` ~868–876. Nested + re-paint. |
| Visible `here ~= false` stays `1` | **Pass.** Named-risk check. |
| Petition / confession / knighting rows stay undimmed | **Pass.** Named-risk check. |
| No mute suffix. No new Presence copy ("offline" / "away") | **Pass.** Named-risk check. |
| `SaveNote` stays nil. No SUMMON. No `UnitIsDead` | **Pass.** Named-risk check. |
| Nest `runB34B()` inside `runB8E()` after `runB33B()`; reuse `pinAlpha`; no new main-chunk locals | **Pass.** Named-risk check. |
| Isolation wrap stays; `lua tests/test_console.lua` exit 0 | **Pass.** **2398 / 0.** |

Bible §18.1 holds on the exclusive pair: Presence is who is here. Visible `here == false` still stock-dims. Hidden leftovers reset to 1 so reuse does not keep `0.45`. Law 4 / License 4 hold: Console stays plain; `presenceLine` is unchanged; no new Presence words; `SaveNote` stays nil; no SUMMON; no `UnitIsDead`.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; stock leftover `SetAlpha(1)` on Anniversary is unproven | **Not a miss.** Brief asked the isolated suite. |
| Full `lua tests/run.lua` not run | **Not a miss.** Exclusive lane; `run.lua` not edited. |
| `wow_ui_stub` `SetAlpha` / `GetAlpha` are no-ops; suite pins a recorder | **On contract.** Stub file was not an exclusive file. |
| Shared leftover reset on petition / confession / knighting pools | **On contract.** Brief cited `acquireRows` leftover hide. Those lists never dim. |
| Empty Presence via nil Roster; 2→1 tail not separately painted | **On contract.** Brief allowed `COB.Roster = nil` or the already-pinned empty path. Same `count + 1` loop. Reviewer probe closed 2→1. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

The B33-B leftover (hidden Presence buttons kept `0.45`) is this lane's spec. It is closed on the exclusive pair.

---

## Isolation / reach / keep

**Isolation wrap — Pass.** Load list is still Common + Ranks + Runtime + Store + Gora + Knighting + Sender + Decree + Console. No `dofile` of Dock, glue, UI shell, Net, DB, Roster, or Confession. Standalone wrap is still **17** nils (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Confession). Wrap is load-time only (unchanged). Nested B34-B re-pins Archive / UI / Toasts / Confession / Popes after restore.

**Reach — Pass.** `Refresh` still calls `paintPresence` with `GetPresence()` rows. Non-empty paint still `paintRowButtons` then the Presence-only dim walk. Empty paint still `acquireRows(..., 0)`. Both leftover paths Hide then `SetAlpha(1)` when present. Missing Roster still `{}`.

**Keep — Pass.** `presenceLine` ignores `here`. `GetPresence` fail-open membership is unchanged. `paintRowButtons` does not `SetAlpha`. Visible `here == false` stays `0.45`. Petitions / confessions / knighting are not dimmed. `SaveNote` nil. No SUMMON / parchment / tabs / `UnitIsDead`.

---

## Strengths

- The delta is the brief: leftover `acquireRows` Hide type-guards `SetAlpha(1)`. Visible Presence dim stays in `paintPresence` only. Shared row painter was left alone.
- Fail-open here 1 / Store ~0.45, empty leftover hidden at 1, and re-paint here 1 / Store ~0.45 sit next to a live petition at 1, so a leftover that keeps `0.45` or a dim that bleeds onto petitions would fail.
- `presenceLine` stays mute of `here`. No offline / away suffix.
- `runB34B()` is nested inside `runB8E()` after `runB33B()`. Isolation wrap was not rewritten. Writer-reported **2398 / 0** matched the re-run. Writer-reported red (**2394 / 4**) matches a missing leftover `SetAlpha(1)`.

---

## Issues

### Critical

None.

### Important leftover — not must-fix

1. **2→1 leftover tail is not a separate in-lane pin.** Writer leftover: shrink from 2 visible rows to 1 is the same `count + 1` loop and is not separately painted. Reviewer probe: `Roster.complete = true` drops Store-only; hidden Store slot resets to 1; visible here stays 1. Do not expand this exclusive pair for another Refresh path.

2. **Shared leftover reset.** Petition / confession / knighting leftover Hide also `SetAlpha(1)`. Those lists never dim. Intended once the reset lives in `acquireRows` (brief L9 cites that hide). Not a Presence-copy or dim leak.

### Nit

1. **The "type-guarded SetAlpha" source pin is tautological.** After `find("SetAlpha(1)")`, `find("SetAlpha")` always hits. Live body is `if leftover.SetAlpha then leftover:SetAlpha(1) end`. Reviewer walk closed the hole.

2. **Confession / knighting “not dimmed” is source-only in-lane.** Brief asked leftover Presence plus undimmed petitions; the petition behavioral pin is present. Reviewer probe closed a confession row at alpha 1 under the same fail-open Refresh.

3. **`wow_ui_stub` `SetAlpha` / `GetAlpha` are no-ops.** The suite pins a recorder on row buttons and on `CreateFrame("Button", …)`. The stub file was not edited.

4. **Isolation wrap is load-only.** Seventeen pins under the first `if standalone then`. Nested B34-B re-pins four of them plus Popes. Brief said the wrap stays; it did.

5. **Exclusive-pair diff is not a vs-HEAD Console delta.** Packet is the B34-B-only leftover reset + nested pins. `git diff HEAD` on the two files still includes earlier console batches. Report already says this.

6. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **2398 / 0** was re-run here. Stock leftover `SetAlpha(1)` on Anniversary hidden Presence buttons is unproven.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **2398 passed, 0 failed.** Isolation wrap: **17**.

`acquireRows` leftover Hide (`count + 1` tail, including count `0`) type-guards `SetAlpha(1)` (brief L11 vs `Console.lua` ~468–473). Visible `here == false` still stock `SetAlpha(0.45)` after `paintPresence`; visible `here ~= false` stays `1`. `presenceLine` adds no offline / away / not-here suffix. Fail-open membership is unchanged. Petitions / confessions / knighting are not dimmed. `SaveNote` stays nil. No SUMMON. No `UnitIsDead`. Isolated `lua tests/test_console.lua` **2398 passed, 0 failed**, exit 0.

Leftovers: 2→1 leftover tail is not a separate in-lane pin (reviewer probe closed it); shared leftover reset on other desks is intended; type-guard source pin is tautological; `wow_ui_stub` `SetAlpha` / `GetAlpha` are no-ops; no client smoke; full harness not run.

Do not claim V1 / MVP complete. This review does not sign the lane.
