# Track 73 — Desktop Lua testing / dofile / CI unit tests

**Track id:** `73-desktop-lua-testing`  
**Last updated:** 2026-07-25  
**Sole focus:** How Classic addon authors unit-test **pure Lua outside the client** — `dofile` harnesses, busted/luassert, mock WoW APIs, and GitHub Actions unit-test jobs — plus what Church of Beef **Core/Data** can prove offline vs what must stay in-game.  
**Out of scope:** In-game QA (BugSack, alpha channels, multi-client guild labs, combat lockdown, spectacle pass criteria) → [19-testing-debugging-qa](../19-testing-debugging-qa/). Packager/release CI → [33-packager-ci-releases](../33-packager-ci-releases/). Module layout that *enables* offline tests → [34-lua-module-architecture](../34-lua-module-architecture/). No addon implementation in this folder.

## Product truth (from V1 plan + track 34)

| Locked default | Value |
|----------------|-------|
| Interpreter | Lua **5.1** preferred (WoW); 5.4 OK for pure-logic suites per plan |
| Harness (plan) | `tests/wow_stub.lua` + `tests/run.lua` + `dofile` of Data/Core |
| Architecture | Plain `COB` tables; Core never `CreateFrame` |
| Suites named in plan | `test_ranks`, `test_ladder`, `test_scoring`, `test_officer`, `test_net_validate` |

Sources: [`docs/superpowers/plans/2026-07-25-church-of-beef-v1.md`](../../../superpowers/plans/2026-07-25-church-of-beef-v1.md) Task 1–5; [34 beef-v1-architecture](../34-lua-module-architecture/beef-v1-architecture.md).

## Index

| Note | Covers |
|------|--------|
| [ecosystem-harnesses.md](ecosystem-harnesses.md) | busted, luassert, WoWUnit, PersoLootRoll CLI, custom dofile runners |
| [mock-wow-apis.md](mock-wow-apis.md) | Minimal vs fat stubs; inject vs global mock |
| [offline-vs-ingame.md](offline-vs-ingame.md) | Beef Core/Data offline matrix vs must-be-in-game (boundary with 19) |
| [github-actions-unit-tests.md](github-actions-unit-tests.md) | Lua/LuaRocks Actions; lint vs unit vs packager jobs |
| [beef-v1-recommendation.md](beef-v1-recommendation.md) | Recommended V1 desktop test policy |
| [annotated-urls.md](annotated-urls.md) | Primary URLs with steal/adapt notes |

## Boundary with track 19

| This track (73) | Track 19 |
|-----------------|----------|
| Desktop `lua tests/run.lua` / busted | `/console scriptErrors`, BugSack |
| Mock roster / fake clocks / payload shapes | Two-client guild lab, offline sync scenarios |
| CI exit code on pure logic | Alpha channel, TOC flavor smoke, combat lockdown, spectacle |
| “Does Scoring clamp?” | “Does AFK at entrance really drip?” |

Do **not** treat a green CI suite as a substitute for §13.1 two-character verification or §13.11 spectacle.

## Top insights for Beef (read this first)

1. **The ecosystem’s real pattern is “thin stub + load Core,” not a full WoW emulator.** Authors either ship a tiny `wow_stub` (Beef plan), grow a fat mock that can fire `ADDON_LOADED`/`PLAYER_LOGIN` ([PersoLootRoll `Test.lua`](https://github.com/shrugal/PersoLootRoll)), or run tests *inside* the client ([WoWUnit](https://github.com/Jaliborc/WoWUnit)). Nobody reliably simulates Classic guild throttle or secure UI offline.

2. **busted + luassert are the general Lua industry tools; WoW authors often skip them.** [busted](https://github.com/lunarmodules/busted) (describe/it, spies/stubs/mocks via [luassert](https://github.com/lunarmodules/luassert)) is excellent for pure modules and has a first-party GitHub Action. Beef’s plan already chose a **zero-dep** `assert_eq` runner — that matches Classic-addon culture and CI simplicity. Adopt busted only if describe/it and spies earn their LuaRocks install cost.

3. **Injection beats global mock for Beef’s Officer/Net edges.** Plan already injects `rosterLookup` into `IsOfficerName` and keeps Net validation as pure string/table checks. Prefer that over stubbing `GetGuildRosterInfo` globally — stubs drift; injected fakes stay local to the test.

4. **Offline yes / in-game only is a hard split.** Data canon, ladder revisions, scoring caps, officer index thresholds, and message *shape* validation → desktop. Live `C_ChatInfo`, roster timing, combat lockdown, frame layout, BeefNet throttle, and spectacle → track 19.

5. **CI unit tests are a separate job from packager and Luacheck.** [leafo’s guide](https://leafo.net/guides/testing-lua-modules-with-github-actions.html) (`gh-actions-lua` + `gh-actions-luarocks` + busted) or a one-liner `lua tests/run.lua` after installing Lua 5.1. Luacheck ([WowAddonDevGuide lint workflow](https://www.wowaddondev.guide/docs/publishing-cicd)) catches undefined globals; it does not prove scoring math. Packager ([33](../33-packager-ci-releases/)) builds zips — do not fold unit tests into the release Action.

6. **Target Lua 5.1 in CI even if local 5.4 “works.”** WoW embeds Lua 5.1 ([Wowpedia Introduction to Lua](https://wowpedia.fandom.com/wiki/Introduction_to_Lua); [lua-users WoW page](http://lua-users.org/wiki/WorldOfWarcraft)). Pure tables usually agree across versions; `unpack`/`loadstring`/`setfenv` edges do not. Prefer `leafo/gh-actions-lua` with `luaVersion: "5.1"`.

## Recommended V1 policy (one line)

**Keep the plan’s zero-dep `dofile` + minimal stub; CI job = install Lua 5.1 + `lua tests/run.lua`; defer busted/WoWUnit; never claim offline coverage for Net transport or UI.**

Detail: [beef-v1-recommendation.md](beef-v1-recommendation.md).

## Provenance

Search/extract dumps under [`.raw/`](.raw/). Prefer V1 plan + track 34 for Beef truth; lunarmodules / leafo / PersoLootRoll / Jaliborc for ecosystem norms.
