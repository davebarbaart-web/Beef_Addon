# B33-C — Gate refuse keeps remembered mark units

**Exclusive:** `addon/ChurchOfBeef/UI/Markers.lua`, `tests/test_markers.lua`

**Do not edit** glue. Do not commit. No `UnitIsDead`. No `Markers:Clear` from refuse. `clearPrior` stays.

## Law

B32-D leftover: `refuse` → `remember` replaces `last`, so a Ghost miss after Chuckroast drops `last.unit`. Tendermage mark cannot clear Chuckroast.

`refuse`: copy `last.unit` / `last.unitA` / `last.unitB` (and their indices) onto fields when the caller omitted them. Then `remember`. Successful Mark* still replace last. Successful `Clear` still records Clear. Quiet / not-pope / ungrouped refuse of a **first** mark (no prior last) stays empty units. No combat automation.

## Tests

MarkCandidate A, MarkCandidate Ghost (unit not found): `GetView().unit` still A's token. MarkCandidate B then spies `{A, 0}` then `{B, 1}`. First Quiet refuse still has no unit. Existing clearPrior / player-token pins stay.

`lua tests/test_markers.lua` exit 0.

Report `docs/reformation/vestments/briefs/B33-C-markers-keep-report.md` + diff.
