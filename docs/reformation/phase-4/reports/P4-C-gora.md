# Phase 4 Lane C — Gora Core (sanction + verdict)

**Status:** DONE

**Cited:** Ten Laws 3, 4, 5, 8; Bible §10.1–10.8; `.cursor/rules/gora-sanction.mdc`; `.cursor/rules/records-not-points.mdc`; brief `docs/reformation/phase-4/briefs/P4-C-gora.md`. Store already has `RecordGoraResult` and rulings `victor` / `cowardice` / `void` / `free`. Runtime QUIET / `EndEvent` is the petition freshness window.

A Beef Gora exists only after **SANCTION BEEF GORA**. Combat is WoW’s (not this file). Software proposes; the Pope ratifies. No auto-declare, no narration, no ELO, no pairing score, no Grant, no auto-elevate. TOC / bootstrap / `tests/run.lua` / Store / Runtime / Net / UI / DB / `OPEN_QUESTIONS.md` not edited. No `Data/Popes.lua`. No commit.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_gora.lua` | Created first. Isolated suite: Common + Ranks + Store + Runtime + Gora. Standalone wrap. |
| `addon/ChurchOfBeef/Core/Gora.lua` | Petition / Dismiss / Recommend / Sanction / Propose / four Pope rulings. Leftover `Challenge` kept. |
| `docs/reformation/phase-4/reports/P4-C-gora.md` | This file |

`tests/test_gora_ceremony.lua` was not edited.

## Loop

**Petition → Recommend (context only) → SANCTION BEEF GORA → Propose (caller-supplied) → Pope ruling → `Store:RecordGoraResult` for both characters.**

`OpenRite` stays a Runtime verb. Sanction does not start a duel and does not transition Runtime. Named opponents are stored; nothing announces. Present-and-alive is a caller set on `GetPetitions` — no roster sensing.

Petitions and the live pair expire when Runtime is QUIET or the event id changes (`EndEvent` → QUIET, then a new `StartEvent`). No petition TTL number. No re-petition cooldown number. `Dismiss` is consequence-free. `Continue` keeps the current-event pool.

## API

| Method | Role |
|--------|------|
| `Petition(characterId, namedOpponentId?)` | Pool is character ids. Optional named opponent. Dedupes by character. Refuses QUIET / name strings / humans. |
| `Dismiss(characterId)` | Consequence-free remove. Immediate re-petition is allowed. |
| `GetPetitions(presentAndAlive)` | Copies. Shows only ids the caller flags `true`. Omitting the set shows none. |
| `Recommend(a, b)` | Levels, Store head-to-head, named-challenge flag. No odds, rating, ELO, or score. Does not Sanction. |
| `Sanction(fighterA, fighterB, stipulation?)` | One verb. Optional one-line stipulation remembered. One live pair. Same pair may update the line. Does not OpenRite. |
| `GetSanctioned()` | Copy of the live pair + stipulation, or nil. |
| `Propose(proposal)` | Caller-supplied table or string. Does not write Store. Does not declare. |
| `GetProposal()` | Copy of the caller value, or nil. |
| `DeclareVictor(winnerId)` | Both characters: `ruling = "victor"`. Winner `won = true`, other `won = false`. |
| `CowardiceRecorded(fleerId)` | Both characters: `ruling = "cowardice"`. Fleer `won = false`, other `won = true`. |
| `Void()` | Both characters: `ruling = "void"`. No win/loss increment. |
| `FreeRuling(text?)` | Both characters: `ruling = "free"`. Text is returned on the verb, not a new outcome enum. |
| `Challenge` / `Cancel` / `IsChallenged` / `GetPending` | Leftover pair-key notes. Unchanged. Not the product loop. |
| `ResetForTests()` | No-op unless `COB._IN_TEST`. |

Getters return copies. Expected failures are `nil, err`. Rulings clear the live pair and the proposal. EndEvent without a ruling clears live state and does **not** write Store (no auto-void, no auto-declare). A Gora win does not `SetRank`.

## Verification

- Isolated suite (`Core/Common.lua` + `Data/Ranks.lua` + `Core/Store.lua` + `Core/Runtime.lua` + `Core/Gora.lua`): **304 passed, 0 failed**.
- Lua 5.1.5. `lua tests/test_gora.lua` exits 0.
- Leftover pair-key suite (Common + harness asserts + `tests/test_gora_ceremony.lua`): **17 passed, 0 failed**. Challenge / Cancel / GetPending / TTL behavior unchanged.
- No `dofile` of BeefNet / UI / DB / Officer / Archive / Recognition / Sender / Codec / Snapshot / `Data/Popes.lua` / TOC / bootstrap / `tests/run.lua`.
- Gora verbs do not `CreateFrame`, `SendChatMessage`, or `SendAddonMessage`. They do not write `ChurchOfBeefDB`.

This lane did not edit `tests/run.lua`. Raw `lua tests/test_gora_ceremony.lua` still needs the harness `assert_*` helpers (pre-existing; that file has no standalone wrap and this lane was forbidden to edit it).

## Leftovers (other lanes — not fixed)

- **Integrator:** add `test_gora` to `tests/run.lua`. The runner will report the new file as unlisted until then. Do not treat that as a product miss.
- **Store:** `RecordGoraResult` does not persist free-ruling text. `FreeRuling` returns the line; Store stores `ruling = "free"`. Store also requires a `won` flag on `free`, so both characters are written `won = false` when the Pope does not name a victor.
- **Director Console / Fight HUD / favor / INPUT / `#8` / elevation ceremony** are not this lane.
- Leftover `Challenge` TTL (1800) and `PENDING_MAX` (20) remain demo numbers on the pair-key notes. They are not a petition freshness window.

## Concerns

- One live sanctioned pair at a time. A different pair is refused until the Pope rules or the event ends. Same pair may update the stipulation.
- Famous Upsets are not computed (`famousUpset` stays false unless a later Pope-flag lane sets it).
- `OPEN_QUESTIONS.md` was not edited. Defense increment, Famous Upsets computation, petition cooldown duration, and `#8` stay untouched.
- Do not claim V1 complete. Client smoke and a human Gathering (Bible §22.3) were not run.
