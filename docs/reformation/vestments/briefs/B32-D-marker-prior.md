# B32-D — New raid mark clears the previous subject

**Exclusive:** `addon/ChurchOfBeef/UI/Markers.lua`, `tests/test_markers.lua`

**Do not edit** glue, Console. Do not commit. No `UnitIsDead`. No combat automation. No GuildPromote. Anniversary `SetRaidTarget(unit, index)`; index `0` already clears (existing `Clear`). First Mark* with no prior memory still one spy.

## Law

Bible §8: marks on the **current** candidate / fighters. `MarkCandidate` / `MarkFighters` never clear the remembered prior unit. `Clear` already `applyMark(unit, 0)`.

Before a successful new mark, `applyMark` index `0` on remembered `last.unit` / `last.unitA` / `last.unitB` that are not in the new keep-set. Do **not** call `Markers:Clear` (it would overwrite `last` first). Same-unit remake does not clear-then-mark. Fail-closed gates stay (quiet / not pope / ungrouped / unit not found). `"player"` resolve stays. No SecureActionButton. Existing `pcall(SetRaidTarget, …)` stays.

## Tests

MarkCandidate A, then MarkCandidate B: spy includes `{unit=A, index=0}` then `{unit=B, index=1}`. Same-name remake: no extra 0 on that unit. MarkFighters after a candidate not in the pair clears the candidate. First mark still one spy. Existing Quiet / ungrouped / player-token pins stay.

`lua tests/test_markers.lua` exit 0.

Report `docs/reformation/vestments/briefs/B32-D-marker-prior-report.md` + diff.
