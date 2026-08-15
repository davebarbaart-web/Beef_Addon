# Phase 1 Sweep L — UI leftovers

Read: `docs/reformation/phase-0/TEN_LAWS.md`, `GATE1_DESIGN_LEAD_DIRECTIVE.md` §3a. Law 10.

## Exclusive files

- `addon/ChurchOfBeef/UI/MainFrame.lua`
- `addon/ChurchOfBeef/UI/Toasts.lua`
- `tests/test_ui.lua`
- `tests/test_minimap.lua` only if a toast/minimap assertion would abort
- Report: `docs/reformation/phase-1/reports/P1-L-ui-leftovers.md`

**Do not** edit Status.lua unless the joke footer was restored (it should already be empty). Do not edit TOC, Minimap (unless required), Roster.

## Mission

1. Cut the **dead tab registry** (`RegisterTab`, `ShowTab` product plumbing, officer-only tab chrome) and **`ClassColorCode`** (it walked `GetLadderView`). Keep drag / resize / coalesce / empty content host. `/beef` stays a tabless Quiet shell. Do not invent Director Console, Decree, or Event theater.
2. **Eternal Grazing.** must stay gone (Law 10).
3. Cut orphaned **promote / rite** toast copy builders and those `KINDS` if nothing live calls them. Keep the engine (`system` / `debug` and Push). Do not invent Event Mode kinds.

Rewrite `test_ui.lua` off the tab-registry probe. Isolated suite must pass.

## Do not git commit.
