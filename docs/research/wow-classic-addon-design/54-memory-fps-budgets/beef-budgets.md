# Church of Beef V1 — memory / FPS budgets

**Track:** [54-memory-fps-budgets](README.md)  
**Status:** Design targets for implementers and QA — not Blizzard-enforced limits.  
**Assumes:** TBC Classic Anniversary client; social addon shape ([spec §1](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)).

## Budget philosophy

1. **Invisible at idle.** If AddonUsage with `scriptProfile` on cannot distinguish Beef from unused utilities after a quiet minute, the idle budget is met.
2. **Hitch-aware, not average-FPS-obsessed.** Players notice toast/login stutters more than 59 vs 60 FPS.
3. **Do not steal combat-addon budget.** Guildmates run DBM / WeakAuras / ElvUI; Beef must stay out of their CPU top-5 during pulls.
4. **Network scale ≠ this table.** Byte/CPS and login storms → [14](../14-addon-messaging-beefnet/), [47](../47-login-storms-guild-scale/). Here: **what Beef may spend on the local client** when those systems fire.

## Target budgets

### A. Idle (main UI closed, no pending sync UI)

| Metric | Target | How to measure |
|--------|--------|----------------|
| Attributed CPU | **&lt; 0.1 ms/s** after 2–3 min quiet (reset then wait) | `scriptProfile 1` + AddonUsage or `GetAddOnCPUUsage` / elapsed ([workflow](profiling-tools-workflow.md)) |
| Permanent `OnUpdate` | **None** on visible parents | Code review + `/framestack` while idle |
| Registered noisy events | Only what V1 needs; handlers return in microseconds for foreign prefixes | Event print audit ([garbage-patterns](garbage-patterns.md)) |

### B. Memory (steady state after login settle + one sync)

| Metric | Target | Notes |
|--------|--------|-------|
| Addon KB (AddonUsage / `GetAddOnMemoryUsage`) | **Prefer &lt; ~512 KB–2 MB** idle for V1 feature set | Soft; flag if **tens of MB** alone |
| Growth | **No unbounded climb** over a 2-hour guild night | Reset memory view after GC dip; if still climbing, leak/log |
| SV ladder cache | O(members × record fields), not chat history | Cap local standing log ([21](../21-savedvariables-migration/)) |

### C. Interactive spikes (wall time via `debugprofilestop`)

| Action | Target wall time | Notes |
|--------|------------------|-------|
| Open `/beef` cold (build list) | **&lt; 5 ms** typical guild (&lt; ~200 names) | Pool rows; one sort |
| Refresh dirty ladder | **&lt; 2 ms** | Incremental text updates preferred |
| Single promotion toast + string format | **&lt; 2–3 ms** | No texture spam |
| Apply one `RANK_COMMIT` to tables (no UI) | **&lt; 1 ms** | UI paint deferred |

### D. Frame-time share (qualitative)

| Context | Expectation |
|---------|-------------|
| 60 FPS city idle, Beef closed | Overlay FPS unchanged vs Beef disabled |
| During 25-man with full UI stack | Beef not in top CPU offenders |
| Officer approve moment | At most one brief hitch; stream still readable ([17](../17-stream-overlay-readability/)) |

Convert player reports: a **visible hitch** ≈ multi-ms spike on one frame. Stay under a few ms for toast/announce so 16.7 ms frames survive.

## Scenario test matrix (perf QA)

| # | Scenario | Pass |
|---|----------|------|
| P1 | Disable all but Beef + libs → idle 3 min → CPU | Near floor |
| P2 | Re-enable normal UI stack → idle 3 min → Beef rank in AddonUsage | Bottom tier |
| P3 | Open/close `/beef` ×20 | No accumulating CPU after Reset; no frame leak |
| P4 | Simulate 50 `CHAT_MSG_ADDON` COB messages in &lt;1 s (dev) | UI not rebuilt 50×; coalesced paint |
| P5 | One promote + guild announce | Hitch imperceptible; FPS overlay recovers immediately |
| P6 | 2-hour guild night memory | No monotonic climb after GC resets |

Script errors / alpha channels for distributing these builds → [19](../19-testing-debugging-qa/).

## Explicit non-budgets (owned elsewhere)

| Concern | Track |
|---------|-------|
| `SYNC_STATE` chunk size / CTL priority | [14](../14-addon-messaging-beefnet/) |
| Login reply-storm / roster readiness delay | [47](../47-login-storms-guild-scale/) |
| TOC Interface / file load order | [04](../04-toc-api-performance/) |
| Combat lockdown correctness | [19](../19-testing-debugging-qa/), [29](../29-taint-secure-ui/) |

## Implementation implications (research → design)

Without writing product code here, V1 architecture should assume:

1. **Event → data → dirty → paint** pipeline.
2. **Toast singleton** + optional short animation via timer, not forever `OnUpdate`.
3. **Row pool** for ladder list.
4. **Capped** local logs.
5. **Profiling hooks optional** behind a hidden dev flag — never enable `scriptProfile` from the addon for end users.

## Success criteria link

Spec §13 success is social (promotion reaction, officer flow). Perf budgets support that by ensuring spectacle is **felt as content**, not as stutter. A promotion nobody sees fails the product; a promotion that hitch-stutters the stream fails the same criterion for streamers.
