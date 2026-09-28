# Task 11 report — Pope-only Gora persist

**Date:** 2026-09-14  
**Checkout:** `/Volumes/AI_Design_Drive/Beef_Addon`  
**Status:** **DONE** (harness green). Not a Gathering. Not `POLISH:PASS`. Not MVP.

## What landed

`Gora:Snapshot` / `Gora:Restore` copy `sanctioned`, petitions (including unsigned name-key rows), `favorPicks`, `lastSanctioned`, and `eventId`. Empty `{}` / missing `eventId` is not a snapshot and does not replace live memory.

Schema **7** gained root `gora` via `applyDefaults` / `ensureTable`. No schema 8. `DB:Init` Restores **store → event → gora → decree** with no `UnitName` / role lookup (ADDON_LOADED is still too early). Gora lands after event so `_Expire()` does not see QUIET and wipe the pair.

**Predicate (`localWriterIsPope` in `DB:Save`, not Init):** `COB.Sender` exists and `Sender:IsRegisteredPope(Group.PlayerName()) == true`. Isolated Core tests with no Sender are **not** Pope — `Save` leaves present `db.event` and `db.gora` untouched. Tests that stub Sender as Pope still write both. Pew `OnLogout` / `DB:Save` may still persist `store` / `ui` / `decree`.

Write-path persist: `InstallWire` `wrapAfter`s successful Gora / Runtime / Store writers. `ResetForTests` and `Gora:_Expire` are not wrapped. `if C_Timer and C_Timer.After then` debounce, else Save on the write path. `PLAYER_LOGOUT` still flushes. Tests call `DB:Save()` directly. `wow_stub.lua` has no `C_Timer`.

Pope `/reload` with a persisted sanctioned pair + restored event: `DeclareVictor` does not refuse `no sanctioned gora`.

Task 10 login split, Welcome order, pew Quiet drop, Pope `sendState`, gated `RequestSnapshot`, stash, #111, and slash honesty were not unwrapped.

## Files

| File | Change |
|------|--------|
| `addon/ChurchOfBeef/Core/Gora.lua` | `Snapshot` / `Restore`; persist copies of petitions / last pair; comments no longer say never-SV |
| `addon/ChurchOfBeef/Core/DB.lua` | Root `gora`; Init restore after event; Pope-only ceremony Save |
| `addon/ChurchOfBeef/ChurchOfBeef.lua` | `persistAfterWrite` wraps; OnLogout comment (still calls `DB:Save`) |
| `tests/test_gora.lua` | Round-trip, empty `{}`, Restore-after-event, `ResetForTests` does not Save |
| `tests/test_db.lua` | `rootKeys` includes `gora`; Pope Save; pew / no-Sender leave blobs; Init order |
| `.superpowers/sdd/task-11-report.md` | This report |

Not edited: `UI/Hud.lua`, `UI/Console.lua`, `Net/Codec.lua`, `Core/Runtime.lua`. No `tests/test_wire_glue.lua` pin (pew-Save is in `test_db.lua`).

## Pins

- Snapshot / Restore of sanctioned + unsigned petition + favorPicks + lastSanctioned + eventId. `{}` does not replace live memory.
- `SCHEMA_VERSION == 7`. `rootKeys` == `decree,event,gora,store,ui,version`.
- Init restore order: event then gora. Restore-before-event expires on the next `GetSanctioned`.
- `DB:Init` has no `UnitName`. `DB:Init` chunk has no `IsRegisteredPope`. Save predicate is `localWriterIsPope`.
- Pew Save / no-Sender Save do not assign empty `gora` or Quiet `event` over present blobs.
- `ResetForTests` does not call `DB:Save`. Wraps never list `ResetForTests` or `_Expire`.
- After Pope Save → reset → Init, `DeclareVictor` succeeds.

## Harness

Lua 5.1. All exit 0.

| Suite | Result |
|-------|--------|
| `lua tests/test_gora.lua` | **601 passed, 0 failed** |
| `lua tests/test_db.lua` | **648 passed, 0 failed** |
| `lua tests/run.lua` | **16826 passed, 0 failed** |

## Not run

In-game Pope `/reload` with a live sanctioned pair, or two-client smoke on separate Account SV trees. Green harness is not client smoke.

## Concerns

1. **Init Restore stays ungated.** Congregation still Restores leftover `event` + `gora` at `ADDON_LOADED` (Task 10: no role split in `DB:Init`). Pew `OnLogin` drops Quiet; the next Gora read `_Expire`s the desk. The wipe Task 10 named is closed on **Save**, not on Init Restore. A pew process that Saves *before* the Quiet drop could still snapshot a live desk — Pope-only Save prevents that write too.
2. **`applyDefaults` still `ensureTable`s a missing `gora` to `{}`.** Pew Save of an old file that never had `gora` adds an empty hook. That is not overwriting a present snapshot (`{}` is not Restored). A present Pope blob is left as the same table.
3. **`wow_ui_stub` has `C_Timer`.** Full-harness `test_wire_glue` (last suite) may queue a debounced Save when `COB.DB` is leftover from `test_db`. `wow_stub.lua` has no `C_Timer`; isolated Core tests Save on the write path or via `DB:Save()`. Did not fail the harness.
4. Pew Save still Snapshots **store**. Congregation Store mint remains OPEN_QUESTIONS **#26**, not this task.
