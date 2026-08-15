# Phase 3 Lane D — Registered-Pope sender stub

Read: Ten Laws 5; Bible §13.4; `.cursor/rules/ceremony-runtime.mdc` (discard non-Pope senders); `GATE1_DESIGN_LEAD_DIRECTIVE.md` §4 **#8 do not code**.

## Exclusive files

- `addon/ChurchOfBeef/Core/Sender.lua` (create)
- `tests/test_sender.lua` (create)
- Report: `docs/reformation/phase-3/reports/P3-D-sender.md`

**Do not** edit TOC, bootstrap, `tests/run.lua`, BeefNet, Codec, Runtime, UI. **Do not** create `Data/Popes.lua` or any Pope list.

## Mission

Test-first. Isolated suite: Common + Sender.

§13.4: theatrical / state / snapshot messages render only from a registered Pope-character sender. The list is Phase 4 workspace data (#8). This lane is the **fail-closed predicate** so later Net can discard.

- **IsRegisteredPope(sender)** — always `false`. Do not read guild rank. Do not treat GM as Pope. Do not invent a config file or override UX.
- **Accept(sender, kind)** — `false` for `STATE`, `SNAPSHOT`, and any theater kind. Congregation `INPUT` is not theater: `Accept` may return `true` when `kind == "INPUT"` and sender is a non-empty string (server-provided identity later). Missing sender is `false`.

Do not store discarded messages for later paint. Do not `SendAddonMessage`. Do not invent Director Console.

## Do not git commit.
