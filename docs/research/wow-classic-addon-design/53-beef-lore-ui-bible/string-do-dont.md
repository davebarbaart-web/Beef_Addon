# In-game strings — lore do / don’t

**Purpose:** Surface-by-surface rules so UI copy stays aligned to the V1 design spec’s brand and advancement doctrine.  
**Complement:** Word lists in [sacred-profane-vocabulary.md](sacred-profane-vocabulary.md); craft budgets in [32](../32-microcopy-tone-voice/).

---

## Global rules

| Do | Don’t |
|----|-------|
| Use exact rank titles from canon | Paraphrase titles for variety |
| Treat standings as **advisory testimony**; officers as the gate | Promise tamper-proof scores or “anti-cheat crypto” |
| Keep guild-chat commits readable without the addon | Require knowing BeefNet to understand a promotion |
| Split sacred (spectacle) vs procedural (truth) | Joke on sync failures or permission errors |
| Remember separate Dreamscythe / Doomhowl churches | Imply one cross-realm ladder |
| Allow plain Classic chrome with sacred *words* | Block V1 on gothic art; words carry brand first |

---

## By surface

### Addon list / TOC Notes

| Do | Don’t |
|----|-------|
| Name: **Church of Beef** | Generic “Guild Rank Helper” |
| Describe social ranks, ceremonies, spectacle | Promise DPS, interrupts, or automation |

### `/beef` frame chrome

| Do | Don’t |
|----|-------|
| Tabs: Ladder / My Standing / Officer | “Leaderboard / XP / Admin” |
| Highlight local title with canon string | Show raw rank id as primary label |
| One-line scripture footer (optional) | Multi-page Beef Bible in V1 |

### Ladder tab

| Do | Don’t |
|----|-------|
| List all seven titles with occupants | Hide Council/Prophet behind “coming soon” |
| Mark Appointed / Bestowed tiers | Show point bars toward Council/Prophet |
| Vacant Council seats as scarcity | “0/4 grind progress” |

### My Standing tab

| Do | Don’t |
|----|-------|
| Call currency **standing** | Rename to XP/DKP/elo in labels |
| Show next threshold for ranks 1–5 | Invent “points to Prophet” |
| Recent events in plain language (instance, ceremony, Gora) | Liturgical sermons per drip |

### Officer tab

| Do | Don’t |
|----|-------|
| Approve / Reject as clear actions | Meme button labels that obscure judgment |
| Confirm demote / Council / Prophet | One-click nuclear actions without friction |
| Breakdown as short event list | Details!-style meter essay |
| “Suggestion” = member testimony | “Cheat report” framing |

### Toasts

| Do | Don’t |
|----|-------|
| Short confirm; title is the sacred hero on rank change | Multi-line jokes over the combat HUD |
| Procedural voice for suggestion-created | Guild-chat volume on every toast |
| Credit Gora/ceremony locally | Broadcast every standing drip |

### Guild-chat announce

| Do | Don’t |
|----|-------|
| One line, officer sender, liturgy slots | Member echo storms |
| Rite-correct verbs (elevate / seat / anoint / return / excommunicate) | “lol grats” or protocol dumps |
| Opt-out respected | Silent-default that kills §13.11 spectacle by accident |

### Thin Gora / ceremony stubs

| Do | Don’t |
|----|-------|
| Keep proper names **Beef Gora**, **Ceremony** | Overbuild wrestling-show packaging in V1 (deferred §3.2) |
| Record win/loss/draw; losses still “count” in flavor (“you showed”) | Shame losers in public chat |
| Officer start/close language for ceremony | Auto-credit without officer close (spec edge table) |

### Empty & error states

| Do | Don’t |
|----|-------|
| “Not in a guild — ladder unavailable” | “The unbaptized cannot behold the ladder” as the only message |
| “Officer only” | Fake sacred lock copy that hides the real rule |
| Soft version mismatch warning | Applying incompatible commits with a joke |

### Slash / help

| Do | Don’t |
|----|-------|
| `/beef` opens the church frame | Dump scripture in chat |
| Short subcommand help in procedural voice | Hidden meme-only commands as the only docs |

---

## Doctrine tripwires (instant rewrite)

If a draft string does any of the following, rewrite before ship:

1. **Auto-promote fantasy** — “Congratulations, you are now Beef Knight” without officer commit.  
2. **Clergy-by-grind** — “Reach 1000 standing to unlock Council.”  
3. **Protocol liturgy** — “RANK_COMMIT applied.”  
4. **Cross-church state** — “Prophet of Dreamscythe and Doomhowl.”  
5. **Alt merge assumption** — “Your main’s title applies” (V1 false).  
6. **Decay that doesn’t exist** — “Standing rotting…” (V1 false).  
7. **Combat assistance** — anything that sounds like a raid tool.

---

## Relationship to other tracks

| Need | Go to |
|------|-------|
| Sacred word lists | [sacred-profane-vocabulary.md](sacred-profane-vocabulary.md) |
| Title glosses | [rank-titles-lore.md](rank-titles-lore.md) |
| Liturgy slots / rites | [announce-liturgy-patterns.md](announce-liturgy-patterns.md) |
| Length, humor craft, dual register *execution* | [32-microcopy-tone-voice](../32-microcopy-tone-voice/) |
| Color of titles / states | [23-color-brand-tokens](../23-color-brand-tokens/) |
