# Annotated URLs — keybinds & binding conflicts

Primary sources for track 38. Prefer these over “best keybinds” listicles when deciding whether Beef touches the binding system.

## Bindings.xml & howto

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://warcraft.wiki.gg/wiki/Creating_key_bindings | Canonical howto: Bindings.xml auto-load (not TOC), attributes including `default`, SetBinding vs SetOverrideBinding, combat protection, secure click path. |
| https://wowpedia.fandom.com/wiki/Creating_key_bindings | Mirror of the same howto (backup if wiki.gg flakes). |
| https://addonstudio.org/wiki/WoW:Using_bindings.xml_to_create_key_bindings_for_your_addon | Practical notes: `BINDING_NAME_*` / `BINDING_HEADER_*`, empty-body ignore since 2.1, “only way onto default Key Bindings UI.” |
| https://wowwiki-archive.fandom.com/wiki/Using_bindings.xml_to_create_key_bindings_for_your_addon | Archive mirror of the AddOn Studio / WoWWiki howto. |
| https://github.com/NeticSoul/wow-335a-addon-wiki/blob/main/chapters/ch16-key-bindings.md | Clear Classic-era mental model: Bindings.xml, API table, override stacking order, BUTTON names. |

## SetBinding / override APIs

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://wowpedia.fandom.com/wiki/API_SetBinding | Restricted in combat; bindings need `SaveBindings` to persist; documents permanent-set behavior. |
| https://warcraft.wiki.gg/wiki/Creating_key_bindings | (Same page) Explicit: SetBinding **unbinds** previous action on that key; overrides do not permanently unbind Key Bindings UI rows. |
| https://www.wowinterface.com/forums/showthread.php?t=57596 | Authoritative distinction: clearing ≠ restore; prefer `SetOverrideBinding*` + `ClearOverrideBindings` for temporary steals. |
| https://addonstudio.org/wiki/WoW:API_SetOverrideBindingClick | Override-click API notes; cannot clear via SetOverrideBindingClick — use SetOverrideBinding / ClearOverrideBindings. |
| https://github.com/phanx-wow/MountMe/blob/master/Addon.lua | Real addon pattern: ClearOverrideBindings + re-apply from `GetBindingKey` on `UPDATE_BINDINGS` (still a steal while active). |
| https://www.curseforge.com/wow/addons/togtools/files/8444187 | Changelog hygiene: override-click on private owner, never clobber saved binds, `GetBindingAction` conflict heads-up, combat-defer apply. |

## Click-cast / conflict culture

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://addons.wago.io/addons/clique | Clique binding model: mouse/keyboard combos, combat lock on edits, overrides frame defaults, rebind target/menu. |
| https://www.curseforge.com/wow/addons/clique | Distribution / current Classic+Retail Clique listing. |
| https://www.wowinterface.com/downloads/info5108-Clique.html | Long comment history; dual-use bar+Clique keybind player expectation. |
| https://www.wowinterface.com/forums/archive/index.php/t-7106.html | Classic support culture: Clique + “other addon conflicting” bisect. |
| https://github.com/tullamods/Dominos/issues/781 | Bar-addon bind/profile pain on Classic — reason not to join the bind-writing party. |

## Cousin social / loot hotkeys (contrast)

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://github.com/papa-smurf/Gargul | Ships configurable **item** modifier-clicks (`ALT_CLICK` etc.) — justified for loot, not a template for ladder toggles. |

## Product truth (repo)

| Path | Why |
|------|-----|
| [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §10 | Locked `/beef` + minimap entry; no keybind requirement. |
| [`docs/research/wow-classic-addon-design/22-slash-commands-ux/`](../22-slash-commands-ux/) | Primary discoverability surface. |
| [`docs/research/wow-classic-addon-design/28-minimap-addon-compartment/`](../28-minimap-addon-compartment/) | Non-keyboard launcher coexistence. |
| [`docs/research/wow-classic-addon-design/00-church-of-beef-implications.md`](../00-church-of-beef-implications.md) | Edge social tool — do not compete with combat input. |

## Provenance dumps

| File | Contents |
|------|----------|
| [`.raw/search-bindingxml-overrides.json`](.raw/search-bindingxml-overrides.json) | Parallel search: BindingXML, overrides, Clique |
| [`.raw/search-binding-conflicts.json`](.raw/search-binding-conflicts.json) | Parallel search: conflicts, Dominos, ClearOverride |
| [`.raw/search-clique-defaults.json`](.raw/search-clique-defaults.json) | Parallel search: Clique + Gargul defaults |
| [`.raw/search-clique-mechanics.json`](.raw/search-clique-mechanics.json) | Parallel search: Clique click-cast mechanics |
| [`.raw/extract-creating-key-bindings.json`](.raw/extract-creating-key-bindings.json) | Extract: warcraft.wiki.gg Creating key bindings |
| [`.raw/extract-addonstudio-bindings.json`](.raw/extract-addonstudio-bindings.json) | Extract: AddOn Studio Bindings.xml howto |
| [`.raw/extract-ch16-key-bindings.json`](.raw/extract-ch16-key-bindings.json) | Extract: NeticSoul ch16 |
| [`.raw/extract-setbinding-wowpedia.json`](.raw/extract-setbinding-wowpedia.json) | Extract: Wowpedia SetBinding |
| [`.raw/extract-wowinterface-override.json`](.raw/extract-wowinterface-override.json) | Extract: WoWInterface override thread |
| [`.raw/extract-gargul-hotkeys.json`](.raw/extract-gargul-hotkeys.json) | Extract: Gargul hotkey table |
