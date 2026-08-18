Spec PASS

# B33-B — Presence rows honor here == false (review)

**Quality:** Approved-with-nits

**Lane:** B33-B Presence rows honor here == false
**Brief:** `docs/reformation/vestments/briefs/B33-B-presence-here.md`
**Writer report:** `docs/reformation/vestments/briefs/B33-B-presence-here-report.md`
**Diff:** `docs/reformation/vestments/briefs/B33-B-presence-here.diff` (B33-B-only exclusive-pair packet; live `Console.lua` also carries earlier console batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Console.lua` (`paintPresence` ~834–874 / `presenceLine` / `paintRowButtons` / `GetPresence` / `paintPetitions` / `paintConfessions` / `paintKnightingLine` / `SaveNote`), and `tests/test_console.lua` (isolation wrap, nested `runB33B()` inside `runB8E()` after `runB32B()`); then ran `lua tests/test_console.lua` (**2297 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: Bible §18.1 Presence is who is here; `GetPresence` already writes `here` (true on roster, false on fail-open Store); honor `here` without new words; do not dim petitions; `SaveNote` stays nil; no `UnitIsDead`; no SUMMON. Did not mutate `Console.lua` or `test_console.lua`. Did not commit. Did not edit Roster, glue, TOC, bootstrap, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Presence `here == false` still looks live (`paintPresence` / `presenceLine` ignore `here`) | **Pass. Verified.** After `paintRowButtons`, `paintPresence` walks the Presence pool only. `rows[i].here == false` stock `SetAlpha(0.45)`; otherwise `SetAlpha(1)`. Nested: fail-open Store-only stub alpha ~0.45; roster `here == true` stays 1. Reviewer probe matched. |
| New words: mute suffix / "offline" / "away" / "not here" | **Pass. Verified.** `presenceLine` is still name / rank / needs Knighting. Empty copy stays `"No one on the roster yet."` Nested: Store-only label keeps the name and has no offline / away / not-here suffix. Source pins: `presenceLine` and `paintPresence` have no those words; `presenceLine` still has no `here`. Live `Console.lua` has no `offline` / `away` / `UnitIsDead`. |
| Petitions dimmed by this walk or by shared `paintRowButtons` | **Pass. Verified.** `paintRowButtons` has no `SetAlpha`. `paintPetitions` has no `SetAlpha`. Nested: live petition row stub alpha stays 1. Reviewer probe: petition row stays 1 beside a dimmed Store-only Presence row. |
| Confessions / knighting grayed | **Pass.** Those painters have no `SetAlpha`. In-lane pins are source-only. Reviewer probe: confession row and a Fresh-Beef knighting row stay alpha 1 under the same fail-open Refresh. |
| Fail-open membership changed (Store-only hidden or roster `here` rewritten) | **Pass.** `GetPresence` is unchanged. Nested: incomplete roster still lists member + Store-only; roster `here == true`; Store-only `here == false`. Reviewer probe: `complete == true` drops the Store-only name (B21-A keep). |
| `SaveNote` defined; SUMMON / `UnitIsDead` / parchment / tabs | **Pass.** `Console.SaveNote` is nil before and after the nested block. Source has no `function Console:SaveNote`, no `SUMMON THE FAITHFUL`, no `UnitIsDead`, no `Parchment`, no `PanelTabButtonTemplate`. |
| New main-chunk locals / not nested in `runB8E()` after `runB32B()` | **Pass.** `runB33B()` is a nested `local function` inside `runB8E()` after `runB32B()`. Packet adds no main-chunk `local`. Header comment only at file top. No new file locals in `Console.lua`. |
| Isolated suite not exit 0 / isolation wrap rewritten | **Pass. Verified.** 2297 passed, 0 failed. Writer-reported count matches. Isolation wrap stays under the first `if standalone then` (**17** nil pins). `runB33B()` re-pins 4 of them plus `COB.Popes`. |
| Exclusive file breach | **Pass.** Lane implementation is the two named files. Packet is header note + Presence-only `SetAlpha` after `paintRowButtons` + nested `runB33B()`. Roster / glue have no Presence dim. Sibling dirt vs HEAD is other lanes. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Roster, glue; no commit | **Pass.** Named-risk check. Reviewer did not commit. |
| After `paintRowButtons` for Presence only, `here == false` → `SetAlpha(0.45)` | **Pass.** Named-risk check. |
| Otherwise `SetAlpha(1)` | **Pass.** `here == false` is the only dim. Nil / true stay 1. |
| No mute suffix. No new word ("offline" / "away") | **Pass.** Named-risk check. |
| Do not change fail-open membership | **Pass.** Named-risk check. |
| Do not gray petitions / confessions / knighting | **Pass.** Named-risk check. |
| `SaveNote` stays nil. No SUMMON. No `UnitIsDead` | **Pass.** Named-risk check. |
| Nest `runB33B()` inside `runB8E()` after `runB32B()`; no new main-chunk locals | **Pass.** Named-risk check. |
| Isolation wrap stays; `lua tests/test_console.lua` exit 0 | **Pass.** **2297 / 0.** |

Bible §18.1 holds on the exclusive pair: Presence is who is here. `GetPresence` already writes `here`. The desk honors that flag with stock alpha and does not invent offline / away copy. Law 4 / License 4 hold: Console stays plain; `presenceLine` is unchanged; `SaveNote` stays nil; no SUMMON; no `UnitIsDead`.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; stock `SetAlpha(0.45)` on Anniversary is unproven | **Not a miss.** Brief asked the isolated suite. |
| Full `lua tests/run.lua` not run | **Not a miss.** Exclusive lane; `run.lua` not edited. |
| `wow_ui_stub` `SetAlpha` / `GetAlpha` are no-ops; suite pins a recorder | **On contract.** Stub file was not an exclusive file. |
| Fail-open still lists Store-only names; only alpha changes | **On contract.** Brief said do not change fail-open membership. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

---

## Isolation / reach / keep

**Isolation wrap — Pass.** Load list is still Common + Ranks + Runtime + Store + Gora + Knighting + Sender + Decree + Console. No `dofile` of Dock, glue, UI shell, Net, DB, Roster, or Confession. Standalone wrap is still **17** nils (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Confession). Wrap is load-time only (unchanged). Nested B33-B re-pins Archive / UI / Toasts / Confession / Popes after restore.

**Reach — Pass.** `Refresh` still calls `paintPresence` with `GetPresence()` rows. When the Presence child exists and `#rows > 0`, `paintRowButtons` paints, then the Presence-only walk type-guards `SetAlpha`. Fail-open Store-only (`here == false`) is 0.45. Roster (`here == true`) is 1.

**Keep — Pass.** `presenceLine` ignores `here`. `GetPresence` fail-open membership is unchanged. `paintRowButtons` does not `SetAlpha`. Petitions / confessions / knighting are not dimmed. `SaveNote` nil. No SUMMON / parchment / tabs / `UnitIsDead`.

---

## Strengths

- The delta is the brief: one Presence-only walk after `paintRowButtons`, `here == false` → 0.45, else 1. Shared row painter was left alone, so other desks cannot inherit the dim.
- Fail-open membership, roster `here == true`, Store-only ~0.45, and a live petition at 1 sit next to each other, so a membership rewrite or a shared-painter dim would fail.
- `presenceLine` stays mute of `here`. No offline / away suffix.
- `runB33B()` is nested inside `runB8E()` after `runB32B()`. Isolation wrap was not rewritten. Writer-reported **2297 / 0** matched the re-run. Writer-reported red (**2293 / 4**) matches a missing Presence `SetAlpha` walk.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Leftover hidden Presence buttons keep the last alpha.** `acquireRows` hides extras; the new walk only covers `#rows`. Reviewer probe: after roster `complete == true`, the hidden Store-only slot stays 0.45. Next paint as `here == true` would `SetAlpha(1)`. Not player-facing while hidden. Do not expand this exclusive pair to reset the leftover pool.

### Nit

1. **Confession / knighting “not dimmed” is source-only in-lane.** Brief asked a petition behavioral pin; that pin is present. Reviewer probe closed the other two desks at alpha 1 under the same fail-open Refresh.

2. **Several “does not X” pins are string finds.** They would miss a computed suffix. Reviewer walk of live `presenceLine` / `paintPresence` / the other painters closes that hole.

3. **`wow_ui_stub` `SetAlpha` / `GetAlpha` are no-ops.** The suite pins a recorder on row buttons and on `CreateFrame("Button", …)`. The stub file was not edited.

4. **Isolation wrap is load-only.** Seventeen pins under the first `if standalone then`. Nested B33-B re-pins four of them plus Popes. Brief said the wrap stays; it did.

5. **Exclusive-pair diff is not a vs-HEAD Console delta.** Packet is the B33-B-only Presence dim + nested pins. `git diff HEAD` on the two files still includes earlier console batches. Report already says this.

6. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **2297 / 0** was re-run here. Stock `SetAlpha(0.45)` on Anniversary Presence rows is unproven.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **2297 passed, 0 failed.** Isolation wrap: **17**.

`paintPresence` still paints `presenceLine` and `paintRowButtons`. After that Presence-only walk, `here == false` stock `SetAlpha(0.45)` and otherwise `SetAlpha(1)`. `presenceLine` adds no offline / away / not-here suffix. Fail-open membership is unchanged. Petitions / confessions / knighting are not dimmed. `SaveNote` stays nil. No SUMMON. No `UnitIsDead`. Isolated `lua tests/test_console.lua` **2297 passed, 0 failed**, exit 0.

Leftovers: leftover hidden Presence buttons keep the last alpha (not player-facing while hidden; do not expand exclusive to reset the pool); confession / knighting not-dimmed is source-only in-lane (reviewer probe closed both at 1); `wow_ui_stub` `SetAlpha` / `GetAlpha` are no-ops; no client smoke; full harness not run.

Do not claim V1 / MVP complete. This review does not sign the lane.
