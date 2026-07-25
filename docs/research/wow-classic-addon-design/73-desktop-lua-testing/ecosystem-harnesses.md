# Ecosystem harnesses — desktop & hybrid Lua tests

**Track:** [73-desktop-lua-testing](README.md)  
**Does not cover:** In-client BugSack / playtest culture → [19](../19-testing-debugging-qa/).

Classic authors use four overlapping patterns. Beef’s plan is pattern A; the others are steal/adapt options.

---

## A. Custom `dofile` + minimal stub (Beef plan; common DIY)

**Shape:**

1. `tests/wow_stub.lua` — define only globals Core touches (`CreateFrame` no-op, `DEFAULT_CHAT_FRAME`, `SlashCmdList`, …).
2. `tests/run.lua` — `require("wow_stub")`, define `assert_eq` / `assert_true`, `require` suite modules, `os.exit(1)` on failure.
3. Suites — `ChurchOfBeef = {}` then `dofile("addon/ChurchOfBeef/Data/Ranks.lua")` etc.

**Why authors like it:** No LuaRocks; runs with stock `lua` / `lua5.1`; matches TOC mental model (files mutate a global table). Blizzard-forum practice is the same idea: “stub functions for the WoW API calls that I use” with matching I/O shape ([Saved Variables and LUA](https://us.forums.blizzard.com/en/wow/t/saved-variables-and-lua/1194561)).

**Cost:** You reinvent describe/it, spies, and fixtures. Fine for Beef’s five plan suites.

**Plan source:** Task 1 Step 5 in [`2026-07-25-church-of-beef-v1.md`](../../../superpowers/plans/2026-07-25-church-of-beef-v1.md).

---

## B. busted + luassert (general Lua; rare but strong for pure modules)

| Piece | Role |
|-------|------|
| [busted](https://github.com/lunarmodules/busted) | `describe` / `it` / `pending`, CLI, TAP/JSON output for CI |
| [luassert](https://github.com/lunarmodules/luassert) | Chained asserts; **spy** / **stub** / **mock** (ships with busted) |

Docs: [lunarmodules.github.io/busted](https://lunarmodules.github.io/busted/). Supports Lua ≥ 5.1 and LuaJIT. Install: `luarocks install busted`.

**Typical WoW-shaped use** (same pattern as FreeSWITCH script tests): put mocks on `_G`, then `dofile` the addon chunk, then `assert.spy(...).was.called_with(...)` ([Stack Overflow — Testing lua script with busted](https://stackoverflow.com/questions/23377991/testing-lua-script-with-busted)).

**When to steal for Beef:** If Core grows many edge cases and maintainers want nested contexts / tags (`busted --tags=scoring`). Not required for V1 scaffold.

**CI:** First-party Action `uses: lunarmodules/busted@v0` ([busted README](https://github.com/lunarmodules/busted)), or leafo’s Lua + LuaRocks recipe ([Testing Lua projects with GitHub Actions](https://leafo.net/guides/testing-lua-modules-with-github-actions.html)).

---

## C. WoWUnit (in-game first; optional CLI host)

[Jaliborc/WoWUnit](https://github.com/Jaliborc/WoWUnit) is a **client-side** unit-test addon: suites run on game events, with temporary variable mocking and a monitor UI. CurseForge also has a historically separate “WoWUnit” project ([Feithar listing](https://www.curseforge.com/wow/addons/wowunit) — last update ~2014; treat as archive, not Classic V1 tooling).

**Steal:** Event-triggered suites for code that *must* see real frames.  
**Avoid for Beef V1 CI:** Requires the client (or a fat desktop mock that embeds WoWUnit — next section). Does not replace track 19 guild labs.

---

## D. Fat desktop mock + WoWUnit (PersoLootRoll)

[PersoLootRoll](https://github.com/shrugal/PersoLootRoll) documents: install Lua binary → `lua Test.lua` (or `-b` against a packager build); in-game path uses WoWUnit on login. The shared [Test.lua](https://raw.githubusercontent.com/shrugal/PersoLootRoll/master/Test.lua) (also discussed on [r/wowaddons](https://www.reddit.com/r/wowaddons/comments/dfgkba/tool_run_automated_tests_on_the_command_line/)):

- Parses `.toc` / `.xml` / `.lua` and `loadfile`s with `(addonName, ns)` like the client
- Implements a non-trivial `CreateFrame` (scripts, events, points, `FireEvent` / `FireUpdate`)
- Stubs `C_*` namespaces, `Unit*`, loot APIs, WoW string helpers (`strsplit`, `wipe`, …)
- Fires `ADDON_LOADED` → `PLAYER_LOGIN` → `PLAYER_ENTERING_WORLD`
- Runs `WoWUnit:RunTests(...)` and `os.exit` with status

**Steal:** TOC-aware loader and event firing if Beef ever tests bootstrap wiring offline.  
**Avoid for V1:** Thousands of lines of mock drift; Beef Core is designed *not* to need frames ([34](../34-lua-module-architecture/beef-v1-architecture.md)).

---

## Comparison (decision aid)

| Harness | Offline CI | Deps | Best for | Beef V1 |
|---------|------------|------|----------|---------|
| Custom dofile + tiny stub | Yes | None | Pure Core/Data | **Default (plan)** |
| busted + luassert | Yes | LuaRocks | Rich asserts / spies | Optional upgrade |
| WoWUnit in-game | No (client) | Addon | Frame/event code | Defer; use 19 instead |
| PersoLootRoll-style fat mock | Yes | Large DIY stub + WoWUnit | Full addon load | Avoid unless bootstrap tests demand it |

---

## Steal / adapt

- **Steal from plan:** suite list + `ResetForTests` + `_IN_TEST` flag for Scoring.
- **Steal from PersoLootRoll:** idea of dual path (CLI + optional in-game), not the mock bulk.
- **Steal from busted:** TAP reporter / Action only if/when you migrate off homemade asserts.
- **Adapt:** Keep Core loadable without LibStub so any of A–D stay possible ([34 aceaddon-modules-vs-namespaces](../34-lua-module-architecture/aceaddon-modules-vs-namespaces.md)).
