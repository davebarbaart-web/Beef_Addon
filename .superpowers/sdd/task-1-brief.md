## Task 1: Boot safety

**Files:** `ChurchOfBeef.lua` `initUi`; `UI/Hud.lua`; `UI/Inputs.lua`; `tests/test_wire_glue.lua`; `tests/test_inputs.lua`

- [ ] **Pin:** every `Init` in `initUi` is inside `pcall`. After a forced Hud Init failure, `Net:Init` still runs. One chat line `Church of Beef: <module> failed to start.`
- [ ] **Pin:** invert `test_inputs.lua` BackdropTemplate assert if you drop the inherit. Add a Hud source pin for `_template` / inherit string. The stub will not catch a client abort.
- [ ] Wrap Minimap, RecordsBook, PlayerCard, Hud, and every other Init. Always reach `Net:Init()`.
- [ ] On the live 20506 client: if `CreateFrame(..., "BackdropTemplate")` errors, drop the inherit. Do not claim the template is missing until that happens.
- [ ] `lua tests/run.lua` exit 0.

