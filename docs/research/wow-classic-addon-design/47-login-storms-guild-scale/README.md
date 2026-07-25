# Track 47 — Login storms & guild-scale event load

**Track id:** `47-login-storms-guild-scale`  
**Last updated:** 2026-07-25  
**Sole focus:** What happens when **many Beef clients wake at once** in a **40–500 member** guild — login waves, raid-night pile-ons, backoff/jitter, request coalescing, and BeefNet load envelopes.  
**Out of scope (do not duplicate):**

| Belongs in | Topics |
|------------|--------|
| [14-addon-messaging-beefnet](../14-addon-messaging-beefnet/) | Prefix `COB`, GUILD, CTL CPS/burst, 255-byte framing, message-type anti-spam matrix, silent drops |
| [27-desync-conflict-resolution](../27-desync-conflict-resolution/) | Revision/LWW merge, officer authority, partition healing *policy* |
| [16-guild-roster-officer-edges](../16-guild-roster-officer-edges/) | When roster APIs are safe; Officer+ rank-index checks |

No addon implementation in this folder.

## Product truth (scale-relevant)

| Locked default | Value |
|----------------|-------|
| Bus | BeefNet on `GUILD` / prefix `COB` — every online peer with the addon hears every broadcast |
| Heal path | Login/reload `SYNC_REQUEST` → peers may answer `SYNC_STATE` (spec §8.3) |
| Traffic stance | Prefer commits + login sync; avoid chatty `SCORE_EVENT` |
| Guild reality | Soft roster visibility historically ~500; design for **40–500** members, with **online concurrent addon users** as the real load variable |

Sources: design spec §8–§9, §11; tracks 14 / 27 for transport and consistency.

## Index

| Note | Covers |
|------|--------|
| [login-storm-model.md](login-storm-model.md) | Thundering-herd framing; who triggers what; N² reply math; guild-night scenarios |
| [backoff-jitter-coalescing.md](backoff-jitter-coalescing.md) | Full jitter, capped exponential backoff, request coalescing / singleflight, stale-while-revalidate |
| [guild-scale-event-load.md](guild-scale-event-load.md) | Online-N vs roster-N; HELLO storms; roster-churn traps; score/commit fanout |
| [beefnet-load-guidance.md](beefnet-load-guidance.md) | Concrete envelopes for ~40 / ~150 / ~500 guilds; do/don’t load rules |
| [annotated-urls.md](annotated-urls.md) | Primary URLs with steal/adapt notes |

## Top insights for Beef (read this first)

1. **A login storm is a thundering herd, not “more users.”** The danger is *correlation*: many clients react to the same trigger (raid invite time, instance reset night, `/reload` after patch) within a few seconds. Normal guild growth is gradual; a herd is simultaneous. Spec §8.3’s random responder delay alone is necessary but not sufficient if **requesters** also lockstep.

2. **Load scales with online addon peers × sync size, not roster size.** A 500-member guild with 25 Beef users online is a medium bus; a 80-member guild with 60 online on raid night is hotter. Design envelopes against **concurrent listeners**, then sanity-check cold-cache dumps against roster length.

3. **Without coalescing, work is roughly requesters × would-be responders × chunks.** Spec’s “one responder answers; others abort” cuts the responder axis. Still need: **jittered `SYNC_REQUEST` send**, **piggyback if a peer already requested**, **watermark diffs**, and **capped retry budgets** so silent drops don’t recreate the herd.

4. **Serve stale, revalidate in the background.** SavedVariables cache is the product UX during storms — show last ladder, sync when the bus is quiet. Do not block UI or spam retries until “perfect.”

5. **Cousin precedent: opt-in directed sync beats guild-wide dumps for bulk.** RCLootCouncil’s Synchronizer is consent + 1:1 + AceComm/CTL **low priority** (~4 kB/s shared). Guild Roster Manager documents Classic disconnects when sync overlaps raid chatter and throttles harder when grouped. Beef V1 should stay **diff-first on GUILD**, never GRM-scale roster dumps.

6. **Guild-scale event load is mostly self-inflicted.** Per-combat `SCORE_EVENT`, HELLO-every-login, and sync-on-every-`GUILD_ROSTER_UPDATE` turn a quiet ladder into a second threat-meter. Keep the wire for commits + rare sync; keep scoring local.

## Boundary map

```
Trigger (login / reload / manual refresh)
  → settle (14: CTL window, roster ready — 16)
  → jittered / coalesced SYNC_REQUEST          ← this track
  → one SYNC_STATE responder (14 anti-spam)
  → merge by revision (27)
  → retry with full-jitter backoff if silence/loss ← this track
```

## Provenance

Search/extract dumps under [`.raw/`](.raw/). Prefer Blizzard forums + addon author changelogs for Classic bus behavior; AWS Architecture / Builders’ Library for herd mathematics (adapted to a peer bus, not a server).
