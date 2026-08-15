# Phase 3 Lane B — BeefNet v2 codecs (encode/decode only)

**Status:** DONE

**Cited:** Ten Laws 5, 6; Bible §13.1, §13.4, §20.2–20.3; brief `docs/reformation/phase-3/briefs/P3-B-codec.md`; `.cursor/rules/ceremony-runtime.mdc` (Broadcast and catch-up).

Encode/decode only. No `SendAddonMessage`. No TOC / bootstrap / `tests/run.lua` / `Net/BeefNet.lua` / Runtime / Store / UI edits. No HELLO in this module. No SUGGESTION / SYNC_* / RANK_COMMIT. No registered-Pope file (#8), whisper routing, Director Console, hold timers, or SUMMON protocol. No commit. `OPEN_QUESTIONS.md` unchanged.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_net_codec.lua` | Created first. Isolated suite: Common + Codec. |
| `addon/ChurchOfBeef/Net/Codec.lua` | Created after the suite. Closed TYPE encode/decode. |
| `docs/reformation/phase-3/reports/P3-B-codec.md` | This file |

## Wire (engineering, not product)

Framing matches BeefNet: `VERSION:TYPE:fields...`. Protocol major stays **1** — "v2" is the vocabulary, not a new number.

| TYPE | Fields |
|------|--------|
| `STATE` | event id, state, rite type, candidate, fighters, sequence |
| `SNAPSHOT` `request` | role only |
| `SNAPSHOT` `response` | role + the same fields as STATE |
| `INPUT` | kind, character id; confession may append text (last field; colons join back) |

States: `QUIET`, `ASSEMBLY`, `RITE`, `CONSEQUENCE`. Rite types: `Knighting`, `Gora`, `Confession`, `Proclamation`. Input kinds: `petition`, `favor`, `confession`. Snapshot roles: `request`, `response`.

Subjects are Bible-named only (`candidate`, `fighters`). Character ids are positive integers (store-local), never name strings. Fighters are a comma-separated id list. Favor has no side field — the brief did not name one.

## Fail closed

`nil, err` when:

- TYPE is unknown (including `HELLO`, `SUGGESTION`, `SYNC_STATE`, `SYNC_REQUEST`, `RANK_COMMIT`)
- protocol version is missing
- role or kind is missing or not in the closed set
- any table carries `points` / `standing` / Grant-shaped keys (`Grant`, `GrantGora`, `granted`, …)
- rite type is free-text or `RITE` has no type
- INPUT carries theater fields, or petition/favor carries text
- SNAPSHOT request carries STATE fields, or response invents extra schema

A foreign major that is still versioned decodes so a later receiver can drop to Quiet Mode (§13.4). `Encode` stamps protocol 1 only.

## API

| Method | Role |
|--------|------|
| `Encode(msg)` | `msg.type` is `STATE` / `SNAPSHOT` / `INPUT` |
| `Decode(payload)` | Typed table, or `nil, err` |
| `EncodeState(fields)` / `DecodeState(payload)` | State broadcast |
| `EncodeSnapshot(fields)` / `DecodeSnapshot(payload)` | `role` `request` or `response` |
| `EncodeInput(fields)` / `DecodeInput(payload)` | Congregation input; never theater |
| `IsCompatible(version)` | True only for protocol 1 |

Closed sets on the module: `PROTOCOL`, `TYPES`, `STATES`, `RITE_TYPES`, `INPUT_KINDS`, `SNAPSHOT_ROLES`. Getters return copies. Encode does not mutate the caller. Expected failures are `nil, err`. No Send, whisper, hold, Grant, or Pope-list APIs.

## Verification

- Isolated suite (`Core/Common.lua` + `Net/Codec.lua`): **371 passed, 0 failed**.
- Lua 5.1.5. No `CreateFrame`. No `SendAddonMessage`. No `dofile` of BeefNet / Runtime / Store / UI / Ranks.
- `lua tests/test_net_codec.lua` exits 0.
- `BeefNet.lua`, TOC, bootstrap, `tests/run.lua`, Runtime, Store, UI unread for edits.

## Leftovers (other lanes — not fixed)

- **Integrator:** add `Net/Codec.lua` to `ChurchOfBeef.toc` (file exists now). Add `test_net_codec` to `tests/run.lua`. Full harness will report the new suite as unlisted until then.
- **Later / BeefNet:** transport still speaks HELLO only. Wiring these codecs onto send/recv, guild vs whisper, and the §13.4 Quiet version notice is not this lane.
- **Out of scope:** registered-Pope file (#8), whisper routing, hold-timeout seconds, Director Console, SUMMON, favor side, Runtime verbs.

## Concerns

- Protocol major remains 1 so HELLO and v2 kinds can share a number when the integrator wires them. Do not invent a v2 major here.
- SNAPSHOT response is STATE fields plus `role`. That is not a second snapshot schema.
- Player-typed confession text is carried, not performed. Theater render stays a later Pope-origin rule (§13.4).
- `OPEN_QUESTIONS.md` was not edited. #8 remains uncoded.
