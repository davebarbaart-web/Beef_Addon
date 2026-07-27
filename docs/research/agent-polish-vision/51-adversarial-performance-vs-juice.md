# 51 — Adversarial performance vs juice (Classic FPS / event storms)

**Audience:** Coding agents proposing or implementing Church of Beef UI polish (“juice”).  
**Last updated:** 2026-07-26  
**Status:** Research reject brief for agents — **not** product law. Product locks stay in the [design spec](../../superpowers/specs/2026-07-25-church-of-beef-design.md) §10 / §15 and [glossary 74–81](../wow-classic-addon-design/74-v1-decision-glossary/locked-v1-decisions.md). Hard runtime budgets live in [`.cursor/rules/wow-performance.mdc`](../../../.cursor/rules/wow-performance.mdc) and track [54](../wow-classic-addon-design/54-memory-fps-budgets/).  
**Client:** TBC Classic Anniversary (`## Interface: 20506`).

---

## 1. Verdict (read first)

Church of Beef is a **social** addon. Juice that looks fine in a city with the panel open will still **fail review** if it:

1. burns frame time when `/beef` is **closed**, or  
2. fans out into **event / message / roster storms** when guildmates are busy.

**Spectacle budget (locked):** one throttled guild-chat line + one private edge toast. Everything else is optional chrome and must fit the envelopes below — or be rejected.

Bar: **invisible next to WA / Details / nameplates** when idle. Players notice **hitches** more than average FPS; agents must optimize for hitch + storm avoidance, not “smooth breathing UI.”

---

## 2. Budget envelopes (local client)

Targets from track [54/beef-budgets](../wow-classic-addon-design/54-memory-fps-budgets/beef-budgets.md) + performance rule. Soft design targets, not Blizzard hard caps.

### 2.1 Duty-cycle envelopes

| Phase | Allowed work | Forbidden |
|-------|--------------|-----------|
| **UI closed** | Event handlers that return in microseconds for foreign traffic; optional one-shot timers finishing a toast | Permanent `OnUpdate`; idle “breathing”; per-frame proximity; combat scanning |
| **UI open** | Interaction + dirty-flag paint coalesced **≤ 10 Hz** | Rebuild full ladder per BeefNet message; per-row forever animators |
| **In combat** | Show insecure frames; light text updates if already dirty | Permanent `OnUpdate`; full ladder rebuild storms; secure-template work; particle rain |
| **Login / sync** | Bursty then quiet; revision merge; deferred UI paint | Paint-per-chunk; `GuildRoster()` spam; peer reply storms (→ [47](../wow-classic-addon-design/47-login-storms-guild-scale/)) |
| **Promote moment** | ≤1 toast anim + ≤1 `/g` line + ≤1 commit path | Center WA pulse; multi-toast fireworks; announce echoes from every peer |

### 2.2 Numeric envelopes (agent QA)

| Metric | Envelope | Reject if |
|--------|----------|-----------|
| Idle attributed CPU (`scriptProfile` + AddonUsage) | **&lt; 0.1 ms/s** after 2–3 min quiet, UI closed | Measurable vs Beef disabled; Beef rises into combat-addon tier |
| Permanent `OnUpdate` | **None** on visible parents when idle | Any always-on updater for juice / scoring / net |
| Open `/beef` cold rebuild | **&lt; 5 ms** typical guild (&lt; ~200 names) | CreateFrame-per-member; full sort+recreate every open |
| Dirty ladder refresh | **&lt; 2 ms**, ≤10 Hz coalesce | Per-message full rebuild |
| Toast + string format | **&lt; 2–3 ms**; queue cap **5** | Unbounded toast spawn; texture spam per promote |
| Apply one `RANK_COMMIT` (no UI) | **&lt; 1 ms** | Syncs UI paint into Core/Net path |
| Memory steady | Prefer **≪ 1 MB** SV; addon KB low hundreds KB–low MB | Tens of MB idle; unbounded standing/event logs |
| Concurrent motion | **1** toast AnimationGroup / timer fade at a time (queue drains) | N row breaths + minimap spin + screen flash together |
| Guild announce | **1** officer-origin line per promotion; CTL-paced | Peer echoes; drip spam; RCL-style multi-line ceremony dumps |
| Roster API | Respect ~**10s** refresh culture; cache lookups | `GuildRoster()` per BeefNet / per suggestion / per juice tick |

### 2.3 Network / event storm envelopes (cross-cutting)

Local FPS and guild storms are the same failure class for agents: “make it feel live.”

| Pipe | Envelope | Storm reject |
|------|----------|--------------|
| BeefNet `GUILD` | CTL pacing; small colon payloads; commits &gt; chatty SCORE spam | Burst 40 commits / full ladder dumps in a loop |
| Login sync | Random delay + reply suppression ([spec §8.3](../../superpowers/specs/2026-07-25-church-of-beef-design.md)) | Every online peer answers every `SYNC_REQUEST` immediately |
| UI dirty | One coalesce window after burst (0.1–0.5 s) | 50× ladder rebuild from 50 `CHAT_MSG_ADDON` in &lt;1 s |
| Instance drip | Events + **low-rate** ticker; combat-gated anti-AFK | Per-frame instance / proximity polls |
| Chat spectacle | Officer client only; product throttle | Auto-congrats bots; filter→re-announce loops |

---

## 3. Adversarial kill list — juice that tanks FPS

Agents love these. **Reject on sight** unless a later spec amendment + measured budget exists.

### 3.1 Always-on / frame-coupled (hard reject)

| Temptation | Why it tanks Classic | Prefer |
|------------|----------------------|--------|
| Breathing / pulsing idle chrome | Permanent `OnUpdate` or looping AnimationGroup while hidden parents still dispatch cost if mis-parented | Static Classic shell; motion only on discrete events |
| Minimap button spin / orbit | Forever updater; fights every other minimap lib | Static icon; LibDBIcon path; no spin |
| Smooth countdown bars on Standing | Hero StatusBar + tick = combat-HUD shape; V1 bans hero bars | Text thresholds only |
| Per-row rank “alive” glow on ladder | N AnimationGroups never torn down; cost scales with guild size | Vertex color / stock highlight on select only |
| Screen-edge vignette / fullscreen flash on promote | Extra fullscreen regions + alpha every promote; stream-hostile | Edge toast + `/g` words |
| ModelFrame / 3D seal preview | Expensive widget class for social utility | 2D texture later (art pass); V1 stock textures |
| Particle / firework / confetti rain | Texture churn + OnUpdate emitters | **No** — product forbids WA-style center spectacle |
| Live “who’s nearby” co-play radar | `GetPlayerMapPosition` / unit scans every frame = bot-shaped + FPS death | Event-driven scoring only; no open-world loops |
| Combat-log / aura “juice triggers” | `COMBAT_LOG_EVENT_UNFILTERED` / `UNIT_AURA` ownership fights WA/DBM | Out of scope for CoB |

### 3.2 Allocation / hitch killers (hard reject on hot paths)

| Temptation | Why it hitch-stutters | Prefer |
|------------|----------------------|--------|
| `CreateFrame` per ladder member on every open / every message | Spike + retain | Row pool; hide extras |
| Rebuild + sort full ladder per `CHAT_MSG_ADDON` | O(n log n) × message rate | Dirty flag → coalesce paint |
| Per-event `{ ... }` / string `..` in loops | GC pauses mid-city / mid-toast | Scratch tables; `SetFormattedText` |
| New AnimationGroup per toast instance forever | Retained animators | Singleton toast; reuse group; nil OnUpdate when done |
| `collectgarbage("collect")` after sync | Forced hitch | Fix allocators; never product-force GC |
| `UpdateAddOnMemoryUsage` on a ticker | Profiler fighting the FPS it measures | Dev-only manual profile |

### 3.3 Soft / gated (allowed only inside envelopes)

| Juice | Allowed if | Still reject if |
|-------|------------|-----------------|
| Toast fade in/out | `C_Timer` or short `AnimationGroup`; singleton; ≤5 queue | Permanent updater; center screen; SFX in V1 |
| Tab switch | Instant Show/Hide | Cross-fade all tab children every click |
| Row select highlight | Texture / stock highlight | Per-row looping pulse |
| Officer confirm chrome | Own insecure frame / careful StaticPopup index | EasyMenu / SecureActionButton “polish” |
| Post-V1 seal textures | PoT TGA + fallbacks; no load fail | Blocking Media; Retail atlases unverified on 20506 |

---

## 4. Adversarial kill list — juice that causes event storms

These may not show in a solo FPS overlay. They still fail guild nights and two-client QA.

| Temptation | Storm shape | Reject / prefer |
|------------|-------------|-----------------|
| “Live ladder” — paint on every BeefNet byte | UI storm + hitch storm | Coalesce ≤10 Hz when open; idle = no paint |
| Refresh roster to “keep officer gate fresh” on every message | Client ignores / thrashes; fights Guild UI | Cache; roster events; ~10s culture |
| Login sync without suppression | N peers × full `SYNC_STATE` | Spec §8.3 delay + suppression |
| Peer echo of guild announce | N identical `/g` lines | Approving officer only; opt-out |
| Auto guild congrats / chat reactions as “juice” | Chat CPS + disconnect risk + ToS-adjacent spam | Human chat; CoB announce is commit-tied only |
| Chat filter that re-sends ceremony | Feedback loop with other social addons | Filters must never send |
| Suggestion / Commit spam buttons without debounce | Double commit + double announce | UI debounce; Core idempotency |
| Instance drip “more juicy” tick rate | Timer storm while grouped | Low-rate ticker; event primary |
| Debug prints / `print` per addon message left on | Chatframe storm for officer | Dev flag only |
| Unbounded My Standing / event log for “history juice” | SV bloat → load hitch every login | Cap / rotate ring buffer |

---

## 5. Agent reject criteria (copy into PR / review)

Use as a **hard checklist**. Any **Reject** row fails the change until redesigned.

### R1 — Idle & OnUpdate

- **Reject** if any permanent `OnUpdate` remains when UI closed and no toast/anim is active.  
- **Reject** if juice requires a visible parent solely to keep an updater alive.  
- **Pass** if motion uses `C_Timer` / `AnimationGroup` and scripts are niled / frames hidden when done.

### R2 — Combat & duty cycle

- **Reject** if in-combat path does full ladder rebuild, row recreate, or secure-template creation.  
- **Reject** if scoring/net parse is frame-coupled.  
- **Pass** if combat is events-only + deferred paint; UI may show but stays cheap.

### R3 — Spectacle scope

- **Reject** center-screen pulses, particle rains, ModelFrame ceremonies, screen flashes, standing-as-castbar.  
- **Reject** V1 SFX / custom Media as load requirements.  
- **Pass** if spectacle is throttled `/g` + private edge toast only (settings: announce opt-out).

### R4 — Message → UI fan-out

- **Reject** if each `CHAT_MSG_ADDON` / commit triggers a full list rebuild.  
- **Reject** if open UI refresh exceeds ~10 Hz under burst.  
- **Pass** if mutate → dirty → coalesce paint; closed UI does not paint.

### R5 — Roster & guild API

- **Reject** `GuildRoster()` (or equivalent full rescan) per message, per suggestion row, or on a juice ticker.  
- **Pass** if roster is cached and refreshed on roster events / respectful intervals.

### R6 — Net & chat storms

- **Reject** sync reply storms, peer announce echoes, multi-line ceremony dumps, auto-congrats bots.  
- **Reject** outbound paths that bypass CTL when CTL is already in the tree.  
- **Pass** if CTL paces BeefNet + announce; one officer line per promote; login suppression held.

### R7 — Allocation & pools

- **Reject** CreateFrame-per-row without pooling; unbounded SV logs; hot-path table/string churn.  
- **Pass** if row pool + capped logs + scratch reuse; toast singleton.

### R8 — Measurement bar

- **Reject** if AddonUsage/`scriptProfile` shows Beef competing with combat addons while idle.  
- **Reject** if P4-style burst (50 COB messages / 1 s) rebuilds UI 50×.  
- **Pass** if idle ≈ noise; promote hitch imperceptible; 2 h guild night memory non-monotonic after GC.

### R9 — Layer & product law (perf-adjacent)

- **Reject** Core `CreateFrame`, UI awarding points, Net inventing ranks — even “for smoother juice.”  
- **Reject** Retail-only animation/atlas APIs without Anniversary verify.  
- **Pass** if UI→Core→Data / Net→Core→Data preserved; 20506-safe widgets only.

---

## 6. Decision flowchart (agent)

```
Juice idea proposed
├─ Needs work while /beef closed and no toast?
│  └─ YES → REJECT (idle must be events-only)
├─ Needs permanent OnUpdate / per-frame scan?
│  └─ YES → REJECT (use C_Timer / AnimationGroup / events)
├─ Center screen / particles / ModelFrame / hero StatusBar?
│  └─ YES → REJECT (spectacle = /g + edge toast)
├─ Triggers paint or GuildRoster per BeefNet message?
│  └─ YES → REJECT (dirty + coalesce; cache roster)
├─ Adds chat/net fan-out (echo, auto-congrats, sync blast)?
│  └─ YES → REJECT (officer-origin + CTL + suppression)
├─ Allocates frames/tables on hot path without pool/cap?
│  └─ YES → REJECT
└─ Fits envelopes §2 + passes R1–R9 → ALLOW (measure on 20506)
```

---

## 7. Scenario rejects (perf QA mapping)

| ID | Scenario | Auto-reject signal |
|----|----------|--------------------|
| P1 | Idle 3 min, Beef only | CPU not near floor |
| P2 | Full UI stack idle | Beef not bottom-tier in AddonUsage |
| P3 | Open/close `/beef` ×20 | Frame/CPU leak after reset |
| P4 | 50 COB messages &lt;1 s | 50 paints / sorts |
| P5 | One promote + announce | Multi-ms hitch; FPS overlay slow to recover; &gt;1 `/g` line |
| P6 | 2 h guild night | SV/memory climb without bound |
| P7 | Two clients login together | Sync reply storm / roster thrash |
| P8 | In combat + panel open | Rebuild storm or secure errors from juice |

---

## 8. What good juice looks like (positive envelope)

Keep agents from over-rejecting safe polish:

| OK | Why |
|----|-----|
| Singleton edge toast, hold + fade via timer/AnimationGroup | Discrete; tear-down clear |
| Instant tab Show/Hide | No frame tax |
| Dirty ladder coalesce while open | Bounded Hz |
| Stock template hover/highlight | No custom updater |
| One formatted announce string per Commit | Spectacle without chrome |
| Pool of ~visible ladder rows | O(viewport), not O(guild) per paint |

---

## 9. Authority & depth (do not fork)

| Need | Source |
|------|--------|
| Product spectacle / UI locks | Spec §10, §15; agent briefing [`ui-polished-direction-for-agents.md`](../../superpowers/ui-polished-direction-for-agents.md) |
| Performance rule | [`.cursor/rules/wow-performance.mdc`](../../../.cursor/rules/wow-performance.mdc) |
| Budgets & profiling | [54-memory-fps-budgets](../wow-classic-addon-design/54-memory-fps-budgets/) |
| Events vs OnUpdate | [04/03-events-onupdate-throttling.md](../wow-classic-addon-design/04-toc-api-performance/03-events-onupdate-throttling.md) |
| BeefNet / CTL | [14](../wow-classic-addon-design/14-addon-messaging-beefnet/), [72](../wow-classic-addon-design/72-guild-chat-announce-api/) |
| Login storms | [47](../wow-classic-addon-design/47-login-storms-guild-scale/) |
| Construction / motion | [02-lua-vs-xml-frames.md](02-lua-vs-xml-frames.md) |
| Taint (orthogonal but co-fails) | [03-taint-lockdown-ux.md](03-taint-lockdown-ux.md) |

If research here conflicts with the design spec, **spec wins** — log a §15 decision; do not silently ship stormy juice.

---

## 10. One-line agent contract

**No juice may buy delight with permanent frame work, per-message UI rebuilds, roster/chat/net storms, or center-screen spectacle — idle stays quiet; promote stays one toast and one officer line.**
