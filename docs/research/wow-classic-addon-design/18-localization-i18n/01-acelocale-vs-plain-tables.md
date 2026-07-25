# AceLocale-3.0 vs plain locale tables

**Last updated:** 2026-07-25  
**Primaries:** [AceLocale-3.0 API](https://www.wowace.com/projects/ace3/pages/api/ace-locale-3-0) · [Ace3 Getting Started — AceLocale](https://www.wowace.com/projects/ace3/pages/getting-started) · [WelcomeHome AceLocale chapter](https://warcraft.wiki.gg/wiki/WelcomeHome:_Your_first_Ace3_Addon#Localizing_Your_Strings_with_AceLocale) · [Blizzard UI forum — Localization Question](https://us.forums.blizzard.com/en/wow/t/localization-question/1610833) · [Wowpedia — Localizing an addon](https://wowpedia.fandom.com/wiki/Localizing_an_addon)

---

## What AceLocale buys you

From the [WowAce AceLocale-3.0 page](https://www.wowace.com/projects/ace3/pages/api/ace-locale-3-0):

- Register per-application locale tables with `NewLocale(app, locale[, isDefault[, silent]])`.
- `GetLocale(app[, silent])` returns the table for the **current client locale**, falling back to the **default** locale for missing keys.
- `NewLocale` returns **`nil` when that locale file is not needed** for the player’s game locale (non-default locales can early-return) — keeps unused translation tables out of memory.
- Default locale is usually `enUS` with `isDefault = true`. Phrase keys set to `true` mean “value equals key” (common English idiom).
- AceLocale maps **enGB → enUS** automatically ([Getting Started](https://www.wowace.com/projects/ace3/pages/getting-started)).
- Optional missing-key warnings (unless `silent`); `silent = "raw"` disables the metatable and returns nils for unknown keys.
- Locale functions can wrap word-order-sensitive interpolations (DKP-style examples in Getting Started).

Load order still matters: locale files (and AceLocale itself) must load **before** code that calls `GetLocale` / reads `L[...]` ([WelcomeHome](https://warcraft.wiki.gg/wiki/WelcomeHome:_Your_first_Ace3_Addon#Localizing_Your_Strings_with_AceLocale)).

---

## Plain locale tables (no Ace)

Community HOWTOs ([Wowpedia](https://wowpedia.fandom.com/wiki/Localizing_an_addon), [warcraft.wiki.gg mirror](https://warcraft.wiki.gg/wiki/Localizing_an_addon), [Phanx localize tutorial](https://phanx.net/addons/tutorials/localize)) converge on the same pattern:

1. Create an `L` table (often the addon’s private `...` namespace table).
2. Metatable `__index` returns the key itself when untranslated (English-as-key idiom).
3. Per-locale files: `if GetLocale() == "frFR" then L["Hello"] = "…" end`.
4. Or TOC-gated files (`AllowLoadTextLocale` on modern clients) that overwrite English defaults.

Veteran author guidance on the [Blizzard UI forum](https://us.forums.blizzard.com/en/wow/t/localization-question/1610833) (Gello, 2023): pulling AceLocale **only** to hold a string table is overkill — “like having a library to add numbers together.” Prefer the addon namespace + metatable unless you already embed Ace3.

---

## Comparison for Classic guild tools

| Dimension | AceLocale-3.0 | Plain `L` table |
|-----------|---------------|-----------------|
| Dependency | LibStub + AceLocale embed | None |
| Fallback | Built-in to default locale | Metatable or explicit `or key` |
| Unused locales | `NewLocale` returns nil | `if GetLocale()` / TOC allow-load |
| Missing-key warnings | Optional | DIY |
| Fits AceConfig labels | Natural | Same if you wrap strings |
| Fits no-Ace V1 Beef | Extra weight | **Preferred** |

---

## Beef recommendation

- **V1:** plain locale module (or `Locales/enUS.lua` + `L` on the addon table). No AceLocale.
- **V2+:** adopt AceLocale only if the addon already embeds Ace3 for DB/config/comms — do not add Ace solely for i18n.
- Either way: one lookup path for UI chrome, toasts, slash help, and officer confirm copy. Rank **titles** may live in machine canon (`Data/Ranks.lua`) and be referenced by id; still route display through one place so brand wording stays consistent.
