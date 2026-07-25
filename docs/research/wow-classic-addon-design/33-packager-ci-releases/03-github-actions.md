# GitHub Actions for Classic Addon Releases

**Last updated:** 2026-07-25  
**Track:** [33-packager-ci-releases](README.md)

---

## 1. Why Actions (vs Travis / manual zip)

The ecosystem moved from Travis curl-of-`release.sh` to the marketplace Action ([Kemayo — Actions sequel](https://davidlynch.org/blog/2020/09/world-of-warcraft-addon-packaging-but-with-github-actions-this-time/); [Wowpedia HOWTO](https://wowpedia.fandom.com/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions)). Benefits for Beef-like projects:

- Secrets stay in GitHub, not developer laptops
- Same zip consumers get whether they use CurseForge, Wago, WoWI, or GitHub Releases
- Tag push = intentional release; branch push = optional continuous alpha

---

## 2. Recommended job shape

From the [official wiki example](https://github.com/BigWigsMods/packager/wiki/GitHub-Actions-workflow):

1. **`actions/checkout@v4`** with **`fetch-depth: 0`** — required so packager can walk tags and build a changelog.
2. **`BigWigsMods/packager@v2`** — pin major; bump deliberately.
3. **Env block** at job level mapping secrets (see [05-channels-and-tokens.md](05-channels-and-tokens.md)).
4. **Permissions:** auto `GITHUB_TOKEN` needs **read-write contents** (or equivalent) for GitHub Releases ([wiki Important note](https://github.com/BigWigsMods/packager/wiki/GitHub-Actions-workflow); [Wowpedia](https://wowpedia.fandom.com/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions)).

### Trigger patterns

| Trigger | Typical use |
|---------|-------------|
| `push.tags: ['**']` | Release / beta / alpha *tagged* builds (wiki default) |
| `push.branches: [main]` | Continuous alpha to CurseForge (Kemayo / CF convention) |
| `workflow_dispatch` | Manual “cut a zip” without a host upload (Pawn-style) ([Blizzard forum](https://us.forums.blizzard.com/en/wow/t/creating-addon-releases-with-github-actions/613424)) |

Beef V1 recommendation: start with **`workflow_dispatch` + tag releases**, add branch alphas only when officer testers use WowUp Alpha ([track 19](../19-testing-debugging-qa/alpha-channels.md)).

---

## 3. Passing args to the Action

```yaml
- uses: BigWigsMods/packager@v2
  with:
    args: -p 1234 -w 5678 -a he54k6bL
```

([README example](https://github.com/BigWigsMods/packager); [marketplace](https://github.com/marketplace/actions/wow-packager))

Monorepo / Beef:

```yaml
args: -t addon/ChurchOfBeef -d
```

`-d` = package + (optionally) GitHub Release without CF/Wago/WoWI until secrets exist.

Multi-step flavor matrix (wiki pattern):

```yaml
- uses: BigWigsMods/packager@v2
- uses: BigWigsMods/packager@v2
  with:
    args: -g wrath -w 0
```

Second job skips WoWI when that host cannot share a multi-flavor project ([Kemayo Classic packaging](https://davidlynch.org/blog/2019/09/world-of-warcraft-classic-addon-packaging/) — WoWI historically wants separate addon entries per client family).

---

## 4. Local dry-run parity

Authors can run `release.sh` locally with the same flags; packager loads a `.env` in topdir/cwd for tokens ([README Uploading](https://github.com/BigWigsMods/packager)). Never commit `.env`. Dependencies: bash ≥ 4.3, zip, curl, git ≥ 2.13, jq when uploading, optional pandoc ([README Dependencies](https://github.com/BigWigsMods/packager)).

CI should be the source of truth for “what players get”; local runs are for debugging PackageMeta ignore lists.

---

## 5. Failure modes worth baking into runbooks

| Symptom | Likely cause |
|---------|----------------|
| Changelog empty / wrong version | Shallow clone (`fetch-depth` default 1) |
| Workflow didn’t run on first tag | Workflow file introduced in same push as tag ([Wowpedia](https://wowpedia.fandom.com/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions)) |
| GitHub Release missing | `GITHUB_TOKEN` permissions too narrow |
| CF upload 401 | Expired/missing `CF_API_KEY`; wrong project id |
| Zip root wrong (`Beef_Addon/` or nested junk) | Missing `-t` / `package-as`; `ignore:` incomplete |
| Anniversary users see wrong build | Flavor tags / TOC Interface mismatch ([CF Multi-TOC](https://support.curseforge.com/support/solutions/articles/9000209856-multi-toc-for-world-of-warcraft-addons)) |

---

## 6. Optional pre-steps (keep thin)

Acceptable *before* packager:

- `luacheck` / syntax smoke (QA track)
- Ensure `## Interface` matches live Anniversary build (verify with `/dump select(4, GetBuildInfo())` culture — [TOC wiki](https://warcraft.wiki.gg/wiki/TOC_format))

Do **not** turn the release workflow into a full test matrix for BeefNet; keep guild/net QA on characters ([track 19](../19-testing-debugging-qa/)).
