# Track 67 — Offline officer suggestion-queue sync policy

**Track id:** `67-offline-officer-suggestion-sync`  
**Last updated:** 2026-07-25  
**Sole focus:** Product policy for **pending promotion suggestions when Officer+ clients are offline** — what Classic guild tools actually do, option tradeoffs, and a locked **V1 recommendation** for Church of Beef (spec §16.5).  
**Out of scope:** BeefNet transport / CTL / `SYNC_STATE` chunk budgets ([14](../14-addon-messaging-beefnet/)); revision merge & CRDT theory for *official* ranks ([27](../27-desync-conflict-resolution/)); approve/reject audit UI ([40](../40-officer-moderation-audit/)); how officers *notice* a non-empty queue ([49](../49-officer-notifications/)). No addon implementation in this folder.

## Product truth (from V1 design spec)

| Locked / open | Value |
|---------------|-------|
| Trigger | Threshold cross → **pending suggestion**, never auto-promote ([§7.3](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) |
| Wire type | `SUGGESTION` — member submits; officers filter ([§8.1](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) |
| Official heal | Login `SYNC_REQUEST` → `SYNC_STATE` for **revisioned ranks only** ([§8.3](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) |
| Persistence | Per-character SV includes **pending suggestions** ([§9](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) |
| Open §16.5 | V1 *may* keep suggestions only for officers who received the live message; extend sync if officers complain |

## Index

| Note | Covers |
|------|--------|
| [cousin-offline-inbox-patterns.md](cousin-offline-inbox-patterns.md) | How RCL / CEPGP / Attune / GRM / Gargul treat “pending while offline” |
| [policy-options-tradeoffs.md](policy-options-tradeoffs.md) | Options A–E with steal/avoid and traffic notes |
| [v1-recommendation.md](v1-recommendation.md) | **Recommended V1 policy** + V1.1 flag + traffic estimate |
| [annotated-urls.md](annotated-urls.md) | Primary URLs with steal/adapt notes |

## Boundary with sibling tracks

| This track (67) | Elsewhere |
|-----------------|-----------|
| *Whether* pending suggestions sync to offline officers | [14](../14-addon-messaging-beefnet/) — how `SYNC_*` / `SUGGESTION` travel |
| Grow-only inbox vs revision ladder | [27](../27-desync-conflict-resolution/) — already: “maybe grow-only suggestions later” |
| Reject audit shared memory | [40](../40-officer-moderation-audit/) — accountability after decide |
| Silent login catch-up vs toast | [49](../49-officer-notifications/) — “sync replay stays silent” |
| “No officers online” empty copy | [41](../41-empty-states-degraded-ux/) |
| On-duty Approving Officers | [51](../51-guild-night-playbook/) |

## Top insights for Beef (read this first)

1. **Classic tools do not ship a durable “officer inbox” for advisory claims.** Loot sessions are live and session-scoped ([RCLootCouncil](https://rclootcouncil.com/)); Attune surveys leave offline peers blank ([Attune](https://www.curseforge.com/wow/addons/attune)); GRM syncs *timestamped durable metadata* and deliberately keeps the personal log unsynced ([GRM philosophy](https://www.curseforge.com/wow/addons/guild-roster-manager)). Beef’s pending suggestion is closer to Attune’s advisory fan-in than to CEPGP’s officer-note canon.

2. **Official ladder sync is already solved; do not conflate it with the petition queue.** Spec §8.3 heals missed `RANK_COMMIT`s. §16.5 is only about *missed petitions*. An offline officer who later logs in still sees the ladder after peers answer `SYNC_STATE` — they just may not see petitions that fired while they were away.

3. **V1 should persist locally and fan out live — not extend `SYNC_STATE`.** Persist pending rows in member + receiving-officer SV; rate-limited `SUGGESTION` reaches online Officer+ only; soft-expire stale rows; document the gap; rely on on-duty officers ([51](../51-guild-night-playbook/)). Full shared queue is a **V1.1 flag**, not a launch blocker.

4. **If V1.1 sync ships, treat suggestions as grow-only / union by id — never as ladder revisions.** Track [27](../27-desync-conflict-resolution/) already draws this line: OR-Set semantics fit pending IDs; demotable ranks stay revision registers. Catch-up must stay **silent** ([49](../49-officer-notifications/)).

## Recommended V1 policy (one line)

**Local-persist + live fanout only; soft expire; no BeefNet suggestion store in V1; officer pull-on-login behind a V1.1 flag.**

Detail: [v1-recommendation.md](v1-recommendation.md).

## Provenance

Search/extract dumps under [`.raw/`](.raw/). Prefer design spec for product truth; cousin docs for ecosystem norms.
