# 14 — Celebration & promotion spectacle design

**Status:** Research guidance (not product law)  
**Audience:** Agents designing polish / spectacle choreography for Church of Beef  
**Last updated:** 2026-07-26  
**Workspace:** `/Volumes/AI_Design_Drive/Beef_Addon`

**Maps to:** Design spec §10 (toasts + guild-chat announce), §13.11 (social reaction), §15 (SFX silent / announce locks); glossary rows 68, 74–79; tracks [17](../wow-classic-addon-design/17-stream-overlay-readability/), [20](../wow-classic-addon-design/20-sound-sfx-feedback/), [32](../wow-classic-addon-design/32-microcopy-tone-voice/), [49](../wow-classic-addon-design/49-officer-notifications/), [72](../wow-classic-addon-design/72-guild-chat-announce-api/).  
**Juice sources:** [11b](11b-juice-sources-digest.md) · fundamentals [11](11-game-juice-fundamentals.md) · streamer [55](55-streamer-guild-event-ux.md)

> If this note disagrees with the design spec or locked glossary, **spec wins**. Log any product change in the decisions log — do not silently fork policy here.

---

## 1. Executive summary

Celebration systems in games and live events work by **tiering intensity** to scarcity: small receipts for frequent feedback, medium callouts for meaningful progress, and rare “jumbotron” moments for institutional peak events. Twitch/stream practice reinforces the same ladder — keep alerts **on brand, quick, and non-blocking**, reserving heavier 3D / full-bleed treatments for bigger wins ([GETREKT — Twitch overlays & animated alerts](https://www.getrekt.com/blogs/news/ultimate-guide-to-twitch-overlays-streamelements-widgets-animated-alerts); [Twitch — Celebrate your community with alerts](https://blog.twitch.tv/en/2023/07/25/celebrate-your-community-your-way-with-twitch-s-alerts/)).

Church of Beef already locked the V1 **spectacle budget**: one throttled officer `/g` line (visible without the addon) + private edge toasts ([spec §10](../../superpowers/specs/2026-07-25-church-of-beef-design.md); [17 — spectacle budget](../wow-classic-addon-design/17-stream-overlay-readability/beef-v1-spectacle-budget.md)). This note adapts cross-domain celebration craft into a **Small / Medium / Epic** choreography table that fits Classic addon constraints: **no bots, no protected-action bypass, no combat automation, no Retail-only APIs**, and no photosensitivity-hostile full-screen strobes.

**Verdict for implementers:** Keep V1 inside Small + Medium. Reserve Epic for scarce seats (Council / Prophet) and V2+ theater — never for standing drips.

---

## 2. Cross-domain patterns (what to steal)

### 2.1 Games — reward acknowledgment hierarchy

Progression UIs treat celebrations as **feedback loops**, not wallpaper:

| Pattern | Job | Intensity cue |
|---------|-----|----------------|
| Toast / snackbar | Confirm a completed op without stealing focus | Short dwell, peripheral placement ([StudyAround — toast design](https://studyaround.blog/toast-notification-design-guide); Material snackbar norms cited in [32 — toast copy](../wow-classic-addon-design/32-microcopy-tone-voice/toast-copy-length.md)) |
| Achievement / unlock plate | Make a scarce unlock *feel* paid-off | Icon + short title; themed severity (gold unlock vs system cyan) ([Achievement Toast Pack — itch.io](https://mtw1man2.itch.io/achievement-toast-pack-unlock-reward-progress-popup-ui)) |
| Level-up / rank fanfare | Institutional identity change | Longer dwell, optional SFX, public channel |
| Credit drip | Meter tick | Coalesce; never public spam |

Industry toast guidance converges on **~3–6 s** success dwell, longer for warnings, and **one toast at a time** so new messages replace or wait ([StudyAround](https://studyaround.blog/toast-notification-design-guide); [LogFlow via track 17 duration](../wow-classic-addon-design/17-stream-overlay-readability/duration-and-attention.md)). Stream capture needs the **upper** end of that band (6–8 s for promote) because viewers are distracted ([17 — duration](../wow-classic-addon-design/17-stream-overlay-readability/duration-and-attention.md)).

**Steal for Beef:** Severity ladder (receipt → recognition → rite).  
**Avoid:** Achievement-spam density; every standing point as an unlock plate.

### 2.2 Live events & stadium jumbotron logic

Stadium screens exist to briefly promote a person or moment from **spectator → spectacle** — stats, close-ups, fan callouts ([Jumbotron — Wikipedia](https://en.wikipedia.org/wiki/Jumbotron); cultural “on the board” moments in live sports coverage). The design lesson is scarcity + naming:

1. **Name the person** (and the honor).  
2. Hold long enough for the crowd to react.  
3. Return the screen to the game.

Guild chat is Beef’s jumbotron: durable, shared, OBS-readable, works for members **without** the addon ([17 — spectacle budget](../wow-classic-addon-design/17-stream-overlay-readability/beef-v1-spectacle-budget.md)).

### 2.3 Stream / creator celebration ladders

Creator tooling already ships intensity tiers:

- Flat / quick animated alerts for common interactions.  
- Heavier 3D / chest-style alerts for bigger celebrations ([GETREKT guide](https://www.getrekt.com/blogs/news/ultimate-guide-to-twitch-overlays-streamelements-widgets-animated-alerts)).  
- Advice: **on theme, quick, impactful, do not block content** (same source).  
- Twitch’s own alert framing: some moments are “one-of-a-kind” and deserve appropriate celebration weight ([Twitch blog](https://blog.twitch.tv/en/2023/07/25/celebrate-your-community-your-way-with-twitch-s-alerts/)).

**Steal:** Tiered duration + visual weight.  
**Avoid:** Shipping OBS overlay chrome inside the addon; Beef must coexist with the streamer’s own alert stack ([17 — safe zones](../wow-classic-addon-design/17-stream-overlay-readability/capture-safe-zones.md)).

### 2.4 Classic addon cousins (social celebration)

| Cousin | Pattern | Beef mapping |
|--------|---------|--------------|
| Gargul / RCLootCouncil | Authority client speaks; peers get UI, not N-way chat echo | Approving Officer+ owns `/g` ([72 — single announcer](../wow-classic-addon-design/72-guild-chat-announce-api/single-announcer-patterns.md)) |
| Attune | Celebrate **completion**, not every drip | Announce on rank commit, not `SCORE_EVENT` |
| LS: Toasts Classic | Dedicated toast surface for Classic alert replacement ([CurseForge — LS: Toasts Classic](https://www.curseforge.com/wow/addons/ls-toasts-classic)) | Own Beef toast plate; do not depend on LS |
| GuildCongratsTBC | Auto `/g` congrats on milestones ([CurseForge — GuildCongratsTBC](https://www.curseforge.com/wow/addons/guildcongratstbc)) | **Do not copy auto-reply bots** — Beef is announce-from-authority, not chat-bot pile-on |

---

## 3. Classic addon constraint map

### 3.1 Hard safety (non-negotiable)

| Constraint | Implication for spectacle |
|------------|---------------------------|
| No bots / automation | No auto-responders in guild chat; no scrape-driven “congrats bots” |
| No protected-action bypass | Never `GuildPromote` / rank APIs as celebration; ranks via officer Commit (or roster-backed suggestion flow per product amendments) |
| Announce / track / sync only | Spectacle reports state that Core already committed — UI/Net never invent ranks |
| No Retail-only APIs | Stay on Anniversary `20506` FrameXML patterns |
| Photosensitivity | No full-screen strobe / flashing textures as default ceremony ([20 — accessibility](../wow-classic-addon-design/20-sound-sfx-feedback/03-accessibility-and-spam.md); [05 — a11y](../wow-classic-addon-design/05-packaging-community-antipatterns/02-accessibility-density-clean-ui.md)) |
| Combat HUD coexistence | Edge toasts only; never center WA pulses for social ([01 synthesis](../wow-classic-addon-design/01-ux-patterns/church-of-beef-synthesis.md); [08 combat HUD](../wow-classic-addon-design/08-combat-hud-alerts/church-of-beef-implications.md)) |

### 3.2 Legal / technical surfaces (what is allowed)

| Surface | Classic-safe use | Notes |
|---------|------------------|-------|
| Custom edge toast (`CreateFrame` on `UIParent`) | **Primary** member-facing celebration | Opaque scrim; title-safe; one at a time ([43 — toast sizing](../wow-classic-addon-design/43-ui-scale-pixel-perfection/toast-sizing.md)) |
| `SendChatMessage(..., "GUILD")` | **Primary** public spectacle | ≤255 chars; approving officer only; CTL-shaped ([72](../wow-classic-addon-design/72-guild-chat-announce-api/)) |
| `RaidNotice_AddMessage(RaidWarningFrame, …)` | **Officer AttentionKit only** (pending queue) | Local chrome — never `SendChatMessage` RAID_WARNING ([49](../wow-classic-addon-design/49-officer-notifications/); [WoWInterface personal RW](https://www.wowinterface.com/forums/showthread.php?t=36250)) |
| `UIFrameFlash(frame, …)` | Soft fade on **toast panel only** | FrameXML helper; do not flash the whole screen ([UIFrameFlash — Wowpedia](https://wowpedia.fandom.com/wiki/API_UIFrameFlash); [AddOn Studio](https://addonstudio.org/wiki/WoW:API_UIFrameFlash)) |
| Soft `PlaySound` / licensed `.ogg` | Post-V1, **default off** | Never rip Blizzard soundtrack; ban `RAID_WARNING` kit as default ([20 V1/V2](../wow-classic-addon-design/20-sound-sfx-feedback/04-beef-v1-v2.md); spec §10) |
| `FlashClientIcon()` | Officer AttentionKit | Taskbar nudge, not in-world flash ([49 recipe](../wow-classic-addon-design/49-officer-notifications/beef-officer-alert-recipe.md)) |
| BeefNet `RANK_COMMIT` | Sync truth to peers | Peers toast locally; **stay silent** in `/g` |

### 3.3 Explicit bans (celebration anti-patterns)

| Ban | Why |
|-----|-----|
| Every peer re-announces on `RANK_COMMIT` | Spam; fails single-announcer model |
| Announce on suggestion create / login sync heal | False ceremony |
| Full-screen tint / strobe “fanfare” | Photosensitivity + combat confusion |
| Center-screen WA-style pulse for promote | Competes with DBM/WA; off-brand for social tool |
| `SOUNDKIT.RAID_WARNING` / ready-check as promote SFX | Trains boss-mechanic reflexes ([20](../wow-classic-addon-design/20-sound-sfx-feedback/)) |
| Auto guild-chat “congrats” replies from all clients | Bot-shaped; ignore-list chaos |
| Using `RaidWarningFrame` as the **member promote toast** | Combat/social confusion ([66 — toast implications](../wow-classic-addon-design/66-editmode-classic-coexistence/beef-panel-toast-implications.md)) |

---

## 4. Tiered celebration system proposal (Small / Medium / Epic)

Intensity scales with **institutional meaning × rarity × audience**. Channels stack; they never substitute for Core truth.

### 4.1 Tier definitions

| Tier | Intent | Audience | Cadence target | Primary channels |
|------|--------|----------|----------------|------------------|
| **Small** | Private receipt — “the system noticed” | Local player (addon) | Frequent (credits, suggestions) | Edge toast only |
| **Medium** | Shared recognition — “the flock heard” | Whole guild + stream (chat) + promotee toast | Uncommon (ladder promotions / demotions) | Officer `/g` + longer toast |
| **Epic** | Rite / jumbotron — “history changed” | Guild + stream + all online addon clients | Rare (Council, Prophet, excommunication drama, V2 ceremony close) | Medium stack + optional local fanfare (never auto-bot) |

### 4.2 Channel stack by tier

| Channel | Small | Medium | Epic |
|---------|-------|--------|------|
| Edge toast (promotee / actor) | Yes (~3.5–5 s credit; ~5–7 s suggestion) | Yes (~6–8 s) | Yes (~8–10 s or two-line plate) |
| Officer AttentionKit (RaidNotice + print + icon flash) | SoftUpdate only if queue already hot | N/A for member promote | Optional for Council/Prophet pending |
| Guild chat (`GUILD`, officer-owned) | **No** | **Yes — one line** | **Yes — one ceremonial line** (still one line; richer copy, not more lines) |
| Soft panel fade (`UIFrameFlash` on toast) | Optional subtle | Preferred | Preferred |
| Full-screen flash / shake | **No** | **No** | **No** (default forever) |
| SFX | Silent (V1) | Silent (V1); optional soft cue later, default off | Optional branded one-shot later, default off |
| Ladder tab highlight pulse | Optional 1-shot row flash | Yes — highlight promotee row if frame open | Yes — sticky highlight until dismiss / tab change |
| BeefNet peer behavior | Local toast if relevant | Local toast; **no** `/g` | Local toast + optional epic plate; **no** `/g` |

### 4.3 Event → tier matrix (Church of Beef)

| Event | Tier | Public `/g`? | Local toast job | Copy posture |
|-------|------|--------------|-----------------|--------------|
| Standing / Gora / ceremony **credit** | **Small** | No | Confirm `+n` standing | Procedural; coalesce bursts |
| **Suggestion created** (member) | **Small** | No | “Eligible — officers can review” | Hopeful, short ([32](../wow-classic-addon-design/32-microcopy-tone-voice/toast-copy-length.md)) |
| Officer pending queue AttentionKit | Officer kit (not member tier) | No | Center caution for Officer+ | Serious register ([49](../wow-classic-addon-design/49-officer-notifications/)) |
| Rank **approved** Fresh→Cooked … → Butcher | **Medium** | Yes (if announce on) | `Elevated to {Title}.` | Liturgical sentence in chat; toast = receipt |
| Rank **demoted** / excommunication | **Medium** (drama) | Yes | Title change confirm | Same throttle; solemn voice |
| **Council** appointment | **Epic** | Yes | Two-line: name + seat | Scarce seat = scarce airtime |
| **Prophet** bestowal | **Epic** | Yes | Two-line + unique title weight | Rarest rite |
| Login sync heal / revision ignore | — | **Never** | Silent or debug | Anti-spectacle |

Ladder titles (lore prose only): Fresh Beef → Cooked Beef → Beef Knight → … → Butcher → Beef Council → Beef Prophet ([canon ranks](../../canon/ranks.md)). Thresholds stay in `Data/Ranks.lua`.

### 4.4 Choreography (recommended beat sheets)

#### Small — credit / suggestion

```
Core awards / enqueues
  → UI shows one edge toast (replace/coalesce, never stack)
  → Fade out 3.5–7 s
  → No guild chat, no RaidNotice, no SFX
```

#### Medium — ladder promote / demote

```
Officer+ Commit succeeds locally
  → Broadcast RANK_COMMIT (BeefNet)
  → If announce enabled + guildchat_speak: ONE SendChatMessage GUILD
  → Promotee (and peers with addon): edge toast 6–8 s
  → Approving officer: optional short ack toast (not a second /g)
  → Ladder open? Flash promotee row once
```

Authority rule: **only the approving officer’s client** sends `/g` ([72](../wow-classic-addon-design/72-guild-chat-announce-api/single-announcer-patterns.md)).

#### Epic — Council / Prophet (and future ceremony close)

```
Same Medium pipeline (Commit → RANK_COMMIT → one /g)
  → Toast: taller plate, two lines (name + honor), ~8–10 s
  → Optional soft UIFrameFlash on toast panel only
  → V2+: optional branded SFX (default off); optional in-frame “spotlight” strip
  → Never: full-screen strobe, RAID_WARNING sound, multi-line /g walls
```

### 4.5 Copy budgets (aligned with existing microcopy research)

| Surface | Budget | Example |
|---------|--------|---------|
| Small toast | ≤ ~60 chars, 6–12 words | `Ceremony marked. Standing +12.` |
| Medium toast | One line title | `Elevated to Beef Knight.` |
| Medium `/g` | One ceremonial sentence, glanceable @ 720p | `The Church recognizes Beefina, elevated to Beef Knight.` |
| Epic toast | Title + name (two lines max) | `Beef Prophet bestowed` / `Beefina` |
| Epic `/g` | Still **one** line; denser liturgy OK within 255 | Prefer one breath, not a paragraph |

Do not paste the guild sermon into the toast ([32](../wow-classic-addon-design/32-microcopy-tone-voice/toast-copy-length.md)).

### 4.6 Stream / accessibility notes per tier

| Concern | Small | Medium | Epic |
|---------|-------|--------|------|
| OBS corners | Stay title-safe; avoid BR webcam / BL chat defaults | Same | Same; longer dwell helps VOD glance |
| Encode contrast | Opaque scrim | Opaque scrim | Opaque scrim — no glass |
| Photosensitivity | Fade only | Fade only | Fade only — **no** screen flash escalation |
| Mute / streamer quiet | N/A (silent) | Announce remains public rite; privacy must not silently kill `/g` ([spec §10](../../superpowers/specs/2026-07-25-church-of-beef-design.md)) | Same |

### 4.7 Phasing vs product locks

| Tier | V1 | V1.1 / polish | V2+ |
|------|----|---------------|-----|
| Small | Ship | Toast mute only if playtest proves noise | Optional soft tick SFX (off) |
| Medium | Ship (`/g` + toast) | Streamer quieter-toasts preset (never kill announce) | Optional branded promote SFX (off) |
| Epic | **Copy + slightly richer toast OK**; no new chrome required | — | Ceremony spotlight / dashboard theater |

V1 success criterion remains **guild-chat social reaction** (§13.11), not toast FPS ([17 — spectacle budget](../wow-classic-addon-design/17-stream-overlay-readability/beef-v1-spectacle-budget.md)).

---

## 5. Design principles (checklist)

1. **Scarcity buys intensity** — credits are Small; ladder commits are Medium; appointed seats are Epic.  
2. **Chat is the jumbotron; toast is the receipt** — viewers without the addon must still witness Medium/Epic.  
3. **One announcer** — authority client only; peers sync silently.  
4. **One toast at a time** — promote interrupts credit; credit never interrupts promote.  
5. **Edge, not center** — leave fovea to combat HUD and the streamer’s OBS alerts.  
6. **Silent by default** — spectacle is text + motion fade; SFX is a later opt-in.  
7. **No strobe escalation** — Epic means longer / taller / rarer, not brighter flashes.  
8. **Celebrate commits, not drips** — Attune-style completion energy ([72](../wow-classic-addon-design/72-guild-chat-announce-api/single-announcer-patterns.md)).

---

## 6. Juice-literature → celebration choreography (Classic filter)

Celebration UX is juiciness applied to **scarce recognition**, not to every credit drip. Map from [11b](11b-juice-sources-digest.md):

| Juice principle | Celebration application | Classic ban / substitute |
|-----------------|-------------------------|--------------------------|
| Cascading redundant feedback (Gabler / Juice It) | Medium = toast + `/g` + optional row flash | Not toast + particles + shake + SFX |
| Amplification ∝ importance (Hicks) | Small / Medium / Epic tiers (§4) | Same bounce for credit and Prophet = fail |
| Permanence (Nijman) | `/g` line is the residue; toast is ephemeral | Particles as “residue” banned |
| Hit-stop / hold | Optional ≤50 ms before Medium toast enter | No slow-mo raid freeze |
| Context / immersion (Kelly) | Liturgical copy + Classic shell | Don’t paste OBS Alert Box into UIParent |
| Spectator coaching | Announce readable at 720p without addon | Icon-only “celebration” fails V1 |
| Hype Train cooldown | Throttle + no drip `/g` | Auto GuildCongrats pile-on banned |
| Medium juiciness > extreme | Epic = taller/rarer/longer — not strobe | Full-screen flash forever banned |
| Silent multimodal (V1) | Text + motion fade only | Sound later, default off |

**Parametric celebration knobs** (research proposal): `tier ∈ {S,M,E}`, `dwell_s`, `toast_height_lines` (1–2), `title_overshoot_pct` (0 for Small, ≤10 for Medium/Epic), `announce_enabled` (officer checkbox). Do not parameterize particle count or shake amplitude in V1.

**Jumbotron beat (stadium → `/g`):** name the person → hold long enough for crowd reaction → return fovea to the game ([Jumbotron](https://en.wikipedia.org/wiki/Jumbotron); [55](55-streamer-guild-event-ux.md)).

---

## 7. Open questions (research → product)

| Question | Suggestion |
|----------|------------|
| Should Cooked Beef (first promote) get Epic-lite once per character? | Optional “first heat” Medium+ (longer toast only); keep single `/g` |
| Demotion Epic vs Medium? | Keep Medium public; allow Epic toast dwell if officers want stream drama |
| Officer ack toast on every Medium? | Prefer SoftUpdate print for officer; promotee owns the flourish |
| Roster-backed ladder amendment (no Commit announcer)? | Toast + officer queue remain; re-enable Medium `/g` via roster-diff later ([roster-backed design](../../superpowers/specs/2026-07-25-roster-backed-ladder-design.md)) |

---

## 8. Sources

### External

- [StudyAround — Toast Notification Design](https://studyaround.blog/toast-notification-design-guide) (Apr 2026)  
- [GETREKT — Ultimate guide to Twitch overlays / animated alerts](https://www.getrekt.com/blogs/news/ultimate-guide-to-twitch-overlays-streamelements-widgets-animated-alerts)  
- [Twitch — Celebrate Your Community Your Way with Alerts](https://blog.twitch.tv/en/2023/07/25/celebrate-your-community-your-way-with-twitch-s-alerts/)  
- [Twitch — Hype Train Guide](https://help.twitch.tv/s/article/hype-train-guide)  
- [Jumbotron — Wikipedia](https://en.wikipedia.org/wiki/Jumbotron)  
- [Achievement Toast Pack (itch.io)](https://mtw1man2.itch.io/achievement-toast-pack-unlock-reward-progress-popup-ui)  
- [LS: Toasts Classic — CurseForge](https://www.curseforge.com/wow/addons/ls-toasts-classic) (May 2026)  
- [GuildCongratsTBC — CurseForge](https://www.curseforge.com/wow/addons/guildcongratstbc) (contrast / anti-pattern)  
- [WoWInterface — personal RaidWarning](https://www.wowinterface.com/forums/showthread.php?t=36250)  
- [Wowpedia — UIFrameFlash](https://wowpedia.fandom.com/wiki/API_UIFrameFlash)  
- [AddOn Studio — UIFrameFlash](https://addonstudio.org/wiki/WoW:API_UIFrameFlash)  
- [AddOn Studio — SendChatMessage](https://addonstudio.org/wiki/WoW%3AAPI_SendChatMessage)  
- Juice / feel canon (annotated): [11b](11b-juice-sources-digest.md) — Juice It, Don’t Juice It, Hicks, Gabler, Nijman, GMTK, Twitch alerts  

### Internal (normative context)

- [Design spec](../../superpowers/specs/2026-07-25-church-of-beef-design.md) §10, §13.11, §15  
- [UI polished direction for agents](../../superpowers/ui-polished-direction-for-agents.md)  
- [17 — spectacle budget](../wow-classic-addon-design/17-stream-overlay-readability/beef-v1-spectacle-budget.md)  
- [17 — duration](../wow-classic-addon-design/17-stream-overlay-readability/duration-and-attention.md)  
- [20 — SFX V1/V2](../wow-classic-addon-design/20-sound-sfx-feedback/04-beef-v1-v2.md)  
- [32 — toast copy](../wow-classic-addon-design/32-microcopy-tone-voice/toast-copy-length.md)  
- [49 — officer alerts](../wow-classic-addon-design/49-officer-notifications/)  
- [72 — guild chat announce](../wow-classic-addon-design/72-guild-chat-announce-api/)  
- [00 — implications](../wow-classic-addon-design/00-church-of-beef-implications.md)  
- [55 — streamer guild-event UX](55-streamer-guild-event-ux.md)  

### Search dumps (follow-up)

- `docs/research/agent-polish-vision/_search-celebration-spectacle.json`  
- `docs/research/agent-polish-vision/_search-celebration-apis.json`  
- `docs/research/agent-polish-vision/_search-celebration-live.json`  
- `.firecrawl/juice-research/search-streamer-readability.json` (gitignored scrape cache)  
