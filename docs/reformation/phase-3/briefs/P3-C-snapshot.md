# Phase 3 Lane C — Snapshot request / response (Core apply)

Read: Ten Laws 5, 6; Bible §20.3, §13.1; `.cursor/rules/ceremony-runtime.mdc` (whisper to the Pope only). Lanes A and B are signed.

## Exclusive files

- `addon/ChurchOfBeef/Net/Snapshot.lua` (create)
- `tests/test_net_snapshot.lua` (create)
- Report: `docs/reformation/phase-3/reports/P3-C-snapshot.md`

**Do not** edit TOC, bootstrap, `tests/run.lua`, `Net/BeefNet.lua`, `Net/Codec.lua`, `Core/Runtime.lua`, UI.

## Mission

Test-first. Isolated suite: Common + Runtime + Codec + Snapshot.

Catch-up is **not** peer SYNC. Congregation **requests**; only the Pope client **responds**. This lane is apply/build, not the whisper send.

- **Request()** — `Codec:EncodeSnapshot({ role = "request" })`. Does not change Runtime.
- **BuildResponse()** — from `Runtime:Snapshot()` via `Codec:EncodeSnapshot({ role = "response", ...STATE fields })`. If Runtime is QUIET (no event), return `nil, err` — there is nothing to catch up to. Do not invent a second snapshot schema.
- **ApplyResponse(blob)** — `Codec:DecodeSnapshot` then `Runtime:Restore` of the Bible-named fields only. Fail closed if decode fails, `IsCompatible` is false, or role is not `response`. Do not apply a request. Do not apply SUGGESTION / SYNC_*.

Do not `SendAddonMessage`. Do not invent whisper routing, Officer+/Council answer, registered-Pope file (#8), hold timers, or GUILD fan-out.

Later Net will send Request on whisper-to-Pope and call BuildResponse only on the Pope client. Do not code that gate here.

## Do not git commit.
