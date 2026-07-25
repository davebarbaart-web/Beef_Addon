# Partial sync mode

**Last updated:** 2026-07-25  
**Track:** [55-graceful-degradation](README.md)  
**Boundary:** Transport budgets / reply storms → [14 sync-state](../14-addon-messaging-beefnet/sync-state-and-anti-spam.md). Merge predicates → [27](../27-desync-conflict-resolution/). This note is the **product/runtime degraded mode** when the mesh is incomplete.

---

## 1. Definition

**Partial sync mode** = Church of Beef is running with incomplete peer connectivity or incomplete ladder knowledge, but the player can still open `/beef`, see a cached ladder, earn local standing where allowed, and participate in guild social play.

It is the **normal** mode under Classic realities, not a rare failure:

- Peers offline or without the addon  
- Prefix not registered on this client  
- GUILD addon messages silently dropped despite `success == true` ([Classic SendAddonMessage problems](https://us.forums.blizzard.com/en/wow/t/classic-sendaddonmessage-problems/620054))  
- Cold login before roster / CTL settle ([SO: cold login](https://stackoverflow.com/questions/62723031/wow-classic-api-event-for-addon-messages))  
- Sync timeout with zero `SYNC_STATE` answers (spec §8.3: keep cache)

---

## 2. Capability matrix → behavior

| Condition | Ladder UI | Scoring | Officer actions | BeefNet send | BeefNet apply |
|-----------|-----------|---------|-----------------|--------------|---------------|
| Full mesh (prefix OK, roster ready, peers answering) | Live cache + merges | On | On | On | On |
| Alone online with addon | Show cache; “may be stale” optional | Local-first OK | Officer commits apply locally; broadcast best-effort | Try | Self / later peers |
| Peers without addon only | Show local/officer cache | On for self | Commits + **guild-chat spectacle** | HELLO/SYNC may silence | N/A for them |
| Prefix register failed | Show cache | Local only | Local only; warn once | Off | Off |
| Not in guild | Empty state (track 41) | Paused | N/A | Off | Off |
| Roster not ready | Show cache | Pause authority applies | Queue/drop commits | Delay SYNC | Queue/drop |
| Major version mismatch | Soft warn | — | — | Soft | Refuse incompatible |
| Wrong flavor project | Warn; local viewer | Off | Off | Off | Off |

---

## 3. Spec anchors already designed for this

| Spec | Behavior |
|------|----------|
| §8.2 | Players without addon invisible to BeefNet; must not soft-lock |
| §8.3 | Offline → login sync; no peer → keep cache; reconcile when someone appears |
| §10 | Guild-chat promotion line reaches non-addon members |
| §11 | Version mismatch soft-warn; roster missing → queue/drop; missing media fallback |

Partial sync mode is the **named umbrella** for those rows plus Classic silent-drop reality from track 14.

---

## 4. UX principles (not copy — track 41 owns words)

1. **Never block `/beef` waiting for sync.** Open frame with cache immediately.  
2. **Stale is OK if labeled lightly** (optional footer / officer-only debug). Avoid scary “ERROR DESYNC” for normal login.  
3. **Spectacle path independent of BeefNet.** Officer guild-chat line still fires when commit succeeds locally.  
4. **No soft-lock on suggestions** if officers are offline — queue locally; deliver when mesh returns (product detail may live with officer tools).  
5. **Attune pattern:** non-installers simply don’t appear in surveys; guild continues ([attune teardown](../13-cousin-addon-teardowns/attune.md)).

---

## 5. Heal path (when mode exits)

Conceptual ladder out of partial sync:

```
enter world → settle → register COB → roster ready
  → HELLO + SYNC_REQUEST
  → (optional) timeout remains in partial sync
  → on SYNC_STATE / RANK_COMMIT / peer HELLO → merge revisions → clear “alone” badge
  → on GUILD_ROSTER_UPDATE while queued commits exist → drain verify queue
```

Reliability stack remains: revisions + idempotent apply + later login (track 14 / 27). Partial sync does **not** invent a second authority.

---

## 6. What partial sync is not

- Not CRDT multi-master (track 27).  
- Not “trust any peer because we’re degraded.” Forged commits still die at roster check.  
- Not an excuse to blast large GUILD dumps — silent drops get worse under load.  
- Not feature flags / experimental toggles (track 48) — those are intentional product rollout, not mesh failure.
