# B28-B — Decree Refresh hides leftover paint when the line is gone (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Law 6 / §19.4 (Quiet silent; hidden-until-Set / minimap replay); Law 10 / Bible §19.3 / §14.1 (theatrical parchment; header copy / QuestBG stay); B27 leftover (Core `Decree:Clear()` leaves a visible banner until Hide or empty Show); brief `docs/reformation/vestments/briefs/B28-B-decree-refresh.md`. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`. Anniversary `FontString:SetText` accepts `""`. No deputy. No Clear Decree chrome. No custom media. No sound. Exclusive files only. No commit. Lane is not signed.

`Refresh()` now: `ensureFrame()` if needed. If `getDecree()` is nil, `wipePaint` then Hide, return false. If a Decree exists and the banner is already shown, `paint`, stay shown, return true. Does not Show a hidden banner. Empty Show / Hide wipe stay. Quiet stays silent.

**Isolated count:** 369 passed, 0 failed (`lua tests/test_decree_ui.lua`). **18** isolation pins under the first `if standalone then`. Nested `runB28B()` inside `runB25B()` after `runB27B()`. One new source-pin local (`refreshBody`). Hide body still matches through `GetView` (`Refresh` is after `GetView`).

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_decree_ui.lua` | TDD first. Type pin `Banner.Refresh`. Source pin: Refresh body has `ensureFrame()`, `getDecree()`, `wipePaint(frame)` (or `wipePaint(self.frame)` / `LineText:SetText("")`), Hide when Get is nil, `paint` + `IsShown` when a Decree is shown; no `:Show()` / `PlaySound` / invented Goldshire / Clear Decree. `LINE_FONT` Morpheus pin stays. Nested `runB28B()` inside `runB25B()` after `runB27B()`: Set Goldshire + flavor, Show, `Decree:Clear()`, `Refresh()` (not Hide/Show) is false, `IsShown` false, `LineText` / `FlavorText` are `""`, flavor hidden, wiped `UISpecialFrames` remounts `ChurchOfBeefDecree` once, no sound. Hidden + Set + Refresh does not Show and does not paint. Shown + live Set + Refresh paints Shattrath and stays shown. B27-B Hide wipe / B26-C empty Show stay. Isolation wrap stays. No Clear Decree chrome / verb. |
| `addon/ChurchOfBeef/UI/Decree.lua` | `Refresh()`: `ensureFrame()`, then if `getDecree()` is nil `wipePaint(frame)` + Hide, return false. If a Decree exists and `IsShown`, `paint` and return true. Does not Show a hidden banner. No `PlaySound`. Empty Show / Hide wipe / `wipePaint` / `LINE_FONT` unchanged. |
| `docs/reformation/vestments/briefs/B28-B-decree-refresh-report.md` | This file |
| `docs/reformation/vestments/briefs/B28-B-decree-refresh.diff` | B28-B-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Toasts, Records, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add deputy. Did not add Clear Decree chrome. Did not add sound. Did not add custom media. Did not change `LINE_FONT`. Did not commit.

`git diff` vs HEAD on these two files also includes earlier Decree vestment batches (working tree already dirty). The brief diff is the B28-B-only delta.

## Contract

| Surface | Role |
|---------|------|
| `DecreeBanner:Refresh` (Get nil) | `ensureFrame()`. `wipePaint(frame)` then Hide. Return false. No banner Show. |
| `DecreeBanner:Refresh` (Decree set, already shown) | `paint(frame, decree)`. Stay shown. Return true. |
| `DecreeBanner:Refresh` (Decree set, hidden) | Do not Show. Do not paint. Return false. Quiet hidden-until-Set / minimap replay. |
| `DecreeBanner:Show` (empty Get) | Unchanged. `ensureFrame()`, `wipePaint(frame)`, Hide, return false. |
| `DecreeBanner:Hide` (Get nil) | Unchanged. `wipePaint(self.frame)` then Hide. |
| `wipePaint` | Unchanged. `LineText:SetText("")`. `FlavorText:SetText("")` then Hide. |
| Quiet | Silent. No `PlaySound`. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`. No Clear Decree chrome. |

### Unchanged

- B27-B Hide wipe. B26-C empty Show wipe. B25-B wipe + Show-only uniqueness. B24-D Init uniqueness.
- Existing Set / Show / Quiet hide / persist / already-seen-is-not-SV pins.
- Morpheus / FRIZQT / `SetFontObject` source pins.
- Isolation wrap (wow_ui_stub + Common + Decree + Decree UI + Minimap).
- Header copy / QuestBG. No deputy.

## TDD

1. Extended `tests/test_decree_ui.lua` first (Refresh type / source pins; nested `runB28B()` after `runB27B()`: Set Goldshire, Show, Clear, Refresh not Hide/Show is hidden with `""` line/flavor; Hidden + Set + Refresh does not Show; shown Refresh paints; B27-B Hide wipe / B26-C empty Show stay). Isolation wrap and Set / Show / Quiet hide / persist / Morpheus pins untouched except the new Refresh / Clear Decree pins.
2. Red: `lua tests/test_decree_ui.lua` — **347 passed, 22 failed** (Refresh type/source missing; leftover Goldshire / flavor still on `LineText` / `FlavorText` after Clear with no Hide/Show; banner still shown; remount 0; Hidden + Set still shown with leftover paint; shown Refresh did not paint Shattrath). B27-B Hide wipe / B26-C empty Show stayed green.
3. `Refresh()` calls `ensureFrame()`, `wipePaint` + Hide when `getDecree()` is nil, `paint` when a Decree is already shown. Does not Show a hidden banner.
4. Green: `lua tests/test_decree_ui.lua` — **369 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_decree_ui.lua   # 369 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_decree_ui.lua` standalone | **369 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 18 isolation asserts stay under `if standalone then` (slash, Decree slash, DB, Store, Runtime, Net, Console, Hud, RecordsBook, Toasts, Sender, Sound, Officer, Archive, Gora, Knighting, Recognition, MainFrame). Wrap unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Toasts / Records / glue / TOC were not edited.
- Refresh after Clear blanks leftover line/flavor and Hides. Does not Show a hidden banner. Does not invent a line.
- Hidden + Set + Refresh stays hidden. Shown + live Decree Refresh paints and stays shown. B27-B Hide wipe / B26-C empty Show stay green.
- Quiet stays silent. No `PlaySound`. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`. Header copy / QuestBG stay. No deputy. No Clear Decree chrome.
- `runB28B()` is nested inside `runB25B()` after `runB27B()`. Isolation wrap stays.

## Leftovers

- **Glue does not call Refresh yet.** Core `Decree:Clear()` still does not notify the banner. A parchment left visible after Clear with no follow-up Hide, empty Show, or Refresh can still display Goldshire until something calls one of those. B28-INT is the wrap (`Decree:Clear` → `DecreeBanner:Refresh`) if this lane lands.
- **No client smoke.** Live leftover paint after Pope Clear + Refresh is unproven on Anniversary.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Harness `Refresh()` is a direct call**, not a Pope-console Clear path. Membership remount is pinned; the client's special-frame walk is not.

## Status

**DONE_WITH_CONCERNS.** Isolated **369 / 0**. Isolation wrap **18**. Not signed. No Gate / **POLISH:PASS** claim. Gate W stays OPEN. Gate V stays OPEN.
