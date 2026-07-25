# Ace3, LibStub, and the Shared Library Ecosystem

**Last updated:** 2026-07-25  
**Primary sources:** [Ace3 Getting Started](https://www.wowace.com/projects/ace3/pages/getting-started), [AceConfig options tables](https://www.wowace.com/projects/ace3/pages), [Ace3 for Dummies](https://warcraft.wiki.gg/wiki/Ace3_for_Dummies), [CurseForge Ace3](https://www.curseforge.com/wow/addons/ace3), [LibDBIcon](https://www.wowace.com/projects/libdbicon-1-0), [LibStub (CurseForge)](https://www.curseforge.com/wow/addons/libstub).

---

## 1. Decision frame for Church of Beef

Ace3 is the dominant Classic/retail addon framework (lifecycle, DB, config, comms, events). It is **not required** — wiki tutorials stress understanding vanilla addon loading first.

| Approach | Pros | Cons | Beef fit |
|----------|------|------|----------|
| **No Ace** (plain CreateFrame + SavedVariables) | Small footprint; matches “plain Classic frames” V1 | Reinvent profiles/options/minimap | **V1 default per plan** |
| **Embed select libs only** | LibDBIcon, ChatThrottleLib, LibStub without full Ace | Still manage embeds.xml | Good incremental path |
| **Full AceAddon stack** | AceDB profiles, AceConfig UI, AceComm | Weight + style coupling; embed churn | Optional if options explode in V2 |

Recommendation: ship V1 without Ace; document Ace patterns so V2 options/profiles can adopt AceDBOptions without rewrite of Core.

---

## 2. LibStub

- Versioned library loader used by nearly all shared libs.
- Multiple addons embed the same lib; newest minor wins.
- Pattern: `LibStub("LibraryName-1.0")`.

Always load LibStub before other embeds.

---

## 3. Ace3 modules most relevant to Beef

| Module | Role | Beef mapping |
|--------|------|--------------|
| **AceAddon-3.0** | `OnInitialize` / `OnEnable` / `OnDisable` lifecycle | Bootstrap timing analogue |
| **AceDB-3.0** | Layered SavedVariables + profiles | Future account-wide prefs vs per-char ladder |
| **AceDBOptions-3.0** | Standard profile UI block | Copy UX labels if rolling custom profiles |
| **AceConfig-3.0** + **AceConfigDialog** | Declarative options tables → GUI/slash | Officer settings, thresholds |
| **AceConsole-3.0** | Slash + Print | `/beef` family |
| **AceEvent-3.0** | Event register helpers | Instance/scoring events |
| **AceComm-3.0** | Addon messaging + throttling integration | BeefNet alternative to raw SendAddonMessage |
| **AceSerializer-3.0** | Serialize tables to strings | Heavier than colon-delimited; optional |

### Lifecycle lesson (critical)

AceDB must be created in **`OnInitialize` or later**, not at file load — SavedVariables are not ready in the main chunk ([Getting Started](https://www.wowace.com/projects/ace3/pages/getting-started)). Same rule applies to plain addons: init DB on `ADDON_LOADED` for your addon name.

### Options UI conventions (AceConfig)

From AceConfig options tables:

- Root `type = "group"` with nested `args`.
- Common controls: `toggle`, `range`, `input`, `select`, `execute`, `color`, `header`.
- Cross-cutting: `order`, `desc`, `confirm`, `disabled`, `hidden`, width hints (`full`, `double`, `half`).
- Inherit `get`/`set` down the tree.
- Register: `LibStub("AceConfig-3.0"):RegisterOptionsTable(name, options, {"slash1"})`.
- Profile chunk: `options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(db)`.

**Steal without Ace:** Keep officer-facing settings few; use `confirm` pattern for demote / Prophet bestowal / standing wipe.

---

## 4. LibSharedMedia (LSM)

- Registers fonts, statusbars, borders, backgrounds, sounds.
- ElvUI and many Classic UIs expect LSM; optional soft dependency.
- Beef V1: **do not require LSM**; fallback to default fonts (spec §10).
- V2 theatrical pass may *optionally* register a Church font/statusbar if shipped as addon media.

---

## 5. LibDBIcon (+ LibDataBroker)

De facto minimap button standard:

- Create a DataBroker object; LibDBIcon places a minimap button.
- Plays nicer with collectors than raw `Minimap` children.
- Commonly paired with AceDB `profile.minimap.hide`.

**Beef:** Spec requires minimap button; LibDBIcon is the least-friction path when ready to embed libs. Hand-rolled button is fine for V1 if tested with collectors.

---

## 6. Embedding conventions

Common layout:

```
MyAddon/
  MyAddon.toc
  embeds.xml          # LibStub + libs
  Libs/...
  Core.lua
```

`embeds.xml` clarifies third-party vs first-party code ([Getting Started](https://www.wowace.com/projects/ace3/pages/getting-started)). Prefer embedding over hard `## Dependencies` so the addon loads alone.

---

## 7. AceComm vs raw BeefNet

AceComm wraps addon messages (prefix registration, chunking, callbacks) and is commonly used with ChatThrottleLib under the hood in the broader ecosystem.

BeefNet V1 plan: prefix `COB`, channel `GUILD`, colon-delimited payloads, ChatThrottleLib-style pacing (spec §8). That is the right complexity level — AceComm is optional polish, not a requirement.

---

## Sources

- [Ace3 Getting Started — WowAce](https://www.wowace.com/projects/ace3/pages/getting-started)
- [AceConfig-3.0 Options Tables](https://www.wowace.com/projects/ace3/pages)
- [Ace3 for Dummies — Warcraft Wiki](https://warcraft.wiki.gg/wiki/Ace3_for_Dummies)
- [WelcomeHome: first Ace3 addon](https://warcraft.wiki.gg/wiki/WelcomeHome:_Your_first_Ace3_Addon)
- [LibDBIcon-1.0](https://www.wowace.com/projects/libdbicon-1-0)
- [Ace3 — CurseForge](https://www.curseforge.com/wow/addons/ace3)
