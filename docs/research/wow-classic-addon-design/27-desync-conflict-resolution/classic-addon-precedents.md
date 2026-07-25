# Classic addon precedents (consistency patterns)

**Track:** 27 — desync & conflict resolution  
**Focus:** How existing guild/raid tools treat authority, merge, and catch-up — not their UI or loot rules.

## 1. Pattern summary

| Addon | Authority | Merge / sync shape | Closest Beef layer |
|-------|-----------|--------------------|--------------------|
| **RCLootCouncil** | Raid leader / ML session; council votes | Live session state; optional consent Synchronizer | Officer commit + rare bulk sync |
| **Gargul** | Loot master–centric; SoftRes/TMB import | Join/reload `requestData`; ML owns awards | Officer mint; peers pull |
| **CEPGP / EPGP** | Officers who can edit notes | Blizzard officer-note store | Contrast (hosted shared string) |
| **Attune** | Each player for own progress | Survey pull; self-report merge | Advisory standing / suggestions |
| **CalamityEPGP** (note) | Addon DB, not officer notes | Explicit history / sync features | Peer cache alternative |

## 2. RCLootCouncil — session authority + consent sync

**Product role:** Loot council automation; Classic fork exists ([RCLootCouncil Classic — CurseForge](https://www.curseforge.com/wow/addons/rclootcouncil-classic/); [main project](https://www.curseforge.com/wow/addons/rclootcouncil)).

**Consistency-relevant behaviors:**

- **Session owner:** Group/raid leader enables the addon for the raid; ML options apply to the group ([RCLootCouncil description](https://www.curseforge.com/wow/addons/rclootcouncil)).
- **Version checker:** Social observability of who is in sync on *software*, not data ([wiki / commands](https://github.com/evil-morfar/RCLootCouncil2/wiki)).
- **Synchronizer** ([wiki — Synchronizer](https://github.com/evil-morfar/RCLootCouncil2/wiki/Synchronizer)):
  - Explicit, **consent-based**, both sides open sync UI.
  - **Settings:** receiving side **overwrites** current profile (whole-blob LWW / replace).
  - **Loot History:** **non-destructive union** — add missing entries; does not delete local; bidirectional sync needed for identity.
  - Slow BULK AceComm + CTL; minutes-long transfers acceptable for rare maintenance.
- **Reload/join healing:** Changelog notes extra code to help data sync after reload/join mid-enable ([3.20.1 file notes](https://www.curseforge.com/wow/addons/rclootcouncil/files/7782526)).

**Steal for Beef:**

- History-style **union merge** is a template for *suggestions* or audit logs, not for demotable ranks.
- Settings-style **replace** is fine for non-authoritative prefs, never for official ladder without revisions.
- Consent bulk sync is optional V2; V1 login `SYNC_REQUEST` is the automatic cousin.

**Avoid:** Overwriting a peer’s entire ladder SV because an officer clicked “sync.”

## 3. Gargul — ML-centric pull on join

**Product role:** Master-loot / SoftRes / GDKP toolkit ([Gargul — Wago](https://addons.wago.io/addons/gargul); [CurseForge](https://www.curseforge.com/wow/addons/gargul)).

**Consistency-relevant behaviors:**

- Most features require only the loot master; raiders optional — **authority concentrated**.
- SoftRes path: on group join / after reload delay, `requestData()` to resync session ([cousin teardown corpus / SoftRes listener patterns](../13-cousin-addon-teardowns/)).
- Soft reserves often **imported** from external softres.it — external snapshot becomes raid truth for the night.

**Steal for Beef:** Pull-on-join / pull-after-reload mirrors `SYNC_REQUEST`. Concentrated writer matches Officer+.

**Avoid:** Assuming “ML-only install” — Beef ladder must remain visible to members without making every member a writer.

## 4. CEPGP / EPGP — officer notes as the database

**Product role:** EPGP standings + loot moderation ([CEPGP — WoWInterface](https://www.wowinterface.com/downloads/info25051-CEPGP.html)).

**Consistency-relevant behaviors:**

- Standings stored in **Officer Notes**; viewers need note visibility; editors need note edit.
- Blizzard replicates note text to eligible clients — peer addon sync is secondary for the core numbers.
- Still grows addon traffic features (traffic sharing, force sync settings, version checks) for *addon* state around the notes.

**Steal for Beef:** Proof that guilds accept **officer-gated truth**. Version/query whispers for standings are a UX pattern.

**Avoid for V1:** Depending on officer-note payload limits and privacy fights ([forum concerns about officer-note visibility via addons](https://eu.forums.blizzard.com/en/wow/t/addon-accessing-and-sharing-officer-notes-for-any-guild-member/573173)). Beef’s richer ladder + scripture UI wants SV + BeefNet.

**Contrast addon:** [CalamityEPGP](https://www.wowinterface.com/downloads/info26606-CalamityEPGP.html) explicitly **does not** use officer notes — peer/history sync territory closer to Beef’s “no server” choice.

## 5. Attune — survey mesh, self-authority

**Product role:** Attunement progress + guild survey ([Attune — CurseForge](https://www.curseforge.com/wow/addons/attune); [forums launch thread](https://us.forums.blizzard.com/en/wow/t/attune-addon-track-your-attunement-progress/883832)).

**Consistency-relevant behaviors:**

- Survey: request over guild/whisper; peers reply with own TOON/DONE/OVER style payloads; merger stores into local `toons` DB ([Attune 3.3.5 README summary](https://github.com/r-o-b-o-t-o/Attune-3.3.5)).
- Anti-spoof: avoid accepting survey messages *about* other players from the wrong sender.
- Optional export to website — external consolidation, not CRDT.
- Progress is **self-reported** (quest/bag scan) — trust model matches Beef §6.3 advisory layer.

**Steal for Beef:** Survey = inspiration for suggestion fan-in and for “who has the addon” presence — not for official ranks.

**Avoid:** Treating the freshest survey reply as church doctrine.

## 6. What Classic culture does *not* do

Across these tools, authors almost never ship:

- Full text CRDTs / Automerge over GUILD
- Vector clocks in SavedVariables
- OT with a central sequencer

They ship: **authority roles**, **small messages**, **optional bulk sync**, **union or replace**, **version soft-warns**, and **human judgment**.

Beef’s revisioned officer commit is firmly inside that culture — slightly more formal than Attune surveys, slightly less “hosted” than CEPGP notes, closest in spirit to “ML awards a fact; late joiners catch up.”

## 7. Precedent → Beef cheat sheet

| If you are tempted to… | Precedent warns… | Beef does… |
|------------------------|------------------|------------|
| Merge ranks by union | RCLC history union keeps *additions*; ranks need replace | Per-key revision replace |
| Push whole SV from officer | RCLC settings overwrite | Merge by revision only |
| Trust peer point totals | Attune/self-report culture | Officer approve |
| Store canon in officer notes | CEPGP works but constrains UX | Peer cache + BeefNet |
| Skip catch-up | RCLC/Gargul keep adding join/reload heal | `SYNC_REQUEST` on login |

## Sources

- [RCLootCouncil Synchronizer wiki](https://github.com/evil-morfar/RCLootCouncil2/wiki/Synchronizer)
- [RCLootCouncil — CurseForge](https://www.curseforge.com/wow/addons/rclootcouncil)
- [RCLootCouncil Classic](https://www.curseforge.com/wow/addons/rclootcouncil-classic/)
- [Gargul — Wago](https://addons.wago.io/addons/gargul)
- [CEPGP — WoWInterface](https://www.wowinterface.com/downloads/info25051-CEPGP.html)
- [Attune — CurseForge](https://www.curseforge.com/wow/addons/attune)
- [Attune forums thread](https://us.forums.blizzard.com/en/wow/t/attune-addon-track-your-attunement-progress/883832)
- [CalamityEPGP — WoWInterface](https://www.wowinterface.com/downloads/info26606-CalamityEPGP.html)
