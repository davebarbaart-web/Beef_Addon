# Annotated URLs — Packager, CI, Releases

**Last updated:** 2026-07-25  
**Track:** [33-packager-ci-releases](README.md)

Steal / adapt notes are for Church of Beef release engineering. Prefer these primaries over listicles.

---

## Packager core

| URL | Why it matters | Steal / adapt |
|-----|----------------|---------------|
| https://github.com/BigWigsMods/packager | Canonical `release.sh` + Action source | Pin `@v2`; treat README as env-var source of truth |
| https://github.com/marketplace/actions/wow-packager | Marketplace entry / version tags | Confirm latest v2.x before first workflow |
| https://github.com/BigWigsMods/packager/wiki/GitHub-Actions-workflow | Official workflow YAML + secrets wiring | Copy structure; add `-t addon/ChurchOfBeef` for monorepo |
| https://github.com/BigWigsMods/packager/wiki/Preparing-the-PackageMeta-File | `.pkgmeta` directives | `package-as`, `ignore`, optional `manual-changelog` |
| https://github.com/BigWigsMods/packager/wiki/Repository-Keyword-Substitutions | `@project-version@`, `@alpha@`, do-not-package | Version TOC from tags; alpha-only asserts |
| https://github.com/BigWigsMods/packager/wiki/Localization-Substitution | `@localization@` (Curse locale portal) | Skip until multi-locale shipping (track 18) |
| https://github.com/BigWigsMods/packager/releases | Changelog for Interface comma-lists, upload behavior | Read before upgrading Action minor |

---

## Tutorials & practice notes

| URL | Why it matters | Steal / adapt |
|-----|----------------|---------------|
| https://wowpedia.fandom.com/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions | End-to-end HOWTO (TOC ids, secrets, `-S`, first-tag gotcha) | Best narrative onboarding; verify env names against current README |
| https://davidlynch.org/blog/2019/09/world-of-warcraft-classic-addon-packaging/ | Classic dual-build history; WoWI limits; Travis-era patterns | Keep conceptual; prefer Actions sequel for YAML |
| https://davidlynch.org/blog/2020/09/world-of-warcraft-addon-packaging-but-with-github-actions-this-time/ | Early Actions + env example | Historical `CF_API_KEY` / `GITHUB_OAUTH` shape |
| https://us.forums.blizzard.com/en/wow/t/creating-addon-releases-with-github-actions/613424 | Alternative `workflow_dispatch` packaging (Pawn) | Useful if Beef wants manual zip without host upload |
| https://www.wowinterface.com/forums/showthread.php?t=55801 | Community “automagic package & publish” guide | Cross-check against current BigWigs docs |

---

## Hosts, channels, tokens

| URL | Why it matters | Steal / adapt |
|-----|----------------|---------------|
| https://support.curseforge.com/support/solutions/articles/9000197281-automatic-packaging | Untagged=alpha; tag heuristics; `@alpha@` blocks | Align Beef tag names with CF/WowUp channels |
| https://support.curseforge.com/support/solutions/articles/9000209856-multi-toc-for-world-of-warcraft-addons | Multi-TOC + flavor tagging on CF | Phase 3 ports only |
| https://wow.curseforge.com/account/api-tokens | CurseForge API token minting | Store as `CF_API_KEY` secret |
| https://authors.curseforge.com/#/settings/api-tokens | Alternate authors-portal token UI | Same secret; don’t commit |
| https://docs.wago.io/ | Wago auth, BigWigs integration, stability enum, patch fields | Phase 2 parallel host |
| https://addons.wago.io/account/apikeys | Wago API key minting | `WAGO_API_TOKEN` |
| https://addons.wago.io/developers | Wago project id (X-Wago-ID) | Commit id in TOC; keep token secret |
| https://www.wowinterface.com/downloads/filecpl.php?action=apitokens | WoWI API tokens | Phase 3 optional; release tags |
| https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions | How to store Action secrets | Repo Settings → Secrets |
| https://wowup.io/guide/my-addons/addons | WowUp per-addon channel UX | Pointer only — detail in track 19 |

---

## TOC / Interface (packaging constraints)

| URL | Why it matters | Steal / adapt |
|-----|----------------|---------------|
| https://warcraft.wiki.gg/wiki/TOC_format | Suffixes (`_TBC`, etc.), Interface tables, Anniversary notes | V1 single TOC; verify Interface live |
| https://github.com/Stanzilla/WoWUIBugs/issues/68 | Original multi-Interface support discussion | Background for `-S` / multi-TOC |
| https://github.com/BigWigsMods/packager/pull/107 | Packager TOC-suffix / game-version evolution | Why `-g` is less central now |

---

## Related library tracks (do not duplicate)

| URL (repo-relative) | Owns |
|---------------------|------|
| [../19-testing-debugging-qa/alpha-channels.md](../19-testing-debugging-qa/alpha-channels.md) | Tester-facing Alpha/Beta/Release |
| [../05-packaging-community-antipatterns/](../05-packaging-community-antipatterns/) | Antipatterns / community packaging culture |
| [../30-anniversary-vs-era-deltas/](../30-anniversary-vs-era-deltas/) | Client delta research |
| [../31-listing-copy-discovery/](../31-listing-copy-discovery/) | Store listing copy |

---

## Provenance dumps

Raw search/extract JSON for this track:

- [`.raw/search-packager-overview.json`](.raw/search-packager-overview.json)
- [`.raw/search-multi-flavor.json`](.raw/search-multi-flavor.json)
- [`.raw/search-channels-tokens.json`](.raw/search-channels-tokens.json)
- [`.raw/search-packager-yml.json`](.raw/search-packager-yml.json)
- [`.raw/extract-packager-readme.json`](.raw/extract-packager-readme.json)
- [`.raw/extract-cf-wowi.json`](.raw/extract-cf-wowi.json)
- [`.raw/extract-wiki-pkgmeta.json`](.raw/extract-wiki-pkgmeta.json)
