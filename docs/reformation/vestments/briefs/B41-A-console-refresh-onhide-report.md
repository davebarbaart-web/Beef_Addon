# B41-A — Console Refresh remounts missing OnHide (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Wiki ESC via `UISpecialFrames` (named frame; do **not** PlaySound `IG_CHARACTER_INFO_*`); Law 6 / §19.4 (Quiet silent; no panel whoosh); Law 10 / Bible §19.3 (functional / stock Director Console; no parchment); Bible §18.1 leftover highlight; B40-A leftover (Refresh remounted `rememberSpecial` only and pinned no `wireConsoleOnHide`, so glue `Runtime:EndEvent` Refresh left a niled OnHide idle until Hide); B31-A keep (QUIET Refresh still nils Recommend; does not reset selection / pair); B39-A keep (do not refuse empty OpenRite Gora); brief `docs/reformation/vestments/briefs/B41-A-console-refresh-onhide.md`. `FRAME_NAME` stays `ChurchOfBeefConsoleFrame`. `SaveNote` stays nil. No SUMMON. No parchment. No tabs. No sound. Exclusive files only. No commit. Lane is not signed.

Existing-frame `Refresh`: remount missing OnHide (`wireConsoleOnHide`), then `rememberSpecial(FRAME_NAME)`. Never replace an existing script. Does not reset selection / pair. QUIET Refresh still nils Recommend (B31-A keep). Does not refuse empty OpenRite Gora. Show stays without a direct `wireConsoleOnHide` call (Show already Refreshs). B40-A Refresh keep-string updated in this exclusive test file. Does not rebuild.

**Isolated count:** 3045 passed, 0 failed (`lua tests/test_console.lua`). Isolation wrap stays under `if standalone then` at file load (**17** nil pins). Nested `runB41A()` inside `runB8E()` after `runB40A()`. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console.lua` | Nested `runB41A()` inside `runB8E()` after `runB40A()` (no new main-chunk locals). B40-A keep-string updated: Refresh remounts via `wireConsoleOnHide` before `rememberSpecial(FRAME_NAME)`. Show source pin stays without a direct call; Show runtime remounts via Refresh, then OnHide is re-niled so Hide remount still runs. Wipe list, nil OnHide, Refresh: OnHide restored, `ChurchOfBeefConsoleFrame` re-listed once, selection / pair stay, live Recommend stays, no sound, no rebuild. Third Refresh does not replace OnHide. QUIET Refresh still nils Recommend. Empty OpenRite Gora still opens. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/Console.lua` | Existing-frame `Refresh` remounts missing OnHide (`wireConsoleOnHide(self.frame)`), then `rememberSpecial(FRAME_NAME)`. Never replace. Does not reset selection / pair. QUIET Refresh still nils Recommend. Does not refuse empty OpenRite Gora. Header notes the remount. No `PlaySound`. No parchment. `SaveNote` stays nil. No SUMMON. |
| `docs/reformation/vestments/briefs/B41-A-console-refresh-onhide-report.md` | This file |
| `docs/reformation/vestments/briefs/B41-A-console-refresh-onhide.diff` | B41-A-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit glue, Dock, MainFrame, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add sound. Did not add parchment. Did not define `SaveNote`. Did not refuse empty OpenRite Gora. Did not commit.

`git diff HEAD` on these two files also includes earlier Console batches (working tree already dirty). The brief diff is the B41-A-only delta.

## Contract

| Surface | Role |
|---------|------|
| `wireConsoleOnHide` | Unchanged. If `GetScript("OnHide")` is nil, wire: `rememberSpecial(FRAME_NAME)`. Do not replace an existing script. Do not wire OnShow. Do not reset selection / pair / Recommend. |
| `Refresh` (frame exists) | `wireConsoleOnHide(self.frame)` then `rememberSpecial(FRAME_NAME)`, then paint. Same frame pointer. QUIET / nil Runtime still nils `lastRecommendation` before `paintRecommendation`. |
| `Refresh` (no frame) | Unchanged. Still returns. |
| `Show` existing-frame | Unchanged body. Still remounts `rememberSpecial` (B28-A). No direct `wireConsoleOnHide`. Show already Refreshs, so a missing OnHide is remounted on Show. |
| `Hide` existing-frame | Unchanged (B40-A). Still remounts missing OnHide, then `rememberSpecial(FRAME_NAME)`, then `self.frame:Hide()`. |
| `Init` remount | Unchanged (B27-A). Existing-frame Init still remounts `rememberSpecial`. Does not remount OnHide. |
| Wipe remount | `UISpecialFrames = {}` then nil OnHide, Refresh lists `ChurchOfBeefConsoleFrame` exactly once. |
| Rebuild | Existing-frame Refresh does not call `buildFrame` / `CreateFrame`. |
| Selection / pair / Recommend | Refresh / OnHide do not assign `selectedFighterA` / `B` or `selectedHumanId`. Live-event Refresh does not drop painted Recommend. QUIET Refresh still nils Recommend (B31-A). |
| OpenRite Gora | Unchanged (B39-A). Empty pair still reaches Runtime. No `GetLastSanctioned` fallback. |
| Sound / dress | None. No `PlaySound`. No `IG_CHARACTER_INFO_*`. No parchment. `FRAME_NAME` stays `ChurchOfBeefConsoleFrame`. `SaveNote` stays nil. No SUMMON. |

### Unchanged

- Stock `BasicFrameTemplate`. Title stays `Director Console`.
- B40-A Hide remount. B29-A Hide `rememberSpecial` remount. B28-A Show / Refresh remount. B27-A Init remount. `rememberSpecial` scan-then-append. Missing table no-ops.
- B39-A OpenRite Gora live `GetSanctioned` fallback. Empty OpenRite Gora still opens.
- B26-A StartEvent / EndEvent pair-clear. B31-A QUIET leftover drop. Isolation wrap.
- No new main-chunk locals in `test_console.lua`.

## TDD

1. Extended `tests/test_console.lua` (`runB41A()` nested inside `runB8E()` after `runB40A()`: Refresh remount body has `wireConsoleOnHide` then `rememberSpecial(FRAME_NAME)`; helper never replaces; no OnShow / rebuild / `PlaySound` / selection / pair reset; B31-A QUIET Recommend drop stays; wipe list, nil OnHide, Refresh restores OnHide and re-lists once; third Refresh keeps identity; empty OpenRite Gora still opens). Updated the B40-A Refresh keep-string. Isolation wrap and existing Hide / Show / Init remount / B39-A pins stay.
2. Existing-frame `Refresh` remounts missing OnHide, then `rememberSpecial(FRAME_NAME)`. Hide / Init remount kept. Show kept without a direct call. Selection / pair not reset. QUIET Recommend drop kept.
3. Green: `lua tests/test_console.lua` — **3045 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console.lua   # 3045 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console.lua` standalone | **3045 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 3045 passed, 0 failed. Isolation wrap stays (17 nil pins at file load). Wrap pattern unchanged. `runB41A()` re-pins 4 of them.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Glue / Dock / MainFrame / TOC not edited.
- Existing-frame `Refresh` remounts a missing OnHide, re-registers `ChurchOfBeefConsoleFrame`, and does not rebuild. An existing script is not replaced.
- Wipe-to-empty then Refresh lists the name exactly once. Same frame pointer. Third Refresh keeps OnHide identity. Selection / pair stay. Live Recommend stays; QUIET Refresh still nils it.
- B40-A Hide remount stays. B28-A Show / Refresh remount stay. B27-A Init remount stays. Show has no direct `wireConsoleOnHide`. Init does not remount OnHide.
- Empty OpenRite Gora still opens. `SaveNote` / SUMMON / parchment / no-sound stay. No OnShow re-wire.
- `runB41A()` is nested inside `runB8E()` after `runB40A()`. No new main-chunk locals.
- Isolation wrap stays.

## Leftovers

- **Init remount still skips a niled OnHide.** Brief asked Refresh remount and no OnShow re-wire. Existing-frame Init still remounts `rememberSpecial` only.
- **Widget Hide / ESC does not remount a niled OnHide.** The missing handler cannot remount itself. `CloseSpecialWindows` / `frame:Hide()` still bypass `Console:Hide`. A dropped OnHide that never hits `Console:Refresh` / `Console:Hide` / Show still leaves a wiped list idle until one of those paths.
- **Show has no direct `wireConsoleOnHide`.** Remount on Show is via `self:Refresh()`. Brief allowed that keep.
- **No client smoke.** Real ESC vs `CloseSpecialWindows` on Anniversary is unproven. A live remount that dropped the name is simulated by `UISpecialFrames = {}`. A dropped handler is simulated by `SetScript("OnHide", nil)`. Glue `Runtime:EndEvent` Refresh is not invoked here; the suite calls `Console:Refresh` directly.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Harness `Refresh()` in this suite is a direct call**, not a real ESC key and not glue EndEvent. Script identity, membership counts, and selection / pair / Recommend persist are pinned; the client's special-frame walk is not.

## Status

**DONE_WITH_CONCERNS.** Isolated **3045 / 0**. Isolation wrap **17**. Not signed. No Gate / **POLISH:PASS** claim. Gate W stays OPEN. Gate V stays OPEN.
