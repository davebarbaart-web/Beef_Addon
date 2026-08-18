# B28-A — Console Show / Refresh remount ESC (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Wiki ESC via `UISpecialFrames` (named frame; do **not** PlaySound `IG_CHARACTER_INFO_*`); Law 6 / §19.4 (Quiet is silent; no panel whoosh); Law 10 / Bible §19.3 (functional / stock desk); Bible §18.1 Director Console; B27 leftover (`Refresh` / `Show` / `Toggle` skipped `rememberSpecial`; a wiped list then Show-only or Refresh-only never put `ChurchOfBeefConsoleFrame` back); brief `docs/reformation/vestments/briefs/B28-A-console-show.md`. B27-A Init remount stays. B14-D uniqueness stays. B26-A selected-pair lifetime stays. `SaveNote` stays nil. No SUMMON. Exclusive files only. No commit. Lane is not signed.

`Console:Show` and `Console:Refresh` now call `rememberSpecial(FRAME_NAME)` when the frame exists. They do not rebuild. Create-path uniqueness still dedupes (`rememberSpecial` scan-then-append from `buildFrame`). Init remount (B27-A) stays. First-create uniqueness pin stays.

**Isolated count:** 2026 passed, 0 failed (`lua tests/test_console.lua`). Isolation wrap stays under `if standalone then` at file load (**17** nil pins). Nested `runB28A()` inside `runB8E()` after `runB27A()`. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console.lua` | TDD first. Nested `runB28A()` inside `runB8E()` after `runB27A()` (Lua 5.1 200-local cap; no new main-chunk locals). Source pin: Show and Refresh bodies have `rememberSpecial(FRAME_NAME)` and no `buildFrame` / `CreateFrame` / `PlaySound`. Init remount source pin stays. Init, wipe `UISpecialFrames` to `{}`, Show-only: `ChurchOfBeefConsoleFrame` listed exactly once. Wipe again, Refresh-only: listed exactly once. Same frame pointer. Wrapped `CreateFrame` saw 0 calls on both remounts. B27-A Init remount / B14-D uniqueness / B26-A Start/End pair-clear source pins stay. SaveNote / SUMMON / parchment / tabs / no `IG_CHARACTER_INFO`. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/Console.lua` | Show and Refresh call `rememberSpecial(FRAME_NAME)` when the frame exists. They do not rebuild. Init remount stays. Header notes Init / Show / Refresh remount. No new file locals. No sound. |
| `docs/reformation/vestments/briefs/B28-A-console-show-report.md` | This file |
| `docs/reformation/vestments/briefs/B28-A-console-show.diff` | B28-A-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Dock, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add parchment, tabs, or SUMMON. Did not define `SaveNote`. Did not add `PlaySound`. Did not commit.

`git diff HEAD` on these two files also includes earlier Console batches (working tree already dirty). The brief diff is the B28-A-only delta.

## Contract

| Surface | Role |
|---------|------|
| `Show` (frame exists) | `rememberSpecial(FRAME_NAME)` then show and refresh. |
| `Refresh` (frame exists) | `rememberSpecial(FRAME_NAME)` then paint. |
| `Init` early-return | Unchanged. Still remounts (B27-A). |
| Create path | Unchanged. `buildFrame` still calls `rememberSpecial(FRAME_NAME)` once. |
| Wipe remount | `UISpecialFrames = {}` then Show-only lists `ChurchOfBeefConsoleFrame` exactly once. Wipe again, Refresh-only lists it once. |
| Frame identity | Show and Refresh keep the same frame. No rebuild. |
| Sound | None. Source has no `PlaySound` / `IG_CHARACTER_INFO`. |
| `SaveNote` | Stays nil. |

### Unchanged

- B27-A Init early-return remount.
- B14-D `rememberSpecial` scan-then-append. First-create uniqueness pin.
- B26-A successful Start / End nil the selected pair before `after()`.
- Stock desk. No parchment. No tabs. No SUMMON.
- Isolation wrap. No new main-chunk locals in `test_console.lua`.
- No new file locals in `Console.lua`.

## TDD

1. Extended `tests/test_console.lua` first (`runB28A()` nested in `runB8E()` after `runB27A()`: Show and Refresh source have `rememberSpecial(FRAME_NAME)`; Init remount source stays; Init, wipe `UISpecialFrames` to `{}`, Show-only lists the name once and keeps the same frame; wipe again, Refresh-only lists the name once and keeps the same frame; no rebuild; B27-A Init remount / B14-D uniqueness / B26-A pair-clear / SaveNote / SUMMON / parchment / tabs / isolation). Isolation wrap untouched except the new nested pin block.
2. Red: `lua tests/test_console.lua` — **2022 passed, 4 failed** (Show / Refresh source missing `rememberSpecial(FRAME_NAME)`; wiped list stayed 0 after Show-only / Refresh-only). Same-frame / no-rebuild / B27-A Init remount / B14-D uniqueness / B26-A / SaveNote / isolation stayed green.
3. Show and Refresh call `rememberSpecial(FRAME_NAME)` when the frame exists. Init remount kept. `buildFrame` kept.
4. Green: `lua tests/test_console.lua` — **2026 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console.lua   # 2026 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console.lua` standalone | **2026 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 2026 passed, 0 failed. Isolation wrap stays (17 nil pins at file load). Wrap pattern unchanged. `runB28A()` re-pins 4 of them plus `COB.Popes`.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Dock / glue / TOC not edited.
- Show and Refresh re-register `ChurchOfBeefConsoleFrame` and do not rebuild.
- Wipe-to-empty then Show-only lists the name exactly once. Wipe again, Refresh-only lists it once. Same frame pointer.
- B27-A Init remount stays. B14-D uniqueness stays. B26-A selected-pair lifetime stays. `SaveNote` nil. No SUMMON / parchment / tabs / `PlaySound`.
- `runB28A()` is nested inside `runB8E()` after `runB27A()`. No new main-chunk locals.
- Isolation wrap stays.

## Leftovers

- **No client smoke.** Real ESC vs focused EditBox vs `CloseSpecialWindows` on the named desk is unproven on Anniversary. A live remount that dropped the name is simulated by `UISpecialFrames = {}`.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Harness membership counts are pinned;** the client's special-frame walk is not. `Hide()` in this suite is a direct call, not a real ESC key.
- **`Toggle` on an existing frame still skips `rememberSpecial`.** This lane closed Show and Refresh. A wipe then Toggle-hide or Toggle-show that never hits Show / Refresh / Init does not put the name back. Toggle-show currently calls Show, so that path remounts; Toggle-hide does not.
- **`ResetForTests` does not nil `Console.frame`.** Init is idempotent; the wipe remount uses the existing pointer.

## Status

**DONE_WITH_CONCERNS.** Isolated **2026 / 0**. Isolation wrap **17**. Not signed. No Gate / **POLISH:PASS** claim. Gate W stays OPEN. Gate V stays OPEN.
