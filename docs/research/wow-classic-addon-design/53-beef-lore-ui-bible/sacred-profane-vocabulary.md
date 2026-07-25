# Sacred / profane vocabulary

**Purpose:** A lexicon for UI authors so every string knows whether it is liturgy, flock slang, office language, or cold procedure.  
**Not this doc:** Toast length, announce character budgets — see [32 announce-line craft](../32-microcopy-tone-voice/announce-line-craft.md).

---

## Four registers (lore, not craft)

| Register | When it appears | Voice |
|----------|-----------------|-------|
| **Sacred** | Guild-chat rank commits, ladder titles, optional scripture footer, toast *title* line for promote/demote | Liturgical deadpan; proper nouns; present tense of ceremony |
| **Flock** | Optional flavor in My Standing empty states, Gora stub labels, ceremony stub names — never errors | Warm absurdity; still Church-native words |
| **Office** | Officer tab headers for appoint/bestow/demote, confirm dialogs for Council/Prophet/excommunicate | Plain verbs + sacred *object* (“Bestow Prophet,” not “Set rank=7”) |
| **Procedural** | Errors, sync warnings, BeefNet mismatch, settings, Approve/Reject defaults | Straight Classic-addon English; zero jokes |

**Profane** in this bible means *non-sacred / out-of-doctrine*, not swearing. Profane strings break the institution fantasy (protocol leaks, meme slang, generic “level up” RPG speak).

---

## Sacred lexicon (prefer these)

### Institution & metaphysics

| Term | Use |
|------|-----|
| **Church of Beef** / **The Great Church of Beef** | Full brand; TOC Notes, first-run, about |
| **The Church** | Default subject of guild-chat liturgy |
| **Beef God** | Rare; footer scripture / V2+ — not every toast |
| **Eternal Grazing** | Afterlife / rest metaphor; footer or lore blurb — not a rank |
| **the flock** | Members collectively; avoid “users,” “subscribers” |
| **standing** | Points currency in UI (spec language); not “XP,” “DKP,” “elo” |
| **suggestion** | Client testimony awaiting officer judgment — not “application” |
| **rite** / **ceremony** | Officer-run event credit source |
| **Beef Gora** | Theatrical challenge; keep the proper name |

### Rite verbs (sacred when flock-facing)

| Verb family | Canonical uses |
|-------------|----------------|
| **recognize / elevate / raise** | Ranks 1–5 promotion |
| **seat / appoint** | Beef Council |
| **anoint / bestow** | Beef Prophet |
| **record the fall / return / reduce** | Ordinary demotion |
| **excommunicate / cast down** | High-drama demotion only |

### Identity nouns

| Term | Use |
|------|-----|
| **title** | Display name of a ladder rank |
| **ladder** | The seven-rung social hierarchy |
| **Prophet** / **Council** | Capitalized when referring to the office |
| **excommunication** | The public drama demotion *event*, not a permanent faction flag in V1 |

---

## Flock-adjacent (allowed sparingly)

| Term | Notes |
|------|-------|
| **Fresh** / **Cooked** | Only as part of full titles; do not nickname people “Freshie” in official announces |
| **butcher** / **knight** / **lord** | Same — full title in commits |
| **tribute** | Optional metaphor for standing contribution in flavor copy; do not rename the Standing tab |
| **devotion** | Flavor for attendance/ceremony; do not replace “standing” in mechanical UI |
| **holy** / **sacred** / **blessed** | Atmosphere words in footer; never on error dialogs |

---

## Office lexicon (officer UI)

Prefer blunt action labels with sacred *targets*:

| Prefer | Avoid |
|--------|--------|
| Approve / Reject | Anoint Suggestion / Smite Application |
| Demote… | Soften Rank |
| Appoint to Council | Grind to Council |
| Bestow Prophet | Unlock Final Rank |
| Correct standing | Absolve Points |

Confirm dialogs may use one sacred noun for friction (“Bestow the Prophet’s mantle on {name}?”) while buttons stay Approve / Cancel.

---

## Procedural lexicon (must stay cold)

| Domain | Preferred words |
|--------|-----------------|
| Network | sync, outdated, incompatible version, try again |
| Permissions | Officer only, not in a guild, roster unavailable |
| Data | standing, revision (debug/tooltip only — never guild chat) |
| Empty states | No pending suggestions, Ladder unavailable while unguilded |

Do **not** wrap these in liturgy (“The Church cannot hear your prayer: sync failed”).

---

## Profane / forbidden in official strings

| Avoid | Why |
|-------|-----|
| XP, level up, prestige pass, battle pass | Wrong genre metaphor |
| DKP, EPGP, loot, soft-reserve | Wrong guild-tool cousin vocabulary for flock UI |
| RANK_COMMIT, BeefNet, COB, revision, SavedVariables | Protocol leak (except officer/debug panels) |
| yeet, based, goated, skill issue, W/L streak slang | Meme register; ages badly on stream VODs |
| emoji walls, 🥩 spam, ALL CAPS praise | Spec wants plain-text liturgy |
| “rank 3,” “tier 2,” numeric IDs in flock UI | Titles are the product |
| Cross-faction / cross-realm “one true Church” | Spec: Dreamscythe ≠ Doomhowl ladders |
| Auto-promote / “you earned it automatically” | Hybrid doctrine: officers anoint; clients only testify |

---

## Sacred vs WoW guild rank (do not confuse)

| Church ladder title | WoW guild rank |
|---------------------|----------------|
| Social layer managed by the addon | Real roster rank (GM/Officer/…) |
| Appears in `/beef` ladder & announces | Used only for Officer+ gate (index) |
| Funny proper nouns | Arbitrary per-guild names — never parse them for liturgy |

UI copy must never imply Church titles replace Blizzard guild ranks.

---

## Quick author checklist

1. Is this string flock-visible ceremony? → Sacred lexicon + exact title.  
2. Is this officer judgment or system truth? → Procedural or Office.  
3. Does a word appear in [forbidden](#profane--forbidden-in-official-strings)? → Rewrite.  
4. Would an addon-less member understand who/what without knowing BeefNet? → Required for guild chat.
