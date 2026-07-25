# Undo and compensating commits

**Maps to:** Spec §4.3 demotion, §7.2 manual adjust, §8.3 revisions/replay safety, §11  
**Question:** How should Beef reverse a bad approve, a mis-click demote, or a standing wipe?

---

## Precedent: undo as reverse-then-reapply

From the [RCLootCouncil ↔ EPGP discuss thread](https://groups.google.com/g/epgp-discuss/c/cI3TwSHD3ZM): when a player changes mind after loot, admins open `/rc history`, **undo the previous GP**, change response/winner, then **award GP again** via the right-click menu. Undo is an explicit reverse action, not silent mutation of the past without a trail.

From [RCLootCouncil Loot History wiki](https://rclootcouncil.com/wiki/Loot-History):

- Double-click delete has **no confirmation and no undo**.
- Right-click edits are often **local-only** (do not change others’ history) unless done via reaward during a session.
- Mass deletion warns that revert is usually impossible (maybe an SV `.bak`).

**Lesson:** Destructive history edits without compensating events are how guilds lose the plot. Prefer reverse actions that create new history.

---

## Beef’s natural undo model

Official state is a **per-player revisioned snapshot**. Spec rules:

- Higher revision wins; replay of ≤ local revision ignored.
- Officers may demote and manually correct standing.
- Demotion uses the same commit/sync path as promotion.

Therefore **undo = a new `RANK_COMMIT`** (or standing correction commit) that:

1. Sets rank/standing to the intended recovery state.
2. Bumps revision.
3. Records `updatedBy` = correcting officer.
4. Optionally links `correctsRevision` / `correctsAuditId` for UI (“reverts Beefina’s approve of …”).

This matches distributed “compensating transaction” thinking without needing a CRDT or editable log.

---

## Undo scenarios

| Mistake | Compensating action | Friction |
|---------|---------------------|----------|
| Approved wrong rank | New commit to correct rank (or demote one step) | Confirm dialog if rank delta ≥ 2 |
| Approved wrong player | Commit target A back; optionally approve B | Two commits; announce carefully |
| Rejected in error | Member re-suggests when still over threshold, or officer manual promote | No need to “undelete” suggestion if standing still qualifies |
| Standing wipe accident | Manual adjust restore + audit reason | Confirm on wipe |
| Grief demote | Another Officer+/GM re-promotes; audit shows both actors | Social process; announce |

**Reject undo** is usually “suggestion can fire again” or “officer manual promote” — do not invent a resurrected pending row unless queue sync (§16.5) makes that easy.

---

## Soft undo UX (product)

Steal RCL’s “history → act on row” pattern without RCL density:

1. Officer Audit / Recent Actions list (last N commits affecting guild).
2. Row actions: **Correct rank…**, **Restore standing…**, **Announce correction** (optional guild line).
3. Never offer “Delete from history” in V1. Hiding a row from UI ≠ erasing authority.

Emergency bypass analogy from [four-eyes / Flagsmith](https://www.flagsmith.com/blog/what-is-the-four-eyes-principle): allow fast correction, but **always log** and optionally notify other officers (toast / officer whisper / guild officer chat — product choice).

---

## Anti-patterns

| Anti-pattern | Why it fails in Beef |
|--------------|----------------------|
| Mutate SavedVariables history in place | Breaks peer caches; no `updatedBy` story |
| “Last packet wins” rewind without revision bump | Spec §8.3 forbids stale overwrite; undo must be a *newer* revision |
| Silent un-announce | Members saw the guild-chat spectacle; silent fix looks like cover-up — prefer a short correction line or officer-only acknowledgment |
| Unlimited undo stack UI | Comedy church does not need Git; last-correct-state is enough |

---

## Insight

V1 already has demote + standing adjust. Productize them as **first-class undo tools** with confirm + audit linkage, instead of a separate “undo engine.”
