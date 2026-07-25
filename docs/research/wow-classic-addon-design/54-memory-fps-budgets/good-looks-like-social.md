# What “good” looks like for a social Classic addon

**Track:** [54-memory-fps-budgets](README.md)  
**Audience:** Church of Beef V1 — guild ladder / spectacle, not combat assistance.

## Contrast: combat HUD vs social utility

| Dimension | Combat / tracker addons | Social guild addons (Beef class) |
|-----------|-------------------------|----------------------------------|
| Duty cycle | High during encounters; often every-frame or combat-log heavy | Low most of the hour; bursty on events |
| Acceptable idle CPU | Small but often non-zero (nameplates, auras) | Should be **indistinguishable from noise** when UI closed |
| Memory shape | Large caches (spell DBs, CL history) are common | Small structured tables (ranks, standing, revisions) |
| Failure mode players notice | FPS drop in boss pulls | Hitch on login / guild chat spam / opening `/beef` |
| “Good enough” bar | Survive 25-man with DBM + WeakAuras + ElvUI | Invisible next to those — never the addon blamed in `/addonusage` |

Church of Beef’s own product definition is social coordination and spectacle, **not** raid optimization ([design spec §1](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)). Performance expectations should match that: **cheap by default**.

## Idle goodness checklist

A social Classic addon is doing well when, with its main frame **hidden**:

1. **No permanent `OnUpdate`** on a visible parent. Prefer events + one-shot / ticker timers ([OnUpdate notes](https://wowpedia.fandom.com/wiki/UIHANDLER_OnUpdate); [Gello: detach when idle](https://us.forums.blizzard.com/en/wow/t/optimizing-cpu-usage/1366572)).
2. **Event handlers short-circuit fast.** Ignore non-`GUILD` / non-`COB` addon messages immediately; ignore roster events until needed.
3. **No polling loops** for “is the ladder dirty?” — dirty flags set by events, paint on open or throttled refresh.
4. **No continuous memory sampling** (`UpdateAddOnMemoryUsage` is for tools, not product code every frame — see [GetAddOnMemoryUsage](https://warcraft.wiki.gg/wiki/API_GetAddOnMemoryUsage)).
5. **SV growth is bounded.** Ladder + standing log sizes grow with guild activity, not with every chat line or every frame.

## Active goodness checklist (when something happens)

| Moment | Healthy behavior | Unhealthy behavior |
|--------|------------------|--------------------|
| Login / reload | Delayed settle, then one sync request (see [47](../47-login-storms-guild-scale/), [14](../14-addon-messaging-beefnet/)); merge revisions | Rebuild UI + dump full ladder to chat on `PLAYER_LOGIN` |
| `CHAT_MSG_ADDON` | Parse → validate → mutate tables → maybe dirty flag | Allocate new UI rows / sort full ladder per message |
| Officer approve | One toast + one guild-chat line + one commit | Animated particle rain + full frame recreate |
| Open `/beef` | Build or refresh list once; reuse row pool | CreateFrame per roster member every open |
| City / raid with many addons | Beef still near bottom of CPU sort | Beef competes with DBM/ElvUI in AddonUsage |

## Memory: what “too much” means for this class

Community consensus for **player** “how much addon RAM is too much?” is soft: stop when you *feel* FPS/load pain, not at a fixed MB number ([forum thread](https://us.forums.blizzard.com/en/wow/t/how-much-is-too-much-addon-memory/337833)). For **authors** of a single social addon:

- Absolute MB matters less than **growth rate** and **whether GC pauses hitch**.
- AddonUsage’s author guidance: watch memory, but **optimize CPU first**; Lua GC will reclaim slow creep ([AddonUsage](https://www.wowinterface.com/downloads/info7362-AddonUsage.html)).
- A guild ladder of tens–hundreds of names should stay in the **low hundreds of KB to low MB** range if stored as plain tables/strings — if Beef alone is tens of MB idle, something is retaining huge strings, textures, or unbounded logs.

## FPS / hitch vocabulary for social QA

| Term | Meaning for Beef |
|------|------------------|
| Steady FPS | Idle world / city with UI closed — Beef must not move the needle |
| Hitch | One-frame spike when a toast fires or ladder opens — more important than average FPS for this product |
| Frame ms | `1000 / FPS` approximate budget for the whole client; Beef should consume a tiny fraction except during intentional UI work |
| Attributed ms/s | `GetAddOnCPUUsage` / session seconds after `scriptProfile` — compare Beef to quiet utilities, not to WeakAuras |

## Steal / adapt from cousin social tools

Patterns from guild loot / attunement / RP tools (see also [13](../13-cousin-addon-teardowns/)):

- Work is **event-driven** and **officer-gated**.
- Heavy UI is **on demand**.
- Network sync is **revisioned and chunked** (performance implication: don’t re-render on every chunk — batch).

Do **not** copy combat-addon norms (always-on tickers, CL parsers, unit aura scans) into Beef V1.

## Boundary with other tracks

- **TOC / API surface / general performance practices** → [04](../04-toc-api-performance/)
- **Login fan-out / guild scale storms** → [47](../47-login-storms-guild-scale/)
- **Message size / CTL pacing** → [14](../14-addon-messaging-beefnet/)
- This track: **what good idle/active costs look like + how to measure them**
