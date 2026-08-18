# B28-D — Fighter card Init restores a missing OnHide

**Exclusive:** `addon/ChurchOfBeef/UI/FighterCard.lua`, `tests/test_fighter_card.lua`

**Do not edit** Hud, glue. Do not commit. No `UnitHealth`. No close button. lastPair until QUIET stays. `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`.

## Law

Wiki ESC / UIHANDLER OnHide. Create-path OnHide syncs `lastView` then `paintHidden` unless `hiding`. Init remounts ESC but never restores a missing OnHide.

On Init, if the frame exists and `GetScript("OnHide")` is nil, wire the **same** handler as `build()`. Do **not** replace an existing script. Do not rebuild. Extract `wireCardOnHide(widget)` if that avoids duplication.

## Tests

Nil the OnHide, second Init: script is restored. Third Init with the script already set: identity stays. Existing persist / OnHide lastView / health-nil / Morpheus pins stay. Isolation wrap stays.

`lua tests/test_fighter_card.lua` exit 0.

Report `docs/reformation/vestments/briefs/B28-D-card-onhide-report.md` + diff.
