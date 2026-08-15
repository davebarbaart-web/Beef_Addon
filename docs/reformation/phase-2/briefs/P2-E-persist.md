# Phase 2 Lane E — Persist the Pope store into account SV

Read: Ten Laws 5, 7; Bible §12.1, §13.1; Lane D `Core/DB.lua` (`store = {}` hook); Lane A `Store:Snapshot` / `Restore`.

A–D are signed. The store is still in-memory only. This lane is the missing data-layer wire: Church history must survive `/reload` on the Pope's account SV.

## Exclusive files

- `addon/ChurchOfBeef/Core/DB.lua`
- `tests/test_db.lua`
- Report: `docs/reformation/phase-2/reports/P2-E-persist.md`

**Do not** edit TOC, `ChurchOfBeef.lua` (Init/Save already run on ADDON_LOADED / PLAYER_LOGOUT), `Core/Store.lua`, `Core/Archive.lua`, `Core/Recognition.lua`, UI, Net.

## Mission

Test-first. Keep isolated `test_db.lua` green (it currently dofiles `DB.lua` only — that path must still work).

When `COB.Store` is present:

- **`DB:Save`** writes `ChurchOfBeefDB.store = Store:Snapshot()` (the Snapshot table, not an Archive stamp). Archive is the backup codec, not live persist.
- **`DB:Init`** Restores from `ChurchOfBeefDB.store` only when it looks like a Snapshot (has `humans` and `characters` tables). The Lane D empty `{}` hook is **not** a Snapshot — do not call `Restore` on it (that would replace live memory with nobody).
- Leftover `ladder` / `scoring` / `suggestions` stay at the SV **root**. Never copy them into `store`. Never wipe them.
- `Store` missing: Init/Save still succeed; `store` remains `{}` if that is what is on disk.

Do not bump `SCHEMA_VERSION` unless you add a new root key (you should not).

Do not invent: Archive reminder, congregation-vs-Pope persist policy (#8), Director Console, BeefNet v2, Grant/standing, a second schema.

## Do not git commit.
