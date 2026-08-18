# W-INT — bootstrap SendState / Decree glue (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** CONTINUE 2026-08-18 licenses 1–2; Bible §13.1, §10.6, §14.1; wrap plan `docs/reformation/wire/briefs/W-INT-bootstrap.md`.

Bootstrap glue only. UI and Core stay Net-free. Wraps attach in `COB:InstallWire()` from `OnLogin` (idempotent, not at file load). Fail-closed: missing Net / unlisted Pope already refuse; sends are `pcall`'d. Exclusive files only. No commit. **Gate W is not closed.** Vestments stay closed.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_wire_glue.lua` | TDD first. Isolated load (no `Data/Popes.lua`). Unstubbed StartEvent silent; stubbed Beefina StartEvent/EndEvent STATE; PostDecree DECREE; InspectProgress silent; favor on/off; inbound STATE paints HUD; petition stays unknown; Restore sets local id. Pope stub restored. Isolation under `if standalone then`. |
| `addon/ChurchOfBeef/ChurchOfBeef.lua` | `InstallWire`. Runtime / RecordFavor / congregation toggle → `SendState`. `PostDecree` → `SendDecree`. Inbound STATE / SNAPSHOT-response → HUD. `_inspecting` around `InspectProgress`. Local character id on login / Store Restore. |
| `tests/run.lua` | Listed `test_wire_glue` only. |
| `docs/phases/two-client-smoke.md` | Honesty table: STATE sent on Runtime transitions; DECREE live; INPUT favor whisper-to-Pope; petition/confession unknown. Walk boxes untouched. |
| `docs/REFORMATION_LOG.md` | W-INT verdict. Gate W stays OPEN. |
| `docs/reformation/wire/briefs/W-INT-report.md` | This file |
| `docs/reformation/wire/briefs/W-INT.diff` | Integrator diff |

Did not edit Codec, Gora, Store, BeefNet, Console, Hud, Sender, Runtime, Decree Core, `Data/Popes.lua`, or the TOC. Did not invent a Pope name.

## Contract

| Wrap | After success |
|------|----------------|
| Runtime `StartEvent` / `OpenRite` / `CloseRite` / `Continue` / `EndEvent` | `Net:SendState(stateFields())` |
| `Gora:RecordFavor` | `SendState` (live split) |
| `Console:SetCongregationFavorVisible` | `SendState` |
| `Console:PostDecree` | `Net:SendDecree({ line = result.line, flavor = result.flavor })` — not `Decree.Set` |
| `Net._HandleState` | On accept: `Hud:SetFavorTarget(sender)`, `Hud:SetBroadcastFavor(decoded.favor or nil)`, `Hud:Refresh` |
| `Net._HandleSnapshot` | On accepted **response**: same HUD paint; favor from `decoded` or a decode of `payload` |
| `Store:Restore` + end of `InstallWire` | `Hud:SetLocalCharacterId` for the Store character whose `Names.Key(name)` matches `UnitName("player")` |

`stateFields()`: Runtime bible fields (`eventId`, `state`, `riteType`, `subjects`, `sequence`). Optional `favor = Gora:GetFavorSplit()` only when `Console:GetCongregationFavorVisible()` is true **and** `Gora:GetSanctioned()` is a live pair. Else omit favor.

`COB._inspecting` is true around the existing `InspectProgress` body. Every send no-ops while it is set. `Decree:Set` inside inspect still does not broadcast (wrap is PostDecree only).

## TDD

1. Wrote `tests/test_wire_glue.lua` and listed it in `tests/run.lua`.
2. Red: `lua tests/test_wire_glue.lua` — `InstallWire` nil; aborted.
3. Implemented `ChurchOfBeef.lua`.
4. Green: isolated 133/0; full harness 6677/0.

Pope predicate is stubbed name-aware (`Names.Key(sender) == "beefina"`) and restored. Empty `Data/Popes.lua` still fail-closed. Suite unwraps at the end so later harness suites are not polluted.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_wire_glue.lua   # 133 passed, 0 failed
lua tests/run.lua              # 6677 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_wire_glue.lua` standalone | 133 passed, 0 failed. Exit 0. |
| `lua tests/run.lua` | 6677 passed, 0 failed. Exit 0. |

Conformance (glue): no favor persist to SV; no favor history/streak/economy; favor omitted when the congregation toggle is off; no narration; Quiet inspect path stays silent on the wire.

## Self-review

- Exclusive files only. UI → Core and Net → Core unchanged. Glue lives in bootstrap.
- Sends are skipped while inspecting, when Net is missing, and when `_LocalPope()` refuses.
- `InstallWire` is OnLogin-only and idempotent (`_wireInstalled`). Minimap dofile of bootstrap does not wrap.
- No Pope name written. `#8` list stays David's.
- Two-client walk boxes were not ticked. Gate W is not claimed closed.

## Concerns

- Codec refuses a STATE `favor` unless `subjects.fighters` has two ids. Sanction is legal in ASSEMBLY before `OpenRite`, so outbound `stateFields()` copies the sanctioned pair onto the **wire snapshot only** when favor is included and Runtime subjects lack two fighters. Runtime is not mutated.
- Client `/reload` and the two-client smoke were not run. The harness does not prove Anniversary broadcast.
- Snapshot-response HUD paint is implemented but not separately asserted (STATE inbound is).
- Do not claim V1 / MVP complete. Do not open Vestments.

## Status

**DONE_WITH_CONCERNS.** Not signed. **Gate W stays OPEN.**
