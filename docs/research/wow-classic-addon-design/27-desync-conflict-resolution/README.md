# Track 27 — Offline desync & conflict resolution for peer guild sync

**Track id:** `27-desync-conflict-resolution`  
**Last updated:** 2026-07-25  
**Sole focus:** Consistency / conflict models for Church of Beef’s **officer-commit + revision sync** story (design spec §8.3, §6.2–§6.3, §9, §11).  
**Out of scope:** Transport budgets, CTL priorities, prefix/channel limits, reply-storm pacing — see [14-addon-messaging-beefnet](../14-addon-messaging-beefnet/). No addon implementation in this folder.

## Product truth (from V1 spec / plan)

| Locked default | Value |
|----------------|-------|
| Authority | Only Officer+ may create `RANK_COMMIT`; peers validate sender via guild roster rank index |
| Official state | Per-player record: rank, standing, **revision**, `updatedAt`, `updatedBy` |
| Merge rule | Higher revision wins; equal revision → later `updatedAt`, then `updatedBy` string |
| Offline heal | Login/reload `SYNC_REQUEST` → peers answer `SYNC_STATE`; merge higher revisions |
| Persistence | SavedVariables are a **cache** of official records, not a server |
| Anti-cheat stance | Self-reported standing is advisory; officer commit is the real gate |

Sources: [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §6.2–§6.3, §8.3, §9, §11; plan Task ladder / BeefNet (`ApplyRemoteCommit` rules).

## Index

| Note | Covers |
|------|--------|
| [conflict-models-crdt-lww-revision.md](conflict-models-crdt-lww-revision.md) | CRDTs vs LWW vs revision/commit logs; what Beef already is |
| [officer-authority-models.md](officer-authority-models.md) | Single-writer classes, multi-officer races, officer-notes vs peer cache |
| [partition-healing.md](partition-healing.md) | CAP/AP framing, anti-entropy, stale UI, heal paths |
| [classic-addon-precedents.md](classic-addon-precedents.md) | RCLootCouncil, CEPGP/EPGP, Attune, Gargul — consistency patterns only |
| [beef-officer-commit-mapping.md](beef-officer-commit-mapping.md) | Explicit map: theory → BeefNet behaviors → residual risks |
| [annotated-urls.md](annotated-urls.md) | Primary URLs with steal/adapt notes |

## Top insights for Beef (read this first)

1. **Beef V1 is not a general multi-master CRDT.** It is a **privileged-writer, per-key revision register**: only Officer+ may mint commits; each player’s official record is an LWW-style register ordered by revision (+ timestamp/name tiebreak). That is the right complexity for comedy-church ranks.

2. **“Last packet wins” without revisions is the bug class to avoid.** Wall-clock LWW alone fails under clock skew and replay; a bare “overwrite with whatever arrived last” also lets stale offline caches clobber fresher state. Spec §8.3’s revision gate is the load-bearing invariant.

3. **Concurrent officer commits on the same player are the only true conflict.** Two officers offline (or racing) can mint equal revisions with divergent ranks; the tiebreak silently discards one write. Social process + rare concurrent edits make this rare; if it hurts in playtests, prefer **officer coordination** or a **monotonic per-player revision owned by the commit path**, not a full CRDT.

4. **Partition healing is login anti-entropy, not consensus.** Offline members are partitioned from the guild message bus. V1 chooses availability (show cache) over linearizability, then heals via `SYNC_STATE` when any fresher peer appears — classic AP / eventual consistency for a social ladder.

5. **Classic precedents converge on authority classes, not CRDTs.** RCLootCouncil uses ML/session authority + optional consent sync (settings overwrite; history grow-union). CEPGP uses **Blizzard officer notes** as the shared store. Attune surveys are **self-reported** progress. Beef’s model is closest to “ML/officer mint facts; peers cache; sync fills gaps” — not Attune’s survey mesh.

6. **Do not CRDT the ladder; maybe grow-only the suggestion queue later.** Official ranks need human judgment and demotion. Grow-only / OR-Set semantics fit “pending suggestions seen by officers,” not “who is Beef Knight.” Keep V1 official state as revisioned snapshots.

## Boundary with track 14

| This track (27) | Track 14 |
|-----------------|----------|
| Who may write; merge predicates; desync scenarios | Prefix `COB`, GUILD, CTL, 255-byte envelopes |
| Conflict model choice vs CRDT/LWW/logs | `SYNC_STATE` chunk budgets, reply-storm jitter |
| Officer authority & partition healing | Login throttle / silent drops as *transport* failures |

Transport loss still matters for consistency (a dropped `RANK_COMMIT` is a partition), but healing *policy* lives here; pacing lives in 14.

## Provenance

Search dumps under [`.raw/`](.raw/). Prefer design spec + plan for product truth; wiki / WowAce / addon docs / distributed-systems primers for models and precedents.
