# Why this archive exists

These files are **historical**. They must not be followed. Product law is now `docs/design/Game_Design_Bible_v1.1.1.md`. On conflict the Bible wins — including over the Demo Build Audit (v1.1.1 confirmed Beef Butcher as a raid-team role; Audit §4 / §7.2 “Butcher dies” is superseded). Then Peer Review Adjudication, then the Audit.

## The turn

The demo was **"a well-engineered implementation of the wrong product"** (Audit §1). The engineering — layering, harness, API guards, throttled networking — is worth keeping. The product is not the Church of Beef of the Bible. It is a generic guild points-ladder with Beef-themed names: standing points, daily caps, threshold petitions, officer queues, and a seven-rung threshold ladder that treated Butcher as a grind capstone and invented Beef Prophet. There is no Beef Pope, no ceremony theater, no sanctioned duel, no Event Mode, no Director Console.

## Root cause

The agents did competent work against the spec they were given. The failure is upstream (Audit §2): workspace law predates Bible v1.1.1 and encodes a conventional guild-progression product. That law was then hardened — specs, plans, `docs/canon/ranks.md`, and domain rules named `ladder-authority.mdc` and `scoring-coplay.mdc` — into self-reinforcing governance a good agent obeys. `AGENTS.md` said the design spec / glossary / `Data/Ranks.lua` win. They did. The fix is not "code better"; it is **replace the workspace's law with bible-derived law**, then rework the code under it (Audit §6 step 1).

This folder is that first step: archive, do not delete, so git history shows why the turn happened.

## Audit violations the old law encoded (V1–V10)

- **V1** — Points economy as the product spine (standing, caps, buckets, grants). Banned.
- **V2** — Linear threshold ladder; ranks treated as grind rungs; invented Beef Prophet; the old law's grind-capstone Butcher (the name is canon as a raid-team role designation — Bible §5).
- **V3** — No Pope; ceremonial sovereignty given to officers.
- **V4** — Gora as typed self-report / points faucet, not a sanctioned unmodified duel.
- **V5** — Ceremony as attendance-credit timesheet, not theater.
- **V6** — Per-character identity; 14-day departed-member prune. History is never deleted.
- **V7** — Peer self-report authority instead of Pope-authoritative star topology.
- **V8** — Public demotion / excommunication spectacle. Canon has neither.
- **V9** — Always-on engagement surfaces (feeds, toasts, pips) against the Quiet Mode contract.
- **V10** — Stock-chrome-only visual law vs. hybrid ecclesiastical identity.

## What lives here

Retired specs, plans, `ranks.md`, the agent UI brief, and the four domain rules that would rebuild the points-ladder. Do not treat any of them as law. Do not restore them into `.cursor/rules` or `docs/superpowers/` as winners on conflict.
