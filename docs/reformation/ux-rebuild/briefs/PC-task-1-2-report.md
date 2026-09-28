# PC Tasks 1-2 Report

Status: DONE

## Per-File Changes

- `addon/ChurchOfBeef/Data/Ranks.lua`
  Added the Bible §5 `relationship` line to each of the six canonical ranks and added `COB.Ranks.Relationship(id)`.

- `tests/test_ranks.lua`
  Appended the Task 1 TDD assertions for the six relationship lines, `Relationship(id)`, and the absence of ladder/progress helpers.

- `addon/ChurchOfBeef/Core/Records.lua`
  Created the pure Core records keeper. Moved the existing superlative math helpers from `UI/RecordsBook.lua` verbatim, added canonical `TITLES`, and implemented `Pages()`, `Summary(characterId)`, and `HeldBy(characterId)`.

- `tests/test_records_core.lua`
  Created the standalone Task 2 suite covering module contract, empty-store behavior, superlatives, rivalry sorting, derived defenses, and copy semantics.

- `addon/ChurchOfBeef/UI/RecordsBook.lua`
  Removed the moved superlative helper functions, switched `PAGE_TITLES` to `COB.Records.TITLES`, and replaced local superlative computation with the Task 2 Core delegate.

- `addon/ChurchOfBeef/ChurchOfBeef.toc`
  Added `Core\Records.lua` immediately after `Core\Store.lua`.

- `tests/run.lua`
  Added `"test_records_core",` immediately after `"test_store",`.

- `tests/test_records.lua`
  Added `dofile("addon/ChurchOfBeef/Core/Records.lua")`, added the source pins proving superlative math left the book, and removed the stale `CountDefenses` source pin that no longer applies once the math lives in Core.

- `tests/preview_dump.lua`
  Added `dofile("addon/ChurchOfBeef/Core/Records.lua")` immediately after `dofile("addon/ChurchOfBeef/Core/Store.lua")`.

- `.superpowers/sdd/progress.md`
  Appended:
  `Plan Task 1: complete (harness 15660/0)`
  `Plan Task 2: complete (harness 15756/0)`

## Touched Suite Counts Before/After

- `tests/test_ranks.lua`
  Before implementation: harness failed after the new Task 1 assertions were added. Observed output: `FAIL: Relationship(id) exists expected function got nil`; suite aborted after 51 assertions; harness summary `15643 passed, 3 failed`.
  After implementation: harness summary `15660 passed, 0 failed`.

- `tests/test_records_core.lua`
  Before implementation: standalone run failed because `addon/ChurchOfBeef/Core/Records.lua` did not exist yet (`cannot open .../Core/Records.lua`), exit 1.
  After implementation: standalone summary `94 passed, 0 failed`.

- `tests/test_records.lua`
  During integration: one stale source pin failed after the Task 2 move (`FAIL: page prefers Store:CountDefenses expected true got false`); harness summary `15756 passed, 1 failed`.
  After pin update: harness summary `15756 passed, 0 failed`.

- `tests/run.lua` suite list
  Before Task 2: `test_records_core` was not listed.
  After Task 2: `test_records_core` is listed immediately after `test_store` and the harness runs green.

## Final Command Outputs

### `lua tests/run.lua`

```text
|cffffaa00Church of Beef|r: a guildmate is running BeefNet v2; this client speaks v1. Update for matching addon messages.
Tests finished: 15756 passed, 0 failed
```

Exit code: `0`

### `lua tests/test_records_core.lua`

```text
Tests finished: 94 passed, 0 failed
```

Exit code: `0`

### `COB_PREVIEW_DIR=$(mktemp -d) lua tests/preview_dump.lua`

```text
wrote /var/folders/t9/lq2vsknx7d382pb6jn6r7xhh0000gp/T/tmp.S6FiWukqoq/theme.json
wrote /var/folders/t9/lq2vsknx7d382pb6jn6r7xhh0000gp/T/tmp.S6FiWukqoq/decree.json (25 widgets)
A Beef Gora is Sanctioned
Chuckroast
VS
Tendermage
Come as you are
wrote /var/folders/t9/lq2vsknx7d382pb6jn6r7xhh0000gp/T/tmp.S6FiWukqoq/proclaim_sanction.json (21 widgets)
Victor declared: Chuckroast. So ruled by the Beef Pope.
wrote /var/folders/t9/lq2vsknx7d382pb6jn6r7xhh0000gp/T/tmp.S6FiWukqoq/proclaim_victor.json (21 widgets)
Cowardice recorded: Tendermage. So ruled by the Beef Pope.
wrote /var/folders/t9/lq2vsknx7d382pb6jn6r7xhh0000gp/T/tmp.S6FiWukqoq/proclaim_cowardice.json (20 widgets)
RISE, BEEF KNIGHT
Chuckroast
wrote /var/folders/t9/lq2vsknx7d382pb6jn6r7xhh0000gp/T/tmp.S6FiWukqoq/proclaim_knighting.json (23 widgets)
wrote /var/folders/t9/lq2vsknx7d382pb6jn6r7xhh0000gp/T/tmp.S6FiWukqoq/fightercard.json (32 widgets)
wrote /var/folders/t9/lq2vsknx7d382pb6jn6r7xhh0000gp/T/tmp.S6FiWukqoq/hud.json (28 widgets)
wrote /var/folders/t9/lq2vsknx7d382pb6jn6r7xhh0000gp/T/tmp.S6FiWukqoq/event_inputs.json (7 widgets)
wrote /var/folders/t9/lq2vsknx7d382pb6jn6r7xhh0000gp/T/tmp.S6FiWukqoq/dashboard.json (50 widgets)
wrote /var/folders/t9/lq2vsknx7d382pb6jn6r7xhh0000gp/T/tmp.S6FiWukqoq/records.json (44 widgets)
wrote /var/folders/t9/lq2vsknx7d382pb6jn6r7xhh0000gp/T/tmp.S6FiWukqoq/records_empty.json (33 widgets)
wrote /var/folders/t9/lq2vsknx7d382pb6jn6r7xhh0000gp/T/tmp.S6FiWukqoq/console.json (58 widgets)
wrote /var/folders/t9/lq2vsknx7d382pb6jn6r7xhh0000gp/T/tmp.S6FiWukqoq/minimap.json (5 widgets)
preview_dump finished: 13 scenarios at 1024x768
```

Exit code: `0`
