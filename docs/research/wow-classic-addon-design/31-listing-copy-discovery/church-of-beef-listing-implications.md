# Implications for Church of Beef listing

**Lane:** Draft storefront plan for CurseForge + Wago.  
**Maps to:** V1 design spec §1–2 (social, not combat), §13 success criteria, Anniversary client.  
**Does not replace:** Packaging zip/TOC work (track 05).

## Positioning (non-negotiable)

| Do | Don’t |
|----|-------|
| Lead with **guild ladder / officer-approved ranks** | Lead with combat, meters, WeakAuras |
| Say **TBC Classic Anniversary** in Summary or first description line | Imply “all Classic forever” without files |
| State **who must install** (members vs Officers+) | Imply silent magic with one officer install only for full ladder UX |
| Promise **guild-chat spectacle** for non-users | Promise cross-realm / cross-faction church state |

Aligned with synthesis note that market/TOC Notes should read as a guild institution tool ([00 implications](../00-church-of-beef-implications.md) §1–2).

## Recommended metadata

| Field | Draft value |
|-------|-------------|
| **Name** | Church of Beef |
| **Summary** | Guild standing ladder for TBC Classic Anniversary — officer-approved ranks, social spectacle (not combat). |
| **Class** | Addons |
| **Main category** | Guild |
| **Additional** | Roleplay; Chat & Communication |
| **Logo** | ≥400×400 PNG; brand-first (cow/cathedral absurd), readable at tile size |
| **Primary flavor file** | Classic TBC / Anniversary — Interface **20506** (verify live) |
| **Hosts** | CurseForge + Wago Addons, same version + changelog |

Rationale for categories: honest Guild primary; Roleplay for church/titles framing; Chat for announces. Avoid Combat/Boss Encounters ([category note](category-tags-discovery.md)).

## Description must-haves (checklist)

- [ ] Functional “what it does” table (ladder, officer queue, co-play standing, announce)
- [ ] `/beef` getting-started line
- [ ] Anniversary folder callout (separate AddOns tree)
- [ ] “Not a combat addon” one-liner
- [ ] Who needs the addon vs who only sees guild chat
- [ ] Host/Discord badges without drowning the pitch ([Best Project Page](https://blog.curseforge.com/how-to-create-the-best-project-page/))
- [ ] English, no fluff-only lore wall ([Creating and Submitting a Project](https://support.curseforge.com/en/support/solutions/articles/9000197241-creating-and-submitting-a-project))

## Gallery must-haves (checklist)

Ship ≥6 captioned in-game shots before public launch ([screenshot note](screenshot-gallery-norms.md)): ladder, standing, officer queue, guild-chat announce, edge UI entry, empty/not-in-guild. No AI mock of unshipped V2 ceremony art without disclaimer ([Moderation Policies](https://support.curseforge.com/en/support/solutions/articles/9000197279-moderation-policies)).

## Changelog must-haves

- Interface / Anniversary bump always first line
- Player-facing Added/Fixed only
- Same text on CF file + Wago release
- Prefer Release channel for guild nights; don’t train ignore via daily alphas ([changelog note](changelog-culture.md))

## Discovery SEO tactics (ethical)

1. Job nouns in Summary: guild, ladder, ranks, officer, Classic, Anniversary.
2. Categories that match real behavior (Guild + Roleplay + Chat).
3. Keep flavor file **Updated** date fresh — browse cards sort/filter by activity ([WoW addons hub](https://www.curseforge.com/wow)).
4. Dual-list so WowUp/Wago users find you ([Blizzard forums](https://us.forums.blizzard.com/en/wow/t/wow-up-curse-wago/2292441)).
5. Optional: streamer/guild Discord pin with CF+Wago links (Attune-style social proof later).

## Cousin steal list (copy only)

| Steal from | What |
|------------|------|
| [Questie](https://www.curseforge.com/wow/addons/questie) | Ultra-short Classic job Summary |
| [Attune](https://www.curseforge.com/wow/addons/attune) | “WHAT THE ADDON IS FOR”; guild survey framing; Anniversary honesty; who needs install |
| [Gargul](https://www.curseforge.com/wow/addons/gargul) | Feature×command table; badge row; dual CF/Wago |
| [Total RP 3](https://www.curseforge.com/wow/addons/total-rp-3) | Captioned feature gallery; FAQ link near top |
| [DBM](https://www.curseforge.com/wow/addons/deadly-boss-mods) | Release-channel education only — **not** combat framing |

## Risks

| Risk | Mitigation |
|------|------------|
| Tagged Roleplay → RP directory expectations | Opening paragraph: guild institution / standing ladder, not MSP profiles |
| Tagged Guild → compared to RCLootCouncil | Explicit “not a loot addon” if comments confuse |
| Lore-heavy Scarlet pageantry in V1 copy | Keep V1 listing plain-functional; defer gothic chrome to V2 media |
| Wrong Interface file on Anniversary | Changelog + file game-version tags verified every patch |

## Open decisions (product, not research)

1. Exact Summary string (funny brand voice vs dry job noun).
2. Whether to add **Data Export** category if officer sync tools are marketed.
3. Public Discord URL for badge row.
4. Whether WowInterface listing is needed for WowUp coverage beyond CF/Wago (distribution → track 05).
