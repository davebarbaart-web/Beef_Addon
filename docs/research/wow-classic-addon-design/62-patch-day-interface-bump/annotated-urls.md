# Annotated URLs — patch-day / Interface bump

**Track:** [62-patch-day-interface-bump](README.md)  
**Last updated:** 2026-07-25

Primary URLs for maintainer ops. Prefer these over listicles. Steal/adapt notes are for **runbook behavior**, not packager YAML (→ [33](../33-packager-ci-releases/)) or flavor install trees (→ [30](../30-anniversary-vs-era-deltas/)).

---

## Detect Interface / TOC rules

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://warcraft.wiki.gg/wiki/TOC_format | Canonical `## Interface` out-of-date rules; comma Interfaces; `_TBC` covers Anniversary; **`/dump (select(4, GetBuildInfo()))`** probe. Wiki latest-interfaces table is hint-only (lags). |
| https://wowpedia.fandom.com/wiki/Getting_the_current_interface_number | Author folklore: GetBuildInfo, steal from updated TOC, `lastAddonVersion` in Config.wtf — always re-verify in Anniversary client. |
| https://warcraft.wiki.gg/wiki/Patch_2.5.6/API_changes | Concrete Anniversary ladder: TOC **`20506`**, source diffs, embeds Kaivax UI note — model for “read patch API page + smoke.” |
| https://github.com/p3lim/toc-interface-updater | Optional CI PR signal for Interface moves (`tbc` / `anniversary` aliases). Detect ≠ auto-ship to guild. |

---

## Patch-day player / author behavior

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://warcraft.wiki.gg/wiki/UI_FAQ/AddOns | **Patch Day** section: Load Outdated OK; only *must* update when broken; **do not hand-edit TOC** (destroys diagnostics). Guild-comms doctrine. |
| https://www.wowinterface.com/forums/faq.php?faq=install | Install FAQ still points players at Load Outdated on Character Select — language members recognize. |
| https://us.forums.blizzard.com/en/wow/t/user-interface-updates-in-classic/2325408 | Kaivax 2026-07: Classic shares modern UI code; 2.5.6 nameplates/raid frames; addons may error until authors update; 2.5.6 ≈ lab for 1.15.9 API. Treat UI-sync patches as hotfix-risk. |

---

## CurseForge / managers (Unsupported & versions)

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://support.curseforge.com/en/support/solutions/articles/9000197241-creating-and-submitting-a-project | File upload fields: Changelog, **Supported Version**, Release vs other types; app sync needs a Release file. Clears listing “no version for this game” / Unsupported-class signals. |
| https://support.curseforge.com/support/solutions/articles/9000198422-world-of-warcraft-addons-faq-and-troubleshooting | App warnings (corrupt / wrong flavor / modified). Warning ≠ always broken — but flavor mismatch is the usual “installed Era zip on Anniversary” failure mode. |
| https://support.curseforge.com/support/solutions/articles/9000202351-burning-crusade-classic-troubleshooting | Expansion/pre-patch: outdated icons; wait for author or try running anyway. Player expectation management. |
| https://support.curseforge.com/support/solutions/articles/9000209856-multi-toc-for-world-of-warcraft-addons | Multi-TOC tagging for managers — **out of V1 patch-day scope**; link only so maintainers do not reinvent it under pressure. |
| https://www.curseforge.com/wow/addons/lfraider/files/8394943 | Exemplar changelog: TOC → `20506` + “verified wow-ui-source diff, no code change.” Steal the honesty pattern for TOC-only Beef ships. |

---

## Adjacent research (do not duplicate)

| URL / path | Role |
|------------|------|
| [../04-toc-api-performance/01-interface-versions-and-toc.md](../04-toc-api-performance/01-interface-versions-and-toc.md) | Interface encyclopedia for Anniversary |
| [../19-testing-debugging-qa/church-of-beef-qa-checklist.md](../19-testing-debugging-qa/church-of-beef-qa-checklist.md) | Full QA when smoke fails |
| [../31-listing-copy-discovery/changelog-culture.md](../31-listing-copy-discovery/changelog-culture.md) | Changelog wording for Interface bumps |
| [../33-packager-ci-releases/README.md](../33-packager-ci-releases/README.md) | How to build/upload the zip |
| [../30-anniversary-vs-era-deltas/README.md](../30-anniversary-vs-era-deltas/README.md) | Wrong-folder / wrong-flavor installs |
| https://github.com/Gethe/wow-ui-source | Diff FrameXML between patch tags when deciding TOC-only vs hotfix |
| https://github.com/Ketho/BlizzardInterfaceResources | Alternate InterfaceResources diffs cited by wiki patch pages |

---

## Provenance note

Search/extract JSON under [`.raw/`](.raw/). Wiki Interface tables and CF UI labels drift — re-probe live Anniversary + current CF upload form before a real guild ship.
