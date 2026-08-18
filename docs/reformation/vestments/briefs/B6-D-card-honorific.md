# B6-D — Mute fighter-card honorifics

**Exclusive:** `addon/ChurchOfBeef/UI/FighterCard.lua`, `tests/test_fighter_card.lua`

**Do not edit** Hud, Toasts, Console. Do not commit. Keep H2H/record as `1-0`. No UnitHealth. No generated flavor.

## Law

Bible §10.6: tale of the tape includes **relevant accolades**. Read `Store:GetCharacter(id).humanId` → `Store:GetHuman.honorifics`. Paint the first honorific as a mute line per plate (or join with ` · ` if you must show more than one — max 2). Empty → hide the widget. Never invent "Duke of …".

LEFT dock and MORPHEUS names stay.

## Tests

No honorifics → widget hidden. Seed Pope text → paints exactly that string. `1-0` pins stay. Isolation wrap stays.

`lua tests/test_fighter_card.lua` exit 0. POLISH:CANDIDATE.

Report `docs/reformation/vestments/briefs/B6-D-card-honorific-report.md` + diff.
