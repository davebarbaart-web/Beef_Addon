# Beef copy & UX map (empty / degraded)

**Track:** 41 — empty states & degraded UX  
**Question:** What should Church of Beef *say* in each scenario — Classic-short, on-brand, not clever-at-the-cost-of-clarity?

Copy formula used below: **Heading (state) → Body (why / benefit) → Next step** ([UXPin / Yifrah structure](https://www.uxpin.com/studio/blog/ux-best-practices-designing-the-overlooked-empty-states); [Eleken hierarchy](https://www.eleken.co/blog-posts/empty-state-ux)). Prefer forward verbs over “You haven’t…” ([Tour Kit / Polaris starting-state note](https://usertourkit.com/blog/empty-states-that-convert-onboarding-design-patterns)).

Tone guardrail: scripture/flavor allowed in **heading**; body stays plain. Full voice bible → track 32.

---

## Surface inventory (V1)

| Surface | Role in degraded UX |
|---------|---------------------|
| Ladder tab body | Rank shelves + empty-state banner |
| My Standing tab body | Points / events empty or paused |
| Officer tab body | Empty suggestion queue (Officer+ only) |
| Frame status chip / footer | Sync / cache / peers / unguilded |
| Optional one-shot chat print | First open only (never spam) |
| Guild chat (officer announce) | No-addon peer spectacle (not an empty state — the *escape hatch*) |

---

## Scenario A — First install (in guild)

| Slot | Proposed copy |
|------|----------------|
| Ladder heading | The ranks await their first names |
| Ladder body | Standing starts on your client. Officers bless promotions into the shared ladder. |
| Ladder next | Run a dungeon or BG with a guildmate — they need not run Church of Beef. |
| Standing heading | Fresh Beef · 0 standing |
| Standing body | Shared instances, Gora, and ceremonies feed this tab. |
| Standing events empty | No rites recorded yet. |
| Officer queue empty | No petitions yet. The flock is quiet. |
| Status chip | Syncing ladder… → Synced / Using cached ladder |
| Optional first-print | Church of Beef: `/beef` opens the Church. Standing is local until an officer blesses a rank. |

**Do not:** “No data found.” **Do:** Show all seven rank rows as empty shelves with local highlight.

---

## Scenario B — Not in a guild

| Slot | Proposed copy |
|------|----------------|
| Ladder heading | No flock, no ladder |
| Ladder body | Church of Beef tracks guild standing. Join or create a guild to open the ranks. |
| Ladder next | Use the default Guild UI to join — then reopen `/beef`. |
| Standing heading | Scoring paused |
| Standing body | Standing waits until you wear a guild tag. |
| Status chip | Not in a guild |
| Chat | Prefer silence after one optional first-open line; no per-login spam |

**Do not:** Error-red modal. **Do:** Keep rank names visible as preview chrome (structure without occupants).

---

## Scenario C — No officers online

| Slot | Proposed copy |
|------|----------------|
| Status chip | No officers online |
| Standing (member) | Your standing still accrues. Petitions wait for an officer. |
| Ladder footer | Ladder shows the last blessed ranks on this client. |
| Officer alone, empty queue | No petitions — enjoy the quiet. |
| Officer alone, local approve | Blessing saved here; peers will catch up when they sync. |

**Do not:** “Sync failed” when the only issue is social availability. **Do:** Separate *authority offline* from *transport failure*.

---

## Scenario D — Peers without addon

| Slot | Proposed copy |
|------|----------------|
| Status chip | Few Church clients online |
| Ladder body (thin) | Only blessed ranks known to this client appear. Guildmates without the addon still count for shared-instance standing. |
| Footer tip | Rank shout-outs still hit guild chat — no addon required to witness. |
| Officer optional later | `/beef peers` or RCL-style waiting list (V1.1) |

**Do not:** Nag “Tell your guild to install” on every open. **Do:** One calm chip; rely on chat spectacle for non-installers (spec §10 / §13.11).

---

## Scenario E — Sync pending / timeout

| Phase | Status chip | Ladder body note |
|-------|-------------|------------------|
| Request sent | Syncing ladder… | Show cache if any; don’t clear |
| Peer answered | Synced | Brief; then idle |
| Timeout, had cache | Using cached ladder | “No peers answered — cache kept.” |
| Timeout, empty cache | No peers online | Same as first-install empty shelves + “Ask an officer who runs Church of Beef to log in once.” |

Progression mirrors [RCL “Waiting for response” → not installed](https://github.com/evil-morfar/RCLootCouncil2/wiki/Version-Checker) without needing a full version table in V1.

---

## Compound states (priority)

When multiple apply, show the **hardest gate** in the banner; keep secondary info in the chip.

1. Not in guild (B)  
2. Sync pending (E) — only if in guild  
3. First install empty shelves (A) — if cache empty after E settles  
4. No officers (C) / few peers (D) — chips, not banners  

Example: unguilded + empty SV → **only B**. In guild + syncing + empty cache → chip E + A shelves.

---

## Antipatterns (Beef-specific)

| Antipattern | Why it hurts Church of Beef |
|-------------|-----------------------------|
| Blank ladder with no banner | Looks like the “command works, nothing appears” failure mode the spec forbids |
| Joke-only empty (“Fridge empty lol”) | Comedy without pathway ([Eleken](https://www.eleken.co/blog-posts/empty-state-ux)) |
| Blocking modal until sync completes | Soft-lock; fights Classic login lag |
| “Install required” for dungeon credit | Contradicts §7.1 |
| Treating cache as error | Spec: cache is the product offline |
| Officer tab visible but disabled grey soup | Prefer hide (spec §11) |

---

## Acceptance checklist (design review)

- [ ] Unguilded: scoring paused language + join pathway  
- [ ] First install: seven ranks visible; local Fresh Beef  
- [ ] Sync: Pending / Synced / Cached — never infinite wait  
- [ ] No officers: member standing still explained as live  
- [ ] No-addon peers: instance credit + guild-chat spectacle called out once  
- [ ] Personality only in headings; bodies instructional  
- [ ] No implementation committed in this research track
