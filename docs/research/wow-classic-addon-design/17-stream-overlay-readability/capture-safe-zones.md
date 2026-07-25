# Capture Safe Zones (720p / 1080p)

**Track:** [17-stream-overlay-readability](README.md)  
**Audience:** Twitch / YouTube Classic streamers watching Church of Beef moments on capture

---

## Canvas reality

| Output | Pixels (16:9) | Stream practice |
|--------|---------------|-----------------|
| 720p | 1280 × 720 | Still common for bandwidth / dual-PC / older GPU; Twitch player often *displays* smaller than native capture |
| 1080p | 1920 × 1080 | Dominant canvas for modern overlay packs; design assets usually authored here ([GETREKT overlay size guide](https://getrektlabs.com/blogs/news/twitch-overlay-size-guide-for-1080p-4k-streaming-2025); [TacticalLion Twitch graphic sizes](https://tacticalliondesigns.com/twitch-graphic-sizes)) |

**Rule for Beef:** author visual specs against **1080p**, but **validate readability after a downscale to 720p** (and a phone-width Twitch player). Text that “looks fine” on a 1440p monitor in-game can fail once encoded and paneled.

Overlay packs and OBS scenes almost always assume a **1920 × 1080 base canvas** matching output ([TacticalLion](https://tacticalliondesigns.com/twitch-graphic-sizes)). Blurry overlays are usually canvas/output mismatch, not “bad PNG.”

---

## Title safe vs action safe

Broadcast / console heritage still maps cleanly onto streaming:

| Zone | Traditional share of frame | Meaning for stream UI |
|------|----------------------------|------------------------|
| **Action safe** | ~**90%** of width × height | Outer bound — do not put *anything* required outside this |
| **Title safe** | ~**80%** of width × height | Inner bound — **must-read** text, names, rank titles live here |

Xbox-era cert language (quoted via [Ryan Markel — Title Safe](https://ryanmarkel.com/7884/title-safe/)): keep UI within **80%** (recommended) and never outside **90%** (hard fail for console). For Twitch/YouTube creators, Markel’s practical rule: **alerts, tickers, and must-see labels stay inside the 80% title-safe box**; YouTube/device viewers are *more* overscan-prone than desktop browser viewers.

HD broadcast later tightened margins (SMPTE ST 2046-1: ~**90% title / 93% action**) ([PremiumBeat on title safe](https://www.premiumbeat.com/blog/default-title-safe-guides-are-a-sham/); [Extreme Reach — Safe Title Area](https://helpcenter.xr.global/hc/en-us/articles/23817307323028-Safe-Title-Area)). For **gaming streams + mobile**, the **stricter 80%/90%** guides remain the safer default ([eks.tv — Title Safe Still Matters](https://eks.tv/title-safe-still-matters/)).

Premiere-style “safe margins” language matches the same idea: action safe ≈ 5% inset each edge; title safe ≈ 10% inset ([Tella / Premiere safe margins glossary](https://www.tella.com/definition/safe-margins)).

**OBS:** Multiview can show safe-margin guides; creators also drop a transparent safe-area PNG into the scene while laying out ([OBS Forums — Safe Margins](https://obsproject.com/forum/threads/safe-margins-and-rulers-simulation-included.79621); Markel’s template approach).

---

## Capture “danger corners” for Classic + streamers

Even when pixels are fully visible, **platform UI and streamer layout** steal edges:

| Region | Typical collision | Beef implication |
|--------|-------------------|------------------|
| Bottom-right | Webcam, alert box, StreamElements/Streamlabs alerts | Prefer *not* defaulting Beef toasts here if the streamer’s kit already owns it |
| Bottom-left | Chat overlay, Twitch extension chrome | Guild-chat lines already live in chat; don’t stack a second chat-like panel |
| Top-right | Minimap / buffs / addon buttons (Classic) | Toasts near minimap compete with LibDBIcon clutter |
| Top-left | Quest tracker / party frames | Busy on dungeon nights |
| Center / center-lower | Character, WA packs, DBM bars | **Forbidden for Beef spectacle** — social tool, not combat HUD ([01 UX mental model](../01-ux-patterns/README.md)) |
| Far edges (outside 90%) | Overscan + mobile letterboxing | Never put rank titles here |

Layout practice from stream tools: keep **70–80% of the frame as game**, webcam ~15–20% width in a corner, chat on an unused edge ([5856.tw overlay configurator tips](https://5856.tw/stream-overlay-configurator); [Position Is Everything — chat overlay guide](https://www.positioniseverything.net/how-to-add-twitch-chat-overlay-in-obs-full-guide/)).

**Thumbnail / Shorts note (YouTube-adjacent):** if ceremony clips are cut for Shorts, UI chrome at the bottom is eaten by titles/buttons — keep hooks in a centered safe band ([ClickyApps safe text areas](https://clickyapps.com/creator/thumbnails/guides/thumbnail-safe-text-areas); [Kreatli Shorts safe zone](https://kreatli.com/guides/youtube-shorts-safe-zone)). V1 does not depend on Shorts; V2 clip theater might.

---

## Pixel budgets (approximate)

Assuming 1080p canvas, title-safe ≈ 80% → usable ~**1536 × 864**. Outer 10% per side on 1080p ≈ **96 px** margin; on 720p ≈ **64 px**.

| Resolution | Outer margin (≈10% / side) | Prefer toast inset ≥ |
|------------|----------------------------|----------------------|
| 1920×1080 | ~96 px | 100–120 px from edges |
| 1280×720 | ~64 px | 70–90 px from edges |

Streamer OBS overlays often add *another* inset (webcam frame, chat column). Beef defaults should leave room so a typical facecam + alert stack does not cover the toast.

---

## Relevance to Church of Beef

- Movable, clamped frames ([spec §10](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) are correct — streamers will relocate toasts away from their webcam.
- Default toast anchor: **upper-center or upper-middle-right inside title-safe**, *not* dead center and not glued to the absolute corner.
- Guild-chat announces ignore safe zones (they live in chat UI / OBS chat browser sources) — that is a feature: they remain readable when the game HUD is cropped or busy.

## Sources

- [Ryan Markel — Title Safe](https://ryanmarkel.com/7884/title-safe/) (2014)
- [GETREKT — Twitch Overlay Size Guide](https://getrektlabs.com/blogs/news/twitch-overlay-size-guide-for-1080p-4k-streaming-2025) (2025)
- [TacticalLion — Twitch Overlay Size Guide](https://tacticalliondesigns.com/twitch-graphic-sizes) (2026)
- [Tella — Safe Margins (Premiere)](https://www.tella.com/definition/safe-margins)
- [PremiumBeat — Title Safe Guides](https://www.premiumbeat.com/blog/default-title-safe-guides-are-a-sham/)
- [eks.tv — Title Safe Still Matters](https://eks.tv/title-safe-still-matters/)
- [Extreme Reach — Safe Title Area](https://helpcenter.xr.global/hc/en-us/articles/23817307323028-Safe-Title-Area)
- [OBS Forums — Safe Margins](https://obsproject.com/forum/threads/safe-margins-and-rulers-simulation-included.79621)
