# Task 3 report — Slash honesty + console gate

**Status:** DONE (no commit). Re-review after Critical fix: `Show`/`Toggle` always require `isRegisteredPope()`, including after login `Init`. Harness 16323/0.

**Implemented**
- Bare `/beef` still toggles the player card.
- `/beef help` prints one line: bull / `/beef` opens your name; night = Ask to fight, then pick a side when two names appear. No "Director Console."
- Listed Pope gets a second line: the desk is `/beef console`.
- Unknown args and retired petition/confess/catchup print help; they do not toggle the card.
- `Console:Show` / `Toggle` do not `Init` the 560×600 desk unless `isRegisteredPope()`. Existing suite Show paths that `Init` first still work. Verbs still refuse `not a registered pope`.

**Tests:** isolated console 2630/0; wire_glue 757/0; then full suite (see harness).

**Files:** ChurchOfBeef.lua, UI/Console.lua, tests/test_wire_glue.lua, tests/test_console.lua
