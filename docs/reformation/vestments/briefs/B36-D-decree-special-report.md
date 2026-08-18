# B36-D — Decree Hide remounts UISpecialFrames membership (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Wiki ESC via `UISpecialFrames` (named frame; do **not** PlaySound `IG_CHARACTER_INFO_*`); Law 6 / §19.4 (Quiet silent); Law 10 / Bible §19.3 / §14.1 (theatrical parchment; header copy / QuestBG stay); B31 leftover (`DecreeBanner:Hide` remounted OnHide but skipped `rememberSpecial`; a wiped list + Hide-only left ESC idle until Show / Refresh / Init); brief `docs/reformation/vestments/briefs/B36-D-decree-special.md`. `FRAME_NAME` is `ChurchOfBeefDecree`. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`. Anniversary `FontString:SetText` accepts `""`. No deputy. No Clear Decree chrome. No custom media. No sound. Exclusive files only. No commit. Lane is not signed.

`DecreeBanner:Hide` now: when the frame exists, `rememberSpecial(FRAME_NAME)` then existing `wireDecreeOnHide(self.frame)` then wipe-if-empty then `frame:Hide()`. Existing OnHide is not replaced. OnShow is not re-wired. Does not rebuild. Does not Show. ensureFrame remount stays.

**Isolated count:** 615 passed, 0 failed (`lua tests/test_decree_ui.lua`). **18** isolation pins under the first `if standalone then`. Nested `runB36D()` inside `runB25B()` after `runB31B()`. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_decree_ui.lua` | TDD first. Nested `runB36D()` inside `runB25B()` after `runB31B()`. Source pin: Hide body calls `rememberSpecial(FRAME_NAME)` before OnHide remount + wipe + `frame:Hide()`. No inline `SetScript("OnHide"`; no OnShow re-wire; no rebuild / `CreateFrame` / `PlaySound` / `IG_CHARACTER_INFO_*` / `:Show()` / `ensureFrame` / Clear Decree. Wipe `UISpecialFrames`, Hide: `ChurchOfBeefDecree` re-listed once. Third Hide does not duplicate. Existing OnHide identity stays. B31-B OnHide remount stay. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/Decree.lua` | When `self.frame` exists, `Hide` calls `rememberSpecial(FRAME_NAME)` before the existing OnHide remount + wipe-if-empty + `frame:Hide()`. Does not replace an existing OnHide. No OnShow re-wire. No rebuild. ensureFrame remount / create-path / `buildFrame` / Refresh / empty Show / `wipePaint` / `LINE_FONT` unchanged. No `PlaySound`. No Clear Decree chrome. |
| `docs/reformation/vestments/briefs/B36-D-decree-special-report.md` | This file |
| `docs/reformation/vestments/briefs/B36-D-decree-special.diff` | B36-D-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit glue, Console, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add deputy. Did not add Clear Decree chrome. Did not add sound. Did not add custom media. Did not change `LINE_FONT`. Did not commit.

`git diff` vs HEAD on these two files also includes earlier Decree vestment batches (working tree already dirty). The brief diff is the B36-D-only delta.

## Contract

| Surface | Role |
|---------|------|
| `DecreeBanner:Hide` | When `self.frame` exists, `rememberSpecial(FRAME_NAME)` then `wireDecreeOnHide(self.frame)` then wipe when Get is nil, then Hide. Does not replace an existing OnHide. Does not re-wire OnShow. Does not Show. Does not call `ensureFrame`. |
| `wireDecreeOnHide` | Unchanged. If `GetScript("OnHide")` is nil, wire: when `getDecree()` is nil, `wipePaint(frame)`. Do not replace an existing script. Do not Show. |
| `rememberSpecial` | Unchanged. Lives on `buildFrame` / `ensureFrame`. Scan-then-append `FRAME_NAME` (`ChurchOfBeefDecree`). Hide now calls it too. |
| `ensureFrame` early-return | Unchanged. `rememberSpecial` then `wireDecreeOnHide(frame)`. Does not rebuild. |
| `buildFrame` | Unchanged. Calls `rememberSpecial(FRAME_NAME)` then `wireDecreeOnHide`. |
| Wipe remount | `UISpecialFrames = {}` then Hide lists `ChurchOfBeefDecree` exactly once. Third Hide still once. |
| Frame identity | Hide keeps the same frame. No rebuild. Existing OnHide identity stays. |
| Quiet | Silent. No `PlaySound` / `IG_CHARACTER_INFO_*`. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`. No Clear Decree chrome. |

### Unchanged

- B31-B Hide OnHide remount. B30-A ensureFrame remount. B29-B OnHide wipe. B28-B Refresh wipe. B27-B Hide wipe. B26-C empty Show wipe. B25-B wipe + Show-only uniqueness. B24-D Init uniqueness.
- Existing Set / Show / Quiet hide / persist / already-seen-is-not-SV pins.
- Morpheus / FRIZQT / `SetFontObject` source pins.
- Isolation wrap (wow_ui_stub + Common + Decree + Decree UI + Minimap).
- Header copy / QuestBG. No deputy.

## TDD

1. Extended `tests/test_decree_ui.lua` first (nested `runB36D()` after `runB31B()`: Hide body calls `rememberSpecial(FRAME_NAME)` before `frame:Hide()`; wipe `UISpecialFrames`, Hide lists `ChurchOfBeefDecree` once; third Hide does not duplicate; existing OnHide identity stays; no OnShow / rebuild / `PlaySound` / Clear Decree). Isolation wrap and B31-B OnHide remount pins untouched.
2. Red: `lua tests/test_decree_ui.lua` — **607 passed, 8 failed** (Hide source missing `rememberSpecial(FRAME_NAME)`; wiped list stayed 0 after Hide / second Hide / third Hide / remount-stay). OnHide identity / no rebuild / no OnShow / B31-B remount stay pins stayed green.
3. `Hide` calls `rememberSpecial(FRAME_NAME)` when the frame exists, before the existing OnHide remount + wipe-if-empty + `frame:Hide()`. Existing script is not replaced. No OnShow re-wire. ensureFrame remount kept.
4. Green: `lua tests/test_decree_ui.lua` — **615 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_decree_ui.lua   # 615 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_decree_ui.lua` standalone | **615 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 18 isolation asserts stay under `if standalone then` (slash, Decree slash, DB, Store, Runtime, Net, Console, Hud, RecordsBook, Toasts, Sender, Sound, Officer, Archive, Gora, Knighting, Recognition, MainFrame). Wrap unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Glue / Console / TOC were not edited.
- Hide re-registers `ChurchOfBeefDecree` and does not rebuild. Existing OnHide identity stays. OnShow is not wired.
- Wipe-to-empty then Hide lists the name exactly once. Third Hide still once.
- Quiet stays silent. No `PlaySound`. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`. Header copy / QuestBG stay. No deputy. No Clear Decree chrome.
- `runB36D()` is nested inside `runB25B()` after `runB31B()`. No new main-chunk locals. Isolation wrap stays.

## Leftovers

- **Widget Hide / ESC does not remount `rememberSpecial`.** `CloseSpecialWindows` / `frame:Hide()` bypass `DecreeBanner:Hide`. A wiped list that never hits Hide / Show / Refresh / Init stays idle.
- **`ResetForTests` still calls `self.frame:Hide()` directly** and does not remount. Harness-only; production Close / `DecreeBanner:Hide` remount.
- **`UISpecialFrames = nil` still no-ops `rememberSpecial`.** Brief asked wipe-to-empty uniqueness, not a missing table.
- **Isolated suite does not load bootstrap glue.** A parchment left *visible* after Clear with no follow-up Hide, empty Show, Refresh, or widget Hide can still display Goldshire in this suite.
- **No client smoke.** Real ESC vs `CloseSpecialWindows` on `ChurchOfBeefDecree` is unproven on Anniversary. A live remount that dropped the name is simulated by `UISpecialFrames = {}`.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Harness `Hide()` is a direct call**, not a real ESC key. Membership counts are pinned; the client's special-frame walk is not.

## Status

**DONE_WITH_CONCERNS.** Isolated **615 / 0**. Isolation wrap **18**. Not signed. No Gate / **POLISH:PASS** claim. Gate W stays OPEN. Gate V stays OPEN.
