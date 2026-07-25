# Annotated URLs — desync & conflict resolution

**Track:** 27  
**How to use:** Prefer these when arguing merge/authority choices. Transport/API limits belong in track 14’s URL list.

## Distributed conflict models

| URL | Why it matters | Steal / adapt for Beef |
|-----|----------------|------------------------|
| [OT vs CRDTs — System Design Sandbox](https://www.systemdesignsandbox.com/learn/ot-vs-crdt) | Clear OT-vs-CRDT split; snapshots + op logs; LWW drops concurrent work | Skip OT (no server). Treat official rank as register, not text CRDT |
| [LWW vs CRDTs — DZone](https://dzone.com/articles/conflict-resolution-using-last-write-wins-vs-crdts) | Structure-aware merge vs timestamp replace | Don’t LWW standing counters; do revisioned rank replace |
| [LWW vs CRDTs — UMA Technology](https://umatechnology.org/conflict-resolution-using-last-write-wins-vs-crdts) | Offline-first examples; LWW-Register as CRDT formalization | Label Beef as privileged LWW-Register with logical rev |
| [How to Implement LWW — OneUptime](https://oneuptime.com/blog/post/2026-01-30-last-write-wins/view) | Fit/poor-fit table; LWW-Element-Set | Union merge for future suggestion sets only |
| [CRDT — Wikipedia](https://en.wikipedia.org/wiki/Conflict-free_replicated_data_type) | Taxonomy; notes Figma-style per-property LWW | Sanity-check jargon; avoid shipping heavy CRDT libs |
| [CRDTs vs OT — HackerNoon](https://hackernoon.com/crdts-vs-operational-transformation-a-practical-guide-to-real-time-collaboration) | Bandwidth: OT ops often smaller; CRDT for P2P/offline | GUILD bandwidth favors tiny revisioned snapshots |
| [Oracle NoSQL — CRDT counters](https://blogs.oracle.com/nosql/global-active-tables-and-conflict-free-replicated-data-type-crdt) | LWW default + CRDT when sums must converge | Standing sums ≠ official truth in Beef |

## Clocks, versions, logs

| URL | Why it matters | Steal / adapt for Beef |
|-----|----------------|------------------------|
| [Vector Clocks & Lamport Time — Algoroq](https://www.algoroq.io/learn/system-design-advanced/vector-clocks-and-lamport-time) | Wall clocks lie; vectors detect concurrency; single-writer per key avoids conflicts | Per-player revision ≈ single-writer version; vectors optional later |
| [Lamport Clock — Baeldung](https://www.baeldung.com/cs/lamport-clock) | Logical order primer | Revision as logical time |
| [Eventual Consistency Patterns — Codelit](https://codelit.io/blog/eventual-consistency-patterns) | LWW / merge / CRDT / anti-entropy / when to avoid EC | Login `SYNC_*` = anti-entropy; ranks OK for EC |

## Offline / CAP / partitions

| URL | Why it matters | Steal / adapt for Beef |
|-----|----------------|------------------------|
| [CAP Theorem — Distributed System Authority](https://distributedsystemauthority.com/cap-theorem/) | Partition ⇒ CP vs AP choice | Beef UI = AP; heal later |
| [CAP Theorem — GeeksforGeeks](https://www.geeksforgeeks.org/dbms/the-cap-theorem-in-dbms/) | Accessible CAP examples | Teach officers “stale until sync” |
| [Ditto — offline-first CRDT guide](https://www.ditto.com/blog/how-to-build-robust-offline-first-apps-a-technical-guide-to-conflict-resolution-with-crdts-and-ditto) | Against fake single-leader election offline | Authority = WoW roster, not addon election |
| [Offline-first sync patterns — DevelopersVoice](https://developersvoice.com/blog/mobile/offline-first-sync-patterns) | Local SSOT + delta sync | SV cache as SSOT for UI |
| [Android offline-first](https://developer.android.com/topic/architecture/data-layer/offline-first) | Local entity vs network model | Keep advisory vs official types separate |

## Classic / guild addon precedents

| URL | Why it matters | Steal / adapt for Beef |
|-----|----------------|------------------------|
| [RCLootCouncil Synchronizer wiki](https://github.com/evil-morfar/RCLootCouncil2/wiki/Synchronizer) | Consent sync; settings overwrite; history non-destructive union; slow CTL BULK | Union ≠ ranks; never full SV clobber for ladder |
| [RCLootCouncil — CurseForge](https://www.curseforge.com/wow/addons/rclootcouncil) | ML/session authority; version checker; `/rc sync` | Human mint of awards |
| [RCLootCouncil Classic](https://www.curseforge.com/wow/addons/rclootcouncil-classic/) | Classic-maintained fork | Precedent that Classic guilds run sync-heavy loot tools |
| [RCLootCouncil 3.20.1 notes](https://www.curseforge.com/wow/addons/rclootcouncil/files/7782526) | Join/reload sync hardening | Reinforce login heal importance |
| [Gargul — Wago](https://addons.wago.io/addons/gargul) | ML-centric; SoftRes import; optional raider install | Pull-on-join cousin to `SYNC_REQUEST` |
| [CEPGP — WoWInterface](https://www.wowinterface.com/downloads/info25051-CEPGP.html) | Officer notes as standings store; version checks; traffic sharing | Contrast store; keep Beef on BeefNet |
| [CEPGP — CurseForge](https://www.curseforge.com/wow/addons/cepgp) | Same authority story | Document as rejected alternate |
| [CalamityEPGP — WoWInterface](https://www.wowinterface.com/downloads/info26606-CalamityEPGP.html) | EPGP **without** officer notes; history/sync | Closer to peer-cache philosophy |
| [Attune — CurseForge](https://www.curseforge.com/wow/addons/attune) | Guild survey; self-reported progress | Template for advisory layer only |
| [Attune forums thread](https://us.forums.blizzard.com/en/wow/t/attune-addon-track-your-attunement-progress/883832) | Author description of survey | Peer pull semantics |
| [Officer notes privacy thread](https://eu.forums.blizzard.com/en/wow/t/addon-accessing-and-sharing-officer-notes-for-any-guild-member/573173) | Social risk of note-based designs | Reinforces not using notes for Beef |

## Transport reality (consistency-adjacent; detail in track 14)

| URL | Why it matters | Steal / adapt for Beef |
|-----|----------------|------------------------|
| [Classic SendAddonMessage problems](https://us.forums.blizzard.com/en/wow/t/classic-sendaddonmessage-problems/620054) | Silent drops enlarge partitions | Idempotent rev apply; chunked sync |
| [SendAddonMessage — Warcraft Wiki](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage) | Envelope / throttle facts | Design merge assuming loss |

## Product truth (repo)

| Path | Role |
|------|------|
| [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §6.2–§6.3, §8.3, §9, §11 | Locked officer-commit + revision sync |
| [`docs/superpowers/plans/2026-07-25-church-of-beef-v1.md`](../../../superpowers/plans/2026-07-25-church-of-beef-v1.md) | `ApplyRemoteCommit` tiebreak details |
| [Track 14 README](../14-addon-messaging-beefnet/README.md) | Transport budgets (do not duplicate here) |

## Provenance dumps

Raw `parallel-cli` JSON under [`.raw/`](.raw/):

- `search-crdt-lww-revision.json`
- `search-classic-addon-sync.json`
- `search-partition-healing.json`
- `search-rcl-gargul-sync-detail.json`
- `search-authority-revision-logs.json`
- `search-epgp-officer-sync.json`
- `search-synchronizer-attune.json`
