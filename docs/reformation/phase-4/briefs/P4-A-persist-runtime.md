# Phase 4 Lane A — Persist the Runtime event object

Read: Ten Laws 5, 7; Bible §20.3, §13.1; `.cursor/rules/ceremony-runtime.mdc` (Disconnect: Pope console resumes from the persisted event object). Phase 3 is signed. Gate 3 leftover: Runtime is not in `ChurchOfBeefDB`.

## Exclusive files

- `addon/ChurchOfBeef/Core/DB.lua`
- `tests/test_db.lua`
- Report: `docs/reformation/phase-4/reports/P4-A-persist-runtime.md`

**Do not** edit TOC, `ChurchOfBeef.lua` (Init/Save already run on ADDON_LOADED / PLAYER_LOGOUT), `Core/Runtime.lua`, `Core/Store.lua`, `Core/Archive.lua`, UI, Net, Sender, Codec, Snapshot.

## Mission

Test-first. Keep isolated `test_db.lua` green when Runtime is absent (today it dofiles `DB.lua` only — that path must still work). When Runtime is present, add cases.

Bible §20.3: on reconnect, the Pope console resumes from the **event object** in his SavedVariables. That object is `Runtime:Snapshot()` / `Runtime:Restore`. It is not the Pope store.

- **New root key `event`.** Bump `SCHEMA_VERSION` to **6** (`{ version, ui, store, event }`). Phase 2 said bump only when adding a root key — this is that key. The Bible names the event object; do not invent `runtime` / `ceremony` / `holdSeconds`.
- **`DB:Save`** writes `ChurchOfBeefDB.event = Runtime:Snapshot()` when `COB.Runtime` exists. Store persist is unchanged (`store = Store:Snapshot()`).
- **`DB:Init`** Restores `event` only when it looks like a Runtime snapshot (`state` is a string). Empty `{}` / missing `event` does **not** call `Restore`. QUIET Restore already drops `awaitingPope` — do not special-case a sixth state.
- `Runtime` missing: Init/Save still succeed; do not invent an event table.
- Leftover `ladder` / `scoring` / `suggestions` stay at the SV **root**. Never copy them into `event` or `store`. Never wipe them.

Do not invent: congregation-vs-Pope persist policy, `#8` Pope list, Director Console, Grant/standing, a hold timer, Archive-of-the-event.

## Do not git commit.
