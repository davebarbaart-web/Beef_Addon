# enUS-first shipping and string externalization

**Last updated:** 2026-07-25  
**Primaries:** [Ace3 Getting Started](https://www.wowace.com/projects/ace3/pages/getting-started) · [AceLocale API](https://www.wowace.com/projects/ace3/pages/api/ace-locale-3-0) · [Localizing an addon (wiki)](https://warcraft.wiki.gg/wiki/Localizing_an_addon) · [TOC format](https://warcraft.wiki.gg/wiki/TOC_format) · [Phanx — How to localize an addon](https://phanx.net/addons/tutorials/localize)

---

## enUS-first is the ecosystem norm

Ace and wiki tutorials assume the authoring language is **enUS**, registered as the **default** locale (`NewLocale(..., "enUS", true)`). Other locales are optional overlays; missing keys fall back to English ([AceLocale](https://www.wowace.com/projects/ace3/pages/api/ace-locale-3-0)). European English clients (`enGB`) reuse enUS under AceLocale ([Getting Started](https://www.wowace.com/projects/ace3/pages/getting-started)).

Shipping practice for small/medium addons:

1. Ship complete English strings on day one.
2. Accept community PRs / CurseForge localization later.
3. Never gate a feature release on incomplete translations.

For guild-private tools, step 2 may never happen — enUS-first still applies as the **fallback contract**.

---

## Internationalization vs localization

Wiki distinction ([Localizing an addon](https://warcraft.wiki.gg/wiki/Localizing_an_addon)):

| Concern | Meaning | Beef relevance |
|---------|---------|----------------|
| **Internationalization** | Addon **works** on non-English clients (APIs, IDs, message formats) | Must not parse English combat/loot/zone names |
| **Localization** | Addon **displays** the user’s language | Optional for V1 guild-culture English |

Hard internationalization rule: identify items/spells/quests/NPCs by **ID**, not by English name. Names vary by client locale; IDs do not. Prefer Blizzard `GlobalStrings` / APIs when you need already-localized system phrases.

Beef’s V1 scoring path (instance presence, guild roster rank index, officer commits) should stay on events/APIs/IDs. Hard-coded English is fine for **Church chrome**, dangerous for **game-world matching**.

---

## String externalization (do this even if English-only)

Wiki: every user-visible string should go through a table lookup so translators (or brand rewrites) do not edit logic files ([Localizing an addon](https://warcraft.wiki.gg/wiki/Localizing_an_addon)). WelcomeHome tutorial recommends externalizing **early**, not as a post-ship chore ([WelcomeHome](https://warcraft.wiki.gg/wiki/WelcomeHome:_Your_first_Ace3_Addon#Localizing_Your_Strings_with_AceLocale)).

### What to externalize for Beef

| Bucket | Examples | Notes |
|--------|----------|-------|
| UI chrome | Tab labels, empty states, button text, slash help | High value for future locales |
| Toasts / feedback | Suggestion created, approve/reject confirm | High value |
| Liturgy / spectacle | Guild-chat promotion & demotion lines | Keep Church English; still centralize for voice edits |
| Rank titles | Fresh Beef … Beef Prophet | Canon proper nouns — externalize as data, do not “translate casually” |
| Officer errors | Council full, Prophet unique | Externalize |
| Debug / Lua errors | Developer `print` | Optional; low priority |

### What not to translate

- API names, frame/XML names, SavedVariables keys, BeefNet message type tokens (`RANK_COMMIT`, etc.)
- Protocol field separators and version integers
- Anything used as a **machine key** across clients (prefer stable ids; display strings are derived)

Phanx’s tutorial also stresses **UTF-8 file encoding** for any non-ASCII locale file ([Phanx](https://phanx.net/addons/tutorials/localize)).

---

## TOC metadata localization (cheap, separate)

`Title` / `Notes` (and similar) accept locale suffixes: `Title-frFR`, `Notes-deDE` ([TOC format](https://warcraft.wiki.gg/wiki/TOC_format), [Localizing an addon](https://warcraft.wiki.gg/wiki/Localizing_an_addon)). Put the unlocalized English tag first; locale-specific lines override for that client.

V1 Beef can ship English `Title` / `Notes` only. Add suffixes only if public multi-locale distribution becomes real.

Modern TOC can also restrict files with `AllowLoadTextLocale` ([TOC format](https://warcraft.wiki.gg/wiki/TOC_format)) — useful if many heavy locale files accumulate; irrelevant for a single enUS table.

---

## Phrase keys vs opaque keys

Two common styles:

1. **English-as-key:** `L["Show on Screen"] = true` (Ace default idiom) — readable call sites; painful if English marketing copy changes often.
2. **Opaque keys:** `L["OPTIONS_SHOW_SCREEN"] = "Show on Screen"` — stabler for copy churn; uglier call sites.

For Church of Beef, hybrid works well:

- **Opaque or stable keys** for liturgy that may be rewritten for punchline quality.
- **English-as-key or short keys** for dull chrome (`Approve`, `Reject`, `My Standing`).
- **Rank ids → title strings** from canon data, not free-floating literals in UI files.
