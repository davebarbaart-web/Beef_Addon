# B12-C — Fighter card ESC dismiss (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §10.6 (mute tape), §10.7 (persist through the verdict beat); Law 6 / §19.1 (Quiet Mode hides Event chrome); Law 10 / §19.3 (theatrical card, stock FrameXML ESC); brief `docs/reformation/vestments/briefs/B12-C-card-esc.md`. B3-B mute tape, B4-E LEFT / Morpheus, B6-D honorifics, B8-C mute defense integers, and B10-C lastPair persist kept. A01 still NOT RUN.

Event Mode mute fighter card registers the named frame `ChurchOfBeefFighterCard` on `UISpecialFrames` so Classic ESC Hide()s it. Registration copies Decree `rememberSpecial`: type-guard a missing table; skip if the name is already listed. Second Init does not duplicate. `Hide()` still dismisses without forgetting `lastPair` until QUIET. Refresh after Hide still paints the remembered pair while the event is live. No close ✕. No `ShowUIPanel`. No `UnitHealth`. No sound on show/hide. Exclusive files only. No commit. Lane is not signed. **POLISH:CANDIDATE** at most.

**Isolated count:** 448 passed, 0 failed (`lua tests/test_fighter_card.lua`). **17** isolation pins under `if standalone then`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_fighter_card.lua` | TDD first. Source contains `UISpecialFrames` and no close mark. After Init the name is listed once; second Init does not duplicate; Init survives a missing table; rebuild Init still does not duplicate. Existing Hide / persist / 1-0 / health-nil pins stay. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/FighterCard.lua` | Decree-shaped `rememberSpecial`. `Init` registers `FRAME_NAME` after the widget exists. Type-guard `type(UISpecialFrames) ~= "table"`. Dedup scan before append. `Hide()` / `lastPair` / QUIET forget unchanged. No close button. No `ShowUIPanel`. |
| `docs/reformation/vestments/briefs/B12-C-card-esc-report.md` | This file |
| `docs/reformation/vestments/briefs/B12-C-card-esc.diff` | B12-C-only unified diff of the exclusive implementation files vs the pre-lane baseline |

Did not edit Hud, Toasts, glue, TOC, bootstrap, `run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add Media files. Did not commit.

`git diff` vs HEAD on these two files also includes Batches 3–10 (working tree already dirty). The brief diff is the B12-C-only delta.

## Contract

```lua
FighterCard:Init()      -- builds once; rememberSpecial(FRAME_NAME)
FighterCard:Show()      -- live pair, Runtime subjects, or remembered pair while not QUIET
FighterCard:Hide()      -- dismisses the widget; does not forget lastPair
FighterCard:Refresh()   -- may restore while the event is live
FighterCard:GetView()   -- copy
FighterCard:ResetForTests()
```

Mode Event. Quiet / Hide / EndEvent still Hide. `health` stays nil.

### ESC (Classic FrameXML)

- Named frame is already `ChurchOfBeefFighterCard`.
- `rememberSpecial` type-guards a missing `UISpecialFrames` table, then appends the name if it is not already present.
- Second `Init` (and a module rebuild `Init`) does not insert a second copy.
- ESC Hide()s the named widget. `FighterCard:Hide()` still dismisses without forgetting `lastPair` until QUIET.
- No close ✕ chrome. No `ShowUIPanel`. No sound on show/hide.

| Field | Source / form |
|-------|----------------|
| dock | LEFT of UIParent, clamped (B4-E; unchanged) |
| names | `GameFontHighlight` + stock Morpheus (unchanged). Class color on the name only |
| titles / records / H2H / stipulation | `GameFont*`. W–L and H2H paint as `1-0` (arabic) |
| honorific | Store human text. Empty / unlinked → Hide (B6-D; unchanged) |
| defenses | `Store:CountDefenses(id)` mute integer. Hide when 0 or missing (B8-C; unchanged) |
| persist | lastPair until QUIET (B10-C; unchanged). Hide dismisses; Refresh may restore |
| health | not on the card. No `UnitHealth` |

## TDD

1. Extended `tests/test_fighter_card.lua` first (`UISpecialFrames` source pin; once after Init; second Init no duplicate; missing-table type-guard; rebuild no duplicate; no close mark). Isolation wrap stayed. Existing Hide / persist / 1-0 / health-nil pins untouched.
2. Red: `lua tests/test_fighter_card.lua` — **443 passed, 5 failed** (the four registration pins plus the source pin).
3. Implemented `rememberSpecial` + `Init` register in `FighterCard.lua`.
4. Green: `lua tests/test_fighter_card.lua` — **448 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_fighter_card.lua   # 448 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_fighter_card.lua` standalone | **448 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 17 pins under `if standalone then` (Net, UI, Toasts, DB, Officer, Archive, Recognition, Sender, Codec, Snapshot, Knighting, Minimap, Console, Hud, Sound, Decree, Records Book). Wrap unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Quiet / Hide / EndEvent still Hide. `health` stays nil. No close button.
- Source has `UISpecialFrames`. Source has no `UnitHealth`, `COMBAT_LOG`, `NamePlate`, `PlaySound`, `ShowUIPanel`, `StatusBar`, `Toasts`, `Media\\`, `.tga`, `.blp`, `✕`, `rubber`, `ordained`.
- Painted rematch record and H2H stay `1-0`. LEFT dock and Morpheus names stay.
- `GetView` is still a copy. Isolation asserts stay under `if standalone then`.
- Card does not write Store or Gora. `Hide()` does not call `forgetPersist`.

## Concerns

- **No client smoke.** ESC dismiss is FrameXML `CloseSpecialWindows` on the named widget. The harness pins registration and dedupe, not a live Escape key. **POLISH:CANDIDATE** only.
- **ESC Hide()s the widget, not `FighterCard:Hide()`.** Classic iterates `UISpecialFrames` and calls the frame's `Hide()`. `lastView.shown` may stay true until the next `Refresh` / `FighterCard:Hide()`. `lastPair` still remains until QUIET (existing pin). This lane did not add an `OnHide` hook (B12-D does, on Proclaim).
- **Type-guard is a no-op.** If `UISpecialFrames` is missing at Init, the name is not queued. A later-created table is not backfilled until another Init.
- **A01 still NOT RUN.** `health` is nil. No `UnitHealth`.
- **Hud / Toasts / glue were not edited.** HUD ESC and Proclaim `OnHide` stay those lanes.
- Integrator still lists the files in the TOC and `run.lua` (already listed).

## Status

**DONE_WITH_CONCERNS.** Isolated **448 / 0**. Isolation wrap **17**. Not signed. **POLISH:CANDIDATE.**
