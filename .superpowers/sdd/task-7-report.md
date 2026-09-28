# Task 7 Report — Version drop + PROTOCOL 2

**Status:** DONE_WITH_CONCERNS  
**Date:** 2026-09-14  
**Slice:** Wave 2 Task 7 only. No commit. SCHEMA_VERSION stays 7. Interface stays 20506.

Locked options: O-Foreign A, O-Drop A, O-Warn A, O-Where (Net inbound + `Snapshot:ApplyResponse`).

## What landed

- `Codec.PROTOCOL = 2` and `Net.PROTOCOL = 2`. Both `IsCompatible` stay `finite(version) == self.PROTOCOL`. `IsCompatible(1) == false`. `IsCompatible(2) == true`.
- Foreign/skew fixtures now use major `1:` (old v1). Protocol `0:` stays foreign. Local emit/decode fixtures are `2:`.
- `_WarnVersion` chats `the Church's software has advanced; update the addon.` Once per session via `warnedVersion`. Discard reason stays `"protocol mismatch"`. No toast / Sound / status chip.
- Incompatible inbound does not Restore/Apply the foreign theater. Event chrome drops to QUIET via `Runtime:DropToQuietForVersion()` (`Restore` of `newEvent()`: `state="QUIET"`, no rite, no subjects, sequence 0, eventId nil). Not `EndEvent`. Not a sixth state.
- Drop runs on Net mismatch (`HandleHello`, TYPES gate, `_HandleV2`) and on `Snapshot:ApplyResponse`. Net guards the helper when Runtime is absent (HELLO-only validate cut).
- Extra unknown colon parts still `"unknown field"`. No packed `names` allowlist. No clerical kind/beat.
- I-06 rewind leftovers were not inverted.

## Pins inverted / retargeted

- I-05: local major is 2; old v1 is incompatible.
- I-02 (`test_net_v2.lua`): after foreign STATE/SNAPSHOT, Runtime is QUIET; foreign body not Restored; `"protocol mismatch"`; `_WarnVersion` once; chat contains the Bible phrase + update the addon; no toast.
- I-03 (`test_ceremony_chaos.lua`): `ApplyResponse` of foreign-major drops to QUIET presentation. Header still “Do not add a Quiet toast.” Runtime still has no toast / `_WarnVersion`.
- Companion `test_net_validate.lua` (Option V1) and `test_wire_glue.lua` `HandleHello({ version = 2, … })` so the harness stays green.

## Harness

Isolated:

| Suite | Result |
|-------|--------|
| `lua tests/test_net_codec.lua` | 481 passed, 0 failed |
| `lua tests/test_net_v2.lua` | 829 passed, 0 failed |
| `lua tests/test_ceremony_chaos.lua` | 473 passed, 0 failed |
| `lua tests/test_net_snapshot.lua` | 824 passed, 0 failed |
| `lua tests/test_net_validate.lua` | not standalone (see concerns) |

Full: `lua tests/run.lua` — **16314 passed, 0 failed**, exit 0.

## Concerns

1. `lua tests/test_net_validate.lua` still cannot run isolated: it `require`s `wow_ui_stub` and uses harness `assert_eq`. Pre-existing. Covered by `lua tests/run.lua`.
2. `DropToQuietForVersion` is still `Restore(newEvent())` (O-Drop A Quiet object). Controller follow-up: the helper now keeps `nextEventId` so a later `StartEvent` does not reuse 1. Pinned in `tests/test_runtime.lua`.
3. No `.superpowers/sdd/task-6-report.md` was present. Work proceeded on the explicit Task 7 instruction.

Not claimed: POLISH:PASS, POLISH:CANDIDATE, MVP / Bible §22.3. Phase docs not ticked.
