# Design Implications for Church of Beef

**Last updated:** 2026-07-25  
**Spec anchor:** [2026-07-25-church-of-beef-design.md](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)  
**Inputs:** [player-expectations.md](player-expectations.md), [nostalgia-vs-qol.md](nostalgia-vs-qol.md), [rejected-from-retail.md](rejected-from-retail.md), [quietly-accepted.md](quietly-accepted.md)

---

## 1. Brand position in the Classic culture war

Church of Beef is **not** a raid HUD and **not** a Retail social app. It is a **religious-sports-entertainment institution** tool (spec §1) on **TBC Classic Anniversary**.

Winning aesthetic/political stance:

> **Classic-native container, modern bookkeeping, human ritual gate, stream-readable spectacle.**

That maps cleanly onto community consensus: accept tedium-reduction and information overlays; reject automation and forced Retail chrome.

---

## 2. Principles (ranked for CoB)

1. **Preserve social friction that is content.** Officer approve/reject, Gora challenges, ceremonies started by humans — these are the product, not bugs to Delete.
2. **Information, not automation.** Standing suggestions are testimony; officers are anti-cheat (spec §6.3). Never auto-promote, auto-invite, or path players.
3. **Default look = Blizzard Classic dialog DNA.** Spec §10 already allows plain Classic frames for V1 — that is also the politically safest default.
4. **Spectacle through guild chat + rare toasts**, not always-on feeds. Cheapest stream moment = promotion line in guild chat.
5. **Theatrical chrome is V2 and skeuomorphic.** Scarlet/cathedral/steak pageantry ≠ Dragonflight flat panels (brand §3.3).
6. **Coexist with ElvUI / Questie / WA.** Unique frame names, no global skinning, one minimap icon, saved position.
7. **Do not market with Retail metaphors.** Avoid “Edit Mode,” “Social HUD,” “Discord for your guild.” Prefer “ladder,” “standing,” “rite,” “edict.”
8. **Era honesty.** V1 is TBC Anniversary; Hardcore purity is adjacent brand lore, not a reason to ship worse UX — but it *is* a reason to avoid leash/automation vibes.
9. **Optional density.** Power users can want breakdowns; new Fresh Beef should see seven titles and their own standing without a spreadsheet.
10. **Members without the addon remain first-class audience** for chat spectacle and in-world ceremonies.

---

## 3. V1 UI do / don’t

| Do | Don’t |
|----|-------|
| Movable, clamped, saved `/beef` frame | Full layout editor / Edit Mode clone |
| Tabs: Ladder / My Standing / Officer | Persistent activity feed |
| Simple rank list + local highlight | Raid-frame or meter visual language |
| Event list for standing sources | Details!-style parse tables |
| One toast per meaningful event | WA wall of church notifications |
| Throttled guild-chat edict on promote/demote | Multi-addon spam echoes |
| Default fonts with media fallback | Require pixel fonts / LSM to function |
| Officer-gated commits via BeefNet | Client-authoritative auto ladder |

---

## 4. Copy and tone implications

Classic players punish UI that sounds like a live-service patch notes blog. CoB should sound like an absurd institution:

- “The Church recognizes…” (already in spec) beats “Rank updated successfully.”
- “Suggestion pending officer rite” beats “Claim your reward.”
- “Excommunication” for demotion is on-brand *and* culturally Classic (drama in guild chat).

Avoid Retail systems copy: “Catch-up,” “Renown track,” “Weekly vault,” “Warband.”

---

## 5. Mapping Blizzard’s Classic pillars → CoB

From Wrath-era Classic philosophy (social proximity / familiar / world as main character):

| Pillar | CoB expression |
|--------|----------------|
| Social proximity | Shared instance standing; ceremonies; Gora; guild-chat edicts |
| Approachable & familiar | Plain frames; `/beef`; minimap button; seven readable titles |
| World is main character | Credit from being *in instances with guildmates*, not from clicking a battle-pass UI |

---

## 6. Learning from adjacent addons (steal shape, not skin)

| Source | Steal | Leave |
|--------|-------|-------|
| Questie | Scannable icons/info | Map clutter norms |
| WeakAuras | Short declarative toasts | Permanent aura walls |
| Total RP 3 | Clean depth; profiles; interoperability ethos | Full RP dossier scope |
| Dragonflight UI Classic | Modular opt-in honesty | Retail visual identity |
| Details! | — | Meter aesthetics |
| ElvUI | Coexistence discipline | Becoming another ElvUI module |

---

## 7. Risk register (philosophy-driven)

| Risk | Why it happens | Mitigation |
|------|----------------|------------|
| “This feels Retail” backlash | Flat panels, feed UI, systems copy | Classic frames + institutional language |
| “This plays the game for you” | Auto-promote, auto-path, combat hooks | Keep hybrid gate; no protected actions |
| Purity guildmates refuse addon | Any required HUD | Chat announcements work without addon |
| ElvUI users can’t find frame | Strata/parent fights | Document strata; unique names; position save |
| Stream unreadable | Low contrast, tiny type | High-contrast titles; one toast; chat edict |
| Ladder becomes parse culture | Showing too much comparative DPS-like data | Standing breakdown is narrative events, not DPS |

---

## 8. Decision echoes for the spec (no silent forks)

These research conclusions **already agree** with the approved spec — reinforce, don’t reopen:

- Hybrid suggest → Officer+ approve  
- No combat automation  
- Guild-chat promotion visibility  
- Plain V1 frames; theatrical pass later  
- Per-character standing (“flesh must prove itself anew”) as Classic-flavored friction  

Open questions from spec §16 that this philosophy informs (still not V1 blockers):

- **Alt linking:** Account-wide ranks feel more Retail/Warband; per-character is more Classic-hardcore-flavored.
- **Decay / Lent reset:** Seasonal institutional reset is on-brand *and* Classic-raid-reset culturally familiar — better than silent modern battle-pass drip.
- **Suggestion queue sync:** Officers missing suggestions is Meaning-B QoL; fixing it does not violate nostalgia.

---

## 9. One-paragraph product brief (for designers)

Build Church of Beef as a **Classic dialog-shaped guild institution**: seven holy titles, standing earned by showing up with the flock, promotions that require clergy, and edicts spoken in guild chat. Make bookkeeping modern; make ritual human; make chrome optional and cathedral — never Midnight.
