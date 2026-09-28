# `/beef` player card type (approach A)

**Date:** 2026-09-15  
**Status:** Design approved by David in conversation. Implementation license is this spec plus a follow-up plan — not this file alone.  
**Authority:** David (Design Lead). Product type law stays Bible §19.3 / Law 10 / `Theme.lua`. This spec only dresses **`COB.PlayerCard`** and **card-variant `COB.NightRows`**.  
**Does not reopen:** rank names, Quiet Mode, Nights parchment voice, proclamation type, Records Book type.

---

## 1. Intent

The `/beef` card now uses stock tooltip containers and `UIPanelButtonTemplate` verbs. Custom serif (EB Garamond) at a flat 12px on those boxes fights the Blizzard chrome and flattens hierarchy.

**Approach A:** ecclesiastical blackletter stays on the nameplate only. THIS WEEK, BEEF GORA, FROM THE CHRONICLE, night rows, ledger, and identity *meta* use stock `GameFont*`.

Comedy contrast (Law 10) is nameplate dignity vs stock column chrome — not a second serif inside the boxes.

---

## 2. Font split

### 2.1 Blackletter (`Theme:FontPath("display")`, size ≥ 16)

Exactly three strings, and only when they are Church voice:

| Widget | Copy | Size token | Ink | Ground |
|---|---|---|---|---|
| `ChurchLabel` | `Church of Beef` | `Theme.FontSize.name` (16) | gold | charcoal title band |
| `NameText` | character name | `Theme.FontSize.name` (18) | parchment | charcoal identity |
| `RankText` | store Church rank title | `Theme.FontSize.headline` (22) | gold | charcoal identity |

If `SetFont` on the shipped Grenze path fails, keep today’s fallback: `GameFontNormalHuge` / `GameFontNormalLarge` object, still ≥ 16.

Never paint this face in all caps. Title case for `Church of Beef` and store rank titles (`Beef Knight`). Character names stay as the client spelled them.

### 2.2 Not blackletter (even on the identity plate)

| Widget | Why | Face |
|---|---|---|
| `RankText` when `UNRANKED` or a live guild name | not a Church rank (already true in paint) | `GameFontNormal` at 14 |
| Format, Gora record, knighted, honorific, relationship, guild | meta, not a title | `GameFontNormalSmall` |

### 2.3 Stock `GameFont*` (no `Theme:FontPath`)

All other FontStrings owned by this window, including:

- Section titles: THIS WEEK, BEEF GORA, FROM THE CHRONICLE, ledger header
- Night rows when `NightRows` `variant == "card"`
- Decree leftover / flavor lines on the week plate
- Gora victory lines, records, empty copy, “Your record”
- Chronicle headlines, bodies, empty copy
- Ledger columns and rows
- Kind ribbon ink on the card (gold on oxblood ribbon)

`UIPanelButtonTemplate` labels (Going, OPEN NIGHTS, THE RECORD, READ MORE, footer nav) keep the template face. Do not `SetFont` over them.

### 2.4 Out of scope (unchanged)

- `Theme.SHIPPED_FONTS` / `Theme:FontPath` role table
- Nights parchment (`NightRows` `variant == "parchment"`): still label/body serif, no display on rows
- Records Book, proclamations, Welcome, Decree banner, Console, Hud, FighterCard
- New font files, size-token systems, small-caps synthesis

---

## 3. Scale and ink (card containers)

Floor is 12px. No caption below that (2026-08-18 in-client pass).

| Role | Font object | Ink | Notes |
|---|---|---|---|
| Section title | `GameFontNormal` | oxblood | THIS WEEK / BEEF GORA / FROM THE CHRONICLE |
| Row title / fighter name | `GameFontNormal` | charcoal; oxblood if “yours” | Gora names, Chronicle headlines |
| Meta | `GameFontNormalSmall` | iron | date, place·time, roman record |
| Kind on ribbon | `GameFontNormalSmall` | gold | dark ribbon only |
| Empty / Chronicle body | `GameFontNormalSmall` | iron / charcoal | |
| Identity meta | `GameFontNormalSmall` | parchment / gold / silver as today | charcoal ground — gold/silver legal |

Ink discipline unchanged: no gold/silver/class as *text* on parchment-tinted tooltip fills. Gold on the kind ribbon is ornament-on-dark.

Kind ribbon copy stays Gathering / Knighting / Gora (short tags). Display/blackletter remains forbidden on night-row ink.

---

## 4. Implementation shape

### 4.1 `UI/PlayerCard.lua`

- `label()` (or a sibling) must be able to apply **object-only** type: `SetFontObject(GameFont*)`, no `Theme:FontPath`.
- Display path stays for the three blackletter strings only.
- `paintHome` must not promote leftover Decree text to `display` / 16px blackletter. Week plate copy stays `GameFontNormal` / `GameFontNormalSmall`.
- `RankText` paint already branches UNRANKED / guild vs Church title — keep the branch; Church title stays display, the others go stock `GameFontNormal` 14.

### 4.2 `UI/NightRows.lua`

- `applyFont` is variant-aware:
  - `parchment`: today’s Theme label/body path
  - `card`: `SetFontObject` only (`GameFontNormal` / `GameFontNormalSmall`), never `Theme:FontPath`
- `Attach` already stores `host.variant`. `buildRow` must see that variant (pass it in, or read `row._cobHost.variant` after attach). Rows minted in `Attach` know the host variant.
- Going stays `UIPanelButtonTemplate`. Do not restyle its font.

### 4.3 Tests

Update pins that currently require Theme label/body paths on card-owned strings (`_cobFontPath`, `_cobFontRole`). Card column/meta strings must pin `GameFont*` (or nil custom path). Church name / character name / Church rank still pin display.

Add or keep:

- NightRows card variant does not set a Theme font path on Date / Kind / Where
- NightRows parchment variant still uses Theme label/body
- PlayerCard `ChurchLabel` / `NameText` / Church `RankText` stay display
- `UNRANKED` RankText is not display
- `DecreeText` never uses display after this spec
- Source: PlayerCard week/gora/chronicle `label(` calls do not pass `"display"` except identity/title

Harness green. Install + `/reload` + `/beef` smoke. Claim **POLISH:CANDIDATE** only.

---

## 5. Non-goals

- Restyling the Nights parchment to GameFont
- Restyling Console / Records / proclamations
- Changing Theme shipped families or adding Alegreya/Unifraktur as the card face
- Inventing a fourth Theme role (`ui` / `stock`)
- Copy changes except what type already shows

---

## 6. Done when

A human on Anniversary opens `/beef` and can tell, without a caption: blackletter is the person and the Church; the three boxes read as Blizzard UI type; night titles are not the same weight as THIS WEEK; buttons still look like panel buttons.
