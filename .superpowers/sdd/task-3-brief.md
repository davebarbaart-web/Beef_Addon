## Task 3: Slash honesty + console gate

**Files:** `ChurchOfBeef.lua`; `UI/Console.lua`; `tests/test_wire_glue.lua`; `tests/test_console.lua`

- [ ] **Pin (invert):** `test_wire_glue.lua` currently pins unknown args toggling the card. Unknown args print help (or a one-line refuse), they do not `PlayerCard:Toggle`.
- [ ] `/beef help` one chat line: bull / `/beef` = your name; night = Ask to fight, then pick a side when two names appear. Do not advertise `/beef console` to congregation.
- [ ] If `Sender:IsRegisteredPope(UnitName("player"))`, a second chat line may say the desk is `/beef console`.
- [ ] Gate `Console:Show` for non-Popes **before** `Init()` builds the 560×600 desk. Existing `test_console.lua` `Show()` paths need `stubPope()` — that suite’s header forbids slash tests.
- [ ] Verbs already refuse `not a registered pope`. Keep that string.

