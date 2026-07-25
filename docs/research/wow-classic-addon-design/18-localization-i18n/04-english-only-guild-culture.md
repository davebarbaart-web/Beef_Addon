# When guild-culture English-only is OK

**Last updated:** 2026-07-25  
**Primaries:** [Localizing an addon — “ignore the whole problem”](https://warcraft.wiki.gg/wiki/Localizing_an_addon) · [V1 design spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) · [V1 plan — Announce sketch](../../../superpowers/plans/2026-07-25-church-of-beef-v1.md)

---

## Wiki permission structure

The localization HOWTO lists three honest strategies for locale mismatch ([Localizing an addon](https://warcraft.wiki.gg/wiki/Localizing_an_addon)):

1. **Ignore the problem** — works for the author’s locale; limits audience.
2. **Localize all user-facing text** — full translation burden.
3. **Avoid localized game strings via IDs** — internationalize behavior without translating chrome.

Strategy (1) is explicitly valid when the audience is bounded. Strategy (3) remains mandatory for **correctness** even when (1) is chosen for chrome.

---

## When English-only is socially acceptable

English-only shipping is a reasonable product choice when most of the following hold:

| Condition | Church of Beef V1 |
|-----------|-------------------|
| Audience is a known English-speaking guild/community | Yes — Dreamscythe Alliance / Doomhowl Horde Beef culture ([spec §5](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) |
| Copy is **brand voice**, not neutral utility labels | Yes — religious-sports comedy, stream liturgy ([§3.3](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) |
| Distribution is not aiming at global CurseForge leaderboards | V1 is guild/social, not mass utility |
| Translating would destroy jokes / proper nouns | Rank ladder is English wordplay (`Fresh Beef`, `Beef Prophet`) |
| Officers and stream moments expect a fixed catchphrase | Guild-chat announce is the V1 spectacle budget ([§10](../../../superpowers/specs/2026-07-25-church-of-beef-design.md), [§13.11](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) |

Under those conditions, incomplete machine translations are **worse** than English: half-translated AceLocale files, Google-quality liturgy, or mismatched rank titles break immersion and sync expectations (“why does my ladder say something else than guild chat?”).

---

## When English-only is *not* enough

Revisit full localization if:

- The addon is published for **general Classic audiences** across EU/KR/CN/TW regions.
- UI chrome volume grows into a dense options tree used by non-guild strangers.
- Gameplay correctness depends on comparing Blizzard-localized chat/system strings (avoid this design instead of translating).
- Leadership wants a **localized brand fork** (separate canon titles per language) — that is a content project, not a checkbox.

---

## Church of Beef voice / copy rules

### Keep English on purpose

- **Ladder titles** — canon proper nouns; same string in UI, toasts, and guild chat.
- **Liturgy lines** — e.g. plan sketch `The Church recognizes %s, elevated to %s.` / demotion excommunication line ([plan Task 9](../../../superpowers/plans/2026-07-25-church-of-beef-v1.md)). These are performance scripts for an English comedy church.
- **Scripture footer placeholder** — brand tone; English until a deliberate multilingual lore pass.

### Still externalize

Centralize liturgy and chrome in one locale table so writers can retune jokes without touching Net/Core. Externalization ≠ offering deDE on day one.

### Do not “helpfully” localize

- Auto-picking Blizzard `GlobalStrings` for promotion lines would sound like generic UI, not Church of Beef.
- Translating only the options panel while leaving rank titles in English is fine later; translating titles without a brand decision is not.

### Cross-client members

A friend on a frFR client in an English guild should still:

- Accrue standing / receive commits (internationalized logic).
- See English Church chrome (localization strategy 1).
- Render player names with default fonts (see [03](03-fonts-non-latin.md)).

Document in README/onboarding: **Church of Beef V1 UI language is English** — sets expectations and avoids “unfinished locale” bug reports.

---

## Recommendation summary

| Layer | V1 policy |
|-------|-----------|
| Behavior / IDs / BeefNet | Locale-agnostic (internationalized) |
| UI chrome & liturgy | English-only, externalized |
| Rank titles | English proper nouns (canon) |
| TOC Title/Notes | English |
| Community translation portal | Deferred until public multi-guild demand |
