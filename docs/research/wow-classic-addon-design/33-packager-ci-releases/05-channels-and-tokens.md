# Release Channels & Host Tokens

**Last updated:** 2026-07-25  
**Track:** [33-packager-ci-releases](README.md)

**Boundary:** Consumer/QA channel behavior (WowUp Stable/Alpha/Beta UX) is documented in [track 19 — alpha-channels](../19-testing-debugging-qa/alpha-channels.md). This note covers **how CI marks a build** and **which secrets upload it**.

---

## 1. How a build becomes Alpha / Beta / Release

CurseForge Automatic Packaging rules (mirrored by BigWigs packager heuristics) ([CF Automatic Packaging](https://support.curseforge.com/support/solutions/articles/9000197281-automatic-packaging); [track 19](../19-testing-debugging-qa/alpha-channels.md)):

| Git state | File type |
|-----------|-----------|
| Untagged commit packaged by CI | **Alpha** |
| Tag containing `alpha` (e.g. `1.0-alpha`, `1.0.alpha7`) | **Alpha** |
| Tag containing `beta` | **Beta** |
| Other tags | **Release** |

Wago’s manual API uses explicit `stability`: `stable` | `beta` | `alpha` ([Wago docs](https://docs.wago.io/)). Packager maps build type when uploading.

**WoWInterface:** release uploads on tags; alphas generally do not go to WoWI ([Kemayo](https://davidlynch.org/blog/2019/09/world-of-warcraft-classic-addon-packaging/)).

**GitHub Releases:** created when packager has OAuth + permissions; prerelease flags follow packager’s release-type detection ([README](https://github.com/BigWigsMods/packager)).

### Author practice

| Intent | Do this |
|--------|---------|
| Officer smoke build | Push main (alpha) or tag `v0.1.0-alpha.N` |
| Soft guild preview | Tag `v0.9.0-beta.1` |
| Guild-night “live” | Tag `v1.0.0` (no alpha/beta substring) |
| Hotfix after live | `v1.0.1` release tag — avoid overloading alpha |

Use **annotated** tags (`git tag -a`) ([wiki](https://github.com/BigWigsMods/packager/wiki/GitHub-Actions-workflow)).

---

## 2. Environment variables / secrets

Documented by packager README and Wago ([Uploading section](https://github.com/BigWigsMods/packager); [docs.wago.io](https://docs.wago.io/); [Wowpedia](https://wowpedia.fandom.com/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions)):

| Env var | Secret name (typical) | Obtain |
|---------|----------------------|--------|
| `CF_API_KEY` | `CF_API_KEY` | CurseForge / WowAce API tokens ([wow.curseforge.com/account/api-tokens](https://wow.curseforge.com/account/api-tokens); authors portal also lists tokens) |
| `WOWI_API_TOKEN` | `WOWI_API_TOKEN` | [WoWI API tokens](https://www.wowinterface.com/downloads/filecpl.php?action=apitokens) |
| `WAGO_API_TOKEN` | `WAGO_API_TOKEN` | [Wago API keys](https://addons.wago.io/account/apikeys) — send as `Authorization: Bearer …` |
| `GITHUB_OAUTH` | usually `${{ secrets.GITHUB_TOKEN }}` | Built-in; needs contents write for Releases |

### Naming drift warning

Some marketplace/README snippets mention `CF_API_TOKEN` / `GITHUB_API_TOKEN` ([marketplace page excerpts](https://github.com/marketplace/actions/wow-packager)). Wiki + Wowpedia examples standardize on **`CF_API_KEY`** and **`GITHUB_OAUTH`**. When implementing, **read the pinned `@v2` README for the env names that version actually reads** — do not mix both styles in one workflow.

Local runs: packager may load `.env` from topdir ([README](https://github.com/BigWigsMods/packager)). Gitignore it.

---

## 3. Project IDs vs API tokens

| Kind | Lives in | Secret? |
|------|----------|---------|
| `X-Curse-Project-ID` / `X-WoWI-ID` / `X-Wago-ID` | TOC (committed) | No — public identifiers |
| API tokens | GitHub Actions secrets / `.env` | **Yes** |

Wago: add `## X-Wago-ID: as3Dfg57` then set `WAGO_API_TOKEN` in the Action env ([docs.wago.io](https://docs.wago.io/)).

---

## 4. Host selection matrix for Beef

| Host | When to enable | Token cost |
|------|----------------|------------|
| **GitHub Releases** | Day one for officer zip distribution | `GITHUB_TOKEN` only |
| **CurseForge** | When guild wants CurseForge App / WowUp CF provider | `CF_API_KEY` + project id |
| **Wago Addons** | Parallel discovery; WowUp/Wago users | `WAGO_API_TOKEN` + Wago id |
| **WoWInterface** | Optional; Classic authors still use it | `WOWI_API_TOKEN` + WoWI id; release tags only |

V1 can ship **GitHub-only** indefinitely; public hosts are product distribution choices, not engine requirements ([spec §5 packaging path](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)).

---

## 5. Security checklist

- Never commit tokens, `.env`, or Action logs that echo secrets
- Rotate CF/Wago/WoWI tokens if a fork/PR from an untrusted collaborator could read Actions logs with debug enabled
- Prefer environment/repo secrets over org-wide secrets until multiple addons share them
- `-d` dry-run in PR workflows so forks cannot upload to your CurseForge project
