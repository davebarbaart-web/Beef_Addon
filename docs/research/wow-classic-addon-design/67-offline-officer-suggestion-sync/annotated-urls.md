# Annotated URLs — Track 67

Primary sources for offline / pending-approval norms. Prefer these when revisiting §16.5.

## Design truth (repo)

| URL / path | Why it matters |
|------------|----------------|
| [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §7.3, §8.1, §8.3, §9, §16.5 | Locked suggestion flow, BeefNet types, ladder sync, SV pending, open question this track closes |
| [Track 14 — beefnet-mapping](../14-addon-messaging-beefnet/beefnet-mapping.md) | `SUGGESTION`: “local queue if officers offline; optional later sync” |
| [Track 27 — README](../27-desync-conflict-resolution/README.md) | Grow-only suggestion queue later; do not CRDT the ladder |
| [Track 40 — beef-product-patterns](../40-officer-moderation-audit/beef-product-patterns.md) | Suggestion-queue login sync listed post-V1 |
| [Track 49 — officer notifications](../49-officer-notifications/README.md) | Sync replay / login catch-up stays silent |
| [Track 41 — scenario C](../41-empty-states-degraded-ux/scenario-matrix.md) | “No officers online — petitions wait” |
| [Track 56 — priority gap #6](../56-coverage-gap-audit/priority-next-research.md) | Asked for this one-pager + V1.1 flag + traffic |

## RCLootCouncil (live pending + consent sync)

| URL | Annotation |
|-----|------------|
| [https://rclootcouncil.com/](https://rclootcouncil.com/) | Product home — session/voting culture; council expected present for loot |
| [https://www.curseforge.com/wow/addons/rclootcouncil](https://www.curseforge.com/wow/addons/rclootcouncil) | Retail listing; in-game sync of settings/history called out; Classic fork linked |
| [https://www.curseforge.com/wow/addons/rclootcouncil-classic/](https://www.curseforge.com/wow/addons/rclootcouncil-classic/) | Classic port — same session model for Beef’s client family |
| [https://github.com/evil-morfar/RCLootCouncil2/wiki/Synchronizer](https://github.com/evil-morfar/RCLootCouncil2/wiki/Synchronizer) | **Steal shape for V1.1 only:** consent, online targets, settings overwrite vs history **union**, slow BULK CTL — not auto officer inbox |
| [https://rclootcouncil.com/wiki/Voting-Frame](https://rclootcouncil.com/wiki/Voting-Frame) | **Award Later** = defer award locally (ML list), not guild-wide pending sync |
| [https://github.com/evil-morfar/RCLootCouncil2/wiki/Chat-Commands](https://github.com/evil-morfar/RCLootCouncil2/wiki/Chat-Commands) | `/rc sync`, `/rc award` — sync is explicit maintenance |

## CEPGP / EPGP (hosted canon + timers)

| URL | Annotation |
|-----|------------|
| [https://www.wowinterface.com/downloads/info25051-CEPGP.html](https://www.wowinterface.com/downloads/info25051-CEPGP.html) | Officer notes as standings DB; loot GUI; response timer expiry notes in changelog |
| [https://wowup.io/addons/475100](https://wowup.io/addons/475100) | CEPGP Lore fork — traffic/sync features around notes; still not a petition inbox |

**Steal:** expire transient claims; reconcile official numbers via a durable store (for Beef: commits + §8.3).  
**Avoid:** stuffing Beef petitions into officer notes.

## Attune (advisory blanks)

| URL | Annotation |
|-----|------------|
| [https://www.curseforge.com/wow/addons/attune](https://www.curseforge.com/wow/addons/attune) | Survey only reaches online peers — same failure mode as §16.5 |
| [../13-cousin-addon-teardowns/attune.md](../13-cousin-addon-teardowns/attune.md) | Local research map: survey → SUGGESTION; offline blanks accepted |

## GRM (timestamped sync; local log)

| URL | Annotation |
|-----|------------|
| [https://www.curseforge.com/wow/addons/guild-roster-manager](https://www.curseforge.com/wow/addons/guild-roster-manager) | Design philosophy: decentralized DB, most-recent timestamp wins; year-offline must not clobber |
| [https://github.com/TheGeneticsGuy/Guild-Roster-Manager](https://github.com/TheGeneticsGuy/Guild-Roster-Manager) | Source mirror of sync philosophy |
| [https://www.curseforge.com/wow/addons/guild-roster-manager/files/2874277](https://www.curseforge.com/wow/addons/guild-roster-manager/files/2874277) | Classic throttle / group sync contention notes — why login dumps hurt |

**Steal:** do not sync personal officer attention logs; freshness-gate any V1.1 union.  
**Avoid:** treating GRM’s full metadata mesh as a template for every petition row.

## Gargul / authority pull

| URL | Annotation |
|-----|------------|
| [https://addons.wago.io/addons/gargul](https://addons.wago.io/addons/gargul) | ML-centric; late joiners pull session facts — pattern for *commits*, not petitions |

## Transport / scale context (already researched)

| URL | Annotation |
|-----|------------|
| [https://us.forums.blizzard.com/en/wow/t/classic-sendaddonmessage-problems/620054](https://us.forums.blizzard.com/en/wow/t/classic-sendaddonmessage-problems/620054) | Classic addon-message throttle culture — cited in track 47; bounds Option C/D |
| [Track 14 — sync-state-and-anti-spam](../14-addon-messaging-beefnet/sync-state-and-anti-spam.md) | Request/suppress pattern to reuse if V1.1 suggestion catch-up ships |
| [Track 47 — guild-scale-event-load](../47-login-storms-guild-scale/guild-scale-event-load.md) | `SUGGESTION` volume vs sync storm amplifiers |

## Provenance dumps

| Path | Contents |
|------|----------|
| [`.raw/search-offline-officer-queue.json`](.raw/search-offline-officer-queue.json) | Parallel search: RCL/CEPGP/GRM offline/sync |
| [`.raw/search-award-later-grm.json`](.raw/search-award-later-grm.json) | Award Later + GRM timestamp sync excerpts |
| [`.raw/extract-rcl-synchronizer.md`](.raw/extract-rcl-synchronizer.md) | Full Synchronizer wiki extract |
