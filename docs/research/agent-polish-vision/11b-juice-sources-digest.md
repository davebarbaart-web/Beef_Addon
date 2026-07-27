# 11b — Juice sources digest (annotated ≥25)

**Track:** `agent-polish-vision`  
**Date:** 2026-07-26  
**Purpose:** Annotated primary sources for game juice / game feel / 2D UI motion / celebration UX / streamer-readable feedback — mapped to **Church of Beef Classic Anniversary** constraints.  
**Authority:** Research only. Spec §10 / §15 + [UI agent briefing](../../superpowers/ui-polished-direction-for-agents.md) win on conflict.  
**Companions:** [11 — fundamentals](11-game-juice-fundamentals.md) · [14 — celebration](14-celebration-spectacle-design.md) · [16 — timing recipes](16-timing-curves-recipes.md) · [55 — streamer UX](55-streamer-guild-event-ux.md)

---

## Classic WoW constraint filter (apply to every technique)

| Constraint | Rule for Beef |
|------------|---------------|
| **No permanent `OnUpdate`** | Motion only while enter/exit/settle runs; clear script on complete ([04 events](../wow-classic-addon-design/04-toc-api-performance/03-events-onupdate-throttling.md)) |
| **Edge toasts** | Private flourish on screen edge — never center WA pulses |
| **`/g` spectacle** | Throttled officer-owned guild-chat line is the durable jumbotron |
| **Silent V1** | No mandatory SFX; audio is later, default off |
| **No bots / protected bypass** | No auto-congrats, no rank API “celebration” |
| **Photosensitivity** | No full-screen strobe; Epic ≠ brighter flash |
| **Guest on `uiScale`** | Brief local `SetScale` OK; never `UIParent:SetScale` |
| **Layers** | UI presents Core results only — juice never invents ranks |

**Adequacy default:** juice *recognition* (Commit / promote / demote); keep Ladder / Standing / Officer chrome calm ([Folmer Kelly](https://www.gdcvault.com/play/1020861/don-t-juice-it-or); [11 §3.6](11-game-juice-fundamentals.md)).

---

## Technique → source → Classic WoW mapping

| Technique | Primary sources | Classic WoW / Beef mapping | V1 tier |
|-----------|-----------------|----------------------------|---------|
| **Redundant / cascading feedback** (“max output for min input”) | Gabler et al. Prototype-in-7-Days ([GD archive](https://www.gamedeveloper.com/disciplines/how-to-prototype-a-game-in-under-7-days)); [Jonasson & Purho](https://www.youtube.com/watch?v=Fy0aCDmgnxg); [Brad Woods](https://garden.bradwoods.io/notes/design/juice) | Stack **button state + FontString update + edge toast + one `/g`** — not particles | spectacle |
| **Direct confirmatory feedback** | [Hicks et al. DiGRA 2018](https://dl.digra.org/index.php/dl/article/view/936); Swink *Game Feel* | Same-handler ladder/standing refresh before any tween | always |
| **Anticipation / feedforward** | Disney 12 → [IxDF UI animation](https://www.interaction-design.org/literature/article/the-12-principles-of-animation-for-ux-and-ui-design); Interaction Frogger | Commit confirm copy; announce checkbox; disabled+reason | always |
| **Follow-through / overlapping action** | IxDF; [UX Collective Disney→UX](https://uxdesign.cc/disneys-12-principles-of-animation-exemplified-in-ux-design-5cc7e3dc3f75) | Rank update → row flash → toast → async `/g` | spectacle |
| **Squash & stretch (press / impact)** | Disney; [Comeau squash/stretch](https://www.joshwcomeau.com/animation/squash-and-stretch); Juice It demos | Button `SetScale(0.96–0.98)` or pressed template; toast title soft overshoot only | always / spectacle |
| **Slow-in / slow-out (easing)** | [Material M1](https://m1.material.io/motion/duration-easing.html) · [M3](https://m3.material.io/styles/motion/easing-and-duration); [NN/G duration](https://www.nngroup.com/articles/animation-duration) | Enter ease-out 160–300 ms; exit ease-in ~25% faster; see [16](16-timing-curves-recipes.md) | always |
| **Staging / attention direction** | IxDF staging; [NN/G motion purpose](https://www.nngroup.com/articles/animation-purpose-ux/) | Opaque edge toast + dual-encoded rank color; do not steal combat fovea | spectacle |
| **Exaggeration (scoped)** | Juice It; Nijman Screenshake list; [GameAnalytics / GD squeeze juice](https://www.gamedeveloper.com/design/squeezing-more-juice-out-of-your-game-design-) | Amplitude ∝ scarcity (Council/Prophet > mid ladder > credit); never exaggerate process chrome | spectacle |
| **Hit-stop / sleep / hold** | Nijman “Sleep”; GameAnalytics “hold”; stream “sticky peak” 100–150 ms (deep research) | ≤50–150 ms hold on Commit success only — then clear; never global timeScale | spectacle |
| **Screen shake** | [Nijman — Art of Screenshake](https://www.youtube.com/watch?v=AJdEqssNZ-U); Juice It; juicee/FX libs | **Banned** as full UIParent shake; optional 1–2 px toast nudge only if ever, never default | ban / later micro |
| **Particle bursts / trails** | Juice It; Longwelwind demo; GameAnalytics dust/impact | **No TGA particle systems in V1**; metaphor = one-shot color flash / alpha pulse | ban V1 |
| **Impact flash / white flash** | Juice It “flash the screen”; RPG Playground list | Toast/`UIFrameFlash` on **toast panel only**; never full-screen strobe | spectacle (soft) |
| **Sound / bass / one-shots** | Gabler; Juice It; GameAnalytics audio section; Hicks CHI PLAY | **Silent V1**; later `PlaySoundFile` custom, default off; never RAID_WARNING kit | later |
| **Color / palette punch** | Juice It takeaway #1; Whitkin / PopCap emotional lens | Dual-encode rank accent + text; class color on names only | always |
| **Tweening / parametric lerp** | Juice It; Brad Woods FLIP/tween; Material tokens | Short-lived lerp of alpha/offset/scale via cleared `OnUpdate` or `UIFrameFade*` | always |
| **Camera lerp / kick** | Nijman points 13–15, 27 | N/A (no camera). Closest: toast slide ≤12–20 px | n/a → toast slide |
| **Permanence / residue** | Nijman permanence | Guild-chat line + ladder title persist; toast is ephemeral | spectacle |
| **Idle / ambient aliveness** | Juice It eyes/smile; jelly wind sin layers | **Idle stillness** on main frame — motion on state change only | always (anti) |
| **Multimodal / Frogger coupling** | [Wensveen et al. DIS 2004](https://doi.org/10.1145/1013115.1013140); Hicks VE = redundant feedback | Toast title + `/g` + ladder from same `Ranks.lua` id | always |
| **Medium juiciness > extreme** | Pichlmair & Johansen survey (cites Kao); Kelly Don’t Juice | Cap concurrent tweens; one toast; no credit→`/g` | always |
| **Tiered celebration / alert ladder** | Twitch Alerts; OWN3D/Streamlabs; [14](14-celebration-spectacle-design.md) | Small toast / Medium toast+`/g` / Epic taller toast — still one chat line | spectacle |
| **Spectator / stream legibility** | OBS chat overlay practice; [55](55-streamer-guild-event-ux.md); track 17 | Design `/g` for 720p glance; toast title-safe opaque | spectacle |
| **Scarcity = intensity** | Hicks importance; Hype Train cooldown analogy | Progressive amplitude; throttle public airtime | spectacle |
| **Error ≠ reward juice** | Juul & Begy (juicy UI can obscure learning); NN/G purpose | Errors: sharp short, no overshoot | always |
| **Juice reinforces core mechanic** | GameAnalytics; GMTK Secrets; Kelly context | Core rite = Commit recognition — not juicing every standing drip | always |

---

## Annotated sources (≥25)

Annotations: **what it is · key takeaways · Beef use · Classic caveat**.

### A. GDC / practitioner canon

1. **[Jonasson & Purho — Juice It or Lose It (YouTube / GDC Europe 2012)](https://www.youtube.com/watch?v=Fy0aCDmgnxg)** · [GDC Vault](https://www.gdcvault.com/play/1016487/juice-it-or-lose)  
   Canonical live demo: Breakout + layered non-gameplay feedback until it feels alive. Catchphrase: maximum output for minimum input.  
   **Takeaways:** accumulate color, tweening, squash/stretch, sound, particles, screenshake, trails, flash, slow-mo — isolation is weak, stack is strong.  
   **Beef:** use as *technique catalog* for Commit moments; do not mandate “more is more” on Officer chrome.  
   **Classic:** particles / screenshake / slow-mo mostly banned or metaphor-only.

2. **[Folmer Kelly — Don’t Juice It or Lose It (GDC Europe)](https://www.gdcvault.com/play/1020861/don-t-juice-it-or)** · [Game Developer summary](https://www.gamedeveloper.com/design/video-indies-resist-the-urge-to-juice-it-or-lose-it-)  
   Counter-talk: polish without context kills immersion; juice-for-juice distracts from goals.  
   **Beef:** context = social rite + Classic process UI. Dust-on-wrong-material ≈ WA pulse on guild promote.

3. **[Jan Willem Nijman — The Art of Screenshake](https://www.youtube.com/watch?v=AJdEqssNZ-U)** (Vlambeer; often paired with Juice It)  
   ~30 incremental feel tweaks (muzzle flash, hit-stop/sleep, camera lerp, permanence, bass, etc.) — summarized widely (e.g. [RPG Playground](https://rpgplayground.com/research-making-a-juicy-game) citing [r/gamedev](https://www.reddit.com/r/gamedev/comments/1t0jlc/vlambeers_jan_willem_nijman_the_art_of_screenshake/)).  
   **Beef:** steal *sleep*, *permanence* (chat residue), *impact clarity*; leave camera shake / explosions.

4. **[Gabler, Gray, Kucic, Shodhan — How to Prototype a Game in Under 7 Days](https://www.gamedeveloper.com/disciplines/how-to-prototype-a-game-in-under-7-days)** · [Archive audio](https://archive.org/details/GDC2006Gabler) · [GDC Vault](https://www.gdcvault.com/play/1013294/How-to-Prototype-a-Game)  
   Origin of the juicy definition often quoted: bounce, wiggle, squirt, little noise; cascading response; coaches rules per interaction.  
   **Beef:** “coach the rite” via redundant toast + `/g`, not via combat-HUD language.

5. **[Steve Swink — Game Feel: The Secret Ingredient (Game Developer, 2007)](https://www.gamedeveloper.com/design/game-feel-the-secret-ingredient)** · [game-feel.com](http://www.game-feel.com/)  
   Foundational essay/book lineage: tactile sensation of controlling a digital agent; moment-to-moment control.  
   **Beef:** map to click→panel physics predictability; game feel ≠ juice (feel = control; juice = amplification).

6. **[Game Maker’s Toolkit — Secrets of Game Feel and Juice](https://www.youtube.com/watch?v=216_5nu4aVQ)**  
   Concise public synthesis: feel vs juice; emphasize the core verb; screen shake / freeze / audio / camera as tools.  
   **Beef:** “double down on your core verb” → Commit / recognition, not Standing drip.

7. **[GameJuice — What Juice It or Lose It Teaches](https://www.gamejuice.co.uk/articles/juice-it-or-lose-it-lessons)** · [resource page](https://gamejuice.co.uk/resources/juice-it-or-lose-it)  
   Practitioner write-up of ~20 layered tweaks; accumulation insight; “start with sound.”  
   **Beef:** in silent V1, start with *state echo + toast timing* instead of sound.

### B. Academic / research

8. **[Pichlmair & Johansen — Designing Game Feel: A Survey (arXiv:2011.09201)](https://arxiv.org/abs/2011.09201)** · IEEE TG DOI via arXiv page  
   Survey of 200+ sources → three domains: **physicality (tuning)**, **amplification (juicing)**, **support (streamlining)**.  
   **Beef:** tune frames; juice Commit; streamline officer queue under raid-night pressure.

9. **[Hicks, Dickinson, Holopainen, Gerling — Good Game Feel: Empirically Grounded Framework for Juicy Design (DiGRA 2018)](https://dl.digra.org/index.php/dl/article/view/936)** · [PDF](https://dl.digra.org/index.php/dl/article/download/936/936/933) · [Lincoln figshare](https://repository.lincoln.ac.uk/articles/conference_contribution/Good_Game_Feel_An_Empirically_Grounded_Framework_for_Juicy_Design/25174439)  
   Developer survey → actionable juiciness framework (direct feedback, amplification, thematic coherence, clarity, appeal, etc.).  
   **Beef:** review axes in [11 §6](11-game-juice-fundamentals.md); juiciness communicates *importance*.

10. **[Hicks et al. — Juicy Game Design: Visual Embellishments (CHI PLAY 2019)](https://doi.org/10.1145/3311350.3347171)**  
    Juiciness as **redundant** feedback: one action → multiple non-functional reactions; VE support info already conveyed.  
    **Beef:** toast + chat + row flash are VEs over Core truth — they must not *be* the truth channel alone.

11. **[Juul & Begy — Good Feedback for Bad Players? (juicy interface feedback)](https://www.academia.edu/28934462/Good_Feedback_for_bad_Players_A_preliminary_Study_of_juicy_Interface_feedback)**  
    Caution: juicy UI feedback can obscure learning / signal success inappropriately.  
    **Beef:** never celebratory bounce on sync/error; fail states stay sharp.

12. **[Wensveen, Djajadiningrat, Overbeeke — Interaction Frogger (DIS 2004)](https://doi.org/10.1145/1013115.1013140)**  
    Feedforward/feedback coupling across time, location, direction, dynamics, modality, expression.  
    **Beef:** announce / toast / ladder must agree on rank id and valence.

13. **[Hicks — Juicy Game Design thesis (Lincoln)](https://repository.lincoln.ac.uk/articles/thesis/Juicy_Game_Design_Exploring_the_Impact_of_Juiciness_on_the_Player_Experience/24326740)**  
    Defines juiciness as coherent mechanics+visuals with confirmatory, explicit, and ambient feedback.  
    **Beef:** ambient feedback ≈ quiet Classic chrome; confirmatory ≈ Commit stack.

### C. Design blogs / industry press

14. **[Josh Whitkin — Juicy: a useful game design term? (Game Developer / Gamasutra, 2014)](https://www.gamedeveloper.com/design/juicy-a-useful-game-design-term-)**  
    Emotional lens vs cold UX; not Skinner-box scores; PopCap “right now” delight; narrow useful lens, not a whole method.  
    **Beef:** emotional lens for *rite lines*; procedural chrome stays factual.

15. **[Squeezing more juice out of your game design (Game Developer / GameAnalytics)](https://www.gamedeveloper.com/design/squeezing-more-juice-out-of-your-game-design-)** · [GameAnalytics original](https://www.gameanalytics.com/blog/squeezing-more-juice-out-of-your-game-design)  
    Juice reinforces core mechanics; easings/weight; audio bass; particles; hit-hold; genre-specific juice.  
    **Beef:** social-ladder juice ≠ shooter juice; reinforce recognition, not DPS fantasy.

16. **[Brad Woods — Juice (digital garden, matured 2025)](https://garden.bradwoods.io/notes/design/juice)**  
    Interactive juice levels on a delete button; FLIP/tween; redundant techniques; particles/shake as “other.” Quotes Gabler + Juice It.  
    **Beef:** best UI-native demo of stacking hover → press → confirm → transition — model for Commit button, not Breakout.

17. **[RPG Playground — Research: Making a ‘juicy’ game](https://rpgplayground.com/research-making-a-juicy-game)**  
    Collates Juice It takeaways (11 points), Kelly counter, Nijman 30-point list, Whitkin, GMTK.  
    **Beef:** useful index; apply Kelly filter before shipping any row.

18. **[Egmatic — How to Make Your Game Feel Good](https://egmatic.com/blog/how-to-make-your-game-feel-good)**  
    Controls instant + feedback + juice layers; squash/stretch & shake primers.  
    **Beef:** “instant controls” → Officer Commit must never wait on toast enter.

19. **[Has your game got ‘juice’? (Game Developer)](https://www.gamedeveloper.com/business/has-your-game-got-juice-more-)**  
    Juice/feel/polish as discoverability & trailer energy.  
    **Beef:** stream clip energy comes from `/g` reaction, not toast FPS.

20. **[abagames — Making Games ‘Juicy’](https://abagames.github.io/joys-of-small-game-development-en/make_game_juicy.html)**  
    Small-game juicing patterns for 2D.  
    **Beef:** scale down aggressively for addon guest UI.

### D. UI motion / parametric animation (adapt carefully)

21. **[IxDF — UI Animation & Disney’s 12 Principles](https://www.interaction-design.org/literature/article/the-12-principles-of-animation-for-ux-and-ui-design)** · [ixdf.org mirror](https://ixdf.org/literature/article/ui-animation-how-to-apply-disney-s-12-principles-of-animation-to-ui-design)  
    Anticipation, staging, follow-through, slow-in/out for interfaces.  
    **Classic:** prefer Blizzard pressed art; micro scale only; no cartoon elastic chrome.

22. **[UX Collective — Disney’s 12 principles exemplified in UX](https://uxdesign.cc/disneys-12-principles-of-animation-exemplified-in-ux-design-5cc7e3dc3f75)**  
    Modals ease in/out; slow-in/out scrolling.  
    **Beef:** tab crossfade & toast enter/exit — not page-flip slides.

23. **[Material Design — Duration & easing (M1)](https://m1.material.io/motion/duration-easing.html)** · **[M3 Easing and duration](https://m3.material.io/styles/motion/easing-and-duration)**  
    Desktop-fast tokens; enter decelerate / exit accelerate; don’t stretch single elements past ~600 ms.  
    **Beef:** borrow *budgets*, not Material glow language ([16](16-timing-curves-recipes.md)).

24. **[NN/G — Animation duration](https://www.nngroup.com/articles/animation-duration)** · **[Role of animation in UX](https://www.nngroup.com/articles/animation-purpose-ux/)**  
    100–500 ms band; purpose = feedback, state, spatial orientation — not decoration.  
    **Beef:** reject motion without a purpose token.

25. **[Josh Comeau — Squash and Stretch (web)](https://www.joshwcomeau.com/animation/squash-and-stretch)**  
    Parametric squash amount on micro-interactions / SVG; volume conservation metaphor.  
    **Beef:** parametric `scaleX/scaleY` ≈ brief `SetScale` or inset; keep ≤100 ms on press.

26. **[timgraf — Disney 12 as UX foundation (2026)](https://timgraf.com/ux-design/disneys-12-principles-of-animation-the-foundation-of-lifelike-ux-ui-design-in-2026)**  
    Spring vs snap; trust/error when motion is ornate or long.  
    **Beef:** ornate = fail review for process UI.

### E. Community / demos / YouTube-adjacent

27. **[r/gamedesign — Juice it or lose it thread](https://www.reddit.com/r/gamedesign/comments/201o3l/juice_it_or_lose_it_a_talk_by_martin_jonasson/)**  
    Community canonization; “not just screen shake.”  
   **Beef:** same caution in polish reviews.

28. **[Longwelwind — Juice It demonstration (interactive Breakout)](https://longwelwind.net/blog/juice-it/)** · [r/gamedev discussion](https://www.reddit.com/r/gamedev/comments/8com5p/a_demonstration_of_juice_it_or_lose_it/)  
    Toggleable color, ball/block particles, funky background, screenshake — teaches isolation vs stack.  
    **Beef:** agent playtest: enable one effect at a time on toast mock before shipping stacks.

29. **[grapefrukt / juicy-breakout (GitHub)](https://github.com/grapefrukt/juicy-breakout)**  
    Reference implementation tied to Juice It talk.  
    **Beef:** read for effect inventory, not port.

30. **[Game Design Tube — Game Feel & Juice](https://gamedesign.tube/concepts/game-feel)**  
    Short lexicon: feel = tactile control; juice = satisfying polish details.  
    **Beef:** vocabulary alignment for agent critiques.

31. **[YouTube — Game feel vs game juice](https://www.youtube.com/watch?v=_3WKEQD6yyY)**  
    Practitioner distinction video.  
    **Beef:** keep glossary clean in reviews (feel ≠ juice ≠ polish).

### F. Celebration / streamer-readable (jumbotron analogy)

32. **[Twitch — Celebrate your community with Alerts](https://blog.twitch.tv/en/2023/07/25/celebrate-your-community-your-way-with-twitch-s-alerts/)**  
    Platform framing: some moments deserve heavier celebration weight.  
    **Beef:** Medium/Epic tiers; still one `/g` line.

33. **[Twitch — Hype Train guide](https://help.twitch.tv/s/article/hype-train-guide)**  
    Spike → levels → cooldown → named status.  
    **Beef:** throttle + scarce seats; no forced trains.

34. **[OWN3D Alert Widgets](https://hi.own3d.pro/en/features/alert-widgets)** · [Streamlabs Alert Box](https://streamlabs.com/stream-widgets/alert-box)  
    Tiered alert weight; don’t block content.  
    **Beef:** coexist with OBS — do not *be* Alert Box.

35. **[obs-overlay.com — Chat overlay guide](https://obs-overlay.com/guides/chat-overlay)** · [OBS stream layout tutorial](https://obsproject.com/kb/stream-tutorial-1-game)  
    Readable chat fonts; game owns most of canvas; cam/chat in corners.  
    **Beef:** `/g` is stream-durable; toast must not fight BR cam / BL chat ([55](55-streamer-guild-event-ux.md)).

36. **[StudyAround — Toast notification design](https://studyaround.blog/toast-notification-design-guide)**  
    Dwell bands, one-at-a-time, peripheral.  
    **Beef:** align with track 17 dwell (credit 3.5–5 s … promote 6–8 s).

37. **[Jumbotron — Wikipedia](https://en.wikipedia.org/wiki/Jumbotron)**  
    Stadium screen: name someone, hold beat, return to game.  
    **Beef:** guild chat = jumbotron ([14](14-celebration-spectacle-design.md)).

### G. In-repo product anchors (not external research, but binding context)

38. **[Church of Beef design spec](../../superpowers/specs/2026-07-25-church-of-beef-design.md)** §10 / §13.11 / §15 — toast + `/g`, silent V1, social reaction success.  
39. **[UI polished direction for agents](../../superpowers/ui-polished-direction-for-agents.md)** — Classic shell, edge toast, no hero Standing bar.  
40. **[17 — stream overlay readability](../wow-classic-addon-design/17-stream-overlay-readability/)** — spectacle budget, duration, title-safe, contrast.

---

## Procedural / parametric animation notes (2D UI)

| Parametric idea | Source cue | Classic implementation |
|-----------------|------------|------------------------|
| `t ∈ [0,1]` ease curves | Material / NN/G / [16](16-timing-curves-recipes.md) | Lua `ease(t)` in short `OnUpdate`; self-clear |
| Squash amount slider | Comeau; Juice It | Map severity → peak scale 1.0–1.08 (title only) |
| Stagger delay | Plushie / mastery notes via [16](16-timing-curves-recipes.md) | 30–50 ms; cap cascade |
| FLIP-like continuity | Brad Woods | Prefer alpha/offset continuity over hard Show/Hide on reward |
| Sin-layered idle wind | GameAnalytics | **Do not** — idle stillness doctrine |

---

## Provenance (scrapes / searches — not product truth)

Under workspace `.firecrawl/juice-research/` (gitignored):

- Parallel searches: `search-gdc-academic.json`, `search-ui-motion.json`, `search-reddit-youtube.json`, `search-streamer-readability.json`, `search-academic-extra.json`, `search-community-extra.json`, `search-gamedev-polish.json`, `search-foundational-defs.json`
- Scrapes: `bradwoods-juice.md`, `swink-game-feel.md`, `dont-juice.md`, `hicks-digra.md`, `rpg-playground-juice.md`, `gamejuice-lessons.md`, `squeezing-juice.md`, `comeau-squash.md`, `nng-duration.md`, `nng-purpose.md`, `m3-easing.md`, `longwelwind-juice.md`, `obs-chat-overlay.md`, …
- Deep research run (if completed): `juice-deep-research.md` / `.json` — merge deltas into this digest; do not treat as product lock

Index of parallel search hits (titles/URLs only): [`_search-juice-sources-index.json`](_search-juice-sources-index.json).  
Deep research **completed** (`trun_91f36069f096448084bb59c743151b30`): `.firecrawl/juice-research/juice-deep-research.json` + `.md` (gitignored). Merged useful deltas below; **do not treat raw field 7/9 as product law** — they mix Retail APIs and combat hooks incompatible with CoB.

---

## Deep-research merge notes (2026-07-26)

Useful additions after completion of the Parallel ultra-fast run. Filtered against Anniversary `20506` + CoB locks.

### Keep / adopt

| Finding | Source field | Beef use |
|---------|--------------|----------|
| Hicks five-element taxonomy: cohesion, responsiveness, intuitiveness, comprehensibility, satisfaction | `2_academic_theory` | Complements [11 §6](11-game-juice-fundamentals.md) review axes — use either vocabulary consistently in a given critique |
| Juul *Half-Real*: juiciness as **congruence** / proportionate feedback (not a moral obligation) | `2_academic_theory` · [MIT Press](https://mitpress.mit.edu/9780262014563/half-real/) | Aligns with Kelly adequacy + progressive amplitude |
| Sticky / freeze-frame peak **100–150 ms** at climax for 30 fps / low-bitrate legibility | `6_streamer_readable_feedback…` | Optional Commit hit-stop hold band (still ≤50–150 ms, then clear); not full-screen freeze |
| Celebratory motion peaks **&lt;400 ms**, settles fast; motion only for cause→effect | `6_…` + M3 “fast by default” | Matches [16](16-timing-curves-recipes.md) enter caps + one celebration zone |
| M3 transition patterns (container transform, shared axis, fade-through) | `4_material_design_motion_google` | **Budgets only** for tab crossfade / toast enter; no FAB→page morphs in Classic shell |
| Consolidated citation table (shake, hitstop, easing tokens, Disney→IxDF) | `7_summary_table…` | Already covered in technique table above; use as QA checklist |

### Reject / do not port (deep-research field errors vs CoB)

| Claim in deep research | Why reject |
|------------------------|------------|
| `C_AlertSystem.AddAlert` / Retail AlertFrame as “only legal” edge toast | **Retail-only**; V1 uses custom edge `CreateFrame` on `UIParent` ([14](14-celebration-spectacle-design.md)) |
| Hook `COMBAT_LOG_EVENT_UNFILTERED` / loot / boss kills for jumbotron | CoB is announce/track/sync social ladder — **not** combat spectacle |
| `PlaySound(SOUNDKIT.READY_CHECK)` as celebration | Explicitly banned (trains boss-mechanic reflexes); V1 silent |
| Custom `Fonts\FRIZQT__.TTF` paths as V1 requirement | V1 = `GameFont*` ([UI brief](../../superpowers/ui-polished-direction-for-agents.md)) |
| “Don’t Juice” attributed as Föllmer & Clarissa Kelly | Prefer [Game Developer / Folmer Kelly](https://www.gamedeveloper.com/design/video-indies-resist-the-urge-to-juice-it-or-lose-it-) + [GDC Vault](https://www.gdcvault.com/play/1020861/don-t-juice-it-or) naming; verify before citing dual authors |
| Juice It described as Pong clone | Talk demo is Breakout-style block breaker ([Longwelwind](https://longwelwind.net/blog/juice-it/)) |

### Optional source URLs to pull next (not yet fully annotated above)

- [Swink 6 components of game feel (GameJuice summary)](https://www.gamejuice.co.uk/articles/swink-6-components-game-feel)  
- [Twitch recommended encoder settings](https://help.twitch.tv/s/article/recommended-encoder-settings) (stream smear ceiling)  
- [M3 transition patterns](https://m3.material.io/styles/motion/transitions/transition-patterns)  
- [addonstudio — Using OnUpdate correctly](https://addonstudio.org/wiki/WoW%3AUsing_OnUpdate_correctly) (aligns with no permanent OnUpdate)

---

## Related tracks

- Cookbook rows: [11 §8](11-game-juice-fundamentals.md)  
- Small/Medium/Epic: [14](14-celebration-spectacle-design.md)  
- Timing tokens: [16](16-timing-curves-recipes.md)  
- Stream checklist: [55](55-streamer-guild-event-ux.md)  
- Architecture tensions: [48](48-architecture-vs-juice-tensions.md) · [51](51-adversarial-performance-vs-juice.md)
