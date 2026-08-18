# B4-G — Event congregation petition / confess (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §13.1, §18.5, §19.1, Law 6, Law 10; brief `docs/reformation/vestments/briefs/B4-G-congregation-inputs.md`.

Event-only congregation input surface. `MODE` Event. Quiet refuse. No Pope-name lookup. Petition and Confess call Net only. Stock `UIPanelButtonTemplate` labels `Petition` / `Confess`. Optional stock `InputBoxTemplate`. Exclusive files only. No commit. Lane is not signed. **POLISH:CANDIDATE** at most.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_inputs.lua` | Isolated suite first. wow_ui_stub + Common + Runtime + Inputs. Stub `COB.Net.SendPetition` / `SendConfession`. Quiet refuse. StartEvent + target + id → Petition spies Net. Confess spies text. GetView copy. Isolation under `if standalone then`. |
| `addon/ChurchOfBeef/UI/Inputs.lua` | `COB.Inputs`. Init / SetInputTarget / SetLocalCharacterId / Petition / Confess / Show / Hide / Refresh / GetView / ResetForTests. Stock functional chrome. |
| `docs/reformation/vestments/briefs/B4-G-congregation-inputs-report.md` | This file |
| `docs/reformation/vestments/briefs/B4-G-congregation-inputs.diff` | B4-G-only unified diff of the exclusive implementation files |

Did not edit TOC, `run.lua`, `ChurchOfBeef.lua`, BeefNet, Console, Hud, OPEN_QUESTIONS, or REFORMATION_LOG. Did not commit.

## Contract

```lua
Inputs:Init()
Inputs:SetInputTarget(name)          -- whisper destination; no Pope lookup
Inputs:SetLocalCharacterId(id)
Inputs:Petition()                    -- Net:SendPetition({ characterId }, target)
Inputs:Confess(text)                 -- Net:SendConfession({ characterId, text }, target)
Inputs:Show() / Hide() / Refresh()
Inputs:GetView()                     -- copy
Inputs:ResetForTests()
```

Mode Event. Runtime QUIET or missing → Show / Petition / Confess return false; frame hidden. No Quiet chrome.

| Refuse | Return |
|--------|--------|
| Missing / empty target | `false, "no target"` |
| Missing local character id | `false, "no character"` |
| Missing Net send | `false, "no net"` |

Call Net only. Do not call `Gora:Petition` locally. Do not Proclaim. Do not PlaySound. Do not SendChatMessage. Do not look up `Data/Popes.lua`.

Stock chrome: `UIPanelButtonTemplate` `Petition` / `Confess`. Optional `InputBoxTemplate`. `Confess(text)` wins over the box; `Confess()` with no arg reads the box. No jokes.

## TDD

1. Wrote `tests/test_inputs.lua` first (API, isolation, source grep, Quiet refuse, missing target/character, StartEvent Net spies, Confess text, GetView copy, Hide / EndEvent, ResetForTests, missing CreateFrame).
2. Implemented `Inputs.lua`.
3. Green: `lua tests/test_inputs.lua` — **209 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_inputs.lua   # 209 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_inputs.lua` standalone | 209 passed, 0 failed. Lua 5.1. Exit 0. |

Isolation asserts: **24** under `if standalone then` (23 nil-module + slash). Shared-body remainder if later listed in `run.lua`: **185**.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Quiet Show / Petition / Confess are false. Frame stays hidden in Quiet.
- Source has no `PlaySound`, `SendChatMessage`, `Proclaim`, `Gora:Petition`, `Popes.lua`, `COB.Popes`, `Media\\`, or joke copy.
- `SetInputTarget` stores the given non-empty string. No Pope lookup.
- Petition / Confess spy Net with `{ characterId }` / `{ characterId, text }` and the stored target.
- Injected `Gora.Petition` / `Toasts.Proclaim` spies stay at zero.
- `GetView` is a copy. Isolation asserts stay under `if standalone then`.

## Concerns

- **No client smoke.** Integrator still lists `UI/Inputs.lua` in the TOC and `test_inputs` in `run.lua`, and still wires `SetInputTarget` from the last accepted STATE sender. This lane does not invent a Pope name.
- **`no net` is extra.** The brief names only `"no target"` / `"no character"`. Missing `SendPetition` / `SendConfession` is fail-closed as `false, "no net"` so a stub-less desktop call does not throw.
- **EditBox is included** (brief: optional). Button Confess reads the box; an explicit `Confess(text)` wins.
- **Quiet verbs return `false` with no named reason.** Only target / character / net misses are named.
- Stock tooltip-background strip. Functional, not theatrical. **POLISH:CANDIDATE** only.

## Status

**DONE_WITH_CONCERNS.** Not signed. **POLISH:CANDIDATE.**
