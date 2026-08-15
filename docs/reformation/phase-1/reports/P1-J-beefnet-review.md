# Phase 1 Lane J — Adversarial Review

**Lane:** BeefNet message cut  
**Exclusive files:** `addon/ChurchOfBeef/Net/BeefNet.lua`, `tests/test_net_validate.lua`, `tests/test_net_adversarial.lua`  
**Lane report:** `docs/reformation/phase-1/reports/P1-J-beefnet.md`  
**Writer:** [BeefNet cut](d416a189-24bf-4a73-b8bb-7022d7b5091b)  
**Cited law:** Ten Laws 1, 5, 6; Bible §13.1, §13.4, §21.3; GATE1_DESIGN_LEAD_DIRECTIVE.md §3c (HELLO stays); brief `docs/reformation/phase-1/briefs/P1-J-beefnet.md`

**Spec:** PASS  
**Quality:** Approved

Transport skeleton and HELLO remain. `SendSuggestion` / `OnLocalSuggestion` / `HandleSuggestion` / standing / threshold / petition hold / promote toasts are gone. `SUGGESTION` is a retired discard name only — never handled. No BeefNet v2 codecs, snapshots, or Pope broadcasts. Isolated net suites are green and do not `dofile` Ladder/Scoring. Writer did not edit TOC / bootstrap / `tests/run.lua` / Core / UI. This review did not restore SUGGESTION and did not invent product.

## Verdict

Refutation of GATE1 §3c / Law 1 / Law 5 / Law 6 **fails** for this lane’s exclusive files.

Law 1 (no points economy) is not refuted by the `SUGGESTION` string in `RETIRED_TYPES`. That table names old wires so they die quietly. No standing is stored, no threshold is compared, no petition is queued, no Grant path remains. Generic `Encode` / `Send` can still emit retired bytes (the kept wire). Nothing in live `addon/` builds those bytes, and inbound never acts on them.

Law 5 (Pope-authoritative star) is not refuted by HELLO. GATE1 §3c names version/presence discovery as transport that survives into v2. `HandleHello` writes a sender → addon-version note. `PeerCount` is unused by UI and Core. No ranks, verdicts, or consensus. Witnesses still do not rule.

Law 6 (Quiet Mode) is not refuted by `_WarnVersion`. GATE1 §1 already ratified the version-mismatch notice as the sole permitted Quiet notice. HELLO does not call `NotifyStatus` (probed). Roster-path `NotifyStatus` only refreshes the player-opened `/beef` chip. No Toasts, no promote pip, no feed.

The banned engines this lane was asked to kill were the suggestion fanout and everything standing / threshold-shaped on the wire. They are gone. What remains is the wire.

## Confirmations

| Check | Result |
|---|---|
| HELLO + transport skeleton kept | **Yes.** Prefix `COB`, channel `GUILD`, `PROTOCOL = 1`, `VERSION:TYPE:fields...` framing, 240-byte cap, outbound burst 10 / 1 per second / queue 60, inbound burst 5 / 0.2 per second / sender cap, version discard, API guards, server-provided sender as identity. `SendHello` / `HandleHello` / `PeerCount` remain. |
| `SendSuggestion` / `OnLocalSuggestion` / `HandleSuggestion` gone | **Yes.** All nil (probed). Suites lock the first three. |
| Standing / threshold / petition hold / promote toasts gone | **Yes.** `ReleaseHeld`, `MaxHeld`, `_Hold`, `held`, `RefreshLadder`, `toastCelebrate`, `paintPending`, `RosterLookup`, `RosterReady` are nil. No `COB.Toasts` call. No `standing` / `threshold` / `Grant(` in `BeefNet.lua`. |
| `SUGGESTION` is retired discard only | **Yes.** Named in `RETIRED_TYPES` with `RANK_COMMIT` / `SYNC_REQUEST` / `SYNC_STATE`. `OnAddonMessage` returns `"retired message type"` before any handler. Suites lock that it seats no peer. |
| No BeefNet v2 codecs / snapshots / Pope broadcasts | **Yes.** `PROTOCOL` stays 1. `SNAPSHOT` / `STATE` / `SCORE_EVENT` decode as `"unknown message type"`. No snapshot schema, no whisper catch-up, no state opcode. Header forbids them. |
| Net suites do not `dofile` Ladder/Scoring; isolated green | **Yes.** Load is `Core/Common.lua` + `Net/BeefNet.lua` only. Re-ran: **70 passed, 0 failed** and **35 passed, 0 failed.** Writer counts match. Repo `tests/` has zero `dofile` of Ladder/Scoring. |
| Writer did not edit TOC / bootstrap / `run.lua` / Core / UI | **Yes.** Transcript Writes: `Net/BeefNet.lua`, `tests/test_net_validate.lua`, `P1-J-beefnet.md`. `test_net_adversarial.lua` is rewritten to the same contract (transcript multi-Write turn is truncated; file on disk matches). Those other paths are dirty from parallel lanes. |
| No commit; `OPEN_QUESTIONS.md` unchanged | **Yes.** No commit. Writer did not touch `OPEN_QUESTIONS.md`. |

Public functions after load: `CanSend`, `Decode`, `Encode`, `HandleHello`, `Init`, `IsCompatible`, `IsSelf`, `NotifyStatus`, `OnAddonMessage`, `OnRosterUpdate`, `PeerCount`, `PlayerName`, `Pump`, `RequestRoster`, `ResetForTests`, `Send`, `SendHello`, plus the kept throttle / roster-retry helpers. No suggestion / hold / toast / ladder-paint function.

## Attack results

| Attack | Result |
|---|---|
| Law 1 — `SUGGESTION` in `RETIRED_TYPES` is a live standing codec? | **No.** Discard table only. Inbound returns `"retired message type"`. `PeerCount` stays 0. No `HandleSuggestion`. GATE1 §5.3 `suggestion` hit is waived here as a named discard, not a comment and not a live codec. The string must stay so an older build’s petition dies by name. |
| Law 1 — generic `Encode`/`Send` still emits standing-shaped bytes? | **No product path.** Probe: `Encode("SUGGESTION", ...)` + `Send` returns true (transport). Live `addon/` has zero `Encode("SUGGESTION"` / `SendSuggestion` callers. Inbound still discards. An outbound type allowlist would be a v2 codec gate. Not this phase. |
| Law 5 — HELLO / `peers` / `PeerCount` is peer self-reported authority? | **No.** GATE1 §3c keeps HELLO as version/presence. Stored value is the peer’s addon version string. `PeerCount` has no UI or Core caller. No ranks, verdicts, or store writes. Presence is not a second writer. |
| Law 5 — `OnRosterUpdate` → `Officer:RefreshRosterCache` restores Officer+? | **No.** Fallback is roster-cache sensing if `Roster` is absent. Lane I already fail-closed `LocalIsOfficer`. This lane no longer calls `GetRosterLookup` / `LocalIsOfficer`. |
| Law 5 — `SYNC_STATE` / `SYNC_REQUEST` rebuilt as gossip? | **No.** Retired discard, same door as SUGGESTION. Tests lock the reason string. |
| Law 6 — `_WarnVersion` chat is a Quiet toast/feed? | **No.** GATE1 §1: the version-mismatch notice is the sole permitted Quiet notice. Fires once. Suites lock that. Not a toast-kind family. |
| Law 6 — HELLO or `NotifyStatus` paints ambient chrome? | **No.** Probe: a peer HELLO does **not** call `UI:OnStatusChanged`. `NotifyStatus` runs on the roster path only and refreshes the player-opened `/beef` chip (`unguilded` / `roster_wait` / §13.4 word). No Toasts. No promote pip. |
| GATE1 §3c — HELLO deleted, or v2 invented in its place? | **No.** Live `TYPES` is HELLO only. `PROTOCOL` remains 1. Suites lock both. |
| Writer restored SUGGESTION “so tests pass”? | **No.** Suites assert the handlers are nil and the type is retired. Isolated 70/0 and 35/0. |
| Writer edited forbidden files? | **No.** Exclusive writes only. |
| Isolated suites still `dofile` deleted engines? | **No.** Common + BeefNet only. |

Refutation of Law 1 (no points economy), Law 5 (Pope-authoritative star), Law 6 (Quiet Mode), and GATE1 §3c (HELLO stays; SUGGESTION dies) **fails** for the exclusive files.

## Leftover callers (other lanes — expected; not fixed)

Writer leftover map is partly stale. `lua tests/run.lua` is **green on this tree** (489 passed, 0 failed). That was integrator / other-lane work, not this writer editing `run.lua`.

| File | What remains |
|------|----------------|
| `ChurchOfBeef.lua` | `Net:Init()` / public `Net:Send` — transport, kept. Slash comment still points `/run` forging at `Net:Send`. |
| `UI/MainFrame.lua` | `Net:RequestRoster` — sensing, kept. `UI:RefreshLadder` remains; comment still says “BeefNet still invokes RefreshLadder.” **That comment is now false** — BeefNet no longer calls it. Body is optional `Minimap:Refresh` only. Writer correctly did not edit UI. |
| `UI/Status.lua` | reads `Net.warnedVersion` — §13.4 chip, kept. |
| `UI/Toasts.lua` | leftover `Celebrate` engine (P1-L already cut promote / rite / grant kinds). BeefNet does not call it. |
| `Core/Officer.lua` | roster cache still exists. `OnRosterUpdate` still falls back to `RefreshRosterCache` if Roster is absent. No `GetRosterLookup` / `LocalIsOfficer` ask from this lane. |

`PeerCount` has no live `addon/` caller outside `BeefNet.lua`.

## Findings

### Critical

None.

### Important

None for this lane’s exclusive files.

### Nit

1. **Writer leftover map is stale** (`P1-J-beefnet.md`). It still says `lua tests/run.lua` is red from integrator leftovers. On this tree the full harness is 489/0. Report accuracy only; J correctly did not edit `run.lua`.

2. **MainFrame `RefreshLadder` comment is stale.** Name was kept because BeefNet invoked it. This cut deleted that invoke. Other-lane leftover; not a Spec miss.

3. **`Encode` / `Send` have no outbound type allowlist.** A `/run` can still put `1:SUGGESTION:...` on the guild channel. Receivers discard it. Do not add an allowlist here — that would be inventing a v2 gate.

4. **Suites lock suggestion/hold nil, not every deleted helper.** `RefreshLadder` / `toastCelebrate` / `paintPending` / `RosterLookup` are nil (probed) but unasserted. Not a Spec miss.

5. **Version-notice copy is the old BeefNet line**, not Bible §13.4’s “the Church's software has advanced.” Writer kept the existing notice rather than inventing new copy. Leave it.

## Brief contract

| Requirement | Result |
|---|---|
| Keep transport: throttle, inbound limits, framing, prefix, GUILD, version discard | Met |
| Keep HELLO (version/presence; survives into v2) | Met |
| Delete SUGGESTION send/handle and standing / threshold / petition / promote-toast paths | Met |
| Retired types discarded, never acted on | Met |
| Do not invent BeefNet v2 codecs, snapshots, or Pope broadcasts | Met |
| Rewrite net suites; no `dofile` of Ladder/Scoring; isolated green | Met (70 / 0 and 35 / 0) |
| Do not edit TOC / bootstrap / `run.lua` / Core / UI | Met |
| Report leftovers; do not fix them | Met (map now partly stale; see Nit) |
| No commit | Met |
| Do not invent product | Met |
| SUGGESTION not restored this review | Met |

## Sections checked

- Brief `docs/reformation/phase-1/briefs/P1-J-beefnet.md`
- Writer report `docs/reformation/phase-1/reports/P1-J-beefnet.md`
- `docs/reformation/phase-0/TEN_LAWS.md` Laws 1, 5, 6
- GATE1_DESIGN_LEAD_DIRECTIVE.md §3c (HELLO stays) and §1 (version-mismatch notice)
- Bible §13.1, §13.4, §21.3
- `addon/ChurchOfBeef/Net/BeefNet.lua` (live + probe)
- `tests/test_net_validate.lua` / `tests/test_net_adversarial.lua` (isolated 70/0 and 35/0)
- Writer transcript (exclusive writes; no TOC / bootstrap / `run.lua` / Core / UI)
- Live leftovers: `ChurchOfBeef.lua`, `UI/MainFrame.lua`, `UI/Status.lua`, `UI/Toasts.lua`, `Core/Officer.lua`
- `docs/design/OPEN_QUESTIONS.md` (unchanged by this writer)
