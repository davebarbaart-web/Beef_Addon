# Phase 2 Lane E — Adversarial Review

**Lane:** Persist Pope store into account SV
**Exclusive files:** `addon/ChurchOfBeef/Core/DB.lua`, `tests/test_db.lua`
**Lane report:** `docs/reformation/phase-2/reports/P2-E-persist.md`
**Cited law:** Ten Laws 5, 7; Bible §12.1, §13.1; Lane D `store = {}` hook; Lane A `Store:Snapshot` / `Restore`; brief `docs/reformation/phase-2/briefs/P2-E-persist.md`
**Writer:** [Store persist](05fb857d-7e24-49dc-9e0a-66ec5eb1d2cf)

**Spec:** PASS
**Quality:** Approved

Data-layer wire only. When `COB.Store` is present, `Save` writes `Store:Snapshot()` (a table, not an Archive stamp) into `ChurchOfBeefDB.store`. `Init` Restores only when `store` has `humans` and `characters` tables. Empty `{}` / missing / humans-only / characters-only do not Restore and do not wipe live humans. No Store: Init/Save still succeed; the empty hook survives. Leftover `ladder` / `scoring` / `suggestions` stay at the SV root — not imported, not wiped. `SCHEMA_VERSION` is still 5. Isolated suite: **206 passed, 0 failed**. Writer stayed inside exclusive files. `OPEN_QUESTIONS.md` unchanged. No commit. Player `WTF/` not touched. No #8 persist policy, Grant/standing, or reminder UX.

## Verdict

Refutation of Laws 5, 7 and Bible §13.1 **fails** for this lane’s exclusive files.

Law 5 and §13.1 are intact: the Pope store remains the single writer. `DB` has no create/set/record/Grant verbs. It copies the in-memory store onto the account SV and reloads a Snapshot-shaped table back into that same store. That is the Bible’s per-client SavedVariables sentence, not a second authority, not peer consensus, not congregation theater.

Law 7 is intact on the honest path and on the named empties. `{}`, a missing store (filled to `{}`), humans-only, characters-only, and typed-wrong `humans` / `characters` do not call `Restore` and do not replace live humans. Leftover demo keys are neither imported nor swept. Round-trip keeps rank, `elevationAt`, tombstone, Gora, ceremony log, and marked moments. A *valid* empty-array Snapshot may Restore empty — that is `/reload` of a saved empty church, not a `SweepDeparted`, not the Lane D `{}` hook.

This review did not invent congregation-vs-Pope persist policy (#8), Archive reminder UX, or a second schema, and did not commit.

## Confirmations

| Check | Result |
|---|---|
| `Save` writes `Store:Snapshot()` table into `ChurchOfBeefDB.store` when Store exists (not an Archive stamp) | **Yes.** `snapshotToSv` assigns `db.store = store:Snapshot()`. Suite + reviewer: type is `table`; keys are `humans`, `characters`, `ceremonyLog`, `markedMoments`, `next*Id`. Not a `COBARCH1` string. `DB.Export` / `Import` are `nil`. |
| `Init` Restores only when `store` has `humans` + `characters` tables | **Yes.** `isSnapshot` is exactly those two `type == "table"` checks. Spy: Snapshot-shaped store Restores once. |
| Empty `{}` / missing / humans-only / characters-only do **not** Restore (no wipe) | **Yes.** Suite + reviewer: `restoreCalls == 0`; live Keep name survives. Typed-wrong `humans` / `characters` also skip. |
| No Store: Init/Save still work; empty hook survives | **Yes.** First section nils `COB.Store` and dofiles `DB.lua` only. Fresh and re-Save `storeKeys` stay `""`. Reviewer: hiding Store after persist is loaded still Inits/Saves; hook stays `{}`. |
| Leftover `ladder` / `scoring` / `suggestions` stay at SV root; not imported; not wiped | **Yes.** Nested leftover payload (`Alice`, `dayKey`, `leftover = true`) survives Init **and** Save, with and without Store. `store.ladder` / `store.scoring` / `store.suggestions` stay `nil`. Missing leftovers are not created. |
| `SCHEMA_VERSION` still 5 | **Yes.** No new root key. Fresh keys are exactly `store,ui,version`. Filled Save does not bump. Downgrade 99 is kept. |
| Writer did not edit Store / Archive / Recognition / TOC / bootstrap / `run.lua` | **Yes.** Transcript Writes: `Core/DB.lua`, `tests/test_db.lua`, this lane’s report. Those other paths were Read only. Mtimes: Store / Archive / Recognition / TOC / `ChurchOfBeef.lua` / `run.lua` are Aug 14; writer files are Aug 15 06:14–06:15. Init/Save remain ADDON_LOADED / PLAYER_LOGOUT. |
| Isolated `test_db` green | **Yes.** Isolated (`lua tests/test_db.lua`): **206 passed, 0 failed** (reviewer rerun). Writer count matches. Full harness (integrator-owned; this lane did not edit `run.lua`): **1589 passed, 0 failed**. |
| No #8 persist policy, no Grant/standing, no reminder UX | **Yes.** No `IsPope` / registered-Pope / congregation gate. `DB.Grant` / `SetStanding` are `nil`. Save does not invent `ChurchOfBeefDB.Grant` / `standing`. No `Remind`, Discord, toast, or file-picker. `OPEN_QUESTIONS.md` #8 is unchanged. |

## Attack results

| Attack | Result |
|---|---|
| Law 5 — persist is a second writer / second source of truth? | **No.** `DB` does not create humans, set ranks, or record Goras. `Save` copies `Store:Snapshot()`. `Init` calls `Store:Restore` on the same module. Congregation UI/Net are not called. No broadcast. No peer self-report. |
| Law 5 / §13.1 — persist-when-Store-present on every client is peer authority? | **No as product.** Brief: persist when `COB.Store` is present. TOC already loads Store for every client. This lane must not invent a registered-Pope list (`#8` — do not code). Later layers must not treat a congregation account SV as canonical or call Store writes there. This review does not invent that gate. |
| Law 5 / §13.1 — Restore from SV is a competing database? | **No.** §13.1’s first sentence is per-client SavedVariables. The Pope’s account SV is the durability of the Pope’s store. Conflict resolution remains “one writer.” A congregation file that holds an empty Snapshot after logout is a local hook, not a second Church. |
| Law 7 — empty `{}` / missing store Restores nobody and wipes live humans? | **No.** `isSnapshot({})` is false. Missing store is filled to `{}` and skipped. Live Keep survives. That was the Lane D hook the brief named. |
| Law 7 — humans-only / characters-only / typed-wrong fields wipe? | **No.** Not a Snapshot. `restoreCalls == 0`. Keep stays. |
| Law 7 — leftover demo keys must be imported as Church history? | **No.** That would invent product: treat a banned points ladder as history. Brief: leftovers stay at the root; never copy into `store`. Suite locks the non-import. |
| Law 7 — Init/Save wipe leftover `ladder` / `scoring` / `suggestions`? | **No wipe.** `applyDefaults` fills `version`, `ui`, and `store` only. `snapshotToSv` replaces `store` with a Snapshot; it does not touch root leftovers. Reviewer: leftovers survive empty-Snapshot Init and filled Save. |
| Law 7 — valid empty-array Snapshot over live Keep is `SweepDeparted`? | **No.** Reviewer probe: `{ humans = {}, characters = {} }` *does* Restore and replace Keep. Writer disclosed this. The blob is a real Snapshot (empty arrays). Production `Init` runs once at ADDON_LOADED against an empty in-memory store — that is `/reload`, not a departed sweep. Do not invent “refuse empty churches.” |
| Law 7 — map-shaped / id-less `humans` Restores nobody? | **Restore of a Snapshot-shaped table, not a sweep.** Reviewer: `{ [10] = row }` plus `characters = {}` calls Restore; `loadRows` (`#list == 0`) replaces Keep with nobody. Honest `Store:Snapshot` emits arrays with integer ids. A forger who wants a wipe can already persist a valid empty-array Snapshot. Do not add Archive integrity to `DB` (that invents a second codec). |
| Law 7 — refused Restore (bad `ceremonyLog`) deletes disk history? | **No.** Reviewer: `Store:Restore` refuses; live Keep stays; SV `FromDisk` row is not wiped and is not loaded. Corrupt extra fields are Store’s fail-closed leftover, not a prune. |
| Law 7 — non-table / Archive-string `store` is a history sweep? | **No.** `ensureTable` replaces a string with `{}` (Lane D don't-error). Reviewer: `"COBARCH1:…"` does not Restore and does not wipe live Keep. Archive is the backup codec, not live persist. |
| §13.1 — persist writes theater, BeefNet, or a second schema? | **No.** No `CreateFrame`, `SendAddonMessage`, or schema 6. Fresh root is still `{ version, ui, store }`. |
| §12.1 — persist is per-character, or rank/Gora land on the wrong row? | **No.** TOC is already `## SavedVariables: ChurchOfBeefDB` (integrator). Snapshot keeps rank / `elevationAt` / tombstone on the human and Gora on the character. Shared-account / two-humans machinery was not invented. |
| Writer invented #8 / Grant / standing / reminder UX, edited forbidden files, or committed? | **No.** Exclusive Writes only. No commit. `OPEN_QUESTIONS.md` mtime predates the lane. |

Refutation of Law 5 (one Pope writer; persist is durability), Law 7 (never-delete; `{}` is not a wipe; leftovers are not history), and Bible §13.1 (Pope-authoritative star; per-client SV) **fails** for the exclusive files. The empty-array Snapshot Restore is `/reload`, not `SweepDeparted`.

## Leftovers (other lanes — expected; not fixed)

Writer leftovers are current. Additional live leftovers this lane correctly did not touch:

### #8 / later (do not invent here)

- Registered-Pope / congregation-vs-Pope persist policy. This lane persists whenever `COB.Store` is present. Exact file, edit path, and override UX are Phase 4 (`OPEN_QUESTIONS.md` #8; GATE1 §4). Do not code now.
- Director Console, BeefNet v2, Grant/standing, a second schema.

### Archive (§13.5)

- Live persist is the Snapshot table. Archive remains the backup codec. No weekly reminder, Discord post, or file-picker.

### Store / Archive leftovers (not this wire)

- `Restore` still passthroughs extra `points` / `standing` on a crafted Snapshot (Lane A). Live `Create*` / `SetRank` do not write them. Lane B refuses those keys on Import. `DB` must not grow a denylist (looks like a wipe; invents a second codec).
- Map-shaped / id-less arrays and a valid empty-array Snapshot replace live memory if `Init` is called mid-session. Honest logout/`/reload` starts from an empty process.

### Integrator / bootstrap (already landed — writer did not edit)

- `ChurchOfBeef.toc` — `## SavedVariables: ChurchOfBeefDB`; lists `Core\Store.lua`.
- `ChurchOfBeef.lua` — `DB:Init` on ADDON_LOADED; `DB:Save` on PLAYER_LOGOUT. Mid-session writes flush at logout / `/reload` only.
- `tests/run.lua` still lists `test_db`. Full harness color is integrator-owned.

### Not this lane

- Ceremony-runtime event object persist (§20.3 “resumes from the persisted event object”) is not in `Store:Snapshot`. Later runtime, not this wire.
- Existing player `ChurchOfBeefDB` may still contain leftover `ladder` / `scoring` / `suggestions`. They remain on disk and are not Church history.
- `ui.announce` remains a shipped default. Pre-existing; not a store row.

## Findings

### Critical

None.

### Important

1. **A Snapshot-shaped empty church Restores.** Reviewer probe: `{ humans = {}, characters = {} }` calls `Restore` and replaces live Keep. Writer disclosed this. After the first `Save` with Store, the Lane D `{}` hook is gone; the next `Init` Restores that Snapshot. Production `Init` is once per load against empty memory. Do not “fix” by refusing empty arrays (invents “refuse empty churches”).

2. **`isSnapshot` is structural only.** Any tables named `humans` and `characters` count — including map-shaped `{ [10] = row }`. `Store:Restore` then `loadRows` may yield nobody. Honest `Save` emits arrays with integer ids. Do not move Archive fail-closed checks into `DB`.

### Nit

1. **Law 7 citation is slightly loose on leftover demo keys.** Comments and the suite say leftovers survive “because Law 7.” Law 7’s object is Church history, not unknown keys. The brief used the same stretch. Behavior is right: do not import, do not wipe, do not treat leftovers as product. Do not “fix” this by adding a wipe.

2. **Suite does not lock empty-array Snapshot over live Keep.** Writer report states the behavior. Reviewer probe confirms it. Coverage gap only.

3. **Suite does not lock a refused `Restore` (typed-wrong `ceremonyLog`).** Reviewer: live Keep stays; SV row is not wiped and not loaded. Honest Snapshot always has table `ceremonyLog`.

4. **`Save` with Store drops unknown `store.future`.** Lane D’s no-Store section still locks “unknown store key survives Save.” With Store, `db.store = Snapshot()` replaces the table. Expected persist; not a root-leftover wipe.

5. **`initOk`’s `if not ok` branch is dead-looking.** `assert_true` does not abort. Coverage of the happy dirty paths is still real. Pre-existing from Lane D.

6. **`DB:Init(_now)` still ignores `now`.** Pre-existing. Persist does not invent a clock.

## Brief contract

| Requirement | Result |
|---|---|
| Test-first; isolated `test_db.lua` stays green without Store, then persist cases dofile Common + Ranks + Store + DB | Met (206 / 0) |
| `Save` writes `Store:Snapshot()` table, not an Archive stamp | Met |
| `Init` Restores only a Snapshot-shaped table (`humans` + `characters`) | Met |
| Lane D `{}` hook is not a Snapshot; do not Restore it | Met |
| Leftover `ladder` / `scoring` / `suggestions` stay at the root; never copy into `store`; never wipe | Met |
| Store missing: Init/Save succeed; `store` remains `{}` if that is on disk | Met |
| Do not bump `SCHEMA_VERSION` unless a new root key is added | Met (still 5) |
| Do not invent Archive reminder, #8 persist policy, Director Console, BeefNet v2, Grant/standing, a second schema | Met |
| Do not edit TOC / `ChurchOfBeef.lua` / Store / Archive / Recognition / UI / Net | Met |
| Isolated `test_db.lua` must pass | Met (206 / 0) |
| No commit; do not invent product / OPEN_QUESTIONS answers | Met |

## Sections checked

- `docs/reformation/phase-0/TEN_LAWS.md` Laws 5, 7
- Brief `docs/reformation/phase-2/briefs/P2-E-persist.md`
- Writer report `docs/reformation/phase-2/reports/P2-E-persist.md`
- Bible §12.1, §13.1 (also §12.3 permanence; §13.5 Archive out of scope)
- `GATE1_DESIGN_LEAD_DIRECTIVE.md` §4 (`#8` do not code)
- `docs/design/OPEN_QUESTIONS.md` (#8 unchanged)
- `addon/ChurchOfBeef/Core/DB.lua` (live + empty-Snapshot / leftover / Archive-string / no-Store / refused-Restore probes)
- `tests/test_db.lua` (live + isolated run: 206 / 0)
- `addon/ChurchOfBeef/Core/Store.lua` Snapshot / Restore (read only; mtime Aug 14)
- `ChurchOfBeef.lua` Init/Save hooks (read only; not edited)
- `ChurchOfBeef.toc` (`## SavedVariables: ChurchOfBeefDB`)
- Writer transcript ([Store persist](05fb857d-7e24-49dc-9e0a-66ec5eb1d2cf)) — exclusive Writes only
- P2-A / P2-B leftovers (Restore passthrough / empty Snapshot) — not reopened as this lane’s defect
