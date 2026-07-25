# Annotated References — Stream Overlay Readability

**Track:** [17-stream-overlay-readability](README.md)  
**Last updated:** 2026-07-25  

Steal / adapt notes are for **Church of Beef design**, not for copying overlay shop assets.

---

## Capture, canvas, safe zones

| URL | Annotation |
|-----|------------|
| [https://ryanmarkel.com/7884/title-safe/](https://ryanmarkel.com/7884/title-safe/) | **Core.** Twitch/YouTube overscan; Xbox-derived **80% title / 90% action** safe; why stream chrome at frame edges disappears on TVs/consoles. Steal: keep Beef must-read UI inside 80%. |
| [https://www.tella.com/definition/safe-margins](https://www.tella.com/definition/safe-margins) | Premiere-style action (~5% inset) / title (~10% inset) definitions. Steal: language for docs; same geometry as 90%/80% boxes. |
| [https://www.premiumbeat.com/blog/default-title-safe-guides-are-a-sham/](https://www.premiumbeat.com/blog/default-title-safe-guides-are-a-sham/) | SMPTE ST 2046-1 HD tightening (**90% title / 93% action**). Adapt: know modern broadcast is looser; still prefer stricter 80% for mobile + game streams. |
| [https://eks.tv/title-safe-still-matters/](https://eks.tv/title-safe-still-matters/) | Argues title safe still matters for online video / mobile. Steal: don’t use HD-loose margins for phone viewers. |
| [https://helpcenter.xr.global/hc/en-us/articles/23817307323028-Safe-Title-Area](https://helpcenter.xr.global/hc/en-us/articles/23817307323028-Safe-Title-Area) | SMPTE history RP 8 / ST 2046-1. Reference only. |
| [https://getrektlabs.com/blogs/news/twitch-overlay-size-guide-for-1080p-4k-streaming-2025](https://getrektlabs.com/blogs/news/twitch-overlay-size-guide-for-1080p-4k-streaming-2025) | 1080p/4K overlay & alert canvas sizes (marketing tone). Steal: **1920×1080** as authoring default; alert asset size ranges. |
| [https://tacticalliondesigns.com/twitch-graphic-sizes](https://tacticalliondesigns.com/twitch-graphic-sizes) | Overlay canvas, leave HUD space, avoid excessive motion, test small screens. Steal: game-first layout; motion discipline for toasts. |
| [https://5856.tw/stream-overlay-configurator](https://5856.tw/stream-overlay-configurator) | Game area 70–80%; webcam corners ~15–20% width; mentions inner ~90% safe zone. Steal: coexistence with streamer OBS kit. |
| [https://obsproject.com/forum/threads/safe-margins-and-rulers-simulation-included.79621](https://obsproject.com/forum/threads/safe-margins-and-rulers-simulation-included.79621) | OBS Multiview safe margins exist / requested. Steal: validation workflow for streamers testing Beef. |
| [https://oakwaygraphics.com/free-stream-overlay-generator](https://oakwaygraphics.com/free-stream-overlay-generator) | Tool with explicit safe-margin preview (64 px default). Lightweight confirmation that creators expect margin guides. |

## Contrast & accessibility

| URL | Annotation |
|-----|------------|
| [https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum.html](https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum.html) | **Primary.** 4.5:1 body / 3:1 large text. Steal: toast panel contrast targets. |
| [https://developer.mozilla.org/en-US/docs/Web/Accessibility/Guides/Understanding_WCAG/Perceivable/Color_contrast](https://developer.mozilla.org/en-US/docs/Web/Accessibility/Guides/Understanding_WCAG/Perceivable/Color_contrast) | Compact ratio table + AAA. |
| [https://www.wcag.com/blog/content-over-images-how-does-this-ux-ui-trend-impact-accessibility](https://www.wcag.com/blog/content-over-images-how-does-this-ux-ui-trend-impact-accessibility) | Text-over-image failures; scrims; large fonts. Steal: **opaque/scrim panel under Beef text**. |
| [https://www.positioniseverything.net/how-to-add-twitch-chat-overlay-in-obs-full-guide/](https://www.positioniseverything.net/how-to-add-twitch-chat-overlay-in-obs-full-guide/) | Chat contrast, 60–85% dark transparency, 720p readability, placement vs HUD. Steal: same physics for toast panels + OBS chat of guild announces. |
| [https://www.techbloat.com/how-to-add-twitch-chat-overlay-in-obs-full-guide.html](https://www.techbloat.com/how-to-add-twitch-chat-overlay-in-obs-full-guide.html) | **18–28 px** chat text @ 1080p. Steal: lower bound for stream-facing type scale. |

## Duration & toast UX

| URL | Annotation |
|-----|------------|
| [https://blog.logrocket.com/ux-design/toast-notifications](https://blog.logrocket.com/ux-design/toast-notifications) | 3–8 s attention band; corner placement; don’t use toasts for critical/long content. Steal: promote toast upper band; chat for durability. |
| [https://studyaround.blog/toast-notification-design-guide](https://studyaround.blog/toast-notification-design-guide) | 3s / 6s / indefinite by severity; 4.5:1; icon+text. Steal: severity→duration mapping. |
| [https://uxdesign.cc/toasts-or-snack-bars-design-organic-system-notifications-1236f2883023](https://uxdesign.cc/toasts-or-snack-bars-design-organic-system-notifications-1236f2883023) | 2–7 s band; ~100 ms/char heuristic. Steal: copy length budget. |
| [https://m1.material.io/components/snackbars-toasts.html](https://m1.material.io/components/snackbars-toasts.html) | One snackbar at a time; short feedback. Steal: **no toast stacks**. |
| [https://stackoverflow.com/questions/56598610/what-is-the-actual-duration-of-a-snackbar-with-length-long](https://stackoverflow.com/questions/56598610/what-is-the-actual-duration-of-a-snackbar-with-length-long) | Material SHORT/LONG ≈ **1500 / 2750 ms**. Steal: proof phone snackbars are *too short* for stream spectacle — Beef should exceed these. |
| [https://stackoverflow.com/questions/7965135/what-is-the-duration-of-a-toast-length-long-and-length-short/7965192](https://stackoverflow.com/questions/7965135/what-is-the-duration-of-a-toast-length-long-and-length-short/7965192) | Android Toast delay lore (~2 s / ~3.5 s). Context only. |

## YouTube / Shorts safe areas (secondary)

| URL | Annotation |
|-----|------------|
| [https://clickyapps.com/creator/thumbnails/guides/thumbnail-safe-text-areas](https://clickyapps.com/creator/thumbnails/guides/thumbnail-safe-text-areas) | Thumbnail/mobile margins; contrast ≥4.5:1. Relevant if V2 clips ceremonies. |
| [https://kreatli.com/guides/youtube-shorts-safe-zone](https://kreatli.com/guides/youtube-shorts-safe-zone) | Shorts UI eats edges; center text. V2 clip theater only. |

## WoW-adjacent (light touch; UX track owns depth)

| URL | Annotation |
|-----|------------|
| [https://www.curseforge.com/wow/addons/ls-toasts](https://www.curseforge.com/wow/addons/ls-toasts) | Ecosystem toast replacement pattern (positionable alerts). Steal: movable toasts; not combat dependency. |
| [https://www.curseforge.com/wow/addons/toastalerts](https://www.curseforge.com/wow/addons/toastalerts) | X/Y offsets to match UI — confirms streamers/players relocate toast stacks. |
| Design spec §10 / §13.11 | Canonical V1 announce + social success check. |

## Spec & library cross-links

| URL / path | Annotation |
|------------|------------|
| [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) | Product truth for toasts, guild announces, deferred V2 contrast pass. |
| [`../00-church-of-beef-implications.md`](../00-church-of-beef-implications.md) | Synthesis: chat as spectacle budget; edge social tool. |
| [`../01-ux-patterns/chat.md`](../01-ux-patterns/chat.md) | In-game chat norms (do not duplicate here). |
| [`../01-ux-patterns/weakauras-overlays.md`](../01-ux-patterns/weakauras-overlays.md) | Brief/high-contrast overlay manners only. |

---

## Raw search dumps

| File | Query theme |
|------|-------------|
| [`.raw/search-safe-zones.json`](.raw/search-safe-zones.json) | Overlay sizes, title safe, Twitch/YouTube |
| [`.raw/search-contrast-typography.json`](.raw/search-contrast-typography.json) | WCAG, toasts, contrast |
| [`.raw/search-wow-stream-ui.json`](.raw/search-wow-stream-ui.json) | WoW toast addons / streamer UI |
| [`.raw/search-obs-title-safe.json`](.raw/search-obs-title-safe.json) | OBS margins, chat overlays |
| [`.raw/search-toast-duration.json`](.raw/search-toast-duration.json) | Toast/snackbar duration |
| [`.raw/search-title-safe-pct.json`](.raw/search-title-safe-pct.json) | 80/90 vs SMPTE 90/93 |
| [`.raw/search-material-snackbar.json`](.raw/search-material-snackbar.json) | Material snackbar |
| [`.raw/search-snackbar-ms.json`](.raw/search-snackbar-ms.json) | SHORT/LONG milliseconds |
