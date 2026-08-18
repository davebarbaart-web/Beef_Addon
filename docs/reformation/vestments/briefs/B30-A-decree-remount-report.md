# B30-A — Decree ensureFrame remounts a missing OnHide (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Law 6 / §19.4 (Quiet silent); Law 10 / Bible §19.3 / §14.1 (theatrical parchment; header copy / QuestBG stay); B29 leftover (`ensureFrame` early-return only `rememberSpecial`s; a remount that dropped OnHide stays idle until rebuild); brief `docs/reformation/vestments/briefs/B30-A-decree-remount.md`. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`. Anniversary `FontString:SetText` accepts `""`. No deputy. No Clear Decree chrome. No custom media. No sound. Exclusive files only. No commit. Lane is not signed.

`ensureFrame` early-return now: `rememberSpecial` then `wireDecreeOnHide(frame)`. Existing script is not replaced (`wireDecreeOnHide` already guards). Create-path / `buildFrame` stay. Does not Show. Hide / Refresh / empty Show wipe stay. Quiet stays silent.

**Isolated count:** 494 passed, 0 failed (`lua tests/test_decree_ui.lua`). **18** isolation pins under the first `if standalone then`. Nested `runB30A()` inside `runB25B()` after `runB29B()`. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_decree_ui.lua` | TDD first. Nested `runB30A()` inside `runB25B()` after `runB29B()`. Source: early-return `rememberSpecial` then `wireDecreeOnHide`; no inline `SetScript("OnHide"`; no rebuild / `CreateFrame` / `PlaySound` / `:Show()` / Clear Decree. Create-path / `buildFrame` still call the helper. Hide / Refresh stay free of `wireDecreeOnHide`. `LINE_FONT` Morpheus pin stays. Nil OnHide, then Show / Refresh / Init on the existing frame: script restored; same frame pointer. Third call with the script already set: identity stays. Widget `frame:Hide()` after Clear / Hide wipe / Refresh wipe / empty Show wipe stay. Isolation wrap stays. No Clear Decree chrome / verb. |
| `addon/ChurchOfBeef/UI/Decree.lua` | `ensureFrame` early-return calls `wireDecreeOnHide(DecreeBanner.frame)` after `rememberSpecial`. Does not replace an existing script. Create-path / `buildFrame` / Hide / Refresh / empty Show / `wipePaint` / `LINE_FONT` unchanged. No `PlaySound`. |
| `docs/reformation/vestments/briefs/B30-A-decree-remount-report.md` | This file |
| `docs/reformation/vestments/briefs/B30-A-decree-remount.diff` | B30-A-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Toasts, Records, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add deputy. Did not add Clear Decree chrome. Did not add sound. Did not add custom media. Did not change `LINE_FONT`. Did not commit.

`git diff` vs HEAD on these two files also includes earlier Decree vestment batches (working tree already dirty). The brief diff is the B30-A-only delta.

## Contract

| Surface | Role |
|---------|------|
| `ensureFrame` early-return | `rememberSpecial` then `wireDecreeOnHide(frame)`. Does not rebuild. Does not replace an existing script. |
| `wireDecreeOnHide` | Unchanged. If `GetScript("OnHide")` is nil, wire: when `getDecree()` is nil, `wipePaint(frame)`. Do not replace an existing script. Do not Show. |
| `buildFrame` | Unchanged. Calls `wireDecreeOnHide(frame)` after `rememberSpecial`. No inline `SetScript("OnHide"`. |
| `ensureFrame` create | Unchanged. `buildFrame()` then `wireDecreeOnHide(DecreeBanner.frame)`. |
| Widget `frame:Hide()` / OnHide | After Core Clear, blanks leftover Line/Flavor. A dropped handler is remounted on the next Show / Refresh / Init. |
| `DecreeBanner:Refresh` (Get nil) | Unchanged. `wipePaint` then Hide. Hits `ensureFrame`, so a dropped OnHide remounts. |
| `DecreeBanner:Hide` (Get nil) | Unchanged. `wipePaint(self.frame)` then Hide. Does not call `ensureFrame`. |
| `DecreeBanner:Show` (empty Get) | Unchanged. `ensureFrame()`, `wipePaint(frame)`, Hide, return false. Hits `ensureFrame`, so a dropped OnHide remounts. |
| `wipePaint` | Unchanged. `LineText:SetText("")`. `FlavorText:SetText("")` then Hide. |
| Quiet | Silent. No `PlaySound`. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`. No Clear Decree chrome. |

### Unchanged

- B29-B OnHide wipe. B28-B Refresh wipe. B27-B Hide wipe. B26-C empty Show wipe. B25-B wipe + Show-only uniqueness. B24-D Init uniqueness.
- Existing Set / Show / Quiet hide / persist / already-seen-is-not-SV pins.
- Morpheus / FRIZQT / `SetFontObject` source pins.
- Isolation wrap (wow_ui_stub + Common + Decree + Decree UI + Minimap).
- Header copy / QuestBG. No deputy.

## TDD

1. Extended `tests/test_decree_ui.lua` first (nested `runB30A()` after `runB29B()`: early-return source remounts via `wireDecreeOnHide` after `rememberSpecial`; nil OnHide then Show / Refresh / Init on the existing frame restores the script; third call with the script already set keeps identity; widget Hide after Clear / Hide / Refresh / empty Show wipe stay). Isolation wrap and Set / Show / Quiet hide / persist / Morpheus pins untouched except the new remount pins.
2. Red: `lua tests/test_decree_ui.lua` — **486 passed, 8 failed** (early-return missing `wireDecreeOnHide`; Show / Refresh / Init left OnHide nil; leftover Goldshire / flavor still on `LineText` / `FlavorText` after Clear + widget Hide). Identity-stay / Hide wipe / Refresh wipe / empty Show wipe stay pins stayed green.
3. `ensureFrame` early-return calls `wireDecreeOnHide(DecreeBanner.frame)` after `rememberSpecial`. Existing script is not replaced. Create-path kept. Does not Show.
4. Green: `lua tests/test_decree_ui.lua` — **494 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_decree_ui.lua   # 494 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_decree_ui.lua` standalone | **494 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 18 isolation asserts stay under `if standalone then` (slash, Decree slash, DB, Store, Runtime, Net, Console, Hud, RecordsBook, Toasts, Sender, Sound, Officer, Archive, Gora, Knighting, Recognition, MainFrame). Wrap unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Toasts / Records / glue / TOC were not edited.
- A dropped OnHide is remounted on Show / Refresh / Init when the frame already exists. Existing script identity stays. Does not Show. Does not invent a line.
- Widget Hide after Clear still blanks leftover line/flavor. Hide wipe / Refresh wipe / empty Show wipe stay green.
- Quiet stays silent. No `PlaySound`. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`. Header copy / QuestBG stay. No deputy. No Clear Decree chrome.
- `runB30A()` is nested inside `runB25B()` after `runB29B()`. No new main-chunk locals. Isolation wrap stays.

## Leftovers

- **Glue does not call Refresh yet.** Core `Decree:Clear()` still does not notify the banner. A parchment left *visible* after Clear with no follow-up Hide, empty Show, Refresh, or widget Hide can still display Goldshire.
- **`DecreeBanner:Hide` does not call `ensureFrame`.** A dropped OnHide that never hits Show, Refresh, or Init stays idle. Hide wipe of leftover paint still runs on the method itself.
- **No client smoke.** Live leftover paint after Pope Clear + ESC, and a live remount of a dropped OnHide, are unproven on Anniversary.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Harness `frame:Hide()` is a direct call**, not a real ESC key. Script fire and leftover wipe are pinned; the client's special-frame walk is not.

## Status

**DONE_WITH_CONCERNS.** Isolated **494 / 0**. Isolation wrap **18**. Not signed. No Gate / **POLISH:PASS** claim. Gate W stays OPEN. Gate V stays OPEN.
