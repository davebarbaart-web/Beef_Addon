# Track 03 — Ace3 / LibStub / LibSharedMedia / Options UI / Profiles

**Date:** 2026-07-25  
**Scope:** Architecture and UX knowledge for Church of Beef. Design research only — no addon implementation in this folder.  
**Design context:** [Church of Beef V1 design spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)  
**Parent library:** [../README.md](../README.md)

## Documents in this track

| Doc | Topic |
|-----|--------|
| [01-ace3-conventions.md](01-ace3-conventions.md) | AceAddon lifecycle, embeds, modules, mixin model |
| [02-libstub-ecosystem.md](02-libstub-ecosystem.md) | LibStub versioning, embedding, OptionalDeps, pkgmeta |
| [03-libsharedmedia.md](03-libsharedmedia.md) | LibSharedMedia types, Register/Fetch, soft-deps |
| [04-acedb-and-profiles.md](04-acedb-and-profiles.md) | AceDB scopes, profile UX, vs TOC SavedVariables |
| [05-options-ui-norms.md](05-options-ui-norms.md) | AceConfig tables, AceDBOptions, Classic options norms |
| [06-implications-for-church-of-beef.md](06-implications-for-church-of-beef.md) | Mapped recommendations for V1 / later Ace adoption |
| [07-annotated-references.md](07-annotated-references.md) | Annotated URLs with CoB relevance |

## Provenance

| Path | Contents |
|------|----------|
| [`.firecrawl/`](.firecrawl/) | Firecrawl scrapes of WowAce / wiki / CurseForge primaries |
| [`.raw/ace3-libs-options-deep.md`](.raw/ace3-libs-options-deep.md) | Parallel deep-research synthesis (processor `pro-fast`) |
| [`.raw/ace3-libs-options-deep.json`](.raw/ace3-libs-options-deep.json) | Deep-research metadata + basis citations |

**Note on deep-research:** the parallel report is useful for landscape framing but **misstates** AceDB’s third `New()` argument (`true` means shared profile `"Default"`, not per-character SV). Prefer the AceDB API scrape and [04-acedb-and-profiles.md](04-acedb-and-profiles.md) for that fact.

## One-line verdict for CoB

V1 can ship plain Classic frames + `SavedVariablesPerCharacter` as the design spec states; treat Ace3 as the **de facto upgrade path** for options panels, named UI profiles, LibDBIcon minimap, and AceComm-style messaging — plan data shape now so a later AceDB migration is a storage rewrite, not a product rewrite.
