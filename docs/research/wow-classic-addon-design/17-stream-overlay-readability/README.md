# Track: Stream Overlay & Content-Creator Readability

**Track id:** `17-stream-overlay-readability`  
**Last updated:** 2026-07-25  
**Lane:** Independent research (stream / capture / creator readability)  
**Maps to:** [Church of Beef V1 design spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §§1, 10, 13.11, 14 (V2 stream contrast pass)

## Scope

How Church of Beef **toasts**, **guild-chat announces**, and later **spectacle** read when the game is captured and watched on Twitch / YouTube at **720p and 1080p** — including safe zones, contrast against live footage, duration, and typography scale for Classic streamers.

## Out of scope (deliberate)

| Covered elsewhere | Why not here |
|-------------------|--------------|
| [01-ux-patterns/weakauras-overlays.md](../01-ux-patterns/weakauras-overlays.md) | In-game WA combat HUD patterns; only “brief then clear” is shared |
| [01-ux-patterns/chat.md](../01-ux-patterns/chat.md) | Chat-addon norms & BeefNet channel choice; not capture readability |
| Combat alert / DBM HUD design | [08-combat-hud-alerts](../08-combat-hud-alerts/) when filled |
| Addon implementation / Lua | Spec + plan only; this track is research |

This track goes deeper on **viewer-facing capture** (safe zones, encode scale, mobile Twitch, text-over-footage) — not on Classic UX surface inventory.

## Index

| Note | Topic |
|------|--------|
| [capture-safe-zones.md](capture-safe-zones.md) | 720p/1080p canvas, title/action safe, OBS/Twitch corners |
| [contrast-on-game-footage.md](contrast-on-game-footage.md) | WCAG-style contrast over busy Classic footage |
| [duration-and-attention.md](duration-and-attention.md) | Toast / announce dwell times for stream audiences |
| [typography-scale.md](typography-scale.md) | Font size / weight guidance at 720p vs 1080p |
| [beef-v1-spectacle-budget.md](beef-v1-spectacle-budget.md) | **Implications for Beef V1** spectacle budget |
| [annotated-references.md](annotated-references.md) | Curated annotated URLs |

## Provenance

Search JSON under [`.raw/`](.raw/). Prefer broadcast-safe-area standards, WCAG contrast docs, Material snackbar timing, and stream-layout practice over overlay-shop marketing copy.

## Quick verdict for Beef

V1 spectacle is **one throttled guild-chat line + short high-contrast toasts** — not overlay chrome. Design toasts for the **worst common watch path** (720p Twitch player / mobile), keep critical text inside **title-safe (~80%)**, put opaque/scrimmed panels under text, and leave the center fovea to the game (and to the streamer’s own OBS overlays).
