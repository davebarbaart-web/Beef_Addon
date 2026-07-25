# Announce liturgy patterns

**Purpose:** Doctrine for *what kind of ceremony* guild-chat and flock-facing lines perform.  
**Craft (length, throttle, stream skim, template bank polish):** [32 — announce-line craft](../32-microcopy-tone-voice/announce-line-craft.md). This track owns slots, rites, and forbidden content — not character budgets.

Spec locks V1 spectacle as **one throttled guild-chat line** on promotion/demotion from the approving officer’s client (§10, §13.11, §15).

---

## The liturgical sentence

Canonical slot pattern (shared with 32):

```
[Institution] [rite verb phrase] [Name], [motion phrase] [Title or Office].
```

| Slot | Doctrine |
|------|----------|
| **Institution** | Prefer `The Church`. `Church of Beef` when the short form would be ambiguous outside guild culture. Never `COB`, `ChurchOfBeef`, or addon version strings. |
| **Rite verb phrase** | Chosen from the **rite table** below — matches the *kind* of commit, not the player’s joke of the week. |
| **Name** | Exact character name as committed. No stream nicknames in the automated line. |
| **Motion phrase** | Elevation / return / seating / anointing language — see rite table. |
| **Title / Office** | Exact canon title. Council/Prophet lines may use office phrasing (“upon the Beef Council,” “as Beef Prophet”). |

Spec exemplar (promote):

> The Church recognizes Beefina, elevated to Beef Knight.

---

## Rite table (verb families)

| Rite | When | Institution + verb pattern | Motion |
|------|------|----------------------------|--------|
| **Elevation** | Approve suggestion ranks 1→2…→5 | The Church **recognizes** / **proclaims** | **elevated to** / **raised to** {Title} |
| **Seating** | Appoint Beef Council | The Church **seats** / **appoints** | **upon the Beef Council** (or “as Beef Council”) |
| **Anointing** | Bestow Beef Prophet | The Church **anoints** / **bestows upon** | **as Beef Prophet** |
| **Fall** | Ordinary demote | The Church **records the fall of** | **returned to** / **reduced to** {Title} |
| **Excommunication** | Officer-chosen high drama | The Church **excommunicates** | **cast down to** {Title} |
| **Silence** | Reject suggestion; standing drip; sync | — | **No guild liturgy** |

### Verb scarcity rules

1. **Excommunicate** is nuclear — Council/Prophet falls or explicit officer template; not every −1 step ([32](../32-microcopy-tone-voice/announce-line-craft.md) agrees).  
2. **Anoint** is Prophet-only in V1 automated lines.  
3. **Seat** is Council-only — never “seated as Beef Knight.”  
4. **Recognize + elevated** is the default flock grind path — keep it stable so five promotions in a night still feel like the same rite.

---

## What liturgy may never contain

Aligned to spec success (addon-less members must parse the line) and immersion:

| Forbidden in guild-chat liturgy | Put it here instead |
|---------------------------------|---------------------|
| Standing totals, caps, breakdowns | My Standing / Officer queue |
| “Suggestion #,” revision, BeefNet | Debug / officer tooltips |
| Fake thresholds for Council/Prophet | Officer confirm copy only |
| Multi-sentence scripture / sermon | V2 dashboard; V1 = one-line **UI footer** max |
| Reject pile-ons | Silent reject + local officer feedback |
| Instance/Gora/ceremony point drips | Local toasts only (V1) |

---

## Local toast vs public liturgy

| Event | Public guild liturgy? | Local toast voice |
|-------|----------------------|-------------------|
| Suggestion created | No | Procedural + mild flock (“Suggestion ready for officers”) |
| Rank approved (1–5) | Yes — Elevation | Sacred title hero + short confirm |
| Council appointed | Yes — Seating | Sacred |
| Prophet bestowed | Yes — Anointing | Sacred |
| Demote / excommunicate | Yes — Fall / Excommunication | Sacred, higher drama |
| Gora / ceremony credit | No (V1) | Flock-light confirm |
| Sync / error | No | Procedural only |

---

## Footer scripture (V1 placeholder)

Spec §3.2 / §10: **one-line** footer allowed; not a lore system.

| Do | Don’t |
|----|-------|
| Stable epigraph rotating rarely (or fixed) | New joke every `/beef` open |
| Sacred lexicon (*Eternal Grazing*, *Beef God*) | Protocol jokes |
| Secondary visual weight under the ladder | Compete with rank titles |

Suggested doctrine epigraphs (authors may swap; keep one line):

- `The Church remembers. The flock endures.`
- `All meat returns to Eternal Grazing.`
- `Standing is testimony; officers anoint.`

---

## Cross-realm / multi-guild liturgy

Each guild’s officer speaks for **that** church only. Do not write lines implying a continent-wide Beef theocracy. Horde Doomhowl and Alliance Dreamscythe may share brand vocabulary and still never share ladder state (spec §5).

---

## Pointer to craft templates

Ready-to-ship string shapes and anti-pattern examples live in track 32’s [template bank](../32-microcopy-tone-voice/announce-line-craft.md#template-bank-v1-ready). When liturgy doctrine and craft conflict, **doctrine wins on verbs/titles**; **craft wins on length/throttle**.
