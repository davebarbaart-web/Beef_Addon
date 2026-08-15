# Phase 4 Lane A — Persist the Runtime event object

**Status:** DONE

**Cited:** Ten Laws 5, 7; Bible §20.3, §13.1; `.cursor/rules/ceremony-runtime.mdc` (Disconnect: Pope console resumes from the persisted event object); brief `docs/reformation/phase-4/briefs/P4-A-persist-runtime.md`.

Data-layer wire only. Schema 6 adds root key `event`. When `COB.Runtime` is present, `Save` writes `Runtime:Snapshot()` into `ChurchOfBeefDB.event`; `Init` Restores only when `event.state` is a string. Empty `{}` / missing `event` does not Restore. Runtime missing: Init/Save still succeed; `event` stays `{}` (not a Snapshot). Store persist is unchanged. Leftover `ladder` / `scoring` / `suggestions` stay at the SV root — not imported into `event` or `store`, not wiped. TOC / bootstrap / `tests/run.lua` / Runtime / Store / Archive / Net / UI / Sender / Codec / Snapshot / `OPEN_QUESTIONS.md` not edited. No commit. Player `WTF/` not touched.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_db.lua` | Schema 6 + empty `event` hook on the no-Runtime path. Runtime persist cases dofile Common + Runtime + DB. |
| `addon/ChurchOfBeef/Core/DB.lua` | `SCHEMA_VERSION` 5→6. `Save` writes `Runtime:Snapshot()` when Runtime exists. `Init` Restores only when `event.state` is a string. |
| `docs/reformation/phase-4/reports/P4-A-persist-runtime.md` | This file |

## Schema

- **`SCHEMA_VERSION`:** 6 (bumped because the `event` key was added).
- Fresh Init: `{ version = 6, ui, store = {}, event = {} }` whether or not Runtime is loaded. Init does not Snapshot.
- `Save` with Runtime: `event` becomes the Runtime Snapshot (`state`, `eventId`, `riteType`, `subjects`, `sequence`; `awaitingPope` only if set). Not a hold timer. Not a sixth state.
- `Save` without Runtime: `event` remains `{}` if that is what is on disk. No Snapshot-shaped ceremony object is invented.
- Store persist is unchanged: `Save` still writes `Store:Snapshot()` when Store exists.

## Verification

- Isolated suite (`lua tests/test_db.lua`): **369 passed, 0 failed**.
- No-Runtime section: Init/Save still work; empty `event` hook survives; leftovers are not imported or wiped. Isolated path still dofiles `DB.lua` only.
- With-Runtime section: empty `{}` / missing event / non-string `state` do not call `Restore` and do not wipe the live event. Snapshot-shaped event Restores once. Round-trip keeps RITE / Gora / fighters / sequence. `awaitingPope` round-trips on non-QUIET; QUIET Restore drops it (Runtime). Leftovers stay at the root.
- Lua 5.1. This lane did not edit `tests/run.lua`.

## Leftovers (other lanes — not fixed)

- **#8** registered-Pope / congregation-vs-Pope persist policy is not coded. This lane persists whenever `COB.Runtime` is present.
- Director Console, Grant/standing, a hold timer, and Archive-of-the-event were not invented.

## Concerns

- After the first `Save` with Runtime, `event` is Snapshot-shaped (including cold QUIET). The next `Init` Restores that Snapshot. That is `/reload`, not the empty `{}` hook.
- `Restore` of a valid QUIET Snapshot replaces live memory with QUIET. `Init` never treats `{}` as that Snapshot.
- A crafted `event.state` string (including `AWAITING_POPE`) still calls `Restore`; Runtime refuses invalid states and leaves the live event unchanged. DB does not special-case a sixth state.
- `OPEN_QUESTIONS.md` was not edited. #8 stays open.
