# Typography Scale for Twitch / YouTube Classic Streams

**Track:** [17-stream-overlay-readability](README.md)

---

## Scale relative to capture, not the streamer’s monitor

The player may run UI scale 0.9 on a 1440p / 4K display. Viewers see the **encoded frame** — often 720p or a letterboxed 1080p player on a phone. Typography for Beef spectacle must survive that path.

OBS / chat-overlay practice for **on-stream text widgets** (useful as an upper bound for what viewers expect):

| Context | Reported comfortable size | Source |
|---------|---------------------------|--------|
| Chat overlay @ 1080p | **18–28 px** message text | [TechBloat — Twitch chat in OBS](https://www.techbloat.com/how-to-add-twitch-chat-overlay-in-obs-full-guide.html) |
| Chat overlay general | Large enough to read at **720p**; sans-serif; high contrast | [Position Is Everything](https://www.positioniseverything.net/how-to-add-twitch-chat-overlay-in-obs-full-guide/) |
| Alerts (design assets) | Common alert canvases **800×500 – 1280×720** | [GETREKT overlay sizes](https://getrektlabs.com/blogs/news/twitch-overlay-size-guide-for-1080p-4k-streaming-2025) |

WCAG “large text” floor (~**18pt / ~24px**, or 14pt bold) is the *minimum* for relaxed contrast — not a stream hero size ([WCAG 1.4.3](https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum.html); [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/Guides/Understanding_WCAG/Perceivable/Color_contrast)).

---

## Suggested Beef type ramp (1080p game UI → viewer)

Treat these as **design targets** for toast layout (Blizzard font objects won’t use CSS px; map to `GameFont*` / custom sizes that *read* this large on a default UI scale).

| Role | Target apparent size @ 1080p | @ 720p (≈0.67×) | Content |
|------|------------------------------|------------------|---------|
| **Spectacle title** | ~**28–36 px** equivalent, bold | ~19–24 px | Rank title (“Beef Knight”), “Elevated”, “Excommunicated” |
| **Primary line** | ~**20–24 px** | ~14–16 px | Player name |
| **Secondary / credit** | ~**16–18 px** | ~11–12 px | “Ceremony credit”, point crumb — optional |
| **Do not use for spectacle** | &lt;14 px @ 1080p | &lt;10 px | Fine print, lore walls |

If secondary drops below ~14 px apparent at 1080p, **drop the secondary line** rather than shrink everything.

Guild-chat announce: one sentence, **no multi-line paste**, names + title only — chat font size is out of addon control; brevity is the readability tool.

---

## Font character (V1 vs brand)

| Phase | Type choice | Stream reason |
|-------|-------------|----------------|
| **V1** | Default UI fonts / thick sans | Survive encode; media fallback required ([spec §10](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) |
| **V2 art pass** | Display / gothic for titles *with* heavy weight + scrim | Brand pageantry; thin blackletter dies on 720p bitrate |

Streamer chat guides push Inter/Roboto/Arial for *overlay* chat ([TechBloat](https://www.techbloat.com/how-to-add-twitch-chat-overlay-in-obs-full-guide.html)) — take the **legibility** lesson, not the web font stack (WoW cannot load those). Prefer **bold GameFont** families over ornate SharedMedia until a stream contrast pass exists.

---

## Motion vs type

[TacticalLion](https://tacticalliondesigns.com/twitch-graphic-sizes): avoid excessive motion on overlays — constant movement hurts followability. For Beef toasts:

- Short fade/slide in (≤0.3 s)
- Hold (duration table in [duration-and-attention.md](duration-and-attention.md))
- Fade out
- **No** looping glow pulses behind body text during the hold (glow eats contrast under compression)

---

## Relevance to Church of Beef

- Rank **title** is the hero glyph in a promote toast — size it like a lower-third name, not like bag-slot tooltip text.
- `/beef` ladder UI can stay denser (player-facing tool); **toasts and chat lines** are the stream surface and need the larger ramp.
- Test plan: capture OBS at 720p, watch on a phone — if the title isn’t readable without fullscreen, bump size or scrim before shipping defaults.

## Sources

- [TechBloat — Twitch chat overlay font sizes](https://www.techbloat.com/how-to-add-twitch-chat-overlay-in-obs-full-guide.html)
- [Position Is Everything — chat readability](https://www.positioniseverything.net/how-to-add-twitch-chat-overlay-in-obs-full-guide/)
- [GETREKT — overlay / alert dimensions](https://getrektlabs.com/blogs/news/twitch-overlay-size-guide-for-1080p-4k-streaming-2025)
- [TacticalLion — clean overlay tips](https://tacticalliondesigns.com/twitch-graphic-sizes)
- [W3C WCAG 1.4.3](https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum.html)
