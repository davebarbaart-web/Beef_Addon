# Color Contrast on Game Footage

**Track:** [17-stream-overlay-readability](README.md)

---

## Why game footage breaks “normal” UI contrast

Church of Beef toasts sit on **live, high-variance pixels**: dungeon lighting, raid wipes, outdoor noon, fog, particle spam, ElvUI black bars, bright nameplates. A text color that passes contrast against a solid panel can fail the moment the toast is transparent over Outland green or a fire effect.

WCAG treats this explicitly: measuring contrast against an **unspecified or busy background image** is a known failure mode ([W3C Understanding SC 1.4.3](https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum.html); failure technique [F83](https://www.w3.org/TR/UNDERSTANDING-WCAG20/visual-audio-contrast-contrast.html) — background images that don’t provide sufficient contrast).

Streaming guides make the same point without citing WCAG: chat text needs strong contrast against changing gameplay; use a **semi-transparent dark panel**, not pure float-on-video ([Position Is Everything — chat overlay](https://www.positioniseverything.net/how-to-add-twitch-chat-overlay-in-obs-full-guide/)).

---

## Target ratios (borrow WCAG language)

WoW addons are not websites, but WCAG numbers are the best shared yardstick for “can a remote viewer read this?”:

| Content | Minimum (AA) | Enhanced (AAA) | Source |
|---------|--------------|----------------|--------|
| Body / secondary toast line | **4.5:1** | 7:1 | [MDN Color contrast](https://developer.mozilla.org/en-US/docs/Web/Accessibility/Guides/Understanding_WCAG/Perceivable/Color_contrast); [WCAG 1.4.3](https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum.html) |
| Large title text (≥ ~18pt / 24px CSS equivalent, or 14pt bold) | **3:1** | 4.5:1 | Same |
| Icons / non-text UI bits | **3:1** | — | WCAG 1.4.11 (via MDN table) |

For **text over images / video**, practitioners recommend: verify contrast, add a **scrim / overlay**, prefer simple backgrounds behind the glyphs, use large legible fonts ([WCAG.com — Text over images](https://www.wcag.com/blog/content-over-images-how-does-this-ux-ui-trend-impact-accessibility)).

**Beef default stance:** measure contrast of toast **text against the toast panel fill**, not against the game world. The panel is the guaranteed background.

---

## Practical toast recipes for Classic capture

| Approach | Stream readability | Notes |
|----------|-------------------|-------|
| Near-white text on **opaque or ≥85% opaque dark** panel | Strong | Best default for V1 plain frames |
| Light text + soft black drop shadow / outline, no panel | Fragile | Fails on bright snow / holy effects; outline helps but encode blur eats thin strokes |
| Brand gold/crimson text on transparent | Weak | Brand accent as **border or icon**, not as sole body color |
| Color-only success/error (green vs red, no icon/label) | Fail | Colorblind + compressed streams; pair icon + words ([StudyAround toast a11y notes](https://studyaround.blog/toast-notification-design-guide)) |

Chat-overlay practice useful for Beef announces in OBS: **60–85% transparent dark** behind messages; avoid pure black blocks that punch a hole in the aesthetic ([Position Is Everything](https://www.positioniseverything.net/how-to-add-twitch-chat-overlay-in-obs-full-guide/)). For **in-game** toasts, prefer higher opacity than OBS chat — viewers cannot “hover” the game UI.

Encode/compression note: heavy x264 low-bitrate streams smear thin fonts and low-contrast edges. High-contrast panels survive 720p@3–4 Mbps better than delicate gothic thin strokes (V2 chrome risk).

---

## Guild-chat announce contrast

Plain guild chat is the V1 spectacle channel ([spec §10](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)). Contrast then depends on:

1. Default Blizzard chat colors / player Prat settings ([01 chat note](../01-ux-patterns/chat.md))
2. Streamer’s OBS chat widget theme
3. Whether the announce is visible **without** the addon (yes — by design)

**Do not** rely on `|cAARRGGBB` color spam or weird escape sequences for the promotion line. Keep one plain, punchy sentence so Prat/ElvUI/OBS all render something readable.

---

## Relevance to Church of Beef

- V1: plain Classic frames + dark toast plate + light text is enough; theatrical Scarlet chrome is V2 ([spec §14](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) “stream contrast pass”).
- Rank titles in toasts (“Beef Knight”) should be the high-contrast hero string; scripture footers can be dimmer secondary.
- Never put spectacle-critical meaning in a transparent gold serif over open world footage.

## Sources

- [W3C — Understanding SC 1.4.3 Contrast (Minimum)](https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum.html)
- [MDN — Color contrast](https://developer.mozilla.org/en-US/docs/Web/Accessibility/Guides/Understanding_WCAG/Perceivable/Color_contrast)
- [WCAG.com — Text over images](https://www.wcag.com/blog/content-over-images-how-does-this-ux-ui-trend-impact-accessibility) (2025)
- [Position Is Everything — Twitch chat overlay readability](https://www.positioniseverything.net/how-to-add-twitch-chat-overlay-in-obs-full-guide/)
- [StudyAround — Toast notification design](https://studyaround.blog/toast-notification-design-guide)
