# Conflict models: CRDTs vs revision/commit logs vs LWW

**Track:** 27 — desync & conflict resolution  
**Question:** Which consistency toolkit fits peer guild ladder sync with no server?

## 1. What problem are we solving?

Peers hold local caches of “official” player records. Writers (officers) may be offline when others log in; messages drop; two officers may act while disconnected from each other. On reconnection, every client must **converge** without a central database.

Distributed systems literature frames this as conflict resolution under multi-writer or offline-first replication ([Conflict Resolution: LWW vs CRDTs — UMA Technology](https://umatechnology.org/conflict-resolution-using-last-write-wins-vs-crdts); [Eventual Consistency Patterns — Codelit](https://codelit.io/blog/eventual-consistency-patterns)).

## 2. Last-writer-wins (LWW)

**Idea:** Attach an ordering key (wall clock, hybrid clock, or sequence). Keep the max; discard the rest.

| Fit | Poor fit |
|-----|----------|
| Single-value fields where silent loss is OK (avatar URL, toggle) | Collaborative text, shopping carts, counters, financial ledgers |
| Cheap metadata | Clock skew can pick the “wrong” winner |

Sources: [How to Implement Last-Write-Wins — OneUptime](https://oneuptime.com/blog/post/2026-01-30-last-write-wins/view); [DZone — LWW vs CRDTs](https://dzone.com/articles/conflict-resolution-using-last-write-wins-vs-crdts).

**Beef note:** Pure wall-clock LWW on the whole ladder (or “last `CHAT_MSG_ADDON` applied”) is **unsafe**. Spec §8.3 explicitly rejects “last valid commit wins” without revisions. Beef’s ordered register is LWW-*shaped* but keyed by **per-player revision**, with timestamp/name only as tiebreak — closer to an LWW-Register with a logical sequence than to NTP-ordered blobs.

## 3. CRDTs (Conflict-free Replicated Data Types)

**Idea:** Data types whose merge is associative, commutative, and idempotent, so replicas converge without coordination ([Wikipedia — CRDT](https://en.wikipedia.org/wiki/Conflict-free_replicated_data_type); [OT vs CRDT — System Design Sandbox](https://www.systemdesignsandbox.com/learn/ot-vs-crdt)).

Common shapes:

| Type | Behavior | Ladder relevance |
|------|----------|------------------|
| **LWW-Register** | One value; max timestamp/version wins | Closest CRDT label for a single official rank row |
| **G-Counter / PN-Counter** | Concurrent increments preserved | Standing *could* be a counter — but Beef standing is advisory until officer commit |
| **OR-Set / G-Set** | Concurrent adds (and observed removes) merge by union | Fits suggestion IDs or loot-history style unions, not demotions |
| Text / rich CRDTs (Yjs, Automerge) | Merge concurrent edits | Overkill; huge metadata vs 255-byte addon messages |

**When CRDTs shine:** Offline multi-master edits where dropping work is unacceptable ([Ditto offline-first guide](https://www.ditto.com/blog/how-to-build-robust-offline-first-apps-a-technical-guide-to-conflict-resolution-with-crdts-and-ditto); [HackerNoon — CRDT vs OT](https://hackernoon.com/crdts-vs-operational-transformation-a-practical-guide-to-real-time-collaboration)).

**When to refuse them for Beef official state:**

- Ranks need **human authority** and **demotion** (not grow-only).
- Payload and Lua complexity budgets favor one revision integer, not tombstones/version vectors.
- Silent discard of a concurrent *officer* write is acceptable if rare; silent discard of concurrent *member points* is already product policy (suggestions are advisory).

**Nuance:** An LWW-Register *is* a CRDT. Calling Beef “not a CRDT” means “not a multi-value merge / OR-Set / text CRDT,” not “zero relation to CRDT literature.”

## 4. Revision / commit logs (and OT)

### 4.1 Per-key revision (optimistic versioning)

Single integer (or Lamport-like counter) per entity: accept update only if `remote.rev > local.rev`. Under a **single primary writer**, this is enough ([Algoroq — Vector Clocks and Lamport Time](https://www.algoroq.io/learn/system-design-advanced/vector-clocks-and-lamport-time) — single-writer-per-key structurally prevents concurrency; optimistic versioning is the compressed form).

Beef’s plan matches this: `Commit` bumps revision; `ApplyRemoteCommit` requires strictly greater revision (or equal with timestamp/`updatedBy` tiebreak).

### 4.2 Append-only commit / event log

Store operations (`PROMOTE Beefina → Knight by Pope @ t`), snapshot periodically, replay for catch-up ([OT vs CRDT — operation logs + snapshots](https://www.systemdesignsandbox.com/learn/ot-vs-crdt); [Codelit — reconciliation from event sequence](https://codelit.io/blog/eventual-consistency-patterns)).

| Pros | Cons for Classic addon |
|------|------------------------|
| Auditable; can rebuild state | Log size vs GUILD throttle / 255-byte frames |
| Natural idempotency with op ids | Needs compaction story |
| Can detect gaps | Peers still need authority rules for who may append |

Beef V1 ships **snapshot records with revision**, not a full guild-wide op log. That is a deliberate compression: `SYNC_STATE` carries current official rows, not every historical commit. Replay safety is “ignore rev ≤ local,” not “replay missing ops 1..N.”

### 4.3 Operational Transformation (OT)

Central sequencer transforms concurrent ops ([OT vs CRDT](https://www.systemdesignsandbox.com/learn/ot-vs-crdt)). **No fit** for Beef: there is no server sequencer; Classic guild messaging is not a collaboration bus for text.

## 5. Logical clocks (ordering toolkit)

| Tool | Detects concurrency? | Cost | Beef use |
|------|----------------------|------|----------|
| Wall clock | No (skew lies) | Free | Tiebreak only (`updatedAt`) |
| Lamport / per-key revision | No (false total order) | O(1) | **Primary order** (`revision`) |
| Vector / version vector | Yes | O(writers) | Unnecessary if officer races are rare |

Sources: [Algoroq — Vector Clocks and Lamport Time](https://www.algoroq.io/learn/system-design-advanced/vector-clocks-and-lamport-time); [Baeldung — Lamport Clock](https://www.baeldung.com/cs/lamport-clock).

**Insight:** Vector clocks *detect* concurrent officer commits; they do not pick a winner. Beef already picks a winner via tiebreak. Adding vectors would only help UI (“conflict: two officers disagreed”) — a V2 polish if races appear in the wild.

## 6. Decision matrix for Church of Beef

```
Is official rank multi-writer collaborative text?
  └─ No → skip OT / text CRDTs

Must concurrent independent facts all survive (adds)?
  └─ Official ranks: No (one truth) → register / revision
  └─ Suggestions / history-like sets: Maybe later → G-Set / union merge

Is there a privileged writer class?
  └─ Yes (Officer+) → per-key revision register + roster gate
     (structurally reduces conflicts vs open multi-master)

Is silent loss of one concurrent officer write acceptable?
  └─ V1: Yes, if rare → revision + timestamp/name tiebreak
  └─ If not: surface conflict UI or require single committing officer
```

## 7. Steal / avoid

| Steal | Avoid |
|-------|--------|
| Per-entity version + ignore stale (optimistic register) | Wall-clock LWW alone |
| Snapshot + anti-entropy sync for catch-up | Full CRDT libraries in V1 |
| Idempotent apply (rev ≤ local → no-op) | OT / central sequencer fantasies |
| Label Beef as “privileged LWW-Register” in design talks | Claiming “we’re CRDT-complete” |

## Sources

- [OT vs CRDTs — System Design Sandbox](https://www.systemdesignsandbox.com/learn/ot-vs-crdt)
- [Conflict Resolution: LWW vs CRDTs — DZone](https://dzone.com/articles/conflict-resolution-using-last-write-wins-vs-crdts)
- [Conflict Resolution: LWW vs CRDTs — UMA Technology](https://umatechnology.org/conflict-resolution-using-last-write-wins-vs-crdts)
- [How to Implement Last-Write-Wins — OneUptime](https://oneuptime.com/blog/post/2026-01-30-last-write-wins/view)
- [CRDT — Wikipedia](https://en.wikipedia.org/wiki/Conflict-free_replicated_data_type)
- [Eventual Consistency Patterns — Codelit](https://codelit.io/blog/eventual-consistency-patterns)
- [Vector Clocks and Lamport Time — Algoroq](https://www.algoroq.io/learn/system-design-advanced/vector-clocks-and-lamport-time)
- Design spec §8.3; plan `ApplyRemoteCommit` rules
