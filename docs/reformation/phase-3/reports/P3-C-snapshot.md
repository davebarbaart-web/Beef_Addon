# Phase 3 Lane C — Snapshot request / response (Core apply)

**Status:** DONE

**Cited:** Ten Laws 5, 6; Bible §20.3, §13.1; brief `docs/reformation/phase-3/briefs/P3-C-snapshot.md`; `.cursor/rules/ceremony-runtime.mdc` (whisper to the Pope only). Lanes A and B signed.

Apply/build only. No TOC / bootstrap / `tests/run.lua` / `Net/BeefNet.lua` / `Net/Codec.lua` / `Core/Runtime.lua` / UI edits. No `SendAddonMessage`. No whisper routing, Officer+/Council answer, registered-Pope file (#8), hold timers, or GUILD fan-out. No extra snapshot schema. No peer `SYNC_*`. No commit. `OPEN_QUESTIONS.md` unchanged.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_net_snapshot.lua` | Created first. Isolated suite: Common + Runtime + Codec + Snapshot. |
| `addon/ChurchOfBeef/Net/Snapshot.lua` | Created after the suite. Request / BuildResponse / ApplyResponse. |
| `docs/reformation/phase-3/reports/P3-C-snapshot.md` | This file |

## Catch-up (not peer SYNC)

Congregation **requests**; only the Pope client **responds**. This lane encodes and Restores. Later Net will send Request on whisper-to-Pope and call BuildResponse only on the Pope client. That gate is not coded here.

- **Request()** — `Codec:EncodeSnapshot({ role = "request" })`. Wire is `1:SNAPSHOT:request`. Does not change Runtime.
- **BuildResponse()** — `Runtime:Snapshot()` then `Codec:EncodeSnapshot({ role = "response", ...STATE fields })`. If Runtime is QUIET (no event — cold, or after EndEvent), `nil, "no event"`. Same STATE fields as Lane B. No second schema.
- **ApplyResponse(blob)** — `Codec:DecodeSnapshot` then `Runtime:Restore` of Bible-named fields only (`eventId`, `state`, `riteType`, `subjects`, `sequence`). Fail closed: bad decode, `IsCompatible` false (`"protocol mismatch"`), role not `response` (`"invalid role"`). Does not apply a request. Does not apply SUGGESTION / SYNC_* / STATE / INPUT / HELLO / RANK_COMMIT.

A Codec-valid body that Runtime Restore refuses (CONSEQUENCE without a type, ASSEMBLY with a rite type, free-text rite, sixth state) fails at Restore and leaves Runtime unchanged. That seam is not collapsed into a third schema.

## API

| Method | Role |
|--------|------|
| `Request()` | Encode a SNAPSHOT request. Extra args ignored. |
| `BuildResponse()` | Encode the live Runtime event as a SNAPSHOT response, or `nil, "no event"` when QUIET. Extra args ignored. |
| `ApplyResponse(blob)` | Decode a response and Restore Bible fields. Extra args ignored. |

Expected failures are `nil, err`. Apply success is `true` (Restore). No Send, whisper, hold, Grant, Pope-list, or SYNC APIs.

## Verification

- Isolated suite (`Core/Common.lua` + `Core/Runtime.lua` + `Net/Codec.lua` + `Net/Snapshot.lua`): **471 passed, 0 failed**.
- Lua 5.1.5. No `CreateFrame`. No `SendAddonMessage`. No `dofile` of BeefNet / Store / UI / Ranks / DB.
- `lua tests/test_net_snapshot.lua` exits 0.
- `BeefNet.lua`, Codec, Runtime, TOC, bootstrap, `tests/run.lua`, UI unread for edits.

## Leftovers (other lanes — not fixed)

- **Integrator:** add `Net/Snapshot.lua` to `ChurchOfBeef.toc` (file exists now). Add `test_net_snapshot` to `tests/run.lua`. Full harness will report the new suite as unlisted until then.
- **Later / BeefNet:** send Request on whisper-to-Pope; call BuildResponse only on the Pope client; apply only from a registered Pope-character sender (#8 — do not code). No GUILD fan-out. No Officer+/Council answer.
- **Out of scope:** hold-timeout seconds, “awaiting the Pope,” Director Console, SUMMON, Quiet version-mismatch notice (the only Quiet notice is later, §13.4).

## Concerns

- These APIs are ungated wherever the file loads. Bytes and Restore are not themselves star authority. Later Net must keep the Pope-only respond / Pope-sender apply rule. Do not add a Pope list this lane.
- EndEvent leaves a leftover `eventId` on QUIET. BuildResponse still refuses: Quiet Mode is not catch-up. Key Event Mode off `state ~= "QUIET"`, not `eventId ~= nil`.
- Foreign-major SNAPSHOT responses decode in Codec so this lane can refuse Restore (`IsCompatible`). That is the §13.4 hook, not a Quiet toast.
- `OPEN_QUESTIONS.md` was not edited. #8 remains uncoded.
