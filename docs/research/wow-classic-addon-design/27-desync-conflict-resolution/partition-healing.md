# Partition healing for guild peer sync

**Track:** 27 — desync & conflict resolution  
**Question:** What does “offline” mean on BeefNet, and how does the ladder heal?

## 1. Partitions in this product

There is no WAN cluster. The “network” is the WoW **GUILD** addon-message bus among currently online clients with the addon.

| Partition type | Cause | Symptom |
|----------------|-------|---------|
| **Player offline** | Logged out / no addon | Misses live `RANK_COMMIT` |
| **Sparse online set** | Few Beef users online | `SYNC_REQUEST` unanswered; cache stays stale |
| **Transport loss** | Classic throttle / silent drop | Commit or sync chunk never arrives (see track 14) |
| **Roster lag** | Commit before roster ready | Authority check queues/drops (spec §11) |
| **Version island** | Major BeefNet mismatch | Soft-warn; incompatible commits ignored (spec §11) |

These are all forms of **message delay/loss between replicas** — the partition scenario in CAP discussions ([CAP Theorem — Distributed System Authority](https://distributedsystemauthority.com/cap-theorem/); [GeeksforGeeks — CAP](https://www.geeksforgeeks.org/dbms/the-cap-theorem-in-dbms/)).

## 2. CAP framing (practical, not pedantic)

During a partition, Beef V1 chooses:

| Property | Beef V1 choice |
|----------|----------------|
| **Availability** | UI keeps showing cached ladder / local standing |
| **Consistency** | Not linearizable; may be stale until heal |
| **Partition tolerance** | Continues operating while peers unreachable |

That is an **AP / eventual consistency** stance for official ladder display ([Eventual Consistency Patterns — Codelit](https://codelit.io/blog/eventual-consistency-patterns); [TechInterview — CAP tradeoffs](https://www.techinterview.org/post/3233463567/system-design-distributed-file-system-hdfs/) adjacent discussion of EC).

A CP stance would hide the ladder or block `/beef` until sync completes — hostile for a comedy guild tool and unnecessary when ranks are social spectacle, not bank balances.

## 3. Heal mechanisms (anti-entropy)

### 3.1 Live path (opportunistic)

`RANK_COMMIT` broadcast → online peers apply if officer-valid and revision newer. This is **eager replication** for the connected component only.

### 3.2 Login / reload path (explicit anti-entropy)

`SYNC_REQUEST` → jittered single `SYNC_STATE` responder → requester merges higher revisions (spec §8.3).

This matches the classic anti-entropy idea: periodically compare and repair replicas ([Codelit — anti-entropy / gossip](https://codelit.io/blog/eventual-consistency-patterns)), simplified to **pull-on-join** rather than continuous gossip (bandwidth culture; track 14).

### 3.3 Passive path (no peer online)

Keep SV cache; reconcile when someone appears. Spec is explicit: no peer ⇒ no magic refresh.

Optional V2 heal triggers (not required for V1 correctness if login sync exists):

- First guildmate with addon detected (`HELLO` exchange)
- Officer opens Officer tab (push `SYNC_REQUEST`)
- Manual `/beef sync` for support

## 4. Convergence guarantees (what V1 can and cannot promise)

**Promise (eventual, under assumptions):**

If (a) commits are revision-monotonic per player from valid officers, (b) at least one replica that saw the latest commit later overlaps online with a stale replica, (c) `SYNC_STATE` delivers that record intact, then the stale replica converges to the max-revision view.

**Non-promises:**

| Non-promise | Why |
|-------------|-----|
| Immediate global agreement | Offline members exist by design |
| Surviving equal-rev divergent commits without loss | Tiebreak discards one |
| Surviving total data loss of all holders of rev N | No server backup; social re-commit |
| Ordering of suggestions across officers | Not official state |

## 5. Healing vs transport (hand-off to track 14)

Consistency policy assumes messages that *arrive* are applied correctly. Transport realities that enlarge partitions:

- Silent / intermittent drops on Classic ([Blizzard forums — SendAddonMessage problems](https://us.forums.blizzard.com/en/wow/t/classic-sendaddonmessage-problems/620054))
- Login clamp / cold-send failures
- Oversized `SYNC_STATE` dumps

**Consistency-side mitigations** (policy, not CTL):

1. **Idempotent apply** — retries safe (rev ≤ local ignored).
2. **Small snapshot chunks** — partial apply of per-player records still progresses (record-level merge).
3. **Prefer commit+sync over chatty streams** — fewer lost intermediate states.
4. **Do not require full-ladder atomic sync** — merging record A rev 5 while B still rev 2 is OK; ladder is a set of per-key registers.

## 6. Stale-state UX (healing is social)

Offline-first guidance: local DB is the UI source of truth until sync ([Android offline-first](https://developer.android.com/topic/architecture/data-layer/offline-first); [Offline-first sync patterns](https://developersvoice.com/blog/mobile/offline-first-sync-patterns)).

For Beef:

| UX affordance | Purpose |
|---------------|---------|
| Show ladder from cache immediately | Availability |
| Optional “last synced” / stale hint | Expectation management |
| Guild-chat promotion line | Spectacle for non-addon / offline humans |
| Toast on applying higher-rev commit | Make heal visible |

Avoid blocking gameplay on sync completion.

## 7. Partition healing checklist for implementers

When validating Core/Net behavior (tests, not this folder’s job), scenarios that matter:

1. Offline during commit → login sync applies higher rev.
2. Duplicate / replayed commit → no change.
3. Two peers with different max revs online → after mutual sync/commit flood, both at component-wise max.
4. No peers online → cache unchanged; later peer heals.
5. Equal rev, different payload → deterministic tiebreak; ideally log/soft-warn.
6. Non-officer commit → never applied.
7. Major version mismatch → ignore incompatible payloads.

## 8. Steal / avoid

| Steal | Avoid |
|-------|--------|
| Pull-on-join anti-entropy | Continuous full-ladder gossip |
| Per-key merge (partial heal OK) | All-or-nothing guild snapshot transactions |
| Stale-visible UI | CP lockout waiting for sync |
| Idempotent retries | Assuming GUILD delivery is reliable |

## Sources

- Design spec §8.3, §9, §11
- [CAP Theorem — Distributed System Authority](https://distributedsystemauthority.com/cap-theorem/)
- [CAP Theorem — GeeksforGeeks](https://www.geeksforgeeks.org/dbms/the-cap-theorem-in-dbms/)
- [Eventual Consistency Patterns — Codelit](https://codelit.io/blog/eventual-consistency-patterns)
- [Offline-first sync patterns — DevelopersVoice](https://developersvoice.com/blog/mobile/offline-first-sync-patterns)
- [Android — offline-first](https://developer.android.com/topic/architecture/data-layer/offline-first)
- [Classic SendAddonMessage problems — Blizzard forums](https://us.forums.blizzard.com/en/wow/t/classic-sendaddonmessage-problems/620054)
