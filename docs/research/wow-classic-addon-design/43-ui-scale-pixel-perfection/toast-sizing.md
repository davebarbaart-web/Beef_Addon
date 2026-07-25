# Toast Sizing Under Variable UI Scale

**Track:** [43-ui-scale-pixel-perfection](README.md)  
**Related:** [17 — typography / capture](../17-stream-overlay-readability/typography-scale.md), [17 — safe zones](../17-stream-overlay-readability/capture-safe-zones.md)

---

## Two audiences, one frame

| Audience | Constraint |
|----------|------------|
| **Player** | Toast must read at their UI scale (Classic ~0.9 at 1440p, or pixel-perfect ~0.53, or 4K+modifier) |
| **Stream viewer** | Sees the *encoded* frame; type ramp in track 17 is the floor for spectacle titles |

This note covers **in-client virtual sizing**. Capture readability stays in track 17.

---

## Size in UIParent units, not “pixels”

Parent toasts to `UIParent` (or a full-screen Beef parent with `SetAllPoints`) so they inherit the player’s scale automatically ([Warcraft Wiki — UI scaling](https://warcraft.wiki.gg/wiki/UI_scaling)). Then:

- `SetSize(w, h)` uses **region units**.
- Apparent on-screen size ≈ `h * effectiveScale * physicalHeight / 768`.
- A toast that looks correct at scale 1.0 on 1080p will look **smaller in real mm** on a 27″ 1440p panel running pixel-perfect 0.533 — unless the player’s whole UI is meant to be small (WA culture).

**Design for the Classic default cluster first** (scale off ≈ 0.9–1.0), then spot-check with ElvUI/PixelPerfect at `768/h`. Do not author toasts only under a pixel-perfect profile.

---

## Suggested V1 toast geometry (virtual units)

Guidance targets for a **promote / credit** toast plate (plain Classic frame + dark fill — spec §10):

| Element | Virtual size (starting point) | Notes |
|---------|-------------------------------|--------|
| Panel width | **280–360** | Cap ~40% of `GetScreenWidth()` on 16:9; avoid full ultrawide span |
| Panel height | **64–96** | One title + one name line; drop secondary before growing past ~110 |
| Outer margin from screen edge | ≥ **24–40** | Title-safe overlap with track 17; leave ultrawide corners free |
| Default anchor | **TOP** / upper-center or upper-middle-right | Not dead center (combat fovea); not bottom-right (alerts/webcam) |
| User scale slider (optional V1.1) | `toast:SetScale(db)` relative to parent | Multiply carefully — child scale stacks with UIParent ([SetScale semantics](https://wowwiki-archive.fandom.com/wiki/API_Frame_SetScale)) |

Map fonts to the apparent sizes in [17 typography-scale](../17-stream-overlay-readability/typography-scale.md) (~28–36 px title equivalent @ 1080p). If the only way to hit that under pixel-perfect 4K is a huge panel, prefer **bold GameFont + shorter copy** over a billboard.

---

## Stacking, motion, and scale glitches

- **One toast at a time** (track 17 duration note) — stacking at different effective scales looks like jitter.
- Prefer fade over slide distances that use half-pixel offsets; if borders shimmer, round panel size/point offsets with a local `mult = (768/physH) / UIParent:GetScale()` ([WoWInterface pmult pattern](https://www.wowinterface.com/forums/showthread.php?t=56898)).
- Re-anchor / re-clamp on `DISPLAY_SIZE_CHANGED` and `UI_SCALE_CHANGED` so a monitor hot-plug doesn’t leave the toast off-screen.
- Do not call global scale setters from Beef when showing a toast.

---

## Movable `/beef` frame vs toast

| Surface | Scale policy |
|---------|--------------|
| `/beef` main frame | Movable, clamped, saved point ([spec §10](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)); denser type OK |
| Toasts | Same clamp rules; **do not** require drag for V1 if defaults sit in title-safe; optional saved toast anchor later |
| Minimap button | Follow LibDBIcon / compartment norms (track 28); not pixel-snapped |

---

## Sources

- [Warcraft Wiki — UI scaling](https://warcraft.wiki.gg/wiki/UI_scaling)
- [WoWInterface — Achieving pixel perfection](https://www.wowinterface.com/forums/showthread.php?t=56898)
- [Track 17 — typography-scale](../17-stream-overlay-readability/typography-scale.md)
- [Track 17 — capture-safe-zones](../17-stream-overlay-readability/capture-safe-zones.md)
