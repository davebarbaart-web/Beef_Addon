# B26-C — Empty Decree Show blanks leftover line paint (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Law 6 / §19.4 (Quiet silent); Law 10 / Bible §19.3 / §14.1 (theatrical parchment; header copy / QuestBG stay); B25-B leftover (empty `Show()` `ensureFrame`s then Hide, leftover `LineText` / `FlavorText` still hold the last Goldshire line on the hidden widget); brief `docs/reformation/vestments/briefs/B26-C-decree-wipe.md`. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`. No deputy. No custom media. No sound. Exclusive files only. No commit. Lane is not signed.

Empty `Show()` now `ensureFrame()`s, `wipePaint`s (`LineText` / `FlavorText` `SetText("")`; hide flavor), then Hide, return false. It does not Show the banner. It does not invent a line. It does not call `paint(`. B25-B ESC remount stays. Quiet stays hidden-until-Set.

**Isolated count:** 302 passed, 0 failed (`lua tests/test_decree_ui.lua`). **18** isolation pins under the first `if standalone then`. Nested `runB26C()` inside `runB25B()`. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_decree_ui.lua` | TDD first. Source pin: empty `Show` body has `ensureFrame()` + `wipePaint(frame)` (or `LineText:SetText("")`) + Hide; `frame.LineText:SetText("")` / `frame.FlavorText:SetText("")` exist; no `paint(frame` / `frame:Show()` / `PlaySound`. Nested `runB26C()` inside `runB25B()` after uniqueness restore: Set Goldshire + flavor, Show, `Decree:Clear()`, empty Show is false, `IsShown` false, `LineText` / `FlavorText` are `""`, flavor hidden, wiped `UISpecialFrames` + Show-only still lists `ChurchOfBeefDecree` once, no sound. Suite Clear path after Orgrimmar also pins blank line/flavor. B25-B wipe + Show-only uniqueness stays. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/Decree.lua` | `wipePaint(frame)` blanks `LineText` / `FlavorText` (`SetText("")`) and hides flavor. Empty `Show()` calls `ensureFrame()`, `wipePaint(frame)`, Hide, return false. Does not Show the banner. Does not invent a line. No `PlaySound`. Header copy / QuestBG / `LINE_FONT` unchanged. |
| `docs/reformation/vestments/briefs/B26-C-decree-wipe-report.md` | This file |
| `docs/reformation/vestments/briefs/B26-C-decree-wipe.diff` | B26-C-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Toasts, Records, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add deputy. Did not add sound. Did not add custom media. Did not commit.

`git diff` vs HEAD on these two files also includes earlier Decree vestment batches (working tree already dirty). The brief diff is the B26-C-only delta.

## Contract

| Surface | Role |
|---------|------|
| `DecreeBanner:Show` (empty Get) | `ensureFrame()`, `wipePaint(frame)`, Hide, return false. No `paint(`. No banner Show. No invented line. |
| `wipePaint` | `LineText:SetText("")`. `FlavorText:SetText("")` then Hide. Does not Show the banner. |
| `ensureFrame` | Unchanged. Early-return and create-path both `rememberSpecial(FRAME_NAME)`. B25-B ESC remount stays. |
| Wipe remount | After Init, `UISpecialFrames = {}` then Show-only lists `ChurchOfBeefDecree` exactly once (B25-B). Same uniqueness after Clear + empty Show (B26-C). |
| Quiet | Silent. Hidden-until-Set. No `PlaySound`. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`. |

### Unchanged

- Existing Set / Show / Quiet hide / persist / already-seen-is-not-SV pins.
- Morpheus / FRIZQT / `SetFontObject` source pins.
- B24-D Init uniqueness. B25-B Show-only uniqueness.
- Isolation wrap (wow_ui_stub + Common + Decree + Decree UI + Minimap).
- Header copy / QuestBG. No deputy.

## TDD

1. Extended `tests/test_decree_ui.lua` first (empty-Show source blanks leftover line/flavor; nested `runB26C()` after B25-B uniqueness: Set Goldshire, Show, Clear, empty Show is hidden with `""` line/flavor; suite Clear path after Orgrimmar pins the same; B25-B remount stays). Isolation wrap and Set / Show / Quiet hide / persist / Morpheus pins untouched except the tightened `paint(frame` source pin so `wipePaint` is allowed.
2. Red: `lua tests/test_decree_ui.lua` — **292 passed, 11 failed** (empty Show missing wipe/`SetText("")`; leftover Goldshire / Orgrimmar still on `LineText` / `FlavorText` after Clear + empty Show; flavor still shown). B25-B uniqueness pins stayed green.
3. `wipePaint(frame)` blanks line/flavor and hides flavor. Empty `Show()` calls it after `ensureFrame()`, then Hide, return false.
4. Green: `lua tests/test_decree_ui.lua` — **302 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_decree_ui.lua   # 302 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_decree_ui.lua` standalone | **302 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 18 isolation asserts stay under `if standalone then` (slash, Decree slash, DB, Store, Runtime, Net, Console, Hud, RecordsBook, Toasts, Sender, Sound, Officer, Archive, Gora, Knighting, Recognition, MainFrame). Wrap unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Toasts / Records / glue / TOC were not edited.
- Empty Show blanks leftover line/flavor on the hidden widget, then Hide. Does not Show the banner. Does not invent a line.
- B25-B wipe + Show-only uniqueness stays green. B24-D Init uniqueness stays green.
- Quiet stays silent. No `PlaySound`. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`. Header copy / QuestBG stay. No deputy.
- `runB26C()` is nested inside `runB25B()`. No new main-chunk locals. Isolation wrap stays.

## Leftovers

- **Wipe is on empty `Show` only.** `Decree:Clear()` and `DecreeBanner:Hide()` do not blank the FontStrings. A banner left visible after Core Clear (no follow-up empty Show) can still display Goldshire until something calls `Show()`.
- **No client smoke.** Live leftover paint after a Pope Clear + minimap replay is unproven on Anniversary.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Harness `Hide()` is a direct call**, not a real ESC key. Membership counts are pinned; the client's special-frame walk is not.

## Status

**DONE_WITH_CONCERNS.** Isolated **302 / 0**. Isolation wrap **18**. Not signed. No Gate / **POLISH:PASS** claim. Gate W stays OPEN. Gate V stays OPEN.
