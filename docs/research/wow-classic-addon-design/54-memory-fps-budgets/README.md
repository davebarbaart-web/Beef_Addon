# Track 54 — Memory / FPS budgets & profiling tools

**Track id:** `54-memory-fps-budgets`  
**Last updated:** 2026-07-25  
**Sole focus:** How a **social** Classic addon should budget CPU and memory; how authors measure frame time and addon CPU; garbage patterns that cause hitching; Church of Beef V1 budgets.  
**Out of scope:** TOC / Interface / general API constraint catalogs (track [04](../04-toc-api-performance/)); login storms, reply-storm scale, and guild fan-out timing (track [47](../47-login-storms-guild-scale/)); BeefNet byte/CPS budgets (track [14](../14-addon-messaging-beefnet/)); QA channels and BugSack (track [19](../19-testing-debugging-qa/)). No addon implementation in this folder.

## Product truth (from V1 spec)

| Locked default | Value |
|----------------|-------|
| Product shape | Social guild / streamer-event addon — **not** a combat HUD |
| Hot path | Rank ladder UI (`/beef`), officer approve queue, thin toasts, BeefNet sync |
| Cold path | Most of the session: idle, no permanent combat `OnUpdate` |
| Persistence | Per-character SV cache of ladder + local standing ([21](../21-savedvariables-migration/)) |

Source: [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §1–§3, §8–§10.

## Index

| Note | Covers |
|------|--------|
| [good-looks-like-social.md](good-looks-like-social.md) | What “good” looks like for a social Classic addon vs combat tools |
| [profiling-tools-workflow.md](profiling-tools-workflow.md) | Frame-time mindset (`/framems` budget), `scriptProfile`, AddonUsage, `debugprofilestop`, Classic vs Retail profilers |
| [garbage-patterns.md](garbage-patterns.md) | Allocation / GC patterns that hitch FPS; what to avoid |
| [beef-budgets.md](beef-budgets.md) | Explicit V1 CPU / memory / hitch budgets for Church of Beef |
| [annotated-urls.md](annotated-urls.md) | Primary URLs with steal/adapt notes |

## Top insights for Beef (read this first)

1. **CPU is the FPS budget; memory is a secondary signal.** Addon work runs between rendered frames. High Lua CPU lengthens frame time and drops FPS. Slow memory “creep” that resets after Lua GC is usually normal — chase **milliseconds of CPU per second**, not every KB of GC churn ([AddonUsage](https://www.wowinterface.com/downloads/info7362-AddonUsage.html)).

2. **A social addon should be nearly free when closed.** Church of Beef is not a nameplate/threat/rotation tool. “Good” = idle cost ≈ noise floor; cost spikes only on login sync, roster events, open ladder UI, and rare promotion toasts. Permanent every-frame `OnUpdate` is an antipattern for this product class ([OnUpdate](https://wowpedia.fandom.com/wiki/UIHANDLER_OnUpdate); [Gello on CPU](https://us.forums.blizzard.com/en/wow/t/optimizing-cpu-usage/1366572)).

3. **Think in frame milliseconds, not only FPS.** At 60 FPS the whole client has ~16.7 ms/frame; at 120 FPS ~8.3 ms. Budget Beef as a tiny slice of that. Built-in FPS overlay is `ToggleFramerate` (usually **Ctrl-R**) via [GetFramerate](https://warcraft.wiki.gg/wiki/API_GetFramerate). Treat “**/framems**” as the *budget unit* (ms/frame) and overlay workflow — not a separately documented Blizzard slash in current wiki indexes (verify in-client if a flavor exposes one).

4. **Classic CPU profiling = `scriptProfile` + reload + measure, then turn it off.** `/console scriptProfile 1` then `/reload` enables Lua CPU accounting; `UpdateAddOnCPUUsage` / `GetAddOnCPUUsage` then return cached ms totals ([CVar scriptProfile](https://wowpedia.fandom.com/wiki/CVar_scriptProfile); [UpdateAddOnCPUUsage](https://wowprogramming.com/docs/api/UpdateAddOnCPUUsage.html)). Profiling itself costs CPU — leave it off for normal play ([AddonUsage](https://www.wowinterface.com/downloads/info7362-AddonUsage.html)).

5. **Garbage patterns kill social addons the same way they kill combat ones — just less often.** Tables/`{}` and string concat inside chatty events (`CHAT_MSG_ADDON`, roster spam) create GC pauses. Reuse tables, throttle bursts, detach `OnUpdate` when idle ([Gello](https://us.forums.blizzard.com/en/wow/t/optimizing-cpu-usage/1366572)).

6. **Beef V1 budgets (design targets, not Blizzard laws):** idle &lt; ~0.1 ms/s attributed CPU with `scriptProfile` on after a quiet minute; closed UI memory footprint well under ~1–2 MB and not growing unbounded; open ladder rebuild &lt; ~5 ms wall (`debugprofilestop`); no hitch &gt; ~2–3 ms from a single toast/announce. Sync storms belong to track 47/14 — this track only says: never rebuild the whole UI from every addon message.

## Provenance

Search/extract dumps under [`.raw/`](.raw/). Prefer Warcraft Wiki / WowAce / WoWInterface author notes over SEO “how to see addon memory” blogs.
