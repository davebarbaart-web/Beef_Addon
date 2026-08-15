# Phase 2 Lane D — Adversarial Review

**Lane:** Account SV hook / demo-key ignore
**Exclusive files:** `addon/ChurchOfBeef/Core/DB.lua`, `tests/test_db.lua`
**Lane report:** `docs/reformation/phase-2/reports/P2-D-migration.md`
**Cited law:** Ten Laws 7; Bible §12.1, §12.3, §13.1; Audit V6; handoff Phase 2 migration sentence; GATE1 §3d; brief `docs/reformation/phase-2/briefs/P2-D-migration.md`
**Writer:** [SV migration](c5812b82-3e52-4888-8c21-77ab16c29621)

**Spec:** PASS
**Quality:** Approved

`SCHEMA_VERSION` is 5. Fresh Init is `{ version, ui, store }` with `store == {}`. `DB` has only `Init` / `Save`. Leftover `ladder` / `scoring` / `suggestions` survive Init and Save and are not copied into `store`. Dirty demo shapes Init/Save without error. Writer stayed inside exclusive files. Isolated suite: **109 passed, 0 failed**. Player `WTF/` not touched. No Pope store rows invented.

## Verdict

Refutation of Law 7 and the handoff migration sentence **fails** for this lane’s exclusive files.

Law 7 protects **Church history** (ranks on the human, Gora records on the character, membership; no prune, no departed sweep, no expiry). The demo per-character SV had a points ladder, not that history (Audit V6: identity model absent). The handoff sentence is: old per-character DB on first load — **preserve nothing product-side, but don't error.** The brief then forbids importing leftover `ladder` / `scoring` / `suggestions` into `store` and forbids wiping unknown keys.

Those two instructions do not collide here. Not importing banned demo keys is “preserve nothing product-side.” Not wiping them, and not opening player `WTF/`, is not a `SweepDeparted`. First load of a missing account-level table becomes `{ version, ui, store = {} }` and does not error. `{ version, ui }` still works. `store` is an empty hook. Lane A still owns rows.

This review did not invent store rows, did not edit TOC / bootstrap / `tests/run.lua` / Store / UI / Net, and did not commit.

## Confirmations

| Check | Result |
|---|---|
| `SCHEMA_VERSION` 5; fresh DB is `{ version, ui, store }` with `store == {}` | **Yes.** `SCHEMA_VERSION = 5`. Fresh keys are exactly `store,ui,version`. `storeKeys` is `""`. `store.humans` / `store.characters` / `store.gora` are `nil`. |
| No human / character / Gora / Archive APIs on `DB` | **Yes.** Public surface is `Init` and `Save` only. Suite locks `GetHuman`, `CreateHuman`, `GetCharacter`, `CreateCharacter`, `RecordGora`, `SetRank` as `nil`. No Archive / Export / Import / Snapshot. |
| Leftover `ladder` / `scoring` / `suggestions` survive Init/Save and are **not** copied into `store` | **Yes.** Nested leftover payload (`Alice`, `Bob`, `dayKey`) survives Init **and** Save. `storeKeys` stays `""`. `store.ladder` / `store.scoring` / `store.suggestions` / `store.records` are `nil`. Missing leftovers are not created. |
| Dirty demo SV does not error | **Yes.** Empty table, string version, non-table `ui`, typed-wrong leftovers, missing `ui`, classic demo leftovers: Init and Save under `pcall` succeed. |
| Writer did not edit TOC / bootstrap / `run.lua` / Store / UI / Net | **Yes.** Transcript Writes: `Core/DB.lua`, `tests/test_db.lua`, this lane’s report only. No `Store.lua` in the tree. TOC line is already `## SavedVariables: ChurchOfBeefDB` (integrator). Those other paths are dirty from other lanes; not this writer. |
| Isolated `test_db` green | **Yes.** Isolated (`test_db.lua` + `Core/DB.lua` only): **109 passed, 0 failed.** Writer count matches. |
| Player `WTF/` not touched | **Yes.** No `ChurchOfBeefDB.lua` write in the transcript. No `ChurchOfBeefDB.lua` under the workspace. No player SV path opened. |
| No Pope store schema invented | **Yes.** `defaultStore()` is `{}`. `applyDefaults` only `ensureTable`s `store` if missing / not a table. No humans, characters, ranks, ceremony, Gora, archive, notebook, or tombstone keys. Unknown `store.future` is a merge probe, not a row type. `OPEN_QUESTIONS.md` unchanged by this writer. |

## Attack results

| Attack | Result |
|---|---|
| Law 7 — “preserve nothing product-side” deletes Church history when the account-level file is new? | **No.** First load of a non-table / nil SV is `defaultDb()`: `{ version = 5, ui, store = {} }`. Demo leftovers were standing / grants / suggestions, not ranks or sanctioned-Gora records (Audit V6). The addon does not open or sweep old per-character files (brief: do not touch `WTF/`). Abandoning unread demo bytes is the handoff sentence, not `SweepDeparted`. |
| Law 7 — leftover keys must be imported into `store` as history? | **No.** That would invent product: treat a banned points ladder as Church history. Brief: leftovers “are not Church history and they are not imported.” Suite locks the non-import. |
| Law 7 — Init/Save wipes leftover keys or nested leftover payload? | **No wipe.** `applyDefaults` fills `version`, `ui`, and `store` only. Reviewer probe: leftovers plus a pre-existing `store = { future, keep }` keep both the leftover root keys and the unknown store keys; leftovers are not merged into `store`. |
| Law 7 misapplied so a points economy remains as product? | **No.** Dead leftover bytes that nothing reads are not an economy (same ruling as P1-K). `applyDefaults` never reads `ladder` / `scoring` / `suggestions`. `loadIntoModules` / `ImportState` / `ExportState` / `defaultLadder` / `defaultScoring` are gone from the live file. |
| Handoff — first load still errors on dirty / per-character shapes? | **No.** Empty table, string version, broken `ui`, non-table leftovers, missing `ui`, classic demo leftovers: no error. Reviewer probe: string / `false` / `0` root SV also Init without error and become the fresh hook. |
| Handoff — leftover demo keys are migrated into `store`? | **No.** `store` is a new `{}` when missing. It is not an alias of `ladder` or `scoring` (probe). |
| `{ version, ui }` no longer works? | **No.** Existing `shown` / `point` / `announce` survive Init and Save. Sparse `ui` is filled. Non-table `ui` is replaced so the hook still works (don't-error), not so prefs become product. |
| `store = {}` is a disguised Pope schema (humans / characters / Gora / Archive)? | **No.** Empty table hook only. No row constructors. No Store APIs on `DB`. Lane A brief still owns rows. |
| Writer flipped TOC / invented account-id linking / edited bootstrap? | **No.** Exclusive Writes only. GATE1 §3d’s switch is integrator-owned and already live as `## SavedVariables: ChurchOfBeefDB`. No linker. |
| Writer still runs the old v1→v2 standing-row rewrite (would destroy leftover payload)? | **No.** That migration is not in the live file. `"Alice"` / `dayKey` survive. |
| Writer edited `OPEN_QUESTIONS.md` or committed? | **No.** No commit. `OPEN_QUESTIONS.md` has no migration item from this writer (mtime predates the lane). |

Refutation of Law 7 (§12.3 never-delete of **Church history**; §12.1 account-level identity) and of the handoff sentence (preserve nothing product-side, don't error) **fails** for the exclusive files. The empty `store` hook is the account-level slot. Demo keys are neither imported nor swept. Dirty first load does not error.

## Leftovers (other lanes — expected; not fixed)

Writer concerns are current (TOC already account-level; player SV may still hold leftover `ladder` / `scoring` / `suggestions`; full harness is integrator-owned). Additional live leftovers this lane correctly did not touch:

### Integrator / other Phase 2 lanes

- `ChurchOfBeef.toc` — already `## SavedVariables: ChurchOfBeefDB`. Writer did not edit it.
- `Core/Store.lua` / `tests/test_store.lua` — not in the tree. Lane A owns rows.
- `tests/run.lua` — still lists `test_db`; writer did not add suites. Full harness color is integrator-owned.
- Git `HEAD` `DB.lua` is still the pre-Reformation schema-3 ladder/scoring file. The live working tree is Phase 1 cut + this hook. Commit is not this lane.

### Not this lane

- `UI/MainFrame.lua` / `UI/Minimap.lua` still read `ChurchOfBeefDB.ui` only. Compatible with the new root `store` key.
- `ChurchOfBeef.lua` still calls `DB:Init` / `DB:Save`. Writer did not edit bootstrap.
- `Core/Gora.lua` remains a Phase 1 stub. Not a DB API.
- Existing player `ChurchOfBeefDB` may still contain leftover `ladder` / `scoring` / `suggestions`. They remain on disk and are not Church history.
- `ui.announce` remains a shipped default. Pre-existing; not a store row.

## Findings

### Critical

None.

### Important

None for this lane’s exclusive files.

### Nit

1. **Law 7 citation is slightly loose.** Comments and the suite say leftover demo keys survive “because Law 7.” Law 7’s object is Church history, not unknown keys. The brief used the same stretch. Behavior is right: do not import, do not wipe, do not treat leftovers as product. Do not “fix” this by adding a wipe.

2. **`initOk`’s `if not ok` branch is dead-looking.** `assert_true` does not abort. If Init actually threw, later field asserts would abort the suite. Coverage of the happy dirty paths is still real.

3. **Suite does not lock leftovers + a pre-existing `store` in one fixture.** Reviewer probe: unknown store keys survive and leftovers are not merged in. Coverage gap only.

4. **Suite does not lock a non-table root SV** (`"corrupt"`, `false`, `0`). Reviewer probe: no error; replaced with the fresh `{ version, ui, store }` hook. That is the handoff first-load path, not a history sweep.

5. **Non-table `store` is replaced with `{}`.** Brief said “if missing.” Treating a string store as missing is the don't-error coerce. It is destructive of that value. Acceptable for dirty demo. Lane A must keep `store` as a table.

## Brief contract

| Requirement | Result |
|---|---|
| Keep `{ version, ui }` working | Met |
| `store` table exists as `{}` if missing; do not invent human/character schema | Met |
| Leftover `ladder` / `scoring` / `suggestions`: do not read as product, do not migrate into `store`, do not wipe | Met |
| Init/Save must not error on a dirty demo SV | Met |
| Bump `SCHEMA_VERSION` only if the `store` hook is added | Met (4→5) |
| Do not implement Store APIs / Archive | Met |
| Do not touch player `WTF/` | Met |
| Do not edit TOC / bootstrap / `tests/run.lua` / Store / UI | Met |
| Isolated `test_db.lua` must pass | Met (109 / 0) |
| Do not invent Pope store rows, Rite, Archive, registered Pope, account-id linker | Met |
| No commit | Met |

## Sections checked

- `docs/reformation/phase-0/TEN_LAWS.md` Law 7
- Brief `docs/reformation/phase-2/briefs/P2-D-migration.md`
- Writer report `docs/reformation/phase-2/reports/P2-D-migration.md`
- Bible §12.1, §12.3, §13.1; Audit V6; handoff Phase 2 migration sentence; GATE1 §3d
- `addon/ChurchOfBeef/Core/DB.lua` (live + leftover/non-table/first-load probes)
- `tests/test_db.lua` (live + isolated run)
- `ChurchOfBeef.toc` (`## SavedVariables: ChurchOfBeefDB` only)
- Writer transcript ([SV migration](c5812b82-3e52-4888-8c21-77ab16c29621)) — exclusive Writes only
- `docs/design/OPEN_QUESTIONS.md` (unchanged by this writer; no product invention)
