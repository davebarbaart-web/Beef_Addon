# B29-A — Console Hide remounts ESC (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Wiki ESC via `UISpecialFrames` (named frame; do **not** PlaySound `IG_CHARACTER_INFO_*`); Law 6 / §19.4 (Quiet is silent; no panel whoosh); Law 10 / Bible §19.3 (functional / stock desk); Bible §18.1 Director Console; B28 leftover (`Toggle` / `Hide` skipped `rememberSpecial`; a wiped list then Hide-only or Toggle-hide never put `ChurchOfBeefConsoleFrame` back); brief `docs/reformation/vestments/briefs/B29-A-console-hide.md`. B28-A Show / Refresh remount stays. B27-A Init remount stays. B14-D uniqueness stays. B26-A selected-pair lifetime stays. `SaveNote` stays nil. No SUMMON. Exclusive files only. No commit. Lane is not signed.

`Console:Hide` now calls `rememberSpecial(FRAME_NAME)` when the frame exists. It does not rebuild. Toggle-hide remounts because Toggle calls Hide. Create-path uniqueness still dedupes (`rememberSpecial` scan-then-append from `buildFrame`). Show / Refresh remount (B28-A) stays. Init remount (B27-A) stays. First-create uniqueness pin stays.

**Isolated count:** 2085 passed, 0 failed (`lua tests/test_console.lua`). Isolation wrap stays under `if standalone then` at file load (**17** nil pins). Nested `runB29A()` inside `runB8E()` after `runB28A()`. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console.lua` | TDD first. Nested `runB29A()` inside `runB8E()` after `runB28A()` (Lua 5.1 200-local cap; no new main-chunk locals). Source pin: Hide body has `rememberSpecial(FRAME_NAME)` and no `buildFrame` / `CreateFrame` / `PlaySound`. Show / Refresh remount source pins stay. Init remount source pin stays. Init, wipe `UISpecialFrames` to `{}`, Hide-only: `ChurchOfBeefConsoleFrame` listed exactly once. Wipe again, Toggle while shown: listed exactly once. Same frame pointer. Wrapped `CreateFrame` saw 0 calls on both remounts. B28-A Show/Refresh / B27-A Init remount / B14-D uniqueness / B26-A Start/End pair-clear source pins stay. SaveNote / SUMMON / parchment / tabs / no `IG_CHARACTER_INFO`. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/Console.lua` | Hide calls `rememberSpecial(FRAME_NAME)` when the frame exists. It does not rebuild. Show / Refresh / Init remount stay. Header notes Init / Show / Refresh / Hide remount. No new file locals. No sound. |
| `docs/reformation/vestments/briefs/B29-A-console-hide-report.md` | This file |
| `docs/reformation/vestments/briefs/B29-A-console-hide.diff` | B29-A-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Dock, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add parchment, tabs, or SUMMON. Did not define `SaveNote`. Did not add `PlaySound`. Did not commit.

`git diff HEAD` on these two files also includes earlier Console batches (working tree already dirty). The brief diff is the B29-A-only delta.

## Contract

| Surface | Role |
|---------|------|
| `Hide` (frame exists) | `rememberSpecial(FRAME_NAME)` then hide. |
| `Toggle` while shown | Calls Hide. Remounts via Hide. |
| `Show` / `Refresh` | Unchanged. Still remount (B28-A). |
| `Init` early-return | Unchanged. Still remounts (B27-A). |
| Create path | Unchanged. `buildFrame` still calls `rememberSpecial(FRAME_NAME)` once. |
| Wipe remount | `UISpecialFrames = {}` then Hide-only lists `ChurchOfBeefConsoleFrame` exactly once. Wipe again, Toggle-hide lists it once. |
| Frame identity | Hide and Toggle keep the same frame. No rebuild. |
| Sound | None. Source has no `PlaySound` / `IG_CHARACTER_INFO`. |
| `SaveNote` | Stays nil. |

### Unchanged

- B28-A Show / Refresh remount.
- B27-A Init early-return remount.
- B14-D `rememberSpecial` scan-then-append. First-create uniqueness pin.
- B26-A successful Start / End nil the selected pair before `after()`.
- Stock desk. No parchment. No tabs. No SUMMON.
- Isolation wrap. No new main-chunk locals in `test_console.lua`.
- No new file locals in `Console.lua`.

## TDD

1. Extended `tests/test_console.lua` first (`runB29A()` nested in `runB8E()` after `runB28A()`: Hide source has `rememberSpecial(FRAME_NAME)`; Show / Refresh remount source stays; Init remount source stays; Init, wipe `UISpecialFrames` to `{}`, Hide-only lists the name once and keeps the same frame; wipe again, Toggle while shown lists the name once and keeps the same frame; no rebuild; B28-A Show/Refresh / B27-A Init remount / B14-D uniqueness / B26-A pair-clear / SaveNote / SUMMON / parchment / tabs / isolation). Isolation wrap untouched except the new nested pin block.
2. Red: `lua tests/test_console.lua` — **2082 passed, 3 failed** (Hide source missing `rememberSpecial(FRAME_NAME)`; wiped list stayed 0 after Hide-only / Toggle-hide). Same-frame / no-rebuild / B28-A Show/Refresh / B27-A Init remount / B14-D uniqueness / B26-A / SaveNote / isolation stayed green.
3. Hide calls `rememberSpecial(FRAME_NAME)` when the frame exists. Show / Refresh / Init remount kept. `buildFrame` kept.
4. Green: `lua tests/test_console.lua` — **2085 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console.lua   # 2085 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console.lua` standalone | **2085 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 2085 passed, 0 failed. Isolation wrap stays (17 nil pins at file load). Wrap pattern unchanged. `runB29A()` re-pins 4 of them plus `COB.Popes`.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Dock / glue / TOC not edited.
- Hide re-registers `ChurchOfBeefConsoleFrame` and does not rebuild.
- Wipe-to-empty then Hide-only lists the name exactly once. Wipe again, Toggle-hide lists it once. Same frame pointer.
- B28-A Show / Refresh remount stays. B27-A Init remount stays. B14-D uniqueness stays. B26-A selected-pair lifetime stays. `SaveNote` nil. No SUMMON / parchment / tabs / `PlaySound`.
- `runB29A()` is nested inside `runB8E()` after `runB28A()`. No new main-chunk locals.
- Isolation wrap stays.

## Leftovers

- **No client smoke.** Real ESC vs focused EditBox vs `CloseSpecialWindows` on the named desk is unproven on Anniversary. A live remount that dropped the name is simulated by `UISpecialFrames = {}`.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Harness membership counts are pinned;** the client's special-frame walk is not. `Hide()` / `Toggle()` in this suite are direct calls, not a real ESC key. ESC still walks names and calls `Frame:Hide`, not `Console:Hide`.
- **`ResetForTests` does not nil `Console.frame`.** Init is idempotent; the wipe remount uses the existing pointer.

## Status

**DONE_WITH_CONCERNS.** Isolated **2085 / 0**. Isolation wrap **17**. Not signed. No Gate / **POLISH:PASS** claim. Gate W stays OPEN. Gate V stays OPEN.
