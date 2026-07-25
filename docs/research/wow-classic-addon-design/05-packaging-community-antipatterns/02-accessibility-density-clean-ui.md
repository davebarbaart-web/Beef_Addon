# Accessibility, Density, Scale & “Clean UI” Trends (Classic 2024–2026)

**Last updated:** 2026-07-25  
**Lens:** What Classic / Classic Hardcore / TBC Anniversary players reward visually — and what Blizzard already provides.

---

## 1. Blizzard accessibility baseline (authors must assume this exists)

### 1.1 Colorblind filters (since Patch 6.1)

Official source: [New Colorblind Support in Patch 6.1](https://worldofwarcraft.blizzard.com/en-gb/news/17964863/new-colorblind-support-in-patch-61).

Blizzard shipped an **Accessibility** options section with:

- **UI Colorblind Mode** text enhancements (e.g. “Rare” / “Epic” / friend-enemy-neutral wording when color alone would convey meaning)
- Three filter sets: **protanopia, deuteranopia, tritanopia**
- A **strength** slider that removes problematic wavelengths as it increases

**Author duty (verified implication):** you do **not** need to reimplement client-wide colorblind shaders. You **do** need to verify custom rank colors, status paints, and textures remain distinguishable under each filter + text mode. Do not encode ladder state as red-vs-green alone.

### 1.2 Consolidated Accessibility menus (modern clients)

Secondary report of Dragonflight-era consolidation: [Blizzard Watch — accessibility options](https://blizzardwatch.com/2022/07/27/accessibility-options-dragonflight/). Relevant themes that continue to shape player expectations even when Classic options lag retail:

| Theme | Why it matters for addons |
|-------|---------------------------|
| Photosensitivity / alternate full-screen effects | Avoid strobing ceremony flashes by default |
| Quest / text contrast | Ladder and officer UI text must stay high-contrast |
| Move pad / motor accessibility | Prefer keyboard-reachable slash commands (`/beef`) and large hit targets |
| Text-to-speech | Chat injections should be readable as plain text |
| Colorblind still in Accessibility | Same three filters; authors still test under them |

**Classic caveat:** option availability differs by client flavor. Always verify on TBC Anniversary; treat retail writeups as **expectation pressure**, not a guarantee every CVar exists.

### 1.3 UI scale

Players commonly scale the entire UI for readability (laptop / ultrawide / “CRT nostalgia” setups appear in community UI threads). Addon frames that ignore parent scale, clamp poorly, or assume 1920×1080 absolute pixel layouts break first.

**Norm for social frames:** respect UI scale, clamp to screen, remember position; don’t hardcode font sizes that become unreadable at 0.7 scale or absurd at 1.4.

---

## 2. Density philosophy in Classic communities (2024–2026)

### 2.1 “Clean UI” is a dominant aesthetic signal

Observable across Classic-facing channels (YouTube clean-UI guides, Wago UI packs marketed as “Simple and Clean,” Reddit r/WowUI / r/wowhardcore / r/classicwow):

| Trend | What players praise | What they reject |
|-------|---------------------|------------------|
| Minimal chrome | Fewer bars, less art clutter, more world visibility | ElvUI “dashboard” overload for casual/HC play |
| Default-UI pride | Hot takes that default UI beats multi-addon stacks ([r/classicwow discussion](https://www.reddit.com/r/classicwow/comments/1hbv7lq/hot_take_default_ui_looks_better_than_90_of_your/)) | Skinning that erases Classic identity |
| Information with purpose | Dense **combat** HUD only if every element earns its place ([2026 UI guide tone](https://medium.com/@debonikawow/best-ui-for-wow-complete-guide-for-a-perfect-interface-in-2026-7c03bc12dce7)) | Decorative widgets with no job |
| Hardcore minimalism | Clean setups framed as survival advantage ([r/wowhardcore](https://www.reddit.com/r/wowhardcore/comments/1rd6o45/a_clean_ui_can_make_a_difference/)) | Center-screen aura walls |

**Sentiment confidence:** high for the *direction* (clean > clutter); individual Reddit/YouTube items are opinion samples, not surveys.

### 2.2 Social addons ≠ combat meters on density

Community expectation split (synthesized; see also deep-research draft in `.raw/`):

| Surface | Expected density |
|---------|------------------|
| Details! / meters / WA boss auras | High, tunable, often center-lower |
| Guild / RP / streamer tools | **Low default**, edge placement, progressive disclosure |

Church of Beef is explicitly **not** a raid-optimization tool (design spec §1). Matching clean-UI culture means the ladder should feel like a **roster / ceremony book**, not a DPS frame.

### 2.3 Progressive disclosure pattern

Winning pattern borrowed from aura-pack backlash: show a compact status by default; expand details on click / slash / officer mode. Ceremony spectacle can be brief toasts — then clear — rather than persistent center overlays (aligns with deferred “ceremonial dashboard theater” in the design spec).

---

## 3. Color & brand accessibility for Church of Beef

Brand wants gothic / Scarlet / steak pageantry — still must pass colorblind checks:

| Do | Don’t |
|----|-------|
| Pair color with **icon, title text, or rank order number** | Encode Fresh→Prophet as a pure green→red gradient |
| Test standing/suggestion states under all three filters | Rely on “holy gold” vs “blood red” alone for approve/reject |
| Keep toast text self-explanatory without hue | Flash full-screen tints for promotions by default |
| Offer a “quiet / streamer” visual mode later | Force high-saturation overlays during combat |

---

## 4. Scale & layout checklist (Classic social UI)

1. `/beef` works even if the minimap button is hidden (collectors / clean-UI users).
2. Frame scales with UIParent; fonts remain legible at common scale extremes.
3. Ladder fits a “one job” panel: ranks + standing + officer actions — not a full dashboard in V1.
4. Toasts: short, edge or upper-center, auto-dismiss; never cover action bars by default.
5. Respect combat: no mandatory modal that steals clicks mid-pull.

---

## 5. What “clean UI” means for packaging screenshots

Storefront screenshots should sell the same story players want in-game:

- World visible; ladder panel on an edge
- One clear headline moment (suggestion / officer approve)
- No WeakAura-style icon carpet in the shot
- Brand readable at thumbnail size (logo + title)

This is both an accessibility/density win and a CurseForge discovery win ([screenshot guidance](https://support.curseforge.com/support/solutions/articles/9000199552-project-submission-guide-and-tips)).
