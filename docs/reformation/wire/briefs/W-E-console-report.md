# W-E — Console: favor pane + congregation toggle + free-ruling text (report)

**Status:** DONE

**Cited:** CONTINUE 2026-08-18 licenses 1–3; Bible §10.6, §14.1, §18.1–18.3, §19.3 / Law 10; brief `docs/reformation/wire/briefs/W-E-console.md`.

Director Console stays stock-pragmatic. Favor pane is Pope-desk readout, not congregation theater. Congregation display is a per-event memory toggle (default on). Post Decree stays `Decree:Set`; this file does not call `COB.Net`. FREE RULING reads an optional stock edit box and does not pick a winner. Exclusive files only. No commit. Lane is not signed.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console.lua` | TDD first. Removed leftover “no favor chrome”. Favor pane, congregation toggle, PostDecree-does-not-Net, FREE RULING box. Isolation stays under `if standalone then`. |
| `addon/ChurchOfBeef/UI/Console.lua` | `GetFavorSplit` / `GetFavorCount`. Memory toggle + `UICheckButtonTemplate` fallback. Gora-desk FAVOR paint. `FreeRulingText`. Header: Post Decree is Core Set; integrator broadcasts. |
| `docs/reformation/wire/briefs/W-E-console-report.md` | This file |
| `docs/reformation/wire/briefs/W-E-console.diff` | `git diff -- addon/ChurchOfBeef/UI/Console.lua tests/test_console.lua` |

Did not edit Gora, Store, Codec, BeefNet, HUD, TOC, bootstrap, Sender, Runtime, Decree Core, `tests/run.lua`, OPEN_QUESTIONS, REFORMATION_LOG, or `Data/Popes.lua`.

## Contract

| Method | Role |
|--------|------|
| `GetFavorSplit()` | Copy `{ a = n, b = n }` from `Gora:GetFavorSplit()`, or zeros. Mutating the copy does not change Gora. |
| `GetFavorCount()` | Standing pick count (`pairs` size of `Gora:GetFavor()`), or 0. |
| `GetCongregationFavorVisible()` | In-memory boolean. Default **true**. |
| `SetCongregationFavorVisible(flag)` | `true`/`false` only. Non-boolean → `nil, "flag must be a boolean"`. Does not write SavedVariables. Not Net. |
| `FreeRuling(text?)` | If `text` is omitted, reads `frame.FreeRulingText`. Does not pass `selectedCharacterId`. Trim stays Gora’s. |
| `PostDecree` | `Decree:Set` + local banner. No `SendDecree` / `SendState`. |

### Congregation toggle

- Memory only. `ResetForTests` returns it to true.
- Per-event: `Refresh` compares `Runtime:Snapshot().eventId` (including QUIET `nil`) and resets to true when it changes.
- Runtime `EndEvent` keeps the ended event id (existing Runtime contract). Off-state survives that QUIET until the next `StartEvent` assigns a new id.
- Stock `CheckButton` + `UICheckButtonTemplate`; `pcall` fallback with no template. Label: `Congregation sees favor`.
- `applyGate` disables the checkbox when `IsRegisteredPope` is false. Click then no-ops and restores the checked state. Getter still returns the in-memory flag.

### Favor pane

Clerical `FAVOR` + `a / b` + standing count. Refresh paints. No `Console.Favor` economy table. No custom media. No jokes.

## TDD

1. Extended `test_console.lua` first (APIs, chrome, copy safety, toggle + event reset, PostDecree Net counters, box vs explicit vs empty FREE RULING). Isolation stayed under `if standalone then`.
2. Red: `lua tests/test_console.lua` — **348 passed, 47 failed**. Missing `GetFavorSplit` / toggle / `FreeRulingText` / `FAVOR` paint. Existing Pope-gate, PostDecree Set, and no-Sound asserts stayed green.
3. Implemented `Console.lua`.
4. Green: **393 passed, 0 failed**.

Pope predicate uses the suite’s existing `Sender.IsRegisteredPope = function() return true end` wrap. No Pope name. No `Data/Popes.lua`.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console.lua   # 393 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console.lua` standalone | 393 passed, 0 failed. Lua 5.1.5. Exit 0. |

Full harness not required by the brief; not run. Do not treat a later harness red on a parallel lane as a W-E miss.

## Self-review

- Exclusive files only. UI → Core only. `after()` still Refresh / cue / HUD — no Net.
- Getters return copies. Expected failures are `nil, err`.
- Toggle never writes `ChurchOfBeefDB` (position persist is unchanged).
- FREE RULING has no winner picker and does not forward `selectedCharacterId`.
- `Console.Favor` remains nil. No `OnUpdate`. No `UIParent:SetScale`.
- Isolation asserts remain behind `if standalone then`.

## Concerns

- Client `/reload` smoke was not run. Harness does not prove Anniversary layout of the taller Gora desk.
- Petition scroller is 70px (was 92) so FAVOR, the toggle, and the free-ruling box stay on the same desk.
- Integrator still must read `GetCongregationFavorVisible()` when building `SendState`. This lane does not call Net.
- Do not claim V1 / MVP complete. Do not claim this lane signed.

## Status

**DONE.** Not signed.
