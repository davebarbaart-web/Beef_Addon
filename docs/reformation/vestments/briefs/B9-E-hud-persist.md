# B9-E — HUD persists through the verdict

**Exclusive:** `addon/ChurchOfBeef/UI/Hud.lua`, `tests/test_hud.lua`

**Do not edit** Gora, FighterCard, Console. Do not commit. No `UnitHealth`. Favor W-F intact.

## Law

Bible §10.7: the HUD appears at sanction and **persists through the verdict beat**. The old pin “HUD hides when the pair clears, even mid-event” was a leftover from a lane that did not own persist.

Remember the last sanctioned pair. After `GetSanctioned()` is nil, if Runtime is still not QUIET, keep painting that pair (favor frozen on the last split). Hide on QUIET / EndEvent / no last pair. A new Sanction replaces the remembered pair.

Do not invent a verdict qualifier on the HUD. Health stays nil. Defense integers unchanged.

## Tests

Flip `HUD hides when the pair clears, even mid-event` → stays shown after DeclareVictor while the event is live; `shown == true`; favor still follows W-F. QUIET still hides. Isolation wrap stays.

`lua tests/test_hud.lua` exit 0. POLISH:CANDIDATE.

Report `docs/reformation/vestments/briefs/B9-E-hud-persist-report.md` + diff.
