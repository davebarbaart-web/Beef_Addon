# B3-E — Congregation Snapshot request send (report)

**Status:** DONE

**Cited:** Bible §20.3; brief `docs/reformation/vestments/briefs/B3-E-snapshot.md`.

Congregation catch-up send. `Net:RequestSnapshot(target, nowSeconds)` whispers `Snapshot:Request()` / `1:SNAPSHOT:request` to the given target. Not Pope-gated. Missing target → `false, "no target"`. No Pope-name lookup. `SendState` / `SendSnapshot` / `SendDecree` stay Pope-gated. No new codec kind. Exclusive files only. No commit. Lane is not signed.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_net_v2.lua` | `RequestSnapshot` exists. No target / empty target → `"no target"`. Given target whispers once (`Steakina`, existing suite name). Body is `Snapshot:Request()`. Empty Popes list still blocks `SendState` / `SendDecree` / `SendSnapshot`. Isolation stays under `if standalone then`. |
| `addon/ChurchOfBeef/Net/BeefNet.lua` | `RequestSnapshot`. Header: congregation whisper, not Pope-gated. |
| `docs/reformation/vestments/briefs/B3-E-snapshot-report.md` | This file |
| `docs/reformation/vestments/briefs/B3-E-snapshot.diff` | B3-E-only unified diff of the exclusive files |

Did not edit Codec, Snapshot.lua, Data/Popes.lua, Sender, Runtime, UI, TOC, bootstrap, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not commit.

## Contract

### Send

| Method | Gate | Channel | Notes |
|--------|------|---------|-------|
| `RequestSnapshot(target, nowSeconds)` | none | WHISPER via `_TransmitWhisper` | Requires `target`. Body is `Snapshot:Request()` (`Codec:EncodeSnapshot({ role = "request" })` if Snapshot is missing). Size cap 240. |
| `SendState` / `SendSnapshot` / `SendDecree` | `_LocalPope()` | GUILD / WHISPER | Unchanged. Empty Popes list still fail-closed. |
| `SendFavor` | none | WHISPER | Unchanged. |

No Pope-name lookup. No new codec kind. Petition / confession stay unknown.

### Recv

Unchanged. Inbound SNAPSHOT request is still answered only if `_LocalPope()`.

## Tests

1. Extended `test_net_v2.lua` (API, missing / empty target, whisper spy, empty Popes still blocks SendState). Isolation unchanged.
2. Implemented `BeefNet.lua`.
3. Green: `lua tests/test_net_v2.lua` — **433 passed, 0 failed**.

Whisper target in the suite is `Steakina` (already used). Not a listed Pope. `COB.Popes` stays nil.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_net_v2.lua   # 433 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_net_v2.lua` standalone | 433 passed, 0 failed. Lua 5.1. Exit 0. |

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). Two-client smoke was not run.

## Self-review

- Exclusive files only. No Pope name in `Data/Popes.lua`. Empty list still fail-closed for SendState / SendSnapshot / SendDecree.
- RequestSnapshot is congregation-safe: not Pope-gated, whisper-only, given target only.
- Body is the existing SNAPSHOT request role. No fifth TYPE. HELLO types unchanged.
- `nowSeconds` is accepted for the brief signature and unused (whisper is immediate, same as `SendFavor` / `SendSnapshot`).
- `_TransmitWhisper` is immediate, not the GUILD outbound queue. Suite spies (`wire` / `sent`) confirm one whisper; `#Net.queue` stays 0.
- Live client still needs a caller-supplied Pope character name plus two-client smoke. Inbound answer still requires `_LocalPope()`. Not claimed signed.

## Status

**DONE.** Not signed.
