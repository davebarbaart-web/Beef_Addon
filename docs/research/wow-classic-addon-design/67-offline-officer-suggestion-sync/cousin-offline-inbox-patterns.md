# Cousin patterns: pending work when officers / peers are offline

**Track:** 67 — offline officer suggestion-queue sync  
**Focus:** What Classic guild tools actually do with “something waiting for a human” when the human is offline. Consistency theory for *official* ladder state stays in [27](../27-desync-conflict-resolution/classic-addon-precedents.md).

## Pattern map

| Addon | What is “pending”? | Offline officer / peer behavior | Closest Beef layer |
|-------|--------------------|----------------------------------|--------------------|
| **RCLootCouncil** | Live loot session + votes; optional Award Later bag | Session is raid-night live; Synchronizer is **consent bulk** for settings/history — not auto inbox replay | Officer tab ≈ Voting Frame *IA*; Award Later ≈ “decide later” *local to ML* |
| **CEPGP / EPGP** | Loot response timer; EP/GP edits | Standings in **officer notes** (Blizzard-hosted) — late logins see notes; loot responses **expire** with timer | Official ladder ≈ notes (Beef uses peer SV instead); expire timers ≈ soft suggestion expiry |
| **Attune** | Survey snapshot of progress | Offline guildies stay blank until a later survey | Advisory standing / `SUGGESTION` fan-in |
| **GRM** | Bans, alts, dates, custom notes | Timestamped LWW sync among online GRM users; **personal log is not synced** | Durable metadata sync ≠ personal inbox |
| **Gargul** | SoftRes / award session | ML-centric; join/reload pull for session data | Officer mint + peer pull for *facts*, not petitions |

## 1. RCLootCouncil — live session, deferred award, consent history

**Pending is time-boxed to the raid.** Council voting frames appear when the ML starts a session; the product assumes the council is present for that loot moment ([RCLootCouncil site](https://rclootcouncil.com/); [Classic CurseForge](https://www.curseforge.com/wow/addons/rclootcouncil-classic/)).

**Award Later** stores an item for delayed award from the ML’s list — a *local deferral owned by the session authority*, not a guild-wide inbox that wakes every offline officer ([Voting Frame wiki — Award Later](https://rclootcouncil.com/wiki/Voting-Frame); `/rc award` in [commands](https://github.com/evil-morfar/RCLootCouncil2/wiki/Chat-Commands)).

**Synchronizer** (`/rc sync`) is explicit and consent-based: both sides open the sync UI; settings **overwrite** the receiver’s profile; loot history is **non-destructive union**; targets must be **online**; transfer is slow BULK (~4 kB/s shared CTL) and can take minutes ([Synchronizer wiki](https://github.com/evil-morfar/RCLootCouncil2/wiki/Synchronizer)).

| Steal | Avoid |
|-------|-------|
| History-style **union** for optional later suggestion catch-up | Auto-pushing a full pending queue on every officer login |
| Consent / rare maintenance for heavy blobs | Treating every threshold as a raid loot session that must reach all officers |
| Award Later mindset: deferral is OK; authority stays with online decision-maker | Overwriting peer SV wholesale |

**Beef read:** Offline officers missing a petition is culturally normal. RCL does not promise “every council member who was asleep still has the vote row tomorrow.” Drama resistance comes from **history after award**, not perfect pending fanout.

## 2. CEPGP — hosted canon + expiring loot responses

CEPGP stores standings in **Officer Notes**; viewers need note visibility, editors need edit rights ([CEPGP — WoWInterface](https://www.wowinterface.com/downloads/info25051-CEPGP.html); [CEPGP Lore fork](https://wowup.io/addons/475100)). Offline officers who can see notes get the *official* numbers when they log in — Blizzard replicates the note store.

Loot moderation still uses **response timers**: players cannot keep submitting after the distribution timer expires (CEPGP changelog notes on WoWInterface). That is expire-the-pending, not sync-the-pending.

| Steal | Avoid |
|-------|-------|
| Soft **expiry** on pending claims | Officer notes as Beef’s suggestion database |
| Hosted truth for *official* numbers (analogy → Beef §8.3 commits) | Assuming notes can hold rich petition evidence UI |

**Beef read:** Separate **canon** (notes / `RANK_COMMIT`) from **transient claims** (loot responses / `SUGGESTION`). Expire the latter; reconcile the former.

## 3. Attune — survey mesh accepts blanks

Attune surveys pull progress from **online** peers with the addon; offline guildies stay blank until a later survey ([Attune CurseForge](https://www.curseforge.com/wow/addons/attune); cousin teardown [13/attune](../13-cousin-addon-teardowns/attune.md)). Optional website export / Discord bot are out-of-band.

| Steal | Avoid |
|-------|-------|
| Advisory data may be incomplete without panic | Treating blank/offline as a broken ladder (Beef ranks need §8.3) |
| Episodic pull when a human cares | Continuous suggestion rebroadcast storms |

**Beef read:** Spec §16.5’s “officers online only” sketch is the Attune failure mode applied to petitions — acceptable for V1 because petitions are advisory and ranks heal separately.

## 4. GRM — sync durable facts; keep personal log local

GRM is explicitly decentralized: each user has an account-wide DB; sync accepts the **most recent timestamped** change so a year-offline client cannot overwrite the guild ([GRM CurseForge — design philosophy](https://www.curseforge.com/wow/addons/guild-roster-manager); [GitHub](https://github.com/TheGeneticsGuy/Guild-Roster-Manager)). Sync covers join/promo dates, alts, bans, etc. The **enhanced guild log is unique per account and is not synced** — “your log is your own.”

Classic also teaches traffic humility: shared addon-comms budget; bulk sync during group/combat contended with raid tools ([GRM file notes](https://www.curseforge.com/wow/addons/guild-roster-manager/files/2874277)).

| Steal | Avoid |
|-------|-------|
| Timestamp / freshness gates on any future suggestion sync | Syncing every officer’s personal “I saw this petition” log |
| Rank-gated sync for sensitive lists (ban analogy → Officer+ only) | Login-storm suggestion dumps while in instance |

**Beef read:** If V1.1 shares a pending queue, share **suggestion records**, not each officer’s attention history. Prefer officer-rank responders for catch-up (same instinct as officer-prefer `SYNC_STATE` in [14](../14-addon-messaging-beefnet/)).

## 5. Gargul — authority concentrates; peers pull facts

Gargul concentrates loot authority on the ML; SoftRes/session data often resyncs on join/reload ([Gargul](https://addons.wago.io/addons/gargul); [27 precedents](../27-desync-conflict-resolution/classic-addon-precedents.md)). Late joiners catch *session facts*, not a week of missed advisory whispers.

| Steal | Avoid |
|-------|-------|
| Pull-on-login for **authoritative** state | Pulling every advisory suggestion from every member on every login |

## 6. Synthesis → Beef petition queue

```
Live raid loot vote     → NOT Beef (no session ML for ranks)
Officer-note standings  → Beef RANK_COMMIT + SYNC_STATE (already)
Survey / advisory blank → Beef SUGGESTION offline gap (§16.5)
Award Later / timers    → Soft expire + on-duty officer
Consent history union   → V1.1 optional suggestion union
Personal officer log    → Stay local (GRM pattern)
```

**Cultural expectation for V1:** One Approving Officer online during guild night is enough ([51 facilitator roles](../51-guild-night-playbook/facilitator-roles.md)). The addon should not pretend every offline Officer+ must reconstruct the petition inbox before the next `/g` ceremony.
