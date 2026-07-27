# 11 — Game juice fundamentals (for UI / social ladder)

**Track:** `agent-polish-vision`  
**Date:** 2026-07-26  
**Purpose:** Translate game-feel / “juice” literature into **UI and social-progression** practice for Church of Beef — not combat hit-stop, not raid WA pulses.  
**Authority:** Research only. Product locks stay in the [design spec](../../superpowers/specs/2026-07-25-church-of-beef-design.md) §10 / §15 and [UI agent briefing](../../superpowers/ui-polished-direction-for-agents.md). Do not fork policy here.  
**Annotated source digest:** [11b — Juice sources digest](11b-juice-sources-digest.md) (≥25 sources + technique→WoW table). Prefer 11b for citations; this note owns **vocabulary + cookbook**.

---

## 1. One-line stance for Beef

**Juice the feeling of recognition** (threshold crossed → officer Commit → guild sees it), not the chrome of every click. V1’s primary spectacle channel is a **throttled guild-chat line** plus a **private edge toast**; silent by default; Classic shell. Over-juicing process UI (tabs, lists, standing text) fights legibility and Anniversary constraints.

---

## 2. Vocabulary: game feel vs juice vs polish

| Term | Working definition | UI translation |
|------|--------------------|----------------|
| **Game feel** | Moment-to-moment sensation of control in a simulated space, emphasized by polish ([Swink](http://www.game-feel.com/); survey: [Pichlmair & Johansen 2020](https://arxiv.org/abs/2011.09201)) | Instant click response, predictable panel physics, clear cause→effect |
| **Juice** | Exaggerated / redundant audiovisual feedback that makes actions feel significant beyond strict mechanical necessity ([Juul](https://www.jesperjuul.net/); [Jonasson & Purho — Juice It or Lose It](https://www.youtube.com/watch?v=Fy0aCDmgnxg); Hicks et al.) | Particles-of-meaning: flash, bounce, chat line, toast, copy punch — sized to event importance |
| **Polish** | Layering reactive + proactive motion, sound, and effects so objects feel physical ([Fullerton](https://www.crcpress.com/) via survey; practitioners also mean “bugfix + timing”) | Consistent timing tokens, no dead Show/Hide snaps on *reward* moments |
| **Feedforward** | Information *before* action about what will happen ([Wensveen et al. — Interaction Frogger](https://doi.org/10.1145/1013115.1013140)) | Hover highlight, disabled Commit with reason, pending badge before approve |
| **Feedback** | Information *after* action confirming result | Button depress, toast, ladder row update, `/g` announce |

Pichlmair & Johansen’s survey clusters design intent into three domains that map cleanly onto addon UI:

1. **Physicality (tuning)** — cohesion, predictable motion, weight.  
2. **Amplification (juicing)** — empowerment + clarity of important events.  
3. **Support (streamlining)** — system acts on player intention (buffers, clear goals, forgiving confirm).

For Beef: **tune** everyday frames; **juice** Commit / promote / demote / first-threshold; **streamline** officer queue so the rite is easy to execute under raid-night pressure.

---

## 3. Core principles (combat metaphors → 2D UI)

Disney’s twelve principles (Thomas & Johnston, *The Illusion of Life*) are the shared root of both sprite juice and modern UI motion ([IxDF — applying the 12 principles](https://www.interaction-design.org/literature/article/the-12-principles-of-animation-for-ux-and-ui-design); [Dribbble Design Blog](https://dribbble.com/stories/2020/07/27/disney-principles-of-animation-ui-interactions)). Below: the subset that matters for social ladder UI.

### 3.1 Anticipation

**Game:** crouch before jump; wind-up before punch.  
**UI:** signal *what is about to happen* so the brain primes for the outcome.

| Beef surface | Anticipation pattern |
|--------------|----------------------|
| Officer Commit | Confirm copy + dual-encoded state *before* click; brief “armed” highlight on the selected petition |
| Promote night | Pending count / badge on Officer tab before the player opens it |
| Toast | Optional 1-frame scale-down or dim of surrounding UI *then* toast enter (micro wind-up) — keep &lt;80ms |
| Guild announce | Officer checkbox visible (feedforward: “this will speak to `/g`”) |

Without anticipation, Commit feels like a mute RPC. With too much, officers wait on theater.

### 3.2 Follow-through & overlapping action

**Game:** hair keeps moving after the head stops; camera settles after shake.  
**UI:** primary change lands first; secondary elements settle after; staggered list reflow.

| Beef surface | Follow-through |
|--------------|----------------|
| Ladder refresh after Commit | Row title/points update → short settle on highlight → toast → (async) chat line appears |
| Toast dismiss | Fade/slide continues slightly past “rest” opacity, then hide (avoid hard cut) |
| Tab switch | Content cross-fade overlaps tab underline slide (different durations) |

Canonical UI pattern: delete/remove a list row → row exits while neighbors ease into the gap ([IxDF follow-through](https://www.interaction-design.org/literature/article/the-12-principles-of-animation-for-ux-and-ui-design)).

### 3.3 Squash & stretch (metaphor, not cartoon meat)

**Game:** ball flattens on impact, elongates in flight — volume conserved, weight communicated.  
**UI:** interactive elements briefly change aspect / scale under “force,” then rebound ([timgraf — 12 principles for UX](https://timgraf.com/ux-design/disneys-12-principles-of-animation-the-foundation-of-lifelike-ux-ui-design-in-2026); Material pressed states).

WoW-safe metaphors (Anniversary `CreateFrame`):

| Metaphor | Implementation sketch | Use when |
|----------|------------------------|----------|
| **Press squash** | Button `OnMouseDown` → `SetScale(0.96–0.98)` or 1–2px inset; `OnMouseUp` restore with ease-out | Commit, Approve, Reject |
| **Impact stretch** | Toast enters at scale 0.92 → overshoots 1.03 → rests 1.0 (≤200ms total) | Promotion / demotion toast only |
| **Weight** | Longer ease-out on “heavy” rites (excommunication) vs short snap on checkbox toggle | Timing = valence |
| **Avoid** | Continuous breathing scale on idle panels; full-screen stretch; combat-log screen shake | Spec bans WA center pulses |

Squash/stretch in UI is **tactility and impact grammar**, not character animation.

### 3.4 Slow-in / slow-out (easing)

Linear motion reads mechanical ([Material duration & easing](https://m1.material.io/motion/duration-easing.html); [M3 easing](https://m3.material.io/styles/motion/easing-and-duration)). Rule of thumb from UI practice: most microfeedback **~150–300ms**; layout transitions **~200–500ms**; never make officers wait on juice ([Break Free Graphics / Material timing](https://www.breakfreegraphics.com/design-blog/how-to-use-disneys-12-motion-principles-in-designing-interface-animations)).

Suggested Beef timing tokens (research proposal — not product lock):

| Token | Duration | Easing feel | Surfaces |
|-------|----------|-------------|----------|
| `instant` | 0–50ms | none / step | checkbox, tooltip |
| `press` | 80–120ms | ease-out | button depress |
| `enter` | 160–220ms | ease-out | toast show, row highlight |
| `exit` | 120–180ms | ease-in | toast hide |
| `settle` | 200–320ms | ease-in-out | ladder reflow after Commit |
| `solemn` | 350–450ms | ease-in-out | demote / excommunication only |

### 3.5 Secondary action

A small flourish that **supports** the main message without stealing it ([userinterface.wiki — secondary action](https://www.userinterface.wiki/12-principles-of-animation)). Example: toast title is primary; a brief rank-color flash on the ladder row is secondary. Guild chat is a *parallel channel*, not a secondary particle — treat it as co-equal multimodal output (see §5).

### 3.6 Adequacy (anti-juice)

- [Jonasson & Purho](https://www.youtube.com/watch?v=Fy0aCDmgnxg) demonstrated stacking effects until a Breakout clone feels alive — useful as a **technique catalog**, dangerous as a **mandate**.  
- [Folmer Kelly — Don’t Juice It or Lose It](https://www.gdcvault.com/play/1020861/don-t-juice-it-or) (summary: [Game Developer](https://www.gamedeveloper.com/design/video-indies-resist-the-urge-to-juice-it-or-lose-it-)): polish without context kills immersion.  
- Empirical work: medium juiciness often beats extreme or none for experience and performance (Kao; discussed in [Pichlmair & Johansen](https://arxiv.org/abs/2011.09201)).  
- [Juul & Begy](https://scholar.google.com/scholar?q=Juul+Begy+Good+Feedback+for+Bad+Players+Juicy+Interface) caution that juicy interface feedback can obscure learning if every action screams “success.”  
- Lisa Brown (via survey): juice a **chosen feeling**, not “the game.”

**Beef rule:** juice *recognition and judgment*; keep Ladder / Standing / Officer chrome calm so officers can work.

---

## 4. Reward scheduling (social ladder, not loot RNG)

Behavioral schedules (Skinner) and game live-ops both teach: **when** feedback arrives matters as much as **how loud** it is.

| Schedule | Meaning | Beef mapping |
|----------|---------|--------------|
| **Continuous** | Every action rewarded | Button press feedback, list select highlight — always |
| **Fixed ratio** | Reward every *N* actions | Standing chips ticking toward next title (text thresholds only in V1 — no hero StatusBar) |
| **Variable ratio** | Reward after unpredictable *N* | Dangerous for core ladder truth; OK for *optional* comedy rites / Gora spice later — never for Commit authority |
| **Fixed interval** | Reward after time *T* | Anti-pattern for promotions (feels like paycheck, not glory) |
| **Variable interval** | Unpredictable time | Guild-night social peaks — design for *session* spectacle, not idle drip |

Product-aligned pacing (already locked in spec §4): **fast early ranks** (first dungeon night → first suggestion) then **stretch**. That is a **progressive ratio / expanding threshold** schedule — juice intensity should follow the same curve:

1. **Early (Fresh → Cooked):** brighter private toast; clear “you’re in” copy; continuous microfeedback OK.  
2. **Mid ladder:** quieter private feedback; save amplitude for officer Commit.  
3. **Rare / seat-limited / demote:** maximum multimodal budget (toast + `/g` + longer settle) — scarcity makes juice readable ([Hicks framework](https://doi.org/10.26503/dl.v2018i1.936): juiciness communicates *importance*).

**Do not** variable-ratio the *truth* of standing. Variable scheduling belongs to *ceremony cadence* and *social attention*, not to whether a Commit applied.

---

## 5. Multimodal feedback

Juice is rarely one channel. Hicks et al. ([DiGRA 2018](https://dl.digra.org/index.php/dl/article/view/936); [CHI PLAY 2019 visual embellishments](https://doi.org/10.1145/3311350.3347171)) treat juiciness as layered audiovisual (and sometimes haptic) embellishment. Interaction Frogger adds **modality coupling**: align time, location, direction, dynamics, modality, and expression between action and result.

| Channel | V1 Beef | Notes |
|---------|---------|-------|
| **Visual — process UI** | Classic frames, dual-encoded state colors, text thresholds | Always-on; low juice |
| **Visual — private toast** | Edge toast on promote/demote/self events | Primary personal juice |
| **Text — guild chat** | One throttled `/g` line from approving officer | Primary *social* juice; works without addon |
| **Text — UI copy** | Procedural officer labels; ceremonial announce strings | Brand in words (briefing doctrine) |
| **Audio** | **Silent in V1**; later one-shots default **off** | Spec §15; never ripped Blizzard SFX |
| **Haptic** | N/A (no controller API budget) | — |
| **Social / spectator** | Chat readable on stream (“subway legibility” / over-shoulder appeal in survey) | Design announce for readers, not just the promotee |

**Multimodal checklist for a Commit:**

1. Local: button squash + enabled→disabled state (inherent feedback).  
2. Local: ladder/standing refresh (functional feedback).  
3. Local: edge toast (amplified feedback).  
4. Guild: single announce if checkbox ON (social feedback).  
5. No: center-screen pulse, mandatory SFX, particle fullscreen.

Channels should **agree** (Frogger): if announce says “elevated to Beef Knight,” toast and ladder must show the same title from `Data/Ranks.lua` — never invent numbers in copy.

---

## 6. Hicks-style juiciness dimensions (UI cut)

From developer-grounded juicy-design analysis ([Hicks et al. 2018](https://doi.org/10.26503/dl.v2018i1.936)), useful axes for Beef reviews:

| Dimension | Ask | Fail mode |
|-----------|-----|-----------|
| **Direct feedback** | Did the click answer within a press token? | Silent Commit |
| **Amplification** | Is magnitude proportional to rank rarity / demote severity? | Same bounce for checkbox and excommunication |
| **Coherence** | Do motion, color, and copy share one emotion? | Meme toast + procedural announce mismatch |
| **Clarity** | Can a new officer parse success vs failure? | Juice hides error text |
| **Appeal / aliveness** | Does the *moment* feel alive without constant idle motion? | Breathing panels, WA envy |
| **Context** | Is this process UI or spectacle UI? | Juicing the entire Officer scroll list |

---

## 7. WoW / Anniversary constraints (implementation reality)

| Constraint | Implication for juice |
|------------|------------------------|
| Lua 5.1, `CreateFrame`, Classic templates | Prefer `AnimationGroup` / `Alpha` / `Translation` / `Scale` where available; else `OnUpdate` lerps; no web CSS easings |
| No Core→UI; UI never awards points | Juice is presentation of Core results only |
| Guest on player `uiScale` | Never `UIParent:SetScale`; toast/panel local `SetScale` OK if brief and restored |
| Taint / lockdown | No secure-action hacks for panel open; keep animations off protected paths |
| Performance | Cap concurrent tweens; one toast animation at a time; no per-row idle anim on full ladder |
| V1 silent | Multimodal ≠ audio-required |
| No custom Media required in V1 | Juice via timing, alpha, scale, font color, chat — not TGA particles |

---

## 8. Juice cookbook — 20 techniques → WoW frames

Each row is intentionally mappable to Anniversary frames. **Tier:** `always` = ship with V1 process UI; `spectacle` = Commit / toast / announce; `later` = art/SFX pass.

| # | Technique | Principle | WoW mapping | Beef surface | Tier |
|---|-----------|-----------|-------------|--------------|------|
| 1 | **Press squash** | Squash/stretch | `Button:SetScript("OnMouseDown/Up")` + brief `SetScale` or backdrop inset | Approve / Reject / Commit | always |
| 2 | **Hover feedforward** | Anticipation | `OnEnter`/`OnLeave` highlight texture or border color | Clickable rows, checkboxes | always |
| 3 | **Disabled honesty** | Feedforward | Grey + tooltip reason when not Officer+ / nothing selected | Commit | always |
| 4 | **Instant functional echo** | Direct feedback | Update `FontString` / row data in same event handler before anim | Ladder after Commit | always |
| 5 | **Ease-out enter** | Slow-out | `AnimationGroup` + `Alpha` 0→1, 160–220ms easeOut | Edge toast show | spectacle |
| 6 | **Ease-in exit** | Slow-in | Alpha 1→0 slightly faster than enter | Toast dismiss | spectacle |
| 7 | **Overshoot settle** | Follow-through | Scale 0.92→1.03→1.0 via 2–3 `Scale` anims or OnUpdate | Promote toast only | spectacle |
| 8 | **Impact flash** | Secondary action | 100–150ms `FontString` or row backdrop color pulse toward rank accent, then restore | Ladder row of promotee | spectacle |
| 9 | **Staggered reflow** | Overlapping action | After remove-from-pending, remaining rows `Translation` with 20–40ms stagger | Officer queue | later / light V1 |
| 10 | **Confirm anticipation beat** | Anticipation | Static confirm copy (or one-shot highlight) *before* destructive demote | Excommunication | always |
| 11 | **Solemn timing** | Timing = emotion | Use `solemn` token (longer ease) on demote toast vs promote | Demote toast | spectacle |
| 12 | **Success vs failure polarity** | Clarity | Green/dual-encode approve path; red/dual-encode reject; never same motion | Officer decisions | always |
| 13 | **Progressive amplitude** | Reward schedule | Early ranks: full toast; mid: shorter; seat ranks: max + announce emphasis | Toast + `/g` | spectacle |
| 14 | **Throttled social broadcast** | Multimodal / adequacy | Single `SendChatMessage` GUILD; officer-owned; checkbox gated | Promote/demote announce | spectacle |
| 15 | **Parallel channel sync** | Frogger coherence | Toast title string built from same rank id as announce template | Commit pipeline | always |
| 16 | **Hit-stop (UI metaphor)** | Amplification | 1–2 frame pause (`OnUpdate` hold) *only* on Commit success before toast — ≤50ms | Commit | spectacle |
| 17 | **Idle stillness** | Adequacy | No looping scale/alpha on main frame; motion only on state change | Main `/beef` frame | always |
| 18 | **Error juice ≠ reward juice** | Clarity | Errors: sharp, short, no overshoot; optional red flash; never celebratory bounce | Net/sync failures | always |
| 19 | **Spectator legibility** | Multimodal | Announce plain text readable on stream; avoid icon-only spectacle | `/g` line | spectacle |
| 20 | **Optional audio one-shot** | Multimodal | Later: `PlaySoundFile` custom, **default off**, never ripped Blizzard | Promote toast | later |

### Cookbook usage notes

- Techniques **1–4, 10, 12, 15, 17–18** are the V1 “competence juice” floor — feel responsive without looking like a juice tutorial.  
- Techniques **5–8, 11, 13–14, 16, 19** are the **recognition budget** — spend them on Commit outcomes.  
- Technique **9** is nice-to-have; skip if scrollframe complexity threatens taint/perf.  
- Technique **20** is explicitly post-V1 per spec.

---

## 9. Implications for Church of Beef (do / don’t)

**Do**

- Treat guild chat + private toast as the juiciness stack for promotions (spec success criterion: social reaction).  
- Match motion amplitude to rank scarcity and demote severity.  
- Keep Officer tab scannable: juice the *decision*, not every list paint.  
- Dual-encode states (color + text/icon) so juice never carries meaning alone.

**Don’t**

- Center-screen WA-style pulses for social events.  
- Continuous juice on standing text or ladder idle.  
- Variable-ratio fakery on whether points/ranks applied.  
- Mandatory SFX in V1.  
- Let research timing tokens override locked settings budget / silent V1 without a spec §15 amendment.

---

## 10. Sources

- [Steve Swink — Game Feel (book site)](http://www.game-feel.com/)  
- [Swink — Game Feel: The Secret Ingredient (Game Developer)](https://www.gamedeveloper.com/design/game-feel-the-secret-ingredient)  
- [Wikipedia — Game feel](https://en.wikipedia.org/wiki/Game_feel) (pointer index)  
- [Jonasson & Purho — Juice It or Lose It (YouTube)](https://www.youtube.com/watch?v=Fy0aCDmgnxg)  
- [GDC Vault — Don’t Juice It or Lose It (Folmer Kelly)](https://www.gdcvault.com/play/1020861/don-t-juice-it-or) · [Game Developer summary](https://www.gamedeveloper.com/design/video-indies-resist-the-urge-to-juice-it-or-lose-it-)  
- [Pichlmair & Johansen — Designing Game Feel: A Survey (arXiv:2011.09201)](https://arxiv.org/abs/2011.09201)  
- [Hicks et al. — Good Game Feel: Empirically Grounded Framework for Juicy Design (DiGRA 2018)](https://dl.digra.org/index.php/dl/article/view/936) · [DOI](https://doi.org/10.26503/dl.v2018i1.936)  
- [Hicks et al. — Juicy Game Design / visual embellishments (CHI PLAY 2019)](https://doi.org/10.1145/3311350.3347171)  
- [Wensveen, Djajadiningrat, Overbeeke — Interaction Frogger (DIS 2004)](https://doi.org/10.1145/1013115.1013140)  
- [Material Design — Duration & easing (M1)](https://m1.material.io/motion/duration-easing.html) · [M3 Easing and duration](https://m3.material.io/styles/motion/easing-and-duration)  
- [IxDF — 12 Principles of Animation for UX/UI](https://www.interaction-design.org/literature/article/the-12-principles-of-animation-for-ux-and-ui-design)  
- [Dribbble — Disney principles applied to UI](https://dribbble.com/stories/2020/07/27/disney-principles-of-animation-ui-interactions)  
- [timgraf — Disney 12 principles as UX foundation](https://timgraf.com/ux-design/disneys-12-principles-of-animation-the-foundation-of-lifelike-ux-ui-design-in-2026)  
- [Egmatic — Game feel & juice techniques overview](https://egmatic.net/blog/game-feel-and-juice)  
- Church of Beef: [design spec](../../superpowers/specs/2026-07-25-church-of-beef-design.md) · [UI agent briefing](../../superpowers/ui-polished-direction-for-agents.md)

### Provenance scrapes (not product truth)

- `.firecrawl/game-juice-fundamentals.json`  
- `.firecrawl/game-juice-ui-motion.json`  
- `.firecrawl/game-juice-schedules.json`

---

## 11. Expanded technique catalog → Classic constraints (2026-07-26)

Cross-walk from Juice It / Nijman / Gabler inventories through the [11b technique table](11b-juice-sources-digest.md). Combat metaphors that **do not port** are listed so agents stop inventing them.

| Juice It / Nijman-style effect | Port? | Classic / Beef substitute |
|--------------------------------|-------|---------------------------|
| Color punch / saturated impact | Yes | Dual-encoded rank accent on toast title + ladder row |
| Tween / easing | Yes | Short-lived alpha/offset/scale; `UIFrameFade*`; clear `OnUpdate` |
| Squash / stretch / wobble | Partial | Press squash on buttons; soft title overshoot on promote toast; **no** idle wobble on chrome |
| Sound / bass / music sync | Later | Silent V1; optional one-shot default off |
| Particles / trails / smoke | No (V1) | One-shot color/alpha flash; chat permanence instead of particle residue |
| Screen shake / camera kick | No | Banned on `UIParent`; never WA-like |
| Full-screen flash | No | `UIFrameFlash` on toast panel only |
| Slow-mo / time dilation | No | ≤50 ms hit-stop hold on Commit only |
| More balls / more enemies (density of action) | Metaphor | More *social* density = guild reaction to `/g`, not more toasts |
| Eyes / smile / ambient life | No | Idle stillness doctrine |
| Permanence (casings, scars) | Yes | Guild-chat line + lasting ladder title |
| Sleep / hit-stop | Micro | Commit success hold ≤50 ms then toast |
| Muzzle flash / gun kick | No | Press squash + instant FontString echo |

**Parametric control (2D UI):** expose severity as parameters — `duration_ms`, `ease_token`, `overshoot_pct` (0–10%), `stagger_ms` — not as particle counts. See [16](16-timing-curves-recipes.md).

**Streamer-readable feedback:** redundant channels must remain readable when only `/g` is captured ([55](55-streamer-guild-event-ux.md)). If toast motion fails, chat still carries the rite.

---

## 12. Related tracks

- Annotated sources: [11b](11b-juice-sources-digest.md)  
- Celebration tiers: [14](14-celebration-spectacle-design.md)  
- Timing recipes: [16](16-timing-curves-recipes.md)  
- Streamer UX: [55](55-streamer-guild-event-ux.md)  
- Standing density / anti-HP bars: `docs/research/wow-classic-addon-design/70-standing-breakdown-ui/`  
- Guild announce pipeline: `docs/research/wow-classic-addon-design/72-guild-chat-announce-api/`  
- Officer IA (where Commit juice must not obscure queue): `docs/research/wow-classic-addon-design/69-officer-tab-ia/`  
- Sibling polish-vision searches in this folder — this doc owns **fundamentals + cookbook**.
