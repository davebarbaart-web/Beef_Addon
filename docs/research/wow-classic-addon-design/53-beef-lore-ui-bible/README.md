# Track 53 — Church of Beef narrative lore bible for UI

**Track id:** `53-beef-lore-ui-bible`  
**Last updated:** 2026-07-25  
**Sole focus:** Canon lexicon and liturgy doctrine for in-game strings — sacred/profane vocabulary, rank-title meanings, announce liturgy *patterns*, and lore-aligned do/don’t rules.  
**Out of scope:** Microcopy craft (length budgets, toast timing, officer-vs-flock *register* craft) — that is track [32](../32-microcopy-tone-voice/). Immersion chrome / TRP frames — [07](../07-immersion-roleplay-flavor/). Brand color tokens — [23](../23-color-brand-tokens/). No addon code or commits in this folder.

## Product truth (from V1 spec)

| Locked lore signal | Value |
|--------------------|-------|
| Institution | Absurd religious-sports-entertainment church — comedy + rivalry + ceremony |
| Deity / pantheon cues | Beef God, cow prophets, pope-hat stream pageantry, Eternal Grazing |
| Visual/cultural cousins | Gothic cathedral / Scarlet Crusade–inspired holy energy, steaks, cows |
| Proper names | “The Great Church of Beef,” “Church of Beef,” short form “The Church” |
| Ladder (low→high) | Fresh Beef → Cooked Beef → Beef Knight → Beef Lord → Beef Butcher → Beef Council → Beef Prophet |
| Rank tiers | 1–5 earned (suggest→approve); Council appointed/seated; Prophet bestowed/unique |
| Demotion | Manual; public “excommunication” is on-brand high drama |
| V1 scripture | One-line footer placeholder only — not a lore novel |
| Realms | Dreamscythe Alliance + Doomhowl Horde = **separate churches / ladders** |

Source: [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §1, §3.3, §4, §10, §15–16.

## Boundary with track 32

| Track 32 owns (craft) | This track owns (canon) |
|-----------------------|-------------------------|
| Character budgets, throttle, stream skim tests | Which words are sacred vs procedural |
| Tone registers (sincere vs meme) | Rank-title theology and UI glosses |
| Sample announce *wording polish* | Liturgy *slot doctrine* and verb families |
| Officer UI seriousness heuristics | When flock-facing liturgy is allowed at all |

If a sentence is about **how long / how funny / how often**, put it in 32. If it is about **whether the word belongs in Church canon**, put it here. Prefer linking 32’s template bank rather than re-listing every sample line.

## Index

| Note | Covers |
|------|--------|
| [sacred-profane-vocabulary.md](sacred-profane-vocabulary.md) | Sacred / flock / office / procedural / forbidden word lists |
| [rank-titles-lore.md](rank-titles-lore.md) | Seven titles — meaning, scarcity, UI gloss, alt doctrine |
| [announce-liturgy-patterns.md](announce-liturgy-patterns.md) | Liturgy slots, verbs by rite, what may never appear in chat |
| [string-do-dont.md](string-do-dont.md) | Surface-by-surface do/don’t for in-game strings |
| [cousin-cult-guild-addons.md](cousin-cult-guild-addons.md) | Light research: analogous cult/guild/RP shoutout patterns |
| [annotated-urls.md](annotated-urls.md) | Annotated bibliography |

## Top insights for Beef (read this first)

1. **The joke is sincere institution, not slang.** Spec brand is “absurd religious institution.” Sacred nouns (*Church*, *Beef God*, rank titles, *Eternal Grazing*) stay deadpan and stable; meme slang belongs outside official liturgy (or never in guild-chat commits).

2. **Ranks are proper nouns, not flavors.** Always exact canon casing: `Beef Knight`, never “beef knight,” “Knight of Beef,” or “rank 3.” Machine truth stays in `Data/Ranks.lua`; this bible owns *gloss and usage*, not thresholds.

3. **Three rites, three verb families.** Elevate (1–5), Seat (Council), Anoint (Prophet). Demote uses *returned/reduced*; *excommunicate* is nuclear and scarce. Do not blur appointment into “promotion after points.”

4. **Sacred voice is a privilege, not a skin.** Guild-chat commits + rank titles + optional footer = sacred. Officer Approve/Reject, errors, sync, and settings = procedural English. Mixing them burns trust and immersion.

5. **Cousins teach vernacular placement, not parody spam.** Recognition shoutouts and RP title fields show that cult voice lives in *milestone announces* and *identity labels* — not in every toast or error. Prefer liturgical deadpan over [Guild Achieve Congratulator](https://www.curseforge.com/wow/addons/guild-achieves)-style random sarcasm for V1 commits.

## Provenance

- Design spec + plan under `docs/superpowers/`
- Sibling tracks [07](../07-immersion-roleplay-flavor/), [09](../09-guild-social-community/), [32](../32-microcopy-tone-voice/)
- Light web search dumps under [`.raw/`](.raw/)
