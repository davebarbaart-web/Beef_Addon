# B34-C — successful Target keeps last mark units

**Exclusive:** `addon/ChurchOfBeef/UI/Markers.lua`, `tests/test_markers.lua`

**Do not edit** glue, Hud, Console. Do not commit. No `UnitIsDead`. Do not call `Markers:Clear` from Target.

## Law

Bible §8 current-subject marks. Anniversary `TargetUnit([name], [exactMatch])`. B33-C `refuse` copies omitted `last.unit` / `unitA` / `unitB` (+ indices). Successful `Target` (`~210`) `remember({ verb, ok, name })` only, so `remember` replaces `last` wholesale and wipes the prior mark token. After MarkCandidate A → Target B → MarkCandidate C, `clearPrior` cannot clear A.

Successful Target `remember` keeps omitted `last.unit` / `unitA` / `unitB` (+ indices) with the same `== nil` copy as `refuse`. You may extract a small keep helper used by both refuse and Target success. MarkCandidate / MarkFighters / Clear success still replace. First Quiet refuse stays empty units. Failed Target still keeps (already refuse).

## Tests

After the B33-C block. Source pin: Target success path copies last units when omitted. Runtime StartEvent + Pope + `armRaid`: MarkCandidate A, successful Target of another name, GetView still has A's `unit` / `index`; then MarkCandidate B spies clearPrior of A. MarkFighters pair + Target keeps `unitA` / `unitB`. Successful Mark* / Clear still replace (B33-C pins stay). Isolation wrap stays.

`lua tests/test_markers.lua` exit 0.

Report `docs/reformation/vestments/briefs/B34-C-target-keep-report.md` + diff.
