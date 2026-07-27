# 56 — WoW AnimationGroup on Classic / Anniversary (`20506`)

**Series:** `docs/research/agent-polish-vision/`  
**Audience:** Coding agents implementing toast / chrome motion in Church of Beef  
**Status:** Research cookbook — **not** product law  
**Last updated:** 2026-07-26  
**Client target:** TBC Classic Anniversary · `## Interface: 20506`  
**Companions:** [15 procedural UI animation](15-procedural-ui-animation.md) · [16 timing recipes](16-timing-curves-recipes.md) · [02 Lua vs XML](02-lua-vs-xml-frames.md) · [46 toasts](46-toast-celebration-system.md)  
**Search dump:** [`_search-wow-animationgroup-classic.json`](_search-wow-animationgroup-classic.json), [`_search-procedural-ui-animation.json`](_search-procedural-ui-animation.json)

> **Verify in-client before shipping.** Wiki pages mix Retail and Classic. Prefer Anniversary smoke over assuming every Retail method exists. Product bans (no WA center pulses, silent V1, no permanent OnUpdate) still apply.

---

## Executive summary

`AnimationGroup` is Blizzard’s widget animation system (introduced **patch 3.1**). It is available on modern Classic lineages and is the preferred way to drive short Alpha / Translation / Scale tweens on **insecure Beef-owned frames** without a permanent business-logic `OnUpdate`.

For CoB V1:

- Use AnimationGroup for **toast enter/exit** (and optional rank-up title scale) on `ChurchOfBeefToast` / tab chrome.  
- Keep `SetLooping("NONE")`; tear down / `Stop()` when hidden or queue advances.  
- Preserve today’s `C_Timer.After` hold + queue pump in `UI/Toasts.lua`; only replace the stepped fade.  
- Do **not** put AnimationGroups in Core/Net; do not depend on LibAnimate / LibFrameFade for V1.

---

## Sourced practices

### Object model

From [Warcraft Wiki — AnimationGroup](https://warcraft.wiki.gg/wiki/UIOBJECT_AnimationGroup) and [CreateAnimation](https://warcraft.wiki.gg/wiki/API_AnimationGroup_CreateAnimation):

```text
Region (Frame / Texture / FontString)
  └── AnimationGroup   ← CreateAnimationGroup([name[, template]])
        └── Animation  ← CreateAnimation(type[, name[, inherits]])
              types: "Alpha" | "Translation" | "Scale" | "Rotation"
                     | "Path" | "ControlPoints" | base "Animation"
```

- The animation’s **region parent** is the AnimationGroup’s parent (the Region being animated).  
- Groups support scripts: `OnPlay`, `OnStop`, `OnFinished`, `OnPause`, `OnLoop`, …  
- `Play` / `Pause` / `Stop` / `Finish` control playback; `GetProgress()` is unit `[0,1]`.

Creation:

```lua
local ag = frame:CreateAnimationGroup()
-- or: AnimatableObject:CreateAnimationGroup([name[, templateName]])
-- Added 3.1.0 — see https://warcraft.wiki.gg/wiki/API_AnimatableObject_CreateAnimationGroup
```

### Child animation types (Classic-relevant)

| Type | Typical setters | CoB use |
|------|-----------------|--------|
| **Alpha** | Duration, smoothing; from/to **or** legacy change delta | Toast fade — **primary** |
| **Translation** | `SetOffset(x, y)`, duration, smoothing | Toast slide ≤12–20 px |
| **Scale** | from/to scale or `SetScale`; origin matters | Rank-up title soft overshoot only |
| **Rotation** | `SetDegrees` | **Avoid** for process UI (WA feel) |
| **Path / ControlPoints** | Complex paths | **Out of V1 scope** |
| Base **Animation** | Timing only; custom via its OnUpdate | Rare; prefer typed anims |

Community cookbook ([WoWInterface Animation roundup](https://www.wowinterface.com/forums/showthread.php?t=35104)):

```lua
local ag = f:CreateAnimationGroup()
local a1 = ag:CreateAnimation("Translation")
a1:SetOffset(x, y)
a1:SetDuration(0.28)
a1:SetSmoothing("OUT")
```

### Smoothing & ordering

| API | Values / notes |
|-----|----------------|
| `Animation:SetSmoothing(smoothType)` | `"IN"`, `"OUT"`, `"IN_OUT"` (archives also mention `"OUT_IN"`) |
| UX mapping | Enter → `"OUT"` (ease-out); Exit → `"IN"` (ease-in) — matches [NN/g](https://www.nngroup.com/articles/animation-duration/) |
| `SetOrder(n)` | Same order = parallel; higher order = after previous finishes |
| `SetStartDelay` / end delay | Stagger title vs chrome ([16](16-timing-curves-recipes.md)) |
| `AnimationGroup:SetLooping(loopType)` | `"NONE"`, `"REPEAT"`, `"BOUNCE"` — CoB: **NONE** only |

### Alpha API evolution (verify on Anniversary)

Historical / Retail notes from the Animation roundup and later patches:

| Era | Alpha API |
|-----|-----------|
| Early 3.1 style | Often `change` delta on `<Alpha>` |
| Later (e.g. 6.0+ notes in roundup) | `fromAlpha` / `toAlpha`; `SetToFinalAlpha` on groups |

**Agent rule:** probe at runtime:

```lua
local a = ag:CreateAnimation("Alpha")
if a.SetFromAlpha and a.SetToAlpha then
  a:SetFromAlpha(0)
  a:SetToAlpha(1)
elseif a.SetChange then
  -- legacy: change is delta; set frame alpha first
  frame:SetAlpha(0)
  a:SetChange(1)
else
  -- fall back to C_Timer stepped fade (Toasts.lua today)
end
```

Do not assume Retail `SetFromAlpha` without the probe.

### Looping & final alpha

- `OnFinished` fires when a non-looping group completes; looping groups need `Finish()` for a terminal callback (roundup docs).  
- `SetToFinalAlpha(true)` (where present) applies the final animated alpha to the region when the group ends — useful so a fade-out does not snap back. Prefer explicit `frame:SetAlpha` / `:Hide()` in `OnFinished` for clarity on Classic.

### Hit-test “out of body” (critical Classic gotcha)

Blizzard’s 3.1 animation intro (preserved in the [WoWInterface Animation roundup](https://www.wowinterface.com/forums/showthread.php?t=35104)): the Animation system paints Regions at offset positions, but **mouse hit-testing still uses the Anchor/layout position** until the animation `Stop`s (or a `SetPoint` / drag side-effect clears it).

```text
Button anchored at (50,50)
Translation +50x → paints at (100,50)
Mouse must hover (50,50) to highlight — not the painted (100,50)
```

**CoB mapping:**

- Private **non-interactive** promote toasts may slide/fade freely.  
- Never put officer Approve / Reject / Commit **buttons** on a Translating/Scaling toast.  
- Prefer fade-only (Alpha) for anything that might later gain click handlers.  
- After `Stop`/`OnFinished`, reset points/alpha explicitly so the next queue item is not stuck offset.

`SetPoint` / `ClearAllPoints` / drag on an ancestor **implicitly stops** animations (same roundup) — movable main windows should `Stop()` toast groups before layout thrash.

### Performance vs OnUpdate

[Wowpedia — OnUpdate](https://wowpedia.fandom.com/wiki/UIHANDLER_OnUpdate): OnUpdate can fire every painted frame; prefer `C_Timer` or **Animation** for widget motion. Phanx also notes AnimationGroup duration + `OnFinished` as a timer alternative to OnUpdate countdown ([Function timing — WoWI](https://www.wowinterface.com/forums/showthread.php?t=49566)).

LibAnimate ([CurseForge](https://www.curseforge.com/wow/addons/libanimate)) advertises OnUpdate drivers to “avoid AnimationGroup bugs.” For CoB V1: **do not add a library** — keep one short group on the toast; if Anniversary AnimationGroup misbehaves, keep the existing `C_Timer` stepped fade.

### UIFrameFade relationship

`UIFrameFadeIn` / `UIFrameFadeOut` are FrameXML helpers ([WoWWiki UIFrameFadeIn](https://wowwiki-archive.fandom.com/wiki/API_UIFrameFadeIn)). [LibFrameFade](https://github.com/Meorawr/LibFrameFade) once reimplemented them on AnimationGroup to fight taint; **v14 disables itself** — Blizzard patched Classic/Retail. CoB may use stock fades on insecure frames or own AnimationGroups; no embed required.

---

## CoB-specific application

### Recommended toast upgrade (illustrative)

Preserve queue / hold semantics in `addon/ChurchOfBeef/UI/Toasts.lua`. Replace `fadeIn` / `fadeOutThen` internals roughly as:

```lua
-- Pseudocode — verify API on Anniversary before shipping
local function ensureFadeGroup(frame)
  if frame.cobFadeIn then return end
  local gin = frame:CreateAnimationGroup()
  local ain = gin:CreateAnimation("Alpha")
  ain:SetDuration(0.15)           -- FADE_IN
  ain:SetSmoothing("OUT")
  ain:SetOrder(1)
  -- SetFromAlpha/SetToAlpha or SetChange via probe…
  local tin = gin:CreateAnimation("Translation")
  tin:SetOffset(0, -16)           -- play reverse mentally: often set start offset on frame
  tin:SetDuration(0.15)
  tin:SetSmoothing("OUT")
  tin:SetOrder(1)
  gin:SetLooping("NONE")
  frame.cobFadeIn = gin

  local gout = frame:CreateAnimationGroup()
  local aout = gout:CreateAnimation("Alpha")
  aout:SetDuration(0.22)          -- FADE_OUT
  aout:SetSmoothing("IN")
  gout:SetLooping("NONE")
  gout:SetScript("OnFinished", function()
    frame:Hide()
    frame:SetAlpha(1)
    -- then pump(queue)
  end)
  frame.cobFadeOut = gout
end
```

**Translation gotcha:** Translation animates offset during play; after `Stop`/`Finished`, confirm whether the region retains offset. Safer pattern: set point for enter start (`TOP`, `UIParent`, `TOP`, 0, -144), animate to -160 (or reverse), then reset point in `OnFinished`.

### When to use which driver

| Need | Prefer | Fallback |
|------|--------|----------|
| Alpha toast fade | AnimationGroup `Alpha` | Stepped `C_Timer` (current) |
| Hold 3.5s | `C_Timer.After` | One-shot OnUpdate timer |
| Rank-up scale | AnimationGroup `Scale`, order after fade | Skip (static title) |
| Sync chip | No animation | Static text ([45](45-beefnet-sync-status-ux.md)) |
| Custom bezier | Short OnUpdate lerp using [16] ease functions, then nil script | — |

### Layering

| Allowed | Forbidden |
|---------|-----------|
| `UI/Toasts.lua`, `UI/MainFrame.lua` tab panels | `Core/*`, `Net/*`, `Data/*` |
| Groups on Beef-named frames | Animating CompactRaid / ActionButton / secure templates |
| `Stop()` on `HideAll` / new pump | `SetLooping("REPEAT")` prestige glow |
| Fail-soft if `CreateAnimationGroup` nil | Crashing load / blocking `/beef` |

### Combat / taint

- Product windows stay **insecure** (`wow-ui-taint-lockdown.mdc`).  
- AnimationGroup on Beef frames does not require secure templates.  
- Cancel groups in combat only if a frame could interact with protected UI — toast is HIGH strata insecure; still `Stop()` on hide to avoid orphan callbacks calling into torn-down state.

### Test harness

Keep:

```lua
if COB._IN_TEST or not frame.SetAlpha then
  -- skip multi-step / AnimationGroup; advance queue immediately
end
```

Desktop Lua has no real AnimationGroup host; tests must not depend on `OnFinished` firing from the client.

---

## Agent rules

1. **Probe APIs** (`SetFromAlpha` vs `SetChange`, `SetToFinalAlpha`) on Anniversary before committing a toast rewrite.  
2. **One reusable group per direction** (fadeIn / fadeOut) on the toast frame — no per-Show allocation storms.  
3. **`SetLooping("NONE")` always** for CoB V1 social UI.  
4. **`OnFinished` must Hide + reset alpha/points + continue queue**; never leave the frame stuck invisible at alpha 0.  
5. **Interrupt:** `ag:Stop()` before starting the opposite direction or next envelope.  
6. **Duration tokens** from [16](16-timing-curves-recipes.md): enter ≤300 ms, exit faster, title settle ≤500–600 ms.  
7. **No new dependencies** (LibAnimate, LibFrameFade, SharedMedia) for motion.  
8. **Evidence:** `/console scriptErrors 1` → `/reload` → trigger toast path; BugSack empty. Do not claim motion polish from harness alone.  
9. **TOC:** AnimationGroups are created in Lua — no TOC entry unless you add XML templates (`02`).

---

## Open questions

1. **Exact Alpha API surface on Interface `20506`?** Needs one in-game probe session; document results in a short appendix later.  
2. **Does Translation persist offset after Stop on Classic?** Affects whether agents must reset `SetPoint` every play.  
3. **FontString scale vs Frame scale for rank-up title?** Scaling the whole toast vs a child title region — prefer child to avoid backdrop swim.  
4. **Ship AnimationGroup in V1 or freeze stepped fades?** Product call; stepped is already acceptable under [15](15-procedural-ui-animation.md).  
5. **Tab crossfade groups worth XML templates?** Only if ≥3 call sites — otherwise pure Lua (`02` decision tree).

---

## Source links

**API references**

- [AnimationGroup (Warcraft Wiki)](https://warcraft.wiki.gg/wiki/UIOBJECT_AnimationGroup)  
- [AnimationGroup:CreateAnimation](https://warcraft.wiki.gg/wiki/API_AnimationGroup_CreateAnimation)  
- [AnimatableObject:CreateAnimationGroup](https://warcraft.wiki.gg/wiki/API_AnimatableObject_CreateAnimationGroup)  
- [Wowpedia — CreateAnimation](https://wowpedia.fandom.com/wiki/API_AnimationGroup_CreateAnimation)  
- [Wowpedia — CreateAnimationGroup](https://wowpedia.fandom.com/wiki/API_AnimatableObject_CreateAnimationGroup)  
- [Addon Studio — Widget API](https://addonstudio.org/wiki/WoW:Widget_API)  
- [WoWWiki archive — SetSmoothing](https://wowwiki-archive.fandom.com/wiki/Widget_API)

**Community / history**

- [WoWInterface — Animation roundup](https://www.wowinterface.com/forums/showthread.php?t=35104) (3.1 intro, XML schema, 6.0 from/to notes)  
- [Wowpedia — OnUpdate](https://wowpedia.fandom.com/wiki/UIHANDLER_OnUpdate)  
- [Meorawr/LibFrameFade](https://github.com/Meorawr/LibFrameFade)  
- [UIFrameFadeIn (archive)](https://wowwiki-archive.fandom.com/wiki/API_UIFrameFadeIn)  
- Example usage patterns: [spelgubbe/wow-ui-functions](https://github.com/spelgubbe/wow-ui-functions/blob/master/functions.lua)  
- Vanilla-era backport curiosity only: [martinjlowm/AnimationGroup](https://github.com/martinjlowm/AnimationGroup) (1.12) — **not** for Anniversary

**In-repo**

- `addon/ChurchOfBeef/UI/Toasts.lua`  
- `.cursor/rules/wow-performance.mdc`, `wow-ui-taint-lockdown.mdc`  
- [15](15-procedural-ui-animation.md), [16](16-timing-curves-recipes.md), [02](02-lua-vs-xml-frames.md), [46](46-toast-celebration-system.md)

---

## Quick probe snippet (in-game `/run` or temp slash)

```lua
local f = CreateFrame("Frame", nil, UIParent)
local okGroup = type(f.CreateAnimationGroup) == "function"
local ag = okGroup and f:CreateAnimationGroup()
local a = ag and ag:CreateAnimation("Alpha")
print("CreateAnimationGroup", okGroup)
print("SetFromAlpha", a and type(a.SetFromAlpha))
print("SetToAlpha", a and type(a.SetToAlpha))
print("SetChange", a and type(a.SetChange))
print("SetToFinalAlpha", ag and type(ag.SetToFinalAlpha))
```

Paste results into playtest notes before merging an AnimationGroup toast PR.

---

## Changelog

| Date | Note |
|------|------|
| 2026-07-26 | Initial Classic/Anniversary AnimationGroup cookbook |
| 2026-07-26 | Harvest deepen: hit-test “out of body,” Stop-on-SetPoint, Phanx timer note |
