# Announce-line craft (guild chat)

**Maps to:** Spec §10 guild-chat announcement; §13.11 social success check; §15 “Promotion visibility.”

V1’s cheapest spectacle is **one plain-text guild line** on promotion/demotion, sent by the approving officer’s client only, with per-officer opt-out.

## Hard constraints

| Constraint | Source / note |
|------------|----------------|
| Max **255 characters** per message | [`SendChatMessage` — msg maximum length 255](https://wowwiki-archive.fandom.com/wiki/API_SendChatMessage) |
| Channel | `GUILD` (visible without addon; stream HUD friendly) |
| Sender | Approving officer only — no member echo, no peer storm |
| Frequency | Throttled; one line per commit event |
| Opt-out | Per-officer setting (Gargul pattern: “Announce loot to chat” toggle) |

Design target for *craft* is far below 255: **~80–140 characters**, one glance on a stream overlay.

## Steal structure from successful announces

Gargul’s default loot announce posts **facts** (drops + who soft-reserved / wishlist) into raid/party, with toggles for off, min quality, and whether to include soft-res names ([Announcing Loot in Chat](https://github.com/papa-smurf/Gargul/wiki/Announcing-Loot-in-Chat)). The social job is the same as Beef’s: **everyone hears the outcome, not just addon users**.

RCLootCouncil’s “Announce Consideration” / award transparency culture similarly treats chat as the public ledger ([RCLootCouncil](https://www.curseforge.com/wow/addons/rclootcouncil)).

### Recipe for a Beef promotion line

```
[Institution] [recognition verb] [Name], [elevation verb] to [Title].
```

Spec exemplar:

> The Church recognizes Beefina, elevated to Beef Knight.

| Slot | Rules |
|------|--------|
| Institution | Prefer “The Church” / “Church of Beef” — stable, brandable, stream-readable |
| Recognition verb | *recognizes*, *anoints*, *records*, *proclaims* — avoid *lol*, *yeets*, *buffs* |
| Name | Exact character name; no nicknames unless officers typed them |
| Elevation verb | *elevated to* / *raised to* (promo); *returned to* / *reduced to* (demote); *excommunicated from* only when demotion is dramatic and officers chose that template |
| Title | Exact ladder title from canon (`Beef Knight`, not “rank 3”) |

### Demotion / excommunication

Spec calls public demotion on-brand comedy *and* rivalry content. Craft still stays one line:

> The Church records the fall of Beefina, returned to Cooked Beef.

Reserve “excommunicated” for officer-chosen high-drama demotions (Council/Prophet or explicit officer action), not every −1 rank step — overusing the nuclear word dulls it.

### Appointments (Council / Prophet)

Threshold ranks ≠ appointed ranks. Announce should say the *verb of office*:

> The Church seats Beefina upon the Beef Council.  
> The Church anoints Beefina as Beef Prophet.

Do not invent fake point thresholds in the line (“after 1000 standing”) — officers already know; chat readers need the office moment.

## What to leave out of the announce

- Standing totals, breakdowns, suggestion IDs → Officer tab / My Standing
- Long scripture / multi-sentence liturgy → deferred V2 dashboard; V1 allows one-line footer in UI only
- Mentions of “addon,” “sync,” “BeefNet,” “revision” → breaks immersion for addon-less members
- @-pings, emoji walls, ALL CAPS, meme hashtags
- Second punchline after the period — one beat is enough

## Stream skim test

Read the line at Discord-overlay size:

1. Can a viewer who never installed the addon parse **who** and **new title** in under two seconds?
2. Does the brand (“Church”) appear without needing a logo?
3. Would repeating this line five times in one raid night still feel ceremonial rather than spammy?

If (3) fails, tighten verbs or add officer throttle (already required).

## Template bank (V1-ready)

| Event | Template |
|-------|----------|
| Promote (1–5) | `The Church recognizes {name}, elevated to {title}.` |
| Demote | `The Church records the fall of {name}, returned to {title}.` |
| Excommunicate (opt-in wording) | `The Church excommunicates {name}, cast down to {title}.` |
| Seat Council | `The Church seats {name} upon the Beef Council.` |
| Bestow Prophet | `The Church anoints {name} as Beef Prophet.` |
| Reject (optional; usually silent) | Prefer **no** guild announce on reject — toast/officer UI only |

Rejects are officer process, not flock spectacle; announcing them invites pile-ons.

## Anti-patterns

| Bad | Why |
|-----|-----|
| `lol beefina got beef knight 🥩🥩🥩` | Meme mode; ages poorly; hard to parse on stream |
| `ChurchOfBeef v1.2 RANK_COMMIT ok Beefina->3` | Protocol leak |
| Three lines of scripture then the name | Exceeds skim; risks 255-cut mid-sentence |
| Every online officer’s client sends the same line | Spam; breaks “one speaker” rule |