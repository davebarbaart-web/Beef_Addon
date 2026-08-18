# B5-E — Congregation snapshot catch-up control (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §20.3; brief `docs/reformation/vestments/briefs/B5-E-catchup.md`.

Event-only congregation catch-up. `Inputs:Catchup()` calls `Net:RequestSnapshot(inputTarget)` on the injected whisper target (same as Petition). Quiet refuse. Missing target → `false, "no target"`. No Pope lookup. Stock `Catch up` button. Exclusive files only. No commit. Lane is not signed. **POLISH:CANDIDATE** at most.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_inputs.lua` | Stub `Net.RequestSnapshot`. Quiet refuse. StartEvent + target → Catchup spies the target. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/Inputs.lua` | `Inputs:Catchup()`. Event only. Injected target only. Stock `Catch up` button. |
| `docs/reformation/vestments/briefs/B5-E-catchup-report.md` | This file |
| `docs/reformation/vestments/briefs/B5-E-catchup.diff` | B5-E-only unified diff of the exclusive implementation files |

Did not edit TOC, `run.lua`, BeefNet, `ChurchOfBeef.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not invent a Pope name. Did not commit.

## Contract

```lua
Inputs:Catchup()    -- Net:RequestSnapshot(inputTarget)
```

Mode Event. Runtime QUIET or missing → `false`; frame hidden. No Quiet chrome.

| Refuse | Return |
|--------|--------|
| Quiet / missing Runtime | `false` |
| Missing / empty target | `false, "no target"` |
| Missing Net send | `false, "no net"` |

Calls `Net:RequestSnapshot(inputTarget)` only. Does not look up `Data/Popes.lua`. Does not require a local character id. Does not Proclaim. Does not PlaySound. Does not call Gora.

Stock chrome: `UIPanelButtonTemplate` label `Catch up`, centered between Petition and Confess. No jokes.

## TDD

1. Extended `tests/test_inputs.lua` first (API, source grep, Quiet refuse, missing / empty target, StartEvent + target spy, button wire, missing Runtime / Net, Gora / Proclaim spies stay zero). Isolation wrap unchanged.
2. Implemented `Inputs:Catchup()` and the stock button.
3. Green: `lua tests/test_inputs.lua` — **241 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_inputs.lua   # 241 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_inputs.lua` standalone | **241 passed, 0 failed.** Lua 5.1. Exit 0. |

Isolation asserts: **24** under `if standalone then` (23 nil-module + slash). Shared-body remainder if listed in `run.lua`: **217**.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Quiet Catchup is false. Frame stays hidden in Quiet.
- Source has no `PlaySound`, `SendChatMessage`, `Proclaim`, `Gora:Petition`, `Popes.lua`, `COB.Popes`, `Media\\`, or joke copy.
- `SetInputTarget` remains the whisper destination. No Pope lookup.
- Catchup spies `RequestSnapshot` with the stored target only.
- Injected `Gora.Petition` / `Toasts.Proclaim` spies stay at zero.
- Isolation asserts stay under `if standalone then`.

## Isolated count

**241 passed, 0 failed.** Isolation wrap: **24**.

## Concerns

- **No client smoke.** TOC already lists `UI/Inputs.lua`; `run.lua` already lists `test_inputs`. This lane did not edit either. Whisper target still comes from the injected bind — this lane does not invent a Pope name.
- **`no net` is extra.** The brief names only Quiet refuse and `"no target"`. Missing `RequestSnapshot` is fail-closed as `false, "no net"` so a stub-less desktop call does not throw.
- **No character id.** Catchup does not require `SetLocalCharacterId`. `RequestSnapshot` takes the injected target only.
- **Frame widened 280 → 328** so three stock 96px buttons fit. Brief named the label, not the layout. Catch up is centered between Petition and Confess.
- **Quiet Catchup returns `false` with no named reason.** Only target / net misses are named.
- Stock tooltip-background strip. Functional, not theatrical. **POLISH:CANDIDATE** only.

## Status

**DONE_WITH_CONCERNS.** Isolated **241 / 0**. Isolation wrap **24**. Not signed. **POLISH:CANDIDATE.**
