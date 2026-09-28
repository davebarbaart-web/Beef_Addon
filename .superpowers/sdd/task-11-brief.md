## Task 11: Pope-only Gora persist

**Files:** `Core/Gora.lua`; `Core/DB.lua`; `ChurchOfBeef.lua`; `tests/test_gora.lua`; `tests/test_db.lua`

**Depends on:** Tasks 6 and 10.

### Pins

- Snapshot/Restore `sanctioned`, petitions (including unsigned name-keys), `favorPicks`, `lastSanctioned`, `eventId`.
- `SCHEMA_VERSION` stays 7. Update `rootKeys` if you add root `gora`.
- Restore **after** event restore. If gora lands first, `_Expire()` sees QUIET and wipes the pair.
- Pope-only Save and Restore. Congregation must not write `gora = {}` over a shared-account SV.
- Debounce: `if C_Timer and C_Timer.After then` else save on the write path / `PLAYER_LOGOUT` only. Tests call `DB:Save()` directly. `wow_stub.lua` has **no `C_Timer`**.
- Wrap successful Gora/Runtime/Store writes. `ResetForTests` must not Save.

See `docs/superpowers/plans/2026-09-14-shared-account-sv.md`. No commit. `lua tests/run.lua` exit 0.
