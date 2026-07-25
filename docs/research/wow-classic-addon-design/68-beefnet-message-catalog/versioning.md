# BeefNet protocol versioning

**Track:** 68  
**Maps to:** Spec §8.1 `HELLO` soft-warn; §8.2 discard incompatible majors; §11 “BeefNet version mismatch”; track 27 “version fencing.”  
**Does not redefine:** Addon TOC / Interface bumps ([62](../62-patch-day-interface-bump/)) — those are client load concerns; this note is **on-wire protocol generation**.

## Two version axes (keep distinct)

| Axis | Lives in | Changes when | Soft-fail behavior |
|------|----------|--------------|--------------------|
| **Addon release** | TOC, `Hello.addonBuild`, changelog | Features, UI, bugfixes | Peers may still speak same BeefNet major |
| **BeefNet protocol** | Every frame `maj:min` | Wire grammar / semantics | Major mismatch → fence |

Do not overload a single integer for both. Officers upgrading mid-guild-night need a clear story: *UI newer, protocol compatible* vs *protocol broke*.

---

## Recommended scheme

```
maj.min   # unsigned decimals on every BeefNet frame
```

| Component | Meaning | Compatibility rule |
|-----------|---------|--------------------|
| **major** | Generation fence | Different major ⇒ **incompatible**. Soft-warn; do not apply `RANK_COMMIT` / `SYNC_STATE` rows from foreign major. Optionally still parse `HELLO` to show the warn. |
| **minor** | Additive / clarifications | Higher minor from peer is OK if major matches. Older clients **ignore unknown trailing fields**; newer clients must tolerate missing optional trailing fields from older minors. |

**V1 launch values (research recommendation):** `maj=1`, `min=0`.

Bump **minor** when: optional field appended; new reserved type ignored by old clients; comment-level clarify.  
Bump **major** when: field order changes; type renamed/removed; revision merge semantics change; separator/charset change; `SYNC_STATE` chunk contract breaks.

---

## `HELLO` as the negotiation surface

V1 does **not** need a multi-round VERSION_NEGOTIATE.

| Step | Behavior |
|------|----------|
| Emit | After settle: `HELLO:1:0:addonBuild` |
| Receive | If `maj ≠ local.maj` → soft-warn once per session (or once per peer major), rate-limited |
| Commit path | Independent check: drop foreign-major commits even if HELLO was missed |
| Sync path | Same fence on `SYNC_STATE` rows |

**Avoid:** Refusing to show local SV ladder because a peer major differs. Availability > linearizability (track 27) — warn, keep cache, skip foreign applies.

---

## Forward / backward matrix

| Sender | Receiver | `HELLO` | `RANK_COMMIT` / `SYNC_STATE` | `SUGGESTION` |
|--------|----------|---------|------------------------------|--------------|
| 1.0 | 1.0 | OK | Apply per predicates | OK |
| 1.1 (+ optional trail) | 1.0 | OK | Apply known prefix fields; ignore trail | OK if core fields intact |
| 1.0 | 1.1 | OK | 1.1 fills defaults for missing optionals | OK |
| 1.x | 2.y | Soft-warn | **Drop** | Drop or ignore |
| 2.y | 1.x | Soft-warn | **Drop** | Drop or ignore |

Suggestions are advisory; still fence on major so a v2 petition schema cannot poison v1 officer queues with misaligned columns.

---

## What version does *not* solve

| Problem | Right tool |
|---------|------------|
| Missed commit while offline | `SYNC_REQUEST` / revision merge |
| Two officers race equal rev | Tiebreak + social process (track 27) |
| Login herd | Jitter / coalesce (track 47) |
| TOC out of date | Patch-day checklist (track 62) |
| Forged officer | Roster gate, not version |

---

## SV vs wire version

SavedVariables may carry a **schema version** for migrations ([21](../21-savedvariables-migration/)). That integer is related but not identical to BeefNet `maj`.

| Store | Version field | On mismatch |
|-------|---------------|-------------|
| SV schema | Migration chain | Migrate or reset local cache |
| BeefNet maj | Frame header | Fence remote applies |

A client could migrate SV to schema 5 while still speaking BeefNet 1.0 — expected during polish releases.

---

## Soft-warn UX (protocol-facing)

Spec §11: soft warning; do not apply incompatible commits.

Research guidance for implementers:

1. One clear message: protocol mismatch, update Church of Beef (not “sync broken”).  
2. Do not spam chat.  
3. Debug dump may include `beefNetMajor` ([65](../65-debug-dumps-privacy/)).  
4. Guild-chat promotion spectacle still works without matching majors — ceremony ≠ ladder mesh.

---

## When to mint BeefNet 2.0

Only when a breaking wire change is unavoidable (e.g. identity key migrates from name → GUID, or merge predicate changes). Prefer long-lived 1.x with additive minors. Classic guild tools rarely survive chatty dual-stack eras — if 2.0 ships, accept a transition night where mixed majors soft-warn and officers drive upgrades, rather than inventing dual encode paths for months.
