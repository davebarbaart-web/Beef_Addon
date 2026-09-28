## Task 10: Login restore + Pope rebroadcast

**Files:** `ChurchOfBeef.lua`; `Core/DB.lua`; `tests/test_wire_glue.lua`; `tests/test_db.lua`

**Depends on:** Task 4 done (`welcomeSeen` already in DB). Do not start while Task 4 or Task 8 still owns `ChurchOfBeef.lua`.

### Pins

- Do **not** gate `restoreEventFromSv` on `UnitName` inside `DB:Init` (`ADDON_LOADED`). Pope would skip restore.
- On `PLAYER_LOGIN`, if not `IsRegisteredPope`, Restore QUIET / skip applying the SV event **before** `initUi`. Pope keeps the restored event.
- `RequestSnapshot` only after accepted Pope HELLO or live STATE this session, local still QUIET. Once per login. Tuesday no-response is not a failure.
- If local Pope and Runtime ≠ QUIET after `InstallWire`, `sendState()` once (#48).
- Congregation Decree: prefer not expanding. Do not treat leftover SV as Pope chrome if you must touch Decree — otherwise leave it.

SCHEMA_VERSION stays 7. No commit. `lua tests/run.lua` exit 0.
