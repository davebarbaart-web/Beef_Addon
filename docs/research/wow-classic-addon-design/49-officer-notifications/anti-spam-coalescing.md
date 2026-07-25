# Anti-spam coalescing for pending-approval alerts

**Last updated:** 2026-07-25  
**Track:** [49-officer-notifications](README.md)

Classic guild nights produce **bursts**: several members cross thresholds after the same dungeon, or BeefNet delivers a cluster of `SUGGESTION` messages after a throttle lull. Alerting once per packet is how officers mute the addon forever.

---

## 1. Product event vs network event

| Layer | What happens | May alert? |
|-------|--------------|------------|
| Member client | Threshold → local suggestion + optional member toast (spec §10) | Member only — not this track |
| BeefNet | `SUGGESTION` arrives on Officer+ clients online (spec §8.1, §16.5) | **Yes**, if coalescing rules pass |
| Login / `SYNC_*` | Catch-up of ladder / (later) queue | **No** attention kit |
| Duplicate / replay | Same suggestion id seen again | **No** |
| Approve / reject | Queue shrinks | Soft UI update; no “success fanfare” here (member toast / guild announce own that) |

Spec open question §16.5: offline officers may miss live `SUGGESTION`. That is a **sync product** problem (track [14](../14-addon-messaging-beefnet/), [27](../27-desync-conflict-resolution/)), not solved by louder local alerts for online officers.

---

## 2. Coalescing rules (recommended)

Treat alerts as a function of **pending queue cardinality**, not of packet count.

### 2.1 Rising edge (primary)

```
prevCount = last known pending count for this character
newCount  = count after applying SUGGESTION

if newCount >= 1 and prevCount == 0:
    fire AttentionKit  -- RW caution + Flash + print + optional sound
elseif newCount > prevCount and prevCount >= 1:
    fire SoftUpdate    -- print / badge only
elseif newCount == prevCount:
    no-op
```

### 2.2 Cooldown latch (secondary)

Even on rising edge, suppress AttentionKit if `GetTime() - lastAttentionAt < COOLDOWN` (suggested **120–300 s** for social tools; shorter only if playtests show missed queues). SoftUpdate may still run.

Rationale: an officer clears one item, queue hits 0, two more arrive 10 seconds later — they already know the Church is busy; another Raid Warning ding is hostile.

### 2.3 Burst collapse

If N suggestions arrive in the same frame or within ~1 s (throttle catch-up):

1. Apply all to the local queue first.  
2. Compute one `newCount`.  
3. Fire **one** AttentionKit or SoftUpdate.

Never schedule N `C_Timer.After` flashes.

### 2.4 Silent paths (hard rules)

| Path | Rule |
|------|------|
| `PLAYER_LOGIN` / `PLAYER_ENTERING_WORLD` until roster + BeefNet settle | No AttentionKit |
| Applying synced historical suggestions | No AttentionKit |
| Non-officer client | No officer alerts (tab hidden — spec §11) |
| Global mute / “officer alerts off” pref | No sound; optional still allow print |
| `UnitAffectingCombat("player")` and pref “quiet in combat” | Defer AttentionKit to combat end **once**, or SoftUpdate only |

---

## 3. Acknowledge / clear semantics

Attention is for **unseen work**, not permanent anxiety.

| Action | Effect on latch |
|--------|-----------------|
| Officer opens Officer tab (or focuses queue) | Mark queue “seen”; further SoftUpdates OK; AttentionKit only on next 0→≥1 after seen-and-cleared-to-empty |
| Approve / reject last item | `prevCount` → 0; next arrival may AttentionKit again |
| Minimize / ignore | Cooldown still applies; do not escalate (no second flash every 30 s) |

Do **not** require a dedicated “Dismiss alert” control in V1 if opening the Officer tab is enough.

---

## 4. Multi-officer / multi-toon edges

| Edge | Behavior |
|------|----------|
| Two officers online | Each client runs its own latch — correct; both should know |
| Officer on alt without Beef | No alert (no addon) — social process / Discord, not Beef’s job |
| Same account, two Beef toons Officer+ | Per-character SV (spec §9) → separate latches; acceptable |
| Suggestion for the officer’s own main | Still alert — self-approval is a product/policy choice elsewhere ([40](../40-officer-moderation-audit/)) |

---

## 5. Why cousins feel quieter

RCLootCouncil’s automatic loot/voting frames appear when a **session** starts ([RCLootCouncil overview](https://rclootcouncil.com/); [Classic listing](https://www.curseforge.com/wow/addons/rclootcouncil-classic)) — attention is tied to an intentional raid loot moment, not to every whisper. Beef’s `SUGGESTION` stream is closer to “inbox,” so coalescing is mandatory or officers will treat Beef like a broken ready check.

Track [20](../20-sound-sfx-feedback/03-accessibility-and-spam.md) already lists login-sync silence and global mute as requirements; this track adds the **queue rising-edge** rule those notes imply for officer work.

---

## 6. Checklist

- [ ] AttentionKit only on 0→≥1 (plus cooldown)  
- [ ] SoftUpdate for additional pending while queue non-empty  
- [ ] Burst of packets → single kit  
- [ ] Sync / login / duplicate → silent  
- [ ] Combat quiet option  
- [ ] Opening Officer tab counts as acknowledge  
- [ ] No guild-chat line for *pending* (approve spectacle remains separate)  
