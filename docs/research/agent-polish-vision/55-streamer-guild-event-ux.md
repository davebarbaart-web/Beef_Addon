# 55 — Streamer / guild-event UX (Twitch-era social ladder)

**Lane:** Agent polish vision  
**Date:** 2026-07-26  
**Audience:** Agents polishing Church of Beef as a **streamer-event guild ladder** (not a combat HUD)  
**Maps to:** Design spec §§1, 10, 13.11, 14–15 · UI brief [`ui-polished-direction-for-agents.md`](../../superpowers/ui-polished-direction-for-agents.md)  
**Cousins:** [17 stream overlay readability](../wow-classic-addon-design/17-stream-overlay-readability/) · [14 celebration spectacle](14-celebration-spectacle-design.md) · [12 social progression](12-social-progression-loops.md) · [18 color hierarchy](18-color-hierarchy-readability.md) · [11b juice sources](11b-juice-sources-digest.md)  
**Status:** Research guidance — **not** product law. Spec + glossary win on conflict.

---

## 1. Verdict (one screen)

Church of Beef’s product job on a guild stream night is **name someone, hold the beat, return the screen to the game**. Twitch-era social guilds win when viewers can parse a recognition moment at **720p / phone player** without installing the addon, while facecam + chat + OBS alerts stay unblocked.

| Channel | Stream role | V1 law |
|---------|-------------|--------|
| Officer `/g` promote/demote line | **Primary spectacle** (chat-camera + VOD durable) | One throttled plain sentence; default ON |
| Local edge toast | Secondary flourish for capture of that client | Opaque, title-safe, one at a time, 3.5–8 s by severity |
| `/beef` ladder / Standing | Process UI — open on purpose | Classic shell; not a broadcast overlay |
| OBS alert stack | Streamer’s kit | Coexist; never ship Beef as center-screen WA/OBS chrome |

**Anti-pattern:** turning Beef into a second Alert Box (full-screen hype, BR corner spam, credit drips in chat). Reserve airtime for **rank commits** and scarce seats.

---

## 2. What Twitch-era event UX teaches

### 2.1 Layout ownership (chat + camera first)

Successful gaming layouts keep **most of the frame as gameplay**, then park cam / chat / alerts in predictable corners ([5856.tw overlay tips](https://5856.tw/stream-overlay-configurator); [OBS game-layout tutorial](https://obsproject.com/kb/stream-tutorial-1-game)):

| Element | Typical practice | Beef implication |
|---------|------------------|------------------|
| Game | **70–80%** of canvas | Do not grow process panels into “stream theater” |
| Webcam | Corner; ~**15–20%** width; inset from edges | Default toast must not assume BR is free |
| Chat overlay | Side / unused edge; **5–10** messages; readable fonts | `/g` announce is the durable social beat; don’t stack a second chat-like panel |
| Alerts | Top or near cam; seen, not disruptive ([InfluencerDB overlay checklist](https://influencerdb.net/social-media-platform-playbooks/gratis-twitch-overlays)) | Leave fovea + alert zones to the creator |

Minimal layouts often retain viewers better than widget piles: gameplay + small cam + sparse alerts ([Streamoz layout retention](https://streamoz.com/twitch-streaming-layout-tweaks-that-keep-viewers-watching)). Beef should feel like **one more clear beat**, not another animated layer.

### 2.2 Hype moments are scarce and tiered

Creator tooling treats celebration as a **ladder** — quick flat alerts for common events, heavier treatments for rare wins ([OWN3D alert widgets](https://hi.own3d.pro/en/features/alert-widgets); [Streamlabs Alert Box](https://streamlabs.com/stream-widgets/alert-box); [Twitch Alerts blog](https://blog.twitch.tv/en/2023/07/25/celebrate-your-community-your-way-with-twitch-s-alerts/)). Platform features like [Hype Train](https://help.twitch.tv/s/article/hype-train-guide) formalize the same idea: spike → countdown → levels → cooldown → named status (Conductor).

**Steal for Beef (in-game, Classic-safe):**

| Twitch pattern | CoB analogue |
|----------------|--------------|
| Kickoff + countdown | Officer Commit → `/g` line + promote toast |
| Levels / goals | Standing → threshold → suggestion (process, not stream spam) |
| Conductor / badges | Ladder title + scarce Council / Prophet seats |
| Cooldown after train | Throttle + no drip announces |
| Organic spike, not forced | Real guild night; no bots / auto-congrats |

**Do not steal:** full-screen OBS alert chrome inside the addon; monetization CTAs; bot pile-ons in guild chat ([14 — GuildCongrats ban](14-celebration-spectacle-design.md)).

### 2.3 Social guilds run on recognition, not meters

Twitch communities bond through **named callouts, status, and shared ritual** — not DPS tables. CoB already maps that stack ([12](12-social-progression-loops.md)): short credit → medium title aspiration → long institutional memory via chat spectacle. Stream UX must make the **long beat** legible to lurkers and non-addon members ([spec §13.11](../../superpowers/specs/2026-07-25-church-of-beef-design.md)).

### 2.4 Worst common watch path

Design and QA against:

1. **1280×720** encode (or phone-width Twitch player)  
2. Busy Classic HUD (dungeon / raid)  
3. Streamer cam + alert box occupying a corner  
4. Distracted viewer who glances after a callout  

If the toast fails but the `/g` line lands, V1 still meets the social criterion — fix toast defaults before calling the flourish done ([17 spectacle budget](../wow-classic-addon-design/17-stream-overlay-readability/beef-v1-spectacle-budget.md)).

---

## 3. Church of Beef as streamer-event ladder

### 3.1 Audience matrix

| Audience | Needs from Beef | Surface |
|----------|-----------------|---------|
| Guild member (no addon) | Hear the rite | Guild chat |
| Addon member | Confirm standing / title | Toast + Standing |
| Officer+ | Commit + announce control | Officer tab |
| Stream viewer / VOD | Read name + title in one glance | Chat (primary), toast (if cam on officer/promotee) |
| Streamer host | Cam + OBS alerts free; no privacy surprise | Movable toasts; no Streamer Mode that kills `/g` |

### 3.2 Event choreography (guild night)

```text
Play / Gora / ceremony
  → local credit toast (short, no /g)
  → threshold → suggestion (officer queue; low stream drama)
  → Officer Commit
       → ONE /g line  ← jumbotron / Hype Train “kickoff”
       → promote toast (6–8 s, edge, opaque)
       → Ladder highlight for “you”
  → chat reaction = success (§13.11)
  → return fovea to game
```

Scarce seats (Council / Prophet) and demotion/excommunication may use the same Medium public stack with longer toast dwell — still **one line**, not a dashboard takeover ([14](14-celebration-spectacle-design.md)).

### 3.3 Privacy & coexistence (locked direction)

- No dedicated Streamer Mode in V1 code; document third-party StreamerMode does not mask `/beef` ([spec §10 / §15](../../superpowers/specs/2026-07-25-church-of-beef-design.md)).  
- V1.1 may add SV preset (mask flock names and/or quieter toasts) — **must never silently disable** officer guild announce.  
- Silent SFX in V1; later opt-in only.  
- Brand lives in **words** first; gothic Media waits on stream-contrast pass.

---

## 4. Stream-readable UI rules (implementer checklist)

Copy these into review / QA. Numbers come from track 17 + stream layout practice; product locks stay in the spec.

### A. Placement & coexistence

1. **Chat is the jumbotron** — public promote/demote = one officer `/g` line; no N-way echo.  
2. **Edge, not center** — no WA-style center pulses for social beats.  
3. **Title-safe (~80%)** for must-read toast text; stay inside action-safe (~90%) ([17 capture-safe-zones](../wow-classic-addon-design/17-stream-overlay-readability/capture-safe-zones.md)).  
4. **Inset ≥ ~100–120 px @ 1080p** (≈70–90 px @ 720p) from absolute edges.  
5. **Do not default toast to BR** (webcam/alerts) or BL (chat overlay); prefer upper-middle inside title-safe; keep **movable + clamped + saved**.  
6. **Leave 70–80% game clear** — `/beef` is a tool window, not a permanent stream frame.  
7. **Coexist with OBS** — Beef never ships as Alert Box / full-bleed browser chrome.

### B. Contrast & type

8. **Opaque / near-opaque dark panel** under toast text (measure contrast vs panel fill, not the world) ([17 contrast](../wow-classic-addon-design/17-stream-overlay-readability/contrast-on-game-footage.md)).  
9. Body ≥ **4.5:1**, large titles ≥ **3:1** (WCAG-as-floor for capture).  
10. Toast type ramp @ 1080p: title **~28–36 px** bold; name **~20–24**; drop secondary if it would go &lt;~16 ([17 typography](../wow-classic-addon-design/17-stream-overlay-readability/typography-scale.md)).  
11. **V1 fonts = GameFont\*** — thick, encode-safe; no thin blackletter on stream surfaces.  
12. **Dual-encode** state (pending / approve / reject): color + word + icon.  
13. Class color on **names only**; no item-quality rainbow for ranks ([18](18-color-hierarchy-readability.md)).  
14. Guild announce: **plain text**, one glance, no color-escape spam.

### C. Timing & cadence

15. **One toast at a time**; promote may interrupt credit; credit must not interrupt promote.  
16. Dwell: credit **3.5–5 s** · suggest **5–7 s** · promote/demote **6–8 s** ([17 duration](../wow-classic-addon-design/17-stream-overlay-readability/duration-and-attention.md)).  
17. Enter motion ≤ **300 ms**; no looping glow during hold.  
18. **No drip → `/g`** — standing/Gora/ceremony credits stay local.  
19. Throttle public airtime; cooldown mindset like Hype Train (scarcity preserves hype).

### D. Copy & hype craft

20. Announce shape: **who + verb + title** — e.g. `The Church recognizes Beefina, elevated to Beef Knight.`  
21. Toast hero glyph = **rank title**; second line = player name.  
22. Procedural officer chrome for announce checkbox (“Announce promotions to guild chat”); meme tone belongs in the rite line, not the control.  
23. Success metric = **guild-chat social reaction**, not toast FPS (§13.11).

### E. Safety & product red lines

24. Announce / track / sync only — **no bots**, injection, or protected-action bypass.  
25. UI never awards points; Net never invents ranks.  
26. No tip jars / donate CTAs in-game.  
27. Privacy presets must not kill guild announce.  
28. Photosensitivity: no full-screen strobes as default ceremony.

### F. Acceptance (stream path)

29. Capture at **720p**, busy dungeon frame, phone-width player: `/g` line obvious **and** toast title readable without scrubbing.  
30. If toast fails and chat passes → V1 social OK; fix toast before polish complete.

---

## 5. Surface-by-surface application

| Surface | Stream-friendly default | Avoid |
|---------|-------------------------|--------|
| Guild announce | One CTL-shaped sentence; officer-only; default ON | Multi-line lore, point dumps, bot replies |
| Promote toast | Opaque edge plate; 6–8 s; title + name | Center pulse; glass; BR glued |
| Credit toast | Short local; coalesce | Chat mirror; stack with promote |
| Ladder tab | Readable titles; “you” highlight | Details!-dense meters; WA glow |
| My Standing | Text thresholds | Hero StatusBar / HP metaphor |
| Officer tab | Commit + announce checkbox | Streamer Mode that mutes `/g` |
| Minimap | Quiet LibDBIcon | Animated badge spam |

---

## 6. V1 vs later

| Now (V1) | Later (V1.1 / V2) |
|----------|-------------------|
| Chat + edge toasts; Classic shell | Streamer SV preset (mask names / quieter toasts) without killing announce |
| Silent; no Media required | Optional SFX default off; gothic seals after stream-contrast pass |
| No Streamer Mode code | Ceremonial dashboard / clip-safe layouts (§14) |

---

## 6.1 Juice / game-feel → streamer-readable feedback

Stream capture is a **lossy channel**: compression, 720p player, distracted glance, OBS widgets. Apply juice literature through that lens ([11b](11b-juice-sources-digest.md)):

| Juice / feel idea | Streamer-readable translation | Classic constraint |
|-------------------|------------------------------|--------------------|
| Cascading redundant feedback | `/g` (durable) + edge toast (local flourish) | Not N-way chat echo |
| Amplification ∝ importance | Longer dwell + denser liturgy for scarce seats | Still **one** chat line |
| Staging / attention | Opaque toast, title-safe; chat owns jumbotron | No center WA pulse |
| Permanence | Chat line survives VOD scrub | Toast is ephemeral |
| Hit-stop / particles / shake | **Do not** use for stream hype | Photosensitivity + combat HUD |
| Sound juice | Viewers may have stream muted / Discord ducking | Silent V1 is stream-safe |
| Medium > extreme juiciness | Avoid alert-stack wars with Streamlabs/OWN3D | Coexist, don’t compete |
| Jumbotron / Hype Train | Name → hold → return to game | Throttle; no drip `/g` |
| Frogger coherence | Same name + title in chat and toast | `Ranks.lua` only |

**Acceptance shortcut:** if a busy dungeon + phone Twitch player can read the `/g` who/verb/title, the social juice passed — even if toast motion was cut ([§13.11](../../superpowers/specs/2026-07-25-church-of-beef-design.md)). Motion: enter ≤300 ms, no looping glow ([16](16-timing-curves-recipes.md)); promote dwell 6–8 s for distracted glance.

---

## 7. Guild culture (why chat is the rite)

WoW social guilds have long used **named ranks + public recognition** as culture technology — not DPS meters ([Acheron archive — Creating Useful Guild Ranks](https://www.acheron-guild.com/guild-relations-archive/guild-creation-activities-and-leadership-guides/creating-useful-guild-ranks-a-faq/); [Eight Years in Azeroth — Meritocracy / Avatar rank](https://eightyearsinazeroth.blogspot.com/2013/06/3-11.html)). Classic recruitment and “quality guild” talk still centers Discord + chat presence ([Blizzard forums — finding quality guilds](https://us.forums.blizzard.com/en/wow/t/how-are-you-guys-finding-quality-guilds/2036827)).

| Cultural pattern | CoB mapping |
|------------------|-------------|
| Rank names as identity | Canon titles from `Data/Ranks.lua` in toast + `/g` |
| Officer announcement privilege | Officer+ Commit owns the `/g` line |
| Trial → member recognition | Threshold → suggestion → Commit (hybrid; never auto-promote) |
| Spam / bot congrats fatigue | Ban GuildCongrats-style pile-ons ([14](14-celebration-spectacle-design.md)); one throttled line |
| Discord as logistics hub | Outside addon scope; in-game rite still must work for non-Discord lurkers |

**Anti-pattern cousin:** recruitment addons that auto-spam LFG and auto-congrats promotions ([GuildRecruitmentInLFG — CurseForge](https://www.curseforge.com/wow/addons/guildrecruitmentinlfg)) — useful as a *negative* reference for CoB’s announce/track/sync-only safety model.

### 7.1 Stream night failure modes (expand QA)

| Failure | Symptom | Fix lane |
|---------|---------|----------|
| Toast under facecam | Viewers never see title | Move default anchor; keep movable + saved |
| Glass toast on bright outdoor | Unreadable at 720p | Opaque panel; measure vs fill ([WCAG 1.4.3](https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum.html)) |
| Multi-line liturgy in `/g` | Scrolls past before callout | One sentence; who + verb + title |
| Credit drip mirrors to chat | Attention fatigue | Credits stay local |
| Privacy preset kills announce | Rite vanishes for non-addon flock | Spec lock: never silently disable `/g` |
| Full-screen WA celebrate | Competes with combat + OBS | Edge only; leave Alert Box to creator |

Alert design practice: short dwell, username/name as primary anchor, match energy to event tier ([NeonStreamLab — Engaging Twitch Alert Designs](https://neonstreamlab.com/blog/engaging-twitch-alert-designs-10-examples-that-work); [kapa99 — Overlay size & design](https://kapa99.com/blog/twitch-overlay-design/); [GETREKT — overlays what to avoid](https://getrektlabs.com/blogs/news/choose-your-stream-overlays-where-to-start-what-to-avoid); [twitch.club — Overlay guide](https://twitch.club/twitch-stream-overlay-guide)).

---

## 8. Sources (in-repo)

- [17 — stream overlay readability](../wow-classic-addon-design/17-stream-overlay-readability/)  
- [14 — celebration spectacle](14-celebration-spectacle-design.md)  
- [11b — juice sources digest](11b-juice-sources-digest.md)  
- [12 — social progression](12-social-progression-loops.md)  
- [07 — chat spectacle](07-chat-spectacle-ux.md)  
- [Design spec](../../superpowers/specs/2026-07-25-church-of-beef-design.md)  
- [UI polished direction](../../superpowers/ui-polished-direction-for-agents.md)

Search dumps: `_search-streamer-guild-event-ux.json`, `_search-streamer-guild-event-ux-2.json` (this folder).  
Firecrawl/parallel cache: `.firecrawl/juice-research/search-streamer-readability.json`, `obs-chat-overlay.md` (gitignored).

---

## External sources

Research orientation only — **not** product law. Spec §§1, 10, 13.11, 14–15 win on conflict. Juice/feel canon annotated in [11b](11b-juice-sources-digest.md).

1. [Twitch — Hype Train Guide](https://help.twitch.tv/s/article/hype-train-guide) — kickoff, levels, cooldown, Conductor scarcity.  
2. [Twitch — Celebrate your community with alerts](https://blog.twitch.tv/en/2023/07/25/celebrate-your-community-your-way-with-twitch-s-alerts/) — platform celebration tooling.  
3. [Twitch Help — Alerts customization / Celebrations](https://help.twitch.tv/s/article/alerts-by-twitch-customization) — native celebration intensity (leave to platform).  
4. [OBS — Stream Layout Tutorial 1 (game + webcam)](https://obsproject.com/kb/stream-tutorial-1-game) — game-first layout.  
5. [Streamoz — Layout tweaks that keep viewers watching](https://streamoz.com/twitch-streaming-layout-tweaks-that-keep-viewers-watching) — visual hierarchy + alert fatigue.  
6. [OWN3D — Alert Widgets](https://hi.own3d.pro/en/features/alert-widgets) — full-screen hype (negative pattern for in-addon chrome).  
7. [Streamlabs — Alert Box](https://streamlabs.com/stream-widgets/alert-box) — creator-owned alert stack.  
8. [InfluencerDB — Gratis Twitch overlays checklist](https://influencerdb.net/social-media-platform-playbooks/gratis-twitch-overlays) — mobile readability + safe zones.  
9. [5856.tw — Stream Overlay Configurator tips](https://5856.tw/stream-overlay-configurator) — layout ownership heuristics.  
10. [NeonStreamLab — Engaging Twitch Alert Designs](https://neonstreamlab.com/blog/engaging-twitch-alert-designs-10-examples-that-work) — 3–8 s dwell; name-first hierarchy.  
11. [kapa99 — Twitch Overlay Size & Design Guide](https://kapa99.com/blog/twitch-overlay-design/) — alert ≤~15% screen; queue chaos.  
12. [GETREKT — Stream overlays: where to start & what to avoid](https://getrektlabs.com/blogs/news/choose-your-stream-overlays-where-to-start-what-to-avoid) — clutter / distracting animation bans.  
13. [twitch.club — Stream Overlay Guide and Best Practices](https://twitch.club/twitch-stream-overlay-guide) — scene focus + alert non-blocking.  
14. [Acheron — Creating Useful Guild Ranks FAQ](https://www.acheron-guild.com/guild-relations-archive/guild-creation-activities-and-leadership-guides/creating-useful-guild-ranks-a-faq/) — rank/privilege culture.  
15. [Eight Years in Azeroth — Meritocracy](https://eightyearsinazeroth.blogspot.com/2013/06/3-11.html) — peer recognition ranks.  
16. [Blizzard forums — How are you guys finding quality guilds?](https://us.forums.blizzard.com/en/wow/t/how-are-you-guys-finding-quality-guilds/2036827) — Classic social discovery reality.  
17. [W3C — WCAG 1.4.3 Contrast (Minimum)](https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum.html) — toast/chat capture floor.  
18. [Jumbotron — Wikipedia](https://en.wikipedia.org/wiki/Jumbotron) — stadium naming metaphor for `/g`.  

---

## 9. Open questions (not V1 blockers)

- Default toast anchor A/B on real Dreamscythe / Doomhowl stream layouts  
- Whether V1.1 “quieter toasts” is mask-names, longer coalesce, or both  
- Clip/Shorts safe band only when V2 ceremony theater ships  
