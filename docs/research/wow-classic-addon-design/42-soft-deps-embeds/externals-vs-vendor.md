# Packager externals vs vendored Libs/

**Last updated:** 2026-07-25  
**Track:** [42-soft-deps-embeds](README.md)  
**Primary sources:** [Preparing the PackageMeta File — BigWigs packager wiki](https://github.com/BigWigsMods/packager/wiki/Preparing-the-PackageMeta-File), [Preparing the PackageMeta File — CurseForge support](https://support.curseforge.com/en/support/solutions/articles/9000197952-preparing-the-packagemeta-file), [BigWigsMods/packager README](https://github.com/BigWigsMods/packager).

CI workflows, tags, and upload secrets belong in track **33**. This note is only *how libraries get into the zip* and how that interacts with soft deps.

---

## 1. Three different “dependency” mechanisms

| Mechanism | Injects files into zip? | Affects in-game load? | Typical use |
|-----------|-------------------------|-----------------------|-------------|
| TOC `Dependencies` / `OptionalDeps` | No | Yes (order / enablement) | Soft/hard peers |
| Git-committed `Libs/…` (“hard vendor”) | Yes (already in tree) | Only if TOC/`embeds.xml` loads them | Offline dev, tiny forks, libs without reliable remotes |
| `.pkgmeta` `externals:` | Yes (checkout at package time) | Same — must still be listed in embeds | Normal Ace/WowAce library pulls |
| `.pkgmeta` `required-dependencies` / `optional-dependencies` | **No** | No | CurseForge / client **listing** relations |
| `.pkgmeta` `embedded-libraries:` | No (attribution) | No | Credit hard-vendored or third-party-repo libs for CF rewards |

Confusing store listing deps with embed strategy is the most common packaging mistake.

---

## 2. Externals (preferred for release packaging)

Example shape from the BigWigs pkgmeta wiki:

```yaml
externals:
  Libs/LibStub:
    url: https://repos.wowace.com/wow/libstub/trunk
    tag: latest   # or a fixed tag when you need a pin
  Libs/CallbackHandler-1.0:
    url: https://repos.wowace.com/wow/callbackhandler/trunk/CallbackHandler-1.0
    tag: latest
```

Properties that matter for strategy:

- Local path → remote URL (+ `tag` / `branch` / `commit`).
- Packager creates `Libs/` for you; empty folder not required.
- Nested `.pkgmeta` `ignore` on the external is honored.
- `curse-slug` associates third-party git remotes with CurseForge projects when URL alone is not enough.
- Release zip contains checked-out trees; developers may still use `-e` to skip externals locally (packager flag) — see track 33 for workflows.

**Why prefer externals over forever-vendored Ace trees:** minors stay refreshable; LibStub upgrade story stays honest; git history stays about Beef, not Ace diffs.

---

## 3. Hard vendor (committed copies)

Commit library files under `Libs/` when:

- You are pre-packager / manually zipping alphas.
- The dependency is a **tiny** first-party-friendly file you intentionally pin (e.g. a CTL snapshot) and will bump deliberately.
- Upstream has no stable packager-friendly remote (rare for WowAce libs).

Then declare attribution with `embedded-libraries:` (CurseForge slugs) so listing/rewards stay correct even though files are not `externals:`.

**Anti-pattern:** commit a full Ace tree *and* also declare the same paths as externals without a clear “externals win at package time” discipline — reviewers will not know which copy is authoritative.

---

## 4. nolib packages

| Packager | Default nolib behavior |
|----------|------------------------|
| CurseForge PackageMeta docs | Historically **on** — two zips (full + `-nolib`) unless `enable-nolib-creation: no` |
| BigWigs `release.sh` | **Off** unless `enable-nolib-creation: yes`; nolib not uploaded to CurseForge; may attach to GitHub releases |

nolib assumes consumers have standalone library addons (classic Ace3 suite). That is a power-user niche.

**Beef stance:** keep nolib **off** until/unless you explicitly support “nolib Beef + standalone Ace3.” Library-only projects (if Beef ever publishes one) should disable nolib creation per LibStub guidance.

`{nolib}` in zip name templates is a packager filename flag — not a TOC feature (track 33 for naming).

---

## 5. Decision tree for Church of Beef

```
Need a third-party lib at runtime?
├─ No → ship no Libs/; no OptionalDeps/X-Embeds
└─ Yes
   ├─ Is packager/CI in place? (track 33)
   │  ├─ Yes → add externals: + embeds.xml; pin tag if risk-averse
   │  └─ No  → temporary hard vendor under Libs/; plan externals migration
   ├─ Must user install another addon for core features?
   │  ├─ Yes → STOP; redesign (hard Dependencies banned for V1 core)
   │  └─ No  → OptionalDeps only for load-order peers; feature-detect
   └─ Want nolib consumers?
      ├─ Yes → enable-nolib + OptionalDeps/X-Embeds for Ace3; test both zips
      └─ No  → leave nolib disabled (BigWigs default)
```

---

## 6. Practical pin vs floating tags

| Policy | When |
|--------|------|
| `tag: latest` / trunk | Mature WowAce libs (LibStub, CallbackHandler) during active development |
| Fixed tag / commit | Before a guild-wide release freeze; after a bad upstream bump scare |
| Never “latest” without CI | If you cannot smoke-test Anniversary after each package |

Version-conflict risk is mostly **shipping an ancient minor** that loses to a newer broken embed in another addon, or the reverse — see [libstub-etiquette-conflicts.md](libstub-etiquette-conflicts.md). Externals with occasional pins are the middle path.

---

## 7. What this track deliberately leaves to 33

- GitHub Actions `BigWigsMods/packager@v2` recipes  
- CurseForge/Wago/WoWI upload tokens  
- Multi-flavor `-S` / Interface TOC splitting  
- Changelog / `@project-version@` keywords  

Those consume the `.pkgmeta` dependency strategy defined here; they do not replace it.
