# Ace3 Conventions

**Last updated:** 2026-07-25  
**Sources:** [Ace3 Getting Started](https://www.wowace.com/projects/ace3/pages/getting-started), [Ace3 for Dummies](https://warcraft.wiki.gg/wiki/Ace3_for_Dummies), [Ace3 CurseForge/WowAce project](https://www.wowace.com/projects/ace3), local scrapes under [`.firecrawl/`](.firecrawl/).

---

## 1. What Ace3 is (and is not)

Ace3 is a **modular, LibStub-loaded library suite**, not a mandatory runtime. Warcraft Wiki’s Ace3 tutorial states explicitly that Ace is not required and authors should understand vanilla addon loading first.

Relevant to Church of Beef:

- The design spec allows plain Classic frames for V1.
- Ace is still the **shared vocabulary** of contemporary Classic/Retail utility addons (lifecycle names, DB scopes, options tables, profile UI).
- Adopting Ace later is easiest if V1 already thinks in Ace-shaped modules (bootstrap / core / UI / net).

---

## 2. Core mental model

| Piece | Role |
|-------|------|
| **LibStub** | Versioned library registry; all Ace libs load through it |
| **AceAddon-3.0** | Creates the addon object; drives initialize/enable/disable |
| **Mixins** | Named libs passed to `NewAddon` (e.g. AceEvent, AceConsole, AceComm) become methods on the addon table |
| **Modules** | `NewModule` children with their own enable state, often toggled from `db.profile` |
| **embeds.xml** | Conventional place to list LibStub + library XML/Lua includes |

Standard create pattern (from WowAce Getting Started): obtain AceAddon via LibStub, call `NewAddon("Name"[, "Mixin1", ...])`.

---

## 3. Lifecycle (the convention everyone shares)

| Hook | When | Typical work |
|------|------|----------------|
| **OnInitialize** | Once, around addon load (`ADDON_LOADED` era) | Create AceDB / restore settings; do **not** assume SV earlier than this |
| **OnEnable** | When addon (re)enables; can fire more than once across disable cycles | Register events, show frames, wire slash handlers that should be live |
| **OnDisable** | User disables addon | Unregister listeners; Ace mixins help auto-clean when embedded |

**Hard rule from Ace docs:** initialize AceDB in `OnInitialize` or later. Creating the DB at file-load time races SavedVariables load and can wipe or ignore the real SV table.

**CoB plain-Lua analogue:** init `ChurchOfBeefDB` on `ADDON_LOADED` for `ChurchOfBeef`, never in the main chunk before that event.

---

## 4. Library menu (Beef-relevant)

| Library | Job | CoB relevance |
|---------|-----|----------------|
| **AceAddon-3.0** | Lifecycle + modules | Future bootstrap shape |
| **AceConsole-3.0** | Slash registration + Print + arg parse | `/beef` family; config open |
| **AceEvent-3.0** | Event/message helpers via CallbackHandler | Instance / roster / scoring events |
| **AceDB-3.0** | Scoped SavedVariables + profiles | UI prefs vs ladder data separation |
| **AceDBOptions-3.0** | Standard Profiles options group | Copy/reset/new profile UX players expect |
| **AceConfig-3.0** | Declarative options tables | Officer settings, announce opt-out, thresholds (if exposed) |
| **AceConfigDialog-3.0** | Dialog + Blizzard options integration | Esc → Interface Options / in-game config window |
| **AceGUI-3.0** | Widget toolkit behind ConfigDialog | Mostly indirect unless custom panels |
| **AceComm-3.0** | Prefixed addon messaging + split/reassemble | BeefNet alternative to raw `SendAddonMessage` |
| **AceSerializer-3.0** | Table ↔ string | Heavier than colon-delimited V1 protocol; optional |
| **AceLocale-3.0** | Localization tables | Later i18n; not V1-critical for a mono-guild joke church |
| **AceTimer / AceHook** | Timers / safe hooks | Situational; avoid unless needed |

---

## 5. Embedding conventions

From Getting Started:

1. Ship libs under `Libs/` (or equivalent).
2. Prefer an **`embeds.xml`** that Script/Includes LibStub first, then CallbackHandler, then Ace libs.
3. TOC either lists `embeds.xml` early or lists the same files explicitly.
4. `## OptionalDeps: Ace3` is common so a standalone Ace3 install can satisfy deps; embeds still provide isolation when Ace3 is absent.

CurseForge packager workflows often use **`.pkgmeta` `externals:`** to pull LibStub/Ace trunks at build time (WeakAuras-style). That is a packaging concern, not a runtime API.

---

## 6. Module pattern (why it matters later)

AceAddon modules let large addons split Ladder / Officer / Net / UI with:

- Independent enable flags
- Shared parent DB / options tree
- Cleaner disable behavior

For CoB, the design spec’s `Core/`, `Net/`, `UI/`, `Data/` layout already rhymes with Ace modules. Naming and dependency direction can stay Ace-ready without using Ace in V1.

---

## 7. What “contemporary Classic” authors actually do

Observed industry pattern (WeakAuras, Details!, DBM-family, many Questie-class tools):

- Embed LibStub + a **subset** of Ace (rarely “all of Ace3”).
- Use AceDB/AceConfig when settings complexity justifies it.
- Use LibDataBroker + LibDBIcon for minimap instead of raw Minimap children.
- Keep combat-critical paths light; social/utility addons can afford Ace’s weight more easily than meters.

Church of Beef is social/utility — Ace weight is acceptable **if** options/profiles become a real product surface. It is not required for a seven-rank ladder with a few officer actions.

---

## 8. Pitfalls to document in reviews

| Pitfall | Why it hurts CoB |
|---------|------------------|
| DB created at file load | Corrupts or ignores `ChurchOfBeefDB` |
| Mixing combat-secure assumptions into AceGUI | Irrelevant to V1 social UI, but taint still matters for any secure frames later |
| Treating AceComm as “instant reliable RPC” | Still subject to throttle, online presence, and trust rules — BeefNet’s officer validation remains mandatory |
| Assuming Ace = Retail-only | Ace3 is actively used on Classic flavors; TOC Interface version is the real gate |
