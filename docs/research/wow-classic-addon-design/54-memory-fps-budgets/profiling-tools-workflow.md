# Profiling tools & workflow (Classic-first)

**Track:** [54-memory-fps-budgets](README.md)  
**Goal:** Measure frame time and addon CPU/memory without leaving `scriptProfile` on forever.

## 1. Frame-time mindset (“/framems”)

Addon Lua runs **between frames**. More Lua work → longer frame → lower FPS ([AddonUsage](https://www.wowinterface.com/downloads/info7362-AddonUsage.html)).

| Target FPS | Approx. full-frame budget |
|------------|---------------------------|
| 60 | ~16.7 ms |
| 90 | ~11.1 ms |
| 120 | ~8.3 ms |

**Built-in overlay:** `ToggleFramerate` — keybind “Toggle Framerate Display”, default often **Ctrl-R**; same number via `GetFramerate()` ([GetFramerate](https://warcraft.wiki.gg/wiki/API_GetFramerate)). Note: `GetFramerate()` **lags** sudden drops (wiki detail) — use it for trends, not micro-stutter forensics.

**“/framems” in this research library:** use it as the **discipline** of watching milliseconds per frame (and hitch spikes), not as a guarantee of a first-party slash. Current Warcraft Wiki / Wowpedia indexes document FPS toggle + API, not a dedicated `/framems` command. If an Anniversary client or third-party tool exposes `/framems`, treat it as a convenience overlay for the same budget table above; verify in-client.

**Practical loop:** enable FPS overlay → perform Beef action (open ladder, approve rank, login sync) → watch for dips / hitch → attribute with CPU tools below.

## 2. Classic CPU profiling (`scriptProfile`)

### Enable

```text
/console scriptProfile 1
/reload
```

- CVar `scriptProfile`: `0` off (default), `1` on; **requires UI reload** ([CVar scriptProfile](https://wowpedia.fandom.com/wiki/CVar_scriptProfile); listed under Debug in [Console variables](https://warcraft.wiki.gg/wiki/Console_variables)).
- Optional WTF: `SET scriptProfile 1` in Config-cache (same wiki).

### Measure (API)

| API | Role |
|-----|------|
| `UpdateAddOnCPUUsage()` | Refresh cached CPU stats; **only effective when `scriptProfile` is 1** ([Wowprogramming](https://wowprogramming.com/docs/api/UpdateAddOnCPUUsage.html)) |
| `GetAddOnCPUUsage(name\|index)` | Total ms attributed to the addon (cached) ([GetAddOnCPUUsage](https://warcraft.wiki.gg/wiki/API_GetAddOnCPUUsage)) |
| `ResetCPUUsage()` | Reset accumulators (used by tools’ Reset buttons) |
| `GetFunctionCPUUsage(fn)` | Per-function ms (drill-down) |
| `GetFrameCPUUsage(frame[, includeChildren])` | Sum of **current** handlers’ function CPU — **does not include `OnUpdate`** (wiki detail, tested 6.0.3) ([GetFrameCPUUsage](https://warcraft.wiki.gg/wiki/API_GetFrameCPUUsage)) |

### Caveats (read before trusting numbers)

1. **Profiling costs FPS.** Leave `scriptProfile` off for normal play; enable only for sessions you intend to measure ([AddonUsage](https://www.wowinterface.com/downloads/info7362-AddonUsage.html)).
2. **API time is under-counted.** `GetAddOnCPUUsage` sums Lua function time and **does not include** time spent inside many WoW API calls; busy-wait on `debugprofilestop` barely shows, while a Lua `for` loop does ([GetAddOnCPUUsage details](https://warcraft.wiki.gg/wiki/API_GetAddOnCPUUsage)).
3. **Library blame is muddy.** Shared Ace/libs work can land on the wrong addon; treat rankings as a guide ([AddonUsage](https://www.wowinterface.com/downloads/info7362-AddonUsage.html)).
4. **Display unit in AddonUsage:** ms of CPU **per second** of wall time since reset/login — good for comparing addons after a play segment.

### Recommended Classic workflow

1. Fresh login with Beef + typical guild UI stack.
2. `scriptProfile 1` → `/reload`.
3. Install/use [AddonUsage](https://www.wowinterface.com/downloads/info7362-AddonUsage.html) (`/addonusage`) **or** raw `UpdateAddOnCPUUsage` dumps.
4. Reset CPU → play **idle** 2–3 minutes → Update → note Beef ms/s.
5. Reset → open/close `/beef` 20× → Update → note delta.
6. Reset → trigger one promotion toast + guild announce → Update.
7. **`/console scriptProfile 0` → `/reload`** when done.

## 3. Micro-benchmarks without `scriptProfile`

For “how long does this rebuild take?” use the high-resolution timer:

```text
local t0 = debugprofilestop()
-- work
local used = debugprofilestop() - t0
```

- Prefer **not** calling `debugprofilestart()` repeatedly — it fights other addons; sample with `debugprofilestop()` deltas instead ([debugprofilestop](https://warcraft.wiki.gg/wiki/API_debugprofilestop)).
- Author recommendation from UI forum: also print/event-count how often handlers fire — frequency beats micro-optimizing a rare path ([Optimizing CPU usage](https://us.forums.blizzard.com/en/wow/t/optimizing-cpu-usage/1366572)).

## 4. Memory profiling

| API | Role |
|-----|------|
| `UpdateAddOnMemoryUsage()` | Recompute per-addon KB caches |
| `GetAddOnMemoryUsage(name\|index)` | Cached KB for one addon ([wiki](https://warcraft.wiki.gg/wiki/API_GetAddOnMemoryUsage)) |

Example pattern (wiki): call `UpdateAddOnMemoryUsage()` once, then iterate `GetNumAddOns()`.

**Caveats:**

- Values are **snapshots**; Lua GC will drop “creep” periodically ([AddonUsage](https://www.wowinterface.com/downloads/info7362-AddonUsage.html)).
- Do not call Update every frame in product code — it is a diagnostic.
- Some “GarbageCollector” style addons can break memory APIs; disable them when measuring ([AddonUsage comments](https://www.wowinterface.com/downloads/info7362-AddonUsage.html)).

## 5. Tooling map (Classic Anniversary / TBC Classic)

| Tool | Use when | Notes |
|------|----------|-------|
| **Ctrl-R / ToggleFramerate** | Hitch / FPS sanity | Built-in; always available |
| **AddonUsage** (Gello) | Side-by-side mem + CPU | Classic-era workflow; enables CPU via checkbox (`scriptProfile`) |
| **Raw scriptProfile APIs** | CI notes / slash dumps | No dependency |
| **debugprofilestop** | Function-level timing | Dev only; leave out of release paths |
| **Numy AddonProfiler** (`/nap`) | If client has modern Blizzard addon profiler UI | CurseForge lists Classic / Classic TBC builds; changelog warns against leaving old `scriptProfile` approach on ([Addon Profiler](https://www.curseforge.com/wow/addons/numy-addon-profiler)). Prefer for clients where C_AddOnProfiler-style data exists; do not assume Retail 11.1 UI on Anniversary without verifying. |
| **/framestack** | Wrong frame costly? | Layout debugging, not CPU — still useful when UI open path is hot |

## 6. Retail contrast (do not require for V1)

Retail 11.0.7+ added deeper Blizzard addon performance data; Numy’s profiler markets itself as a better UI over that system and claims lower overhead than classic `scriptProfile` scrapers ([CurseForge description](https://www.curseforge.com/wow/addons/numy-addon-profiler)). Anniversary V1 should assume the **classic `scriptProfile` + AddonUsage** path unless the live TBC Anniversary client proves otherwise.

## 7. What not to confuse with this track

- Message throttle / login sync storms → [14](../14-addon-messaging-beefnet/), [47](../47-login-storms-guild-scale/)
- Lua error capture → [19](../19-testing-debugging-qa/)
- TOC Interface numbers → [04](../04-toc-api-performance/)
