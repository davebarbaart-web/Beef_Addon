# Track 31 — CurseForge / Wago listing copy, screenshots, discovery SEO

**Track id:** `31-listing-copy-discovery`  
**Last updated:** 2026-07-25  
**Sole focus:** Storefront presentation — category tags, screenshot/gallery norms, short/long description patterns that convert Classic players, changelog culture, and draft listing implications for Church of Beef.  
**Out of scope:** Zip/TOC packaging, BigWigs-style release automation, WowInterface upload pipelines, community antipatterns of distribution (track [05-packaging-community-antipatterns](../05-packaging-community-antipatterns/)). This track may *cite* discovery surfaces that 05 also touches, but goes deeper on **copy and SEO**, not packaging mechanics.  
**No addon implementation** in this folder.

## Product truth (from V1 spec)

| Locked framing | Value |
|----------------|-------|
| Product type | Social guild / streamer-event addon — not combat HUD |
| Primary client | TBC Classic Anniversary (`Interface` **20506**) |
| Audience | Guild members + officers; stream-readable spectacle |
| Hard line in copy | No raid DPS / protected-action promises |

Source: [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §1–2, §13.

## Index

| Note | Covers |
|------|--------|
| [category-tags-discovery.md](category-tags-discovery.md) | CurseForge / Wago categories, flavor filters, search SEO |
| [screenshot-gallery-norms.md](screenshot-gallery-norms.md) | Logo, gallery captions, Classic screenshot conventions |
| [short-long-description-patterns.md](short-long-description-patterns.md) | Summary vs description patterns that convert |
| [changelog-culture.md](changelog-culture.md) | Per-file release notes culture players actually read |
| [church-of-beef-listing-implications.md](church-of-beef-listing-implications.md) | Draft CF/Wago listing plan for Beef |
| [annotated-urls.md](annotated-urls.md) | Primary URLs with steal/adapt notes |

## Top insights for Beef (read this first)

1. **Summary is the SEO headline; description is the close.** CurseForge’s short **Summary** appears in browse/search cards; the long **Description** must still state functional what-it-does (not only lore), in English, or moderators reject ([Creating and Submitting a Project](https://support.curseforge.com/en/support/solutions/articles/9000197241-creating-and-submitting-a-project); [How to Create the Best Project Page](https://blog.curseforge.com/how-to-create-the-best-project-page/)).

2. **Categories are discovery channels — max 1 main + 4 additional, and they must be honest.** Irrelevant tags get bounced ([Creating and Submitting a Project](https://support.curseforge.com/en/support/solutions/articles/9000197241-creating-and-submitting-a-project)). Cousins map to job: Questie → Quests/Map/Tooltip; TRP3 → Roleplay; Attune → Data Export + Quests; Gargul → Bags/Tooltip/Data Export; Wago Gargul also tags Guild + Chat ([Questie](https://www.curseforge.com/wow/addons/questie); [Total RP 3](https://www.curseforge.com/wow/addons/total-rp-3); [Attune](https://www.curseforge.com/wow/addons/attune); [Gargul CF](https://www.curseforge.com/wow/addons/gargul); [Gargul Wago](https://addons.wago.io/addons/gargul)).

3. **Classic players filter by flavor first.** Cards show `Classic` / `Classic TBC` / etc. Winning listings keep separate flavor files current and say **Anniversary / TBC Classic** in the first screen of copy (observed on [Attune](https://www.curseforge.com/wow/addons/attune), [Gargul](https://www.curseforge.com/wow/addons/gargul), [Questie](https://www.curseforge.com/wow/addons/questie)).

4. **Galleries sell features with captions, not wallpaper.** High-converting pages use 6–10 in-game shots, each captioned as a feature (“guild summary,” “soft-reserve tooltip,” “directory tab”) — TRP3, Attune, Gargul, DBM all follow this ([Total RP 3](https://www.curseforge.com/wow/addons/total-rp-3); [Attune](https://www.curseforge.com/wow/addons/attune); [Gargul](https://www.curseforge.com/wow/addons/gargul); [DBM](https://www.curseforge.com/wow/addons/deadly-boss-mods)). CurseForge wants in-game media on the Images tab ([Project Submission Guide](https://support.curseforge.com/en/support/solutions/articles/9000199552-project-submission-guide-and-tips)).

5. **Changelogs are skimmed for Interface bumps and player-facing bullets.** Packager-style notes (“Update zhCN,” commit dumps) are normal for megaprojects ([BigWigs_Classic file changelog](https://www.curseforge.com/wow/addons/bigwigs_classic/files/5629060)); for a guild social tool, prefer short **Added / Fixed / Requires Interface** lines — players update because “works on Anniversary” and “officers can approve again,” not because of commit hashes.

6. **Dual-list CurseForge + Wago with the same story.** Authors keep both hosts in sync; managers (WowUp / Wago / CF) do not merge listings ([Blizzard forums — WoW Up / Curse / Wago](https://us.forums.blizzard.com/en/wow/t/wow-up-curse-wago/2292441)). Gargul’s CF description links Wago and Discord at the top — pattern to copy for Beef ([Gargul](https://www.curseforge.com/wow/addons/gargul)).

## Boundary with track 05

| Track 05 (packaging) | Track 31 (this) |
|----------------------|-----------------|
| Zip layout, TOC, publish automation | Category/SEO tags |
| Host choice as distribution risk | Summary/description conversion copy |
| Antipatterns (bundling junk, etc.) | Screenshot/gallery norms |
| — | Changelog *player-facing* culture |

## Provenance

Search/extract dumps under [`.raw/`](.raw/). Prefer CurseForge support/blog, live addon project pages, and Wago Addons over generic “SEO tips” listicles.
