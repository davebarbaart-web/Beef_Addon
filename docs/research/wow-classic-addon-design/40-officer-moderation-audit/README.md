# Track 40 — Officer moderation, abuse, and audit trails

**Track id:** `40-officer-moderation-audit`  
**Last updated:** 2026-07-25  
**Sole focus:** Product patterns for **approve/reject accountability** in Church of Beef’s Officer+ gate — audit logs, undo, disputed scores, griefing officers, transparency norms.  
**Out of scope:** Roster timing / Officer+ API edges ([16](../16-guild-roster-officer-edges/)); BeefNet merge/revision mechanics ([27](../27-desync-conflict-resolution/)); transport budgets ([14](../14-addon-messaging-beefnet/)); ladder gamification toxicity depth ([26](../26-ladders-points-gamification/)). No addon implementation in this folder.

## Product truth (from V1 design spec)

| Locked default | Value |
|----------------|-------|
| Advancement | Hybrid: suggest → Officer+ approve/reject |
| Authority | Real WoW guild Officer+ (roster rank-index); peers ignore forged `RANK_COMMIT` |
| Anti-cheat | Standings = advisory testimony; **officer approval is the real gate** |
| Approve | Official rank updates + BeefNet sync |
| Reject | Suggestion clears; **points remain** unless officer corrects |
| Manual power | Standing adjust/wipe; demote; Council appoint; Prophet bestow |
| Spectacle | Throttled guild-chat announce from approving officer (opt-out) |
| Sync truth | Per-player revision; `updatedBy` / `updatedAt` on official records |
| No server | Ladder = replicated officer commits in SavedVariables caches |

Sources: [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §4, §6.2–§6.3, §7.2–§7.3, §8.2–§8.3, §10–§11, §15–§16.

## Index

| Note | Covers |
|------|--------|
| [approve-reject-audit-logs.md](approve-reject-audit-logs.md) | What to log on approve/reject; schema; who can see it |
| [undo-and-compensating-commits.md](undo-and-compensating-commits.md) | Undo vs compensating `RANK_COMMIT`; RCL/CEPGP precedents |
| [disputed-scores.md](disputed-scores.md) | Inflated standing, reject-with-points-remain, dispute UX |
| [griefing-officers.md](griefing-officers.md) | Abuse vectors when Officer+ *is* the anti-cheat |
| [transparency-norms.md](transparency-norms.md) | Guild norms that keep judgment systems alive |
| [beef-product-patterns.md](beef-product-patterns.md) | V1 / later product recommendations mapped to Beef |
| [annotated-urls.md](annotated-urls.md) | Primary URLs with steal/adapt notes |

## Top insights for Beef (read this first)

1. **Officer approval without an audit trail is opaque loot-council.** Guild culture research converges: judgment systems die on *perceived* favoritism, not on a single wrong call. Spec already stamps `updatedBy` on commits — surface that to officers (and ideally a member-visible “who elevated you”) as the minimum transparency layer.

2. **Reject and approve are different audit events.** Approve creates official state; reject clears a suggestion but leaves self-reported points. Log both, with reason optional on approve and **recommended on reject / demote / standing wipe** so later officers can defend the call.

3. **Undo is a new commit, not a delete.** RCLootCouncil’s history delete has no undo; EPGP-adjacent undo is “reverse last GP, then re-award.” Beef’s revision model already supports compensating commits (demote / re-approve / standing correction). Prefer **compensating `RANK_COMMIT`** over mutating or erasing history.

4. **Disputed scores are expected failure mode, not a bug.** Spec §6.3 says inflated SV → officer laughs and rejects. Product need: officer sees breakdown + recent events; member sees “pending / rejected” without silent black-hole; optional officer note on reject reduces Discord archaeology.

5. **Griefing officers are a social risk the addon cannot fully prevent.** Any Officer+ can mint commits. Mitigations are friction (confirm on demote/Prophet/wipe), visibility (audit + guild announce), and process (narrow Officer+ threshold, GM override culture) — not cryptography. Four-eyes is optional later for high-drama actions only.

6. **Transparency norms beat feature density.** Publish rubric (what standing sources mean, when officers reject), keep a scannable action log, announce promotions publicly, explain demotions. Do not ship a second spreadsheet UI in V1.

## Boundary with sibling tracks

| This track (40) | Sibling |
|-----------------|---------|
| Accountability UX & social abuse of Officer+ power | [16](../16-guild-roster-officer-edges/) — *who counts as Officer+* |
| Audit / undo as product meaning | [27](../27-desync-conflict-resolution/) — *how revisions merge* |
| Favoritism / trust as ladder culture | [26](../26-ladders-points-gamification/) — points & spectacle toxicity |
| Queue UX cousins | [13](../13-cousin-addon-teardowns/), [01 loot](../01-ux-patterns/loot.md) |

## Provenance

Search/extract dumps under [`.raw/`](.raw/). Prefer design spec for product truth; RCL / CEPGP / guild-loot culture / four-eyes primers for patterns.
