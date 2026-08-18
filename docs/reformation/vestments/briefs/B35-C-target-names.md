# B35-C — keepLastUnits also keeps fighter names

**Exclusive:** `addon/ChurchOfBeef/UI/Markers.lua`, `tests/test_markers.lua`

**Do not edit** glue, Hud, Console. Do not commit. No `UnitIsDead`. Do not call `Markers:Clear` from Target.

## Law

Bible §8 current-subject marks. Anniversary `TargetUnit([name], [exactMatch])`. B34-C `keepLastUnits` copies omitted units/indices. Successful Target still `remember({ verb, ok, name = trimmed })`, so `remember` nils omitted `nameA` / `nameB`. After MarkFighters, Target keeps units and drops fighter names.

`keepLastUnits` also copies omitted `nameA` / `nameB` (`== nil`). Target success still sets `name = trimmed` (who was targeted). Do **not** merge name vs unit. Mark* / Clear success still replace. First Quiet refuse stays empty names.

## Tests

After the B34-C block. Source pin: `keepLastUnits` copies `last.nameA` / `last.nameB` when omitted. MarkFighters pair + Target: GetView keeps `nameA` / `nameB` and `unitA` / `unitB`; `name` is the targeted name. MarkCandidate A + Target: `name` is the Target; prior `unit` stays. Isolation wrap stays.

`lua tests/test_markers.lua` exit 0.

Report `docs/reformation/vestments/briefs/B35-C-target-names-report.md` + diff.
