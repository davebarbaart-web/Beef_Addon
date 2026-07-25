# Track 42 — Soft dependencies, embeds, library vendoring

**Track id:** `42-soft-deps-embeds`  
**Last updated:** 2026-07-25  
**Sole focus:** Dependency *strategy* for Church of Beef — TOC soft/hard deps, `X-Embeds`, LibStub etiquette, packager externals vs committed vendor copies, version-conflict realities.  
**Out of scope:** Ace3 module/options deep-dive ([03-ace-libs-options](../03-ace-libs-options/), root sketch [04-ace3-and-libraries.md](../04-ace3-and-libraries.md)); packager CI, tags, multi-flavor upload ([33-packager-ci-releases](../33-packager-ci-releases/)); BeefNet payload design ([14](../14-addon-messaging-beefnet/)). No addon implementation in this folder.

## Product truth (from V1 spec / plan)

| Locked default | Value |
|----------------|-------|
| V1 UI stack | Plain Classic frames; Ace optional later |
| Solo load | Addon must work without hard `## Dependencies` |
| Minimap | Required; LibDBIcon preferred *when* embedding begins |
| Net pacing | ChatThrottleLib-style throttle (embed or equivalent shim) |
| Media | No LibSharedMedia / ElvUI requirement in V1 |

Sources: [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md); synthesis [00 § steal/avoid](../00-church-of-beef-implications.md).

## Index

| Note | Covers |
|------|--------|
| [toc-soft-hard-deps.md](toc-soft-hard-deps.md) | `Dependencies` vs `OptionalDeps` vs `X-Embeds` vs LoadWith — load order, not packaging |
| [libstub-etiquette-conflicts.md](libstub-etiquette-conflicts.md) | LibStub include rules, upgrade semantics, conflict footguns |
| [externals-vs-vendor.md](externals-vs-vendor.md) | `.pkgmeta` externals vs hard-vendored `Libs/`, nolib, CF listing deps |
| [beef-v1-dependency-policy.md](beef-v1-dependency-policy.md) | Concrete Beef V1 allow/deny matrix and adoption triggers |
| [annotated-urls.md](annotated-urls.md) | Primary URLs with steal/adapt notes |

## Top insights for Beef (read this first)

1. **Hard `## Dependencies` is a product footgun for guild tools.** Missing parent → addon disabled. V1 ships solo: embed or feature-detect; never require Ace3 / LibDBIcon / CTL as hard deps.

2. **`OptionalDeps` is load-order, not “download this.”** It only asks the client to load listed addons *first if present*. Soft integration (Masque, LSM, standalone Ace3) still needs nil-checks. Pair with `## X-Embeds:` when you ship embeds so updaters/nolib users know what you ship.

3. **LibStub etiquette is non-negotiable once any shared lib lands.** Load LibStub before other embeds; never list LibStub as `OptionalDeps` / `X-Embeds`; libraries early-return when `NewLibrary` yields nil (newer/same already live). Highest minor wins **globally** across all addons — do not put Beef-private state inside a shared LibStub table.

4. **Externals ≠ vendor copy ≠ CurseForge “dependencies.”** Packager `externals:` checkout into the zip at build time; committed `Libs/` is a hard vendor; `.pkgmeta` `required-dependencies` / `optional-dependencies` only decorate the *store listing* and do not inject files. Prefer externals for release once packaging exists; keep git clean of churning third-party trees when possible.

5. **nolib is a distribution niche, not a V1 requirement.** CurseForge’s older packager docs default nolib on; BigWigs packager defaults it **off**. For a thin embed list (CTL ± LibDBIcon ± LibStub), ship the full zip; enable nolib only if you deliberately support “standalone Ace3 + nolib Beef.”

6. **Adoption trigger, not shopping list.** V1 can ship zero LibStub embeds (hand-rolled minimap + simple outbound queue). First embed candidates, in order: **LibStub → ChatThrottleLib (or tiny CTL-equivalent) → LibDataBroker + LibDBIcon**. Full Ace3 stays a V2 options/profiles decision (track 03).

## Boundary with sibling tracks

| Topic | This track | Sibling |
|-------|------------|---------|
| AceConfig / AceDB / AceAddon APIs | Mention only as embed candidates | **03** |
| CI, tags, upload tokens, multi-TOC builds | `.pkgmeta` *dependency* keys only | **33** |
| CTL budgets / BeefNet pacing numbers | “Must pace somehow” | **14** |
| Packaging antipatterns / store UX | Soft-dep strategy only | **05** |

## Provenance

Scraped search/extract artifacts live under [`.raw/`](.raw/) and [`.firecrawl/`](.firecrawl/). Prefer Warcraft Wiki / WowAce / BigWigs packager wiki / LibStub project docs over listicles.
