# B38-C — Quiet Forget sweeps leftover raid marks

**Exclusive:** `addon/ChurchOfBeef/UI/Markers.lua`, `tests/test_markers.lua`

**Do not edit** glue (integrator owns `afterEndEvent`). Do not commit. No `UnitIsDead`. Do not change Clear Quiet refuse.

## Law

Bible §8 current-subject marks. Anniversary `SetRaidTarget(target, userIndex)` — index `0` clears. `Clear` refuses Quiet. `clearPrior` only runs on new Mark\*. After End, leftover `last.unit` / `unitA` / `unitB` stay marked in the world.

Add `Markers:Forget()`. Works in Quiet. Pope-gated (same writer as Mark\*). `applyMark(unit, 0)` on leftover `last.unit` / `unitA` / `unitB`, then remember empty (`verb = "Forget"`, no units). Do **not** call `Markers:Clear`. Missing `SetRaidTarget` fail-closed. Mark\* / Clear success still replace.

## Tests

After the B35-C block. MarkCandidate A, EndEvent, Forget: spies `SetRaidTarget(A, 0)`, GetView units nil. MarkFighters pair, Forget: spies clear A and B. Quiet Forget without prior last is true and does not SetRaidTarget. Unlisted Pope refuses. Isolation wrap stays.

`lua tests/test_markers.lua` exit 0.

Report `docs/reformation/vestments/briefs/B38-C-mark-forget-report.md` + diff.
