# Annotated URLs — Onboarding & Settings UX

**Last updated:** 2026-07-25  
**How to use:** Prefer primary docs for API truth; use community guides only for observed first-run UX.

---

## Ace3 / libraries (primary)

| URL | What it is | Steal / adapt for Church of Beef |
|-----|------------|----------------------------------|
| [Ace3 Getting Started](https://www.wowace.com/projects/ace3/pages/getting-started) | Slash, AceConfig registration, AceDB init timing, AceDBOptions one-liner | Lifecycle: init DB after load; empty slash → GUI; profiles fragment for V2 |
| [AceConfig-3.0 Options Tables](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables) | Widget types, `order`, `desc`, `confirm`, visibility flags | Progressive disclosure + confirm on demote/Prophet |
| [AceConfig-3.0 API](https://www.wowace.com/projects/ace3/pages/api/ace-config-3-0) | `RegisterOptionsTable` + slash list | Slash names without leading `/` |
| [AceConfigDialog-3.0 API](https://www.wowace.com/projects/ace3/pages/api/ace-config-dialog-3-0) | `AddToBlizOptions`, `Open`, `SelectGroup` | Future Bliz Options page; unique appName |
| [AceDB-3.0 Tutorial](https://www.wowace.com/projects/ace3/pages/ace-db-3-0-tutorial) | Defaults, namespaces, profile callbacks | Mental model even if V1 skips Ace |
| [Ace3 for Dummies](https://warcraft.wiki.gg/wiki/Ace3_for_Dummies) | End-to-end tutorial: slash, Bliz options, profiles child page | Empty-input opens settings pattern |
| [LibDBIcon-1.0 — WowAce](https://www.wowace.com/projects/libdbicon-1-0) | Minimap icon via LDB + SV `hide` | Preferred minimap path for `/beef` launcher |
| [LibDBIcon-1.0 — CurseForge](https://www.curseforge.com/wow/addons/libdbicon-1-0) | Flavor files / maintenance signal | Confirms Classic TBC packaging still live |

---

## Exemplar addons / product UX

| URL | What it is | Steal / adapt |
|-----|------------|---------------|
| [Questie — GitHub README](https://github.com/Questie/Questie) | `/questie`, `/questie journey`, minimap click grammar | Rich but clear launcher semantics; keep Beef simpler |
| [Questie — NoobToBoss guide](https://noobtoboss.com/addon/questie/) | First-login setup wizard claim; minimap config | Soft wizard only if a wrong default is costly |
| [ElvUI — Tukui](https://tukui.org/elvui) | Installer / profile / import-export changelog evidence | Presets + profiles for **UI**, not ladder data |
| [Wago WeakAuras tutorials hub](https://wago.io/weakauras/snippets/tutorials) | Import-string culture | Share strings for future aura/theme packs — not rank state |

---

## Church of Beef canon

| URL / path | What it is | Steal / adapt |
|------------|------------|---------------|
| [Design spec 2026-07-25](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) | Locked `/beef`, minimap, SV, officer gate | Non-negotiable product constraints for this track |
| [04-ace3-and-libraries.md](../04-ace3-and-libraries.md) | Repo Ace decision frame | V1 plain frames; Ace optional later |
| [05-persistence-and-profiles.md](../05-persistence-and-profiles.md) | SV / profile separation | UI prefs vs church data |

---

## Research provenance (this track)

| Path | Notes |
|------|-------|
| [`.raw/onboarding-settings-ux-deep.md`](.raw/onboarding-settings-ux-deep.md) | Deep-research narrative; some addon anecdotes medium confidence — verify before citing as fact |
| [`.raw/extract-ace-libs.json`](.raw/extract-ace-libs.json) | Extracted WowAce / wiki pages |
| [`.raw/extract-addon-ux.json`](.raw/extract-addon-ux.json) | Extracted Questie / AceConfigDialog / ElvUI / guides |
| [`.raw/search-onboarding-settings.json`](.raw/search-onboarding-settings.json) | Parallel search dump |
| [`.raw/search-addon-onboarding.json`](.raw/search-addon-onboarding.json) | Addon-specific search dump |

---

## Intentionally deprioritized

- Generic “top 10 Classic addons” listicles without primary links
- Retail-only Settings API deep dives (isolate behind helpers if used)
- Combat WeakAuras pack import guides (wrong product surface for V1)
