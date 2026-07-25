# Annotated URLs — soft deps, embeds, vendoring

**Last updated:** 2026-07-25  
**Track:** [42-soft-deps-embeds](README.md)

Steal/adapt notes are for **Church of Beef dependency strategy**, not for Ace options UX (track 03) or CI recipes (track 33).

---

## TOC load-order and soft/hard deps

| URL | Annotation |
|-----|------------|
| https://warcraft.wiki.gg/wiki/TOC_format | Canonical `Dependencies` / `OptionalDeps` / `LoadWith` semantics — hard deps disable the addon; soft deps only reorder if present. |
| https://wowwiki-archive.fandom.com/wiki/Creating_AddOn_dependencies | Classic HOWTO: document deps; optional peers must be error-handled; still accurate as strategy culture. |
| https://warcraft.wiki.gg/wiki/WelcomeHome:_Your_first_Ace3_Addon | `OptionalDeps: Ace3` + `X-Embeds: Ace3` + `embeds.xml` pattern explained in plain language. |
| https://www.wowace.com/projects/ace3/pages/getting-started | Why `embeds.xml` exists; LibStub-first include order; modular Ace (pick only what you need). |

---

## LibStub etiquette and conflicts

| URL | Annotation |
|-----|------------|
| https://www.curseforge.com/wow/addons/libstub | Primary LibStub distribution + API; public domain; include rules (no OptDep/X-Embeds for LibStub). |
| https://www.wowace.com/projects/libstub | WowAce project home / externals target culture. |
| https://wowpedia.fandom.com/wiki/LibStub | Mirror summary of registry behavior for offline reading. |
| https://us.forums.blizzard.com/en/wow/t/embedded-library-woes/1610075 | Practitioner thread: highest minor wins globally; LibStub is not per-addon instances; private state must not live in the shared lib table. |
| https://us.forums.blizzard.com/en/wow/t/libstub-versioning/1599572 | Versioning discussion companion to the above. |
| https://www.reddit.com/r/wow/comments/v9hlho/please_help_me_figure_out_this_lua_error/ | Field failure: author forgot to embed LibStub because their other addons already had it — clean-install QA lesson. |

---

## Packager externals, vendor, nolib, store listing

| URL | Annotation |
|-----|------------|
| https://github.com/BigWigsMods/packager/wiki/Preparing-the-PackageMeta-File | **Primary** `.pkgmeta` reference: `externals`, `embedded-libraries`, listing deps, nolib **default off**, ignore/move-folders. |
| https://support.curseforge.com/en/support/solutions/articles/9000197952-preparing-the-packagemeta-file | CurseForge PackageMeta: same concepts; note historical **nolib default on** — reconcile with BigWigs defaults when choosing packager. |
| https://github.com/BigWigsMods/packager | Packager overview: externals checkout into release dir; `-e` skip externals; `{nolib}` filename flag. CI details → track 33. |
| https://support.curseforge.com/en/support/solutions/articles/9000197281-automatic-packaging | CF automatic packaging context (channels/tags); use when wiring externals to releases — process depth in 33 / 19. |
| https://www.wowinterface.com/forums/showthread.php?t=58078 | Community packaging help: “use `.pkgmeta` externals with CF/BigWigs packager” for LibStub/LSM-class libs. |

---

## Soft-integration targets (feature-detect only in V1)

| URL | Annotation |
|-----|------------|
| https://www.wowace.com/projects/chatthrottlelib | CTL project — first serious embed candidate for BeefNet pacing (budgets in track 14). |
| https://www.wowace.com/projects/libdbicon-1-0 | LibDBIcon — minimap standard when collectors force the issue (UX in track 28). |
| https://www.curseforge.com/wow/addons/ace3 | Ace3 distribution presence; soft OptionalDeps target **if** Ace embeds land — not a V1 hard requirement. |
| https://www.wowace.com/addons/libraries | Library catalog for discovering majors/slugs when expanding embeds. |

---

## Product truth (repo)

| Path | Why |
|------|-----|
| [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) | Plain frames V1; CTL-style pacing; minimap required. |
| [`docs/research/wow-classic-addon-design/00-church-of-beef-implications.md`](../00-church-of-beef-implications.md) | Steal LibDBIcon/CTL when embedding; avoid hard Dependencies. |
| [`docs/research/wow-classic-addon-design/04-ace3-and-libraries.md`](../04-ace3-and-libraries.md) | Flat sketch of Ace/embed layout — superseded in depth by tracks 03 + **42**. |
| [`beef-v1-dependency-policy.md`](beef-v1-dependency-policy.md) | This track’s concrete allow/deny matrix. |

---

## Deliberately not primary here

| URL / topic | Better track |
|-------------|--------------|
| AceConfig options tables, AceDB lifecycle | **03** / `04-ace3-and-libraries.md` |
| GitHub Actions packager workflows, multi-flavor `-S` | **33** |
| CTL CPS / GUILD throttle budgets | **14** |
| Packaging antipatterns / store discovery copy | **05** / **31** |
