# Task 1 report — Boot safety

**Status:** DONE (no commit; David has not asked)

**Implemented**
- `initUi` now routes every UI module through `initModule` / `pcall`.
- Failed Init prints one chat line via the existing Church of Beef prefix: `<Module> failed to start.`
- `OnLogin` still always reaches `Net:Init` / `InstallWire`.
- BackdropTemplate inherit on Hud and Inputs left in place (no live 20506 abort).

**Tests**
- `lua tests/run.lua` — 15998 passed, 0 failed, exit 0
- New: throwing Hud.Init still Inits later modules, Net, InstallWire; chat contains `Hud failed to start.`
- New: Hud source pin for `CreateFrame(..., "BackdropTemplate")`

**Files**
- `addon/ChurchOfBeef/ChurchOfBeef.lua`
- `tests/test_wire_glue.lua`
- `tests/test_hud.lua`

**Concerns**
- None. Did not drop BackdropTemplate.
