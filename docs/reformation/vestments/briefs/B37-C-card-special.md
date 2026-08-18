# B37-C — FighterCard Hide remounts UISpecialFrames membership

**Exclusive:** `addon/ChurchOfBeef/UI/FighterCard.lua`, `tests/test_fighter_card.lua`

**Do not edit** glue, Hud. Do not commit. No `PlaySound`. No drag persist. lastPair until QUIET stays.

## Law

Wiki: ESC needs a **named** frame on `UISpecialFrames`. `FRAME_NAME` is `ChurchOfBeefFighterCard`. `Hide` (~605–609) remounts `wireCardOnHide` only. `rememberSpecial` is Init-only (~556). Wiped list + Hide-only leaves ESC idle until Init.

Existing-frame `Hide`: `rememberSpecial(FRAME_NAME)` then existing OnHide remount + `paintHidden()`. Never replace an existing OnHide. No OnShow re-wire. No rebuild. No `PlaySound` / `IG_CHARACTER_INFO_*`. lastPair until QUIET stays.

## Tests

Nest after `runB30B()` inside `runB28D()`. Source pin: Hide body calls `rememberSpecial` before `paintHidden`. Wipe `UISpecialFrames`, Hide: `ChurchOfBeefFighterCard` re-listed once. Third Hide does not duplicate. Isolation wrap stays.

`lua tests/test_fighter_card.lua` exit 0.

Report `docs/reformation/vestments/briefs/B37-C-card-special-report.md` + diff.
