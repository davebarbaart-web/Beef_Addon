# Track 33 — Packaging, CI, and Releases (Classic Addons)

**Track id:** `33-packager-ci-releases`  
**Last updated:** 2026-07-25  
**Lane:** Independent research (release engineering only)  
**Maps to:** [Church of Beef V1 design spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §5 (folder layout / filename discipline), §12 (portability), §13 (shippable guild builds)

**Scope:** How Classic addon authors turn a git tree into installable zips and publish them — BigWigs packager, `.pkgmeta`, GitHub Actions workflow YAML, multi-flavor builds, alpha/beta/release typing, and CurseForge / Wago / WoWInterface upload tokens — plus a Beef-shaped release pipeline recommendation.

**Out of scope (owned elsewhere):**

| Topic | Track |
|-------|--------|
| Packaging / community *antipatterns* (zip hygiene, over-embed, bad listing culture) | [05](../05-packaging-community-antipatterns/) |
| Alpha/Beta/Release as a *QA pipe* (WowUp channel UX, tester ladder) | [19 — alpha-channels](../19-testing-debugging-qa/alpha-channels.md) |
| Multi-TOC *verification* on clients | [19 — multi-flavor-toc-testing](../19-testing-debugging-qa/) |
| Anniversary vs Era Interface deltas | [30](../30-anniversary-vs-era-deltas/) |
| CurseForge listing copy / discovery | [31](../31-listing-copy-discovery/) |
| Addon implementation / committing CI into this repo | Not this library |

## Index

| Note | Topic |
|------|--------|
| [01-bigwigs-packager-overview.md](01-bigwigs-packager-overview.md) | What `release.sh` / `BigWigsMods/packager` does |
| [02-pkgmeta-and-workflow-yml.md](02-pkgmeta-and-workflow-yml.md) | `.pkgmeta` vs “packager.yml” / workflow YAML |
| [03-github-actions.md](03-github-actions.md) | Actions workflow patterns, checkout depth, secrets wiring |
| [04-multi-flavor-builds.md](04-multi-flavor-builds.md) | `-S`, `-g`, TOC suffixes, upload game versions |
| [05-channels-and-tokens.md](05-channels-and-tokens.md) | Tag → alpha/beta/release; CF / Wago / WoWI / GitHub tokens |
| [06-beef-release-pipeline.md](06-beef-release-pipeline.md) | Recommended Church of Beef pipeline (phased) |
| [annotated-urls.md](annotated-urls.md) | Curated annotated primary URLs |

## Top insights for Church of Beef

1. **BigWigs packager is the de facto Classic release tool.** Prefer [`BigWigsMods/packager@v2`](https://github.com/BigWigsMods/packager) over hand-rolled `git archive` or CurseForge-hosted packaging alone — it zips, substitutes keywords, embeds externals from `.pkgmeta`, and can upload to CurseForge + Wago + WoWInterface + GitHub Releases in one Action run ([packager README](https://github.com/BigWigsMods/packager); [Wowpedia HOWTO](https://wowpedia.fandom.com/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions)).

2. **“packager.yml” usually means the GitHub Actions workflow.** The packager’s real config file is **`.pkgmeta`** (YAML PackageMeta). Workflow files are commonly `.github/workflows/release.yml` (or a synonym like `packager.yml` / `package-addon.yml`) — they only *invoke* the Action ([wiki: GitHub Actions workflow](https://github.com/BigWigsMods/packager/wiki/GitHub-Actions-workflow)).

3. **V1 Beef can stay off the public hosts.** Spec packages from `addon/ChurchOfBeef/` into `Interface/AddOns/ChurchOfBeef`. Until public distribution matters: local zip / Discord / GitHub Release artifact with packager `-d` (skip upload) or secrets omitted is enough. Wire CF/Wago/WoWI when the guild wants WowUp-style updates ([track 19 channels](../19-testing-debugging-qa/alpha-channels.md)).

4. **Single-flavor Anniversary first; multi-flavor later.** V1 target is TBC Anniversary (`## Interface: 20506` per plan — verify live). Use packager multi-flavor (`-S`, `_TBC.toc`, comma Interface lists) when porting Era/Retail — not as a V1 gate ([wiki TOC](https://warcraft.wiki.gg/wiki/TOC_format); [packager multi-game](https://github.com/BigWigsMods/packager)).

5. **Tags drive release type.** Untagged CI → alpha; tag containing `alpha`/`beta` → that channel; otherwise release. Annotated tags + `fetch-depth: 0` for changelogs. WoWInterface historically uploads **releases only** ([CF Automatic Packaging](https://support.curseforge.com/support/solutions/articles/9000197281-automatic-packaging); [Kemayo Classic packaging](https://davidlynch.org/blog/2019/09/world-of-warcraft-classic-addon-packaging/)).

6. **Secrets never live in the repo.** `CF_API_KEY` / `WAGO_API_TOKEN` / `WOWI_API_TOKEN` (+ `GITHUB_OAUTH` ← `GITHUB_TOKEN` with contents write) belong in GitHub Actions secrets; project IDs go in TOC `X-Curse-Project-ID` / `X-Wago-ID` / `X-WoWI-ID` ([Wago docs](https://docs.wago.io/); [packager README uploading](https://github.com/BigWigsMods/packager)).

7. **Monorepo gotcha:** packager assumes the addon root *is* the checkout (or `-t` / `package-as` / `move-folders`). Beef’s `addon/ChurchOfBeef/` layout needs an explicit topdir or PackageMeta so the zip root is `ChurchOfBeef/`, not the whole research repo ([`.pkgmeta` wiki](https://github.com/BigWigsMods/packager/wiki/Preparing-the-PackageMeta-File); design spec §5).

## Provenance

Scraped search/extract JSON under [`.raw/`](.raw/). Prefer BigWigs packager README/wiki, CurseForge support, Wago docs, Warcraft Wiki over listicles.
