# Phase 3 Lane D — Registered-Pope sender stub

**Status:** DONE

**Cited:** Ten Laws 5; Bible §13.4; brief `docs/reformation/phase-3/briefs/P3-D-sender.md`; `.cursor/rules/ceremony-runtime.mdc` (discard non-Pope senders); `GATE1_DESIGN_LEAD_DIRECTIVE.md` §4 **#8 do not code**.

Fail-closed predicate only. No TOC / bootstrap / `tests/run.lua` / BeefNet / Codec / Runtime / UI edits. No `Data/Popes.lua`. No guild-rank read. No config or override UX. No `SendAddonMessage`. No discarded-message store. No Director Console. No commit. `OPEN_QUESTIONS.md` unchanged.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_sender.lua` | Created first. Isolated suite: Common + Sender. |
| `addon/ChurchOfBeef/Core/Sender.lua` | Created after the suite. Fail-closed Pope / Accept predicates. |
| `docs/reformation/phase-3/reports/P3-D-sender.md` | This file |

## Predicate

§13.4: theatrical UI, state, and snapshot messages render only from a registered Pope-character sender. The list is Phase 4 workspace data (#8). This lane is the discard gate so later Net can refuse non-Pope theater.

`IsRegisteredPope` is always `false`. GM, Officer, Council, the name "Pope", and guild rank index 0 are not the Church. The module does not call roster or guild-leader APIs.

`Accept` is `false` for `STATE`, `SNAPSHOT`, and any theater kind. Congregation `INPUT` is not theater: `Accept` returns `true` when `kind == "INPUT"` and the sender is a non-empty string (server-provided identity later). Missing, empty, or whitespace-only sender is `false`. An accepted INPUT sender is still not a registered Pope.

Discarded messages are not stored for later paint.

## API

| Method | Role |
|--------|------|
| `IsRegisteredPope(sender)` | Always `false`. The registered-Pope list is not this phase. |
| `Accept(sender, kind)` | `true` only for `INPUT` with a non-empty sender string. Else `false`. |

No Register / Set / Load Pope APIs. No Send, whisper, hold, Grant, or config APIs. Sender identity uses Common `Names.Trim` so whitespace is missing, not a name.

## Verification

- Isolated suite (`Core/Common.lua` + `Core/Sender.lua`): **193 passed, 0 failed**.
- Lua 5.1. No `CreateFrame`. No `SendAddonMessage`. No `dofile` of BeefNet / Codec / Runtime / Store / UI / Ranks / Officer / `Data/Popes.lua`.
- `lua tests/test_sender.lua` exits 0.
- Guild-rank stubs (`GetGuildRosterInfo`, `GetGuildInfo`, `UnitIsGuildLeader`, …) were not called.
- `BeefNet.lua`, Codec, Runtime, TOC, bootstrap, `tests/run.lua`, UI unread for edits.

## Leftovers (other lanes — not fixed)

- **Integrator:** add `Core/Sender.lua` to `ChurchOfBeef.toc` (file exists now). Add `test_sender` to `tests/run.lua`. Full harness will report the new suite as unlisted until then.
- **Later / BeefNet:** call `Accept` / `IsRegisteredPope` on inbound STATE, SNAPSHOT, and theater. Wire INPUT as console input only.
- **Phase 4 / #8:** workspace registered-Pope list (same pattern as `Ranks.lua`), locally overridable. Exact file, edit path, and override UX are not this lane.

## Concerns

- Fail-closed is the product until #8 lands. No client can paint theater from the wire, including a real Pope character. That is the brief, not a bug.
- INPUT acceptance is identity presence, not authority. `IsRegisteredPope` stays false for the same sender.
- `OPEN_QUESTIONS.md` was not edited. #8 remains uncoded.
