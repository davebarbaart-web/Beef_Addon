# Phase 1 Sweep J — BeefNet message cut

Read: `docs/reformation/phase-0/TEN_LAWS.md`, `GATE1_DESIGN_LEAD_DIRECTIVE.md` §3c.

## Exclusive files

- `addon/ChurchOfBeef/Net/BeefNet.lua`
- `tests/test_net_validate.lua`
- `tests/test_net_adversarial.lua`
- Report: `docs/reformation/phase-1/reports/P1-J-beefnet.md`

**Do not** edit TOC, bootstrap, `tests/run.lua`, Core, UI.

## Mission

Keep the **transport skeleton**: throttle, inbound rate limits, framing, prefix, GUILD channel, protocol version discard, **HELLO** (version/presence; survives into v2).

Delete **SUGGESTION** and everything standing / threshold / petition / promote-toast shaped. Retired types stay discarded, never acted on. Do **not** invent BeefNet v2 codecs, snapshots, or Pope broadcasts (Phase 3).

Rewrite net suites: no `dofile` of Ladder/Scoring. Assert HELLO + transport + adversarial discard. Isolated suites must pass.

## Do not git commit.
