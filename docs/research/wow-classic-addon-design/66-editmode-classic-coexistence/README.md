# Track 66 — Edit Mode / modernized Classic UI coexistence

**Track id:** `66-editmode-classic-coexistence`  
**Last updated:** 2026-07-25  
**Sole focus:** What TBC Classic Anniversary (and the Jul 2026 Classic UI wave) actually shipped for **Edit Mode** and modernized Blizzard UI; how third-party frames should coexist; implications for Beef **panel** and **toast** placement.  
**Out of scope:** Movable-frame APIs and SV persistence mechanics ([37-movable-frames-anchors](../37-movable-frames-anchors/)); Classic-vs-Retail product philosophy ([12-classic-vs-retail-philosophy](../12-classic-vs-retail-philosophy/)); Anniversary↔Era packaging deltas ([30-anniversary-vs-era-deltas](../30-anniversary-vs-era-deltas/)); combat HUD atlas ([08-combat-hud-alerts](../08-combat-hud-alerts/)). No addon implementation or commits live here.

## Product truth (from V1 spec)

| Locked default | Value |
|----------------|-------|
| V1 platform | TBC Classic Anniversary (`20506` @ 2.5.6) |
| Main UI | `/beef` real frame — movable, clamped, saved position |
| Toasts | Ephemeral suggestion / rank / Gora credit — not the ladder window |
| Identity | Classic-native social tool — **not** a Retail Edit Mode clone |

Source: [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §2, §9–§10; philosophy rejection of Edit Mode branding in [track 12](../12-classic-vs-retail-philosophy/rejected-from-retail.md).

## Index

| Note | Covers |
|------|--------|
| [what-anniversary-shipped.md](what-anniversary-shipped.md) | Timeline: PTR → pre-patch Edit Mode → 2.5.6 Midnight-aligned plates/frames; Era 1.15.9 wave |
| [third-party-frame-coexistence.md](third-party-frame-coexistence.md) | What Edit Mode owns; what addons own; Expanded libs; ElvUI/DFUI reality |
| [beef-panel-toast-implications.md](beef-panel-toast-implications.md) | Placement / anchoring / branding rules for Beef surfaces |
| [annotated-urls.md](annotated-urls.md) | Primary URLs with steal/adapt notes |

## Top insights for Beef (read this first)

1. **Anniversary got Edit Mode at pre-patch (Jan 2026), not only in the Jul 2026 modernization.** PTR notes (Nov 2025) listed Edit Mode as UI QoL; live Anniversary players were already fighting a shortened/buggy Edit Mode by mid-January ([PTR notes](https://us.forums.blizzard.com/en/wow/t/the-burning-crusade-classic-anniversary-ptr-development-notes/2201610); [Warcraft Tavern](https://www.warcrafttavern.com/tbc/news/edit-mode-is-coming-to-the-ui-for-tbc-classic-anniversary-edition/); [EU “Built-in Edit Mode”](https://eu.forums.blizzard.com/en/wow/t/built-in-edit-mode/601446)).

2. **July 2026 2.5.6 is a second wave: Midnight-aligned raid frames/nameplates + more Edit Mode knobs — not “Edit Mode arriving.”** Kaivax: Anniversary 2.5.5 used War Within–era raid frames; 2.5.6 aligned with Midnight; hotfix added Edit Mode Layout Template / Opacity / Aura Icon Size for raid frames, plus nameplate class-color options. Era/SoD/HC got Edit Mode + analogous plate/frame changes in **1.15.9** (week of Jul 19) ([User Interface Updates in Classic](https://us.forums.blizzard.com/en/wow/t/user-interface-updates-in-classic/2325408); [Blizzard Watch](https://blizzardwatch.com/2026/07/22/blizzard-modernized-parts-wow-classic-era-tbc-classic-anniversary-realms-user-interface/)).

3. **There is no true visual rollback.** Shared modern UI code is the maintenance strategy; a “Classic” Edit Mode preset exists but does not restore 2007 chrome. Players who want old look still rely on addons ([Blizzard Watch](https://blizzardwatch.com/2026/07/22/blizzard-modernized-parts-wow-classic-era-tbc-classic-anniversary-realms-user-interface/); [EU Edit Mode thread](https://eu.forums.blizzard.com/en/wow/t/built-in-edit-mode/601446)).

4. **Blizzard Edit Mode only manages Blizzard-highlighted systems.** Custom addon frames are invisible to Edit Mode unless the author registers them (Retail libs such as EditModeExpanded). Beef V1 should **not** depend on Edit Mode registration — keep independent drag + `ChurchOfBeefDB` position ([Edit Mode Expanded](https://www.curseforge.com/wow/addons/edit-mode-expanded); [library usage](https://github.com/teelolws/EditModeExpanded/wiki/Authors:-Library-Usage); [track 37](../37-movable-frames-anchors/)).

5. **Third-party coexistence rule: do not parent, hook, or brand into Blizzard’s editable HUD.** Expect players to rearrange chat, action bars, unit/raid frames, minimap cluster; expect ElvUI / Dragonflight UI / MoveAnything to replace or fight those same surfaces. Social edge UI survives by owning `UIParent`-anchored frames and staying off combat HUD real estate ([EU coexistence complaints](https://eu.forums.blizzard.com/en/wow/t/built-in-edit-mode/601446); [track 08](../08-combat-hud-alerts/)).

6. **Panel ≠ toasts; neither should inherit Edit Mode layouts.** Persist only `/beef`. Toasts use a fixed title-safe edge stack, independent of panel drag and of Edit Mode profile switches ([track 37 placement](../37-movable-frames-anchors/beef-toast-panel-placement.md)).

7. **Do not market Beef as Edit Mode.** Philosophy track already rejects Retail layout-manager language; Anniversary reception of half-baked Edit Mode makes that branding toxic ([track 12](../12-classic-vs-retail-philosophy/rejected-from-retail.md)).

## Provenance

Search/extract dumps under [`.raw/`](.raw/). Prefer Kaivax blue posts, Warcraft Tavern/Blizzard Watch summaries of those blues, and EU Anniversary Edit Mode threads over Retail Edit Mode marketing.
