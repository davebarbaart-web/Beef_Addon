# Classic addon precedents → BeefNet message shapes

**Track:** 68  
**Focus:** Map **message roles** (not loot UI or EP math) onto Church of Beef’s catalog. Consistency theory stays in [27](../27-desync-conflict-resolution/classic-addon-precedents.md); transport in [14](../14-addon-messaging-beefnet/).

## Cheat sheet

| BeefNet type | Closest cousin behavior | Steal | Avoid |
|--------------|-------------------------|-------|-------|
| `HELLO` | RCLC version checker; CEPGP/GRM version pings | Soft observability of protocol skew | Treating missing HELLO as “player absent from co-play” |
| `SUGGESTION` | Attune guild survey fan-in (self-report) | Sender-bound claims; advisory merge | Survey-as-doctrine; auto-promote |
| `RANK_COMMIT` | RCLC / Gargul ML award fact | Privileged writer mints truth | Member-writable standings |
| `SYNC_REQUEST` | Gargul SoftRes `requestData` on join/reload; RCLC reload heal | Pull-on-join | Request on every roster event |
| `SYNC_STATE` | RCLC Synchronizer bulk (settings/history); GRM sync streams | Chunked BULK; single logical transfer | Consent-UI required for *every* login heal; full overwrite of ladder |
| `SCORE_EVENT` (off) | Threat-meter / noisy combat addon floods (cautionary) | — | On-wire combat drip |
| `SUGGESTION_SYNC_*` (V1.1) | RCLC history **union**; Attune offline gap | Grow-only inbox | Stuffing petitions into ladder sync |

---

## RCLootCouncil

**Docs:** [Synchronizer wiki](https://github.com/evil-morfar/RCLootCouncil2/wiki/Synchronizer) · [CurseForge](https://www.curseforge.com/wow/addons/rclootcouncil)

| Cousin concept | Beef mapping |
|----------------|--------------|
| Session / ML authority | Officer+ class for `RANK_COMMIT` |
| Version checker | `HELLO` + major fence |
| Consent Synchronizer (slow AceComm) | Escape hatch for disaster recovery — **not** V1 login path |
| Settings overwrite | UI prefs only — never official ranks |
| History non-destructive union | Model for V1.1 suggestion catch-up / audit, not demotable ranks |
| Reload/join extra heal | `SYNC_REQUEST` after settle |

**Wire lesson:** Huge blobs are **directed, paced, rare**. Beef login sync should stay revision-diff tiny whenever possible.

---

## Gargul

**Docs:** [CurseForge](https://www.curseforge.com/wow/addons/gargul) · SoftRes join/reload resync patterns (cousin teardowns track 13)

| Cousin concept | Beef mapping |
|----------------|--------------|
| ML-centric facts | Officer mint |
| `requestData` after join/reload delay | `SYNC_REQUEST` |
| External SoftRes import as night truth | Contrast — Beef truth is peer commits, not website import |

**Wire lesson:** Delay + pull beats push-all-presence.

---

## Attune

**Docs:** [CurseForge](https://www.curseforge.com/wow/addons/attune) · [forum launch](https://us.forums.blizzard.com/en/wow/t/attune-addon-track-your-attunement-progress/883832)

| Cousin concept | Beef mapping |
|----------------|--------------|
| Survey request / peer self-report | `SUGGESTION` / local standing |
| Anti-spoof (don’t accept others’ progress from wrong sender) | Suggestion `subject` must match sender (or explicit officer proxy — V1: match sender) |
| Offline peers blank in survey | V1 offline officer miss ([67](../67-offline-officer-suggestion-sync/)) |
| Export string | Optional disaster backup — not BeefNet type |

**Wire lesson:** Advisory mesh ≠ official register. Keep types separate.

---

## CEPGP / EPGP

**Docs:** [CEPGP WoWInterface](https://www.wowinterface.com/downloads/info25051-CEPGP.html)

| Cousin concept | Beef mapping |
|----------------|--------------|
| Officer notes as DB | **Rejected** store for V1 ladder |
| Version / force-sync around notes | Still shows guilds accept version soft-warns + officer gate |
| Traffic sharing features | Caution — easy to over-chat |

**Wire lesson:** Hosted Blizzard strings dodge 255-byte ladder dumps — Beef chose SV+BeefNet instead, so **chunking is mandatory**.

---

## Guild Roster Manager (GRM)

**Docs:** [CurseForge](https://www.curseforge.com/wow/addons/guild-roster-manager)

| Cousin concept | Beef mapping |
|----------------|--------------|
| Timestamped durable metadata sync | Official ladder = durable; personal log unsynced ≈ V1 suggestions |
| Classic disconnect reports when sync fights raid chatter | Defer BULK in combat ([47](../47-login-storms-guild-scale/beefnet-load-guidance.md)) |
| Deliberate “don’t sync personal log” | Validates [67](../67-offline-officer-suggestion-sync/) V1 choice |

**Wire lesson:** Not everything in SV belongs on the bus.

---

## Pattern Beef should stay inside

Classic guild/raid tools converge on:

1. **Authority classes** (ML / officer / self)  
2. **Small live messages**  
3. **Pull-on-join heal**  
4. **Optional rare bulk**  
5. **Version soft-warn**  
6. **Human judgment** for contested truth  

BeefNet’s catalog (`HELLO` / `SUGGESTION` / `RANK_COMMIT` / `SYNC_*`) is that culture with explicit revisioned commits — not a new distributed-systems genre on `GUILD`.
