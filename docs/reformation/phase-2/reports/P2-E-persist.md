# Phase 2 Lane E — Persist the Pope store into account SV

**Status:** DONE

**Cited:** Ten Laws 5, 7; Bible §12.1, §13.1; Lane D `store = {}` hook; Lane A `Store:Snapshot` / `Restore`; brief `docs/reformation/phase-2/briefs/P2-E-persist.md`.

Data-layer wire only. When `COB.Store` is present, `Save` writes the Snapshot table into `ChurchOfBeefDB.store`; `Init` Restores only a Snapshot-shaped table. The Lane D empty `{}` hook is not a Snapshot. No Store module: Init/Save still succeed and leave `store = {}`. Leftover `ladder` / `scoring` / `suggestions` stay at the SV root — not imported, not wiped. TOC / bootstrap / `tests/run.lua` / Store / Archive / Recognition / UI / Net not edited. No commit. Player `WTF/` not touched. `OPEN_QUESTIONS.md` unchanged.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_db.lua` | Standalone runner. Existing no-Store path kept (Store hidden). Persist cases dofile Common + Ranks + Store + DB. |
| `addon/ChurchOfBeef/Core/DB.lua` | `Save` writes `Store:Snapshot()` when Store exists. `Init` Restores only when `store` has `humans` and `characters` tables. |
| `docs/reformation/phase-2/reports/P2-E-persist.md` | This file |

## Schema

- **`SCHEMA_VERSION`:** 5 (unchanged — no new root key).
- Fresh Init: `{ version = 5, ui, store = {} }` whether or not Store is loaded. Init does not Snapshot.
- `Save` with Store: `store` becomes the Snapshot table (`humans`, `characters`, `ceremonyLog`, `markedMoments`, `next*Id`). Not an Archive string.
- `Save` without Store: `store` remains `{}` if that is what is on disk.

## Verification

- Isolated suite (`lua tests/test_db.lua`): **206 passed, 0 failed**.
- No-Store section: Init/Save still work; empty hook survives; leftovers are not imported or wiped.
- With-Store section: empty `{}` / missing store / humans-only / characters-only / typed-wrong fields do not call `Restore` and do not wipe live humans. Snapshot-shaped store Restores once. Round-trip keeps rank, elevation, tombstone, Gora, ceremony log, marked moments. Leftovers stay at the root.
- Lua 5.1. Full harness (`lua tests/run.lua`): 1589 passed, 0 failed (integrator-owned; this lane did not edit `run.lua`).

## Leftovers (other lanes — not fixed)

- **Archive** remains the backup codec. Live persist is the Snapshot table. No weekly reminder, Discord post, or file-picker.
- **#8** registered-Pope / congregation-vs-Pope persist policy is not coded. This lane persists whenever `COB.Store` is present.
- Director Console, BeefNet v2, Grant/standing, and a second schema were not invented.

## Concerns

- After the first `Save` with Store, `store` is Snapshot-shaped (including empty humans/characters arrays). The next `Init` Restores that Snapshot. That is `/reload`, not the Lane D `{}` hook.
- `Restore` of a valid empty Snapshot would clear live memory. `Init` never treats `{}` as that Snapshot.
- `OPEN_QUESTIONS.md` was not edited. #8 stays open.
