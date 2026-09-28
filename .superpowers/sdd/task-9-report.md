# Task 9 report — Latest-wins without dropping favor

**Date:** 2026-09-14  
**Status:** **done** (Option C). No commit. No phase ticks. Not POLISH:PASS. Not MVP.

PROTOCOL stays **2**. SCHEMA stays **7**. Interface stays **20506**. Task 8 packed names / stash / #111 were not reverted. Version-skew pins (Task 7 Quiet drop) were not inverted.

## What landed

`Runtime:Restore` is the ceremony gate:

| Incoming | Ceremony | Return |
|----------|----------|--------|
| Different `eventId` | Apply (new event; smaller seq is not a rewind) | ok |
| Same `eventId`, `sequence` greater | Apply | ok |
| Same `eventId`, `sequence` equal | Do not apply (different fighters must not win) | **ok** so bootstrap `if ok then paintInboundFavor` still runs |
| Same `eventId`, `sequence` less | Do not apply | `nil, "stale sequence"` so favor is not overlaid |

Favor is not a Runtime Bible field. Restore never writes a favor table onto the event object.

`Snapshot:ApplyResponse` uses the same rule via Restore. `_HandleState` still Restores Bible fields only and returns Restore’s result. Overlay stays in Net/bootstrap: equal seq is ok, older is not-ok. Theater inbound (`Toasts:Proclaim` / `Sound`) stays off (#27 unanswered).

I-06 leftover rewind pins in `tests/test_ceremony_chaos.lua` are inverted. Header no longer says “Do NOT invent a monotonic-sequence gate.”

## Harness

Isolated (all exit 0):

| Suite | Result |
|-------|--------|
| `lua tests/test_runtime.lua` | 734 passed, 0 failed |
| `lua tests/test_ceremony_chaos.lua` | 490 passed, 0 failed |
| `lua tests/test_net_v2.lua` | 865 passed, 0 failed |
| `lua tests/test_net_snapshot.lua` | 861 passed, 0 failed |

`lua tests/run.lua` → **16555 passed, 0 failed**, exit 0.

## Files

Edited (scoped):

- `addon/ChurchOfBeef/Core/Runtime.lua` — Option C gate
- `addon/ChurchOfBeef/Net/Snapshot.lua` — comment only (Apply already Restores)
- `addon/ChurchOfBeef/Net/BeefNet.lua` — comment only (`_HandleState` return is the overlay gate)
- `tests/test_runtime.lua` — latest-wins pins; equal-seq Restores that must apply now use a greater sequence
- `tests/test_ceremony_chaos.lua` — I-06 invert
- `tests/test_net_v2.lua` — Accept stub + favor spy (equal paints; older does not; greater applies ceremony + favor)
- `tests/test_net_snapshot.lua` — Apply latest-wins; named SNAPSHOT lands from QUIET so names stay off Restore

Collateral fixture (green harness; not UI production):

- `tests/test_hud.lua` / `tests/test_fighter_card.lua` — Task 8 stash Restore after `StartEvent` used equal sequence; bumped to **2** so fighters still land. `Hud.lua` / `FighterCard.lua` untouched.

Not edited: `ChurchOfBeef.lua`, `Net/Codec.lua`, `Core/DB.lua`, `Core/Gora.lua`, `UI/Hud.lua`, `UI/FighterCard.lua`, `UI/Console.lua`.

## Concerns

1. **Equal-seq after `StartEvent` is now a no-op.** Congregation catch-up from QUIET (different `eventId`) still applies. Tests that `StartEvent` then Restore/Apply the same id at sequence 1 must use a greater sequence or land from QUIET. Two Task 8 stash suites needed that fixture bump.
2. **Favor overlay is still bootstrap glue**, not a Hud call from Net. Isolated `test_net_v2` wraps `_HandleState` the same way as `if ok then paintInboundFavor`. SNAPSHOT equal-seq favor is the same `if ok` path; this slice pins STATE (the RecordFavor hole).
3. **awaitingPope / extras** only replace the event object when ceremony applies. Equal-seq Restore no longer clears `awaitingPope`; `test_runtime.lua` uses a greater sequence for those pins.
4. No inbound Proclaim / Sound. No clerical beat. No congregation Ensure. No schema 8.
5. Client / two-client smoke not run. Not POLISH:PASS. Not MVP.
