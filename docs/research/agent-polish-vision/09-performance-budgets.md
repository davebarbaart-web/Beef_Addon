# 09 — Performance budgets (polished but cheap)

**Series:** `docs/research/agent-polish-vision/`  
**Audience:** Agents implementing Church of Beef UI juice / motion without burning Classic FPS.  
**Last updated:** 2026-07-26  
**Authority:** `.cursor/rules/wow-performance.mdc` (hard constraints) · tracks [04](../wow-classic-addon-design/04-toc-api-performance/) · [54](../wow-classic-addon-design/54-memory-fps-budgets/) (depth).  
**Not product law:** Numbers here are **design targets** from repo research + community norms — not Blizzard SLAs. Prefer [design spec](../../superpowers/specs/2026-07-25-church-of-beef-design.md) + glossary if they diverge.

---

## One-line doctrine

*Social addon = idle when closed; juice is short, timer-driven, and detached when done. Never buy polish with a permanent `OnUpdate`.*

Bar from `wow-performance.mdc`: **invisible next to WA / Details / nameplates.**

---

## Hard constraints (from `wow-performance.mdc`)

| Phase | Expectation |
|-------|-------------|
| UI closed | Events only — effectively idle |
| UI open | Interaction + **≤10 Hz** dirty coalesce |
| In combat | No permanent `OnUpdate`; no full ladder rebuild storms |
| Login sync | Bursty then quiet |
| SavedVariables | Prefer **≪ 1 MB** |

```lua
-- ✅ GOOD — disable when idle
frame:SetScript("OnUpdate", nil)

-- ❌ BAD — scoring or net parse every frame
frame:SetScript("OnUpdate", function(_, elapsed) COB.Scoring:Tick(elapsed) end)
```

---

## Numeric guidelines (known / adopted)

### Frame-time context

| Target FPS | Full-client frame budget |
|------------|--------------------------|
| 60 | ~**16.7 ms**/frame |
| 90 | ~**11.1 ms**/frame |
| 120 | ~**8.3 ms**/frame |

Beef should consume a **tiny fraction** of that except during intentional open-UI work. Soft community headroom for *all* addons combined is sometimes cited as ≪ **5 ms**/frame total — mental model only ([04/05](../wow-classic-addon-design/04-toc-api-performance/05-performance-norms.md)).

### Idle / CPU / memory (track 54)

| Metric | Target |
|--------|--------|
| Attributed idle CPU (`scriptProfile` + AddonUsage) | **&lt; ~0.1 ms/s** after 2–3 min quiet |
| Permanent `OnUpdate` while closed / idle | **None** |
| Steady addon memory (V1 feature set) | Prefer **~512 KB–2 MB**; flag if **tens of MB** alone |
| SV file | Prefer **≪ 1 MB**; no unbounded climb over a guild night |

### Interactive wall time (`debugprofilestop`)

| Action | Target |
|--------|--------|
| Cold open `/beef` (~&lt;200 names) | **&lt; 5 ms** |
| Dirty ladder refresh | **&lt; 2 ms** |
| One promotion toast + string format | **&lt; 2–3 ms** |
| Apply one `RANK_COMMIT` (data only, no paint) | **&lt; 1 ms** |

### UI refresh throttling

| Concern | Guideline |
|---------|-----------|
| Ladder / standing paint while open | Dirty flag + coalesce **≤10 Hz** (rule) — practical interval **0.1–0.5 s** after burst ([04/03](../wow-classic-addon-design/04-toc-api-performance/03-events-onupdate-throttling.md)) |
| Per BeefNet message | Mutate tables → dirty; **do not** rebuild full UI per packet |
| Logic OnUpdate (if unavoidable) | Throttle **≤10–20 Hz**; prefer timers |
| Guild roster API | Respect client throttle (~**10 s**); never `GuildRoster()` per message ([glossary](../wow-classic-addon-design/74-v1-decision-glossary/locked-v1-decisions.md) row 26) |

### Network / chat (orthogonal but same “storm” story)

| Concern | Guideline |
|---------|-----------|
| Outbound CTL shaping | ~**4000-byte** burst, ~**800 CPS** steady ([14](../wow-classic-addon-design/14-addon-messaging-beefnet/chatthrottlelib-and-budgets.md)) |
| Guild spectacle | **One** officer-origin `/g` line per promote/demote |
| BeefNet idle | No heartbeat mesh; login sync then quiet ([68](../wow-classic-addon-design/68-beefnet-message-catalog/anti-storm-per-type.md)) |

---

## OnUpdate costs

`OnUpdate` runs when the UI draws — **dozens to hundreds of times per second**, scaling with FPS ([UIHANDLER_OnUpdate](https://wowpedia.fandom.com/wiki/UIHANDLER_OnUpdate)).

| Fact | Implication for Beef |
|------|----------------------|
| Cost scales with FPS | A “tiny” handler at 120 FPS is 2× the work of 60 FPS |
| Hidden frames do not fire OnUpdate | Hide or `SetScript(..., nil)` when idle |
| Empty forever-OnUpdate still has dispatch cost | Detach; don’t leave a no-op script |
| `GetFrameCPUUsage` historically **omits** OnUpdate | Profiler rankings can under-blame frame scripts — code review still required |

**V1 default:** no permanent OnUpdate for scoring, net, or SV. Allow OnUpdate **only** while a short visual is running, then clear it.

---

## Animation vs timers (pick the cheap tool)

| Mechanism | Use for | Avoid for |
|-----------|---------|-----------|
| `RegisterEvent` / `OnEvent` | Discrete state (roster, addon msg, login, combat) | Continuous interpolation |
| `C_Timer.After` / `NewTicker` | Fixed-interval coalesce, toast dismiss, instance buckets | Sub-frame easing; business logic every frame |
| Animation group / alpha scripts | Short fade/slide (juice) | Scoring, networking, ladder rebuild |
| Throttled `OnUpdate` | Smooth motion **only while animating** | Permanent “watchdog” |

**Prefer:** event → mutate → dirty → `C_Timer.After(0.1–0.5, paint)` (or paint on open).  
**Prefer for juice:** Animation object **or** short OnUpdate with elapsed accumulator → **nil the script** on finish.  
**Never:** ticker that rebuilds the ladder every second while closed.

---

## Garbage (GC hitch patterns)

Pain is **hot-path allocation**, not steady KB after GC reclaim ([54/garbage](../wow-classic-addon-design/54-memory-fps-budgets/garbage-patterns.md)).

| Do | Don’t |
|----|-------|
| File-local scratch tables; overwrite fields | `local t = { ... }` every `CHAT_MSG_ADDON` |
| `string.format` / `SetFormattedText` | `..` concat in loops on chatty handlers |
| Row pool; rebind text | `CreateFrame` per open / per member |
| Cap / rotate standing logs | Unbounded SV append |
| Let incremental GC run | `collectgarbage("collect")` after every sync |

Frames from `CreateFrame` are **not** GC’d — pool and hide ([57](../wow-classic-addon-design/57-scrollframe-list-rows/pooled-rows-recycle.md)).

---

## Event storms → coalesce, don’t paint

| Storm source | Local CPU rule |
|--------------|----------------|
| Login `SYNC_*` fan-out | Merge data; **one** paint after settle (or when UI opens) |
| Burst of `CHAT_MSG_ADDON` COB | O(1) parse/validate; dirty once; coalesce refresh |
| `GUILD_ROSTER_UPDATE` spam | Cache; do not full-rescan + rebuild per tick |
| Many standing credits in instance | Local toast queue: **1** visible; credits don’t interrupt promote |

Dev pass criterion (54): simulate **50** COB messages in &lt;1 s → UI not rebuilt 50×.

---

## Juice / animation budget (polished but cheap)

Spectacle success is **guild chat + one toast**, not chrome ([UI brief](../../superpowers/ui-polished-direction-for-agents.md); spec §13.11). Motion is assistive, not the product.

### Allowed V1 juice (cheap)

| Technique | Budget |
|-----------|--------|
| Toast fade/slide in | **≤ ~0.3 s** ([17 typography](../wow-classic-addon-design/17-stream-overlay-readability/typography-scale.md)) |
| Toast hold (rank approve) | **~6–8 s** then dismiss ([17 duration](../wow-classic-addon-design/17-stream-overlay-readability/duration-and-attention.md)) |
| Credit / suggest toast hold | **~3.5–7 s** by severity |
| Concurrent toasts | **1** (promote may interrupt credit; not reverse) |
| Alpha / position easing | One animation group **or** short OnUpdate; detach on complete |
| Ladder dirty refresh while open | ≤10 Hz coalesce — feels “live,” not per-frame |
| Highlight flash on committed row | One-shot timer (~0.2–0.5 s), not looping glow |

### Forbidden / defer (expensive or brand-wrong)

| Anti-pattern | Why |
|--------------|-----|
| Center-screen WA-style pulses | Spec / brief ban; combat-HUD vibes |
| Permanent glow / spin / idle animation | Idle CPU; stream noise |
| Particle rain / texture spam on promote | Multi-ms hitch; GC + GPU |
| Full frame recreate for juice | Alloc + layout spike |
| Per-frame proximity / aura / CL scans | Wrong product class |
| SFX by default | V1 silent; optional later, default off |
| Animating while UI closed | Breaks idle budget |

### Juice cookbook → cost class

| Juice idea | Implement with | Cost class |
|------------|----------------|------------|
| Promote toast appear | Show + Animation α / short OnUpdate ≤0.3 s | Cheap |
| Auto-dismiss | `C_Timer.After(dwell, hide)` | Cheap |
| Ladder “new rank” flash | One timer; swap vertex color / show overlay | Cheap |
| Progress text update | Dirty coalesce ≤10 Hz | Cheap |
| Standing drip ticker | Low-rate `C_Timer` / event buckets | Cheap if ≪1 Hz |
| Continuous minimap pulse | Permanent OnUpdate / forever Animation | **Reject** |
| Full list re-sort + recreate rows per packet | Hot path | **Reject** |

**Rule of thumb:** if the flourish needs CPU after the player looked away, it is too expensive.

---

## Agent checklist (PR / smoke)

- [ ] No `OnUpdate` while main UI hidden and no toast animating  
- [ ] `SetScript("OnUpdate", nil)` (or hide) at end of every animation  
- [ ] UI paint path is dirty-flagged; coalesce ≤10 Hz when open  
- [ ] `CHAT_MSG_ADDON` handler allocates O(1), not O(guild)  
- [ ] Ladder uses pooled rows; no CreateFrame per refresh  
- [ ] Standing / event log capped  
- [ ] No `UpdateAddOnMemoryUsage` / CPU sampling in production tickers  
- [ ] Toast path wall time &lt; ~2–3 ms; dwell via timer, not busy loop  
- [ ] In combat: data events OK; no full ladder rebuild storms  
- [ ] Idle 2–3 min with UI closed: Beef near floor in AddonUsage (`scriptProfile` session only)

### Measure (dev only)

```text
/console scriptProfile 1
/reload
-- reset → idle 2–3 min → UpdateAddOnCPUUsage / AddonUsage
/console scriptProfile 0
/reload
```

Leave profiling **off** for normal play — it costs FPS.

---

## Depth links (do not duplicate)

| Topic | Track / rule |
|-------|----------------|
| Events vs OnUpdate | [04/03](../wow-classic-addon-design/04-toc-api-performance/03-events-onupdate-throttling.md) |
| Soft norms + combat bar | [04/05](../wow-classic-addon-design/04-toc-api-performance/05-performance-norms.md), `wow-performance.mdc` |
| Explicit Beef budgets + QA matrix | [54/beef-budgets](../wow-classic-addon-design/54-memory-fps-budgets/beef-budgets.md) |
| GC antipatterns | [54/garbage-patterns](../wow-classic-addon-design/54-memory-fps-budgets/garbage-patterns.md) |
| Profiling workflow | [54/profiling](../wow-classic-addon-design/54-memory-fps-budgets/profiling-tools-workflow.md) |
| Toast dwell / stream motion | [17](../wow-classic-addon-design/17-stream-overlay-readability/) |
| Login / reply storms | [47](../wow-classic-addon-design/47-login-storms-guild-scale/) |
| CTL / BeefNet bytes | [14](../wow-classic-addon-design/14-addon-messaging-beefnet/) |
| Combat lockdown / taint | `wow-ui-taint-lockdown.mdc` |

---

## Success criteria

Polish is successful when a promotion feels deliberate (chat + toast) **and** AddonUsage still cannot distinguish Beef from unused utilities after a quiet minute. A promotion that hitch-stutters the stream fails the same social criterion as a promotion nobody sees.

---

## Deepen pass — primary-sourced performance model (2026-07-26)

> **CoB constraints preserved:** Anniversary `20506` only; announce/track/sync only (no bots / automation); UI→Core→Data and Net→Core→Data layer law; Core never `CreateFrame`; juice never buys a permanent `OnUpdate`. Numbers below remain **design targets**, not Blizzard SLAs.

### Why OnUpdate is the wrong default for social juice

Community and wiki consensus is consistent: `OnUpdate` fires with the UI draw rate, so cost scales with FPS ([UIHANDLER_OnUpdate — Wowpedia](https://wowpedia.fandom.com/wiki/UIHANDLER_OnUpdate); [mirror — warcraft.wiki.gg](https://warcraft.wiki.gg/wiki/UIHANDLER_OnUpdate)). Authors repeatedly advise throttling with an elapsed accumulator or, better, replacing continuous work with events / timers ([Using OnUpdate correctly — WoWWiki archive](https://wowwiki-archive.fandom.com/wiki/Using_OnUpdate_correctly); [Newbie tip for OnUpdate performance — CurseForge Authors](https://authors.curseforge.com/forums/world-of-warcraft/general-chat/lua-code-discussion/225689-newbie-tip-for-onupdate-performance); [onupdate-throttling notes — NeticSoul wiki](https://github.com/NeticSoul/wow-335a-addon-wiki/blob/main/concepts/onupdate-throttling.md)).

**CoB mapping:** toast fade may use a short OnUpdate **or** AnimationGroup **only while visible**; scoring, BeefNet parse, and ladder rebuild must never sit on a forever handler. Prefer [`C_Timer.After`](https://warcraft.wiki.gg/wiki/API_C_Timer.After) / `NewTicker` for coalesce and dismiss.

### Profiling APIs agents must not misuse

| API / tool | Fact from primaries | Beef rule |
|------------|---------------------|-----------|
| `scriptProfile` CVar | Must be enabled + reload before Lua CPU accounting ([CVar_scriptProfile — Wowpedia](https://wowpedia.fandom.com/wiki/CVar_scriptProfile); [Console variables — wiki.gg](https://warcraft.wiki.gg/wiki/Console_variables)) | Dev sessions only; leave **off** for play |
| `UpdateAddOnCPUUsage` / `GetAddOnCPUUsage` | Refresh then read ms; API time is under-counted ([UpdateAddOnCPUUsage](https://warcraft.wiki.gg/wiki/API_UpdateAddOnCPUUsage); historical [GetAddOnCPUUsage](https://wowwiki-archive.fandom.com/wiki/API_GetAddOnCPUUsage)) | Rank Beef vs peers, not absolute “ms SLA” |
| `GetFrameCPUUsage` | Sums script handlers; **historically omits OnUpdate** ([wiki.gg family via track 54](https://warcraft.wiki.gg/wiki/API_GetFrameCPUUsage)) | Code-review OnUpdate even if profiler looks clean |
| `debugprofilestop` | High-res wall timer for micro-benchmarks ([API_debugprofilestop](https://warcraft.wiki.gg/wiki/API_debugprofilestop)) | Gate cold open / toast / commit paths in smoke |
| AddonUsage | Classic-standard mem+CPU UI; turn profiling off after tests ([WoWInterface AddonUsage](https://www.wowinterface.com/downloads/info7362-AddonUsage.html); [CurseForge](https://www.curseforge.com/wow/addons/addon-usage)) | Primary in-game smoke instrument |
| Numy AddonProfiler | Modern profiler; Classic/TBC flavors exist ([CurseForge](https://www.curseforge.com/wow/addons/numy-addon-profiler); [GitHub](https://github.com/NumyAddon/AddonProfiler)) | Optional; verify Anniversary before relying |

Blizzard UI forum guidance (Gello and peers) stresses: measure with `debugprofilestop`, reduce event frequency, throttle-by-hide, and avoid always-on OnUpdate ([Optimizing CPU usage — US forums](https://us.forums.blizzard.com/en/wow/t/optimizing-cpu-usage/1366572); related [Profiling tool for addon cpu usage](https://us.forums.blizzard.com/en/wow/t/profiling-tool-for-addon-cpu-usage/1348073)).

### Frame-time literacy (soft norms)

[`GetFramerate`](https://warcraft.wiki.gg/wiki/API_GetFramerate) is the client’s FPS API (laggy to sudden drops — good for trend, bad for micro-hitches). Player-facing display: Ctrl-R / Toggle Framerate ([Gaming Stack Exchange](https://gaming.stackexchange.com/questions/339618/how-to-show-fps-in-world-of-warcraft)). Soft community memory culture is “stop when you feel pain,” not a hard MB ceiling ([How much is too much addon memory? — US forums](https://us.forums.blizzard.com/en/wow/t/how-much-is-too-much-addon-memory/337833)).

**CoB implication:** V1 success is **idle floor in AddonUsage**, not winning a combat-HUD FPS war against WeakAuras / Details / nameplates.

### Garbage vs hitch (what to measure)

Historical leak culture watches KB/hour growth ([WoWInterface memory-leak thread](https://www.wowinterface.com/forums/showthread.php?t=30520)). For Beef, the failure mode is **hot-path allocation storms** during login sync / `CHAT_MSG_ADDON` bursts — not steady KB after incremental GC. Do not call `collectgarbage("collect")` after every sync; prefer file-local scratch tables and pooled rows (frames from `CreateFrame` are not GC’d).

### Combat + social addon interaction

During combat, data handlers may still run; **full ladder rebuild storms** must not. Juice that needs protected ancestry must defer to `PLAYER_REGEN_ENABLED` (see [03](03-taint-lockdown-ux.md)) — that is a UX/perf coupling: deferred work should be O(1) drains, not a backlog that paints the whole guild at once when combat ends.

### Worked micro-budget example (agent-facing)

```text
Event: RANK_COMMIT applied locally
  Core mutate ............. target < 1 ms   (debugprofilestop)
  Private toast Show ...... target < 2–3 ms (string format + SetText)
  Guild /g announce ....... CTL / chat path (not frame-time critical)
  UI dirty flag ........... true
  Coalesce paint .......... ≤10 Hz while /beef open; 0 Hz if closed
  Animation ............... ≤0.3 s fade; SetScript OnUpdate nil / group Stop on finish
Idle 2–3 min, UI closed ... AddonUsage near floor; scriptProfile OFF afterward
```

### Anti-budget (reject in review)

| Pattern | Why it fails primaries + CoB |
|---------|------------------------------|
| Permanent `OnUpdate` “director” while closed | Violates OnUpdate cost model + `wow-performance.mdc` |
| Paint ladder per BeefNet packet | Event-storm anti-pattern; rebuild N× |
| Production ticker calling `UpdateAddOnMemoryUsage` | Diagnostic APIs cost FPS |
| Continuous minimap pulse Animation | Idle CPU after player looked away |
| Core/Net owning motion timers that CreateFrame | Layer law |

---

## External sources

Annotated primaries for this deepen pass (≥8). Prefer these over SEO “optimize your addon” listicles.

1. [UIHANDLER_OnUpdate — Wowpedia](https://wowpedia.fandom.com/wiki/UIHANDLER_OnUpdate) — OnUpdate scales with FPS; prefer timers.  
2. [UIHANDLER_OnUpdate — warcraft.wiki.gg](https://warcraft.wiki.gg/wiki/UIHANDLER_OnUpdate) — wiki.gg mirror.  
3. [API C_Timer.After — warcraft.wiki.gg](https://warcraft.wiki.gg/wiki/API_C_Timer.After) — one-shot / timer replacement for continuous scripts.  
4. [Using OnUpdate correctly — WoWWiki archive](https://wowwiki-archive.fandom.com/wiki/Using_OnUpdate_correctly) — throttle / elapsed patterns.  
5. [Newbie tip for OnUpdate performance — CurseForge Authors](https://authors.curseforge.com/forums/world-of-warcraft/general-chat/lua-code-discussion/225689-newbie-tip-for-onupdate-performance) — community author guidance.  
6. [CVar scriptProfile — Wowpedia](https://wowpedia.fandom.com/wiki/CVar_scriptProfile) — `/console scriptProfile 1` + reload.  
7. [API UpdateAddOnCPUUsage — warcraft.wiki.gg](https://warcraft.wiki.gg/wiki/API_UpdateAddOnCPUUsage) — refresh CPU caches.  
8. [API debugprofilestop — warcraft.wiki.gg](https://warcraft.wiki.gg/wiki/API_debugprofilestop) — micro-benchmark wall time.  
9. [API GetFramerate — warcraft.wiki.gg](https://warcraft.wiki.gg/wiki/API_GetFramerate) — FPS API caveats.  
10. [Optimizing CPU usage — Blizzard US forums](https://us.forums.blizzard.com/en/wow/t/optimizing-cpu-usage/1366572) — Gello: events, hide-throttle, avoid always-on OnUpdate.  
11. [Profiling tool for addon cpu usage — Blizzard US forums](https://us.forums.blizzard.com/en/wow/t/profiling-tool-for-addon-cpu-usage/1348073) — tooling discussion.  
12. [AddonUsage — WoWInterface](https://www.wowinterface.com/downloads/info7362-AddonUsage.html) — Classic mem/CPU smoke UI.  
13. [AddonUsage — CurseForge](https://www.curseforge.com/wow/addons/addon-usage) — distribution mirror.  
14. [Numy AddonProfiler — CurseForge](https://www.curseforge.com/wow/addons/numy-addon-profiler) — modern profiler (verify Anniversary).  
15. [How much is too much addon memory? — Blizzard US forums](https://us.forums.blizzard.com/en/wow/t/how-much-is-too-much-addon-memory/337833) — soft community memory culture.  
16. [OnUpdate throttling — NeticSoul wow-335a wiki](https://github.com/NeticSoul/wow-335a-addon-wiki/blob/main/concepts/onupdate-throttling.md) — Classic-era author notes.  
17. [Useful AddOns for debugging/profiling — Wowpedia](https://wowpedia.fandom.com/wiki/Useful_AddOns_for_debugging/profiling) — tool index.  

**Sister depth (repo, not external):** [54 annotated-urls](../wow-classic-addon-design/54-memory-fps-budgets/annotated-urls.md) · [04/03 events-onupdate](../wow-classic-addon-design/04-toc-api-performance/03-events-onupdate-throttling.md) · adversarial twin [51](51-adversarial-performance-vs-juice.md).

---

## Web-harvest gotchas (2026-07-26 deepen)

### Timer driver choice (community consensus)

[WoWInterface — Function timing](https://www.wowinterface.com/forums/showthread.php?t=49566) (Phanx / p3lim / SDPhantom):

| Driver | When | Caveat |
|--------|------|--------|
| Throttled `OnUpdate` + elapsed | Short custom ease / physics while visible | Cost × FPS; **nil script** when done |
| AnimationGroup duration + `OnFinished` | Delay-then-act without a timer library | Creates UI objects; fine for toast chrome |
| `C_Timer.After` | Toast hold, dirty coalesce, one-shots | Prefer over permanent OnUpdate ([wiki](https://warcraft.wiki.gg/wiki/API_C_Timer.After)) |
| `C_Timer.NewTicker` | Low-rate repeats that must cancel | More table/metatable overhead than bare `After` (SDPhantom) |

**CoB:** hold + queue pump = `After`; toast fade = AnimationGroup or stepped `After`; never NewTicker for scoring/net.

### Blizzard / community CPU % traps

[r/wow — Addon performance tracking misconceptions (Numy)](https://www.reddit.com/r/wow/comments/1j1pxxj/about_the_new_addon_performance_tracking_common/):

- Built-in % is roughly `addonCPU / (appCPU − otherAddons + addonCPU)` over recent frames — **relative**, not an SLA.  
- **High FPS makes every-frame work look worse** as a percentage.  
- Isolation tests under-count shared library blame; multi-addon sessions can mis-attribute.  
- Prefer **average ms/frame**, **peak frame**, and **over-X-ms spike counts** ([AddonProfiler](https://www.curseforge.com/wow/addons/numy-addon-profiler)) over a single microbutton %.  
- Related profiling APIs landed on some Classic lineages — **verify Anniversary `20506`** before trusting the same UI affordance.

**CoB smoke still wins:** AddonUsage + `scriptProfile` session → idle floor with UI closed; leave profiling off for play ([AddonUsage](https://www.wowinterface.com/downloads/info7362-AddonUsage.html)).

### CreateFrame pool reminder

[CreateFrame — wiki.gg](https://warcraft.wiki.gg/wiki/API_CreateFrame): frames are not GC’d. Ladder/officer/toast paths must pool — juice that `CreateFrame`s per promote fails the same budget as a permanent OnUpdate.
