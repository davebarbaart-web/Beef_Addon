# Steal / Adapt / Reject Matrix

**Last updated:** 2026-07-25  
**Maps to:** V1 UI surfaces in design spec §10 — Ladder, My Standing, Officer, thin Gora/Ceremony stubs, toasts, minimap, guild-chat line.

Canon ranks (do not invent Templar substitutes): Fresh Beef → Cooked Beef → Beef Knight → Beef Lord → Beef Butcher → Beef Council → Beef Prophet.

---

## By pattern

| Pattern | Steal from | Adapt for Beef | Reject |
|---------|------------|----------------|--------|
| Unified backdrop/border tokens | ElvUI settings language | Optional V2 “simple / ornate” flag — not a full installer | Matching ElvUI grey; global Blizzard frame skinning |
| Movable clamped frame + saved position | Bartender/Dominos config-mode culture; Blizzard UIPanel | `/beef` movable, clamped, SavedVariables position (spec §10) | Fade-out of primary ladder text |
| Tabbed tool window | AtlasLoot, Auctionator | Ladder / My Standing / Officer tabs | Auction-spreadsheet column counts |
| Item-quality colored rows | AtlasLoot, AH tooltips | Soft rank escalation (bone → gold → scarlet left rule or title color) | Neon class-color rainbow on every row |
| Dense combat table | Details! | Officer queue: player, suggested rank, point breakdown, few recent events | Meter windows, sparklines, multi-monitor layouts |
| Map pins + tooltips | Questie | Future ceremony sites only; V1 = tooltip clarity on ranks | World-map clutter for V1 |
| Scripted spotlight | Plater / WeakAuras | V2+ rank-up card: enter, hold, fade once | Persistent WA-style HUD around the character |
| Masque / button skins | Bartender, Dominos | Optional later on icon buttons | V1 dependency |
| Healer grid density | Cell, VuhDo | — | Ladder-as-raid-frames; fake HP bars for standing |
| Edit Mode layouts | Blizzard modern Classic | Ignore for core UX | Retail Edit Mode API as requirement |
| Glass / blur / glow | Retail WA packs | — | Always |

---

## By Beef surface

### Ladder tab

- **Structure:** AtlasLoot-like vertical list of seven ranks with occupants.  
- **Highlight:** Local player row stronger (border or parchment wash), not a pulsing WA.  
- **Council / Prophet:** Visually scarce — seat-limited and unique (spec §4.1). Extra chrome on Prophet only *after* V1 if it stays readable on stream.

### My Standing tab

- **Structure:** Auctionator “summary + recent lines,” not Details! history.  
- **Progress:** Simple next-threshold readout; avoid fake XP bar that looks like a castbar skin war with ElvUI.

### Officer tab

- **Structure:** Suggestion queue as a short table + Approve / Reject / Adjust.  
- **Tone:** Liturgy roster, not combat log. Demotion (“excommunication”) can be on-brand in copy without red error-UI spam.

### Toasts

- **Steal:** WeakAuras one-shot timing; BigWigs “important then gone.”  
- **V1 events:** suggestion created, rank approved, Gora/ceremony credit (spec §10).  
- **Cap:** one visible toast; no stack spam.

### Minimap button

- **Steal:** AtlasLoot / Dominos familiarity — click toggles main frame.  
- **Coexist:** LibDBIcon-style collectors / ElvUI minimap (see Ace/lib track if present).

### Guild chat spectacle

- **Primary V1 “visual” for non-addon members:** throttled plain-text promotion/demotion line from approving officer (spec §10).  
- **Design lesson:** the most Classic-native spectacle is often **chat**, not overlay art.

---

## Heraldic escalation (post-V1 art pass)

Progressive frame treatment — inspired by Scarlet two-color lockup ([Tabard of the Scarlet Crusade](https://www.wowhead.com/classic/item=23192/tabard-of-the-scarlet-crusade), [Scarlet Crusade — Wowpedia](https://wowpedia.fandom.com/wiki/Scarlet_Crusade)), applied to **Beef titles**, not invented clergy ranks:

| Order | Title | Suggested visual device (later) |
|------:|-------|----------------------------------|
| 1 | Fresh Beef | Plain bone row, white/off-white title |
| 2 | Cooked Beef | Warm brown underline |
| 3 | Beef Knight | Small gold chevron or seal |
| 4 | Beef Lord | Double gold rule |
| 5 | Beef Butcher | Scarlet left bar + heavier title weight |
| 6 | Beef Council | Scarlet plate wash; seat count shown |
| 7 | Beef Prophet | Unique sigil / halo ring; never a grindable lookalike |

V1 may ignore this table and use default fonts + equal chrome.

---

## Coexistence rules (ElvUI-heavy guilds)

1. Do not skin Blizzard frames globally.  
2. Unique frame name + strata; save position.  
3. Do not assume default chat frame indices.  
4. Minimap button must work with collectors.  
5. Do not fight ElvUI bag/chat modules.

---

## Mantra (corrected)

Not “built like ElvUI.” Prefer:

> **Framed like a Classic tool window; dressed later like a ridiculous cathedral.**

Square, opaque, hard-edged, high-contrast now; Scarlet/bone/candle-gold pageantry when art exists — still no glass, blur, or perpetual glow.
