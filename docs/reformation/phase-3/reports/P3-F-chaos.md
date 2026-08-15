# Phase 3 Lane F — Ceremony chaos tests (quality bar)

**Status:** DONE

**Cited:** Ten Laws 4, 5, 6; Bible §20.3, §20.4, §13.1, §13.4; brief `docs/reformation/phase-3/briefs/P3-F-chaos.md`; `.cursor/rules/ceremony-runtime.mdc` (Chaos test; Disconnect); `GATE1_DESIGN_LEAD_DIRECTIVE.md` §4 **#8 do not code**. Lanes A–E are signed.

Isolated compose-only suite. No TOC / bootstrap / `tests/run.lua` / BeefNet / Codec / Runtime / Snapshot / Sender / Store / UI edits. No `Data/Popes.lua`. No `SendAddonMessage`. No whisper routing. No holdSeconds. No new verbs, TYPEs, or snapshot fields. No Quiet toast. No commit. `OPEN_QUESTIONS.md` unchanged. §20.4 five / thirty is the quality bar, not a timer.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_ceremony_chaos.lua` | Created first. Isolated suite: Common + Runtime + Codec + Snapshot + Sender. |
| `docs/reformation/phase-3/reports/P3-F-chaos.md` | This file |

Production files were read only. Signed APIs were not edited.

## Chaos (compose, do not invent)

§20.4: the runtime must survive, on stream: late arrival, reload, disconnect (including the Pope's), no-show petitioner, disputed outcome. A confused client is acceptable for five seconds and embarrassing for thirty. That is the quality bar — not a timeout constant. Handoff also names spoofed senders, replayed sequences, floods, mid-rite reloads, version skew.

The suite dofiles Common + Runtime + Codec + Snapshot + Sender only. Isolation asserts (`COB.Net` / `Store` / `UI` / `Popes` nil) are wrapped in `if standalone then` so an integrator can list this file in `tests/run.lua` later.

| Named scenario | What the signed APIs actually do |
|----------------|----------------------------------|
| **Late arrival** | Event Mode on Runtime. `Request()` does not change it. `BuildResponse()` then `ResetForTests` + `ApplyResponse` lands Bible fields (event id, state, rite type, subjects, sequence). QUIET `BuildResponse` is `nil, "no event"` (cold and after `EndEvent`). |
| **Reload / mid-rite reload** | `BuildResponse` / `ApplyResponse` and Runtime `Snapshot` / `Restore` resume the same event id, state, rite, subjects, sequence. `awaitingPope` round-trips on Runtime `Restore` when set. Lane C `bibleFields` strips it: the wire and `ApplyResponse` do not carry or Restore the flag. |
| **Pope disconnect** | `MarkPopeLost` holds last state and sets `awaitingPope`. State is not `AWAITING_POPE`. No `Promote` / `TakeOver`. `ClearPopeLost` is not a transition (state and sequence unchanged). `EndEvent` is not automatic; from RITE it remains illegal; from ASSEMBLY it is still an explicit Pope verb. |
| **No-show petitioner** | `Accept(sender, "INPUT")` may be true. Runtime stays ASSEMBLY. No auto-open, auto-end, or snapshot Apply of INPUT. |
| **Disputed outcome** | No `Grant` / `Narrate` / `AutoAdvance` / `Declare`. `CloseRite` / `Continue` / `EndEvent` stay explicit. CONSEQUENCE does not auto-Continue. |
| **Spoofed senders** | `IsRegisteredPope` is always false. `Accept` is false for STATE / SNAPSHOT / theater. Discarded theater is not stored. Do not invent a list to make one true. |
| **Version skew** | `ApplyResponse` of a foreign-major SNAPSHOT returns `nil, "protocol mismatch"`. Runtime unchanged. No toast / `WarnVersion` / `_WarnVersion` on these modules. This lane does not paint Quiet Mode. |
| **Floods** | Forty INPUT `Accept`s do not change Runtime and do not encode theater. `EncodeInput` stays INPUT. SUGGESTION / SYNC_* / HELLO / RANK_COMMIT do not Apply. |
| **Replayed sequences** | `Restore` / `ApplyResponse` replace the event object with the given valid snapshot. There is **no** monotonic-sequence gate. An older snapshot Restores and overwrites later state. Named as leftover, not fixed. |

## API used (signed surface only)

| Module | Methods composed |
|--------|------------------|
| `Runtime` | `ResetForTests`, `Snapshot`, `Restore`, `StartEvent`, `OpenRite`, `CloseRite`, `Continue`, `EndEvent`, `MarkPopeLost`, `ClearPopeLost` |
| `Snapshot` | `Request`, `BuildResponse`, `ApplyResponse` |
| `Codec` | `EncodeInput`, `Decode`, `DecodeInput`, `DecodeSnapshot`, `IsCompatible` |
| `Sender` | `IsRegisteredPope`, `Accept` |
| `Common` | Loaded for `Names.Trim` (Sender identity). No new Common API. |

No new verbs. No new TYPEs. No snapshot fields beyond Bible-named `eventId` / `state` / `riteType` / `subjects` / `sequence`. `awaitingPope` is the Lane E degrade flag, not a wire field.

## Verification

- Isolated suite (`Core/Common.lua` + `Core/Runtime.lua` + `Net/Codec.lua` + `Net/Snapshot.lua` + `Core/Sender.lua`): **481 passed, 0 failed**.
- Lua 5.1.5. No `CreateFrame`. No `SendAddonMessage`. No `dofile` of BeefNet / Store / UI / Ranks / DB / Officer / Archive / Recognition / `Data/Popes.lua`.
- `lua tests/test_ceremony_chaos.lua` exits 0.
- BeefNet, Codec, Runtime, Snapshot, Sender, Store, UI, TOC, bootstrap, `tests/run.lua`, `OPEN_QUESTIONS.md` unread for edits.

## Leftover map (not fixed this lane)

| Leftover | What the suite proved | Who owns it |
|----------|----------------------|-------------|
| **Ungated Apply** | `Accept("Spoof", "SNAPSHOT")` is false, but `ApplyResponse(blob)` has no sender argument and Restores if called anyway. Bytes and Restore are not themselves star authority. | Later Net must compose `Accept` / `IsRegisteredPope` **before** Apply. Do not add a Pope list here. |
| **No sequence gate** | An older SNAPSHOT `ApplyResponse` and an older Runtime `Restore` succeed and overwrite a later event (sequence 3 CONSEQUENCE → sequence 1 ASSEMBLY). Current-sequence replay also Restores. | Do **not** invent a monotonic-sequence gate in this lane. Clients that reconcile “latest Pope sequence” (§13.1) are later Net. |
| **#8 registered-Pope list** | `IsRegisteredPope` is always false. `COB.Popes` is nil. No `Data/Popes.lua`. GATE1 §4: direction only; do not code now. | Phase 4 workspace data (same pattern as `Ranks.lua`), locally overridable. Exact file / UX are not this phase. |
| **Integrator** | This suite is not listed in `tests/run.lua` (Lane F must not edit the runner). `run.lua` discovery will report `test_ceremony_chaos.lua` as unlisted until an integrator adds it. | Integrator / later lane. Isolation asserts are already `if standalone then`. |
| **`awaitingPope` on the wire** | Runtime `Restore` round-trips the flag. Lane C strips it from `BuildResponse` / `ApplyResponse`. A congregation that only Applys a Pope snapshot after disconnect does not land degraded. | Later Net / presentation. Not a sixth state. Not a toast. |
| **§13.4 Quiet notice** | Foreign-major Apply fails closed and leaves Runtime. This lane does not paint “the Church's software has advanced.” `_WarnVersion` stays on BeefNet. | Later Net. The only Quiet notice is that one. |
| **Whisper / persist / theater** | Request / Build / Apply encode and Restore only. Pope SV resume (§20.3) and congregation “awaiting the Pope” paint are not this suite. | Later Net / UI / persist. |

## Do not invent (confirmed)

- No opcode strings, hold-timeout seconds, or snapshot schema.
- No `holdSeconds` / Hold / whisper routing / `SendAddonMessage` / BeefNet load.
- No `Data/Popes.lua`, RegisterPope, or a list that makes `IsRegisteredPope` true.
- No Grant / Narrate / AutoAdvance / Declare / Promote / TakeOver.
- No Quiet toast or second version-mismatch notice.
- No `OPEN_QUESTIONS.md` edit. #8 remains uncoded. Hold duration remains unspecified.
- No V1 / MVP complete claim. Client smoke and a human Gathering (Bible §22.3) are product passes — this harness cannot prove them.
- No git commit.

## Concerns

- Ungated Apply and ungated Restore are the same leftover Lane C named: later Net must keep Pope-only respond / Pope-sender apply. Fail-closed Sender is the product until #8 lands — including a real Pope character.
- Older-snapshot Restore is actual signed behavior, not a test gap. Naming it is the brief. Do not add a sequence gate to make the suite look stricter than the APIs.
- `OPEN_QUESTIONS.md` was not edited.
