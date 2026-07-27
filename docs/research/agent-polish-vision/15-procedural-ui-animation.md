# 15 — Procedural / parametric UI animation → Classic `20506` APIs

**Series:** `docs/research/agent-polish-vision/`  
**Audience:** Coding agents polishing Church of Beef motion / juice  
**Status:** Research / implementer guidance — **not** product law  
**Last updated:** 2026-07-26  
**Client:** WoW TBC Classic Anniversary · `## Interface: 20506`  
**Companions:** [16 timing recipes](16-timing-curves-recipes.md) · [56 AnimationGroup Classic](56-wow-animationgroup-classic.md) · [11 juice fundamentals](11-game-juice-fundamentals.md) · [09 performance budgets](09-performance-budgets.md) · [46 toast system](46-toast-celebration-system.md)  
**Deep research dump:** [`.raw/procedural-ui-animation-wow-classic.json`](.raw/procedural-ui-animation-wow-classic.json) (`trun_91f36069f0964480ae5d16d929481c52`)  
**Search dumps:** [`_search-procedural-ui-animation.json`](_search-procedural-ui-animation.json), [`_search-procedural-ui-extra.json`](_search-procedural-ui-extra.json)

> **Authority:** Spec §10 / §15 · [UI agent brief](../../superpowers/ui-polished-direction-for-agents.md) · glossary 74–81 · `wow-performance.mdc` win on conflict. Scrapes / deep dumps are guidance — verify Anniversary in-client.

---

## Executive summary

Procedural UI animation = **parametric** property change over time (easing functions, spring-damper integrators, noise samples, stagger schedules, fake “particles”) driven from Lua — not sprite megapacks, not WeakAura center pulses.

On Classic Anniversary (`20506`) the toolkit is deliberately small:

| Driver | Strength | Weakness |
|--------|----------|----------|
| **`AnimationGroup`** | C-side Alpha / Translation / Scale / Rotation / Path; built-in `SetSmoothing`; `OnFinished` chaining; cheap while playing | Only four easing modes; no springs, noise, or custom bezier; acts on parent Region |
| **`OnUpdate(self, elapsed)`** | True frame delta for custom curves / physics / texcoord | Cost × FPS; must detach when idle; blocked when frame (or parent) hidden |
| **`C_Timer.After` / `NewTicker`** | Delay trains, hold times, low-rate cadence; `:Cancel()` | Accuracy = frame rate; short periods (~every 1–2 frames) are *worse* than throttled OnUpdate (Blizzard / Rygarius) |

**Church of Beef stance:** juice recognition events (toast / Commit); process chrome snappy and under-animated; UI owns all motion; Core/Net never animate; no permanent director while UI closed; V1 silent; spectacle = guild chat + one private toast.

---

## Technique → API mapping (primary deliverable)

Legend for **Primary driver:** prefer this first. **Fallback** = when Primary cannot express the curve/effect.

| Technique | What it is (2D UI) | Primary driver (`20506`) | Fallback / hybrid | AG can do natively? | CoB guidance |
|-----------|--------------------|--------------------------|-------------------|---------------------|--------------|
| **Linear tween** | Constant-speed from→to | `Animation` + `SetSmoothing("NONE")` | Stepped `C_Timer.After` alpha (today’s `Toasts.lua`) | **Yes** | Prefer AG over stepped timers for smooth fades |
| **Ease-in / ease-out / ease-in-out** | Acceleration profiles | `Animation:SetSmoothing("IN"\|"OUT"\|"IN_OUT")` | Custom ease via OnUpdate | **Yes** (enum only) | Enter → `"OUT"`; exit → `"IN"`; avoid `"NONE"` on chrome |
| **Custom cubic-bezier / Penner** | Designer curves beyond the enum | Throttled **`OnUpdate`** + `ease(t)` → `SetAlpha` / `SetPoint` / `SetScale` | `C_Timer.NewTicker` only if period ≥ ~0.05s; else OnUpdate | **No** | Rare — prefer enum smoothing for V1 |
| **Overshoot settle (fake spring)** | Grow past target then ease back | Two ordered `Scale` (or Translation) anims: order1 overshoot + order2 settle | True spring OnUpdate | **Approximate** | Rank-title settle only; overshoot ≤ ~8% |
| **Spring-damper (critical / underdamped)** | `F = −k·x − c·v` integration | **`OnUpdate`** with fixed-dt accumulator; cancel when `|x|<ε` and `|v|<ε` | Sampled `Path` control points (author-time bake) | **No** | Post-V1 / optional; never permanent |
| **Value / Perlin / simplex noise** | Organic drift, shake, flicker seed | **`OnUpdate`** sampling cached noise LUT; drive `SetPoint` / `SetVertexColor` | Low-rate `NewTicker(1/20)` for subtle drift | **No** | **Avoid** idle panel breathe; one-shot shake OK |
| **Stagger / cascade reveal** | Delay train across N widgets | `C_Timer.After(i * step, Play)` **or** per-anim `SetStartDelay` | Same-group `SetOrder` for sequential phases on **one** region | Delays **yes**; multi-region cascade needs timers | Cap N; precreate groups on pooled rows |
| **Wave reveal** | Delay as `f(index)` (e.g. cosine) | Compute delays in Lua → `After` / `SetStartDelay` | — | Delay only | Optional list polish; keep ≤10 Hz dirty coalesce |
| **Parallel multi-property** | Fade + slide together | Same `SetOrder` on Alpha + Translation in one group | Two groups `Play()` same frame | **Yes** | Toast enter canonical |
| **Sequential multi-phase** | A then B on same region | Different `SetOrder` values in one group | `OnFinished` → start next group | **Yes** | Prefer `OnFinished` over polling progress |
| **Hold then exit** | Dwell between enter/exit | `C_Timer.After(hold, exitPlay)` from enter `OnFinished` | `SetEndDelay` on last enter anim | Hold = timer | Matches `Toasts.lua` hold + pump |
| **Loop / bounce breathe** | Idle prestige pulse | `SetLooping("REPEAT"\|"BOUNCE")` | — | **Yes** but costly taste | **Banned** for CoB chrome |
| **Path / arc motion** | Spline through control points | `CreateAnimation("Path")` + `CreateControlPoint` + `SetOffset` + `SetCurveType` | Manual OnUpdate lerp | **Yes** (Path) | Out of V1; verify curve enums in-client |
| **Sprite-sheet / atlas flip** | Fake particle / icon burst | `C_Timer.NewTicker(frameDt, …)` → `SetTexCoord` / `SetAtlas` | OnUpdate accumulator | **No** (AG doesn’t flip UVs) | Needs Media — post-V1 only |
| **Alpha trails / ghosts** | Motion smear without particles | Pool of Textures; delayed Alpha groups or tickers decay α | — | Per-ghost Alpha **yes** | Skip V1; density fights Classic shell |
| **Multiplicative flicker** | Vertex-color strobe / firefly | Short OnUpdate or `NewTicker` modulating `SetVertexColor` | Noise LUT | **No** | Deterministic seed; never seizure-rate |
| **UV scroll fake** | Moving highlight band | OnUpdate `SetTexCoord` **or** Translation of oversized Texture inside clip parent | — | Translation **yes** for sheen slab | Prefer sheen Translation over exotic UV APIs |
| **Shimmer / sheen sweep** | One-shot highlight pass | `Translation` (+ optional `Alpha`) on ADD-blend Texture; `SetLooping("NONE")` | Reparent one shared sheen frame | **Yes** | Post-V1 ceremony only; not ladder idle |
| **Discrete delay / expire** | Queue pump, toast hold | `C_Timer.After` | One-shot OnUpdate accumulator (Toasts fallback) | N/A | Always cancel/advance on hide |
| **Low-rate logic tick** | Sync chip, coalesce | `C_Timer.NewTicker(≥0.1)` | Event + dirty flag | N/A | Never OnUpdate for scoring/net |

### Driver decision tree

```text
Need motion?
  ├─ Alpha / offset / scale / rotation with NONE|IN|OUT|IN_OUT
  │     → AnimationGroup (reuse; Stop on Hide; OnFinished cleanup)
  ├─ Hold / reorder / stagger starts across many frames
  │     → C_Timer.After / NewTicker (+ AG Play per item)
  ├─ Custom ease, spring, noise, SetTexCoord, SetVertexColor flicker
  │     → OnUpdate while active; SetScript(nil) or Hide when done
  └─ Idle / closed UI / business logic
        → REJECT permanent OnUpdate; events + C_Timer only
```

---

## Classic `20506` API constraints

### AnimationGroup anatomy

Sources: [UIOBJECT_AnimationGroup](https://warcraft.wiki.gg/wiki/UIOBJECT_AnimationGroup), [CreateAnimation](https://warcraft.wiki.gg/wiki/API_AnimationGroup_CreateAnimation), [UIOBJECT_Animation](https://warcraft.wiki.gg/wiki/UIOBJECT_Animation), [WoWInterface Animation roundup](https://www.wowinterface.com/forums/showthread.php?t=35104).

```text
Region (Frame / Texture / FontString / StatusBar / …)
  └── AnimationGroup   ← region:CreateAnimationGroup([name[, template]])
        └── Animation  ← group:CreateAnimation(type[, name[, inherits]])
              types: "Alpha" | "Translation" | "Scale" | "Rotation"
                     | "Path" | "ControlPoints" | "Animation"
```

| Control | Notes |
|---------|--------|
| Lifecycle | `Play` / `Pause` / `Stop` / `Finish`; scripts `OnPlay`, `OnStop`, `OnFinished`, `OnLoop`, `OnPause` |
| Looping | `SetLooping("NONE"\|"REPEAT"\|"BOUNCE")` — CoB: **NONE** |
| Smoothing | Per child: `"NONE"`, `"IN"`, `"OUT"`, `"IN_OUT"` (`OUT_IN` deprecated → alias of `IN_OUT`) — [Animation:SetSmoothing](https://warcraft.wiki.gg/wiki/API_Animation_SetSmoothing) / `ui:ANIMSMOOTHTYPE` |
| Order | Same order = parallel; higher order starts after prior order finishes |
| Delays | `SetStartDelay` / `SetEndDelay` per Animation |
| Final alpha | Probe `SetToFinalAlpha`; or set alpha / `:Hide()` in `OnFinished` |
| Models | Translation / Rotation / Scale on `PlayerModel` often **fail silently**; Alpha may work |

**Alpha API probe (do not assume Retail):**

```lua
local a = ag:CreateAnimation("Alpha")
if a.SetFromAlpha and a.SetToAlpha then
  a:SetFromAlpha(0); a:SetToAlpha(1)
elseif a.SetChange then
  frame:SetAlpha(0); a:SetChange(1) -- legacy delta
else
  -- stepped C_Timer fade (UI/Toasts.lua pattern)
end
```

**Path (wiki-accurate):** `Path:CreateControlPoint` → `ControlPoint:SetOffset` / `SetOrder`; `Path:SetCurveType`. Do **not** invent Retail-only `SetControlPoints` / `SetSpline` without Anniversary verify. Cookbook depth: [56](56-wow-animationgroup-classic.md).

### OnUpdate

Source: [UIHANDLER_OnUpdate](https://warcraft.wiki.gg/wiki/UIHANDLER_OnUpdate).

- Fires when UI is drawn; payload `(self, elapsed)` seconds since last dispatch for that widget.  
- **Blocked** when the frame or a parent is hidden — hide idle updaters.  
- Prefer Animation / `C_Timer` for ordinary motion; if used, **throttle** with an accumulator and `SetScript("OnUpdate", nil)` when settled.  
- Empty permanent handlers still cost dispatch.

### C_Timer

Sources: [C_Timer.After](https://warcraft.wiki.gg/wiki/API_C_Timer.After), [C_Timer.NewTimer / NewTicker](https://warcraft.wiki.gg/wiki/API_C_Timer.NewTimer).

| API | Use |
|-----|-----|
| `C_Timer.After(sec, fn)` | One-shot delay (hold, stagger start, expire) |
| `C_Timer.NewTicker(sec, fn[, iterations])` | Cadence; cancel via handle `:Cancel()` |
| `C_Timer.NewTimer` | Single-iteration ticker |

Blizzard note (Rygarius, 6.0 addon changes, still the cost model): timer heap is cheaper than Animation/OnUpdate for **sparse** work; for periods that fire **every couple of frames**, prefer **OnUpdate**. Timing accuracy is limited to frame rate; `After(0)` ≈ next frame.

Anniversary / modernized Classic exposes `C_Timer` (used already in CoB Net/UI). Keep a Toasts-style OnUpdate fallback if stubs lack `C_Timer` in desktop tests.

### Performance & lockdown (social addon)

| Rule | Why |
|------|-----|
| No permanent OnUpdate while UI closed | Idle budget ≈ noise ([09](09-performance-budgets.md), `wow-performance.mdc`) |
| Precreate / reuse AnimationGroups | Never `CreateAnimationGroup` per ladder row per refresh |
| `Stop()` + `Hide()` on interrupt | Groups retain state if only “forgotten” |
| Animate **insecure Beef-owned** frames only | No SecureActionButton “so toast animates”; no scripts on Blizzard protected widgets |
| Motion displays Core outcomes | UI never awards standing |
| In combat | Own FontString/Texture/alpha OK; do not SetPoint/parent protected Blizzard chrome |

---

## Technique deep dives

### 1. Easing

| Curve | Implementation |
|-------|----------------|
| Built-in ease | `anim:SetSmoothing("OUT")` etc. |
| Custom `ease(t)` | `t = clamp(elapsed/dur,0,1); v = from + (to-from)*ease(t)` inside OnUpdate |
| Reading progress | `anim:GetProgress()` / `GetSmoothProgress()` for debug or hybrid drivers |

Industry UX: most UI motion **100–500 ms**; ease-out enter / ease-in exit ([NN/g — Animation duration](https://www.nngroup.com/articles/animation-duration/)). CoB hard ceiling ~**600 ms** for single-property tweens ([16](16-timing-curves-recipes.md)).

### 2. Spring / damper

No native spring. Semi-implicit Euler (or Verlet) on a **temporary** OnUpdate:

```text
x' = x - target
a  = -k * x' - c * v
v  = v + a * dt
x  = x + v * dt
stop when |x'| < eps and |v| < eps → SetScript("OnUpdate", nil)
```

- Critically damped: `c ≈ 2 * sqrt(k)`  
- Underdamped bounce: `c < 2 * sqrt(k)`  
- Use **fixed dt** from an accumulator so feel does not change with FPS  

**Fake spring without physics:** order-1 Scale to 1.08 + order-2 Scale to 1.0 with smoothing — enough for toast title settle.

### 3. Noise

No Perlin API. Cache a permutation / value-noise table at load; sample `n(t * speed)` to offset points or modulate vertex color. Prefer **value noise** for UI. Tear down when the gesture ends — never leave panel “breathing” for prestige (stream noise + idle CPU).

Cheap substitute: layered `sin`/`cos` (two frequencies) for shake — often enough for a promote “thump.”

### 4. Staggered reveals

| Pattern | Recipe |
|---------|--------|
| Delay train | `for i, row in ipairs(rows) do C_Timer.After((i-1)*0.05, function() row.ag:Play() end) end` |
| Wave | `delay = base + amp * (1 - cos((i-1)*pi/(N-1)))` |
| Same-region phases | `SetOrder(1)`, `SetOrder(2)` on sibling anims |
| Intra-order offset | `SetStartDelay` on children with same order |

**Scale rule:** staggered Play on **pooled, prebuilt** groups. Cap visible cascade length. Dirty ladder refresh stays ≤10 Hz while open — do not re-stagger every BeefNet message.

### 5. Procedural particle-like frame tricks

Classic addons have **no** particle-system API. Fake it with Regions:

| Trick | Recipe | Driver |
|-------|--------|--------|
| Sheen sweep | Thin ADD Texture; Translation across parent width; optional Alpha | AG one-shot |
| Atlas / sheet flip | Advance `SetTexCoord` / `SetAtlas` on ticker | `NewTicker` ~8–12 Hz |
| Ghost trail | N pooled textures; copy point; Alpha decay groups | AG + timers |
| Flicker | Deterministic `SetVertexColor` modulation | Short OnUpdate |
| Clip scroll | Large texture under a smaller parent; translate | AG Translation |

**V1:** skip trails/sheets/sheen Media. Toast fade±slide is enough. Post-V1 ceremony may add one shared sheen if art exists and defaults stay quiet.

---

## CoB surface budget

| Surface | Motion | Driver |
|---------|--------|--------|
| Private edge toast | Fade ± ≤12–20 px slide; hold; faster exit | AG (upgrade) or stepped `C_Timer` (today) |
| Rank-up title | Soft scale settle once | AG Scale pair or short spring OnUpdate |
| Tab switch | Optional ≤250 ms alpha | AG — hard cut OK for V1 |
| Ladder row | Optional ≤500 ms one-shot highlight | AG Alpha; no forever groups |
| Sync / status | Static or one-shot fade | Timer — **no** spinner OnUpdate |
| Standing thresholds | None (text only) | — |
| Guild announce | Words only | Not a frame anim |

### Layer law

```text
✅ UI owns CreateAnimationGroup / fade helpers / temporary OnUpdate
✅ Cancel / Stop on Hide and toast queue advance
❌ Core/Net CreateFrame or AnimationGroup
❌ Permanent OnUpdate animation director while closed
❌ Secure templates for motion
❌ Center-screen WA pulses / looping prestige breathe
```

Current code: `addon/ChurchOfBeef/UI/Toasts.lua` — stepped fade via `after()`; OnUpdate only as `C_Timer` fallback. Valid procedural fade; AG is a smoothness upgrade, not a blocker.

---

## Practical mini-recipes (Anniversary-shaped)

### Toast enter → hold → exit

```text
enterAG: Alpha 0→1 + Translation slide, same order, SetSmoothing("OUT"), ~150–300 ms
OnFinished → C_Timer.After(HOLD, function() exitAG:Play() end)
exitAG: Alpha 1→0 (+ optional slide), SetSmoothing("IN"), faster than enter
OnFinished → Stop; Hide; pump queue
Interrupt: Stop both; snap alpha; show next
```

### Staggered list (pooled rows)

```text
Precreate row.ag once at pool alloc
On show wave: for i = 1..N do After((i-1)*step, function() if row:IsShown() then row.ag:Play() end end)
Never CreateAnimationGroup inside the loop body each refresh
```

### Sheen (post-V1 sketch)

```text
Shared sheen Texture (ADD), reparent to target
ag Translation across width, duration ~0.5–0.8 s, looping NONE
OnFinished → Hide sheen; clear parent
```

---

## Anti-patterns

| Anti-pattern | Prefer |
|--------------|--------|
| Permanent OnUpdate “juice director” | Event → Play → idle |
| `NewTicker(0)` forever for physics | Finite OnUpdate + settle cancel |
| `SetLooping("REPEAT")` on ladder chrome | One-shot `NONE` |
| Create AG per row per refresh | Pool + reuse |
| Custom cubic-bezier for every button | Built-in smoothing |
| Particle / confetti Media packs in V1 | Brand-in-words + toast |
| Animate Blizzard protected frames | Beef-owned insecure regions |
| Juicing every standing tick | Recognition events only |
| Clickable controls on Translating toasts | Alpha-only or static click targets ([hit-test gotcha](56-wow-animationgroup-classic.md#hit-test-out-of-body-critical-classic-gotcha)) |
| `C_Timer.NewTicker` for every hold | Bare `C_Timer.After` ([Phanx/SDPhantom](https://www.wowinterface.com/forums/showthread.php?t=49566)) |

### Hit-test vs paint (from AnimationGroup intro)

Procedural Translation/Scale via AnimationGroup moves the **drawn** region, not the hit rectangle, until Stop ([WoWI Animation roundup](https://www.wowinterface.com/forums/showthread.php?t=35104)). Custom OnUpdate `SetPoint` motion *does* move hit-testing (and costs FPS). For CoB: prefer AG Alpha for toasts; if you must slide, keep the frame mouse-disabled (`EnableMouse(false)`) for the whole envelope.

---

## Agent rules

1. Read UI brief → [16](16-timing-curves-recipes.md) → this note → [56](56-wow-animationgroup-classic.md) before shipping AG code.  
2. Probe Alpha from/to vs `SetChange` on Anniversary before toast rewrite.  
3. Event → play → `OnFinished` / last timer → nil OnUpdate / Stop groups.  
4. One toast frame, reused groups; interrupt cancels mid-fade.  
5. Harness: keep `COB._IN_TEST` flush shortcuts; green `lua tests/run.lua` ≠ feel proof — `/reload` smoke required.  
6. No tween OS / intensity tables / SharedMedia hooks for V1 ([49](49-adversarial-overengineering.md)).

---

## Open questions

1. Upgrade toast to AnimationGroup in V1 vs keep stepped `C_Timer`? Taste, not blocker.  
2. Reduced-motion SV? Classic has no OS preference — defer until playtest noise.  
3. Tab crossfade worth it vs Classic hard cut?  
4. Confirm Path `SetCurveType` enum values and Alpha from/to on live `20506`.  
5. Cap stagger N for large guilds so open-ladder cost stays under [09](09-performance-budgets.md) spike budgets.

---

## External sources

1. [UIOBJECT_AnimationGroup](https://warcraft.wiki.gg/wiki/UIOBJECT_AnimationGroup)  
2. [API AnimationGroup:CreateAnimation](https://warcraft.wiki.gg/wiki/API_AnimationGroup_CreateAnimation)  
3. [API AnimatableObject:CreateAnimationGroup](https://warcraft.wiki.gg/wiki/API_AnimatableObject_CreateAnimationGroup)  
4. [UIOBJECT_Animation](https://warcraft.wiki.gg/wiki/UIOBJECT_Animation) / [SetSmoothing](https://warcraft.wiki.gg/wiki/API_Animation_SetSmoothing)  
5. [UIOBJECT_Alpha](https://warcraft.wiki.gg/wiki/UIOBJECT_Alpha) · [Translation](https://warcraft.wiki.gg/wiki/UIOBJECT_Translation) · [Scale](https://warcraft.wiki.gg/wiki/UIOBJECT_Scale) · [Rotation](https://warcraft.wiki.gg/wiki/UIOBJECT_Rotation) · [Path](https://warcraft.wiki.gg/wiki/UIOBJECT_Path)  
6. [UIHANDLER_OnUpdate](https://warcraft.wiki.gg/wiki/UIHANDLER_OnUpdate)  
7. [API C_Timer.After](https://warcraft.wiki.gg/wiki/API_C_Timer.After) · [NewTimer / NewTicker](https://warcraft.wiki.gg/wiki/API_C_Timer.NewTimer)  
8. [WoWInterface — Animation roundup](https://www.wowinterface.com/forums/showthread.php?t=35104)  
9. [NN/g — Animation duration](https://www.nngroup.com/articles/animation-duration/)  
10. [Juice It or Lose It — GDC](https://www.gdcvault.com/play/1016487/juice-it-or-lose) (taxonomy, not FX density)  
11. In-repo: `UI/Toasts.lua`, `wow-performance.mdc`, track [04 events vs OnUpdate](../wow-classic-addon-design/04-toc-api-performance/03-events-onupdate-throttling.md)

---

## Changelog

| Date | Note |
|------|------|
| 2026-07-26 | Initial thorough note |
| 2026-07-26 | Deepen pass: juice lineage, recipe cards |
| 2026-07-26 | Deep research rewrite: technique→API table; spring/noise/stagger/particles; AG/OnUpdate/C_Timer constraints for `20506`; archived `.raw/procedural-ui-animation-wow-classic.json` |
| 2026-07-26 | Web harvest: hit-test vs paint; NewTicker overhead; cross-link [01b](01b-classic-ui-web-digest.md) / [56](56-wow-animationgroup-classic.md) |
