# B39-B — FighterCard Show / Refresh remount rememberSpecial

**Exclusive:** `addon/ChurchOfBeef/UI/FighterCard.lua`, `tests/test_fighter_card.lua`

**Do not edit** glue, Hud, MainFrame. Do not commit. No `PlaySound`. Do not forget `lastPair` on remount.

## Law

Wiki: ESC closes a **named** frame on `UISpecialFrames`. `FRAME_NAME` is `ChurchOfBeefFighterCard`. Hide remounts `rememberSpecial` (B37-C). Show / Refresh already remount `wireCardOnHide` but skip `rememberSpecial`, so a wiped list stays idle until Hide.

Existing-frame Show and Refresh: remount `rememberSpecial(FRAME_NAME)` (and keep `wireCardOnHide`). Do **not** reset `lastPair`. No OnShow re-wire. No rebuild. No `PlaySound` / `IG_CHARACTER_INFO_*`.

## Tests

Nest `runB39B()` after `runB37C()`. Wipe list, Show: `ChurchOfBeefFighterCard` re-listed once. Wipe list, Refresh: re-listed once. Isolation wrap stays.

`lua tests/test_fighter_card.lua` exit 0.

Report `docs/reformation/vestments/briefs/B39-B-card-remember-report.md` + diff.
