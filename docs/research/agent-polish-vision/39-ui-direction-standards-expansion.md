# 39 — UI direction standards expansion (juice · motion · sound · celebration · critique)

**Audience:** Coding agents polishing Church of Beef UI after the locked V1 shell.  
**Status:** Research proposal — **not** product law. Do not treat this file as authority over the design spec or the agent briefing.  
**Authority (unchanged):**

1. [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../superpowers/specs/2026-07-25-church-of-beef-design.md) §10 / §15  
2. Glossary rows 68–71, **74–81** — [`74-v1-decision-glossary/locked-v1-decisions.md`](../wow-classic-addon-design/74-v1-decision-glossary/locked-v1-decisions.md)  
3. Agent briefing — [`docs/superpowers/ui-polished-direction-for-agents.md`](../../superpowers/ui-polished-direction-for-agents.md)  
4. Machine canon — `Data/Ranks.lua` (never invent thresholds in copy/art)

**Depth when disputed:** tracks `02-visual-language`, `20-sound-sfx-feedback`, `32-microcopy-tone-voice`, sibling polish notes `02-lua-vs-xml-frames.md`, `03-taint-lockdown-ux.md`. Scrapes / `_search-*.json` are not product truth.

**Last drafted:** 2026-07-26

---

## 1. Why expand

The current briefing locks **chrome doctrine** and **anti-patterns** well:

- Classic Blizzard shell for process UI  
- Brand in words (guild chat + private toasts)  
- Silent V1; no custom `Media/`; no WA center pulses  

It does **not** yet give agents a shared vocabulary for:

| Gap | Risk if left implicit |
|-----|------------------------|
| **Juice** (what feedback is allowed where) | Agents invent WA-shaped chrome or skip feedback entirely |
| **Motion** (timing, concurrency, teardown) | Permanent `OnUpdate`, row animators, combat thrash |
| **Sound** (when silence lifts) | Ripped kits, raid-warning collisions, unmute-by-default |
| **Celebration tiers** (which events earn spectacle) | Every drip toast looks like a Prophet bestowal — or promote is quiet |
| **Agent critique obligations** | Self-merge loops; “looks fine” without checklist; silent policy forks |

This note proposes those standards so a later §15 / briefing merge can be mechanical, not rediscovered per PR.

---

## 2. Delta from current briefing

Relative to [`ui-polished-direction-for-agents.md`](../../superpowers/ui-polished-direction-for-agents.md) (locked 2026-07-25):

| Topic | Current briefing | This proposal adds |
|-------|------------------|--------------------|
| Doctrine | One-line: Classic shell; brand in words; heraldry later | Unchanged; restates as **juice hierarchy** (chat > toast > chrome motion > SFX > art) |
| V1 non-negotiables | Bullet list (templates, tabs, silent, text thresholds, …) | Same locks; adds **celebration tier table** mapping events → channels |
| Motion | Implicit via “no WA pulses”; canvas pointer | Explicit **motion budget**, durations, concurrency, teardown, combat rules |
| Juice | Anti-patterns only | Positive **allowed juice catalog** + construction prefs (`C_Timer` / `AnimationGroup`) |
| Sound | “Silent (no SFX)” | Phase ladder: V1 silent → later default-off one-shots; channel/`PlaySound` bans; mute UX |
| Celebration | Guild `/g` + edge toast as spectacle | **T0–T4 tiers** (silent → rite) with scarcity rules for Council/Prophet |
| Critique | Anti-patterns + “when stuck” | **Mandatory critique checklist**, stop conditions, what must be logged to §15 |
| Phased art | V1 → V1.1 → art/spectacle pass | Same; ties SFX/heraldry to tier unlocks |
| Authority | Spec > glossary > this brief | Explicit: this research file **cannot** unlock Media/SFX/center spectacle without §15 |

**Non-deltas (do not reopen without product decision):** Officer announce checkbox default ON; settings starvation; text-only Standing; no Streamer Mode in V1; no Alliance/Horde skins; UI never awards points.

---

## 3. Juice doctrine

### 3.1 Definition

**Juice** = sensory acknowledgment that something happened, without becoming the product. For Beef, juice must never:

- Award standing or invent ranks  
- Soft-lock combat UI or require a secure button  
- Replace guild-chat spectacle for members without the addon  
- Persist as ambient HUD motion

### 3.2 Hierarchy (spend from the top)

1. **Guild chat** — throttled promote/demote line (officer client; `ui.announce`)  
2. **Private edge toast** — addon users only; queue-capped  
3. **In-panel feedback** — highlight, dual-encoded state, Instant Show/Hide  
4. **Short motion** — fade/slide on toast or one-shot panel cue  
5. **SFX** — post-V1, default off  
6. **Custom art / seals** — post-V1 art pass only  

If a feature skips (1) for a promotion night moment, it has failed the social check (spec §13.11) even if (2)–(4) look polished.

### 3.3 Allowed juice catalog (V1)

| Surface | Allowed | Forbidden |
|---------|---------|-----------|
| Promotion / demotion | `/g` line + edge toast; ladder row rebind | Center pulse, screen flash, camera shake |
| Suggestion created | Edge toast (short) | Guild spam; sound |
| Gora / ceremony credit | Edge toast | Standing “XP bar” fill anim |
| Officer Approve/Reject | Instant queue rebind + dual-encode | Modal for Approve/Reject (modals reserved for nuclear rites) |
| Tab switch | Instant panel Show/Hide | Cross-fade of whole shell |
| Empty / error states | Clear GameFont copy | Meme overload on Officer process labels |
| Idle ladder open | Static readable roster | Breathing glow, idle particle loops |

Construction prefs: see sibling [`02-lua-vs-xml-frames.md`](02-lua-vs-xml-frames.md) § juice — prefer `C_Timer` / `CreateAnimationGroup`; never permanent business `OnUpdate`.

---

## 4. Motion standards

### 4.1 Budget (hard)

| Rule | Standard |
|------|----------|
| Prefer | `AnimationGroup` (Alpha/Translation) or `C_Timer` stepped alpha |
| Avoid | Permanent `OnUpdate` for polish; nil scripts and hide helpers when done |
| Concurrency | Cap toast anims to existing queue max (≤5); no per-row lifelong groups |
| Panel closed | No animators running on hidden ladder/officer rows |
| Combat | Insecure Beef frames may Show; do not layout-thrash or touch protected trees (see [`03-taint-lockdown-ux.md`](03-taint-lockdown-ux.md)) |
| XML | Do not add FrameXML solely for `<Animations>` |

### 4.2 Timing envelopes (proposed defaults)

Tune in-client; numbers are agent starting points, not canon:

| Motion | Enter | Hold | Exit | Notes |
|--------|-------|------|------|-------|
| Edge toast (T1–T2) | ~0.15–0.25s fade/slide | ~3–5s | ~0.2–0.35s | Readable on stream; not sticky |
| Edge toast (T3 rite) | ~0.2–0.3s | ~5–7s | ~0.3–0.4s | Still edge; still not center |
| Tab / list rebind | 0 | — | 0 | Instant |
| Nuclear confirm | Blizzard StaticPopup | Until action | — | No custom flourish |

**Easing:** prefer simple ease-out on enter, ease-in on exit. No elastic overshoot on process UI (reads as toy/WA). Overshoot reserved for hypothetical post-V1 seal pop if art pass asks — never for Officer queue.

### 4.3 Motion anti-patterns (reject in review)

- Center-screen or character-anchored pulses  
- Continuous idle motion on open panels  
- Staggered “cascade” of all seven rank bands on every refresh  
- Animating opacity of primary ladder text below readability  
- Using Retail-only animation APIs without Anniversary verify  

---

## 5. Sound standards

Aligned with spec §10/§15 (“V1 silent… later default off; no ripped Blizzard audio”) and track [`20-sound-sfx-feedback/04-beef-v1-v2.md`](../wow-classic-addon-design/20-sound-sfx-feedback/04-beef-v1-v2.md).

| Phase | Policy |
|-------|--------|
| **V1** | **No SFX.** Visual + guild text only. Success criterion §13.11 does not require audio. |
| **Spectacle / art pass** | Optional short cleared/licensed `.ogg` or quiet stock UI kits; **default off**; channel `SFX` only |
| **Never** | Redistributed ripped soundtrack; `RAID_WARNING` / Ready Check / level-up ding as Beef cues; Master-forced playback; mute other addons; TTS sermons |

**Mute model (when SFX exists):** one global “Enable Church sounds” (default false). Announce opt-out remains a separate concern — quiet chat ≠ mute SFX and vice versa.

**Silent by frequency:** login sync, revision ignore, co-play drip, suggestion create (even in later phases prefer silent or softest tier).

---

## 6. Celebration tiers

Map every feedback event to a tier. Agents may not promote an event to a higher tier without a §15 log entry.

| Tier | Name | Channels (V1) | Example events | Scarcity |
|------|------|---------------|----------------|----------|
| **T0** | Silent process | None (or instant in-panel rebind only) | Co-play tick applied; sync apply; roster refresh | Unlimited |
| **T1** | Soft private | Edge toast, short hold | Suggestion created; Gora/ceremony credit | Common; queue-capped |
| **T2** | Public rite (standard) | Throttled `/g` + edge toast | Promote/demote ranks 1–5 (Cooked → Butcher band) | Per Commit; officer announce gate |
| **T3** | Public rite (scarce) | Same as T2; toast may hold longer; copy weight higher | Beef Council appointment; Beef Prophet bestowal; public excommunication | Seat/unique constrained — do not dilute with chrome |
| **T4** | Theater (locked out of V1) | Future: ceremonial dashboard, seals, optional SFX | V2+ confession/ceremony spotlight | Requires phase unlock + Media policy |

**Tier rules:**

1. **T2/T3 without `/g` when announce is ON is a bug**, not a taste choice.  
2. **T3 must not invent new UI chrome in V1** — escalate copy and hold time, not center spectacle.  
3. **Demotion is first-class** (spec §4.3 / §15): treat as T2/T3 depending on public vs quiet officer intent; same Commit path; never a red error flash that looks like a failed action.  
4. **Streamer quiet (V1.1+)** may soften toasts; must not silently disable T2/T3 guild announce.

### 6.1 Copy posture by tier

| Tier | Tone |
|------|------|
| T0 | None / system-neutral |
| T1 | Procedural or lightly liturgical; short (see track 32 toast length) |
| T2 | Liturgical one-liner in `/g`; toast mirrors fact (name + title from `Ranks.lua`) |
| T3 | Same channels; weight in wording, not particles |
| Officer chrome | Procedural labels (“Announce promotions to guild chat”) — meme stays in player-facing spectacle, not officer process IA |

---

## 7. Agent critique obligations

Polish without critique recreates the Writer→Critic echo chamber. Borrow stop-discipline from adversarial / reflective-loop practice: **few high-confidence findings**, explicit halt, no infinite “one more pass.”

### 7.1 When critique is mandatory

Run the checklist below before claiming done when the change touches any of:

- `UI/**` CreateFrame / templates / toasts / minimap  
- Guild announce / `ui.announce`  
- Standing / ladder presentation  
- Officer confirms / StaticPopup  
- Any motion, sound, or Media path  
- Copy that names ranks or thresholds  

Desktop `lua tests/run.lua` remains required for Core/Data; it **does not** satisfy UI/spectacle critique.

### 7.2 Critique checklist (pass/fail)

Agents reviewing their own or another agent’s UI PR must answer **yes/no** (fail = block merge claim):

| # | Question |
|---|----------|
| C1 | Does authority order still hold (spec §15 > glossary > briefing > this research)? |
| C2 | Is celebration tier correct for each new/changed event (no silent promote; no T4 chrome in V1)? |
| C3 | Spectacle for promote still = throttled `/g` + edge toast when announce ON? |
| C4 | Motion within budget (no permanent OnUpdate; queue capped; teardown on hide)? |
| C5 | V1 still silent; no ripped audio; no raid-warning kits? |
| C6 | No WA center pulse, standing-as-castbar, item-quality rank rainbow, glass panels? |
| C7 | UI still does not award points; Net still does not invent ranks; Core still has no CreateFrame? |
| C8 | Settings budget intact unless playtest-driven toast mute? |
| C9 | Guest on `uiScale`; missing media cannot fail load? |
| C10 | Any new product choice logged to spec §15 (not only PR description / research)? |

### 7.3 Critique roles (lightweight)

| Role | Job | Stop when |
|------|-----|-----------|
| **Builder** | Implements against briefing + tier table | Smoke path works (`/beef`, announce, toast) |
| **Critic** | Runs C1–C10; cites file/line or behavior | ≤5 findings, prefer blockers over nits; or clean pass |
| **Meta (optional)** | Drops low-confidence nits; checks Critic didn’t invent policy | One pass only |

Do **not** run unbounded Writer↔Critic loops. Halt when: checklist clean, or only nits remain, or disagreement requires human/§15 decision.

### 7.4 What critics must not do

- “Improve brand” by painting research scarlet hex before screenshot lock (glossary 78/81)  
- Add Streamer Mode, tip jars, SecureActionButton panel openers  
- Fork thresholds into toast copy  
- Clear player `ChurchOfBeefDB` or claim V1 complete from desktop tests alone  

### 7.5 In-client gate (still required)

For UI / Net / SV / slash touches: install → `/console scriptErrors 1` → `/reload` → exercise path. Prefer BugGrabber + BugSack. Visual truth on Anniversary beats canvas speculation.

---

## 8. Proposed briefing merge (later, product-owned)

If accepted, fold into `ui-polished-direction-for-agents.md` (and optionally §15 one-liners):

1. **Juice hierarchy** subsection (chat > toast > panel > motion > SFX > art)  
2. **Celebration tiers T0–T4** table with V1 lock on T4  
3. **Motion budget** five bullets (from §4.1)  
4. **Critique obligations** pointer: “Before done: run C1–C10 in research note 39 (or inlined checklist)”  
5. Keep SFX one-liner; add “see tiers + track 20 for when silence lifts”

Do **not** merge Media commission language into V1 Task 7–10 scope.

---

## 9. Open questions (do not block V1 shell)

1. Exact toast hold times — lock after one streamed guild night.  
2. Whether T3 demotion (“excommunication”) uses distinct announce template vs promote.  
3. V1.1 quieter-toasts preset: which tiers soften (likely T1 only).  
4. Whether post-V1 SFX attaches only to T2/T3 or also T1.

---

## 10. Industry standards this proposal borrows

These citations justify *vocabulary and budgets* for a later briefing merge. They do **not** unlock Media/SFX/center spectacle without spec §15.

### 10.1 Motion & juice

| Standard | Borrow for CoB | Source |
|----------|----------------|--------|
| Duration tokens (short UI motion) | Toast enter ≤300ms; no elastic on Officer process | [Material M3 — Easing & duration](https://m3.material.io/styles/motion/easing-and-duration) · [M1 Duration & easing](https://m1.material.io/motion/duration-easing.html) |
| Anticipation / follow-through | Selection highlight before Commit; ladder settle after | [IxDF — 12 principles for UX/UI](https://www.interaction-design.org/literature/article/the-12-principles-of-animation-for-ux-and-ui-design) · [Dribbble — Disney principles in UI](https://dribbble.com/stories/2020/07/27/disney-principles-of-animation-ui-interactions) |
| Adequacy / success-dependent juice | Amplify Commit success, not every co-play tick | [Juice It or Lose It](https://www.youtube.com/watch?v=Fy0aCDmgnxg) · [Don’t Juice It…](https://www.gdcvault.com/play/1020861/don-t-juice-it-or) · [CHI 2024 juicy motivation](https://dl.acm.org/doi/10.1145/3613904.3642656) |
| Game-feel domains | Tune everyday chrome; amplify recognition; streamline officer queue | [Pichlmair & Johansen survey](https://arxiv.org/abs/2011.09201) · [Swink — Game Feel](http://www.game-feel.com/) |

### 10.2 Toast / contrast / capture

| Standard | Borrow for CoB | Source |
|----------|----------------|--------|
| Contrast floor | Body ≥4.5:1 vs opaque toast fill | [WCAG 1.4.3](https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum.html) · [WebAIM checker](https://webaim.org/resources/contrastchecker/) |
| Snackbar dwell | ~3–6s common; promote uses upper band for stream distraction | [StudyAround toast guide](https://studyaround.blog/toast-notification-design-guide) · [Angular Material snack-bar](https://github.com/angular/components/blob/main/src/material/snack-bar/snack-bar.md) · [Access-Ability toast a11y](https://buttondown.com/access-ability/archive/designing-toast-messages-for-accessibility-5277/) |
| Stream alert tiers | Scarce heavy treatments; queue one at a time | [Twitch alerts blog](https://blog.twitch.tv/en/2023/07/25/celebrate-your-community-your-way-with-twitch-s-alerts/) · [NeonStreamLab alert designs](https://neonstreamlab.com/blog/engaging-twitch-alert-designs-10-examples-that-work) |

### 10.3 Critique / stop discipline

Adversarial / reflective loops work when findings are **few, high-confidence, and halt-conditioned** — not infinite Writer↔Critic polish ([sibling `22-llm-critique-loops.md`](22-llm-critique-loops.md); industry parallel: evaluation stop rules in agent tooling docs). CoB’s C1–C10 checklist is the halt surface for UI juice PRs.

Photosensitivity / seizure-safe defaults: no full-screen strobes as ceremony ([W3C — Seizure / flashing guidance overview via WCAG 2.3](https://www.w3.org/WAI/WCAG21/Understanding/three-flashes-or-below-threshold.html)).

---

## 11. One-line doctrine (expanded)

*Process UI stays Classic and quiet; celebration scales by tier — guild chat first, edge toast second, motion scarce, sound off until earned; agents do not ship juice they would not defend on the critique checklist.*

---

## External sources

Research proposal only — **not** product law. Spec §10 / §15 + glossary 68–81 + agent briefing win on conflict.

1. [Jonasson & Purho — Juice It or Lose It](https://www.youtube.com/watch?v=Fy0aCDmgnxg)  
2. [GDC Vault — Don’t Juice It or Lose It](https://www.gdcvault.com/play/1020861/don-t-juice-it-or)  
3. [Pichlmair & Johansen — Designing Game Feel (arXiv)](https://arxiv.org/abs/2011.09201)  
4. [Hicks et al. — Juicy Design (DiGRA 2018)](https://doi.org/10.26503/dl.v2018i1.936)  
5. [CHI 2024 — How does Juicy Game Feedback Motivate?](https://dl.acm.org/doi/10.1145/3613904.3642656)  
6. [Steve Swink — Game Feel](http://www.game-feel.com/)  
7. [IxDF — 12 Principles of Animation for UX/UI](https://www.interaction-design.org/literature/article/the-12-principles-of-animation-for-ux-and-ui-design)  
8. [Dribbble — Disney principles applied to UI](https://dribbble.com/stories/2020/07/27/disney-principles-of-animation-ui-interactions)  
9. [Material Design — Easing and duration (M3)](https://m3.material.io/styles/motion/easing-and-duration)  
10. [W3C — WCAG 1.4.3 Contrast (Minimum)](https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum.html)  
11. [WebAIM — Contrast Checker](https://webaim.org/resources/contrastchecker/)  
12. [StudyAround — Toast Notification Design Guide](https://studyaround.blog/toast-notification-design-guide)  
13. [Access-Ability — Designing toast messages for accessibility](https://buttondown.com/access-ability/archive/designing-toast-messages-for-accessibility-5277/)  
14. [Twitch — Celebrate your community with alerts](https://blog.twitch.tv/en/2023/07/25/celebrate-your-community-your-way-with-twitch-s-alerts/)  
15. [W3C — WCAG 2.3.1 Three Flashes or Below Threshold](https://www.w3.org/WAI/WCAG21/Understanding/three-flashes-or-below-threshold.html)  
16. [Wensveen et al. — Interaction Frogger (DIS 2004)](https://doi.org/10.1145/1013115.1013140)  
