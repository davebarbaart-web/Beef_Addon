# What Classic Players Reject from Retail UI

**Last updated:** 2026-07-25  
**Related:** [quietly-accepted.md](quietly-accepted.md), [design-implications-church-of-beef.md](design-implications-church-of-beef.md)

---

## 1. Rejection is about *defaults and metaphors*, not capabilities

Classic players often run sophisticated addons. What they reject is:

1. **Forced** Retail look/feel as the only Blizzard path  
2. **Metaphors** that feel like mobile/Discord/Dragonflight product design  
3. **Systems** that remove social or discovery friction  

Opt-in Retail-inspired skins exist and sell millions of downloads — with careful positioning (see §4).

---

## 2. Actively rejected or polarizing Retail patterns

### 2.1 Edit Mode as product identity

- Retail treats Edit Mode as core HUD authorship ([Wowhead guide](https://www.wowhead.com/guide/ui/ui-and-hud-edit-mode-guide)).
- On Classic, Blizzard adding Edit Mode to TBC Anniversary was billed as QoL ([Warcraft Tavern](https://www.warcrafttavern.com/tbc/news/edit-mode-is-coming-to-the-ui-for-tbc-classic-anniversary-edition/)).
- Player reception on Anniversary often soured: shortened Edit Mode vs Retail, fights with existing addons, chat positioning regressions, desire to turn it off or restore old UI ([EU BCC “Built-in Edit Mode” thread](https://eu.forums.blizzard.com/en/wow/t/built-in-edit-mode/601446)).
- Classic+ wishlists still split: some want the editor; others refuse modern UI entirely ([US forums Classic+ UI editor thread](https://us.forums.blizzard.com/en/wow/t/one-retail-change-i-would-genuinely-dig-for-classic-is-the-modern-ui-editor/2137436)).

**CoB implication:** Do **not** brand `/beef` as “Edit Mode for your church.” Offer a movable clamped frame + saved position (spec §10). Avoid Retail layout-manager language in UX copy.

### 2.2 Frameless / glossy / “Midnight-adjacent” chrome

July 2026 Classic nameplate and raid-frame updates were read as modernized toward current retail styling; Blizzard Watch notes shared code with retail and the lack of a true visual rollback ([Blizzard Watch modernization article](https://blizzardwatch.com/2026/07/22/blizzard-modernized-parts-wow-classic-era-tbc-classic-anniversary-realms-user-interface/)). Forum pushback on “new UI” for Anniversary/Era is visceral (“the new ui is trash,” optional-only demands) ([Anniversary/ERA UI thread](https://us.forums.blizzard.com/en/wow/t/anniversaryera-needs-the-new-ui-and-high-resolution-textures/2204244?page=3)).

**CoB implication:** V1 plain Classic frames are politically safer than shipping a flat Retail panel skin. V2 theatrical art should be **cathedral/Scarlet skeuomorphism**, not glassmorphism.

### 2.3 Dense Retail action-bar / nameplate language

Retail HUDs normalize many visible bars, class-colored everything, and high nameplate information density. Classic nostalgia cohort associates that density with “playing the UI.” Even players who use Plater/ElvUI chose it; a social addon that *defaults* to meter-like density invites the wrong genre reading.

**CoB implication:** Ladder ≠ raid frames. No fake health bars for standing. Officer breakdown = simple event list, not Details!.

### 2.4 Discord-overlay / feed metaphors

Left-rail social feeds, bubble toasts, always-on notification chrome read as out-of-world apps. Classic chat culture is tabbed chat + guild channel spectacle.

**CoB implication:** Prefer **guild-chat announcements** (spec §10) and short toasts over a persistent “activity feed” in V1. Defer confessions-feed theater to V2 — and even then, skin it as scripture board, not Discord.

### 2.5 Auto-pathing / breadcrumb hand-holding as first-party virtue

Retail built-in quest guidance is the foil Classic nostalgia uses when criticizing “the game plays itself.” Questie is tolerated partly because it marks *objectives/NPCs*, not because players love being railroaded — and paid leash-style guides remain culturally radioactive on Hardcore ([RestedXP HC debate](https://us.forums.blizzard.com/en/wow/t/why-is-addon-like-restedxp-allowed-by-blizzard/2022911?page=6)).

**CoB implication:** Never auto-path members to ceremonies. Announce, coordinate, record — humans still walk.

### 2.6 Matchmaking that deletes city social space

Dungeon Finder–class automation remains the canonical “QoL that breaks Classic” example in Blizzard’s own social-proximity framing ([Wrath philosophy coverage](https://www.mmorpg.com/news/blizzard-devblog-dives-into-the-philosophies-behind-upcoming-wrath-of-the-lich-king-classic-changes-2000125375)).

**CoB implication:** No automated Beef Gora matchmaking that replaces challenge culture. Thin challenge + recorded outcome (spec §3.1) matches Classic social theater.

---

## 3. Soft rejects (accepted only when optional)

| Pattern | When rejected | When tolerated |
|---------|---------------|----------------|
| Modern flat UI | As Blizzard default | ElvUI / DFUI opt-in |
| Edit Mode | Incomplete / forced / breaks addons | As optional power-user tool |
| Class-colored plates | Sudden Blizzard change | Player-chosen CVar/addon |
| Damage meters | “Toxic parse culture” | Raid groups that want them |

---

## 4. Case study: Dragonflight UI Classic (the careful middle)

[Dragonflight UI Classic](https://www.curseforge.com/wow/addons/dragonflight-ui-classic) markets itself as:

> *Minimalistic – Modern – Modular*  
> **No carbon copy** of the new retail Dragonflight UI, but a **faithful adaption** with extra, classic related features.  
> Completely **modular**: (de-)/activate any feature…

([CurseForge description](https://www.curseforge.com/wow/addons/dragonflight-ui-classic); [GitHub README](https://github.com/Karl-HeinzSchneider/WoW-DragonflightUI))

**Why this matters:** Even the flagship “bring Retail UI to Classic” project knows a 1:1 port would fail culturally. Modularity + “not a carbon copy” is the viable lane.

**CoB lesson:** If any modern visual influence appears later, it must be modular, opt-in, and *not* marketed as Retail parity. Brand language should say “Church UI,” not “Dragonflight for Beef.”

---

## 5. Rejection checklist for CoB UI reviews

Ship-blocking smells:

- [ ] Frameless neon panels as default  
- [ ] Persistent social feed competing with chat  
- [ ] Auto-invite / auto-path / auto-promote  
- [ ] Combat HUD density on the ladder  
- [ ] Copy claiming “Retail-quality Edit Mode”  
- [ ] Requires LibSharedMedia / ElvUI to look intentional  

Allowed smells:

- [ ] Movable Classic-style dialog  
- [ ] One toast, then gone  
- [ ] Officer human gate  
- [ ] Guild chat as spectacle channel  
