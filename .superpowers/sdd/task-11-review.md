# Task 11 review — Pope-only Gora persist

**Scope (this gate only):** live `Gora:Snapshot` / `Gora:Restore` (`sanctioned`, unsigned name-key petitions, `favorPicks`, `lastSanctioned`, `eventId`; `{}` / missing `eventId` is not a snapshot); `ResetForTests` does not Save; `Core/DB.lua` SCHEMA 7 + root `gora`; Init `store → event → gora → decree`; `localWriterIsPope` on Save only (no `UnitName` in Init); pew / no-Sender leave present `event` + `gora`; `ChurchOfBeef.lua` `persistAfterWrite` / `persistWrites` exclude `ResetForTests` and `_Expire`; Task 10 login split not unwrapped. Pins in `tests/test_gora.lua` / `tests/test_db.lua`.

Must hold: SCHEMA 7, Interface 20506, no schema 8, no `UnitName` in `DB:Init`, congregation must not write `gora = {}` over a present Pope blob, no commit.

Read: `.superpowers/sdd/task-11-brief.md`, `.superpowers/sdd/task-11-report.md`, `docs/superpowers/plans/2026-09-14-shared-account-sv.md`. Live `Core/Gora.lua`, `Core/DB.lua`, `ChurchOfBeef.lua`, the two test files. Full `lua tests/run.lua` was not re-run (per gate instruction). Working tree was not mutated except this review file.

**Spec-compliance:** PASS

**Task quality:** Approved

The implementer report matches the live tree. Snapshot/Restore copies the desk fields the brief named. Empty `{}` does not replace live memory. Schema stays 7 with root `gora`. Init Restores gora after event. Ceremony Save is `localWriterIsPope` on `DB:Save` only. Pew / no-Sender leave present blobs. Write-path wraps skip `ResetForTests` and `_Expire`. Task 10 login split, Welcome order, pew Quiet drop, Pope `sendState`, gated `RequestSnapshot`, stash, and #111 were not unwrapped.

---

## Verdict

Task 11 matches the brief, shared-account plan §§3 / 5 / 7, pin catalog C-02, and first-night Task 11. The shared-account wipe is closed on **Save**, not by teaching `DB:Init` a role. Congregation cannot snapshot empty Gora memory over a present Pope blob. Restore order is event then gora. SCHEMA stays 7.

---

## Spec Compliance

| Pin | Result | Evidence |
|-----|--------|----------|
| Snapshot/Restore `sanctioned`, unsigned petitions, `favorPicks`, `lastSanctioned`, `eventId` | Met | `Gora:Snapshot` copies petitions (name-keys included), `favorPicks`, optional `sanctioned` + `lastSanctioned`, and a numeric `eventId`. `Restore` writes those fields; `proposal` is cleared. `test_gora.lua`: unsigned `zipfresh` petition + standing/sender favor + stipulation survive round-trip; post-ruling Snapshot keeps `lastSanctioned`; `DeclareVictor` after Restore does not refuse `no sanctioned gora` |
| `{}` / missing `eventId` is not a snapshot and does not replace live memory | Met | `isGoraSnapshot` is `type == "table"` and `isId(eventId)`. `Restore({})` / nil / eventId-less table return `nil, "not a snapshot"` and leave the live pair. `Snapshot` of an empty desk is `{}` (no `eventId`). `test_db.lua`: empty / missing / `{ future = true }` gora do not call Restore |
| Restore **after** event; Restore-before-event expires on the next read | Met | `DB:Init` is `restoreFromSv` → `restoreEventFromSv` → `restoreGoraFromSv` → `restoreDecreeFromSv`. `test_db.lua` order spy: `event` then `gora`. `test_gora.lua`: Restore desk while Runtime is QUIET, then `GetSanctioned` is nil (`_Expire` saw no live `eventId`); Restore event then gora keeps the pair |
| `SCHEMA_VERSION == 7`; `rootKeys` == `decree,event,gora,store,ui,version`; no schema 8 | Met | `DB.lua` `SCHEMA_VERSION = 7`. `applyDefaults` / `ensureTable` add root `gora`. Fresh / Runtime / Gora Init pins and Pope Save stay version 7. TOC `## Interface: 20506`. No version 8 |
| `DB:Init` has no `UnitName`; Init chunk has no `IsRegisteredPope`; Save predicate is `localWriterIsPope` | Met | `DB.lua` source has no `UnitName`. `localWriterIsPope` lives above Init and is called only from `DB:Save`. Init comments: no local-character lookup. `test_db.lua` Task 10 pin still Restores RITE with `UnitName` Pewalt + `IsRegisteredPope` false |
| Pope-only ceremony Save; pew / no-Sender leave present `event` + `gora` | Met | `DB:Save` Snapshots event + gora only inside `if localWriterIsPope()`. Isolated Core (no Sender) is not Pope. Pew Save after Quiet drop + `_Expire` keeps the same `event` / `gora` table refs; state stays ASSEMBLY; `eventId` 1 and the sanctioned pair remain. No-Sender Save still persists `ui`. Pope reload after pew Save can still `DeclareVictor` |
| Congregation must not write `gora = {}` over a present Pope blob | Met | Pew / no-Sender never call `snapshotGoraToSv`. `ensureTable` on an existing table leaves the Pope snapshot. Plan §3 deadly combo (pew Save of expired memory) does not assign empty gora over the seeded blob |
| Debounce: `if C_Timer and C_Timer.After then` else Save on the write path / logout | Met | `persistAfterWrite` uses that guard, else `pcall(DB.Save, DB)`. `OnLogout` still `DB:Save()`. Tests call `DB:Save()` directly. `wow_stub.lua` has no `C_Timer` |
| Wrap successful Gora/Runtime/Store writes; never wrap `ResetForTests` or `_Expire` | Met | `persistWrites` lists Runtime verbs, Gora desk verbs (including unsigned Petition/Favor), and Store writers. Guard skips those two names; lists omit them. `test_db.lua` source pin: no `wrapAfter(COB.Gora, "ResetForTests")` / `"_Expire"`. `Gora:ResetForTests` does not call `DB:Save`; suite spies 0 Save |
| Task 10 login split not unwrapped | Met | `OnLogin` still `_snapshotAsked = nil` → `dropCongregationEventIfNeeded()` (nil-eventId Quiet) → `initUi()` → `Net:Init` → `InstallWire` → listed Pope `sendState()` once when ≠ QUIET. `maybeRequestSnapshot` still HELLO / live-STATE only. Welcome still follows DecreeBanner. `initModule` is still `pcall`. `_HandleState` still stash + #111 dismissed flag |
| Snapshot does not `_Expire` (no Quiet wipe as a Snapshot side effect) | Met | Comment + body: `deskEventId` then copy. Restore also does not `_Expire` or Save |
| Do-not: commit; stamp 8; gate Init on `UnitName`; per-character SV | Met | Report: no commit. SCHEMA 7. Init ungated. TOC still `## SavedVariables: ChurchOfBeefDB` |

---

## Strengths

- The Save predicate is the right half of the Task 10 split. Init stays character-blind. Pew leftover Restore is still a display of the Pope’s file, then login Quiet expires the desk. Pew Save cannot flush that empty memory back onto the file.
- Restore-before-event is pinned as a wipe, then the Init order is pinned as the fix. `DeclareVictor` after Pope Save → reset → Init is the night-walk step 8 shape.
- Unsigned name-keys survive Snapshot/Restore without minting Store rows. That is Task 6 still holding under schema 7 (catalog A-07 / C-02).
- Write-path persist is fail-closed on wrap success (`result ~= nil`) and never attached to `_Expire` or `ResetForTests`. Isolated Core tests Save only when they call `DB:Save()`.
- Neighbors held. Task 10 drop / send / snapshot-ask, Welcome order, stash, and #111 are still on the same bootstrap paths.

---

## Issues

### Critical

None.

### Important

None that miss a Task 11 pin.

1. **Init Restore stays ungated.** Congregation still Restores leftover `event` + `gora` at `ADDON_LOADED`. Task 10 forbade a `UnitName` gate there. Pew `OnLogin` drops Quiet; the next Gora read `_Expire`s the desk. The wipe the plan named is closed on Save. Report concern 1 is accurate, not a miss.

### Minor

1. **`applyDefaults` still `ensureTable`s a missing `gora` to `{}`.** Pew Save of a pre-Task-11 file that never had the key adds an empty hook. `{}` is not Restored and does not replace a present Pope blob. Report concern 2. Plan §5’s “do not ensureTable a fresh `{}` and flush it as truth” is the overwrite case; this is a missing-key hook.

2. **`lastSanctioned` Restore is implemented, not Init-pinned.** `test_gora.lua` asserts Snapshot keeps last pair after a ruling. `test_db.lua` Pope Save pins live `sanctioned` / unsigned petition / `favorPicks`, not a post-ruling last-pair Restore through `DB:Init`.

3. **`wow_ui_stub` has `C_Timer`.** Full-harness `test_wire_glue` (last suite) may queue a debounced Save when `COB.DB` is leftover from `test_db`. Isolated Core tests have no `C_Timer` and Save on the write path or via `DB:Save()`. Report concern 3. Did not re-run the full suite.

4. **Pew Save still Snapshots store.** `persistWrites` includes `EnsureCharacterByName` / `CreateHuman`. Congregation Store mint remains OPEN_QUESTIONS **#26**, not this task. Report concern 4.

5. **`wrapAfter` treats `Dismiss` `false` as success.** A miss on the pool is non-nil, so `persistAfterWrite` can Save. Extra flush, not a blob wipe.

6. **In-game Pope `/reload` with a live sanctioned pair, and two-client smoke on separate Account SV trees, were not run.** Green harness is not client smoke. Night walk stays two Account trees (plan §6).

---

## Assessment

**PASS / Approved.**

Pope `/reload` can Restore a sanctioned desk and `DeclareVictor`. Congregation Save cannot write `gora = {}` over that blob. Init Restores gora after event and does not look up the local character. SCHEMA 7. Interface 20506. `ResetForTests` and `_Expire` do not persist. Task 10 login split was not unwrapped.

Do not claim `POLISH:PASS`.
