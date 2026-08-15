# Phase 4 Lane C — Gora Core (sanction + verdict)

Read: Ten Laws 3, 4, 5, 8; Bible §10.1–10.8; `.cursor/rules/gora-sanction.mdc`; `.cursor/rules/records-not-points.mdc`. Lanes A and B are signed. Store already has `RecordGoraResult` and rulings `victor` / `cowardice` / `void` / `free`.

## Exclusive files

- `addon/ChurchOfBeef/Core/Gora.lua`
- `tests/test_gora.lua` (create)
- Report: `docs/reformation/phase-4/reports/P4-C-gora.md`

**Do not** edit TOC, bootstrap, `tests/run.lua`, Store, Runtime, Sender, Codec, Snapshot, BeefNet, UI, DB. **Do not** create `Data/Popes.lua`. Keep leftover `Challenge` / `GetPending` behavior so `tests/test_gora_ceremony.lua` stays green — do not grow Challenge into the product loop.

## Mission

Test-first. Isolated suite: Common + Ranks + Store + Runtime + Gora. Wrap “other modules nil” asserts in `if standalone then`.

A Beef Gora exists only after **SANCTION BEEF GORA**. Combat is WoW’s (not this file). Software proposes; the Pope ratifies. No auto-declare, no narration, no ELO, no pairing score, no Grant.

- **Petition** — `Petition(characterId, namedOpponentId?)`. Pool is character ids. Expire when Runtime is QUIET / `EndEvent` (Bible freshness = ~the current event). Do **not** invent a TTL number or a re-petition cooldown number. `Dismiss(characterId)` is consequence-free. Present-and-alive is a harness flag the caller passes — do not invent roster sensing.
- A named opponent is stored. The software does **not** announce the callout.
- **Recommend** (optional) — may return level-proximity / head-to-head / named-challenge context from Store. No odds copy. No rating. No auto-sanction.
- **Sanction(fighterA, fighterB, stipulation?)** — one verb. Optional one-line stipulation remembered, not a rules picker. Sets the live sanctioned pair. Does not start a duel. Does not OpenRite (Pope Runtime verb stays separate).
- **Propose** is caller-supplied (no duel-chat parser this lane).
- **DeclareVictor(winnerId)** / **CowardiceRecorded(fleerId)** / **Void()** / **FreeRuling(text?)** — write `Store:RecordGoraResult` for both characters. Record the Pope’s ruling, not a parser guess. Free ruling is free text on the record, not a new outcome enum.
- Elevation is **not** this lane. No auto-Lord.

Do not invent: Fight HUD, favor bar, INPUT channel, holdSeconds, `#8`, Famous Upsets computation, defense increment rule.

## Do not git commit.
