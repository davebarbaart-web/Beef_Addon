# Classic cousin patterns — empty, peer, sync UX

**Track:** 41 — empty states & degraded UX  
**Question:** What do successful Classic guild/social addons do when data, peers, or authority are missing?

---

## Pattern catalog

### 1. Personal value first, guild survey second (Attune)

| Behavior | Source |
|----------|--------|
| `/attune` shows *your* attunement tree immediately | [Attune CurseForge](https://www.curseforge.com/wow/addons/attune); [Attune Wago](https://addons.wago.io/addons/attune) |
| Guild survey is an explicit button; copy states guildies need the addon | Same listings: “For this to work, guildies will need the addon too” |
| Empty guild summary = no survey responses yet, not “addon broken” | Implied by survey-then-Guild-tab flow |

**Steal for Beef:** Ladder may be thin on day one; My Standing must still feel complete. Never require peers to “activate” the addon.

**Avoid:** Making the first screen a dead guild survey with no personal content.

---

### 2. Authority-local; raiders optional (Gargul)

| Behavior | Source |
|----------|--------|
| “Only the loot master needs Gargul for most features. Raiders benefit… but it's not required.” | [Gargul CurseForge](https://www.curseforge.com/wow/addons/gargul); [Gargul Wago](https://addons.wago.io/addons/gargul) |
| `/gl start` onboarding works solo — “No raid required” | Same |
| Softres / awards broadcast into normal chat for non-installers | Cousin tear-down culture (track 13); listing emphasizes chat-visible rolls |
| Version Check wiki page exists as officer tooling | [Gargul wiki](https://github.com/papa-smurf/Gargul/wiki) → Version Check |

**Steal for Beef:** Officer commit + guild-chat announce is the Gargul-shaped spine. Peers-without-addon is a *normal* state, marketed as such.

**Avoid:** Framing missing installs as a failure toast every login.

---

### 3. Explicit peer presence table (RCLootCouncil Version Checker)

| Behavior | Source |
|----------|--------|
| `/rc version` (aliases `ver`, `v`) queries guild or group | [RCL Version Checker wiki](https://github.com/evil-morfar/RCLootCouncil2/wiki/Version-Checker) |
| Rows start as **“Waiting for response”** | Same |
| After ~5s with no reply → treat as **not installed** | Same |
| Newest version green; older red; test yellow; other text grey | Same |
| Offline players omitted until re-query | Same |
| Separate Getting Started paths for council vs ML | [RCL wiki home](https://github.com/evil-morfar/RCLootCouncil2/wiki) |
| Settings sync via `/rc sync` (opt-in, guild-scoped) | [EPGP discuss note on RCL sync](https://groups.google.com/g/epgp-discuss/c/cI3TwSHD3ZM) |

**Steal for Beef:** Status progression vocabulary for scenario E (sync pending → cache / no peers). Optional V1.1 officer “Church clients online” list — not required for V1 if a one-line chip exists.

**Avoid:** Infinite “Waiting…” with no timeout copy; sorting thrash without a settled state.

---

### 4. Sync as ambient redundancy (Guild Roster Manager)

| Behavior | Source |
|----------|--------|
| Auto-sync among GRM users; more users = more redundancy | [GRM docs site](https://thegeneticsguy.github.io/Guild-Roster-Manager/); [GRM Wago](https://addons.wago.io/addons/guild-roster-manager) |
| Rank thresholds control who may push edits | Same |
| Some data intentionally **not** synced (personal log) | Same — “Log is unique to each account” |
| Sync failure called out in changelogs as edge case, not silent forever | [GRM CurseForge file notes](https://www.curseforge.com/wow/addons/guild-roster-manager/files/7793866) |

**Steal for Beef:** “Cache kept until a peer appears” is culturally normal. Don’t invent a fake server status. Separate *personal* standing log from *official* ladder sync in UX language.

**Avoid:** Implying every member must install GRM-style for the guild to function — Beef already rejects soft-lock.

---

### 5. Context-sensitive visibility (CEPGP)

| Behavior | Source |
|----------|--------|
| “Context sensitive… elements will be visible when they are relevant” | [CEPGP WoWInterface](https://www.wowinterface.com/downloads/info25051-CEPGP.html); [CEPGP Retail README](https://github.com/sadsfae/CEPGP-Retail) |
| Officer-note view/edit gates who can use standings tools | Same |
| `/cepgp version` checks who in the *raid* runs the addon | Same |
| Whisper `!info` path for members who can reach someone with note visibility | Same |

**Steal for Beef:** Hide Officer tab (already locked). Soft-deny officer slash with one clear line (track 22). Version check is a *raid/guild tool*, not a first-run modal.

**Contrast:** CEPGP leans on Blizzard officer notes as shared store — Beef does not. Empty/degraded UX must explain peer cache, not “open officer notes.”

---

## Cross-cousin steal / avoid map

| Pattern | Steal? | Beef mapping |
|---------|--------|--------------|
| Personal UI works offline/alone | **Yes** | My Standing + local Fresh Beef |
| Explicit “guildies need the addon” only on *guild aggregate* actions | **Yes** | Sync / ladder mesh — not instance credit |
| ML/officer-only install OK | **Yes** | Officers drive commits; chat covers others |
| Waiting → timeout → not installed | **Yes** | Sync pending → cache / no peers |
| Color-coded version matrix | Later | V1: one status chip; V1.1: `/beef peers` optional |
| Auto-sync ambient | **Yes** | Login `SYNC_REQUEST` (spec) |
| Context-sensitive officer chrome | **Yes** | Hide tab; empty queue copy |
| Require everyone install before fun | **No** | Spec forbids soft-lock |
| Blank panel / “No data” | **No** | NN/g + Eleken antipattern |

---

## Classic UI constraints that shape empty states

| Constraint | UX consequence |
|------------|----------------|
| Login order: `ADDON_LOADED` → `PLAYER_LOGIN` → `PLAYER_ENTERING_WORLD` ([Wowpedia loading process](https://wowpedia.fandom.com/wiki/AddOn_loading_process)) | Don’t judge unguilded / fire sync in the wrong phase; prefer quiet until roster/world ready |
| `IsInGuild()` boolean gate ([Wowpedia](https://wowpedia.fandom.com/wiki/API_IsInGuild)) | Hard empty for scenario B |
| GUILD addon messages only reach online addon users | Scenario D/E are permanent product shapes, not bugs |
| No custom CHANNEL on Classic | Can’t invent a side channel for “everyone” — guild chat remains the broadcast |

---

## UX theory that survives the Classic chrome

NN/g’s three jobs for empty containers ([NN/g](https://www.nngroup.com/articles/empty-state-interface-design/)):

1. **System status** — syncing, cached, unguilded, no peers  
2. **Learning cues** — what the ladder / standing panels *will* show  
3. **Task pathways** — join guild; play with guildmate; wait for officer; `/beef help`

Classic addons rarely ship SaaS-style illustrations; they use **banner text, chat prints, and status columns**. Prefer those surfaces over modal tours for V1.
