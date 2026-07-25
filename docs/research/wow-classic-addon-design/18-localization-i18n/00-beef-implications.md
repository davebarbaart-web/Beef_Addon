# Localization implications for Church of Beef

**Last updated:** 2026-07-25  
**Maps to:** [V1 design spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §3.3 brand voice, §4 titles, §10 UI/fonts/announcements  
**Depth:** [01](01-acelocale-vs-plain-tables.md) · [02](02-enus-first-and-externalization.md) · [03](03-fonts-non-latin.md) · [04](04-english-only-guild-culture.md) · [URLs](05-annotated-urls.md)

---

## Top insights (Beef)

1. **V1 English-only is correct for a guild-culture comedy church.** Spec audience is Dreamscythe/Doomhowl Beef guilds; rank names and guild-chat liturgy are the product. Shipping incomplete community translations would dilute the brand more than it helps. See [04](04-english-only-guild-culture.md).

2. **Externalize strings anyway — without AceLocale.** Put player-facing text behind a plain `L["…"]` (or stable keys) so V2 can add locales or rewrite voice without hunting `SetText("…")` across Core/UI. AceLocale is optional glue; Gello’s forum guidance treats it as overkill for a simple table. See [01](01-acelocale-vs-plain-tables.md).

3. **Treat rank titles as proper nouns, not translate-by-default UI chrome.** `Fresh Beef` → `Beef Prophet` are canon identity ([spec §4](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)). Even a future deDE/frFR UI pack should leave ladder titles in Church English unless leadership deliberately commissions localized brand names.

4. **Separate “works on other clients” from “UI speaks the client language.”** Wiki internationalization advice: never match spell/item/NPC *names* by English string — use IDs. Beef’s scoring (instances, guild roster, officer index) should stay ID/API-driven so a frFR client member does not break the ladder even if chrome stays English. See [02](02-enus-first-and-externalization.md).

5. **Default Blizzard fonts protect non-Latin guests; custom “gothic” faces do not.** Spec already requires fallback to default UI fonts. Latin-only decorative fonts show `?` / tofu on Cyrillic and CJK. V1/V2 theatrical fonts must either stay English-only contexts or use locale-aware Blizzard paths / LSM locale registration. See [03](03-fonts-non-latin.md).

6. **Guild-chat spectacle lines are brand liturgy.** Plan sketch: `The Church recognizes %s, elevated to %s.` — this is stream-facing English comedy. Do not auto-translate via client locale; officer opt-out already exists for noise. If a non-English guild ever forks Beef, they replace liturgy strings as a conscious brand fork.

7. **enUS-first is the industry default; enGB inherits enUS under AceLocale.** Ship English as the default locale table. Community translations (if ever) are additive files that fall back to English for missing keys — never block release on translators.

8. **TOC `Title` / `Notes` can stay English for V1.** Localized `Title-frFR` / `Notes-deDE` are free metadata later; they do not require in-game string systems.

---

## Spec gaps (optional decisions log candidates)

Not V1 blockers; record if product wants an explicit policy:

| Question | Recommended default |
|----------|---------------------|
| Formal i18n scope for V1? | **English-only UI + English liturgy**; strings externalized |
| AceLocale in V1? | **No** — plain table; revisit if Ace stack lands |
| Translate rank titles? | **Never by default** — proper nouns |
| Custom Church fonts? | **Post-V1 only**; default `GameFont*` until then |
| CurseForge localization portal? | Skip until public multi-guild distribution |

---

## What this track does *not* own

- AceConfig option-table structure (Ace libs track)
- Masque/LSM media catalogs beyond font *locale* pitfalls (skinning track)
- Immersion/RP presentation patterns (immersion track)
- Guild officer UX patterns (guild-social track)
