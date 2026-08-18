# B27-A — Console Init early-return remounts ESC (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Wiki ESC via `UISpecialFrames` (named frame; do **not** PlaySound `IG_CHARACTER_INFO_*`); Law 6 / §19.4 (Quiet is silent; no panel whoosh); Law 10 / Bible §19.3 (functional / stock desk); Bible §18.1 Director Console; B14-D leftover (`rememberSpecial` lived only in `buildFrame`; a wiped list then second Init never put `ChurchOfBeefConsoleFrame` back); brief `docs/reformation/vestments/briefs/B27-A-console-special.md`. B14-D uniqueness stays. B26-A selected-pair lifetime stays. `SaveNote` stays nil. No SUMMON. Exclusive files only. No commit. Lane is not signed.

`Console:Init` early-return (`if self.frame then`) now calls `rememberSpecial(FRAME_NAME)` then returns the frame. It does not rebuild. Create-path uniqueness still dedupes (`rememberSpecial` scan-then-append from `buildFrame`). First-create uniqueness pin stays.

**Isolated count:** 1970 passed, 0 failed (`lua tests/test_console.lua`). Isolation wrap stays under `if standalone then` at file load (**17** nil pins). Nested `runB27A()` inside `runB8E()` after `runB26A()`. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console.lua` | TDD first. Nested `runB27A()` inside `runB8E()` after `runB26A()` (Lua 5.1 200-local cap; no new main-chunk locals). Source pin: early-return body has `rememberSpecial(FRAME_NAME)` and no `buildFrame` / `CreateFrame` / `PlaySound`. Init, wipe `UISpecialFrames` to `{}`, second Init: `ChurchOfBeefConsoleFrame` listed exactly once. Same frame pointer. Third Init still once. Wrapped `CreateFrame` saw 0 calls on remount. B14-D uniqueness / B26-A Start/End pair-clear source pins stay. SaveNote / SUMMON / parchment / tabs / no `IG_CHARACTER_INFO`. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/Console.lua` | Early-return calls `rememberSpecial(FRAME_NAME)` then returns the frame. Does not rebuild. `buildFrame` still registers once. Header notes the remount. No new file locals. No sound. |
| `docs/reformation/vestments/briefs/B27-A-console-special-report.md` | This file |
| `docs/reformation/vestments/briefs/B27-A-console-special.diff` | B27-A-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Dock, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add parchment, tabs, or SUMMON. Did not define `SaveNote`. Did not add `PlaySound`. Did not commit.

`git diff HEAD` on these two files also includes earlier Console batches (working tree already dirty). The brief diff is the B27-A-only delta.

## Contract

| Surface | Role |
|---------|------|
| `Init` early-return | `rememberSpecial(FRAME_NAME)` then return the existing frame. |
| Create path | Unchanged. `buildFrame` still calls `rememberSpecial(FRAME_NAME)` once. |
| Wipe remount | `UISpecialFrames = {}` then second Init lists `ChurchOfBeefConsoleFrame` exactly once. |
| Frame identity | Second Init returns the same frame. No rebuild. |
| Sound | None. Source has no `PlaySound` / `IG_CHARACTER_INFO`. |
| `SaveNote` | Stays nil. |

### Unchanged

- B14-D `rememberSpecial` scan-then-append. First-create uniqueness pin.
- B26-A successful Start / End nil the selected pair before `after()`.
- Stock desk. No parchment. No tabs. No SUMMON.
- Isolation wrap. No new main-chunk locals in `test_console.lua`.
- No new file locals in `Console.lua`.

## TDD

1. Extended `tests/test_console.lua` first (`runB27A()` nested in `runB8E()` after `runB26A()`: early-return source has `rememberSpecial(FRAME_NAME)`; Init, wipe `UISpecialFrames` to `{}`, second Init lists the name once and returns the same frame; third Init still once; no rebuild; B14-D uniqueness / B26-A pair-clear / SaveNote / SUMMON / parchment / tabs / isolation). Isolation wrap untouched except the new nested pin block.
2. Red: `lua tests/test_console.lua` — **1967 passed, 3 failed** (early-return source missing `rememberSpecial(FRAME_NAME)`; wiped list stayed 0 after second / third Init). Same-frame / no-rebuild / B14-D uniqueness / B26-A / SaveNote / isolation stayed green.
3. Early-return calls `rememberSpecial(FRAME_NAME)` then returns the frame. `buildFrame` kept.
4. Green: `lua tests/test_console.lua` — **1970 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console.lua   # 1970 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console.lua` standalone | **1970 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 1970 passed, 0 failed. Isolation wrap stays (17 nil pins at file load). Wrap pattern unchanged. `runB27A()` re-pins 4 of them plus `COB.Popes`.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Dock / glue / TOC not edited.
- Early-return re-registers `ChurchOfBeefConsoleFrame` and does not rebuild.
- Wipe-to-empty then second Init lists the name exactly once. Third Init still once. Same frame pointer.
- B14-D uniqueness stays. B26-A selected-pair lifetime stays. `SaveNote` nil. No SUMMON / parchment / tabs / `PlaySound`.
- `runB27A()` is nested inside `runB8E()` after `runB26A()`. No new main-chunk locals.
- Isolation wrap stays.

## Leftovers

- **No client smoke.** Real ESC vs focused EditBox vs `CloseSpecialWindows` on the named desk is unproven on Anniversary. A live remount that dropped the name is simulated by `UISpecialFrames = {}`.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Harness membership counts are pinned;** the client's special-frame walk is not. `Hide()` in this suite is a direct call, not a real ESC key.
- **`Refresh` / `Show` / `Toggle` on an existing frame still skip `rememberSpecial`.** This lane closed Init. A wipe then Refresh-only or Show-only does not put the name back until Init.
- **`ResetForTests` does not nil `Console.frame`.** Init is idempotent; the wipe remount uses the existing pointer.

## Status

**DONE_WITH_CONCERNS.** Isolated **1970 / 0**. Isolation wrap **17**. Not signed. No Gate / **POLISH:PASS** claim. Gate W stays OPEN. Gate V stays OPEN.
