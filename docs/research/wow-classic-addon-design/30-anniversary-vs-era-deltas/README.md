# Track 30 — Classic Anniversary vs Era (and other flavors) deltas

**Track id:** `30-anniversary-vs-era-deltas`  
**Last updated:** 2026-07-25  
**Sole focus:** Product, install, Interface, API/UI, and community deltas between **TBC Classic Anniversary** (Church of Beef V1 target) and **Classic Era / SoD / Hardcore**, plus packaging implications for other Classic flavors.  
**Out of scope:** Full TOC directive catalogs (see [04-toc-api-performance/](../04-toc-api-performance/) when filled; prior sketch [01-client-flavors-and-toc.md](../01-client-flavors-and-toc.md)). No addon implementation in this folder.

## Product truth (from V1 spec)

| Locked default | Value |
|----------------|-------|
| V1 platform | **TBC Classic Anniversary** |
| TOC Interface (plan/spec) | **`20506`** — verify live with `/dump (select(4, GetBuildInfo()))` |
| Install tree | Anniversary client only (`_anniversary_`) |
| Later port | Classic+ (isolate TOC / instance / messaging seams) |
| Not V1 | Classic Era, SoD, Hardcore, Cata/MoP Classic, Retail |

Source: [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §2, §5, §12–§15.

## Index

| Note | Covers |
|------|--------|
| [install-paths-and-clients.md](install-paths-and-clients.md) | `_anniversary_` vs `_classic_era_` vs `_classic_`; WTF isolation; CurseForge BCC Anniversary tab |
| [interface-versions-and-game-types.md](interface-versions-and-game-types.md) | Interface numbers as product gates; `tbc` vs `vanilla`; `_TBC.toc` loads Anniversary |
| [api-ui-deltas.md](api-ui-deltas.md) | Shared-code UI drift, content/API surface differences Era↔Anniversary, Beef-relevant seams |
| [community-expectations.md](community-expectations.md) | What Anniversary players install/expect; Hardcore/Era coexistence; guild onboarding |
| [beef-multi-toc-packaging.md](beef-multi-toc-packaging.md) | V1 single-flavor strategy; when/how to multi-TOC without duplicating track 04 |
| [annotated-urls.md](annotated-urls.md) | Primary URLs with steal/adapt notes |

## Top insights for Beef (read this first)

1. **Wrong folder = invisible addon.** V1 must document `World of Warcraft/_anniversary_/Interface/AddOns/ChurchOfBeef`. Era’s `_classic_era_` and progression `_classic_` are different trees; SavedVariables and AddOns do not transfer automatically ([Mythic-Store install guide](https://mythic-store.com/us/blog/best-tbc-anniversary-addons-full-guide-for-2025), [MSBT Anniversary file notes](https://www.curseforge.com/wow/addons/mikscrollingbattletext-tbc-anniversary/files/7573212), [Blizzard forum copy-WTF advice](https://us.forums.blizzard.com/en/wow/t/the-burning-crusadeaddons/2226408)).

2. **Anniversary is game type `tbc`, not `vanilla`.** Wiki maps `_TBC.toc` / `AllowLoadGameType tbc` to Burning Crusade Classic **and** Classic Anniversary Edition. Era uses `vanilla` / `_Vanilla.toc`. A Vanilla-only TOC will not load on Anniversary ([TOC format](https://warcraft.wiki.gg/wiki/TOC_format)).

3. **Interface `20506` is the Anniversary packaging number for patch 2.5.6.** Spec/plan already lock this; wiki Patch 2.5.6 resources list TOC `20506`. Still verify in-client — secondary guides often lag at `20505` or invent retail-looking numbers ([Patch 2.5.6/API changes](https://warcraft.wiki.gg/wiki/Patch_2.5.6/API_changes)).

4. **UI chrome is converging across Classic flavors; content APIs are not.** Kaivax: all Classic shares modern UI code; Anniversary 2.5.5 used War Within–era frames; 2.5.6 aligned raid frames toward Midnight; Era/SoD/HC got analogous 1.15.9 updates. Addon authors were told **2.5.6 ≈ 1.15.9 API for UI**, but Outland content, attunements, heroics, and TBC systems remain Anniversary-only ([User Interface Updates in Classic](https://us.forums.blizzard.com/en/wow/t/user-interface-updates-in-classic/2325408)).

5. **Community stack on Anniversary is combat + attune + quest — Beef is an edge social tool.** Guides center Questie, Attune, DBM/BigWigs, Details, Plater, WeakAuras ([Overgear](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/), [MMOJUGG](https://www.mmojugg.com/news/essential-addons-for-tbc-classic-anniversary-2026-dominate-outland.html)). Onboarding copy must say “Anniversary folder / BCC Anniversary tab,” never “drop it in Classic Era AddOns.”

6. **V1 packaging: single TOC, Anniversary-only.** Prefer `ChurchOfBeef.toc` with `## Interface: 20506`. Add `_TBC.toc` or comma-Interfaces only when intentionally shipping another flavor; do not use bare `_Classic.toc` as the V1 strategy (post–2.5.5 it loads on *all* Classic clients — too wide for an Anniversary-locked product).

## Provenance

Search/extract dumps under [`.raw/`](.raw/). Prefer Warcraft Wiki, Blizzard forum (Kaivax), and author install notes over listicles that mis-state `_classic_era_` as the Anniversary path.
