# Readable overlays & colorblind-safe usage

**Last updated:** 2026-07-25  
**Purpose:** Contrast and dual-encoding rules for Beef toasts, ladder highlight, and any world-overlapping UI — color layer only.  
**Sibling:** Timing/safe-zones/stream capture live in [17-stream-overlay-readability](../17-stream-overlay-readability/); this track owns **color/contrast/CVD**.

---

## 1. Contrast targets (treat as product law)

From WCAG guidance summarized by [MDN — Color contrast](https://developer.mozilla.org/en-US/docs/Web/Accessibility/Guides/Understanding_WCAG/Perceivable/Color_contrast):

| Content | Minimum (AA) | Prefer for stream (AAA-ish) |
|---------|--------------|-----------------------------|
| Body / toast copy | **4.5:1** | 7:1 |
| Large titles (≥18pt / bold large) | **3:1** | 4.5:1 |
| Icons / non-text controls | **3:1** vs adjacent | 3:1+ |

Game UI is not a website, but stream capture + living-room TVs behave like low-end displays — AA is the floor ([toast a11y notes — contrast + icons](https://studyaround.blog/toast-notification-design-guide)).

### Recommended Beef pairs (check with a contrast tool before lock)

| Foreground | Background | Intent |
|------------|------------|--------|
| `cob.brand.parchment` `#E8DCC4` | `cob.brand.iron` `#2C2420` | Default toast / panel body |
| `cob.brand.cream` `#F5F0E6` | `cob.brand.scarlet` `#9B1B2E` | Ceremony banner title |
| `cob.brand.ink` `#1A1410` | `cob.brand.parchment` `#E8DCC4` | Light-mode option / tooltip |
| `cob.brand.gold` `#D4AF37` | `cob.brand.iron` `#2C2420` | Titles — verify ≥3:1; thicken stroke if needed |

**Reject:** translucent mid-gray text on game world; yellow Rogue-class names on parchment without outline; gold on parchment (low contrast).

---

## 2. Overlay / toast color recipe

Text over busy backgrounds fails when contrast collapses ([WCAG.com — text over images](https://www.wcag.com/blog/content-over-images-how-does-this-ux-ui-trend-impact-accessibility)). Pattern:

1. **Opaque or near-opaque scrim** — `cob.overlay.scrim` ≈ `cob.brand.iron` at α ≥ 0.92 (prefer 1.0 for V1).
2. **Single accent edge** — 2–3px `cob.brand.gold.dim` or scarlet top rule (heraldry, not neon glow).
3. **Title** — cream/gold; **body** — parchment; **state word** — semantic token + icon.
4. **No stacked translucent toasts** — one toast (spec / implications synthesis); color spam reads as WeakAuras.

### Overlay tokens (proposed)

| Token | Value | Role |
|-------|-------|------|
| `cob.overlay.scrim` | `#2C2420` @ 1.0 | Toast / modal fill |
| `cob.overlay.scrim.soft` | `#1A1410` @ 0.85 | Only if forced over video; prefer opaque |
| `cob.overlay.outline` | `#0A0806` | 1px text shadow / outline for title |
| `cob.overlay.flash.holy` | `#F0E6A8` @ 0.15 | 200–400ms Prophet flash — then settle |

Guild-chat announce remains the highest-reach “overlay” and should stay **uncolored or lightly colored** so non-addon members and chat addons do not garble `|c` codes.

---

## 3. Colorblind & accessibility model

### 3.1 What Blizzard already teaches players

Patch 6.1 Accessibility ([Blizzard blog](http://worldofwarcraft.blizzard.com/en-us/news/17964863/new-colorblind-support-in-patch-61); [Blizzard Watch summary](https://blizzardwatch.com/2015/02/17/patch-6-1-adds-new-colorblind-support-ui)):

- **UI Colorblind Mode** — adds words (“Rare”, “Epic”, friendly/hostile hints) where color alone carried meaning.
- **Filters** — protanopia, deuteranopia, tritanopia + strength slider.

Beef should behave like a good citizen of that model: **labels first, color second**.

### 3.2 Dual-encoding checklist (every stateful UI)

| State | Color token | Required non-color |
|-------|-------------|--------------------|
| Pending suggestion | `cob.state.pending` | “Pending” + hourglass/pip |
| Approved / recognized | `cob.state.approved` | “Recognized” + check |
| Rejected | `cob.state.rejected` | “Rejected” + X |
| Demoted | `cob.state.demoted` | “Excommunicated” / “Demoted” + seal icon |
| Self on ladder | gold underline | “You” / row marker |
| Officer-only | scarlet pip | Tab hidden for non-officers (structure > color) |

Never: green row vs red row with no text.

### 3.3 Palette strategy under CVD

Practical rules from [Datawrapper — visualizing for colorblind readers](https://www.datawrapper.de/blog/colorblindness-part2) and [Visme — color blind friendly palettes](https://visme.co/blog/color-blind-friendly-palette):

- Prefer **blue/orange/amber** separations for categories; Beef’s gold/amber pending fits.
- Vary **lightness** between scarlet, gold, parchment, ash.
- Avoid pure red/green approve-reject; Beef uses **teal approve + dusty rose reject**.
- Keep categorical count small (brand + 4 states + ranks) — fewer colors, clearer.
- Test with simulators **and** in-game filters; simulators are approximate ([Datawrapper](https://www.datawrapper.de/blog/colorblindness-part2)).

IBM-style CVD-safe categorical reference (blue / violet / magenta / orange / gold) ([color-hex IBM listing](https://www.color-hex.com/color-palette/1044488); [Carbon data viz palettes](https://carbondesignsystem.com/data-visualization/color-palettes)) — steal the *strategy*, not the corporate blues, for any future charts (standing breakdown).

---

## 4. System color + brand color coexistence

| Surface | System color OK? | Brand color |
|---------|------------------|-------------|
| Ladder occupant name | Class tint | Rank title uses `cob.rank.*` |
| Toast “Recognized” | — | Semantic + brand scrim |
| Ceremony flash | Optional quality tint once | Settle on brand gold/scarlet |
| Faction footer | `GetFactionColor` | Never replace panel brand |
| Progress to next rank | — | `cob.flavor.beef` fill on iron track |
| Error / Soft warning | — | `cob.state.rejected` or ash + text — not Hostile neon |

---

## 5. Streamer-specific color notes

- **720p / compressed Twitch:** thin gold hairlines disappear; prefer ≥2px accent bars and cream titles ([sibling track 17](../17-stream-overlay-readability/) for size/duration).
- **Webcam + game + UI:** keep Beef toast away from face cam; color must still read on dim iron if OBS darkens the game capture.
- **Colorblind streamer or viewer:** announce line in guild chat carries the event if toast hues fail.

---

## 6. Validation pass (no code — checklist)

Before locking tokens into `Data/` later:

1. Screenshot ladder + toast on parchment/iron pairs; run WebAIM-style contrast check ([WebAIM contrast checker](https://webaim.org/resources/contrastchecker/) linked from WCAG.com guidance).
2. Toggle client colorblind filters; confirm states still distinguishable by label/icon.
3. Greyscale the screenshot mentally (or filter): rank order and pending/approved should still differ by lightness/position.
4. Confirm Scarlet panel does not read as “I’m flagged hostile.”
5. Confirm Alliance and Horde guild screenshots use the **same** brand tokens.
