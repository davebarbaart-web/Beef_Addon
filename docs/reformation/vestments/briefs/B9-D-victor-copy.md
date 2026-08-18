# B9-D — Victor clerical close

**Exclusive:** `addon/ChurchOfBeef/UI/Toasts.lua`, `tests/test_ui.lua`

**Do not edit** Console, HUD, Knighting. Do not commit. No new sound names. Quiet refuse stays.

## Law

Cowardice already closes “So ruled by the Beef Pope.” Batch 3 critique: the parchment voice is “Victor declared: Thickcut. So ruled by the Beef Pope.”

Change victor clerical copy (and the matching headline if it is the same string) to:

`Victor declared: <name>. So ruled by the Beef Pope.`

Void / free / sanction / knighting / elevation copy unchanged. No adjectives (“decisive”). No jokes. MORPHEUS headlines stay.

## Tests

Flip the pins that expect `Victor declared: Thickcut.` to the new close. Cowardice pin unchanged. Quiet still refuses Proclaim.

`lua tests/test_ui.lua` exit 0. POLISH:CANDIDATE.

Report `docs/reformation/vestments/briefs/B9-D-victor-copy-report.md` + diff.
