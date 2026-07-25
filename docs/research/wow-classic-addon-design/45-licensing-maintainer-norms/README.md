# Track 45 — Licensing, Copyright, Maintainer Norms

**Lane:** Focused research (IP / distribution / maintainer culture only)  
**Last updated:** 2026-07-25  
**Maps to:** [Church of Beef V1 design spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) (brand identity, free distribution under Blizzard UI policy, streamer-facing liturgy)  
**Does not cover:** Blizzard ToS monetization enforcement depth (see [24-policy-tos-compliance](../24-policy-tos-compliance/)), listing copy (see [31-listing-copy-discovery](../31-listing-copy-discovery/)), packaging antipatterns beyond license metadata (see [05-packaging-community-antipatterns](../05-packaging-community-antipatterns/)).

## Purpose

How the WoW addon scene actually treats copyright: All Rights Reserved vs MIT/GPL, asset licensing, fork etiquette, and what CurseForge/Overwolf ownership means for authors — plus concrete license options for Church of Beef.

## Docs in this track

| File | Contents |
|------|----------|
| [01-license-spectrum.md](01-license-spectrum.md) | ARR vs MIT/GPL/LGPL/Ace-BSD; source-viewable ≠ open source |
| [02-assets-and-third-party.md](02-assets-and-third-party.md) | Textures, sounds, fonts, Blizzard art, SharedMedia packs |
| [03-fork-culture-and-maintainer-norms.md](03-fork-culture-and-maintainer-norms.md) | Abandoned projects, rename etiquette, GitHub vs CF project IDs |
| [04-curseforge-ownership.md](04-curseforge-ownership.md) | Author retains title; Overwolf platform license; exclusive CF distribution rights |
| [05-beef-recommendation-options.md](05-beef-recommendation-options.md) | Three license strategies for Beef + decision checklist |
| [annotated-urls.md](annotated-urls.md) | Annotated primary URLs |

## Top takeaways (one screen)

1. **Readable ≠ reusable.** Blizzard requires addon code to be fully visible; that does **not** make it free to copy. No license ⇒ Berne default = All Rights Reserved.
2. **ARR is the mainstream product license.** ElvUI, Details!, DBM, Gargul, many SharedMedia projects ship ARR (or ARR-with-private-mod clauses). GPL/LGPL clusters around collaborative frameworks (WeakAuras GPL-2.0, RCLootCouncil LGPLv3). Ace3 uses a custom “Ace Style BSD” that forbids stand-alone redistribution.
3. **Brand control is why ARR wins for UI/social tools.** Authors fear stale mirrors, name hijacks, and broken forks more than they fear closed collaboration. MIT is loved in theory, rare for flagship player-facing addons.
4. **CurseForge does not take title.** Overwolf’s Mod Authors Terms leave ownership with the author but grant a broad platform license, with exclusive rights to market/advertise/distribute *on CurseForge* and to share usage data. Authors may still distribute elsewhere.
5. **For Beef, ARR (or ElvUI-style ARR + private mods + GitHub) is the brand-safe default;** MIT/GPL only if intentional community forkability outweighs liturgy/name control. Ace libs stay under their own licenses when embedded.

## Provenance

Search/extract JSON under [`.raw/`](.raw/). Prefer Overwolf legal, Blizzard UI policy, WowAce/CurseForge project license fields, GitHub LICENSE files, and WoWInterface author threads over listicles.
