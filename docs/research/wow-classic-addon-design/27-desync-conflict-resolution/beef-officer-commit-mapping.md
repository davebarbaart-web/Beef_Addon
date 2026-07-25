# Mapping conflict models → Beef officer-commit

**Track:** 27 — desync & conflict resolution  
**Purpose:** One page that ties theory and precedents to locked V1 behavior (spec §8.3 / plan ladder rules).

## 1. What Beef V1 *is* (short label)

**Privileged multi-writer, per-player LWW-Register with logical revision,** healed by pull-on-join snapshot anti-entropy over GUILD.

Not: text CRDT, OT, officer-notes DB, or open survey truth.

## 2. Spec/plan rules → model vocabulary

| Spec / plan rule | Model name | Notes |
|------------------|------------|-------|
| Only Officer+ may `RANK_COMMIT` | Writer ACL / external authority class | Roster rank index; server-trusted sender |
| Per-player `revision` bumps on commit | Per-key Lamport-like version | Single-primary *per successful commit path*, multi-officer *class* |
| Apply iff `rev > local` | Optimistic register merge | Stale/replay ignored |
| Equal rev → `updatedAt`, then `updatedBy` | Deterministic LWW tiebreak | Silent discard of loser |
| `SYNC_REQUEST` / `SYNC_STATE` | Anti-entropy / read repair | Pull-on-join |
| SV = cache | AP / local-first UI | No server of record |
| Standing self-reported; approve creates official | Two-layer trust | Do not CRDT advisory into official |
| Ignore incompatible major versions | Version fencing | Partition by protocol generation |

## 3. Message types by consistency role

| Type | Consistency role | Conflict policy |
|------|------------------|-----------------|
| `RANK_COMMIT` | Eager replicate official register write | Officer gate + revision apply |
| `SYNC_REQUEST` | Heal trigger | N/A (control) |
| `SYNC_STATE` | Snapshot anti-entropy | Same apply predicate per record |
| `SUGGESTION` | Advisory fan-in | Officer judgment; not ladder merge |
| `HELLO` | Capability / version probe | Soft-warn; no state clobber |
| `SCORE_EVENT` (optional) | Noise | Prefer local-first (spec) |

Transport mapping (priorities, sizes) → track 14. Here: **commits and sync states are the only writers of official rows.**

## 4. Desync scenarios → expected outcome

| Scenario | Expected V1 outcome |
|----------|---------------------|
| Member offline during promote | Login sync applies higher rev when any peer has it |
| Duplicate commit rebroadcast | No-op (`rev ≤ local`) |
| Member SV hand-edited rank upward | Display may lie locally until officer commit/sync; social anti-cheat |
| Two officers concurrent equal-rev commits | One wins via tiebreak; other lost |
| All holders of latest rev wipe WTF | Ladder regresses until officers re-commit |
| Non-officer forges commit | Rejected at validation |
| Officer commits, transport drops | Online peers miss it; later sync from officer (or anyone who got it) heals |
| No addon peers online after login | Stale cache persists (correct under AP) |

## 5. What to keep vs what not to invent

### Keep (locked)

1. Per-player revision as primary order.  
2. Officer roster gate on commit accept.  
3. Login pull sync with merge-by-revision.  
4. Replay-safe apply.  
5. Separate advisory vs official layers.

### Do not invent for V1

| Temptation | Why not |
|------------|---------|
| Full OR-Set / Automerge ladder | Demotion + payload cost |
| Vector clocks on every record | Detects races Beef already resolves by tiebreak |
| Officer-notes backing store | UX/privacy constraints; product chose peer cache |
| “Newest officer SV wins” full replace | Violates revision invariant |
| Blocking UI until sync | Breaks AP / social UX |
| CRDT counters for standing as official | Standing is advisory until commit |

### Consider only if playtest hurts

| Enhancement | Trigger |
|-------------|---------|
| Soft-warn on equal-rev divergent payload | Officers race in practice |
| Show `rev` / `updatedBy` on ladder tooltip | Support “why is my rank wrong?” |
| Manual `/beef sync` | Sparse online sets |
| Grow-only suggestion inbox merge | Officers miss suggestions while offline |
| Optional export string (Attune-like) | Disaster recovery / Discord backup |

## 6. Relationship to cousin patterns

```
Attune survey ──► Beef SUGGESTION / local standing (self-authority)
RCLC award     ──► Beef RANK_COMMIT (human mint)
RCLC history ∪ ──► possible future suggestion/audit union
RCLC settings overwrite ──► UI prefs only, never official ladder
CEPGP notes    ──► rejected alternate store (contrast)
Gargul pull    ──► SYNC_REQUEST on login/join
```

## 7. Testable Core predicates (research → implementation checklist)

These belong in Core tests (plan already sketches them); restated as consistency contracts:

1. `ApplyRemoteCommit` false when `rev < local.rev` or (`rev == local.rev` and tiebreak loses).  
2. `ApplyRemoteCommit` true when `rev > local.rev` even if wall clock is older (revision beats clock).  
3. Equal rev: later `updatedAt` wins; equal time: lexicographically greater `updatedBy` wins (plan).  
4. Import/sync path uses the same predicate as live commit path (one merge function).  
5. Non-officer path never calls successful apply (Net validation).

**Clock skew note:** Because revision is primary, skewed `updatedAt` only matters on equal-rev ties — the dangerous case is two officers minting the **same** next revision, not ordinary skew on different revisions.

## 8. One-sentence design north star

> Official Church ranks are officer-minted, revisioned registers replicated eventually to peer caches; everything else is testimony.

## Sources

- [`2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §6, §8.3, §9, §11  
- [`2026-07-25-church-of-beef-v1.md`](../../../superpowers/plans/2026-07-25-church-of-beef-v1.md) ladder / `ApplyRemoteCommit`  
- Sibling notes in this folder  
- Precedents: [RCLC Synchronizer](https://github.com/evil-morfar/RCLootCouncil2/wiki/Synchronizer), [Attune](https://www.curseforge.com/wow/addons/attune), [CEPGP](https://www.wowinterface.com/downloads/info25051-CEPGP.html)
