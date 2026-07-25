# Annotated URLs — memory / FPS / profiling

Primary sources for track 54. Prefer these over SEO “see your addon memory” blogs when setting Beef budgets.

## Frame time & FPS

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://warcraft.wiki.gg/wiki/API_GetFramerate | Built-in FPS API; notes laggy response to sudden drops; points to `ToggleFramerate` (Ctrl-R). |
| https://wowpedia.fandom.com/wiki/API_GetFramerate | Mirror / historical notes for FPS display. |
| https://gaming.stackexchange.com/questions/339618/how-to-show-fps-in-world-of-warcraft | Player-facing: Toggle Framerate Display keybind location. |

## CPU / memory APIs

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://wowpedia.fandom.com/wiki/CVar_scriptProfile | **Canonical enable path:** `/console scriptProfile 1` + `/reload`; required for Lua CPU accounting. |
| https://warcraft.wiki.gg/wiki/Console_variables | Confirms `scriptProfile` default `0`, Debug category. |
| https://wowprogramming.com/docs/api/UpdateAddOnCPUUsage.html | States Update only works when `scriptProfile` is 1. |
| https://warcraft.wiki.gg/wiki/API_UpdateAddOnCPUUsage | Refresh CPU caches. |
| https://warcraft.wiki.gg/wiki/API_GetAddOnCPUUsage | Total ms per addon; **excludes** much WoW API time — interpret carefully. |
| https://warcraft.wiki.gg/wiki/API_GetFrameCPUUsage | Per-frame handler sums; **OnUpdate not included**. |
| https://warcraft.wiki.gg/wiki/API_GetAddOnMemoryUsage | KB per addon; needs `UpdateAddOnMemoryUsage` first. |
| https://warcraft.wiki.gg/wiki/API_UpdateAddOnMemoryUsage | Memory cache refresh (diagnostic only). |
| https://warcraft.wiki.gg/wiki/API_debugprofilestop | High-res ms timer for micro-benchmarks without leaving `scriptProfile` on. |

## OnUpdate / allocation hygiene

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://wowpedia.fandom.com/wiki/UIHANDLER_OnUpdate | OnUpdate cost scales with FPS; prefer timers / throttle. |
| https://us.forums.blizzard.com/en/wow/t/optimizing-cpu-usage/1366572 | Gello: `debugprofilestop`, event frequency, throttle-by-hide, avoid always-on OnUpdate. |
| https://www.wowinterface.com/forums/showthread.php?t=30520 | Historical memory-leak debugging culture (KB/hour). |

## Profiling addons

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://www.wowinterface.com/downloads/info7362-AddonUsage.html | **Classic-standard** mem+CPU UI; “optimize CPU not GC creep”; turn profiling off after tests. |
| https://www.curseforge.com/wow/addons/addon-usage | CurseForge distribution mirror for AddonUsage. |
| https://www.curseforge.com/wow/addons/numy-addon-profiler | Modern profiler UI; Classic/TBC flavors listed; warns against old `scriptProfile` scrapers — verify Anniversary API before relying on it. |
| https://github.com/NumyAddon/AddonProfiler | Source for Numy AddonProfiler. |

## Context (memory culture, not hard limits)

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://us.forums.blizzard.com/en/wow/t/how-much-is-too-much-addon-memory/337833 | Soft community answer: stop when you feel pain — use for player education, not author MB ceilings. |

## Product / sibling tracks (repo)

| Path | Why |
|------|-----|
| [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) | Social (not combat) product → idle-cheap budgets. |
| [14-addon-messaging-beefnet](../14-addon-messaging-beefnet/) | Message/CTL budgets — complementary, not duplicated. |
| [47-login-storms-guild-scale](../47-login-storms-guild-scale/) | Login fan-out scale — complementary. |
| [04-toc-api-performance](../04-toc-api-performance/) | TOC/API/general perf — leave general catalog there. |
| [19-testing-debugging-qa](../19-testing-debugging-qa/) | Errors / alpha / combat lockdown QA. |

## Provenance dumps

| File | Contents |
|------|----------|
| [`.raw/search-profiling-tools.json`](.raw/search-profiling-tools.json) | Memory tools, AddonUsage, AddonProfiler, GetAddOnMemoryUsage |
| [`.raw/search-gc-onupdate.json`](.raw/search-gc-onupdate.json) | OnUpdate, GC, Gello CPU thread |
| [`.raw/search-framems-cpu.json`](.raw/search-framems-cpu.json) | CPU APIs / scriptProfile adjacent |
| [`.raw/search-framems-gc.json`](.raw/search-framems-gc.json) | Frame overlays / FPS tools |
| [`.raw/search-framems-exact.json`](.raw/search-framems-exact.json) | GetFrameCPUUsage / framems hunt |
| [`.raw/search-framems-github.json`](.raw/search-framems-github.json) | Broader framems search |
| [`.raw/search-frametime-addonprofiler.json`](.raw/search-frametime-addonprofiler.json) | Framerate + profiler tooling |
| [`.raw/extract-profiling-apis.json`](.raw/extract-profiling-apis.json) | Wiki extracts: memory/CPU/debugprofilestop |
| [`.raw/extract-scriptprofile-addonusage.json`](.raw/extract-scriptprofile-addonusage.json) | AddonUsage + console vars |
| [`.raw/extract-cpu-gc-apis.json`](.raw/extract-cpu-gc-apis.json) | scriptProfile CVar + UpdateAddOnCPUUsage |
| [`.raw/extract-framecpu-profiler.json`](.raw/extract-framecpu-profiler.json) | Numy profiler + OnUpdate |
