# Annotated URLs — Localization / i18n

**Last updated:** 2026-07-25  
**Use:** Prefer these primaries when citing locale policy. Steal/adapt notes are for Beef, not general addon tutorials.

---

## AceLocale and Ace docs

| URL | Annotation |
|-----|------------|
| [AceLocale-3.0 API (WowAce)](https://www.wowace.com/projects/ace3/pages/api/ace-locale-3-0) | Canonical `NewLocale` / `GetLocale` behavior: default locale, nil when locale unused, `true` = key-as-value, fallback for missing keys. **Adapt:** know the contract; **don’t** embed AceLocale for V1. |
| [Ace3 Getting Started — Using AceLocale-3.0](https://www.wowace.com/projects/ace3/pages/getting-started) | enUS-as-default, enGB→enUS, TOC load order, function-valued locale strings for word order. **Steal:** enUS-first + early externalization habit. |
| [WelcomeHome — Localizing with AceLocale](https://warcraft.wiki.gg/wiki/WelcomeHome:_Your_first_Ace3_Addon#Localizing_Your_Strings_with_AceLocale) | End-to-end Ace tutorial chapter; stresses localizing before shipping and loading locales before Core. **Steal:** process discipline, not the Ace dependency. |
| [AceLocale-3.0.lua (WoWUIDev/Ace3)](https://github.com/WoWUIDev/Ace3/blob/master/AceLocale-3.0/AceLocale-3.0.lua) | Implementation reference if silent/raw modes or fallback edge cases need auditing. |

---

## Plain-table / HOWTO

| URL | Annotation |
|-----|------------|
| [Localizing an addon (warcraft.wiki.gg)](https://warcraft.wiki.gg/wiki/Localizing_an_addon) | Best single HOWTO: i18n vs l10n, TOC `Title-xxXX`, metatable `L`, UTF-8, GlobalStrings, ID-vs-name table, “ignore the problem” as valid strategy. **Primary for Beef policy.** |
| [Localizing an addon (Wowpedia)](https://wowpedia.fandom.com/wiki/Localizing_an_addon) | Same lineage; cross-check if wiki.gg drifts. |
| [Phanx — How to localize an addon](https://phanx.net/addons/tutorials/localize) | Practical per-locale `if GetLocale()` skeleton; UTF-8 warning for ru/ko/zh. **Steal:** file encoding checklist. |
| [Blizzard UI forum — Localization Question (2023)](https://us.forums.blizzard.com/en/wow/t/localization-question/1610833) | Gello: AceLocale overkill for a string table; use addon namespace consistently across files. **Supports plain-table V1.** |
| [TheMizeGuy wow-addon-dev localization.md](https://github.com/TheMizeGuy/wow-addon-dev/blob/main/references/localization.md) | Modern notes including TOC `AllowLoadTextLocale` patterns vs AceLocale. Secondary; verify against current TOC wiki for Classic Anniversary. |

---

## TOC / GetLocale

| URL | Annotation |
|-----|------------|
| [TOC format (warcraft.wiki.gg)](https://warcraft.wiki.gg/wiki/TOC_format) | `Title`/`Notes` locale suffixes; `AllowLoadTextLocale` for locale-gated files. **Steal later** for public listing polish. |
| [API GetLocale](https://warcraft.wiki.gg/wiki/API_GetLocale) | Client locale codes (`enUS`, `deDE`, `frFR`, `koKR`, `ruRU`, `zhCN`, `zhTW`, …). Use only for optional overlays / font switches. |

---

## Fonts / SharedMedia

| URL | Annotation |
|-----|------------|
| [LSM #6 — Different base fonts for Russian clients](https://www.wowace.com/projects/libsharedmedia-3-0/issues/6) | Concrete Cyrillic Friz/Morpheus/Skurri paths; why Latin font registration breaks ruRU. **Must-read before V2 custom fonts.** |
| [WoWInterface — How do you handle fonts for foreign languages](https://www.wowinterface.com/forums/showthread.php?t=44593) | Author discussion of KR/ZH/RU Blizzard font files vs LSM. |
| [SharedMedia: No Asian Fonts](https://www.wowinterface.com/downloads/info21961-SharedMediaNoAsianFonts.html) | Social proof that CJK font registration annoys Western menus — locale-aware media is a product decision. |
| [SharedMedia Classical Fonts (CurseForge)](https://www.curseforge.com/wow/addons/sharedmedia-classicalfonts) | Example decorative Latin packs players pair with RP UIs — high glyph risk if Beef ever soft-depends. |

---

## GlobalStrings / community locale dumps

| URL | Annotation |
|-----|------------|
| [tekkub/wow-globalstrings](https://github.com/tekkub/wow-globalstrings) | Historical community dumps of localized Blizzard strings. Use to **reuse** system phrases, not to invent Church liturgy. |

---

## Spec / plan (repo)

| URL / path | Annotation |
|------------|------------|
| [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) | Implicit English brand voice, rank proper nouns, default font fallbacks, guild-chat spectacle. |
| [`docs/superpowers/plans/2026-07-25-church-of-beef-v1.md`](../../../superpowers/plans/2026-07-25-church-of-beef-v1.md) | English announce templates; “default fonts only in V1”. |

---

## Provenance

Search/extract JSON under [`.raw/`](.raw/) (`search-acelocale-i18n.json`, `search-fonts-english-only.json`, `search-toc-locale-meta.json`, `extract-*.json`).
