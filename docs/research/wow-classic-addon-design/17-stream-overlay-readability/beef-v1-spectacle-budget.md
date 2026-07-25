# Implications: Church of Beef V1 Spectacle Budget

**Track:** [17-stream-overlay-readability](README.md)  
**Spec:** [2026-07-25-church-of-beef-design.md](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §§1, 3.2, 10, 13.11, 14

---

## What “spectacle budget” means here

Not art production hours — the **viewer-facing attention budget** on a guild stream night:

| Channel | Who sees it | Survives without addon? | V1 role |
|---------|-------------|-------------------------|---------|
| Guild-chat promotion / demotion line | Everyone in guild chat + OBS chat overlays | **Yes** | **Primary spectacle** |
| Local toast (suggest / approve / credit) | Addon users + anyone watching that client’s capture | No | Secondary flourish |
| `/beef` ladder frame | Intentional openers | No | System of record, not stream beat |
| V2 ceremonial dashboard / favor bar | Deferred ([§3.2](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) | — | Later |

This matches synthesis already: guild-chat lines *are* the V1 spectacle budget ([00 implications #10](../00-church-of-beef-implications.md)). This track adds **capture constraints** so that budget is spent where viewers can actually read it.

---

## Hard recommendations for V1

### 1. Spend the budget on chat copy, not chrome

One officer-sent, throttled, plain-text line is the cheapest stream-readable moment. Draft for **one glance at 720p**:

- Good: `The Church recognizes Beefina, elevated to Beef Knight.`
- Bad: multi-color escapes, lore paragraphs, point breakdowns in chat

Opt-out must not be the silent default for officers ([§13.11](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)).

### 2. Toasts: few, large, scrimmed, title-safe

| Knob | V1 default |
|------|------------|
| Concurrent toasts | **1** |
| Promote / demote dwell | **6–8 s** |
| Credit dwell | **3.5–5 s** |
| Placement | Inside **~80% title-safe**; avoid center fovea; movable |
| Contrast | Opaque/near-opaque dark panel; light text; icon + words |
| Type | Bold title ~28–36 px-equivalent @ 1080p; drop fine print |

Do not compete with WA/DBM center mass ([01 weakauras note](../01-ux-patterns/weakauras-overlays.md) — shared “brief then clear” only).

### 3. Assume streamer layout ownership of corners

Beef defaults must tolerate webcam (BR), chat (BL), alerts (edges). Clamped + saved position ([§10](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) is the coexistence feature. Document a “streamer preset” later if needed; do not hardcode BR toast.

### 4. Credit spam is anti-spectacle

Gora/ceremony/instance credits feed **local** standing UX. Broadcasting every drip to guild chat or stacking toasts destroys the promote beat. Keep public airtime for **rank commits** (and rare ceremony moments in V2).

### 5. Validate on the worst common path

Acceptance for stream readability (supplement §13):

1. OBS (or equivalent) at **1280×720** output  
2. Promote event while a busy dungeon/raid frame is on screen  
3. Watch on a **phone-width** Twitch/YouTube player  
4. Pass if: guild chat line is obvious **and** toast title readable without scrubbing  

If toast fails but chat passes, V1 still meets §13.11 — fix toast defaults before calling the flourish done.

### 6. Defer theatrical chrome until the “stream contrast pass”

Spec §14 already parks richer spectacle in V2. Research agrees: gothic thin strokes + transparent gold over Outland will fail encode/contrast. Ship plain readable V1; brand the **words** (“Church,” titles, excommunication) before the textures.

---

## Spectacle budget table (V1)

| Moment | Public chat | Toast | Notes |
|--------|-------------|-------|-------|
| Instance / drip credit | No | Optional short | Local only |
| Ceremony / Gora credit | No (V1) | Short | Officers may call out verbally on stream |
| Suggestion created | No | Medium | Officer-facing value; low stream drama |
| Rank approved | **Yes — one line** | Long | Peak V1 moment |
| Rank demoted | **Yes — one line** | Long | On-brand drama; same throttle rules |
| Council / Prophet appoint | **Yes — one line** | Long | Scarce seats = scarce airtime |

---

## Non-goals (guardrails)

- No WeakAuras dependency for spectacle  
- No center-screen “BROADCAST MODE” HUD in V1  
- No requirement that viewers install the addon to witness promotions  
- No treating the ladder window as a stream overlay  

---

## Open follow-ups (not V1 blockers)

- Officer “streamer mode” toggle: larger toasts / longer dwell / force announce on  
- SharedMedia display font gated behind stream-contrast testing  
- Clip/Shorts-safe ceremony layouts when V2 dashboard lands  

## Cross-links

- [capture-safe-zones.md](capture-safe-zones.md)  
- [contrast-on-game-footage.md](contrast-on-game-footage.md)  
- [duration-and-attention.md](duration-and-attention.md)  
- [typography-scale.md](typography-scale.md)  
- [01-ux-patterns/chat.md](../01-ux-patterns/chat.md) · [weakauras-overlays.md](../01-ux-patterns/weakauras-overlays.md)
