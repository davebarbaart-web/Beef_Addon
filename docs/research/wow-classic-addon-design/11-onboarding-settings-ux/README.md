# Track: First-run, Onboarding, Slash Commands, and Settings UX

**Track id:** `11-onboarding-settings-ux`  
**Last updated:** 2026-07-25  
**Scope:** How contemporary Classic / TBC Classic Anniversary addons handle first-run experience, defaults, slash vs GUI, AceConfig layouts, profiles import/export, minimap buttons vs LibDBIcon, tutorial/help patterns, and reducing configuration overwhelm.  
**Out of scope:** Addon implementation, combat HUD design, packaging marketplaces (see sibling tracks).

Church of Beef V1 already locks `/beef` + minimap launcher, plain Classic frames, and per-character `ChurchOfBeefDB` ([design spec §9–§10](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)). This track explains ecosystem norms so V1 stays discoverable without settings sprawl, and so V2 options/profiles can adopt Ace patterns without rewrite of Core.

## Index

| Note | Topic |
|------|--------|
| [first-run-and-defaults.md](first-run-and-defaults.md) | Wizard vs zero-config; safe defaults |
| [slash-commands-vs-gui.md](slash-commands-vs-gui.md) | Slash entry points, empty-input → GUI, help text |
| [aceconfig-layouts.md](aceconfig-layouts.md) | AceConfig / AceConfigDialog layout conventions |
| [profiles-import-export.md](profiles-import-export.md) | AceDBOptions, copy/reset, share strings |
| [minimap-vs-libdbicon.md](minimap-vs-libdbicon.md) | Hand-rolled vs LibDBIcon vs no button |
| [tutorial-help-patterns.md](tutorial-help-patterns.md) | Wizards, empty states, tooltips, `/help` |
| [reducing-configuration-overwhelm.md](reducing-configuration-overwhelm.md) | Progressive disclosure techniques |
| [annotated-urls.md](annotated-urls.md) | Annotated primary URLs |
| [church-of-beef-relevance.md](church-of-beef-relevance.md) | Mapped recommendations for Church of Beef |

## Provenance

| Artifact | Role |
|----------|------|
| [`.raw/onboarding-settings-ux-deep.md`](.raw/onboarding-settings-ux-deep.md) | Parallel deep-research report (pro-fast) |
| [`.raw/onboarding-settings-ux-deep.json`](.raw/onboarding-settings-ux-deep.json) | Deep-research metadata + basis confidence |
| [`.raw/extract-ace-libs.json`](.raw/extract-ace-libs.json) | Extracted Ace3 / LibDBIcon primary pages |
| [`.raw/extract-addon-ux.json`](.raw/extract-addon-ux.json) | Extracted Questie / AceConfigDialog / wiki / ElvUI |
| [`.raw/search-*.json`](.raw/) | Parallel search result dumps |

Prefer WowAce / warcraft.wiki.gg / project READMEs over listicles. Deep-research addon anecdotes are labeled **ecosystem observation** where not backed by a primary extract in this folder.

## Related library docs

- [04-ace3-and-libraries.md](../04-ace3-and-libraries.md)
- [05-persistence-and-profiles.md](../05-persistence-and-profiles.md)
- [01-ux-patterns/minimap.md](../01-ux-patterns/minimap.md)
