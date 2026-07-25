# `.pkgmeta` vs “packager.yml” (Workflow YAML)

**Last updated:** 2026-07-25  
**Track:** [33-packager-ci-releases](README.md)

---

## 1. Naming trap

People say “packager.yml” in three different ways. Only one of them is the packager’s own config:

| Name people say | Actual file | Role |
|-----------------|-------------|------|
| **PackageMeta / pkgmeta** | `.pkgmeta` (YAML) at project root | Packager config: ignore, externals, package-as, changelog, deps |
| **“packager.yml” / release workflow** | `.github/workflows/release.yml` (or `packager.yml`, `package-addon.yml`, …) | GitHub Actions trigger + secrets + `uses: BigWigsMods/packager@v2` |
| **Action definition** | Upstream `action.yml` inside BigWigsMods/packager | How the marketplace Action wraps `release.sh` — not something authors edit |

Official wiki names the workflow example **`.github/workflows/release.yml`** ([GitHub Actions workflow](https://github.com/BigWigsMods/packager/wiki/GitHub-Actions-workflow)). Other repos use synonyms (e.g. Pawn’s `package-addon.yml` on Blizzard forums) — filename is convention, not a packager schema ([Blizzard UI forum](https://us.forums.blizzard.com/en/wow/t/creating-addon-releases-with-github-actions/613424)).

CLI escape hatch: `-m pkgmeta.yaml` points packager at a non-default PackageMeta path ([README](https://github.com/BigWigsMods/packager)).

---

## 2. `.pkgmeta` — what to put in it

Documented on [Preparing the PackageMeta File](https://github.com/BigWigsMods/packager/wiki/Preparing-the-PackageMeta-File). YAML; **spaces only** (tabs break parse). Dotfiles like `.pkgmeta` are always ignored from the zip.

### High-value directives

| Directive | Use |
|-----------|-----|
| `package-as:` | Force zip root / package name (must match install folder expectations) |
| `ignore:` | Drop `docs/`, tests, scripts, `*.md` not meant for players |
| `externals:` | Pull LibStub / Ace / CTL from WowAce/Curse/Git at package time |
| `move-folders:` | Promote nested module dirs to sibling addons in the zip |
| `manual-changelog:` | Ship `CHANGELOG.md` (plain / html / markdown) instead of auto commit log |
| `required-dependencies` / `optional-dependencies` | CurseForge listing metadata (not files) |
| `embedded-libraries:` | Declare hard-embedded libs for Curse UI even when committed |
| `enable-nolib-creation:` | Also produce a nolib zip |

### Minimal Beef-shaped sketch (conceptual — not implementing)

```yaml
package-as: ChurchOfBeef

ignore:
  - docs
  - .github
  - "**/.raw"
  - "*.md"

# Prefer no Ace externals for V1 unless already embedded (see track 03 / synthesis)
# externals: ...

manual-changelog:
  filename: CHANGELOG.md
  markup-type: markdown
```

Design-spec constraint: zip root must be `ChurchOfBeef/` for `Interface/AddOns/ChurchOfBeef` ([spec §5](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)). In a monorepo, combine `package-as` with Action `args: -t addon/ChurchOfBeef` (or a thin package root) so research docs never land in the player zip.

---

## 3. Workflow YAML — what belongs there

Canonical shape from the [packager wiki](https://github.com/BigWigsMods/packager/wiki/GitHub-Actions-workflow):

- **Trigger:** `on.push.tags: ['**']` for releases; many authors also run on `main` pushes for alphas
- **Runner:** `ubuntu-latest`
- **Env:** map GitHub secrets → packager env vars
- **Steps:** `actions/checkout` with `fetch-depth: 0`, then `BigWigsMods/packager@v2`
- **Optional second step:** another packager invocation with different `-g` / `-w 0` for flavor-specific uploads

Example skeleton (illustrative; copy from wiki when implementing):

```yaml
name: Package and release

on:
  push:
    tags:
      - '**'

jobs:
  release:
    runs-on: ubuntu-latest
    env:
      CF_API_KEY: ${{ secrets.CF_API_KEY }}
      WOWI_API_TOKEN: ${{ secrets.WOWI_API_TOKEN }}
      WAGO_API_TOKEN: ${{ secrets.WAGO_API_TOKEN }}
      GITHUB_OAUTH: ${{ secrets.GITHUB_TOKEN }}
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - uses: BigWigsMods/packager@v2
        # with:
        #   args: -t addon/ChurchOfBeef
```

**Annotated tags required** for proper version detection ([wiki](https://github.com/BigWigsMods/packager/wiki/GitHub-Actions-workflow)).

First-time gotcha (Wowpedia): pushing the workflow file *and* the first tag in the same push may not run the workflow — push the workflow first, then tag ([Wowpedia HOWTO](https://wowpedia.fandom.com/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions)).

---

## 4. Keyword substitutions (packaging-time, not runtime)

Owned in depth by CurseForge docs + packager wiki; CI authors need to know they exist:

| Family | Examples | Why CI cares |
|--------|----------|--------------|
| Version tokens | `@project-version@`, `@project-hash@` | TOC `## Version:` stays correct without hand edits |
| Alpha blocks | `--@alpha@` … `--@end-alpha@` | Extra asserts/logging strip from release/beta ([CF Automatic Packaging](https://support.curseforge.com/support/solutions/articles/9000197281-automatic-packaging)) |
| Debug / do-not-package | `--@debug@`, `--@do-not-package@` | Keep dev-only files out of zips ([keyword wiki](https://github.com/BigWigsMods/packager/wiki/Repository-Keyword-Substitutions)) |
| Retail/non-retail TOC | `#@retail@` / `#@non-retail@` | Older dual-build pattern; multi-TOC / `-S` is the modern cousin |

QA meaning of alpha channel → [track 19](../19-testing-debugging-qa/alpha-channels.md). This track only notes that **packager performs the strip/keep**.

---

## 5. What not to put in workflow YAML

- API tokens in plaintext (use secrets)
- Entire addon source duplication
- Listing marketing copy (track 31)
- Luacheck / unit tests *can* live as prior steps, but they are QA (track 19), not packager config
