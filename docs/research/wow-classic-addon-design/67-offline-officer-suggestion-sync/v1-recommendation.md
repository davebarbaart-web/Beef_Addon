# V1 recommendation — offline officer suggestion sync

**Track:** 67  
**Closes:** Spec open question §16.5 (product choice); gap audit item “Suggestion-queue offline sharing decision” ([56](../56-coverage-gap-audit/priority-next-research.md)).  
**Does not change:** §8.3 ladder reconciliation (already mandatory).

---

## Recommended V1 policy

**Local-persist + live fanout only. Soft-expire. No shared BeefNet suggestion store. Officer pull-on-login deferred to a V1.1 flag.**

### Rules (normative for V1)

1. **Persist locally.** On threshold cross (or allowed manual petition), the member client writes a pending suggestion into per-character `ChurchOfBeefDB` (spec §9).

2. **Fan out live.** Emit rate-limited `SUGGESTION` on `GUILD`. Only **online Officer+** clients that receive and validate the packet enqueue it into their local Officer-tab queue.

3. **Offline officers miss it.** Documented, expected. Ladder truth still arrives later via `SYNC_REQUEST` / `SYNC_STATE` for `RANK_COMMIT`s only — petitions are **not** part of that payload in V1.

4. **Soft expire locally** (member + officer queues):
   - cleared on Reject;
   - cleared when an applied `RANK_COMMIT` already grants ≥ suggested rank;
   - cleared after **14 days** without action (tunable);
   - cleared if subject leaves the guild.

5. **Re-petition, not spam.** If still eligible after expiry or obvious “nobody saw this,” member may re-emit at most **once per calendar day per suggested rank step** (cooldown). Never rebroadcast all pendings on every login/HELLO.

6. **UX honesty.** Member empty/status copy when no Officer+ online: petitions wait ([41 scenario C](../41-empty-states-degraded-ux/scenario-matrix.md)). Officer empty queue stays celebratory-quiet, not “sync broken.”

7. **Social coverage.** Guild-night **Approving Officers** on duty process the live queue ([51](../51-guild-night-playbook/facilitator-roles.md)). Optional human Discord note for edge nights — not the data plane.

8. **Alerts.** Live 0→≥1 queue edge may ping; **login / catch-up must not** ([49](../49-officer-notifications/)).

### Explicit non-goals for V1

| Non-goal | Why |
|----------|-----|
| Grow-only suggestion field inside `SYNC_STATE` | Protocol + tombstones + login cost; §16.5 already allows skip |
| Member push of pendings when any officer HELLO | Login-storm risk ([47](../47-login-storms-guild-scale/)) |
| Dual-officer ack on petitions | Offline officers fight four-eyes ([40](../40-officer-moderation-audit/)) |
| Account-wide officer inbox across alts | Per-character SV doctrine ([25](../25-multi-toon-realm-edges/)) |
| Officer-note encoding of petitions | Wrong store; privacy/size |

---

## V1.1 flag (ship when officers complain)

**Flag name (conceptual):** `syncPendingSuggestions` (default **off**).

**Behavior when on:**

- On Officer+ login settle, after ladder `SYNC_REQUEST`, request a **capped** pending-suggestion catch-up from peers (prefer other Officer+ responders; single-responder suppress — same shape as [14](../14-addon-messaging-beefnet/sync-state-and-anti-spam.md)).
- Merge = **union by `suggestionId`** (grow-only / OR-Set-ish), not ladder revisions ([27](../27-desync-conflict-resolution/README.md) insight #6).
- Apply **tombstones** for reject / already-promoted so dead rows do not resurrect.
- Cap: e.g. last **14 days** or **50** rows, whichever smaller.
- UI: silent merge; badge/count update only; no RaidNotice storm.

**Trigger to flip on:** Playtest evidence that Approving Officers routinely miss petitions *and* Discord/on-duty process is insufficient — not “we might need it someday.”

---

## Traffic cost estimate

### V1 (Option B) — recommended

| Item | Cost |
|------|------|
| `SUGGESTION` | Existing NORMAL, rate-limited per player ([47](../47-login-storms-guild-scale/guild-scale-event-load.md): tens/night, not hundreds) |
| Login sync | Unchanged — official records only |
| SV growth | Small; bounded by expiry |

**Net:** ~0 incremental sync frames vs today’s §8.3 design.

### V1.1 flag on (Option D)

| Item | Cost |
|------|------|
| Quiet officer login, ≤5 pending | ~0–1 BULK chunk |
| Busy catch-up, ~20 pending | ~2–4 BULK chunks @ CTL-friendly pacing |
| Worst case uncapped week | Avoid via 14d / 50-row cap |

Still far cheaper than naive `SCORE_EVENT` mesh or full SV overwrite. Keep off during combat/instance bulk windows (same courtesy as ladder sync).

---

## Why this over sync-in-V1

1. **Spec permission.** §16.5 literally sketches this default.
2. **Cousin culture.** RCL sessions require presence; Attune accepts blanks; GRM syncs durable metadata, not personal inbox logs ([cousin-offline-inbox-patterns.md](cousin-offline-inbox-patterns.md)).
3. **Authority split.** Petitions are testimony; commits are law. Heal the law first (already done). Inbox sync is polish.
4. **Comedy pacing.** One online Approving Officer is enough for a guild night; perfect multi-officer inbox is bank-grade process Beef does not need at launch ([40](../40-officer-moderation-audit/beef-product-patterns.md) already lists suggestion-queue login sync as post-V1).
5. **Risk asymmetry.** Shipping union sync early without tombstones resurrects drama; shipping local-only leaves a recoverable social gap.

---

## Spec / decisions-log hint

If adopted, update the design spec decisions log (or close §16.5) with:

> **§16.5 V1:** Pending suggestions persist locally and reach Officer+ clients online at emit time only. Soft-expire 14d / promote / reject. Shared suggestion catch-up deferred to optional V1.1 (`syncPendingSuggestions`). Ladder reconciliation unchanged (§8.3).

Do not fork this into silent assumptions elsewhere without that update ([library README](../README.md)).
