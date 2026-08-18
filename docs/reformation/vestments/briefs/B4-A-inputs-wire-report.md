# B4-A — Petition and confession INPUT on the wire (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §9, §10.2, §13.1, §13.4, §18.5; CONTINUE license 2 (INPUT whisper-to-Pope); brief `docs/reformation/vestments/briefs/B4-A-inputs-wire.md`.

Transport only. `SendPetition` / `SendConfession` mirror `SendFavor`: congregation whisper, not Pope-gated, missing target → `false, "no target"`. No Pope-name lookup. Petition body is `characterId` only (no named opponent). Confession text is optional; a string containing `"\n"` is refused before encode. Inbound INPUT is live on WHISPER only. Favor still hits `_HandleFavor`. Petition as local Pope calls `Gora:Petition(characterId)`. Confession as local Pope calls `Confession:Receive` when the module exists; missing module fail-closes. GUILD INPUT stays unknown. Exclusive files only. No commit. Lane is not signed.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_net_v2.lua` | TDD first. `SendPetition` / `SendConfession` exist. No target / empty target → `"no target"`. Given target whispers once; petition payload `1:INPUT:petition:12`; confession with text encodes; newline refused. Empty Popes list still blocks `SendState`. Inbound petition / confession WHISPER as stubbed local Pope calls `Gora:Petition` / `Confession:Receive`. GUILD INPUT petition stays unknown. Isolation stays under `if standalone then`. |
| `addon/ChurchOfBeef/Net/BeefNet.lua` | `SendPetition`, `SendConfession`. `_HandleV2` routes whisper INPUT kinds. `_HandlePetition` / `_HandleConfession`. Header: petition/confession live on whisper-to-Pope. |
| `docs/reformation/vestments/briefs/B4-A-inputs-wire-report.md` | This file |
| `docs/reformation/vestments/briefs/B4-A-inputs-wire.diff` | `git diff -- addon/ChurchOfBeef/Net/BeefNet.lua tests/test_net_v2.lua` |

Did not edit Codec, Snapshot.lua, Data/Popes.lua, Gora, Confession source, Sender, Runtime, UI, TOC, bootstrap, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not commit.

## Contract

### Send

| Method | Gate | Channel | Notes |
|--------|------|---------|-------|
| `SendPetition(fields, target, nowSeconds)` | none | WHISPER via `_TransmitWhisper` | Requires `target`. Encodes `{ kind = "petition", characterId }` only. Size cap 240. |
| `SendConfession(fields, target, nowSeconds)` | none | WHISPER via `_TransmitWhisper` | Requires `target`. Encodes `{ kind = "confession", characterId, text }` (text optional). Newline in `text` → `false, "invalid text"` before encode. Size cap 240. |
| `SendFavor` | none | WHISPER | Unchanged. |
| `SendState` / `SendSnapshot` / `SendDecree` | `_LocalPope()` | GUILD / WHISPER | Unchanged. Empty Popes list still fail-closed. |
| `RequestSnapshot` | none | WHISPER | Unchanged. |

No `SendInput`. No Pope-name lookup. No named-opponent field. No new codec kind.

### Recv (`_HandleV2`)

- INPUT on a channel other than WHISPER → `"unknown message type"`.
- `kind == "favor"` → existing `_HandleFavor`.
- `kind == "petition"` → `_LocalPope()` or `false, "not a registered pope"`; then `Gora:Petition(characterId)` if Gora offers `Petition`. No named opponent. Missing Gora / `Petition` → `false`. Core error passed through. Never Restore. Never fan out. No inbox.
- `kind == "confession"` → `_LocalPope()` same; if `COB.Confession` and `Receive` exist, `Receive(characterId, text)`. Missing module → `false` (fail-closed). Never invent a queue in BeefNet.

## TDD

1. Extended `test_net_v2.lua` first (APIs, missing / empty target, whisper spy, newline refuse, empty Popes still blocks SendState, stubbed Pope recv, GUILD unknown). Isolation unchanged.
2. Red: `SendPetition` / `SendConfession` nil; whisper petition/confession still `"unknown message type"`; suite then aborted on `Net:SendPetition` (nil).
3. Implemented `BeefNet.lua`.
4. Green: `lua tests/test_net_v2.lua` — **523 passed, 0 failed**.

Pope predicate is stubbed name-aware (`Names.Key(sender) == "beefina"`) and restored after those cases. Gora / Confession are stubbed; the isolated suite does not load them. Whisper target in the suite is `Pope` (already used by `SendFavor`). Not a listed Pope. `COB.Popes` stays nil.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_net_v2.lua   # 523 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_net_v2.lua` standalone | 523 passed, 0 failed. Lua 5.1. Exit 0. |

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). Two-client smoke was not run.

## Self-review

- Exclusive files only. No Pope name in `Data/Popes.lua`. Empty list still fail-closed for SendState / SendSnapshot / SendDecree / Pope-side INPUT.
- Send is congregation-safe: not Pope-gated, whisper-only, given target only. Petition cannot carry a named opponent.
- Congregation clients cannot apply (`_LocalPope()`). GUILD INPUT stays unknown.
- `nowSeconds` is accepted for the brief signature and unused (whisper is immediate, same as `SendFavor` / `RequestSnapshot`).
- `_TransmitWhisper` is immediate, not the GUILD outbound queue. Suite spies (`wire` / `sent`) confirm one whisper; `#Net.queue` stays 0.
- Live confession recv fail-closes until B4-C lands `COB.Confession:Receive`. Live petition recv needs a Pope client plus `Gora:Petition`. Live send still needs a caller-supplied Pope character name plus two-client smoke. Not claimed signed. Not Gate W/V. Not POLISH:PASS.

## Concerns

- `tests/test_wire_glue.lua` still pins whispered petition as `"unknown message type"`. After this lane, a non-Pope whisper returns `"not a registered pope"` (same as favor). That suite is outside the exclusive set; the integrator must update it. Isolated `test_net_v2.lua` is green.

## Status

**DONE_WITH_CONCERNS.** Not signed.
