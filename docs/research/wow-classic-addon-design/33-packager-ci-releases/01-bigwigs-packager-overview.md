# BigWigs Packager Overview

**Last updated:** 2026-07-25  
**Track:** [33-packager-ci-releases](README.md)

---

## 1. What it is

[`BigWigsMods/packager`](https://github.com/BigWigsMods/packager) is a POSIX shell tool (`release.sh`) published as a [GitHub Action (“WoW Packager”)](https://github.com/marketplace/actions/wow-packager). It:

1. Creates a staging dir (default `.release/`)
2. Copies project files (honoring `.pkgmeta` ignore / plain-copy rules)
3. Checks out **externals** (embedded libs from Git/SVN/Hg URLs)
4. Applies **keyword substitutions** (`@project-version@`, `@alpha@` blocks, localization tokens, etc.)
5. Optionally **splits multi-game TOC** metadata (`-S`)
6. Zips a distributable addon folder
7. Optionally **uploads** to CurseForge, WoWInterface, Wago Addons, and GitHub Releases

Community consensus treats it as the successor path when CurseForge-hosted packaging alone is too limited (especially multi-flavor / multi-host) ([Wowpedia HOWTO](https://wowpedia.fandom.com/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions); [Kemayo — Classic packaging](https://davidlynch.org/blog/2019/09/world-of-warcraft-classic-addon-packaging/)).

---

## 2. Versioning model

Packager assumes **annotated git tags are version numbers** ([README](https://github.com/BigWigsMods/packager)):

- If HEAD is tagged → that tag is `{project-version}`
- Otherwise → short revision / approximate version (alpha builds)
- Changelog = commits since previous tag (needs full history in CI)

Default zip name template:

`{package-name}-{project-version}{nolib}{classic}`

`{classic}` expands to flavor suffixes like `-classic`, `-bcc`, `-wrath`, `-cata`, `-mists` when building non-retail ([README filename tokens](https://github.com/BigWigsMods/packager)).

---

## 3. Project identity (TOC metadata)

Upload targets can be set via CLI (`-p`, `-w`, `-a`) or TOC lines ([README](https://github.com/BigWigsMods/packager)):

```toc
## X-Curse-Project-ID: 1234
## X-WoWI-ID: 5678
## X-Wago-ID: he54k6bL
```

| ID | Where to find it |
|----|------------------|
| CurseForge project id | Project page “About Project” sidebar |
| WoWInterface id | URL `…/info5678-MyAddon` → `5678` |
| Wago project id | [Developer dashboard](https://addons.wago.io/developers) (8-char alphanumeric under addon name) ([Wago API docs](https://docs.wago.io/)) |

Pass `0` to unset a TOC id for a specific packager invocation (e.g. `-w 0` to skip WoWI on one flavor job) ([wiki workflow](https://github.com/BigWigsMods/packager/wiki/GitHub-Actions-workflow)).

---

## 4. Useful CLI flags (release engineering)

From packager usage docs ([README](https://github.com/BigWigsMods/packager); [Docker mirror notes](https://hub.docker.com/r/p3lim/wow-packager/)):

| Flag | Meaning |
|------|---------|
| `-d` | Skip upload (package only) |
| `-e` | Skip externals checkout |
| `-s` | Build nolib package |
| `-S` | Multi game-type package from a single TOC (`## Interface-*`) |
| `-g <game>` | Target game version / type for upload (e.g. `wrath`, classic patch string) |
| `-t topdir` | Checkout root containing the addon |
| `-m pkgmeta.yaml` | Alternate PackageMeta path |
| `-n "{template}"` | Zip / label name template |
| `-p` / `-w` / `-a` | Curse / WoWI / Wago ids |

Pin Action major: `uses: BigWigsMods/packager@v2` ([marketplace](https://github.com/marketplace/actions/wow-packager)).

---

## 5. v2.3+ Interface behavior (CI-relevant)

From packager changelog notes ([README](https://github.com/BigWigsMods/packager); [releases](https://github.com/BigWigsMods/packager/releases)):

- `## Interface:` and `## Interface-[Type]:` may be **comma-separated** lists
- Every interface value in every non-external TOC is submitted as a supported version to CurseForge / Wago / WoWI (behavior changed vs older v2.2.2)

Implication: keep TOC Interface lines accurate — packager will advertise whatever you ship.

---

## 6. Relationship to CurseForge Automatic Packaging

CurseForge still documents its own [Automatic Packaging](https://support.curseforge.com/support/solutions/articles/9000197281-automatic-packaging) (untagged = alpha, tag heuristics, `@alpha@` blocks). BigWigs packager **mirrors those keyword/tag conventions** while adding multi-host upload and richer multi-flavor control ([Wowpedia](https://wowpedia.fandom.com/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions); [track 19 channels](../19-testing-debugging-qa/alpha-channels.md) for consumer-facing channel meaning).

Authors who move the repo to GitHub often **disable CurseForge-hosted packaging** and let Actions own the zip ([Kemayo](https://davidlynch.org/blog/2019/09/world-of-warcraft-classic-addon-packaging/)).
