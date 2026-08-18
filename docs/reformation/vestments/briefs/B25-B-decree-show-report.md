# B25-B — Empty Decree Show still registers ESC then hides (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Wiki ESC via `UISpecialFrames` (named frame; do not PlaySound `IG_CHARACTER_INFO_*`); Law 6 / §19.4 (Quiet silent); Law 10 / Bible §19.3 (theatrical parchment; header copy / QuestBG stay); B24-D leftover (`Show()` with no active Decree returned before `ensureFrame`; a wiped list then Show-only never got `ChurchOfBeefDecree` back); brief `docs/reformation/vestments/briefs/B25-B-decree-show.md`. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`. No deputy. No custom media. No sound. Exclusive files only. No commit. Lane is not signed.

Empty `Show()` now calls `ensureFrame()`, then Hide, return false. It does not paint. It does not Show the banner. Quiet stays hidden-until-Set. `ensureFrame` already `rememberSpecial`s. Existing Set / Show / Quiet hide / persist / Morpheus pins stay. B24-D Init uniqueness pins stay.

**Isolated count:** 280 passed, 0 failed (`lua tests/test_decree_ui.lua`). **18** isolation pins under the first `if standalone then`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_decree_ui.lua` | TDD first. Source pin: empty `Show` body has `ensureFrame()` + Hide, no `paint(` / `frame:Show()` / `PlaySound`. `runB25B()` after Init: wipe `UISpecialFrames` to `{}`, Show is false, `IsShown` is false, `ChurchOfBeefDecree` listed once without a follow-up Init, no sound, second empty Show still once. B24-D leftover tightened so Show-without-decree itself re-registers; Init uniqueness pins stay. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/Decree.lua` | Empty `Show()` calls `ensureFrame()` then Hide, return false. Does not paint. Does not Show the banner. No `PlaySound`. Header copy / QuestBG / `LINE_FONT` unchanged. |
| `docs/reformation/vestments/briefs/B25-B-decree-show-report.md` | This file |
| `docs/reformation/vestments/briefs/B25-B-decree-show.diff` | B25-B-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Toasts, Records, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add deputy. Did not add sound. Did not add custom media. Did not commit.

`git diff` vs HEAD on these two files also includes earlier Decree vestment batches (working tree already dirty). The brief diff is the B25-B-only delta.

## Contract

| Surface | Role |
|---------|------|
| `DecreeBanner:Show` (empty Get) | `ensureFrame()` then Hide, return false. No paint. No banner Show. |
| `ensureFrame` | Unchanged. Early-return and create-path both `rememberSpecial(FRAME_NAME)`. |
| Wipe remount | After Init, `UISpecialFrames = {}` then Show-only lists `ChurchOfBeefDecree` exactly once. |
| Quiet | Silent. Hidden-until-Set. No `PlaySound`. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`. |
| Header / QuestBG | Unchanged. |

### Unchanged

- Existing Set / Show / Quiet hide / persist / already-seen-is-not-SV pins.
- Morpheus / FRIZQT / `SetFontObject` source pins.
- B24-D Init uniqueness (first-create, second Init, third Init, Init after Show).
- Isolation wrap (wow_ui_stub + Common + Decree + Decree UI + Minimap).

## TDD

1. Extended `tests/test_decree_ui.lua` first (empty-Show source has `ensureFrame()` + Hide and no paint / banner Show / `PlaySound`; after Init wipe `UISpecialFrames` to `{}`, Show is false, `IsShown` is false, name listed once without Init after; B24-D leftover tightened so Show-without-decree itself re-registers). Isolation wrap and Set / Show / Quiet hide / persist / Morpheus pins untouched.
2. Red: `lua tests/test_decree_ui.lua` — **276 passed, 4 failed** (empty Show missing `ensureFrame`; wiped list still 0 after Show-only; second empty Show still 0).
3. Empty `Show()` calls `ensureFrame()` then Hide, return false. Does not paint. Does not Show the banner.
4. Green: `lua tests/test_decree_ui.lua` — **280 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_decree_ui.lua   # 280 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_decree_ui.lua` standalone | **280 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 18 isolation asserts stay under `if standalone then` (slash, Decree slash, DB, Store, Runtime, Net, Console, Hud, RecordsBook, Toasts, Sender, Sound, Officer, Archive, Gora, Knighting, Recognition, MainFrame). Wrap unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Toasts / Records / glue / TOC were not edited.
- Empty Show re-registers `ChurchOfBeefDecree` via `ensureFrame` and does not paint or Show the banner.
- Wipe-to-empty then Show-only lists the name exactly once. Second empty Show still once. B24-D Init uniqueness stays green.
- Quiet stays silent. No `PlaySound`. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`. Header copy / QuestBG stay.
- Runtime pins are in `runB25B()`. Isolation wrap stays.

## Leftovers

- **No client smoke.** Real ESC vs `CloseSpecialWindows` order is unproven on Anniversary. A live remount that dropped the name is simulated by `UISpecialFrames = {}`.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Harness `Hide()` is a direct call**, not a real ESC key. Membership counts are pinned; the client's special-frame walk is not.

## Status

**DONE_WITH_CONCERNS.** Isolated **280 / 0**. Isolation wrap **18**. Not signed.
