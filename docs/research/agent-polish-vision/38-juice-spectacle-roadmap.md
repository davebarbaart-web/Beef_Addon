# 38 — Juice & spectacle roadmap (V1 → post-V1)

**Audience:** Coding agents (and humans) sequencing UI “juice” and social spectacle for Church of Beef.  
**Client (V1):** WoW TBC Classic Anniversary · `## Interface: 20506`.  
**Last updated:** 2026-07-26  
**Authority:** Design spec §10 / §13.11 / §14 / §15 · [`ui-polished-direction-for-agents.md`](../../superpowers/ui-polished-direction-for-agents.md) · glossary rows 68–81 · [`docs/phases/`](../../phases/).

Research scrapes (`.firecrawl/`, `**/.raw/`) are **not** product truth. This note is a phased execution map; product locks stay in the design spec. If this roadmap and the spec diverge, **spec wins** — amend §15, do not fork policy here.

---

## Verdict (one line)

**V1 spectacle is words in guild chat + private edge toasts; juice is short, gated motion on Beef frames. Theatrical chrome, SFX, ceremonial dashboards, and Gora match theater are post-V1 — and never award points, invent ranks, or automate play.**

---

## Non-negotiables (every phase)

| Rule | Meaning for juice / spectacle |
|------|-------------------------------|
| Announce / track / sync only | No bots, injection, protected-action bypass, combat automation, or external process control |
| UI → Core → Data; Net → Core → Data | UI never awards points; Net never invents ranks; Core never `CreateFrame`; Data never reads SV |
| No Retail / DF-only APIs | Anniversary `20506` verified templates and sound APIs only |
| Officer is the anti-cheat | Toasts/announces react to Core/Net outcomes; they never “grant” standing or commit ranks |
| Edge social tool | No center-screen WA pulses; no raid-HUD competition; keep sticky honey on Beef-owned insecure frames |
| Guild play must not soft-lock | Non-addon members still see `/g` lines; BeefNet silence must not break the night |
| Packaging hygiene | Missing media falls back; no ripped Blizzard audio; no tip jars / donation CTAs |

Related agent notes: [02 Lua vs XML](02-lua-vs-xml-frames.md) · [03 Taint / lockdown](03-taint-lockdown-ux.md) · [08 SavedVars / settings](08-savedvars-settings-ux.md).

---

## Doctrine

1. **Spectacle ≠ chrome.** Spec success criterion §13.11 is an unprompted guild reaction to a promotion line. Ornate frames that nobody sees in chat fail the product.
2. **Brand in words first.** Classic Blizzard shell for process UI; church voice in announce copy + toast text; gothic heraldry only after the shell earns it.
3. **Juice is acknowledgement, not authority.** Fade/slide on toast show, brief ladder-row highlight after `RANK_COMMIT` apply — never a second scoring path.
4. **Scarcity of noise.** One throttled officer `/g` line per promote/demote; private toasts for the actor/peers with the addon; queue caps; silence by default for SFX when it arrives.
5. **Combat deferral, not combat theater.** Combat may delay Blizzard-touching confirms; it must not drop commits or (when announce is on) the guild line.
6. **Success-dependent amplification.** Industry juice research finds amplified feedback helps when it marks *attained* outcomes, not every swing ([CHI 2024](https://dl.acm.org/doi/10.1145/3613904.3642656)). CoB fanfare fires only after Core accepts Commit.
7. **Leave the creator’s Alert Box alone.** Stream tools already own full-screen hype ([Streamlabs Alert Box](https://streamlabs.com/stream-widgets/alert-box); [OWN3D](https://hi.own3d.pro/en/features/alert-widgets)). V1 CoB coexists; it does not replace OBS.

---

## Phase table

| Phase | Focus | Juice / spectacle budget | Gate to exit |
|-------|--------|--------------------------|--------------|
| **V1** | Rank ladder + hybrid approve + thin Gora/ceremony stubs | Throttled officer `/g` promote/demote line (default ON) + private edge toasts; short `AnimationGroup`/`C_Timer` fades on Beef toasts only; template-native chrome; **silent** | [`v1-checklist.md`](../../phases/v1-checklist.md) §13 incl. **social check #11**; guild-night playtest spectacle row |
| **V1.1** | Privacy + officer ops polish (no theater unlock) | Streamer SV preset (mask flock names and/or quieter toasts) **without** killing guild announce; optional toast mute if playtest proved noise; optional thin Standing track for ranks 1–5; suggestion pull-on-login flag if officers missed petitions | Spec §15 amendment + two-client smoke; announce still works when privacy preset on |
| **Art / media pass** (may overlap late V1.1 / early V2) | Commissioned seals, toast/minimap art, optional SFX | TGA PoT under `Media/` with fallbacks; flock seal escalation + Council/Prophet shape break; optional one-shot SFX **default off**; shell stays Classic | Commission brief + packaging track 44; missing-media smoke reopened |
| **V2** | Ceremonial dashboard spectacle | Announcements wall, confessions feed, spotlight states, richer scripture; stream contrast pass; still no point awards from UI | Spec §14 V2; playtest proves dashboard is watched, not ignored |
| **V3** | Full Beef Gora presentation | Favor-meter *theatrical* layer, match history theater, wrestling-show packaging — presentation only; outcomes still officer/recorded stubs → Core | Spec §14 V3; Gora losses still pay; no auto-duel bots |
| **V4** | Classic+ port | Portability of IA + spectacle surfaces; isolate TOC/instance/messaging | Spec §12 / §14 V4 |

Phases V2–V4 match design spec §14. V1.1 and the art pass are explicit bridges already locked in §10 / §15 / the agent UI brief — they are **not** a license to pull V2 dashboard work into V1.

---

## V1 — ship bar (in / out)

### In scope (must work as spectacle)

| Moment | Channel | Who sees it | Notes |
|--------|---------|-------------|-------|
| Promote / demote | Guild chat (`GUILD`, not `/o`) | Whole guild, addon or not | Approving officer’s client only; throttled; `ui.announce` checkbox; default ON |
| Suggestion created | Private edge toast | Local member (and officers if fanout delivers) | No auto-promote; toast is testimony feedback |
| Rank approved / applied | Private edge toast + ladder refresh | Addon users | Driven by Core after validated `RANK_COMMIT` / sync merge |
| Gora / ceremony credit | Private edge toast | Local | Thin stubs only — no match theater |
| Ladder occupancy change | Quiet UI refresh (+ optional brief row highlight) | `/beef` open | Highlight is juice, not a second announce |

### Explicitly out of V1

- Center-screen pulses, raid warnings as brand, WeakAuras-density choreography
- Custom `Media/`, brand hex chrome tints, Alliance/Horde panel skins
- SFX / SharedMedia hard deps
- Ceremonial dashboard, confessions feed, spotlight product surface
- Audience favor / stream betting metaphors
- Deep Gora match presentation / favor meter as gameplay
- Per-event announce filters, UI-scale override, strata picker
- Streamer Mode code (coexistence note only)
- StatusBar “standing as HP” hero meters (text thresholds only for Task 8)
- UI awarding points, inventing ranks, or SecureActionButton “open panel” hacks

### V1 juice techniques (allowed)

- Lua `CreateAnimationGroup` / `C_Timer` fades on **precreated insecure** toast frames
- Cap concurrent toast anims (existing queue max ~5)
- Dual-encode pending / approve / reject (color **and** text/icon — not color alone)
- Class color on **names** only; GameFont* defaults
- Procedural announce copy (church voice OK in the string; checkbox label stays procedural)

### V1 verification (spectacle-specific)

Walk [`docs/phases/v1-checklist.md`](../../phases/v1-checklist.md) and [`guild-night-playtest.md`](../../phases/guild-night-playtest.md):

1. Offline harness green when Core/Data touched — **does not** prove spectacle.
2. Officer promote with announce ON → one `/g` line → Spectacle Watcher marks unprompted reaction.
3. Announce OFF → commit + private toast still happen; no guild line.
4. Member without addon still sees the chat line.
5. Combat: `/beef` still toggles; no taint errors; announce not spam-flooded mid-pull.
6. Two clients: approve on Officer+ → member toast/ladder update via BeefNet.

---

## V1.1 — privacy & ops (still not theater)

| Item | Intent | Constraint |
|------|--------|------------|
| Streamer SV preset | Mask flock names and/or quieter toasts | **Must never** silently disable officer guild announce |
| Toast mute | Only if guild-night proved noise | Settings budget stays starved; no per-event filter tree |
| Thin Standing track (1–5) | Post-playtest readability option | Not a meter-dashboard; Council/Prophet stay appointed/bestowed copy |
| `syncPendingSuggestions` | Officer catch-up if petitions were missed | Default **off**; grow-only union; see glossary row 62 |
| Optional duplicate announce checkbox under minimal settings strip | Discoverability | Slash-only remains insufficient; Officer tab checkbox stays canonical |

No custom heraldry required to ship V1.1.

---

## Art / media pass (post-shell)

Trigger only after V1 social check passes and process UI is trusted.

| Deliverable | Rule |
|-------------|------|
| Seals / toast / minimap textures | Power-of-two TGA; TOC lists only existing files; fallbacks if missing |
| Flock escalation + Council/Prophet break | Accept commission shape language when funded (glossary 80) |
| SFX one-shots | Optional, **default off**, cleared/licensed; never rip Blizzard audio |
| Brand hex lock | Only after Anniversary screenshot pass — research hex is not law until then |
| Faction chip | Post-V1 only if streamers ask; shared Scarlet/church brand remains default |

Agents: do **not** add `Media/` during V1 Task 7–10 UI shell work.

---

## V2 — ceremonial dashboard spectacle

Pulls deferred §3.2 / §14 items into a product surface:

- Announcements wall (history of commits / rites — display of Core/Net truth)
- Confessions feed (social RP input → officer/ceremony flows; still no auto-scoring from UI chrome)
- Spotlight states (stream-friendly focus on Prophet / Council / night’s promotee)
- Richer scripture (beyond one-line footer)
- Stream contrast pass (readable under capture; still edge-placed)

**Still forbidden:** UI→points, Net→rank invention, combat HUD, Retail-only APIs, WA center takeover.

---

## V3 — Beef Gora theater

- Favor meter as **theatrical presentation**, not a hidden second ladder
- Match history theater / card-style recap
- Wrestling-show packaging for challenges already recorded through thin → richer flows
- Outcomes continue to feed Core scoring rules (losses still pay)

**Still forbidden:** automated duels, targeting, movement, or any “play the game for them” path.

---

## V4 — Classic+ port

- Preserve IA and spectacle channels; swap isolated game APIs (TOC, instance detection, messaging)
- Re-verify templates, sound, and chat throttle assumptions on the new client
- Do not use the port as an excuse to silently widen V1 juice scope on Anniversary

---

## Moment → layer map (keeps architecture honest)

```text
Player / officer action
    → UI collects intent only (button, stub, checkbox)
    → Core scores / suggests / gates (authority)
    → Net commits / syncs (validated Officer+ only for RANK_COMMIT)
    → UI juice reacts (toast anim, ladder refresh, optional highlight)
    → Officer client may SendChatMessage to GUILD (spectacle for everyone)
```

| Layer | May | Must not |
|-------|-----|----------|
| UI | Show toasts, animate own frames, toggle announce preference, open confirms | Award standing, call scoring grants, forge commits |
| Core | Emit “something happened” facts for UI to render | `CreateFrame`, chat spam, play sounds as side effect of math |
| Net | Deliver validated commits / sync | Invent ranks or trust non-officer commits |
| Data | Rank titles / thresholds / seats | Read SV or decide spectacle copy cadence |

---

## Anti-patterns (reject in review)

| Anti-pattern | Why |
|--------------|-----|
| WA-style center promote pulse | Competes with combat HUD; fails “edge social tool” |
| Chat flood / multi-line liturgy per promote | Throttle + one line is the V1 brand |
| Toast that implies auto-promote | Hybrid model: suggestion ≠ rank |
| SFX default on | Spec §15 / glossary 79 |
| Custom art blocking `/beef` shell | Words-first; art after process |
| Standing StatusBar as castbar/HP | Locked out of V1 Standing |
| Privacy preset that mutes `/g` announce | Streamer convenience must not kill the rite |
| Juice via permanent `OnUpdate` | Use short AnimationGroup / C_Timer; tear down |
| SecureActionButton to open panels | Taint / lockdown footgun |
| Unit tests as proof of spectacle | Social check is in-game only |

---

## Agent sequencing checklist

| Order | Work | Done means |
|------:|------|------------|
| 1 | V1 shell + tabs + announce + toasts (no Media) | `/beef` real frame; checklist items 1–10 pathable |
| 2 | Guild-night social check | Checklist #11 + playtest spectacle row |
| 3 | V1.1 privacy / mute / thin track / suggestion flag as needed | Spec amendment; announce preserved |
| 4 | Art / optional SFX commission | Fallbacks; default-off audio |
| 5 | V2 dashboard spectacle | Spec §14 scope; still UI→Core only |
| 6 | V3 Gora theater | Presentation over recorded outcomes |
| 7 | V4 Classic+ | Port isolations only |

---

## Cross-links

| Doc | Role |
|-----|------|
| [Design spec](../../superpowers/specs/2026-07-25-church-of-beef-design.md) §10, §13.11, §14, §15 | Product law |
| [UI direction for agents](../../superpowers/ui-polished-direction-for-agents.md) | Implementer bans + phase jobs |
| [V1 checklist](../../phases/v1-checklist.md) | Walkable done bar |
| [Guild-night playtest](../../phases/guild-night-playtest.md) | Live spectacle gate |
| Glossary [74](../wow-classic-addon-design/74-v1-decision-glossary/locked-v1-decisions.md) rows 68–81 | Normative UI/spectacle locks |
| Tracks 20 (SFX), 44 (media), 61 (streamer), 72 (guild announce) | Depth when disputed |
| Sibling polish: [11](11-game-juice-fundamentals.md) · [14](14-celebration-spectacle-design.md) · [39](39-ui-direction-standards-expansion.md) · [42](42-v1-vs-v2-juice-scope.md) · [55](55-streamer-guild-event-ux.md) | Juice vocabulary + scope |

---

## Juice literature → phase mapping

Translate industry juice vocabulary into CoB phases without forking product law. Primary references: [Juice It or Lose It](https://www.youtube.com/watch?v=Fy0aCDmgnxg), [Don’t Juice It or Lose It](https://www.gdcvault.com/play/1020861/don-t-juice-it-or), [Pichlmair & Johansen survey](https://arxiv.org/abs/2011.09201), [Hicks et al. DiGRA](https://doi.org/10.26503/dl.v2018i1.936), [CHI 2024 juicy motivation](https://dl.acm.org/doi/10.1145/3613904.3642656), [Swink — Game Feel](http://www.game-feel.com/).

| Literature idea | V1 spend | Park until |
|-----------------|----------|------------|
| Max output / min input | One `/g` line + one edge toast per Commit | Full-screen particles / WA |
| Success-dependent amplification | Fanfare **after** Core accepts only | Toast-before-truth |
| Tiered intensity | Credit short; promote longer; Council/Prophet copy weight | Same chrome for every drip |
| Cooldown / scarcity | Announce throttle; no drip→chat | Per-event filter tree |
| Audio as cheap juice | **Silent** (spec) | Art pass, default off |
| Screen shake / hit-stop | Optional ≤50ms metaphor on Commit only (research cookbook) | Camera shake, combat HUD |
| Multimodal coherence | Toast title built from same rank id as announce | Divergent meme vs canon titles |
| Stream attention hierarchy | Edge toast; leave OBS Alert Box alone | In-addon Alert Box clone |
| Progressive disclosure | Tooltip glance → panel detail | Second standing meter on map |

### Celebration / live-event borrow list

Stadium and stream celebration systems name a person, hold the beat, return to the game ([Jumbotron](https://en.wikipedia.org/wiki/Jumbotron); [Twitch Hype Train](https://help.twitch.tv/s/article/hype-train-guide); [Twitch alerts blog](https://blog.twitch.tv/en/2023/07/25/celebrate-your-community-your-way-with-twitch-s-alerts/); toast timing practice [StudyAround](https://studyaround.blog/toast-notification-design-guide)). CoB’s jumbotron is **guild chat**; private toast is the sidecar for addon users.

Cousin Classic addon lesson: officer-gated loot chat announcements, not HUD theater ([Gargul — Announcing Loot in Chat](https://github.com/papa-smurf/Gargul/wiki/Announcing-Loot-in-Chat)).

### Motion envelopes (roadmap defaults)

Align with Material duration tokens and Disney-derived UI motion when agents tune fades ([Material M3 easing & duration](https://m3.material.io/styles/motion/easing-and-duration); [IxDF — 12 principles for UX/UI](https://www.interaction-design.org/literature/article/the-12-principles-of-animation-for-ux-and-ui-design)):

| Moment | Enter | Hold | Exit |
|--------|-------|------|------|
| Credit toast | 150–250ms | 3.5–5s | 200–350ms |
| Promote toast | 200–300ms | 6–8s | 300–400ms |
| Ladder row highlight | ≤150ms flash | brief | restore |
| Tab switch | 0 | — | 0 |

Numbers are research starting points — lock after guild-night capture, not from this roadmap alone.

---

## External sources

Research orientation only — **not** product law. Spec §10 / §13.11 / §14 / §15 win on conflict.

1. [Jonasson & Purho — Juice It or Lose It (YouTube)](https://www.youtube.com/watch?v=Fy0aCDmgnxg)  
2. [GameJuice — What is game juice?](https://gamejuice.co.uk/articles/what-is-game-juice)  
3. [GDC Vault — Don’t Juice It or Lose It](https://www.gdcvault.com/play/1020861/don-t-juice-it-or) · [Game Developer summary](https://www.gamedeveloper.com/design/video-indies-resist-the-urge-to-juice-it-or-lose-it-)  
4. [Pichlmair & Johansen — Designing Game Feel (arXiv:2011.09201)](https://arxiv.org/abs/2011.09201)  
5. [Hicks et al. — Good Game Feel / Juicy Design (DiGRA 2018)](https://doi.org/10.26503/dl.v2018i1.936)  
6. [CHI 2024 — How does Juicy Game Feedback Motivate?](https://dl.acm.org/doi/10.1145/3613904.3642656) · [PDF](https://people.csail.mit.edu/dkao/pdf/3613904.3642656.pdf)  
7. [Steve Swink — Game Feel](http://www.game-feel.com/) · [Game Developer — Secret Ingredient](https://www.gamedeveloper.com/design/game-feel-the-secret-ingredient)  
8. [IxDF — 12 Principles of Animation for UX/UI](https://www.interaction-design.org/literature/article/the-12-principles-of-animation-for-ux-and-ui-design)  
9. [Material Design — Easing and duration (M3)](https://m3.material.io/styles/motion/easing-and-duration)  
10. [StudyAround — Toast Notification Design Guide](https://studyaround.blog/toast-notification-design-guide)  
11. [Twitch — Hype Train Guide](https://help.twitch.tv/s/article/hype-train-guide)  
12. [Twitch — Celebrate your community with alerts](https://blog.twitch.tv/en/2023/07/25/celebrate-your-community-your-way-with-twitch-s-alerts/)  
13. [OBS — Stream Layout Tutorial 1](https://obsproject.com/kb/stream-tutorial-1-game)  
14. [Jumbotron — Wikipedia](https://en.wikipedia.org/wiki/Jumbotron)  
15. [Gargul — Announcing Loot in Chat](https://github.com/papa-smurf/Gargul/wiki/Announcing-Loot-in-Chat)  
16. [Wensveen et al. — Interaction Frogger (DIS 2004)](https://doi.org/10.1145/1013115.1013140) — feedforward / feedback coherence  

---

*Church of Beef juice makes committed truth feel felt. It never becomes a second church that awards points in secret.*
