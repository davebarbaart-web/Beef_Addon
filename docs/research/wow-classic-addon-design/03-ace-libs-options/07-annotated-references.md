# Annotated References — Ace / LibStub / LSM / Options / Profiles

**Last updated:** 2026-07-25  
**Local mirrors:** [`.firecrawl/`](.firecrawl/) (Firecrawl), [`.raw/ace3-libs-options-deep.md`](.raw/ace3-libs-options-deep.md) (Parallel deep research)

Relevance tags: **CoB** = Church of Beef decision impact; **API** = primary contract; **UX** = player-facing norms; **Pkg** = packaging/embed.

---

## Ace3 core

| URL | Relevance |
|-----|-----------|
| https://www.wowace.com/projects/ace3 | **Pkg** — Ace3 project hub; files for Classic/Retail builds |
| https://www.wowace.com/projects/ace3/pages/getting-started | **API / CoB** — Lifecycle, embeds.xml, AceDB init timing, AceConfig registration, AceDBOptions one-liner, AceEvent/AceComm overview. Primary “how Ace addons are shaped” doc |
| https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables | **API / UX / CoB** — Full options table schema (`confirm`, `hidden`, `childGroups`, widget types). Steal patterns for officer settings and destructive confirms |
| https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0 | **API / CoB** — Scope list; **correct** `New(tbl, defaults, defaultProfile)` semantics (`true` → shared `"Default"` profile) |
| https://www.wowace.com/projects/ace3/pages/ace-db-3-0-tutorial | **API / CoB** — SavedVariables timing, defaults/`['*']`, working with `profile` vs `char` |
| https://www.wowace.com/projects/ace3/pages/api/ace-dboptions-3-0 | **UX / CoB** — `GetOptionsTable(db)` standard Profiles UI block |
| https://warcraft.wiki.gg/wiki/Ace3_for_Dummies | **UX** — End-to-end WelcomeHome tutorial; OptionalDeps + SavedVariables + Blizzard options; reminder Ace is optional |
| https://www.curseforge.com/wow/addons/ace3 | **Pkg** — Distribution mirror / version matrix |

---

## LibStub and embedding

| URL | Relevance |
|-----|-----------|
| https://www.curseforge.com/wow/addons/libstub | **API / Pkg** — Canonical LibStub distribution |
| https://www.wowace.com/projects/ace3/pages/getting-started#title-1-2 | **Pkg** — embeds.xml convention (LibStub first) |

---

## LibSharedMedia and media widgets

| URL | Relevance |
|-----|-----------|
| https://www.wowace.com/projects/libsharedmedia-3-0 | **Pkg** — LSM project; still releasing (scraped Jul 2026 files) |
| https://www.wowace.com/projects/libsharedmedia-3-0/pages/api-documentation | **API / CoB** — Register/Fetch, media types, Registered/SetGlobal callbacks; guides soft-dep fallback design (§10) |
| https://www.wowace.com/projects/ace-gui-3-0-shared-media-widgets | **UX** — AceConfig dropdowns bound to LSM hashes (font/statusbar pickers) |

---

## Minimap / broker

| URL | Relevance |
|-----|-----------|
| https://www.wowace.com/projects/libdbicon-1-0 | **UX / CoB** — De facto minimap button lib; pairs with LibDataBroker; hide/lock in DB |

---

## Design context (in-repo)

| Path | Relevance |
|------|-----------|
| [Church of Beef V1 design spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) | Authority for per-char SV, `/beef` UI, officer rank-index gate, BeefNet |
| [Parent track 04-ace3-and-libraries.md](../04-ace3-and-libraries.md) | Shorter sibling summary; this folder is the deep dive |
| [Parent track 05-persistence-and-profiles.md](../05-persistence-and-profiles.md) | TOC SV vs AceDB vocabulary overlap |

---

## Deep research artifact

| Path / URL | Relevance |
|------------|-----------|
| [.raw/ace3-libs-options-deep.md](.raw/ace3-libs-options-deep.md) | Landscape synthesis (Ace modules, LSM, LibDBIcon, reference addons). **Verify AceDB third-arg claims against WowAce API** |
| https://platform.parallel.ai/play/deep-research/trun_91f36069f0964480b242772dcf1e9943 | Run record for the 2026-07-25 `pro-fast` research job |

---

## Secondary / caution

| URL | Note |
|-----|------|
| WowInterface / Wowhead SharedMedia forum threads | Useful for player-facing SharedMedia pack confusion; not API authority |
| Fandom Wowpedia Ace3 mirrors | Prefer warcraft.wiki.gg copies when they diverge |
| Deep-research officer-API list (`CanEditOfficerNote`, etc.) | Useful Blizzard capability survey; **CoB commit authority is rank-index per spec §6.2**, not note-edit alone |
