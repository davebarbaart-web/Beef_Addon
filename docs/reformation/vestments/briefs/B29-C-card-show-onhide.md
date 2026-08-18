# B29-C — Fighter card Show / Refresh restore a missing OnHide

**Exclusive:** `addon/ChurchOfBeef/UI/FighterCard.lua`, `tests/test_fighter_card.lua`

**Do not edit** Hud, glue. Do not commit. No `UnitHealth`. No close button. lastPair until QUIET stays. `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`.

## Law

B28 leftover: `Show` / `Refresh` skip a niled OnHide when the frame already exists. Glue that remounts only via Show / Refresh would drop ESC lastView sync.

When the frame exists, `Show` and `Refresh` call `wireCardOnHide(frame)`. Do **not** replace an existing script. Do not rebuild. Init remount stays.

## Tests

Nil the OnHide, Show: script restored. Nil again, Refresh: restored. Third Show with the script already set: identity stays. Existing persist / health-nil / Morpheus / B28-D Init pins stay. Isolation wrap stays.

`lua tests/test_fighter_card.lua` exit 0.

Report `docs/reformation/vestments/briefs/B29-C-card-show-onhide-report.md` + diff.
