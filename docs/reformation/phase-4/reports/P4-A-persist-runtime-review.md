# Phase 4 Lane A — Adversarial Review

**Lane:** Persist the Runtime event object
**Exclusive files:** `addon/ChurchOfBeef/Core/DB.lua`, `tests/test_db.lua`
**Lane report:** `docs/reformation/phase-4/reports/P4-A-persist-runtime.md`
**Cited law:** Ten Laws 5, 7; Bible §20.3, §13.1; `.cursor/rules/ceremony-runtime.mdc` (Disconnect); `GATE1_DESIGN_LEAD_DIRECTIVE.md` §4 (`#8` do not code); brief `docs/reformation/phase-4/briefs/P4-A-persist-runtime.md`
**Writer:** [Persist](9a838146-ab3c-4ecb-a342-224117dadbdb)

**Spec:** PASS
**Quality:** Approved

Data-layer wire only. Schema 6 adds root key `event`. When `COB.Runtime` is present, `Save` writes `Runtime:Snapshot()` into `ChurchOfBeefDB.event`. `Init` Restores only when `event.state` is a string. Empty `{}` / missing `event` do not Restore and do not wipe a live event. Runtime missing: Init/Save still succeed; `event` stays `{}` (not a Snapshot). Store persist is unchanged (`store = Store:Snapshot()`). Leftover `ladder` / `scoring` / `suggestions` stay at the SV root — not imported into `event` or `store`, not wiped. Isolated suite: **369 passed, 0 failed**. Writer stayed inside exclusive files. `OPEN_QUESTIONS.md` #8 unchanged. No `Data/Popes.lua`. No commit. Player `WTF/` not touched. This review did not invent a Pope list, a hold timer, or a persist schema.

## Verdict

Refutation of Laws 5, 7, Bible §20.3 / §13.1, and “do not invent a persist schema / hold timer / #8” **fails** for this lane’s exclusive files.

Law 5 and §13.1 are intact on the same terms as Phase 2 store persist. `DB` has no StartEvent / OpenRite / MarkPopeLost / Grant verbs. It copies the in-memory Runtime object onto the account SV and reloads a string-`state` table back into that same Runtime. That is §20.3’s “the event object persists in his SavedVariables,” not a second authority, not peer consensus, not congregation theater. Persist-when-Runtime-present on every client is the brief; `#8` is not coded.

Law 7 is intact on the honest path and on the named empties. `{}`, a missing event (filled to `{}`), a table without `state`, and a non-string `state` do not call `Restore` and do not replace a live ASSEMBLY. Leftover demo keys are neither imported nor swept. Round-trip keeps RITE / Gora / fighters / sequence. A *valid* QUIET Snapshot may Restore QUIET over live memory — that is `/reload` of a saved event object, not a `SweepDeparted`, not the empty `{}` hook. The event object is ceremony state, not Church history (ranks, Gora records, ceremony log live in `store`).

§20.3 resume is the Runtime Snapshot / Restore already signed in Phase 3. This lane does not invent `runtime` / `ceremony` / `holdSeconds` / a sixth state. `awaitingPope` is Runtime’s degraded-Event flag; QUIET Restore still drops it. ceremony-runtime.mdc’s “do not invent a snapshot schema” holds: DB persists `Runtime:Snapshot()` wholesale and gates on the Bible-named field `state`. GATE1 §4 `#8` is untouched.

This review did not invent congregation-vs-Pope persist policy, a hold-timeout number, `Data/Popes.lua`, or Director Console, and did not commit.

## Confirmations

| Check | Result |
|---|---|
| `SCHEMA_VERSION` is 6; root is `{ version, ui, store, event }` | **Yes.** `SCHEMA_VERSION = 6`. Fresh Init keys are exactly `event,store,ui,version`. Schema 5 SV stamps to 6 when the `event` hook is added. Downgrade 99 is kept. |
| `Save` writes `Runtime:Snapshot()` when Runtime exists; store persist unchanged | **Yes.** `snapshotEventToSv` assigns `db.event = runtime:Snapshot()`. Store path is still `db.store = store:Snapshot()` when Store exists. Reviewer dual-Save: human name + RITE/Gora both land; leftovers stay at the root. |
| `Init` Restores event only when `event.state` is a string; `{}` / missing does not Restore | **Yes.** `isEventSnapshot` is `type(event) == "table" and type(event.state) == "string"`. Spy: empty `{}` / missing / `{ future = true }` / `state = 1` / `state = true` → `restoreCalls == 0`; live ASSEMBLY and event id survive. |
| Runtime missing: Init/Save succeed; no Snapshot-shaped ceremony object invented | **Yes.** First section nils `COB.Runtime` and dofiles `DB.lua` only. Fresh and re-Save `eventKeys` stay `""`; `state` stays `nil`. Reviewer: hiding Runtime after persist is loaded still Inits/Saves; hook stays `{}`. |
| Leftover `ladder` / `scoring` / `suggestions` stay at SV root; not imported; not wiped | **Yes.** Nested leftover payload (`Alice`, `dayKey`, `leftover = true`) survives Init **and** Save, with and without Runtime, and on dual Store+Runtime Save. `event.ladder` / `store.ladder` stay `nil`. Missing leftovers are not created. |
| No `holdSeconds`, no `#8`, no Director Console, no Grant, no `Data/Popes.lua` | **Yes.** `DB.lua` has none of those tokens. `DB.Grant` / `SetStanding` / `IsPope` / `StartEvent` / `MarkPopeLost` / `holdSeconds` are `nil`. Save does not invent `ChurchOfBeefDB.holdSeconds` / `runtime` / `ceremony` / `Grant`. No `Data/Popes.lua`. `OPEN_QUESTIONS.md` #8 is unchanged (mtime Aug 14). |
| Isolated suite green | **Yes.** Isolated (`lua tests/test_db.lua`): **369 passed, 0 failed** (reviewer rerun, Lua 5.1). Writer count matches. No-Runtime path still dofiles `DB.lua` only. |
| Writer did not edit TOC / bootstrap / `run.lua` / Runtime / Store / Net / UI | **Yes.** Transcript Writes: `tests/test_db.lua` (first; RED on schema 5), `Core/DB.lua`, this lane’s report. Those other paths were Read only. Mtimes: Runtime 06:37, TOC 06:38, Store / bootstrap / `OPEN_QUESTIONS.md` Aug 14; writer files 07:01. `tests/run.lua` already listed `test_db`; its later mtime is another lane (`test_net_v2`). Init/Save remain ADDON_LOADED / PLAYER_LOGOUT. |

## Attack results

| Attack | Result |
|---|---|
| Law 5 — persist is a second writer / second source of truth? | **No.** `DB` does not start events, open rites, or mark Pope-lost. `Save` copies `Runtime:Snapshot()`. `Init` calls `Runtime:Restore` on the same module. Congregation UI/Net are not called. No broadcast. No peer self-report. |
| Law 5 / §13.1 — persist-when-Runtime-present on every client is peer authority? | **No as product.** Brief: persist when `COB.Runtime` is present. TOC already loads Runtime for every client. This lane must not invent a registered-Pope list (`#8` — do not code). Later layers must not treat a congregation account SV as canonical ceremony state or call Runtime verbs there. This review does not invent that gate. |
| Law 5 / §13.1 — Restore from SV is a competing database? | **No.** §13.1’s first sentence is per-client SavedVariables. The Pope’s account `event` is the durability of the Pope’s Runtime. Conflict resolution remains “one writer.” A congregation file that holds a local Snapshot after logout is a local hook, not a second Church. |
| Law 5 / §20.3 — congregation `/reload` Restores local theater instead of whispering the Pope? | **Leftover, not this wire.** §20.3 splits late-join (whisper snapshot from the Pope) from Pope reconnect (resume from *his* SV). This lane persists whenever Runtime exists. Catch-up and the `#8` sender gate are other lanes. Do not add `IsRegisteredPope` here. |
| Law 7 — empty `{}` / missing event Restores QUIET and wipes a live ASSEMBLY? | **No.** `isEventSnapshot({})` is false. Missing event is filled to `{}` and skipped. Live ASSEMBLY and event id survive. That was the empty hook the brief named. |
| Law 7 — leftover demo keys must be imported as Church history? | **No.** That would invent product: treat a banned points ladder as history. Brief: leftovers stay at the root; never copy into `event` or `store`. Suite locks the non-import. |
| Law 7 — Init/Save wipe leftover `ladder` / `scoring` / `suggestions`? | **No wipe.** `applyDefaults` fills `version`, `ui`, `store`, and `event` only. `snapshotEventToSv` replaces `event` with a Snapshot; it does not touch root leftovers. Reviewer: leftovers survive empty-hook Init, Snapshot-shaped Init, and dual Save. |
| Law 7 — valid QUIET Snapshot over live ASSEMBLY is `SweepDeparted`? | **No.** Reviewer probe: `{ state = "QUIET", sequence = 0, subjects = {} }` *does* Restore and replace live ASSEMBLY. Writer disclosed this. The blob is a real Runtime Snapshot. Production `Init` runs once at ADDON_LOADED against an empty in-memory event — that is `/reload`, not a departed sweep. The event object is not Church history. Do not invent “refuse QUIET churches.” |
| Law 7 — refused Restore (empty-string / incomplete / `AWAITING_POPE`) deletes disk or live event? | **No.** Reviewer: `state = ""` and `{ state = "QUIET" }` (no sequence) call Restore; Runtime refuses; live ASSEMBLY stays; SV blob is not wiped. Suite already locks `AWAITING_POPE` the same way. |
| Law 7 — non-table `event` is a history sweep? | **No.** `ensureTable` replaces a string with `{}` (don’t-error). Reviewer: `"COBARCH1:nope"` does not Restore and does not wipe live ASSEMBLY. Event is not the Archive codec. |
| §20.3 — this lane invented a persist schema (`runtime` / `ceremony` / extra fields)? | **No.** New root key is the Bible’s **event object**. Shape is `Runtime:Snapshot()` (Phase 3: `state`, `eventId`, `riteType`, `subjects`, `sequence`; `awaitingPope` only if set). Gate is the brief’s `state` is a string — a Bible-named field, not a new codec. No `holdSeconds`. |
| §20.3 / ceremony-runtime — hold duration / §20.4 five/thirty coded as a timer? | **No.** `DB.lua` has no `holdSeconds` / `holdTimeout` / seconds constant. Crafted extras on disk are dropped by Runtime Restore and stripped on the next `Save` Snapshot. §20.4 remains a quality bar. |
| §20.3 — `awaitingPope` persist is a sixth state? | **No.** Save of MarkPopeLost stays `ASSEMBLY` + `awaitingPope = true`. QUIET Restore still drops the flag (Runtime). DB does not special-case a sixth name. |
| GATE1 §4 `#8` — registered-Pope list / `Data/Popes.lua` invented? | **No.** No Pope-name table, no `IsRegisteredPope`, no workspace data file. `#8` text in `OPEN_QUESTIONS.md` is unchanged. |
| Writer invented Director Console / Grant / standing, edited forbidden files, or committed? | **No.** Exclusive Writes only. No commit. `ChurchOfBeef.lua` still Init on ADDON_LOADED and Save on PLAYER_LOGOUT. |

Refutation of Law 5 (one Pope writer; persist is durability), Law 7 (never-delete; `{}` is not a wipe; leftovers are not history), Bible §20.3 (Pope console resumes from the persisted event object; no hold timer; no invented snapshot schema), §13.1 (Pope-authoritative star; per-client SV), and GATE1 `#8` (do not code the Pope list) **fails** for the exclusive files. The QUIET Snapshot Restore is `/reload`, not `SweepDeparted`.

## Leftovers (other lanes — expected; not fixed)

Writer leftovers are current. Additional live leftovers this lane correctly did not touch:

### #8 / later (do not invent here)

- Registered-Pope / congregation-vs-Pope persist policy. This lane persists whenever `COB.Runtime` is present. Exact file, edit path, and override UX are Phase 4 spec (`OPEN_QUESTIONS.md` #8; GATE1 §4). Do not code now. Do not create `Data/Popes.lua` in review.
- Congregation late-join / UI reload is still a whisper snapshot from the Pope’s client (§20.3), not this SV hook. Local `event` on a congregation account is not canonical.
- Director Console, Grant/standing, a hold timer, Archive-of-the-event.

### Runtime (signed; writer did not edit)

- `Runtime.lua` still comments “no SV persist.” True of that module: it does not write `ChurchOfBeefDB`. DB does. Do not “fix” the comment in this lane.
- `Restore` of a valid Snapshot replaces live memory. Honest logout/`/reload` starts from an empty process.
- `isEventSnapshot` is weaker than `parseEvent`. Any string `state` calls Restore; Runtime refuse-closes invalid names and incomplete blobs. Do not special-case a sixth state in DB.

### Store persist (unchanged)

- Empty-array `{ humans = {}, characters = {} }` still Restores (P2-E leftover). Reviewer probe: still true after the event hook. Not this lane’s defect.
- `Save` with Store still drops unknown `store.future` (Snapshot replace). Same for `event.future` once Runtime exists.

### Integrator / bootstrap (already landed — writer did not edit)

- `ChurchOfBeef.toc` — `## SavedVariables: ChurchOfBeefDB`; lists `Core\Runtime.lua` before `Core\DB.lua`.
- `ChurchOfBeef.lua` — `DB:Init` on ADDON_LOADED; `DB:Save` on PLAYER_LOGOUT. Mid-session writes flush at logout / `/reload` only.
- `tests/run.lua` still lists `test_db`. Full harness color is integrator-owned.

### Not this lane

- Existing player `ChurchOfBeefDB` may still contain leftover `ladder` / `scoring` / `suggestions`. They remain on disk and are not Church history.
- `ui.announce` remains a shipped default. Pre-existing; not an event field.

## Findings

### Critical

None.

### Important

1. **A Snapshot-shaped QUIET event Restores.** Reviewer probe: `{ state = "QUIET", sequence = 0, subjects = {} }` calls `Restore` and replaces live ASSEMBLY. Writer disclosed this. After the first `Save` with Runtime, the empty `{}` hook is gone; the next `Init` Restores that Snapshot (including cold QUIET). Production `Init` is once per load against empty memory. Do not “fix” by refusing QUIET (invents a sixth-state special case / hold policy).

2. **`isEventSnapshot` is structural only.** Any string named `state` counts — including `""`, `AWAITING_POPE`, and `{ state = "QUIET" }` with no sequence. `Runtime:Restore` then refuse-closes; live event stays. Honest `Save` emits a parseable Snapshot. Do not move Runtime’s state table into `DB`.

3. **Persist-when-Runtime-present is every client.** TOC already loads Runtime. `#8` is not this wire. Later UI/Net must not treat a congregation SV `event` as the Church’s ceremony, and must not invent a Pope list to “fix” it here.

### Nit

1. **Law 7 citation is slightly loose on leftover demo keys.** Comments and the suite say leftovers survive “because Law 7.” Law 7’s object is Church history, not unknown keys. The brief used the same stretch. Behavior is right: do not import, do not wipe, do not treat leftovers as product. Do not “fix” this by adding a wipe.

2. **Suite does not lock QUIET Snapshot over live ASSEMBLY.** Writer report states the behavior. Reviewer probe confirms it. Coverage gap only.

3. **Suite does not lock Store+Runtime on the same `Save`.** Reviewer: both Snapshots write; leftovers stay at the root. The no-Store event Save and the no-Runtime store Save are locked separately.

4. **Suite does not lock empty-string / sequence-less `state`.** Reviewer: Restore is called; Runtime refuses; live ASSEMBLY stays; disk blob is not wiped. Honest Snapshot always has a sequence.

5. **`Save` with Runtime drops unknown `event.future`.** The no-Runtime section still locks “unknown event key survives Save.” With Runtime, `db.event = Snapshot()` replaces the table. Expected persist; not a root-leftover wipe.

6. **`initOk`’s `if not ok` branch is dead-looking.** `assert_true` does not abort. Coverage of the happy dirty paths is still real. Pre-existing from Lane D / P2-E.

7. **`DB:Init(_now)` still ignores `now`.** Pre-existing. Persist does not invent a clock or a hold timer.

## Brief contract

| Requirement | Result |
|---|---|
| Test-first; isolated `test_db.lua` stays green without Runtime, then persist cases dofile Common + Runtime + DB | Met (369 / 0). Transcript: suite first (RED on schema 5 / missing `event`), then `DB.lua`. |
| New root key `event`; bump `SCHEMA_VERSION` to 6 | Met |
| `Save` writes `Runtime:Snapshot()` when Runtime exists | Met |
| Store persist unchanged (`Store:Snapshot()`) | Met (suite + reviewer dual-Save) |
| `Init` Restores only when `event.state` is a string | Met |
| Empty `{}` / missing `event` do not Restore | Met |
| Runtime missing: Init/Save succeed; do not invent an event table / Snapshot | Met (`event` hook is `{}`, not a Snapshot) |
| Leftover `ladder` / `scoring` / `suggestions` stay at the root; never copy into `event` or `store`; never wipe | Met |
| Do not invent congregation-vs-Pope persist policy, `#8` Pope list, Director Console, Grant/standing, a hold timer, Archive-of-the-event | Met |
| Do not invent `runtime` / `ceremony` / `holdSeconds` | Met |
| Do not special-case a sixth state | Met (`AWAITING_POPE` still calls Restore; Runtime refuses) |
| Do not edit TOC / `ChurchOfBeef.lua` / Runtime / Store / Archive / UI / Net / Sender / Codec / Snapshot / `run.lua` | Met |
| Isolated `test_db.lua` must pass | Met (369 / 0) |
| No commit; do not invent product / OPEN_QUESTIONS answers | Met |

## Sections checked

- `docs/reformation/phase-0/TEN_LAWS.md` Laws 5, 7
- Brief `docs/reformation/phase-4/briefs/P4-A-persist-runtime.md`
- Writer report `docs/reformation/phase-4/reports/P4-A-persist-runtime.md`
- Bible §20.3, §13.1 (also §20.1–20.2 fields; §20.4 not a timer)
- `.cursor/rules/ceremony-runtime.mdc` (Disconnect; no invented snapshot schema / hold seconds)
- `GATE1_DESIGN_LEAD_DIRECTIVE.md` §4 (`#8` do not code)
- `docs/design/OPEN_QUESTIONS.md` (#8 unchanged)
- `addon/ChurchOfBeef/Core/DB.lua` (live + QUIET-over-live / leftover / dual-Save / no-Runtime / refused-Restore / crafted-hold probes)
- `tests/test_db.lua` (live + isolated run: 369 / 0)
- `addon/ChurchOfBeef/Core/Runtime.lua` Snapshot / Restore (read only; mtime 06:37)
- `ChurchOfBeef.lua` Init/Save hooks (read only; not edited)
- `ChurchOfBeef.toc` (`## SavedVariables: ChurchOfBeefDB`; Runtime before DB)
- Writer transcript ([Persist](9a838146-ab3c-4ecb-a342-224117dadbdb)) — exclusive Writes only
- P2-E persist leftovers (empty-array store Snapshot) — not reopened as this lane’s defect
