# Church of Beef — copy guidelines

Practical voice rules for V1 strings. Brand roots: design spec §3.3 (comedic pope, Beef God, gothic/Scarlet pageantry, holy steak absurdity) delivered with the **sincere procedural craft** of successful Classic guild tools.

## North star

**Speak as a church that means it.**  
The world is funny; the narrator is not winking every sentence.

> Yes: *The Church recognizes Beefina, elevated to Beef Knight.*  
> No: *omg BEEFINA just got KNIGHTED lmao get the steaks*

## Lexicon

### Prefer (on-brand nouns/verbs)

| Use | Notes |
|-----|--------|
| Church / Church of Beef / the flock | Institution voice |
| recognizes, elevates, seats, anoints, records, returns | Ceremony verbs |
| standing | Points metaphor — consistent in UI |
| suggestion / eligible | Hybrid ladder honesty |
| Fresh Beef → … → Beef Prophet | Exact canon titles only |
| Beef Gora, ceremony | Event names as proper nouns |
| excommunicate | Rare, officer-gated drama |

### Avoid (unless a future opt-in joke mode)

| Avoid | Why |
|-------|-----|
| Random meme formats (distracted boyfriend, skibidi, etc.) | Dates instantly |
| Internet slang as default UI (`lol`, `based`, `W`, `ratio`) | Breaks liturgical register |
| Fake Latin walls / lorem ipsum scripture | Clutters skim; deferred lore is one-line max |
| Mocking the promotee/demotee in system copy | Officers may joke in voice chat; the addon stays dignified |
| Protocol words in flock surfaces (`RANK_COMMIT`, `revision`, `prefix COB`) | Immersion + clarity |

Steak/cow imagery is welcome **in titles and sparse liturgy**, not in every tooltip.

## Surface matrix

| Surface | Register | Humor level | Length |
|---------|----------|-------------|--------|
| Guild announce | Liturgical | Medium (deadpan institution) | One sentence, ~80–140 chars |
| Rank titles | Canon | High (in the name itself) | Fixed strings |
| Player toasts | Receipt + light Church | Low | ≤ ~60 chars / 6–12 words |
| Officer queue / actions | Procedural | None | Short labels |
| Confirms (demote/appoint) | Procedural + friction | None | Name the consequence |
| Errors / sync | Technical-honest | None | Cause + next step |
| Empty states | Soft Church OK | Low | One sentence |
| Settings / opt-out | Procedural | None | “Announce promotions to guild chat” |
| Slash `/beef` help | Procedural + one brand beat | Low | List commands clearly |
| TOC Notes / store blurb | Brand pitch | Medium | “Guild institution tool,” not DPS helper |

## Grammar of Church voice

1. **Institution first:** “The Church …” beats “You just …” for public lines.  
2. **Name second, title last:** listeners remember *who* then *what*.  
3. **Past or ceremonial present:** *recognizes / elevated / records* — avoid future hype (“will become”).  
4. **One metaphor per line.** Do not stack grill + crusade + sports in one sentence.  
5. **Exact titles.** Never paraphrase ladder ranks in announces.

## Sample bank

### Guild announces

| Event | Line |
|-------|------|
| Promote | The Church recognizes {name}, elevated to {title}. |
| Demote | The Church records the fall of {name}, returned to {title}. |
| Excommunicate (opt-in) | The Church excommunicates {name}, cast down to {title}. |
| Council seat | The Church seats {name} upon the Beef Council. |
| Prophet | The Church anoints {name} as Beef Prophet. |

### Toasts

| Event | Line |
|-------|------|
| Suggestion | Standing recognized — {title} suggested. |
| Approved (self) | Elevated to {title}. |
| Ceremony | Ceremony marked. Standing +{n}. |
| Gora | Beef Gora recorded. Standing +{n}. |

### Officer

| Element | Line |
|---------|------|
| Approve confirm | Approve elevation of {name} to {title}? Announces to guild chat. |
| Reject | Reject suggestion for {name}? No guild announcement. |
| Demote confirm | Demote {name} to {title}? This cannot be undone except by a later promotion. |
| Empty | No pending suggestions. |

### Empty / edge

| State | Line |
|-------|------|
| Not in guild | You are outside the flock. Join a guild to earn standing. |
| Not officer | Officer tools require a guild Officer+ rank. |
| Alts (on-brand, clear) | This character begins as Fresh Beef. The flesh must prove itself anew. |

## Writing checklist (paste beside any PR that adds strings)

- [ ] Flock-facing? Liturgical deadpan — not meme slang.  
- [ ] Officer-facing? Would RCLootCouncil/Gargul ship this label?  
- [ ] Announce ≤ ~140 chars skim; hard ≤ 255.  
- [ ] Toast ≤ ~60 chars; one humor beat max.  
- [ ] Errors have zero jokes.  
- [ ] Confirms name the irreversible verb + announce side effect.  
- [ ] Canon title spelling matches `Data/Ranks.lua`.  
- [ ] No BeefNet/protocol leakage on flock surfaces.  
- [ ] Reject path stays quiet in guild chat.

## Relationship to other docs

| Doc | Use for |
|-----|---------|
| Spec §3.3 / §10 | Brand + required surfaces |
| [sincere-vs-meme-guild-tone.md](sincere-vs-meme-guild-tone.md) | Why deadpan beats gag spam |
| [announce-line-craft.md](announce-line-craft.md) | Public line templates |
| [toast-copy-length.md](toast-copy-length.md) | Local receipt budgets |
| [officer-serious-vs-player-spectacle.md](officer-serious-vs-player-spectacle.md) | Register split |
| Track 07 | *Where* text appears in UI — not wording |
| Future `docs/canon/ranks.md` | 1–2 sentence lore per title (prose only; no thresholds) |