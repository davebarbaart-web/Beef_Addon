# Approve / reject audit logs

**Maps to:** Spec §6.2–§6.3, §7.3, §8.3 (`updatedBy` / revision), §10 Officer tab, §11 edges  
**Question:** What should Beef record when an officer approves or rejects, and who sees it?

---

## Spec baseline (already locked)

- Official state only exists after Officer+ **approve** → `RANK_COMMIT`.
- **Reject** clears the suggestion; standing points remain unless manually corrected.
- Official records carry **revision**, timestamp, and **officer name** (`updatedBy` in plan/sync language).
- Guild-chat announce on promotion/demotion is the public spectacle channel (officer opt-out).

The sync layer already needs actor identity for tiebreaks. An **audit log** is the product surface of that truth — not a second authority store.

---

## What cousins log

### RCLootCouncil — loot history as audit

[RCLootCouncil Loot History](https://rclootcouncil.com/wiki/Loot-History) stores, per award: recipient, time, item, response/reason, votes, instance/boss, note, and technical sort ids. Officers open `/rc history`, filter by date/name/class/response, export, and inspect “more info.”

**Steal:** One row per decision; filterable; reason/response column; export for Discord/officers who want a spreadsheet later.  
**Avoid for V1:** Dense raid-loot columns, mass-delete UX, import pipelines.

### CEPGP — traffic + officer-note visibility

[CEPGP](https://www.wowinterface.com/downloads/info25051-CEPGP.html) keeps standings in **Officer Notes** (viewable by anyone with note-view permission; editable only by note editors) and exposes a **traffic** window (`/cep traffic`) with search. Members can whisper `!info` / `!infoguild` to read standings from a peer who can see notes.

**Steal:** Append-only “traffic” mental model; member-readable standing queries; searchable modification log.  
**Avoid:** Binding Beef ladder to Blizzard officer notes (wrong semantics; rank titles are addon-layer).

### Stream Moderation Policy Audit Logs (product analogy)

[GetStream Moderation Policy Audit Logs](https://www.prlog.org/13138222-feature-announcement-moderation-policy-audit-logs.html) (Apr 2026) emphasize: actor, timestamp, action type, **before/after** of what changed, filters by action/actor/date. Built for “what changed and who changed it?”

**Steal for Beef schema:** `before` / `after` rank (and standing if corrected), not just “approved.”

---

## Recommended audit event types (Beef)

| Event | When | Must capture |
|-------|------|----------------|
| `SUGGESTION_SEEN` | Optional; officer opened queue row | Player, suggested rank, officer (local only OK) |
| `APPROVE` | Officer approves promotion/appointment | Target, from→to rank, standing snapshot, officer, time, revision after, optional note |
| `REJECT` | Officer rejects suggestion | Target, suggested rank, officer, time, **reason recommended**, points-remain flag |
| `STANDING_ADJUST` | Manual +/- or wipe | Target, before→after standing, officer, reason |
| `DEMOTE` | Excommunication / demote | Target, from→to rank, officer, reason, announce yes/no |
| `APPOINT` / `BESTOW` | Council seat / Prophet | Target, seat rules, officer, reason |
| `UNDO` / `CORRECT` | Compensating commit | Points at prior audit id or prior revision; new revision |

V1 minimum that matches existing commits: **`APPROVE`, `REJECT`, `DEMOTE`, `STANDING_ADJUST`** with actor + before/after. Appoint/bestow fold into approve-shaped commits with a `reasonCode` (threshold vs appointed vs bestowed).

---

## Visibility tiers

| Audience | What they need | V1 stance |
|----------|----------------|-----------|
| Approving officer | Full queue + own recent actions | Officer tab |
| Other officers | Shared history so two officers don’t contradict | Sync audit rows with ladder, or derive from commit stream |
| Members | “Who elevated me / when” + public announces | Ladder tooltip or My Standing “last official change”; guild chat |
| Public / no-addon | Promotion line in guild chat | Already specified |

**Do not** hide demotions from the audit while announcing promotions — asymmetric transparency fuels conspiracy theories.

---

## Storage implications (research only)

- Audit rows are **grow-mostly**; official ladder rows stay revisioned snapshots ([27](../27-desync-conflict-resolution/)).
- Prefer logging from the **commit path** (same place revision bumps) so reject-only events that never mint rank still need an explicit `AUDIT` or local officer log + optional sync later (ties to open question §16.5 suggestion-queue sharing).
- Cap / prune old rows in a later version (RCL mass-delete by days/name) — not a V1 blocker.

---

## Insight

Beef already chose “officer is anti-cheat.” The missing product piece is not more validation — it is a **defensible narrative**: who decided, what changed, and (for harsh actions) why.
