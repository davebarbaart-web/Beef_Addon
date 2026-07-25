# Annotated URLs — Track 73

Primary sources for desktop Lua testing / CI. Prefer these when revisiting harness or Actions choices.

Steal/adapt notes are for **Church of Beef offline unit tests**, not in-game QA (see [19 annotated-urls](../19-testing-debugging-qa/annotated-urls.md)).

---

## Design truth (repo)

| URL / path | Why it matters |
|------------|----------------|
| [`docs/superpowers/plans/2026-07-25-church-of-beef-v1.md`](../../../superpowers/plans/2026-07-25-church-of-beef-v1.md) Task 1–5 | Locked `wow_stub` / `run.lua` / `dofile` suites; Lua 5.1 preference; Officer injection |
| [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §13 / §13.1 | Success criteria + two-character verification — desktop tests cannot close this |
| [Track 34 — beef-v1-architecture](../34-lua-module-architecture/beef-v1-architecture.md) | “Core never CreateFrame”; layers that keep `dofile` viable |
| [Track 34 — aceaddon-modules-vs-namespaces](../34-lua-module-architecture/aceaddon-modules-vs-namespaces.md) | Plain namespace wins for offline scoring tests |
| [Track 19 — README](../19-testing-debugging-qa/README.md) | In-game QA boundary; spectacle vs unit tests |
| [Track 33 — GitHub Actions packager](../33-packager-ci-releases/03-github-actions.md) | Release job shape — keep unit tests separate |

---

## busted / luassert

| URL | Annotation |
|-----|------------|
| [https://github.com/lunarmodules/busted](https://github.com/lunarmodules/busted) | Canonical runner; Lua ≥ 5.1; ships `lunarmodules/busted@v0` Action; TAP/JSON for CI |
| [https://lunarmodules.github.io/busted/](https://lunarmodules.github.io/busted/) | Docs: describe/it, `.busted` config, standalone `require 'busted.runner'()`, spies/stubs/mocks |
| [https://github.com/lunarmodules/luassert](https://github.com/lunarmodules/luassert) | Assertion + spy/stub/mock library used by busted |
| [https://luarocks.org/modules/lunarmodules/busted](https://luarocks.org/modules/lunarmodules/busted) | Install channel: `luarocks install busted` |
| [https://stackoverflow.com/questions/23377991/testing-lua-script-with-busted](https://stackoverflow.com/questions/23377991/testing-lua-script-with-busted) | Practical `_G` mock + `dofile` + spy pattern (FreeSWITCH; same shape as WoW chunks) |

**Steal:** spy/mock vocabulary if Beef migrates off homemade asserts.  
**Avoid for V1:** mandating LuaRocks for five simple suites.

---

## WoW-specific harnesses

| URL | Annotation |
|-----|------------|
| [https://github.com/Jaliborc/WoWUnit](https://github.com/Jaliborc/WoWUnit) | In-game unit-test addon; event-triggered suites; temporary mocks — client-side, not desktop CI |
| [https://www.curseforge.com/wow/addons/wowunit](https://www.curseforge.com/wow/addons/wowunit) | Older Feithar WoWUnit listing (2014) — historical only |
| [https://github.com/shrugal/PersoLootRoll](https://github.com/shrugal/PersoLootRoll) | Documents CLI `lua Test.lua` + in-game WoWUnit dual path |
| [https://raw.githubusercontent.com/shrugal/PersoLootRoll/master/Test.lua](https://raw.githubusercontent.com/shrugal/PersoLootRoll/master/Test.lua) | **Reference fat mock:** TOC/XML loader, CreateFrame+FireEvent, C_* stubs, `os.exit` |
| [https://www.reddit.com/r/wowaddons/comments/dfgkba/tool_run_automated_tests_on_the_command_line/](https://www.reddit.com/r/wowaddons/comments/dfgkba/tool_run_automated_tests_on_the_command_line/) | Author announcement of the PersoLootRoll CLI harness |
| [https://us.forums.blizzard.com/en/wow/t/saved-variables-and-lua/1194561](https://us.forums.blizzard.com/en/wow/t/saved-variables-and-lua/1194561) | Practitioner: stub WoW APIs with matching I/O shape for structural tests |

**Steal:** dual-path idea; minimal stub philosophy from the forum post.  
**Avoid:** copying PersoLootRoll’s entire mock into Beef V1.

---

## Lua version & desktop interpreter

| URL | Annotation |
|-----|------------|
| [https://wowpedia.fandom.com/wiki/Introduction_to_Lua](https://wowpedia.fandom.com/wiki/Introduction_to_Lua) | States WoW uses Lua 5.1; desktop Lua Demo / local install for practice |
| [http://lua-users.org/wiki/WorldOfWarcraft](http://lua-users.org/wiki/WorldOfWarcraft) | Historical note: local Lua 5.1 distributions for addon work |

**Steal:** pin CI to 5.1.  
**Avoid:** assuming 5.4-only syntax in Core.

---

## GitHub Actions for Lua / lint

| URL | Annotation |
|-----|------------|
| [https://leafo.net/guides/testing-lua-modules-with-github-actions.html](https://leafo.net/guides/testing-lua-modules-with-github-actions.html) | **Primary CI recipe:** `leafo/gh-actions-lua` + `gh-actions-luarocks` + busted; matrix versions |
| [https://github.com/xpol/setup-lua](https://github.com/xpol/setup-lua) | Alternate Action; example installs busted via luarocks with `lua-version: "5.1.5"` |
| [https://www.wowaddondev.guide/docs/publishing-cicd](https://www.wowaddondev.guide/docs/publishing-cicd) | Lint workflow (`nebularg/actions-luacheck`) + `.luacheckrc` `std = "lua51"` + WoW globals — complementary to unit tests |
| [https://github.com/Jayrgo/wow-luacheckrc](https://github.com/Jayrgo/wow-luacheckrc) | Generated comprehensive WoW `.luacheckrc` |
| [https://github.com/BigWigsMods/packager/wiki/GitHub-Actions-workflow](https://github.com/BigWigsMods/packager/wiki/GitHub-Actions-workflow) | Release workflow — **not** a unit-test job; keep separate ([33](../33-packager-ci-releases/)) |

**Steal:** leafo 5.1 job for `lua tests/run.lua`; optional luacheck sibling.  
**Avoid:** folding Core tests into packager `@v2` args.

---

## Raw research artifacts

JSON/search dumps from this pass live under [`.raw/`](.raw/):

| File | Content |
|------|---------|
| [`.raw/search-desktop-lua-testing.json`](.raw/search-desktop-lua-testing.json) | busted, WoWUnit, PersoLootRoll, WowAddonDevGuide |
| [`.raw/search-harness-ci.json`](.raw/search-harness-ci.json) | PersoLootRoll CLI, busted Action, stubs forum |
| [`.raw/search-lua51-ci.json`](.raw/search-lua51-ci.json) | Lua 5.1, leafo guide, setup-lua |

Prefer the annotated links above when citing in other docs.
