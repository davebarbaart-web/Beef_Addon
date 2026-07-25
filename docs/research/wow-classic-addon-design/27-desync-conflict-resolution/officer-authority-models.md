# Officer authority models

**Track:** 27 — desync & conflict resolution  
**Question:** Who is allowed to mint truth, and how does that interact with peer caches?

## 1. Authority is a consistency lever

Conflict probability collapses when the system **structurally** limits writers. Offline-first literature often warns against fake “single leader election” across partitions ([Ditto — misconceptions about forcing a single leader](https://www.ditto.com/blog/how-to-build-robust-offline-first-apps-a-technical-guide-to-conflict-resolution-with-crdts-and-ditto)), but Beef’s “leader” is not elected by the addon — it is **WoW guild rank**, enforced by server-supplied message senders plus roster lookup (spec §6.2).

That is an **external authority class**, stronger than app-level leader election: non-officers cannot forge `RANK_COMMIT` senders.

## 2. Model catalog (guild-addon relevant)

### A. Privileged multi-writer register (Beef V1)

- Writers: any Officer+ (roster rank index ≤ threshold).
- Object: per-player official record.
- Ordering: per-player `revision` (+ tiebreak).
- Readers: all addon users; SV cache.

**Properties:**

- Concurrent *member* edits to official rank: impossible (members only suggest).
- Concurrent *officer* edits: possible → tiebreak loss.
- Forged commits: rejected if roster check fails or roster unloaded (queue/drop).

### B. Session / Master Looter authority (RCLootCouncil, Gargul-style)

- One player (raid leader / ML) owns the active loot session; council votes but awards flow through the session owner ([RCLootCouncil site / wiki](https://rclootcouncil.com/); [Gargul — “only loot master needs addon for most features”](https://addons.wago.io/addons/gargul)).
- Consistency of *session* state is short-lived (raid night), not a permanent guild ladder.
- Settings sync is often **consent + overwrite** (see precedents note).

**Steal for Beef:** Treat promotions like “awards”: human-gated, not auto-merged from peer testimony.

### C. Blizzard-hosted shared store (CEPGP / classic EPGP)

- Standings live in **guild officer notes**; anyone who can view notes sees the same Blizzard-replicated string; edits require note-edit permission ([CEPGP — WoWInterface](https://www.wowinterface.com/downloads/info25051-CEPGP.html); [CurseForge CEPGP](https://www.curseforge.com/wow/addons/cepgp)).
- Conflict model is mostly **Blizzard’s guild note replication + last editor**, not peer CRDT.
- Tradeoff: limited payload size / privacy / note-visibility politics; not available for rich ladder UI state.

**Contrast for Beef:** Spec chooses peer BeefNet + SV cache (“no server”) instead of stuffing ranks into officer notes. That keeps lore/UI freedom and avoids note-permission politics — at the cost of needing §8.3 reconciliation.

### D. Self-reported survey mesh (Attune)

- Each player is authoritative for *their own* progress; surveys collect testimony ([Attune CurseForge](https://www.curseforge.com/wow/addons/attune); [Attune survey description — forums](https://us.forums.blizzard.com/en/wow/t/attune-addon-track-your-attunement-progress/883832)).
- Merge is “accept owner’s report about self,” not “officers mint guild truth.”
- Matches Beef’s **local standing / suggestions**, not official ranks.

### E. Open multi-master CRDT

- Any peer may write; merge preserves concurrent ops.
- Wrong for demotable ranks; right for some collaborative sets.

## 3. Beef’s two-layer trust (do not flatten)

| Layer | Who writes | Consistency need | Anti-cheat |
|-------|------------|------------------|------------|
| Advisory standing / events | Local client | Local only (or rare `SCORE_EVENT`) | None (spec §6.3) |
| Suggestions | Member → officers | Best-effort delivery | Officer judgment |
| Official rank / standing | Officer+ `RANK_COMMIT` | Guild-wide eventual | Roster gate + human approve |

**Implication:** Do not apply the same merge policy to suggestions and commits. Suggestions can be grow-only or “last suggestion wins per player”; commits must be revisioned registers.

## 4. Multi-officer race (the hard case)

Scenario:

1. Officer A offline (or partitioned) promotes Beefina → Knight, rev 5.
2. Officer B demotes Beefina → Cooked, also believing local rev was 4, mints rev 5 with different payload.
3. Peers eventually see both commits with `revision == 5`; tiebreak (`updatedAt`, then `updatedBy`) picks one; the other is **silently discarded**.

This is LWW-at-equal-revision. Vector clocks would *label* it a conflict; they would not resolve church doctrine.

**Mitigations (product, not CRDT):**

| Mitigation | Cost | V1 stance |
|------------|------|-----------|
| Social: one officer owns promotions per night | Process | Prefer |
| UI: show `updatedBy` / revision on ladder row | Small | Easy win |
| Soft warn if applying equal-rev different payload | Small | Recommended |
| Require GM-only for demote / Prophet | Policy | Optional |
| Global monotonic “commit id” from one officer machine | Fragile offline | Avoid |
| Conflict UI: “two officers disagree — pick” | UX | V2 if needed |

## 5. Roster gate races (authority false negatives/positives)

Spec §11: if roster not loaded, never apply unverified commits.

| Event | Risk | Handling |
|-------|------|----------|
| Commit arrives before `GUILD_ROSTER_UPDATE` | False drop | Queue short window, then drop |
| Officer demoted but SV still caches old roster | Stale accept | Refresh roster on commit; reject if now non-officer |
| Rank index remapped in guild reorg | Threshold drift | Configurable threshold (spec); document for officers |
| Cross-guild / wrong realm | N/A | Spec: independent ladders per guild/realm |

Roster timing detail belongs with track 16; here the consistency claim is: **authority checks are part of the merge predicate**, not a UI nicety.

## 6. “Officer copies are freshest” — precise reading

Spec §8.3: officer copies are *effectively* authoritative because only officers mint commits — not because an officer’s SV magically wins without revisions.

False readings to avoid:

- “If an officer is online, force-push their entire SV” → can wipe higher revisions held by a member who already synced from another officer.
- “Highest guild rank index always wins merge” → GM’s stale laptop could clobber a junior officer’s newer commit.

Correct merge: **revision predicate first**; officer identity only for *accepting* new commits and for equal-rev tiebreak (`updatedBy`).

## 7. Steal / avoid

| Steal | Avoid |
|-------|--------|
| External roster gate as writer ACL | Officer-notes as sole store (unless product pivots) |
| Attune-like self-authority for *advisory* data only | Treating survey mesh as official ladder |
| RCLC “human award” stance | Open multi-master rank edits |
| Surface `updatedBy` for social debug | Electing an addon “leader” across partitions |

## Sources

- Design spec §6.2–§6.3, §8.2–§8.3, §11
- [CEPGP — WoWInterface](https://www.wowinterface.com/downloads/info25051-CEPGP.html)
- [CEPGP — CurseForge](https://www.curseforge.com/wow/addons/cepgp)
- [Attune — CurseForge](https://www.curseforge.com/wow/addons/attune)
- [RCLootCouncil](https://rclootcouncil.com/)
- [Gargul — Wago](https://addons.wago.io/addons/gargul)
- [Ditto — offline-first conflict resolution](https://www.ditto.com/blog/how-to-build-robust-offline-first-apps-a-technical-guide-to-conflict-resolution-with-crdts-and-ditto)
