# Track: UI Scale, Pixel Perfection & Resolution

**Track id:** `43-ui-scale-pixel-perfection`  
**Last updated:** 2026-07-25  
**Lane:** Independent research (coordinate space / scale / high-DPI Classic)  
**Maps to:** [Church of Beef V1 design spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §10 (movable frames, toasts), §13.11 (spectacle), related [17-stream-overlay-readability](../17-stream-overlay-readability/)

## Scope

How WoW’s **768-tall virtual UI**, **UI scale CVars**, **GetScreenWidth/Height vs GetPhysicalScreenSize**, and community **pixel-perfect** tooling affect Church of Beef layout — especially **toasts** and the **`/beef` frame** on Classic Anniversary at 1080p through 4K / ultrawide.

## Out of scope (deliberate)

| Covered elsewhere | Why not here |
|-------------------|--------------|
| [17-stream-overlay-readability](../17-stream-overlay-readability/) | Capture safe zones, contrast, toast *duration*, type ramp for *viewers* |
| [02-visual-language](../02-visual-language/) | Classic chrome / ElvUI coexistence aesthetics |
| [29-taint-secure-ui](../29-taint-secure-ui/) | Combat lockdown on scale changes (only noted as a footgun here) |
| Addon implementation / Lua | Spec + plan only; this track is research |

## Index

| Note | Topic |
|------|--------|
| [virtual-coords-and-scale.md](virtual-coords-and-scale.md) | 768-tall model, Classic vs Retail default scales, `uiScale` floor 0.64 |
| [getscreenwidth-quirks.md](getscreenwidth-quirks.md) | Why `GetScreenWidth` ≠ Video Options resolution |
| [pixel-perfect-libs.md](pixel-perfect-libs.md) | `768/height`, ElvUI PixelPerfect, PixelPerfectUIScale, PixelUtil, own-parent pattern |
| [4k-ultrawide-classic.md](4k-ultrawide-classic.md) | 1440p/4K/21:9 realities; OS DPI; ultrawide parent narrowing |
| [toast-sizing.md](toast-sizing.md) | Toast layout in virtual units under variable player scale |
| [beef-guidance.md](beef-guidance.md) | **Implications for Beef V1** |
| [annotated-references.md](annotated-references.md) | Curated annotated URLs |

## Provenance

Search/extract JSON under [`.raw/`](.raw/). Prefer Warcraft Wiki / Wowpedia UI scaling pages, WoWInterface pixel-perfect threads, ElvUI `PixelPerfect.lua`, and Blizzard UI-macro forum posts over “best UI pack” blogs.

## Quick verdict for Beef

**Do not ship a global UI-scale enforcer.** Parent frames to `UIParent`, **clamp + save position**, size toasts in **virtual units** that stay readable when Classic’s default scale sits near **0.90** at 1440p (or when a raider runs ElvUI / PixelPerfect at `768/height`). Never key layout or “which profile” off `GetScreenWidth()` alone — use **`GetPhysicalScreenSize()`** for real pixels. Treat **4K / ultrawide** as “player scale + aspect width change,” not as a reason to invent Beef-specific pixel-snapping.