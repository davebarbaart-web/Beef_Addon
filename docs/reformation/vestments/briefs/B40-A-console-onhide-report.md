# B40-A — Console Hide remounts missing OnHide (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Wiki ESC via `UISpecialFrames` (named frame; do **not** PlaySound `IG_CHARACTER_INFO_*`); Law 6 / §19.4 (Quiet silent; no panel whoosh); Law 10 / Bible §19.3 (functional / stock Director Console; no parchment); Bible §18.1 leftover highlight; B29-A leftover (`Hide` remounted `rememberSpecial` then `frame:Hide()` only; ESC / `CloseSpecialWindows` bypass `Console:Hide` and there was no OnHide, so a wiped list stayed idle until Show / Init / Refresh / Hide); B39-A keep (do not refuse empty OpenRite Gora); brief `docs/reformation/vestments/briefs/B40-A-console-onhide.md`. `FRAME_NAME` stays `ChurchOfBeefConsoleFrame`. `SaveNote` stays nil. No SUMMON. No parchment. No tabs. No sound. Exclusive files only. No commit. Lane is not signed.

Extracted `wireConsoleOnHide` (never replace an existing script; no OnShow). Existing-frame `Hide`: remount missing OnHide, then `rememberSpecial(FRAME_NAME)`, then `self.frame:Hide()`. OnHide remounts `rememberSpecial` so ESC still re-lists. Create-path calls the helper after create-time `frame:Hide()`. Does not reset selection / pair / Recommend. Does not refuse empty OpenRite Gora. Does not rebuild.

**Isolated count:** 2930 passed, 0 failed (`lua tests/test_console.lua`). Isolation wrap stays under `if standalone then` at file load (**17** nil pins). Nested `runB40A()` inside `runB8E()` after `runB39A()`. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console.lua` | Nested `runB40A()` inside `runB8E()` after `runB39A()` (no new main-chunk locals). Source pin: Hide remounts via `wireConsoleOnHide` before `rememberSpecial(FRAME_NAME)` then `self.frame:Hide()`. Helper never replaces; no OnShow / `PlaySound` / `IG_CHARACTER_INFO_*` / rebuild / selection / pair / Recommend reset. Create-path wires after create-time Hide. Wipe list, nil OnHide, Show, Hide: OnHide restored, `ChurchOfBeefConsoleFrame` re-listed once, selection / pair / Recommend stay, no sound, no rebuild. Third Hide does not replace OnHide. Show / Init / Refresh remount do not remount OnHide. Empty OpenRite Gora still opens. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/Console.lua` | Extracted `wireConsoleOnHide` (never replace an existing script; no OnShow). Create-path calls it after create-time Hide. Existing-frame `Hide` remounts missing OnHide, then `rememberSpecial(FRAME_NAME)`, then `self.frame:Hide()`. OnHide remounts `rememberSpecial`. Does not reset selection / pair / Recommend. Does not refuse empty OpenRite Gora. Does not rebuild. Header notes the remount. No `PlaySound`. No parchment. `SaveNote` stays nil. No SUMMON. |
| `docs/reformation/vestments/briefs/B40-A-console-onhide-report.md` | This file |
| `docs/reformation/vestments/briefs/B40-A-console-onhide.diff` | B40-A-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit glue, Dock, MainFrame, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add sound. Did not add parchment. Did not define `SaveNote`. Did not refuse empty OpenRite Gora. Did not commit.

`git diff HEAD` on these two files also includes earlier Console batches (working tree already dirty). The brief diff is the B40-A-only delta.

## Contract

| Surface | Role |
|---------|------|
| `wireConsoleOnHide` | If `GetScript("OnHide")` is nil, wire: `rememberSpecial(FRAME_NAME)`. Do not replace an existing script. Do not wire OnShow. Do not reset selection / pair / Recommend. |
| `Hide` (frame exists) | `wireConsoleOnHide(self.frame)` then `rememberSpecial(FRAME_NAME)` then `self.frame:Hide()`. Same frame pointer. |
| `Hide` (no frame) | Unchanged. Still returns. |
| `buildFrame` | Unchanged except create-path calls `wireConsoleOnHide(frame)` after create-time `frame:Hide()`. |
| `Show` existing-frame | Unchanged. Still remounts `rememberSpecial` (B28-A). Does not remount OnHide. Does not re-wire OnShow. |
| `Refresh` existing-frame | Unchanged. Still remounts `rememberSpecial` (B28-A). Does not remount OnHide. |
| `Init` remount | Unchanged (B27-A). Existing-frame Init still remounts `rememberSpecial`. Does not remount OnHide. |
| Wipe remount | `UISpecialFrames = {}` then nil OnHide, Show, Hide lists `ChurchOfBeefConsoleFrame` exactly once. |
| Rebuild | Existing-frame Hide does not call `buildFrame` / `CreateFrame` / `Show`. |
| Selection / pair / Recommend | Hide / OnHide do not assign `selectedFighterA` / `B`, `selectedHumanId`, or `lastRecommendation`. |
| OpenRite Gora | Unchanged (B39-A). Empty pair still reaches Runtime. No `GetLastSanctioned` fallback. |
| Sound / dress | None. No `PlaySound`. No `IG_CHARACTER_INFO_*`. No parchment. `FRAME_NAME` stays `ChurchOfBeefConsoleFrame`. `SaveNote` stays nil. No SUMMON. |

### Unchanged

- Stock `BasicFrameTemplate`. Title stays `Director Console`.
- B29-A Hide `rememberSpecial` remount. B28-A Show / Refresh remount. B27-A Init remount. `rememberSpecial` scan-then-append. Missing table no-ops.
- B39-A OpenRite Gora live `GetSanctioned` fallback. Empty OpenRite Gora still opens.
- B26-A StartEvent / EndEvent pair-clear. B31-A QUIET leftover drop. Isolation wrap.
- No new main-chunk locals in `test_console.lua`.

## TDD

1. Extended `tests/test_console.lua` (`runB40A()` nested inside `runB8E()` after `runB39A()`: Hide remount body has `wireConsoleOnHide` then `rememberSpecial(FRAME_NAME)` then `self.frame:Hide()`; helper never replaces; no OnShow / rebuild / `PlaySound` / selection / pair / Recommend reset; wipe list, nil OnHide, Show, Hide restores OnHide and re-lists once; third Hide keeps identity; empty OpenRite Gora still opens). Isolation wrap and existing Init / Show / Refresh / Hide remount / B39-A pins stay.
2. Extracted `wireConsoleOnHide`. Existing-frame `Hide` remounts missing OnHide, then `rememberSpecial(FRAME_NAME)`, then `self.frame:Hide()`. Create-path calls the helper after create-time Hide. Show / Init / Refresh remount kept. Selection / pair / Recommend not reset.
3. Green: `lua tests/test_console.lua` — **2930 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console.lua   # 2930 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console.lua` standalone | **2930 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 2930 passed, 0 failed. Isolation wrap stays (17 nil pins at file load). Wrap pattern unchanged. `runB40A()` re-pins 4 of them.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Glue / Dock / MainFrame / TOC not edited.
- Existing-frame `Hide` remounts a missing OnHide, re-registers `ChurchOfBeefConsoleFrame`, and does not rebuild. An existing script is not replaced.
- Wipe-to-empty then Show + Hide lists the name exactly once. Same frame pointer. Third Hide keeps OnHide identity. Selection / pair / Recommend stay.
- B29-A Hide `rememberSpecial` remount stays. B28-A Show / Refresh remount stay. B27-A Init remount stays. Show / Init / Refresh do not remount OnHide.
- Empty OpenRite Gora still opens. `SaveNote` / SUMMON / parchment / no-sound stay. No OnShow re-wire.
- `runB40A()` is nested inside `runB8E()` after `runB39A()`. No new main-chunk locals.
- Isolation wrap stays.

## Leftovers

- **Widget Hide / ESC does not remount a niled OnHide.** The missing handler cannot remount itself. `CloseSpecialWindows` / `frame:Hide()` still bypass `Console:Hide`. A dropped OnHide that never hits `Console:Hide` still leaves a wiped list idle until Show / Init / Refresh / Hide.
- **Show / Init / Refresh remount still skip a niled OnHide.** Brief asked Hide-only remount and no OnShow re-wire. A niled handler that only hits Show / Init / Refresh stays idle until Hide.
- **No client smoke.** Real ESC vs `CloseSpecialWindows` on Anniversary is unproven. A live remount that dropped the name is simulated by `UISpecialFrames = {}`. A dropped handler is simulated by `SetScript("OnHide", nil)`.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Harness `Hide()` in this suite is a direct call**, not a real ESC key. Script identity, membership counts, and selection / pair / Recommend persist are pinned; the client's special-frame walk is not.

## Status

**DONE_WITH_CONCERNS.** Isolated **2930 / 0**. Isolation wrap **17**. Not signed. No Gate / **POLISH:PASS** claim. Gate W stays OPEN. Gate V stays OPEN.
