# Tear-down: Gargul

**Product:** Gargul — master loot / SoftRes / TMB / GDKP distribution tool  
**Primary listing:** [CurseForge — Gargul](https://www.curseforge.com/wow/addons/gargul)  
**Also:** [Wago — Gargul](https://addons.wago.io/addons/gargul) · [GitHub — papa-smurf/Gargul](https://github.com/papa-smurf/Gargul) · [Wiki home](https://github.com/papa-smurf/Gargul/wiki)  
**Community launch post:** [r/classicwow — Gargul battle-tested loot addon](https://www.reddit.com/r/classicwow/comments/servxp/gargul_a_battletested_autoloot_and_loot)  
**Contrast essay:** [RCLootCouncil vs Gargul (Medium)](https://medium.com/@rengo_wow_world_of_warcraft/rclootcouncil-vs-gargul-which-wow-loot-addon-should-you-use-f99ac760e944)  
**Flavors:** Retail + Classic family including **Burning Crusade Classic** file line on CurseForge (e.g. `v7.7.35-bcc` noted in extract, Jul 2026)

---

## 1. What problem it solves

Make **officer/master-looter decisions fast and visible** during a raid: announce drops, run timed rolls, award winners, keep SoftRes/TMB context on tooltips, optionally auto-trade and packmule trash. Philosophy (author + reviews): **speed + ML-centric control**, not a full voting parliament ([Medium comparison](https://medium.com/@rengo_wow_world_of_warcraft/rclootcouncil-vs-gargul-which-wow-loot-addon-should-you-use-f99ac760e944); [Reddit](https://www.reddit.com/r/classicwow/comments/servxp/gargul_a_battletested_autoloot_and_loot)).

This is the closest cousin to Beef’s **Officer tab approve/reject** workflow.

---

## 2. Screen / IA map

| Surface | Entry | What it shows | Actor |
|---------|-------|---------------|-------|
| **Settings / hub** | `/gl`, `/gl settings`, Interface → AddOns → Gargul | Feature toggles, announce quality, hotkeys | Anyone; ML configures raid behavior |
| **Quick start** | `/gl start` | Walkthrough: hotkeys, GDKP, SoftRes, auto loot/roll — testable solo ([Wago/CF description](https://addons.wago.io/addons/gargul)) | New ML |
| **Masterloot / RollOff window** | Alt-click item; `/gl roll` / `/gl rolloff` | Item link, Start/Stop roll, note, timer, roll list, Award ([Rolling Items wiki](https://github.com/papa-smurf/Gargul/wiki/Rolling-Items)) | Master looter |
| **Roller widget (raiders)** | Auto on RollOff if Gargul installed | Small non-intrusive “what’s rolling” UI; right-click hide ([wiki](https://github.com/papa-smurf/Gargul/wiki/Rolling-Items)) | Raiders with addon |
| **Award window** | Alt+Shift-click; `/gl award` | Pick player → Award → **confirm dialogue** ([Awarding Items](https://github.com/papa-smurf/Gargul/wiki/Awarding-Items)) | ML |
| **SoftRes import** | `/gl sr` (etc.) | Paste softres.it export → Import → optional **Broadcast** ([Importing Soft-Reserves](https://github.com/papa-smurf/Gargul/wiki/Importing-Soft-Reserves)) | ML |
| **TMB / DFT / GDKP / PackMule / Plus Ones / Group Manager** | `/gl tmb`, `/gdkp`, `/gl pm`, … | Adjacent loot-economy tools ([feature table](https://www.curseforge.com/wow/addons/gargul)) | ML / raid lead |
| **Version check** | `/gl version` | Who has Gargul / who is outdated ([Version Check](https://github.com/papa-smurf/Gargul/wiki/Version-Check)) | Anyone in group |
| **Tooltip / corpse highlights** | Passive | SoftRes / TMB badges; animated borders on reserved drops ([gallery / Reddit](https://www.reddit.com/r/classicwow/comments/servxp/gargul_a_battletested_autoloot_and_loot)) | ML + installers |

### RollOff window anatomy (officer queue heart)

From the [Rolling Items wiki](https://github.com/papa-smurf/Gargul/wiki/Rolling-Items):

1. Item link + icon  
2. **Start** RollOff  
3. **Stop** (stop tracking new rolls)  
4. Note field (MS/OS, prio reminder)  
5. Timer duration  
6. Clear  
7. **Award** selected roller  
8–9. Roll list (duplicate rolls marked `[2]`, `[3]`, …)  
10. Optional “close window when roll starts” → floating reopen button with item icon  

**Beef mapping:** Officer pending suggestions ≈ RollOff list of candidates; Approve ≈ Award; Reject ≈ Stop/Clear without award; standing breakdown ≈ note + evidence column (keep short).

---

## 3. Officer queue & authority model

| Pattern | Gargul behavior | Beef analogue |
|---------|-----------------|---------------|
| **Single authority** | Master looter drives official awards | Officer+ drives `RANK_COMMIT` |
| **Soft dependency** | “Only the loot master needs Gargul for most features; raiders benefit but it’s not required” ([CF/Wago](https://addons.wago.io/addons/gargul)) | Non-addon members still play; ladder sync only among COB users |
| **Confirm friction** | Award requires confirm dialogue ([wiki](https://github.com/papa-smurf/Gargul/wiki/Awarding-Items)) | Demote / Prophet / wipe should use confirm (spec + AceConfig confirm culture) |
| **Pending list** | Rolls accumulate until Award | Suggestions pending until Approve/Reject |
| **Broadcast of policy** | SoftRes **Broadcast** only for masterlooters* ([wiki](https://github.com/papa-smurf/Gargul/wiki/Importing-Soft-Reserves)) | Only officers emit commits |
| **Contrast: RCLootCouncil** | Multi-voter council UI; usually wants raid-wide install ([Medium](https://medium.com/@rengo_wow_world_of_warcraft/rclootcouncil-vs-gargul-which-wow-loot-addon-should-you-use-f99ac760e944)) | Beef is **not** a voting council in V1 — closer to Gargul ML than RCLC |

\*Broadcast permission note is as documented on the SoftRes wiki page.

---

## 4. Sync model

Gargul is **not** a durable guild ledger like Beef’s ladder. Sync is session/raid oriented:

| Mechanism | Purpose |
|-----------|---------|
| **Plain `/roll` capture** | Works even if raiders lack Gargul — ML tracks public rolls ([wiki](https://github.com/papa-smurf/Gargul/wiki/Rolling-Items); [Medium](https://medium.com/@rengo_wow_world_of_warcraft/rclootcouncil-vs-gargul-which-wow-loot-addon-should-you-use-f99ac760e944)) |
| **Addon widgets** | Richer UX for installers only |
| **SoftRes Broadcast** | Share imported SR sheet to raid peers with Gargul |
| **Version check** | Capability discovery (`/gl version`) — cousin of BeefNet `HELLO` |
| **TMB import/export strings** | Clipboard bridge to external site of record |
| **Auto-trade on next trade window** | Local convenience after Award ([Reddit](https://www.reddit.com/r/classicwow/comments/servxp/gargul_a_battletested_autoloot_and_loot); [Medium](https://medium.com/@rengo_wow_world_of_warcraft/rclootcouncil-vs-gargul-which-wow-loot-addon-should-you-use-f99ac760e944)) |

**Lesson for BeefNet:** prefer **public-channel readable outcomes** (guild chat promote line) so the guild isn’t soft-locked on addon installers; use addon messages for **official state among users**. Gargul’s rolls-in-chat + optional widget is the same two-layer design.

---

## 5. Announce patterns

Documented in [Announcing Loot in Chat](https://github.com/papa-smurf/Gargul/wiki/Announcing-Loot-in-Chat):

| Event | Default channel behavior | Settings knobs |
|-------|--------------------------|----------------|
| ML loots fresh corpse | Raid/party chat: drops + SoftRes names | Disable announce; min quality; omit SoftRes names |
| Wishlist / TMB hits | Mentioned in chat when relevant | Tied to import data |
| Start RollOff on reserved item | **Raid warning** + raid message | Widget for Gargul users |
| Trades | Optional trade announces (gold/items/enchants) for transparency ([CF gallery](https://www.curseforge.com/wow/addons/gargul)) | Feature-level |

**Design virtues to steal:**

1. **Announce is ML-owned** — one client speaks; no N-way spam.  
2. **Spectacle uses Blizzard chat** so non-addon users see it.  
3. **Quality / content toggles** prevent spam (Beef: throttle + officer opt-out on promote lines).  
4. **Raid warning for “decision now”** vs quieter loot lists — Beef should keep promote lines in guild chat, not raid warning spam, but the *severity ladder* idea is useful (toast for self; guild chat for institution).

**Avoid:** corpse-loot chat walls; Beef is not a loot logger. One line per rank change is enough (spec §10, §13.11).

---

## 6. Onboarding pattern

`/gl start` teaches in-game without a raid ([Wago](https://addons.wago.io/addons/gargul)). Hotkeys are documented as first-class (Alt-click roll, Alt+Shift award).

**Steal for Beef:** first `/beef` should teach Ladder + My Standing in one glance; officer flows can have a short empty-state (“no pending suggestions”) rather than a 40-option installer.

---

## 7. Steal / avoid (Gargul-specific)

### Steal

1. **Officer-centric authority** with optional peer UX.  
2. **Pending list → select → confirm → commit**.  
3. **Duplicate / nonsense detection** in the queue (Gargul marks multi-rolls; Beef should flag implausible standing in the officer breakdown).  
4. **Version / HELLO style capability check**.  
5. **Broadcast of officer-authored policy** (SR sheet ≈ official ladder snapshot).  
6. **Movable windows + saved positions** for RollOff / widgets.  
7. **Plain-chat transparency** for outcomes outsiders can see.

### Avoid

1. **Dense loot/economy surfaces** (GDKP multi-auction, PackMule, SoftRes matrices) for the ladder.  
2. **Auto-loot / protected-action-adjacent automation** — out of Beef hard restrictions (spec §2).  
3. **Raid-warning spam culture** for social ranks.  
4. **Requiring raid-wide install** (that’s RCLC’s pain; Gargul explicitly rejects it — stay on Gargul’s side).  
5. **Session-only mental model** for official ranks — Beef still needs revisioned login sync; loot awards are ephemeral by nature, ranks are not.

---

## 8. Relevance score for Beef

| Spec need | Gargul coverage |
|-----------|-----------------|
| Officer approve queue | **Strong** |
| Confirm on irreversible actions | **Strong** |
| Announce spectacle | **Strong** (tune down volume) |
| Soft dependency | **Strong** |
| Durable guild ledger / offline sync | Weak (not its job) |
| Identity / titles directory | None |

**Bottom line:** Steal Gargul’s **officer queue choreography** and **announce ownership**. Pair it with Attune-like **ladder visibility** and Beef’s own **revisioned sync**.
