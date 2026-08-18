# B4-F — HUD parchment name fields

**Exclusive:** `addon/ChurchOfBeef/UI/Hud.lua`, `tests/test_hud.lua`

**Do not edit** FighterCard, Console, Toasts, Gora, BeefNet. Do not commit. Stock only. A01 still NOT RUN — `health` stays nil. No `UnitHealth`. Favor contract unchanged (Pope from Gora, congregation from `SetBroadcastFavor` only).

## Law

Bible §10.7, §19.3. Batch 3 HUD-B polish: a **thin parchment field behind the name/title text**, iron-and-parchment, no extra row, no faction crest.

Add `nameFieldA` / `nameFieldB` textures (QuestBG, same `applyParchment` helper) sized to the name+title block on each side. Do not add StatusBars. Do not add a third favor widget. Keep mute rails as textures. Keep EmptySlot-White center ring.

W-F favor, PickFavor, SetFavorTarget, SetLocalCharacterId stay.

## Tests

Pin `frame.nameFieldA` / `nameFieldB` exist and use QuestBG (or the existing parchment fallback). `countStatusBars` stays 2. `health` nil. `healthReads` stay 0. Favor pins unchanged. Isolation wrap stays.

`lua tests/test_hud.lua` exit 0.

Report `docs/reformation/vestments/briefs/B4-F-hud-parchment-report.md` + diff. POLISH:CANDIDATE.
