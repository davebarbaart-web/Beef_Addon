# Officer seriousness vs player spectacle

**Maps to:** Spec §6.3 officer-as-anti-cheat; §4.3 demotion; §10 Officer tab vs guild announce; hybrid suggest → approve.

Beef needs **two registers in one addon**. Collapsing them either makes officers feel mocked or makes the flock feel like they’re filling out a tax form.

## Dual-register model

```
┌─────────────────────────────────────────┐
│  FLOCK / STREAM SURFACE                 │
│  Rank titles · guild announce · toasts  │
│  Register: liturgical comedy (deadpan)  │
└─────────────────────────────────────────┘
                    ▲
                    │ RANK_COMMIT / approve
                    │
┌─────────────────────────────────────────┐
│  OFFICER SURFACE                        │
│  Queue · breakdown · confirm · demote   │
│  Register: sincere procedural           │
└─────────────────────────────────────────┘
```

Classic cousins already split this way:

| Addon | Officer / leader tone | Public / raider-facing |
|-------|----------------------|-------------------------|
| [RCLootCouncil](https://www.curseforge.com/wow/addons/rclootcouncil) | Voting, history, award confirm | Consideration/award announces; response buttons as policy |
| [Gargul](https://www.curseforge.com/wow/addons/gargul) | ML settings, packmule rules, import | Raid chat loot facts; roll widgets |
| [Attune](https://www.curseforge.com/wow/addons/attune) | Survey/results/raid planner | Personal progress tree (earnest) |

## Officer UI copy rules

Officer tab is where judgment happens. Spec stance: standings are advisory testimony; approval is the real gate. Copy must support **scrutiny**, not celebration.

| Element | Tone | Example |
|---------|------|---------|
| Tab label | Neutral | `Officer` (not `Holy Tribunal` in V1 chrome — titles can wait for V2 theater) |
| Queue headers | Procedural | `Pending suggestions` · `Standing breakdown` |
| Actions | Plain verbs | `Approve` · `Reject` · `Demote` · `Appoint` · `Bestow` |
| Confirm demote / excommunicate | High friction, sober | `Demote Beefina to Cooked Beef? This will announce to guild.` |
| Empty queue | Calm | `No pending suggestions.` |
| Forged / invalid commit soft-fail | Technical-honest | `Ignored: sender is not Officer+.` |
| Version mismatch | Technical-honest | `BeefNet version mismatch — commit not applied.` |

### Confirm copy pattern (steal from loot-council “award + confirm”)

1. **What** will change (name, from → to).  
2. **Whether** guild chat will fire.  
3. **Primary button** matches the irreversible verb (`Demote`, not `OK`).  
4. **No jokes** in the confirm body — humor after the fact lives in the announce line.

## Player / flock spectacle copy rules

| Element | Tone | Example |
|---------|------|---------|
| Ladder titles | Canon comedy | `Fresh Beef` … `Beef Prophet` |
| Guild announce | Liturgical deadpan | See [announce-line-craft.md](announce-line-craft.md) |
| Personal toasts | Short receipt + optional Church verb | See [toast-copy-length.md](toast-copy-length.md) |
| Footer / scripture placeholder | One line max | Optional; never blocks ladder |
| Empty ladder (not in guild) | Soft Church, still clear | `You are outside the flock. Join a guild to earn standing.` |

## Where registers meet (danger zones)

| Situation | Prefer |
|-----------|--------|
| Officer approves → promotee toast + guild announce | Toast sober/short; announce ceremonial |
| Officer rejects | Toast/officer note only; **no** guild roast |
| Officer demotes | Confirm sober; announce may be dramatic if officer opted into “excommunicate” wording |
| Inflated / funny suggestion | Officer UI shows numbers plainly — the **human laugh** is content; the UI does not need a “lmao” label |
| Sync failure mid-ceremony | Sober error; do not blame “heretics” for network drops |

## Spectacle budget (V1)

Spec defers ceremonial dashboard theater. Until then:

| Allowed spectacle | Not V1 |
|-------------------|--------|
| Guild-chat line | Confessions feed, favor bar, multi-panel liturgy |
| Rank titles on ladder | Full scripture book |
| Short toasts | Stacked toast choreography |
| One-line footer | Always-on overlay sermons |

Officer seriousness is what keeps hybrid advancement trustworthy; flock spectacle is what makes §13.11 (“visible reaction”) possible. **Both are required; they are not the same voice.**

## Checklist for any new string

1. Who reads this — officer at a desk, or flock in chat/stream?  
2. If officer: would this string belong in RCLootCouncil?  
3. If flock: does it pass the liturgical deadpan test (sincere absurdity)?  
4. If error: strip humor.  
5. If confirm: name the irreversible verb.