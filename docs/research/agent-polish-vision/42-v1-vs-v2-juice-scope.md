# 42 — V1 vs V2+ juice / UX scope (strict partition)

**Audience:** Coding agents polishing Church of Beef UI / spectacle without exploding V1.  
**Last updated:** 2026-07-26  
**Status:** Research partition for polish loops — **not** a substitute for product law.  
**Authority (in order):** design spec §3.2 / §10 / §13 / §14 / §15 · [`ui-polished-direction-for-agents.md`](../../superpowers/ui-polished-direction-for-agents.md) · glossary rows 68–71, **74–81** · plan Tasks 7–13 · [`v1-checklist.md`](../../phases/v1-checklist.md).

If this note and the spec disagree, **spec wins**. Log any new product choice in spec §15 — do not leave it only here.

---

## Purpose

Partition “juice” (motion, copy, contrast, celebration, chrome, settings) so agents can **iterate polish on V1 surfaces** while **hard-stopping** ceremonial / media / theater ambitions that belong in V2+.

**Doctrine (one line):** *Guild chat + private edge toasts are the V1 spectacle budget; Classic Blizzard shell is the V1 chrome; everything else waits until the shell earns it.*

---

## Why strict partition (industry + CoB)

Juice literature celebrates *maximum sensory output for minimum input* ([Jonasson & Purho — Juice It or Lose It](https://www.youtube.com/watch?v=Fy0aCDmgnxg); primer: [GameJuice — What is game juice?](https://gamejuice.co.uk/articles/what-is-game-juice)). The matching caution talk is equally important: **Don’t Juice It or Lose It** — over-amplification can occlude cause→effect and burn attention budgets ([GDC Vault — Folmer Kelly](https://www.gdcvault.com/play/1020861/don-t-juice-it-or); [Game Developer summary](https://www.gamedeveloper.com/design/video-indies-resist-the-urge-to-juice-it-or-lose-it-)). Empirical work finds amplified feedback helps most when it is **success-dependent and coherent**, not sprayed on every micro-action ([CHI 2024 — How does Juicy Game Feedback Motivate?](https://dl.acm.org/doi/10.1145/3613904.3642656); [open PDF](https://people.csail.mit.edu/dkao/pdf/3613904.3642656.pdf)).

Product-management language for the same partition:

| Industry phrase | CoB translation |
|-----------------|-----------------|
| MVP / thin slice | V1 = ladder process UI + chat rite + edge toasts ([spec §14](../../superpowers/specs/2026-07-25-church-of-beef-design.md)) |
| Scope creep / feature factory | Custom Media, SFX packs, Streamer Mode, ceremonial dashboard |
| Polaroid / spike before polish | Guild-night social check (#11) before heraldry |
| Progressive disclosure | Tooltip glance → `/beef` detail; Approve without modal → StaticPopup only for nuclear rites |
| Attention scarcity (stream layouts) | Leave OBS alert + cam corners free; chat is the jumbotron ([Streamoz layout](https://streamoz.com/twitch-streaming-layout-tweaks-that-keep-viewers-watching); [OBS game layout](https://obsproject.com/kb/stream-tutorial-1-game)) |

**Agent rule:** If a polish PR cannot be described as improving a **V1 IN** row without inventing a new surface, it is V2+ — park it. Sibling roadmap: [`38-juice-spectacle-roadmap.md`](38-juice-spectacle-roadmap.md).

---

## How to use this in a polish loop

| Loop step | Allowed | Forbidden |
|-----------|---------|-----------|
| Pick a surface | Something in **V1 IN** below | Anything in **V1 OUT / V2+** |
| Improve | Copy, contrast, layout density, toast timing, dual-encode states, empty states, clamp/position, announce throttle | New tabs, Media/, SFX, meters, dashboards, Streamer Mode code |
| Done means | Checklist-relevant path feels clearer **and** no new settings/surface | “Looks more branded” via custom art or WA-style center pulses |
| Stop | When §13 social check (guild-chat reaction) would still pass without the flourish | When polish invents a second product surface |

**Polish ≠ feature.** Task 13 “final polish” means walk the checklist and fix blockers — not commission heraldry.

---

## V1 IN — polish these surfaces

Agents **may** loop juice/UX here. Prefer stock FrameXML + GameFont*; short `AnimationGroup` / `C_Timer` fades OK; never permanent `OnUpdate` for business logic.

### A. Process UI (shell + tabs)

| Surface | In-scope juice | Notes |
|---------|----------------|-------|
| `/beef` main frame | Movable title bar, clamp-to-screen, saved position, opaque high-contrast panel, Classic templates | Always create frame (no chat-only failure) |
| Tab chrome | Ladder / My Standing / Officer+ only; clear selected/unselected; hide Officer for members | No 4th product tab |
| Ladder tab | All 7 ranks, occupants, local highlight + title; readable density; pool rows | No HybridScroll unless overflow proven |
| My Standing | Standing, title, **text** next-threshold / appointed copy; recent grants (~10) | No hero StatusBar / meter dashboard |
| Officer tab | Suggestion queue Approve/Reject; demote / appoint / bestow / correct; seat/Prophet errors visible | Procedural labels; StaticPopup-class confirms where locked |
| Minimap button | Toggle same frame; show/hide pref; stock icon path | No LibDBIcon hard dep unless already triggered |
| Thin Gora / Ceremony stubs | Clear button labels + success/error feedback that scores paid | **No** match theater / ceremony art |
| Empty / edge states | Not-in-guild empty ladder; scoring paused; no BeefNet spam; soft version mismatch | Must not look “broken” — mark deferred features as later-phase in docs, not as disabled chrome |

### B. Spectacle (the V1 brand channel)

| Surface | In-scope juice | Notes |
|---------|----------------|-------|
| Guild-chat promote/demote | One throttled plain-text line from approving officer; glanceable at 720p; procedural copy | **Primary** §13.11 success channel; default ON |
| Announce opt-out | Officer-tab checkbox “Announce promotions to guild chat” → `ChurchOfBeefDB.ui.announce` | Not slash-only; opt-out must not kill Commit |
| Private toasts | Suggestion created; rank approved; Gora/ceremony credit; edge placement; opaque scrim; short fade | Concurrent **1**; promote dwell longer than credit; **no** center WA pulses |
| Local rank refresh after Commit / sync | Ladder/Standing/Officer rebind from Core | Net never invents ranks; UI never awards points |

### C. Settings budget (starved on purpose)

| Pref | V1 |
|------|-----|
| Frame position | Always |
| Minimap show/hide | Yes |
| Announce opt-out | Yes (default ON) |
| Toast mute | **Only if** guild-night playtest proves noise |
| Everything else | **Out** (see V2+) |

### D. Readability / safety polish (not new features)

- Class color on **names** only; dual-encode pending / approve / reject (color + text/icon)
- Guest on player `uiScale` — never set `uiScale` / `UIParent:SetScale`
- Taint-safe juice: own frames; no SecureActionButton “to open a panel”; no overwriting FrameXML handlers
- Combat courtesy: do not fight lockdown with protected mutations; queue if needed
- Missing-media: V1 ships **no** custom `Media/`; stock textures/fonts only; load must not fail
- Microcopy tone: church-comedy in **guild chat + toast titles**; Officer tab stays procedural
- One-line scripture/footer **placeholder** OK — not a lore browser

### E. Checklist-tied “done” (polish must not obscure these)

Polish loops are successful only if they still leave a clear path to:

1. Load on Anniversary `20506`  
2. `/beef` real frame (fresh install OK)  
3. Seven ranks + local title/standing  
4–5. Co-play / thin Gora / ceremony standing  
6–9. Suggest → Officer Commit → BeefNet + login sync; forged commit ignored  
10. No Retail-only APIs / no combat automation  
11. **Guild-night visible reaction** to a promotion line  

---

## V1 OUT / V2+ — do not implement in V1 polish

Park these. Research and canvases may discuss them; agents must **not** ship them as V1 juice.

### A. Ceremonial / product surfaces (spec §3.2 / §14 V2–V3)

| Ambition | Phase |
|----------|--------|
| Ceremonial dashboard / announcements wall | **V2** |
| Confessions feed spectacle | **V2** |
| Spotlight states as a product surface | **V2** |
| Richer scripture / lore systems (beyond one-line footer) | **V2** |
| Stream contrast pass as a funded visual program | **V2** |
| Audience favor / stream betting metaphors / theatrical favor bar | **V3** |
| Full Beef Gora match presentation / wrestling-show packaging | **V3** |
| Classic+ as primary platform | **V4** |

### B. Art / media / audio

| Ambition | Phase |
|----------|--------|
| Custom `Media/` textures, fonts, seals, gothic/heraldry chrome | Post-V1 art / spectacle pass |
| Commissioned flock seal escalation + Council/Prophet shape break | Post-V1 (glossary 80) |
| Brand hex / tinted chrome as law | After Anniversary screenshot lock — not Task 7–10 guesswork |
| Alliance vs Horde panel skins | Never V1; optional tiny faction chip only if streamers ask later |
| Bundled `.ogg` / LibSharedMedia / ceremony ambience / soundboard | Later spectacle; **default off**; V1 stays **silent** |
| Center-screen pulses, raid-warning kits, Master-channel “must hear” | Banned / deferred |

### C. UX sprawl & privacy code

| Ambition | Phase |
|----------|--------|
| UI-scale override, strata picker, per-event announce filters | Out of V1 settings budget |
| AceConfig / options explosion / tip jars / Masque / SharedMedia hard deps | Out |
| Streamer Mode code (name mask / quieter toast preset) | **V1.1** product call — not silent V1 scope; must never kill guild announce |
| Thin StatusBar track on My Standing (ranks 1–5) | Optional **post-playtest**, not Task 8 requirement |
| Meter-dashboard standing breakdown chrome | Out (track 70) |
| Toast mute as default ship item | Only if playtest demands |
| Shared BeefNet suggestion store / officer pull-on-login | V1.1 flag (`syncPendingSuggestions`), default off |
| Account-wide alt merge / profiles | Open question; not V1 |
| Standing decay / Lent reset | Off in V1 |

### D. Anti-patterns (reject in any phase of V1 polish)

WA center pulses for social · Details!-dense rosters · item-quality rainbow for ranks · ElvUI-flat as brand · glass/low-alpha panels · SecureActionButton for panels · in-game donation CTAs · standing-as-HP/castbar · Retail-only templates · forking thresholds into copy/art docs · CLEU-driven “juice” scoring · combat automation dressed as ceremony

---

## Quick lists (copy into PR / agent brief)

### V1 IN (allowed polish)

- Classic shell: `/beef`, minimap, 3 tabs, opaque panels, GameFont*, stock textures  
- Ladder readability + local highlight  
- Standing **text** thresholds + recent grants  
- Officer queue / confirm / seat errors + announce checkbox  
- Throttled guild-chat promote/demote line (primary spectacle)  
- Private edge toasts (suggest / approve / credit) — fade/timing/contrast only  
- Position + minimap + announce prefs  
- Empty guild / member-hidden Officer / sync soft-warn states  
- Dual-encode state colors; class color on names only  
- Short AnimationGroup / C_Timer toast fades  
- Microcopy on chat + toast titles; procedural Officer labels  
- Checklist walk / BugSack-clean session polish  

### V1 OUT → V2+ (park)

- Ceremonial dashboard, confessions feed, spotlight product UI  
- Custom Media/, heraldry, brand-hex chrome law, faction skins  
- Any SFX pack / LSM / ambience (V1 silent)  
- Streamer Mode implementation (V1.1)  
- Settings beyond position / minimap / announce (+ toast mute only if playtest)  
- Standing meters / favor bars / stream betting metaphors  
- Gora match theater / ceremony soundtrack  
- Shared suggestion sync store; alt merge; decay seasons  
- Classic+ packaging as V1 work  
- Center-screen WA-style celebration  

---

## Ambiguous temptations → bucket

| Temptation | Bucket | Rule |
|------------|--------|------|
| “Make the toast feel like a promotion” | **V1 IN** | Longer dwell + clearer title; still edge, still silent |
| “Add a soft ding on approve” | **V2+** (or later spectacle) | Spec: V1 silent |
| “Scarlet borders on the main frame” | **Out until hex lock / art pass** | Template-native V1 |
| “Thin XP-style bar under standing” | **Post-playtest optional** | Not Task 8; no meter dashboard |
| “Streamer quiet preset” | **V1.1** | Document coexistence only in V1 |
| “Confessions / sermon wall for chat clips” | **V2** | Spec §14 |
| “Animate ladder row on Commit” | **V1 IN** if subtle local rebind/highlight | Not a second spectacle channel; chat remains primary |
| “Per-event announce filters” | **Out** | Starved settings budget |
| “Commission seal art while Task 7 ships” | **Out** | Art after shell + chat spectacle work |
| “Match OWN3D full-screen alert energy” | **Out** | Creator OBS kit owns that; CoB stays edge + chat ([OWN3D](https://hi.own3d.pro/en/features/alert-widgets)) |
| “Juice every co-play tick like Breakout particles” | **Out** | Success-dependent amplification only ([CHI 2024](https://dl.acm.org/doi/10.1145/3613904.3642656)) |
| “LibSharedMedia + Masque for brand” | **Out** | Hard-dep / art-pass territory; V1 stock textures |

**Decision heuristic:** Ask “Would a member *without* the addon still feel the moment?” If the answer depends on custom art or SFX, the work is not V1 spectacle.

---

## Phase reminder (spec §14)

| Phase | Juice focus |
|-------|-------------|
| **V1** | Rank ladder process UI + guild-chat rite + private toasts |
| **V1.1** | Streamer SV preset shape; optional suggestion catch-up flag |
| **V2** | Ceremonial dashboard, confessions, richer scripture, stream contrast |
| **Art / spectacle pass** | `Media/` + optional SFX default off; shell stays Classic |
| **V3** | Full Gora presentation theater |
| **V4** | Classic+ port |

---

## Polish gate: when V1 “juice” is enough

Use this as a stop condition for agent loops (see also [`31-loop-stop-conditions.md`](31-loop-stop-conditions.md) and [`39-ui-direction-standards-expansion.md`](39-ui-direction-standards-expansion.md)):

1. **Social channel works** — Officer Commit with announce ON produces one glanceable `/g` line; non-addon members can react ([spec §13.11](../../superpowers/specs/2026-07-25-church-of-beef-design.md)).  
2. **Private channel works** — Edge toast readable under busy Classic HUD; concurrent queue ≤1 promote-weight toast.  
3. **Process UI is Classic-native** — Templates, GameFont*, opaque panels; no custom Media required to load.  
4. **No new settings surface** — Position / minimap / announce only (toast mute only if playtest proved noise).  
5. **Critique clean** — No WA center pulse, standing-as-HP, item-quality rank rainbow, tip jars, SecureActionButton panel openers.

If (1)–(5) pass and the PR is still “adding more juice,” **stop** — further amplitude belongs in V1.1 / art pass / V2.

### Scope anti-patterns borrowed from streams & games

| Temptation | Why it fails V1 | Industry echo |
|------------|-----------------|---------------|
| Full-screen promote alert | Competes with combat + OBS Alert Box | Stream tools sell *full-screen* hype for monetized events ([OWN3D Alert Widgets](https://hi.own3d.pro/en/features/alert-widgets); [Streamlabs Alert Box](https://streamlabs.com/stream-widgets/alert-box)) — that kit is the **streamer’s**, not the addon’s |
| Alert on every standing drip | Attention fatigue; kills scarcity | Twitch alert guidance: short, non-blocking, tier intensity ([Twitch alerts blog](https://blog.twitch.tv/en/2023/07/25/celebrate-your-community-your-way-with-twitch-s-alerts/); [NeonStreamLab alert examples](https://neonstreamlab.com/blog/engaging-twitch-alert-designs-10-examples-that-work)) |
| Custom gothic chrome before chat rite | Brand without social proof | Words-first doctrine in agent briefing |
| SFX default-on | Raid-warning collisions; silent V1 lock | Juicy audio is powerful ([Juice It or Lose It](https://www.youtube.com/watch?v=Fy0aCDmgnxg)) — CoB defers and defaults **off** |
| Meter dashboards for standing | Turns church into Details! | Progress UI research: text thresholds first (track 70) |

---

## Related notes

- Agent briefing: [`ui-polished-direction-for-agents.md`](../../superpowers/ui-polished-direction-for-agents.md)  
- Spectacle budget: [`17-stream-overlay-readability/beef-v1-spectacle-budget.md`](../wow-classic-addon-design/17-stream-overlay-readability/beef-v1-spectacle-budget.md)  
- SFX partition: [`20-sound-sfx-feedback/04-beef-v1-v2.md`](../wow-classic-addon-design/20-sound-sfx-feedback/04-beef-v1-v2.md)  
- Sibling polish notes: `02` frames · `03` taint · `04` media · `05` minimap · `08` settings · `11` juice fundamentals · `12`/`13` progression psychology · `14` celebration · `18` color · `38` roadmap · `39` standards · `55` streamer event  

---

## External sources

Research orientation only — **not** product law. Spec + glossary win on conflict.

1. [Jonasson & Purho — Juice It or Lose It (YouTube)](https://www.youtube.com/watch?v=Fy0aCDmgnxg) — canonical “juice = max output / min input” demo.  
2. [GameJuice — What is game juice?](https://gamejuice.co.uk/articles/what-is-game-juice) — modern primer separating juice / feel / polish.  
3. [GDC Vault — Don’t Juice It or Lose It (Folmer Kelly)](https://www.gdcvault.com/play/1020861/don-t-juice-it-or) · [Game Developer write-up](https://www.gamedeveloper.com/design/video-indies-resist-the-urge-to-juice-it-or-lose-it-) — over-juicing caution.  
4. [Pichlmair & Johansen — Designing Game Feel: A Survey (arXiv:2011.09201)](https://arxiv.org/abs/2011.09201) — physicality / amplification / support framing.  
5. [CHI 2024 — How does Juicy Game Feedback Motivate?](https://dl.acm.org/doi/10.1145/3613904.3642656) · [PDF](https://people.csail.mit.edu/dkao/pdf/3613904.3642656.pdf) — success-dependent amplification.  
6. [Hicks et al. — Good Game Feel / Juicy Design (DiGRA 2018)](https://doi.org/10.26503/dl.v2018i1.936) — empirically grounded juiciness.  
7. [Twitch — Celebrate your community with alerts](https://blog.twitch.tv/en/2023/07/25/celebrate-your-community-your-way-with-twitch-s-alerts/) — tiered celebration tooling.  
8. [Twitch — Hype Train Guide](https://help.twitch.tv/s/article/hype-train-guide) — scarcity + cooldown as social design.  
9. [OBS — Stream Layout Tutorial 1 (game + webcam)](https://obsproject.com/kb/stream-tutorial-1-game) — game-first canvas ownership.  
10. [Streamoz — Layout tweaks that keep viewers watching](https://streamoz.com/twitch-streaming-layout-tweaks-that-keep-viewers-watching) — hierarchy: game → cam → alerts → chat.  
11. [OWN3D — Alert Widgets](https://hi.own3d.pro/en/features/alert-widgets) · [Streamlabs Alert Box](https://streamlabs.com/stream-widgets/alert-box) — what *not* to recreate inside CoB V1.  
12. [Steve Swink — Game Feel (book site)](http://www.game-feel.com/) · [Game Developer — Game Feel: The Secret Ingredient](https://www.gamedeveloper.com/design/game-feel-the-secret-ingredient) — feel vs chrome.  
13. [Material Design — Duration & easing (M3)](https://m3.material.io/styles/motion/easing-and-duration) — short motion envelopes for UI (toast fades).  
14. [Gargul — Announcing Loot in Chat](https://github.com/papa-smurf/Gargul/wiki/Announcing-Loot-in-Chat) — cousin Classic pattern: officer-gated chat spectacle, not HUD takeover.  
)
