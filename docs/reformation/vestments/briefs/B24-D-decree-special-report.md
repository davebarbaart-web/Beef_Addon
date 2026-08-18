# B24-D — Decree ensureFrame re-registers ESC (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Wiki ESC via `UISpecialFrames` (named frame; do not PlaySound `IG_CHARACTER_INFO_*`); Law 6 / §19.4 (Quiet silent); Law 10 / Bible §19.3 (theatrical parchment; header copy / QuestBG stay); B23-C leftover shape (`ensureFrame` returned the existing banner and skipped `rememberSpecial`; a wiped list never got `ChurchOfBeefDecree` back); brief `docs/reformation/vestments/briefs/B24-D-decree-special.md`. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`. No deputy. No custom media. No sound. Exclusive files only. No commit. Lane is not signed.

`ensureFrame` early-return (`if DecreeBanner.frame then`) now calls `rememberSpecial(FRAME_NAME)` then returns the existing frame. It does not rebuild. Create-path `buildFrame` still registers once. Quiet hide / persist / Morpheus pins stay.

**Isolated count:** 265 passed, 0 failed (`lua tests/test_decree_ui.lua`). **18** isolation pins under the first `if standalone then`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_decree_ui.lua` | TDD first. Source pin: `ensureFrame` early-return body has `rememberSpecial(FRAME_NAME)` and no `buildFrame` / `CreateFrame` / `PlaySound`. Init so the frame exists, wipe `UISpecialFrames` to `{}`, second Init: `ChurchOfBeefDecree` listed exactly once. Third Init still once. Existing Quiet hide / persist / Morpheus pins stay. Isolation wrap stays. Runtime pins nested in `runB24D()`. |
| `addon/ChurchOfBeef/UI/Decree.lua` | Early-return calls `rememberSpecial(FRAME_NAME)` then returns the frame. Does not rebuild. No `PlaySound`. Header copy / QuestBG / `LINE_FONT` unchanged. |
| `docs/reformation/vestments/briefs/B24-D-decree-special-report.md` | This file |
| `docs/reformation/vestments/briefs/B24-D-decree-special.diff` | B24-D-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Toasts, Records, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add deputy. Did not add sound. Did not add custom media. Did not commit.

`git diff` vs HEAD on these two files also includes earlier Decree vestment batches (working tree already dirty). The brief diff is the B24-D-only delta.

## Contract

| Surface | Role |
|---------|------|
| `ensureFrame` early-return | `rememberSpecial(FRAME_NAME)` then return the existing banner. |
| Create path | Unchanged. `buildFrame` still calls `rememberSpecial(FRAME_NAME)` once. |
| Wipe remount | `UISpecialFrames = {}` then second Init lists `ChurchOfBeefDecree` exactly once. |
| Rebuild | Early-return does not call `buildFrame` / `CreateFrame`. Same frame pointer. |
| Quiet | Silent. No `PlaySound`. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`. |
| Header / QuestBG | Unchanged. |

### Unchanged

- Existing Quiet hide / persist / already-seen-is-not-SV pins.
- Morpheus / FRIZQT / `SetFontObject` source pins.
- First-create `UISpecialFrames` membership pin.
- Isolation wrap (wow_ui_stub + Common + Decree + Decree UI + Minimap).

## TDD

1. Extended `tests/test_decree_ui.lua` first (early-return source has `rememberSpecial(FRAME_NAME)`; Init, wipe `UISpecialFrames` to `{}`, second Init lists the name once; no rebuild; no `PlaySound`). Isolation wrap and Quiet hide / persist / Morpheus pins untouched.
2. Red: `lua tests/test_decree_ui.lua` — **261 passed, 4 failed**.
3. Early-return calls `rememberSpecial(FRAME_NAME)` then returns the frame.
4. Green: `lua tests/test_decree_ui.lua` — **265 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_decree_ui.lua   # 265 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_decree_ui.lua` standalone | **265 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 18 isolation asserts stay under `if standalone then` (slash, Decree slash, DB, Store, Runtime, Net, Console, Hud, RecordsBook, Toasts, Sender, Sound, Officer, Archive, Gora, Knighting, Recognition, MainFrame). Wrap unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Toasts / Records / glue / TOC were not edited.
- Early-return re-registers `ChurchOfBeefDecree` and does not rebuild.
- Wipe-to-empty then second Init lists the name exactly once. Third Init still once.
- Quiet stays silent. No `PlaySound`. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`. Header copy / QuestBG stay.
- Runtime pins are nested in `runB24D()`. Isolation wrap stays.

## Leftovers

- **No client smoke.** Real ESC vs `CloseSpecialWindows` order is unproven on Anniversary. A live remount that dropped the name is simulated by `UISpecialFrames = {}`.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Harness `Hide()` is a direct call**, not a real ESC key. Membership counts are pinned; the client's special-frame walk is not.
- **`Show()` with no active Decree still returns before `ensureFrame`.** The brief allowed second Init or Show; this lane closed Init. A wipe then Show-only (empty Get) does not put the name back until Init or a Show that paints.

## Status

**DONE_WITH_CONCERNS.** Isolated **265 / 0**. Isolation wrap **18**. Not signed.
