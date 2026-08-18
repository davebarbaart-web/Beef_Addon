# B28-D — Fighter card Init restores a missing OnHide (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Wiki ESC / UIHANDLER OnHide (do **not** PlaySound `IG_CHARACTER_INFO_*`); Bible §10.6 (mute tape), §10.7 (persist through the verdict beat); Law 6 / §19.1 (Quiet Mode hides Event chrome); Law 10 / §19.3 (theatrical card, no close ✕); brief `docs/reformation/vestments/briefs/B28-D-card-onhide.md`. B13-B create-path OnHide syncs `lastView` then `paintHidden` unless `hiding`. Init remounted ESC (`rememberSpecial`) but never restored a missing OnHide. B10-C lastPair until QUIET stays. B20-C `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`. Exclusive files only. No commit. Lane is not signed.

On Init, if the frame exists and `GetScript("OnHide")` is nil, `wireCardOnHide(widget)` wires the same handler as `build()`. An existing script is not replaced. The widget is not rebuilt. Create-path `Hide()` then calls the same helper.

**Isolated count:** 528 passed, 0 failed (`lua tests/test_fighter_card.lua`). **17** isolation pins under `if standalone then`. Nested `runB28D()` after the rebuild pins (Lua 5.1 200-local nest; no new main-chunk pin block).

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_fighter_card.lua` | TDD first. Nested `runB28D()` after the rebuild pins. Source: `wireCardOnHide`; Init / create-path call the helper and do not `SetScript("OnHide"` inline. Nil the OnHide, second Init restores; third Init keeps identity; CreateFrame stays 0; restored fire still sets `lastView.shown` false and Refresh paints lastPair. Existing persist / OnHide lastView / health-nil / Morpheus pins stay. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/FighterCard.lua` | Extracted `wireCardOnHide(widget)`. Create-path and Init both call it. Wires only when `GetScript("OnHide")` is nil. Same handler: `lastView = hiddenView()`, then `paintHidden` unless `hiding`. Does not replace an existing script. Does not rebuild. No `UnitHealth`. No close button. No `PlaySound`. |
| `docs/reformation/vestments/briefs/B28-D-card-onhide-report.md` | This file |
| `docs/reformation/vestments/briefs/B28-D-card-onhide.diff` | B28-D-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Hud, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add a close button. Did not add `UnitHealth`. Did not commit.

`git diff HEAD` on these two files also includes earlier fighter-card batches (working tree already dirty). The brief diff is the B28-D-only delta.

## Contract

```lua
FighterCard:Init()      -- builds once; wireCardOnHide; rememberSpecial; Refresh
FighterCard:Show()      -- live pair, Runtime subjects, or remembered pair while not QUIET
FighterCard:Hide()      -- paintHidden; does not forget lastPair
frame:Hide() / OnHide   -- lastView.shown = false; lastPair remains
FighterCard:Refresh()   -- may restore while the event is live
FighterCard:GetView()   -- copy
FighterCard:ResetForTests()
```

Mode Event. Quiet / Hide / EndEvent still Hide. `health` stays nil.

| Surface | Role |
|---------|------|
| `Init` | If `frame` is nil, `build()`. Then `wireCardOnHide(frame)`, `rememberSpecial`, `Refresh`. |
| `wireCardOnHide` | If `GetScript("OnHide")` is nil, wire `lastView = hiddenView()` then `paintHidden` unless `hiding`. Do not replace an existing script. |
| Create path | `widget:Hide()` then the same helper. |
| Missing OnHide remount | `SetScript("OnHide", nil)` then second Init restores the handler. Third Init keeps identity. No `CreateFrame`. |
| Restored OnHide | Still sets `lastView.shown` false. Still does not forget `lastPair`. Refresh while the event is live still paints. |
| ESC | `UISpecialFrames` stays. Second Init still does not duplicate the name. |
| Persist | lastPair until QUIET. |
| Names | `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`. |
| Health | nil. No `UnitHealth`. |
| Sound | None. Source has no `PlaySound`. |
| Close | No close button. No ✕. |

### Unchanged

- lastPair until QUIET. ASSEMBLY after QUIET does not revive.
- OnHide lastView sync / `hiding` guard (B13-B).
- `NAME_FONT` `Fonts\\MORPHEUS.ttf`. No `MORPHEUS_CYR`.
- No `UnitHealth`. No close button. No `PlaySound`.
- Isolation wrap. New test locals live in `runB28D()`.

## TDD

1. Extended `tests/test_fighter_card.lua` first (`runB28D()` nested after the rebuild pins: `wireCardOnHide` source; Init / create-path call the helper; nil OnHide then second Init restores; third Init identity stays; restored fire still syncs `lastView` and Refresh paints lastPair). Isolation wrap and existing persist / OnHide / health-nil / Morpheus pins untouched.
2. Red: `lua tests/test_fighter_card.lua` — **514 passed, 14 failed** (`wireCardOnHide` missing; Init / create-path still inline `SetScript`; niled OnHide stayed nil after second Init; fire false; lastView stayed shown). Existing persist / OnHide lastView / health-nil / Morpheus / isolation pins stayed green.
3. Extracted `wireCardOnHide(widget)`. Create-path and Init both call it. Existing script is not replaced. Widget is not rebuilt.
4. Green: `lua tests/test_fighter_card.lua` — **528 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_fighter_card.lua   # 528 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_fighter_card.lua` standalone | **528 passed, 0 failed.** Lua 5.1. Exit 0. |

**Isolated count:** 528 passed, 0 failed. Isolation wrap stays (**17** nil pins at file load). Wrap pattern unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Hud / glue / TOC not edited.
- Init restores a missing OnHide via the same helper as `build()`. An existing script is not replaced. No rebuild.
- Restored OnHide still syncs `lastView` without `forgetPersist`. Refresh while the event is live still paints Chuckroast / Tendermage. `health` stays nil.
- `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`. No `PlaySound`. No close button. No `UnitHealth`.
- `runB28D()` is nested after the rebuild pins. Isolation wrap stays.

## Leftovers

- **No client smoke.** A live remount that dropped the handler is simulated by `SetScript("OnHide", nil)`. Anniversary ESC vs `CloseSpecialWindows` order is unproven.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Harness `Hide()` / `stub.fire` is a direct call**, not a real ESC key. Script identity and lastView sync are pinned; the client's special-frame walk is not.

## Status

**DONE_WITH_CONCERNS.** Isolated **528 / 0**. Isolation wrap **17**. Not signed. No Gate / **POLISH:PASS** claim. Gate W stays OPEN. Gate V stays OPEN.
