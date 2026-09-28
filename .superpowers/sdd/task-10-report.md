# Task 10 report — Login restore + Pope rebroadcast

**Date:** 2026-09-14  
**Checkout:** `/Volumes/AI_Design_Drive/Beef_Addon`  
**Status:** **DONE** (harness green). Not a Gathering. Not `POLISH:PASS`. Not MVP.

## What landed

`PLAYER_LOGIN` is the role split. `DB:Init` (`ADDON_LOADED`) still Restores a string-`state` event for whoever loads. Congregation then drops that leftover Event Mode to a **nil-eventId Quiet** (`Runtime:DropToQuietForVersion()` / `newEvent()` shape) **before** `initUi`. Listed Pope keeps the restored event. After `InstallWire`, listed Pope + Runtime ≠ QUIET calls `sendState()` once (#48). Peer HELLO rebroadcast is unchanged.

`RequestSnapshot` is now called from bootstrap, gated: accepted Pope HELLO (`IsRegisteredPope(sender)`) or accepted live STATE this session, local Runtime still QUIET, once per login (`COB._snapshotAsked`). OnLogin itself never asks (cold Tuesday + `Popes.List[1]` is not an ask). Tuesday no-response / `no target` is not a failure.

`restoreDecreeFromSv` left as-is. SCHEMA_VERSION **7**. Interface **20506**. Welcome order, `initModule`, slash honesty, stash, and #111 card glue were not unwrapped.

## Files

| File | Change |
|------|--------|
| `addon/ChurchOfBeef/ChurchOfBeef.lua` | OnLogin drop / Pope `sendState`; gated snapshot ask on `_OnPeerHello` + inbound live STATE |
| `addon/ChurchOfBeef/Core/DB.lua` | Comment only: Init does not look up the local character |
| `tests/test_wire_glue.lua` | Pew Quiet-before-Init, Pope keep + one send, snapshot gates |
| `tests/test_db.lua` | Init still Restores RITE with a local name + false Pope predicate; source pin |
| `.superpowers/sdd/task-10-report.md` | This report |

Not edited: `UI/Hud.lua`, `UI/Console.lua`, `Net/Codec.lua`, `Core/Gora.lua`, `Core/Runtime.lua`.

## Pins

- `DB:Init` has no `UnitName` / `IsRegisteredPope` gate. Source scan + runtime pin: saved RITE Restores even when `UnitName("player")` is Pewalt and Sender is false.
- Congregation OnLogin after restored RITE → Runtime QUIET **before** the first UI Init spy. `eventId` is nil (not `{ state="QUIET", eventId=<same>, sequence=0 }`). Init order still Welcome after DecreeBanner.
- Listed Pope OnLogin keeps RITE / event id; after InstallWire, one STATE when ≠ QUIET. QUIET Pope does not self-send.
- RequestSnapshot: Pope HELLO while local QUIET → once; second HELLO no-ops; pew HELLO no-ops; cold Tuesday OnLogin with `List[1]` set does not ask; Event Mode + Pope HELLO does not ask; live STATE that Restores Event Mode does not ask (local no longer QUIET).
- SCHEMA 7 unchanged.

## Harness

Lua 5.1. All exit 0.

| Suite | Result |
|-------|--------|
| `lua tests/test_wire_glue.lua` | **900 passed, 0 failed** |
| `lua tests/test_db.lua` | **534 passed, 0 failed** |
| `lua tests/run.lua` | **16655 passed, 0 failed** |

## Not run

In-game `/reload` and two-client HELLO → snapshot / Pope self-send. Green harness is not client smoke.

## Concerns

1. **Shared-account `event` Save.** Congregation `OnLogout` still calls `DB:Save()`, which Snapshots the now-QUIET Runtime over the same `ChurchOfBeefDB.event` the Pope restored. Same-account pew logout can wipe the Pope’s persisted ceremony. Task 10 was not allowed to gate Save. Task 11 must not repeat this shape for `gora`.
2. **Snapshot dest vs once-flag.** `_snapshotAsked` is set even when `RequestSnapshot` returns `no target`. A Pope HELLO before `_lastStateSender` / `Popes.List[1]` is resolvable will not retry this login. TOC loads `Data/Popes.lua`, so production usually has a dest; isolated suite does not (spies the call).
3. **Live STATE ask is the leftover-Quiet path.** A successful live Restore leaves Event Mode, so the ask no-ops. The STATE gate is covered by a Restore no-op stub (accepted live STATE, local still QUIET → one ask). HELLO is the real catch-up.
4. **Missing `UnitName` at PLAYER_LOGIN** is treated as pew and drops Event Mode. In-game the name is available at login; Init stays ungated so the Pope’s ADDON_LOADED restore still happens first.
5. Decree leftover still Restores for everyone in Init (pin: prefer not expanding).
