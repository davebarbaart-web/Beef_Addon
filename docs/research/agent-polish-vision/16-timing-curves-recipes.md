# 16 — Timing curves & motion recipes (Classic-friendly)

**Audience:** Coding agents polishing Church of Beef UI motion.  
**Status:** Research / implementer recipes — **not** product law. Spec §10 / glossary / [UI brief](../../superpowers/ui-polished-direction-for-agents.md) win on conflict.  
**Companion dwell (toast hold):** [17 — duration-and-attention](../wow-classic-addon-design/17-stream-overlay-readability/duration-and-attention.md).  
**Source digest:** [11b](11b-juice-sources-digest.md) · principles [11](11-game-juice-fundamentals.md)

---

## Doctrine (one line)

*Snappy Classic shell feedback; save overshoot and long holds for rank spectacle — never WA center pulses.*

---

## Why these numbers

Industry motion systems converge on a tight band:

| Claim | Source |
|-------|--------|
| Most UX motion should land in **100–500 ms**; prefer shortest non-jarring | [NN/G — Animation duration](https://www.nngroup.com/articles/animation-duration) |
| Micro-feedback ≈ **100 ms**; substantial UI change ≈ **200–300 ms** | Same |
| Desktop transitions often **150–200 ms** (faster than mobile) | [Material 1 — Duration & easing](https://m1.material.io/motion/duration-easing.html) |
| MD3 short tokens **50 / 100 / 150 / 200 ms**; long **450–600 ms**; never stretch a single element past ~**600 ms** | [MD3 easing tokens (hub)](https://github.com/Glavo/md3-reference-hub/blob/main/docs/styles/motion/easing-and-duration/tokens-specs.md), [Motion tokens guide](https://camoa.github.io/dev-guides/css/css-craft/motion-design-tokens) |
| Enter = decelerate (ease-out); exit = accelerate (ease-in); exits **20–40% faster** than enters | [NN/G](https://www.nngroup.com/articles/animation-duration), [ux-ui-mastery timing curves](https://github.com/phazurlabs/ux-ui-mastery/blob/main/skills/interaction-motion-design/references/animation-timing-curves.md) |
| Stagger **30–50 ms** tight / **50–80 ms** standard; cap total cascade **~400–600 ms** | Same + [Plushie animation notes](https://hexdocs.pm/plushie/animation.md) |
| Toast enter slide/fade ≤ **300 ms**; hold from track 17; no looping glow during hold | [17 typography / motion](../wow-classic-addon-design/17-stream-overlay-readability/typography-scale.md) |
| Prefer event-driven show; **no permanent OnUpdate** | [04 events/OnUpdate](../wow-classic-addon-design/04-toc-api-performance/03-events-onupdate-throttling.md) |

**Classic filter:** Blizzard process UI feels decisive and slightly under-animated. Borrow MD/NN/G *budgets*, not Retail glow language. Linear only for true meters/progress; never for chrome.

---

## Token vocabulary (copy into constants)

### Duration ladder (`ms`)

| Token | ms | Use |
|-------|-----|-----|
| `D_INSTANT` | 50 | Press flash start, hit-confirm tick |
| `D_QUICK` | 100 | Toggle/checkbox feel, button depress |
| `D_FAST` | 150 | Desktop hover→active, tab indicator nudge |
| `D_NORMAL` | 200 | Small panel state, toast exit, tab content crossfade |
| `D_MODERATE` | 300 | Toast enter, progress fill short hop |
| `D_SLOW` | 400 | Rank-up title settle (rare) |
| `D_EXPRESSIVE` | 500–600 | Rank-up full beat (enter + settle); **hard ceiling for one property** |

Hold / dwell (toast on-screen time) is **not** a motion token — see track 17 (credit 3.5–5 s, suggest 5–7 s, promote/demote 6–8 s).

### Easing curves (cubic-bezier → Lua lerp)

Name them in code; implement as `ease(t)` on `t ∈ [0,1]` via `OnUpdate` elapsed / duration (or Blizzard `UIFrameFade*` for pure alpha).

| Token | Bezier (CSS form) | Character | When |
|-------|-------------------|-----------|------|
| `E_STANDARD` | `cubic-bezier(0.2, 0, 0, 1)` | MD3 standard — snappy settle | In-panel property changes |
| `E_DECEL` | `cubic-bezier(0, 0, 0, 1)` or M1 `0,0,0.2,1` | Ease-out / arrive | **Enter** screen |
| `E_ACCEL` | `cubic-bezier(0.3, 0, 1, 1)` or M1 `0.4,0,1,1` | Ease-in / depart | **Exit** screen |
| `E_EMPH_DECEL` | `cubic-bezier(0.05, 0.7, 0.1, 1)` | Emphasized arrive | Rank-up title only |
| `E_LINEAR` | `linear` | Mechanical | Progress bar **value** only |
| `E_BACK_SOFT` | approx. `cubic-bezier(0.34, 1.3, 0.64, 1)` | Mild overshoot (~8–12%) | Rank-up scale settle **only** |

M1 named set (legacy but still useful): standard `0.4,0,0.2,1` · decel `0,0,0.2,1` · accel `0.4,0,1,1` · sharp `0.4,0,0.6,1` — see [Material 1 Duration & easing](https://m1.material.io/motion/duration-easing.html).

### Stagger

| Pattern | Interval | Cap |
|---------|----------|-----|
| Tight (tab labels, 2–3 chrome bits) | **30–40 ms** | Total start delay ≤ **120 ms** |
| Standard (ladder rows reveal — post-V1 polish) | **50 ms** | Last start ≤ **400–450 ms**; if >10 rows, animate first 8 then snap rest |
| Dramatic (ceremony — V2+) | **80–100 ms** | Prefer not in V1 process UI |

### Overshoot budget

| Level | Amount | Allowed on |
|-------|--------|------------|
| None | 0% | Buttons, tabs, progress, toast exit |
| Soft | scale peak **1.04–1.08** then settle to 1.0 | Rank-up title / seal only |
| Hard bounce / elastic | — | **Banned** (WA / mobile-game feel) |

Spring mental model if you approximate: stiff/responsive (settle ~250–350 ms, ≤1 tiny overshoot) for chrome; “bouncy” springs only if you later add ceremony — not V1 shell ([ux-ui-mastery springs](https://github.com/phazurlabs/ux-ui-mastery/blob/main/skills/interaction-motion-design/references/animation-timing-curves.md)).

---

## Classic WoW implementation notes

1. **No CSS.** Translate recipes to: alpha, `SetPoint` offset, `SetWidth` on status bars, optional `SetScale` on toast title — driven by one short-lived `OnUpdate` that self-clears.
2. **Prefer Blizzard fades** for alpha-only: `UIFrameFadeIn` / `UIFrameFadeOut` (or thin wrapper) so you do not invent a second fade system.
3. **Transform budget:** slide ≤ **12–20 px** for toast; depress scale ≤ **0.97–0.98** for buttons. Bigger travel = longer duration (distance rule).
4. **Combat / taint:** never animate protected actions; cancel in-flight motion on hide/`PLAYER_REGEN_DISABLED` if a frame could be combat-sensitive.
5. **Reduced motion:** Classic has no `prefers-reduced-motion`. Offer SV later if needed; until then keep motion short and optional — snap to end state if a second event interrupts.
6. **V1 product bans still apply:** no center-screen pulses, no looping glow on toast body, no hero StatusBar on Standing (text thresholds). Progress-bar recipe is for **future / non-Standing** meters or post-V1 art — do not invent a standing HP bar to use it.

---

## Recipe cards

### Card A — Button press (`UIPanelButtonTemplate`)

| Field | Value |
|-------|--------|
| **Intent** | Instant “I clicked”; Classic panel button feel |
| **Trigger** | `OnMouseDown` / `OnMouseUp` (or template pressed texture) |
| **Properties** | Rely on Blizzard pressed art first; optional: alpha dip **0.92** or scale **0.98** on content |
| **Down** | `D_INSTANT`–`D_QUICK` (**50–100 ms**), `E_ACCEL` or snap |
| **Up / release** | `D_FAST`–`D_NORMAL` (**150–200 ms**), `E_DECEL` |
| **Overshoot** | None |
| **Stagger** | n/a |
| **Interrupt** | New press cancels release tween |
| **Classic note** | Prefer template pressed state over custom scale; if custom, keep ≤100 ms down so it never lags the click handler |

```
DOWN:  t=0→100ms  scale 1.0→0.98   ease accel/snap
UP:    t=0→180ms  scale 0.98→1.0   ease decel
```

---

### Card B — Tab switch (Ladder / My Standing / Officer+)

| Field | Value |
|-------|--------|
| **Intent** | Peer navigation, not page flip; indicator leads, content follows |
| **Trigger** | Tab button click after selection commits |
| **Phase 1 — indicator** | Active tab highlight / underline: **150–200 ms**, `E_STANDARD` |
| **Phase 2 — content** | Outgoing panel alpha **1→0** in **120–150 ms**, `E_ACCEL`; incoming **0→1** in **150–200 ms**, `E_DECEL`; overlap ~50 ms (crossfade) |
| **Total perceived** | ≈ **200–250 ms** end-to-end |
| **Overshoot** | None |
| **Stagger** | Optional: tab label vs panel **30–40 ms** (indicator first) |
| **Anti-pattern** | Horizontal slide of whole page (implies hierarchy); fade >300 ms (feels like loading) |
| **Classic note** | Match Character/Spellbook tab snappiness; Officer tab may reveal empty states — still same budget |

```
t=0       indicator moves (150–200ms, standard)
t=0       old content fades out (120–150ms, accel)
t≈50–80   new content fades in (150–200ms, decel)
```

---

### Card C — Toast in / out (private edge toast)

| Field | Value |
|-------|--------|
| **Intent** | Ephemeral flourish; guild chat remains durable spectacle |
| **Enter** | Fade + slide from edge **≤12–20 px**; **200–300 ms**, `E_DECEL` (cap **300 ms** per stream readability) |
| **Hold** | Per event class — [duration-and-attention](../wow-classic-addon-design/17-stream-overlay-readability/duration-and-attention.md): credit **3.5–5 s**, suggest **5–7 s**, promote/demote **6–8 s** |
| **Exit** | Fade (+ optional reverse slide); **150–200 ms**, `E_ACCEL` (~25–35% faster than enter) |
| **Overshoot** | None on chrome; rank-up toast may use Card D on the **title** only |
| **Stagger** | Title → body line **40–50 ms** (max 2 lines) |
| **Concurrency** | **One toast**; promote may interrupt credit; credit must not interrupt promote |
| **Anti-pattern** | Looping glow, bounce stack, enter >300 ms, Material phone dwell (1.5–2.75 s) |
| **OnUpdate** | Only while enter/exit running; clear script on complete |

```
ENTER: 0–280ms  alpha 0→1, y+16→0   E_DECEL
HOLD:  (dwell table)
EXIT:  0–180ms  alpha 1→0, y→+12    E_ACCEL
```

---

### Card D — Rank-up (local toast peak + optional ladder row)

| Field | Value |
|-------|--------|
| **Intent** | One satisfying beat; still edge toast — **not** center WA |
| **Choreography** | (1) Toast chrome enter Card C (2) title soft overshoot (3) hold (4) exit Card C |
| **Title motion** | Scale **0.92 → 1.06 → 1.0** (or 1.0 → 1.08 → 1.0); total **400–500 ms**, `E_EMPH_DECEL` + soft back; overshoot peak by **7–10%** |
| **Optional seal/icon** | Same curve, stagger **+40 ms** after title start |
| **Ladder row** (if panel open) | Highlight flash alpha pulse **once**: 0.3→1→0.3 over **300–400 ms**, no loop |
| **Hold** | **6–8 s** promote toast |
| **Guild chat** | Independent; announce is the stream-durable channel |
| **Overshoot** | Soft only; one cycle max |
| **Anti-pattern** | Screen flash, full-UI shake, particle storms, >600 ms title tween, SFX in V1 (silent) |

```
t=0      toast enter (≤300ms)
t=40     title scale settle (400–500ms, soft overshoot)
t=80     optional seal (same, staggered)
t=dwell  exit (150–200ms)
```

---

### Card E — Progress bar fill (non-Standing / post-V1 meters)

| Field | Value |
|-------|--------|
| **Intent** | Value change feels earned, not twitchy; readable as “fill,” not combat castbar |
| **V1 Standing** | **Do not use** — Standing is text thresholds only ([UI brief](../../superpowers/ui-polished-direction-for-agents.md)) |
| **Property** | Bar width / `StatusBar:SetValue` from old→new |
| **Duration** | Δ small (<15%): **200–300 ms**; Δ large: **350–500 ms**; never >**600 ms** |
| **Easing** | `E_LINEAR` or very slight `E_DECEL` (linear reads truest for meters) |
| **Overshoot** | **None** (overshoot on fill = lying about score) |
| **Stagger** | If label + bar: label updates at **t=0**, bar animates; or bar then label **+50 ms** |
| **Interrupt** | New value mid-tween retargets from **current displayed** value (no rewind to stale) |
| **Classic note** | Keep colors dual-encoded; no item-quality rainbow for ranks |

```
value_display = lerp(old, new, E_LINEAR(t/D))
D = clamp(200 + abs(delta)*something, 200, 500)
```

---

## Quick reference matrix

| Recipe | Enter / action | Exit / settle | Ease in | Ease out | Overshoot | Stagger |
|--------|----------------|---------------|---------|----------|-----------|---------|
| Button | 50–100 ms | 150–200 ms | accel/snap | decel | no | — |
| Tab | indicator 150–200; content 150–200 | content out 120–150 | decel in | accel out | no | 30–40 ms |
| Toast | 200–300 ms | 150–200 ms | decel | accel | no* | 40–50 ms lines |
| Rank-up | toast + title 400–500 | toast exit 150–200 | emph decel | accel | soft 7–10% | 40 ms title→seal |
| Progress | 200–500 ms fill | — | linear | — | **no** | optional 50 ms |

\*Rank-up title may overshoot; toast frame itself does not.

---

## Anti-patterns (reject in review)

- Single-element tweens **>600 ms** (feels laggy on desktop)
- Same easing for enter and exit
- Linear motion on buttons/tabs/toasts
- Stagger that makes last item wait **>600 ms**
- Elastic / multi-bounce springs on process UI
- Permanent `OnUpdate` “just in case”
- Center-screen celebration or looping glow during toast hold
- Animating Standing as a hero cast/HP bar in V1

---

## Parametric motion → juice techniques (Classic-safe)

Procedural / parametric animation in engines often means springs, noise, particle emitters. For Anniversary frames, **parameters are duration + ease + amplitude**, driven briefly then torn down ([11b parametric notes](11b-juice-sources-digest.md)).

| Parameter | Range (research) | Tied technique | Must clear |
|-----------|------------------|----------------|------------|
| `duration_ms` | 50–600 | All tweens; hard cap one property | Yes — end script |
| `ease` | `E_*` tokens above | Slow-in/out (Disney / Material) | n/a |
| `travel_px` | 0–20 | Toast slide / staging | Yes |
| `scale_peak` | 1.0–1.08 | Soft overshoot (rank title only) | Yes → 1.0 |
| `press_scale` | 0.96–0.98 | Squash on mouse down | Restore on up/hide |
| `stagger_ms` | 30–50 | Follow-through / overlapping | Cap cascade |
| `hold_ms` | 0–50 | Hit-stop metaphor on Commit | Never loop |
| `flash_ms` | 100–150 | Secondary impact flash | One-shot |
| `dwell_s` | per track 17 | Celebration hold (not a motion curve) | Timer cancel on interrupt |

**Juice It effects that become timing recipes (not VFX):**

| Juice It layer | Recipe card | Note |
|----------------|-------------|------|
| Tweening | A–C | Always |
| Squash/stretch | A, D | Soft only |
| Screen flash | D row flash / `UIFrameFlash` toast | Never full screen |
| Slow-mo | `hold_ms` ≤50 | Not timeScale |
| Particles / shake | — | Banned defaults |

**No permanent OnUpdate:** every card ends with “clear script on complete.” Prefer `UIFrameFadeIn`/`Out` for alpha-only so you do not own a second fade pump ([04](../wow-classic-addon-design/04-toc-api-performance/03-events-onupdate-throttling.md)).

---

## Relevance to Church of Beef

- Motion polish supports **trust and spectacle**; it does not replace guild-chat announce ([§13.11](../../superpowers/specs/2026-07-25-church-of-beef-design.md)).
- Keep shell motion in the **desktop-fast** band so `/beef` never feels like a mobile Material showcase.
- Spend the expressive budget on **rank-up toast title** only; everything else stays Classic-procedural.
- Stream viewers may only see `/g` — timing of toast is secondary to announce clarity ([55](55-streamer-guild-event-ux.md)).

---

## Sources

- [NN/G — Executing UX Animations: Duration and Motion Characteristics](https://www.nngroup.com/articles/animation-duration) (2021)
- [NN/G — The Role of Animation and Motion in UX](https://www.nngroup.com/articles/animation-purpose-ux/)
- [Material Design 1 — Duration & easing](https://m1.material.io/motion/duration-easing.html)
- [Material Design 3 — Motion overview](https://m3.material.io/styles/motion/overview/how-it-works) · [Easing and duration](https://m3.material.io/styles/motion/easing-and-duration)
- [MD3 easing & duration token specs (reference hub)](https://github.com/Glavo/md3-reference-hub/blob/main/docs/styles/motion/easing-and-duration/tokens-specs.md)
- [Motion design tokens (MD3-aligned)](https://camoa.github.io/dev-guides/css/css-craft/motion-design-tokens)
- [ux-ui-mastery — Animation timing curves](https://github.com/phazurlabs/ux-ui-mastery/blob/main/skills/interaction-motion-design/references/animation-timing-curves.md)
- [Plushie — Animation (stagger / ease guidance)](https://hexdocs.pm/plushie/animation.md)
- [Josh Comeau — Squash and Stretch](https://www.joshwcomeau.com/animation/squash-and-stretch)
- [IxDF — 12 principles for UX/UI](https://www.interaction-design.org/literature/article/the-12-principles-of-animation-for-ux-and-ui-design)
- [UX Stack Exchange — Toast temporary duration](https://ux.stackexchange.com/questions/11203/how-long-should-a-temporary-notification-toast-appear)
- Annotated juice digest: [11b](11b-juice-sources-digest.md)
- In-repo: [17 duration-and-attention](../wow-classic-addon-design/17-stream-overlay-readability/duration-and-attention.md), [17 typography motion](../wow-classic-addon-design/17-stream-overlay-readability/typography-scale.md), [04 OnUpdate](../wow-classic-addon-design/04-toc-api-performance/03-events-onupdate-throttling.md)
- Search dumps: `_search-timing-curves.json`, `_search-timing-stagger-overshoot.json` (this folder)
