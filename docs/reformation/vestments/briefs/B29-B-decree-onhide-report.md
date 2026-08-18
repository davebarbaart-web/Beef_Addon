# B29-B — Decree OnHide blanks leftover paint when the line is gone (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Law 6 / §19.4 (Quiet silent); Law 10 / Bible §19.3 / §14.1 (theatrical parchment; header copy / QuestBG stay); B28 leftover (widget `frame:Hide()` via `UISpecialFrames` ESC bypasses `DecreeBanner:Hide` and leaves Goldshire after Core Clear); brief `docs/reformation/vestments/briefs/B29-B-decree-onhide.md`. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`. Anniversary `FontString:SetText` accepts `""`. No deputy. No Clear Decree chrome. No custom media. No sound. Exclusive files only. No commit. Lane is not signed.

Banner OnHide now: if `getDecree()` is nil, `wipePaint`. Extracted `wireDecreeOnHide(frame)` so `SetScript` stays out of Hide/Refresh. Wires only when `GetScript("OnHide")` is nil. Called from `buildFrame` and `ensureFrame` create. Does not Show. Refresh / empty Show / Hide wipe stay. Quiet stays silent.

**Isolated count:** 427 passed, 0 failed (`lua tests/test_decree_ui.lua`). **18** isolation pins under the first `if standalone then`. Nested `runB29B()` inside `runB25B()` after `runB28B()`. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_decree_ui.lua` | TDD first. Nested `runB29B()` inside `runB25B()` after `runB28B()`. Source: `wireDecreeOnHide`; GetScript / existing-return / `getDecree` + `wipePaint`; no `:Show()` / `PlaySound` / rebuild / Clear Decree. `buildFrame` / `ensureFrame` create call the helper and do not `SetScript("OnHide"` inline. Hide / Refresh stay free of `SetScript` / `wireDecreeOnHide`. `LINE_FONT` Morpheus pin stays. Set Goldshire + flavor, Show, `Decree:Clear()`, widget `frame:Hide()` (not `DecreeBanner:Hide` / Refresh): `IsShown` false, `LineText` / `FlavorText` are `""`, flavor hidden, no sound. Init does not replace OnHide. Hide wipe / Refresh wipe / empty Show wipe stay. Isolation wrap stays. No Clear Decree chrome / verb. |
| `addon/ChurchOfBeef/UI/Decree.lua` | Extracted `wireDecreeOnHide(frame)`. If `GetScript("OnHide")` is nil, wire: `getDecree()` nil then `wipePaint(frame)`. Do not replace an existing script. Do not Show. `buildFrame` and `ensureFrame` create call the helper. Hide / Refresh / empty Show / `wipePaint` / `LINE_FONT` unchanged. No `PlaySound`. |
| `docs/reformation/vestments/briefs/B29-B-decree-onhide-report.md` | This file |
| `docs/reformation/vestments/briefs/B29-B-decree-onhide.diff` | B29-B-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Toasts, Records, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add deputy. Did not add Clear Decree chrome. Did not add sound. Did not add custom media. Did not change `LINE_FONT`. Did not commit.

`git diff` vs HEAD on these two files also includes earlier Decree vestment batches (working tree already dirty). The brief diff is the B29-B-only delta.

## Contract

| Surface | Role |
|---------|------|
| `wireDecreeOnHide` | If `GetScript("OnHide")` is nil, wire: when `getDecree()` is nil, `wipePaint(frame)`. Do not replace an existing script. Do not Show. |
| `buildFrame` | Calls `wireDecreeOnHide(frame)` after `rememberSpecial`. No inline `SetScript("OnHide"`. |
| `ensureFrame` create | `buildFrame()` then `wireDecreeOnHide(DecreeBanner.frame)`. Existing script is not replaced. |
| `ensureFrame` early-return | Unchanged. `rememberSpecial` only. Does not remount a missing OnHide. |
| Widget `frame:Hide()` / OnHide | After Core Clear, blanks leftover Line/Flavor. ESC via `UISpecialFrames` now wipes. |
| `DecreeBanner:Refresh` (Get nil) | Unchanged. `wipePaint` then Hide. |
| `DecreeBanner:Hide` (Get nil) | Unchanged. `wipePaint(self.frame)` then Hide. |
| `DecreeBanner:Show` (empty Get) | Unchanged. `ensureFrame()`, `wipePaint(frame)`, Hide, return false. |
| `wipePaint` | Unchanged. `LineText:SetText("")`. `FlavorText:SetText("")` then Hide. |
| Quiet | Silent. No `PlaySound`. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`. No Clear Decree chrome. |

### Unchanged

- B28-B Refresh wipe. B27-B Hide wipe. B26-C empty Show wipe. B25-B wipe + Show-only uniqueness. B24-D Init uniqueness.
- Existing Set / Show / Quiet hide / persist / already-seen-is-not-SV pins.
- Morpheus / FRIZQT / `SetFontObject` source pins.
- Isolation wrap (wow_ui_stub + Common + Decree + Decree UI + Minimap).
- Header copy / QuestBG. No deputy.

## TDD

1. Extended `tests/test_decree_ui.lua` first (nested `runB29B()` after `runB28B()`: `wireDecreeOnHide` source; create-path calls the helper; Set Goldshire, Show, Clear, widget `frame:Hide()` not Hide/Refresh is hidden with `""` line/flavor; Init does not replace; Hide / Refresh / empty Show wipe stay). Isolation wrap and Set / Show / Quiet hide / persist / Morpheus pins untouched except the new OnHide pins.
2. Red: `lua tests/test_decree_ui.lua` — **413 passed, 14 failed** (`wireDecreeOnHide` missing; create-path OnHide nil; leftover Goldshire / flavor still on `LineText` / `FlavorText` after Clear + widget Hide; flavor still shown). Hide wipe / Refresh wipe / empty Show wipe stay pins stayed green.
3. Extracted `wireDecreeOnHide(frame)`. Create-path (`buildFrame` / `ensureFrame` create) calls it. Existing script is not replaced. OnHide wipePaints when `getDecree()` is nil. Does not Show.
4. Green: `lua tests/test_decree_ui.lua` — **427 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_decree_ui.lua   # 427 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_decree_ui.lua` standalone | **427 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 18 isolation asserts stay under `if standalone then` (slash, Decree slash, DB, Store, Runtime, Net, Console, Hud, RecordsBook, Toasts, Sender, Sound, Officer, Archive, Gora, Knighting, Recognition, MainFrame). Wrap unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Toasts / Records / glue / TOC were not edited.
- Widget Hide after Clear blanks leftover line/flavor. Does not Show. Does not invent a line.
- Init does not replace an existing OnHide. Hide wipe / Refresh wipe / empty Show wipe stay green.
- Quiet stays silent. No `PlaySound`. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`. Header copy / QuestBG stay. No deputy. No Clear Decree chrome.
- `runB29B()` is nested inside `runB25B()` after `runB28B()`. No new main-chunk locals. Isolation wrap stays.

## Leftovers

- **Glue does not call Refresh yet.** Core `Decree:Clear()` still does not notify the banner. A parchment left *visible* after Clear with no follow-up Hide, empty Show, Refresh, or widget Hide can still display Goldshire.
- **`ensureFrame` early-return does not remount a missing OnHide.** Create-path only, per brief. A remount that dropped the handler stays idle until the frame is rebuilt.
- **No client smoke.** Live leftover paint after Pope Clear + ESC is unproven on Anniversary.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Harness `frame:Hide()` is a direct call**, not a real ESC key. Script fire and leftover wipe are pinned; the client's special-frame walk is not.

## Status

**DONE_WITH_CONCERNS.** Isolated **427 / 0**. Isolation wrap **18**. Not signed. No Gate / **POLISH:PASS** claim. Gate W stays OPEN. Gate V stays OPEN.
