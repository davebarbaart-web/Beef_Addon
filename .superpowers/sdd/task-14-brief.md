## Task 14: Pope desk (Thedave can run the night)

**Files:** `UI/Console.lua`; `UI/PlayerCard.lua`; `ChurchOfBeef.lua`; `tests/test_console.lua`; `tests/test_player_card.lua`

**Depends on:** Tasks 3, 5, 6. Do not start while those own the same files.

### Pins

- Desk door: listed Pope card has a control that `Console:Show`s, **or** `/beef` help already told him. Bare `/beef` on Thedave must not look like a failed kit.
- `PHASE_HINT` names the next verb (spec #102). No wizard.
- `after()` paints refuse strings on `GateStatus` (or target line). End-during-RITE is visible.
- Petition row fills the next empty Fighter A/B, or the row reads “use this petitioner.” No auto-sanction.
- Pair name buttons select subject only. `DECLARE VICTOR` is the commit. Invert any pin that `DeclareVictor`s from `PairVictorA`.
- Unsigned petition names from Task 6 appear in the strip.

No commit. No congregation desk mint (Task 3 gate stays). `lua tests/run.lua` exit 0.
