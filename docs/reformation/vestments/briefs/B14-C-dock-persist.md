# B14-C — ConsoleDock drag persist

**Exclusive:** `addon/ChurchOfBeef/UI/ConsoleDock.lua`, `tests/test_console_dock.lua`

**Do not edit** Console.lua, Hud, glue. Do not commit. Dock stays **stock** `BasicFrameTemplate`. No custom media. No `PlaySound`. Quiet hide stays. No CloseButton. Title stays exactly `DIRECTOR CONSOLE`.

## Law

Bible §18.1: collapsible movable Director Console. The dock already `SetMovable` + title-bar drag. It does not persist. Copy the HUD `savePoint` / `restorePoint` pattern (`addon/ChurchOfBeef/UI/Hud.lua`): whitelist `ANCHORS`, write `{ point, relativePoint, x, y }` to `ChurchOfBeefDB.ui.consoleDock`, never store a frame reference. Save on the title-bar `OnDragStop` after `StopMovingOrSizing`. Restore in `build()` before the default `SetPoint`. Invalid / missing saved point falls back to today's default: `BOTTOMLEFT`, `UIParent`, `16`, `80`.

Missing `ChurchOfBeefDB` → restore default; save no-ops. `ResetForTests` must not wipe SavedVariables. Event-only show/hide unchanged (`mayShow` = live event + registered Pope).

Anniversary: `StartMoving` / `StopMovingOrSizing` / `GetPoint` already used by HUD on this client. No `BackdropTemplate` requirement. No `OnUpdate`.

## Tests

Mirror `tests/test_hud.lua` drag-persist block, firing **TitleBar** `OnDragStop` (drag is on the title bar, not the root). Pin:

1. After move, `ChurchOfBeefDB.ui.consoleDock` has point/x/y and **no** `relativeTo`.
2. `dofile` ConsoleDock.lua + `Init` restores the saved point parented to `UIParent`.
3. Invalid saved point (`MIDDLE-OF-NOWHERE`) falls back to `BOTTOMLEFT` / x `16` / y `80`.
4. Quiet Init with a saved point still **hides**.
5. Existing pins: title, SANCTION + Expand, CloseButton hidden, no sound, no custom media.

`lua tests/test_console_dock.lua` exit 0.

Report `docs/reformation/vestments/briefs/B14-C-dock-persist-report.md` + diff.
