# B30-B — Fighter card Hide remounts a missing OnHide

**Exclusive:** `addon/ChurchOfBeef/UI/FighterCard.lua`, `tests/test_fighter_card.lua`

**Do not edit** Hud, glue. Do not commit. No `UnitHealth`. No close button. lastPair until QUIET stays. `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`.

## Law

B29 leftover: `Hide` still skips a niled OnHide. Glue that only Hide()s would drop ESC lastView sync.

When the frame exists, `Hide` calls `wireCardOnHide(frame)` before `paintHidden`. Do **not** replace an existing script. Do not rebuild. Show / Refresh / Init remount stay.

## Tests

Nest `runB30B()` after `runB29C()`. Nil the OnHide, Hide: script restored. Third Hide with the script already set: identity stays. Restored fire still sets `lastView.shown` false and does not forget lastPair. Existing persist / health-nil / Morpheus / B28-D Init / B29-C Show/Refresh pins stay. Isolation wrap stays.

`lua tests/test_fighter_card.lua` exit 0.

Report `docs/reformation/vestments/briefs/B30-B-card-hide-onhide-report.md` + diff.
