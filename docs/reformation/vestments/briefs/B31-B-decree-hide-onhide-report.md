# B31-B — Decree Hide remounts a missing OnHide (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Law 6 / §19.4 (Quiet silent); Law 10 / Bible §19.3 / §14.1 (theatrical parchment; header copy / QuestBG stay); Wiki ESC / UIHANDLER OnHide (do **not** PlaySound `IG_CHARACTER_INFO_*`); B30 leftover (`DecreeBanner:Hide` skipped a niled OnHide; ESC last-wipe would drop until ensureFrame); brief `docs/reformation/vestments/briefs/B31-B-decree-hide-onhide.md`. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`. Anniversary `FontString:SetText` accepts `""`. No deputy. No Clear Decree chrome. No custom media. No sound. Exclusive files only. No commit. Lane is not signed.

`DecreeBanner:Hide` now: when the frame exists, `wireDecreeOnHide(self.frame)` then wipe/Hide. Existing script is not replaced (`wireDecreeOnHide` already guards). Does not Show. ensureFrame remount stays. Refresh / empty Show / widget-Hide-after-Clear wipe stay. Quiet stays silent.

**Isolated count:** 565 passed, 0 failed (`lua tests/test_decree_ui.lua`). **18** isolation pins under the first `if standalone then`. Nested `runB31B()` inside `runB25B()` after `runB30A()`. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_decree_ui.lua` | TDD first. Nested `runB31B()` inside `runB25B()` after `runB30A()`. Retired B29-B / B30-A "Hide does not call `wireDecreeOnHide`" source pins. Source: Hide exists-path calls `wireDecreeOnHide` before wipe/Hide; no inline `SetScript("OnHide"`; no rebuild / `CreateFrame` / `PlaySound` / `:Show()` / `ensureFrame` / Clear Decree. ensureFrame remount stays. Refresh stays free of `wireDecreeOnHide`. `LINE_FONT` Morpheus pin stays. Nil OnHide, Hide: script restored; same frame pointer. Third Hide with the script already set: identity stays. Widget `frame:Hide()` after Clear / Refresh wipe / empty Show wipe / ensureFrame Show-Refresh-Init remount stay. Isolation wrap stays. No Clear Decree chrome / verb. |
| `addon/ChurchOfBeef/UI/Decree.lua` | When `self.frame` exists, `Hide` calls `wireDecreeOnHide(self.frame)` before wipe/Hide. Does not replace an existing script. ensureFrame remount / create-path / `buildFrame` / Refresh / empty Show / `wipePaint` / `LINE_FONT` unchanged. No `PlaySound`. |
| `docs/reformation/vestments/briefs/B31-B-decree-hide-onhide-report.md` | This file |
| `docs/reformation/vestments/briefs/B31-B-decree-hide-onhide.diff` | B31-B-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Toasts, Records, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add deputy. Did not add Clear Decree chrome. Did not add sound. Did not add custom media. Did not change `LINE_FONT`. Did not commit.

`git diff` vs HEAD on these two files also includes earlier Decree vestment batches (working tree already dirty). The brief diff is the B31-B-only delta.

## Contract

| Surface | Role |
|---------|------|
| `DecreeBanner:Hide` | When `self.frame` exists, `wireDecreeOnHide(self.frame)` then wipe when Get is nil, then Hide. Does not replace an existing script. Does not Show. Does not call `ensureFrame`. |
| `wireDecreeOnHide` | Unchanged. If `GetScript("OnHide")` is nil, wire: when `getDecree()` is nil, `wipePaint(frame)`. Do not replace an existing script. Do not Show. |
| `ensureFrame` early-return | Unchanged. `rememberSpecial` then `wireDecreeOnHide(frame)`. Does not rebuild. Does not replace an existing script. |
| `buildFrame` | Unchanged. Calls `wireDecreeOnHide(frame)` after `rememberSpecial`. No inline `SetScript("OnHide"`. |
| `ensureFrame` create | Unchanged. `buildFrame()` then `wireDecreeOnHide(DecreeBanner.frame)`. |
| Widget `frame:Hide()` / OnHide | After Core Clear, blanks leftover Line/Flavor. A dropped handler is remounted on the next Hide / Show / Refresh / Init. |
| `DecreeBanner:Refresh` (Get nil) | Unchanged. `wipePaint` then Hide. Hits `ensureFrame`, so a dropped OnHide remounts. |
| `DecreeBanner:Show` (empty Get) | Unchanged. `ensureFrame()`, `wipePaint(frame)`, Hide, return false. Hits `ensureFrame`, so a dropped OnHide remounts. |
| `wipePaint` | Unchanged. `LineText:SetText("")`. `FlavorText:SetText("")` then Hide. |
| Quiet | Silent. No `PlaySound`. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`. No Clear Decree chrome. |

### Unchanged

- B30-A ensureFrame remount. B29-B OnHide wipe. B28-B Refresh wipe. B27-B Hide wipe. B26-C empty Show wipe. B25-B wipe + Show-only uniqueness. B24-D Init uniqueness.
- Existing Set / Show / Quiet hide / persist / already-seen-is-not-SV pins.
- Morpheus / FRIZQT / `SetFontObject` source pins.
- Isolation wrap (wow_ui_stub + Common + Decree + Decree UI + Minimap).
- Header copy / QuestBG. No deputy.

## TDD

1. Extended `tests/test_decree_ui.lua` first (nested `runB31B()` after `runB30A()`: Hide exists-path remounts via `wireDecreeOnHide` before wipe/Hide; no inline `SetScript("OnHide"`; nil OnHide then Hide restores the script; third Hide with the script already set keeps identity; widget Hide after Clear / Refresh / empty Show wipe / ensureFrame remount stay). Retired B29-B / B30-A "Hide does not call `wireDecreeOnHide`" pins. Isolation wrap and Set / Show / Quiet hide / persist / Morpheus pins untouched except the new Hide remount pins.
2. Red: `lua tests/test_decree_ui.lua` — **561 passed, 4 failed** (Hide missing `wireDecreeOnHide`; Hide left OnHide nil). Identity-stay / widget-Hide-after-Clear wipe / Refresh wipe / empty Show wipe / ensureFrame remount stay pins stayed green.
3. `Hide` calls `wireDecreeOnHide(self.frame)` when the frame exists, before wipe/Hide. Existing script is not replaced. ensureFrame remount kept. Does not Show.
4. Green: `lua tests/test_decree_ui.lua` — **565 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_decree_ui.lua   # 565 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_decree_ui.lua` standalone | **565 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 18 isolation asserts stay under `if standalone then` (slash, Decree slash, DB, Store, Runtime, Net, Console, Hud, RecordsBook, Toasts, Sender, Sound, Officer, Archive, Gora, Knighting, Recognition, MainFrame). Wrap unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Toasts / Records / glue / TOC were not edited.
- A dropped OnHide is remounted on Hide when the frame already exists. Existing script identity stays. Does not Show. Does not invent a line.
- Widget Hide after Clear still blanks leftover line/flavor. Refresh wipe / empty Show wipe / ensureFrame remount stay green.
- Quiet stays silent. No `PlaySound`. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`. Header copy / QuestBG stay. No deputy. No Clear Decree chrome.
- `runB31B()` is nested inside `runB25B()` after `runB30A()`. No new main-chunk locals. Isolation wrap stays.

## Leftovers

- **Isolated suite does not load bootstrap glue.** A parchment left *visible* after Clear with no follow-up Hide, empty Show, Refresh, or widget Hide can still display Goldshire in this suite. Installed `wrapAlways` Clear→Refresh is outside this exclusive lane.
- **Widget Hide / ESC does not remount a niled OnHide.** The missing handler cannot remount itself. A dropped OnHide that never hits `DecreeBanner:Hide`, Show, Refresh, or Init stays idle.
- **Hide still does not call `ensureFrame` / `rememberSpecial`.** A wiped `UISpecialFrames` + Hide-only leaves ESC membership idle until Show / Refresh / Init.
- **No client smoke.** Live leftover paint after Pope Clear + ESC, and a live remount of a dropped OnHide, are unproven on Anniversary.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Harness `frame:Hide()` is a direct call**, not a real ESC key. Script fire and leftover wipe are pinned; the client's special-frame walk is not.

## Status

**DONE_WITH_CONCERNS.** Isolated **565 / 0**. Isolation wrap **18**. Not signed. No Gate / **POLISH:PASS** claim. Gate W stays OPEN. Gate V stays OPEN.
