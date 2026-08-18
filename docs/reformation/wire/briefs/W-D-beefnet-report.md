# W-D — BeefNet: DECREE + FAVOR whisper + SendState (report)

**Status:** DONE

**Cited:** CONTINUE 2026-08-18 licenses 1–2; Bible §13.1, §10.6, §14.1; brief `docs/reformation/wire/briefs/W-D-beefnet.md`.

Transport only. `SendState` / `SendSnapshot` / `SendDecree` stay Pope-gated via `_LocalPope()`. `SendFavor` is congregation whisper and is not Pope-gated. Inbound `DECREE` uses `Sender:IsRegisteredPope` (not `Accept`). Favor INPUT is live only on WHISPER to a local Pope. Petition / confession / favor-on-GUILD stay unknown. No inbox, no Runtime Restore, no fan-out, no HELLO types, no `holdSeconds`, no sequence gate. Exclusive files only. No commit. Lane is not signed.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_net_v2.lua` | TDD first. Favor `pick` on encode. Non-Pope favor whisper → `not a registered pope`. Stubbed-Pope SendDecree / inbound DECREE Set / RecordFavor. Petition/confession stay unknown. Isolation stays under `if standalone then`. |
| `addon/ChurchOfBeef/Net/BeefNet.lua` | `SendDecree`, `SendFavor`. `_HandleV2` routes DECREE + favor-whisper INPUT. `_HandleDecree` / `_HandleFavor`. Header: INPUT live only for favor whisper-to-Pope. |
| `docs/reformation/wire/briefs/W-D-beefnet-report.md` | This file |
| `docs/reformation/wire/briefs/W-D-beefnet.diff` | `git diff -- addon/ChurchOfBeef/Net/BeefNet.lua tests/test_net_v2.lua` |

Did not edit Codec, Gora, Store, UI, TOC, bootstrap, Sender, Snapshot, Runtime, `tests/run.lua`, OPEN_QUESTIONS, REFORMATION_LOG, or `Data/Popes.lua`.

## Contract

### Send

| Method | Gate | Channel | Notes |
|--------|------|---------|-------|
| `SendState` / `SendSnapshot` | `_LocalPope()` | GUILD / WHISPER | Unchanged. Empty Popes list still fail-closed. |
| `SendDecree(fields, nowSeconds)` | `_LocalPope()` or `false, "not a registered pope"` | GUILD via `Send` | `EncodeDecree`. Codec errors (`invalid line`, …) pass through. Size cap 240 via `Send`. |
| `SendFavor(fields, target, nowSeconds)` | none | WHISPER via `_TransmitWhisper` | Requires `target`. Encodes `kind = "favor"` + `characterId` + `pick` only — cannot send petition/confession. Size cap 240. |

No `SendInput`. No Pope-name lookup.

### Recv (`_HandleV2`)

- `DECREE` on GUILD: `Sender:IsRegisteredPope(sender)`. Then `COB.Decree:Set({ line, flavor })` when Decree offers `Set`. Wrong channel → discard. Non-Pope → `"not accepted"`. Never Restore Runtime.
- `INPUT` + `kind == "favor"` on WHISPER only: if not `_LocalPope()` → `"not a registered pope"`. If local Pope: `Gora:RecordFavor(characterId, pick)` when Gora offers it. Missing pick / RecordFavor error → no inbox. Never Restore. Never fan out.
- Petition / confession / favor-on-GUILD → `"unknown message type"`.

`Accept(sender, "DECREE")` is false today and is not used.

## TDD

1. Baseline Codec: `EncodeDecree` and `EncodeInput` favor+pick present (`1:DECREE:…`, `1:INPUT:favor:2:1`). Not BLOCKED.
2. Extended `test_net_v2.lua` first (APIs, favor non-Pope discard, stubbed Pope send/recv, petition/confession unknown).
3. Red: `SendDecree exists` / `SendFavor exists` nil; favor whisper still `"unknown message type"`; suite then aborted on `Net:SendDecree` (nil).
4. Implemented `BeefNet.lua`.
5. Green: `lua tests/test_net_v2.lua` — **403 passed, 0 failed**.

Pope predicate is stubbed name-aware (`Names.Key(sender) == "beefina"`) and restored after those cases. Gora / Decree are stubbed; the isolated suite does not load them.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_net_v2.lua   # 403 passed, 0 failed
lua tests/run.lua           # 6366 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_net_v2.lua` standalone | 403 passed, 0 failed. Lua 5.1. Exit 0. |
| `lua tests/run.lua` | 6366 passed, 0 failed. Exit 0. |

## Self-review

- Exclusive files only. No Pope name in `Data/Popes.lua`. Empty list still fail-closed for SendState / SendDecree / inbound DECREE / Pope-side favor tally.
- Favor send is congregation-safe: not Pope-gated, whisper-only, forced `kind = "favor"`.
- Congregation clients cannot tally (`_LocalPope()`).
- No latest-wins / sequence gate. No `holdSeconds`. No HELLO type added.
- `SendFavor`'s `nowSeconds` is accepted for the brief signature and unused (whisper is immediate, same as `SendSnapshot`).
- Live client still needs a registered Pope (David's list / override) plus two-client smoke. Not claimed signed.

## Status

**DONE.** Not signed.
