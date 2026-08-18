# B12-C — Fighter card ESC dismiss

**Exclusive:** `addon/ChurchOfBeef/UI/FighterCard.lua`, `tests/test_fighter_card.lua`

**Do not edit** Hud, glue, Toasts. Do not commit. Stock only. No close-button chrome. No `UnitHealth`. Hide-vs-forget stays: `Hide()` dismisses; lastPair remains until QUIET.

## Law

Classic FrameXML: put the named frame on `UISpecialFrames` so ESC Hide()s it (wiki: "Make frames closable with the Escape key"). Dedupe like Decree (`rememberSpecial`). Type-guard a missing table. Named frame is already `ChurchOfBeefFighterCard`.

Do not add a close ✕. Do not `ShowUIPanel`. Refresh after Hide still paints the remembered pair while the event is live (existing pin).

## Tests

After Init, `UISpecialFrames` contains `ChurchOfBeefFighterCard` once (second Init does not duplicate). Source contains `UISpecialFrames`. Existing Hide / persist / 1-0 / health-nil pins stay. Isolation wrap stays.

`lua tests/test_fighter_card.lua` exit 0. POLISH:CANDIDATE.

Report `docs/reformation/vestments/briefs/B12-C-card-esc-report.md` + diff.
