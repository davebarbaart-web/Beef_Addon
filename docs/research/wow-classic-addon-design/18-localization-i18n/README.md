# Track 18 — Localization / i18n norms (Classic addons)

**Last updated:** 2026-07-25  
**Scope:** How Classic (and Ace-era) addons ship strings, locales, and fonts — and what that means for Church of Beef.  
**Out of scope:** Ace3 lifecycle/options (track `03` / flat `04-ace3-and-libraries.md`), SharedMedia skinning catalogs (track `10`), immersion/RP flavor UX (track `07`), guild social product patterns (track `09`). This track owns **string/locale policy only**.

## Design-spec locale assumptions (read first)

The [V1 design spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) does **not** declare a formal i18n policy. Implicit assumptions that constrain this track:

| Spec signal | Locale implication |
|-------------|-------------------|
| Rank titles are canon proper nouns (`Fresh Beef` … `Beef Prophet`, §4) | Brand lexicon, not Blizzard `GlobalStrings` |
| Guild-chat line example is English Church voice (§10; plan Announce sketch) | Spectacle copy is English-first |
| Alliance Dreamscythe / Horde Doomhowl, independent ladders (§5) | NA English guild-culture audience for V1 |
| Missing fonts → default UI fonts (§10 / §11) | Prefer Blizzard `GameFont*` over custom Latin-only faces |
| No Ace required for V1 (synthesis + Ace track) | Prefer plain locale tables over AceLocale unless Ace is already embedded |

## Docs in this track

| File | Topic |
|------|--------|
| [00-beef-implications.md](00-beef-implications.md) | Decisions for Beef (executive) |
| [01-acelocale-vs-plain-tables.md](01-acelocale-vs-plain-tables.md) | AceLocale-3.0 vs hand-rolled `L` tables |
| [02-enus-first-and-externalization.md](02-enus-first-and-externalization.md) | enUS-first shipping, string externalization, TOC locale tags |
| [03-fonts-non-latin.md](03-fonts-non-latin.md) | Non-Latin glyphs, Cyrillic/CJK font files, LSM pitfalls |
| [04-english-only-guild-culture.md](04-english-only-guild-culture.md) | When English-only is acceptable |
| [05-annotated-urls.md](05-annotated-urls.md) | Annotated primary URLs |

Provenance scrapes live under [`.raw/`](.raw/).
