# V-INT — Proclaim glue (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** CONTINUE 2026-08-18 license 4 (V-B already shipped); Bible §10.8, §19.2–19.4, Law 4, Law 6; brief `docs/reformation/vestments/briefs/V-INT-proclaim.md`.

Bootstrap glue only. After a successful (non-nil) Gora verb, `InstallWire` calls `Toasts:Proclaim` when that function exists. Names come from `Store:GetCharacter(id).name`. Skip while `COB._inspecting`. Missing Toasts / Proclaim is a no-op. Exclusive files only. No commit. **Gate V is not closed. POLISH:PASS is not claimed.**

## Files written

| Path | What changed |
|------|----------------|
| `addon/ChurchOfBeef/ChurchOfBeef.lua` | Extended `InstallWire`. Gora Sanction / DeclareVictor / Void / FreeRuling / CowardiceRecorded wrap `Toasts:Proclaim` after success. |
| `tests/test_wire_glue.lua` | Proclaim spies. Sanction names both fighters; Cowardice is clerical `cowardice`; InspectProgress silent; `_inspecting` skip; refused verb silent; missing Toasts no-op. Victor / void / free pins. Unwraps restored. |
| `docs/REFORMATION_LOG.md` | V-INT verdict only. |
| `docs/reformation/vestments/briefs/V-INT-proclaim-report.md` | This file |

Did not edit Toasts.lua, Gora.lua, Console.lua, Store, Sound, the TOC, or `Data/Popes.lua`. Did not invent a Pope name. Did not `SendChatMessage`.

## Contract

| Verb | Kind | Fields |
|------|------|--------|
| `Gora:Sanction` | `sanction` | `fighterA` / `fighterB` from Store names; `stipulation` if the result has one |
| `Gora:DeclareVictor` | `verdict` | `ruling = "victor"`; `name` = winner |
| `Gora:Void` | `verdict` | `ruling = "void"` |
| `Gora:FreeRuling` | `verdict` | `ruling = "free"`; `text` from the result if present |
| `Gora:CowardiceRecorded` | `cowardice` | `name` = fleer |

`characterName(id)` reads `Store:GetCharacter(id).name` when Store exists. Missing Store, unknown id, or empty name → that field is omitted. No invented name strings.

`proclaim()` no-ops while `COB._inspecting`, when `Toasts.Proclaim` is missing, and is `pcall`'d so glue does not throw. Same `_inspecting` flag as the existing send skip.

Console `after()` may still `Sound:Play` the same cue Proclaim plays. Double cue accepted. Console and Sound were not edited.

## TDD

1. Extended `tests/test_wire_glue.lua` first (Proclaim spy + named paths).
2. Red: `lua tests/test_wire_glue.lua` — `Sanction Proclaims once` expected 1 got 0; suite then indexed a nil spy entry.
3. Implemented `characterName` / `proclaim` and the five Gora wraps in `InstallWire`.
4. Green: isolated 224/0; full harness 6920/0.

Pope predicate stays the existing Beefina stub and is restored. Gora wraps are unwrapped at suite end so a later harness file is not left wrapped.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_wire_glue.lua   # 224 passed, 0 failed
lua tests/run.lua              # 6920 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_wire_glue.lua` standalone | 224 passed, 0 failed. Exit 0. |
| `lua tests/run.lua` | 6920 passed, 0 failed. Exit 0. |

Conformance (glue): no `SendChatMessage`; no invented fighter or Pope names; Quiet inspect path does not Proclaim; missing Toasts does not break Sanction; refused verbs do not Proclaim.

## Self-review

- Exclusive files only. Toasts / Gora / Console stay unedited. UI → Core and Core → UI unchanged. Glue lives in bootstrap.
- Wraps attach only inside idempotent `InstallWire` (OnLogin). File load does not Proclaim.
- Fail-closed: inspecting, missing Toasts, `pcall` around Proclaim and GetCharacter.
- No Pope name written. `#8` list stays David's.

## Concerns

- Console Event-cue `after()` and `Toasts:Proclaim` may play the same §19.4 cue twice. The brief accepts that. Do not edit Console or Sound.
- `InspectProgress` still does not call Gora verbs. The `_inspecting` skip is pinned both on InspectProgress and on a live Sanction taken while the flag is set.
- Client `/reload` smoke was not run. The harness does not prove Anniversary theater.
- Do not claim Gate V closed. Do not claim POLISH:PASS. Do not claim V1 / MVP complete.

## Status

**DONE_WITH_CONCERNS.** Not signed. **Gate V stays OPEN.**
