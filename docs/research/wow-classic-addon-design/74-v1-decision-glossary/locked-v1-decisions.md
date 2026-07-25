# Locked V1 decisions — implementer glossary

**Track:** [74-v1-decision-glossary](README.md)  
**Last updated:** 2026-07-25  
**Audience:** Implementers of `addon/ChurchOfBeef/` and reviewers tempted to re-litigate settled V1 choices.  
**Rule:** Each row is **LOCKED for V1**. Open / draft items live in a short footer — do not treat them as locks.

**Primary truth:** [design spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) (§15 + body). Research tracks deepen or close gaps; they do not silently override the spec ([library README](../README.md)).

**Count: 81**

---

## How to read a row

| Column | Meaning |
|--------|---------|
| **#** | Stable glossary id for this track (not a protocol opcode) |
| **Decision** | Locked V1 choice (normative) |
| **Rationale** | One-line *why* |
| **Sources** | Spec § and/or research tracks |

Relative links assume this file’s folder.

---

## A. Purpose, platform, hard restrictions

| # | Decision | Rationale | Sources |
|---|----------|-----------|---------|
| 1 | V1 centerpiece is the **rank ladder + titles**, not a ceremonial dashboard. | Spectacle and identity land through standing and promotion moments first. | Spec §3.1, §15 · [00](../00-church-of-beef-implications.md) |
| 2 | Product is a **social / RP / stream theater** guild tool — never a raid DPS or combat-assistance addon. | Owns an underserved niche; combat stacks already saturate center screen. | Spec §1–2 · [00](../00-church-of-beef-implications.md) |
| 3 | Platform is **TBC Classic Anniversary** only for V1. | Guild nights and Interface packaging are one-client until a funded port. | Spec §2, §15 · [30](../30-anniversary-vs-era-deltas/beef-multi-toc-packaging.md) |
| 4 | **Classic+** is a future port, not V1 scope (design for isolation only). | Avoid dual-client QA and untested instance/messaging seams at launch. | Spec §12, §15 · [30](../30-anniversary-vs-era-deltas/beef-multi-toc-packaging.md) |
| 5 | Addon is **fully in-game**: Lua/XML only; no external process controlling gameplay. | Matches Classic addon norms and ToS-safe surface area. | Spec §2 · [00](../00-church-of-beef-implications.md) |
| 6 | **No bots**, injection, automated movement/targeting/casting, combat decision-making, or protected-action circumvention. | Secure-execution reality + “must not play the game for anyone.” | Spec §2 · [00](../00-church-of-beef-implications.md) |
| 7 | **No Retail-only / Dragonflight-era APIs** in V1. | Anniversary surface is the supported contract. | Spec §2 · plan Global Constraints |
| 8 | **No cross-realm / cross-faction church state** — Dreamscythe Alliance and Doomhowl Horde each run an independent ladder. | Separate guilds and realms; merge would invent a false shared church. | Spec §5, §15 · [59](../59-coplay-guildmate-detection/beef-scoring-map.md) |
| 9 | Repo is **knowledge-first** with light canon/engine split (`docs/` vs `addon/ChurchOfBeef/`). | Research and lore stay out of TOC load paths; engine stays installable. | Spec §5, §15 |

---

## B. Rank ladder & advancement

| # | Decision | Rationale | Sources |
|---|----------|-----------|---------|
| 10 | Official ladder (low→high): **Fresh Beef → Cooked Beef → Beef Knight → Beef Lord → Beef Butcher → Beef Council → Beef Prophet**. | Canon titles are the product surface and machine ids 1–7. | Spec §4, §15 |
| 11 | Advancement is **hybrid**: addon **suggests**; real WoW guild **Officer+ approves or rejects**. | Human judgment is the gate; auto-rank would be forgeable comedy. | Spec §4, §7.3, §15 · [00](../00-church-of-beef-implications.md) |
| 12 | **Never auto-promote** on threshold cross — only create a pending suggestion. | Separates advisory standing from official state. | Spec §7.3 · [67](../67-offline-officer-suggestion-sync/v1-recommendation.md) |
| 13 | Ranks **1–5 are point-driven**; **Beef Council** is seat-limited appointed; **Beef Prophet** is bestowed and unique. | Prestige requires scarcity; top seats are clergy, not grind. | Spec §4.1, §15 |
| 14 | **No automatic decay** in V1; points only go up until policy revisits. | Avoid hated decay metas; officers can still demote. | Spec §4.3, §15 |
| 15 | **Manual demotion / excommunication** is a first-class officer action (same commit/sync path as promote). | On-brand rivalry content; needs the same authority story as promote. | Spec §4.3, §15 · [27](../27-desync-conflict-resolution/beef-officer-commit-mapping.md) |
| 16 | Machine canon lives only in **`addon/ChurchOfBeef/Data/Ranks.lua`** (not `docs/canon/` numbers). | TOC can load only addon-folder files — one source, no drift. | Spec §5, §15 · [34](../34-lua-module-architecture/beef-v1-architecture.md) |
| 17 | **Pacing rule:** a new member’s first full dungeon night with guildmates should yield Fresh→Cooked suggestion eligibility. | Fast early hook; later ranks stretch (exact thresholds remain tunable). | Spec §4.2 · [59](../59-coplay-guildmate-detection/beef-scoring-map.md) |
| 18 | Suggestion fuel is **Gora + ceremonies + shared instance presence**. | Three thin sources feed the ladder without meter culture. | Spec §3.1, §15 |

---

## C. Authority, roster, anti-cheat

| # | Decision | Rationale | Sources |
|---|----------|-----------|---------|
| 19 | Approvers are **real WoW guild Officer+** via **roster rank-index** vs configurable threshold (default GM + top officer band). | Rank *names* are arbitrary per guild; index is the Classic-safe gate. | Spec §6.2, §15 · [16](../16-guild-roster-officer-edges/README.md) |
| 20 | Do **not** gate Officer+ on rank names, `CanGuildInvite()`, or officer-note edit rights. | Those permissions diverge from “Officer+” in real guilds. | [16](../16-guild-roster-officer-edges/README.md) · Spec §6.2 |
| 21 | Treat `C_GuildInfo.IsGuildOfficer()` as **optional shorthand**, not authority. | Undocumented criteria; not configurable like `OfficerRankIndexMax`. | [16](../16-guild-roster-officer-edges/README.md) |
| 22 | **Standings are self-reported advisory testimony; officer approval is the anti-cheat.** | SV is editable; comedy guild tool will not ship crypto score servers. | Spec §6.3, §15 · [27](../27-desync-conflict-resolution/README.md) · [00](../00-church-of-beef-implications.md) |
| 23 | Clients **must ignore** `RANK_COMMIT` from non-officers; forged approve fails validation. | Sender identity is server-trusted; roster check stops peer forgery. | Spec §6.2, §8.2, §11 · [27](../27-desync-conflict-resolution/beef-officer-commit-mapping.md) |
| 24 | If guild roster is **not loaded**, **queue or drop** commits — **never apply unverified**. | Login races return nil/0 ranks; unverified apply is a forged ladder. | Spec §6.2, §11 · [16](../16-guild-roster-officer-edges/README.md) |
| 25 | **Normalize realm-qualified names** before officer/guildmate lookups. | Roster often `Name-Realm`; message senders may not match raw strings. | [16](../16-guild-roster-officer-edges/README.md) · [59](../59-coplay-guildmate-detection/README.md) |
| 26 | Respect roster refresh throttle (~**10s**); do not `GuildRoster()` per BeefNet message. | Blind spam is ignored by the client and fights other guild UI. | [16](../16-guild-roster-officer-edges/api-edges.md) |
| 27 | Offline officers **do not break** the model: they cannot mint live commits; members heal via login sync. | Offline rows stay on roster; authority requires an online sender. | [16](../16-guild-roster-officer-edges/README.md) · Spec §8.3 |

---

## D. BeefNet protocol & conflict model

| # | Decision | Rationale | Sources |
|---|----------|-----------|---------|
| 28 | Protocol name **BeefNet**; addon prefix **`COB`**; distribution channel **`GUILD`**. | Classic-safe; custom CHANNEL addon messaging was banned. | Spec §8.2, §15 · [14](../14-addon-messaging-beefnet/README.md) |
| 29 | Serialization is **small colon-delimited** (or equally small packed) strings — keep payloads tiny. | 255-byte envelopes + Classic silent drops punish multi-KB dumps. | Spec §8.2 · [14](../14-addon-messaging-beefnet/beefnet-mapping.md) |
| 30 | V1 wire types: **`HELLO`**, **`SCORE_EVENT`**, **`SUGGESTION`**, **`RANK_COMMIT`**, **`SYNC_REQUEST`**, **`SYNC_STATE`**. | Enough for version ping, petitions, commits, and login heal. | Spec §8.1 · [14](../14-addon-messaging-beefnet/beefnet-mapping.md) |
| 31 | Pace outbound traffic with **ChatThrottleLib-style** throttling (embed or equivalent). | Per-prefix burst/regen limits; throttle is mandatory, not polish. | Spec §8.2 · [14](../14-addon-messaging-beefnet/README.md) · [42](../42-soft-deps-embeds/beef-v1-dependency-policy.md) |
| 32 | Prefer **commits + login sync**; keep **`SCORE_EVENT` local-first or rare** — never high-frequency standing spam. | Bandwidth budget and Classic drop culture favor sparse official writes. | Spec §8.2 · [14](../14-addon-messaging-beefnet/README.md) · [00](../00-church-of-beef-implications.md) |
| 33 | Official records carry **per-player revision**; apply iff **`rev > local`**; equal rev → later **`updatedAt`**, then **`updatedBy`**. | “Last packet wins” without revisions is the bug class to avoid. | Spec §8.3, §15 · [27](../27-desync-conflict-resolution/README.md) |
| 34 | On login/reload: **`SYNC_REQUEST`** → peers answer **`SYNC_STATE`**; merge higher revisions. | Live broadcasts miss offline members; anti-entropy is the product. | Spec §8.3 · [14](../14-addon-messaging-beefnet/sync-state-and-anti-spam.md) · [27](../27-desync-conflict-resolution/beef-officer-commit-mapping.md) |
| 35 | **Reply-storm suppression**: random delay + cancel pending reply when another peer answers the same request. | Guild-scale login storms otherwise thrash the prefix budget. | Spec §8.3 · [14](../14-addon-messaging-beefnet/sync-state-and-anti-spam.md) |
| 36 | **Replay-safe:** `rev ≤ local` commits/sync rows are ignored. | Old state must never overwrite new state. | Spec §8.3, §11 · [27](../27-desync-conflict-resolution/beef-officer-commit-mapping.md) |
| 37 | Major protocol mismatch → **soft warn**; drop incompatible commits (do not half-apply). | Prevents corrupted ladders across guild nights. | Spec §8.2, §11 · [14](../14-addon-messaging-beefnet/beefnet-mapping.md) |
| 38 | **Do not** design V1 around custom `CHANNEL`, `RAID`-scoped ladder sync, or whisper fanout as the primary plane. | Wrong scope or banned/hostile transport for guild-wide ranks. | [14](../14-addon-messaging-beefnet/beefnet-mapping.md) |
| 39 | Delay sync until after **enter-world settle** + roster readiness — not in cold `PLAYER_LOGIN` / `ADDON_LOADED`. | CTL historically clamps post-login; roster may be empty. | [14](../14-addon-messaging-beefnet/README.md) · [34](../34-lua-module-architecture/beef-v1-architecture.md) |
| 40 | Consistency model is **privileged multi-writer, per-player revision register** — **not** a ladder CRDT. | Demotion + comedy judgment need human mint, not OR-Set ranks. | [27](../27-desync-conflict-resolution/README.md) · [27](../27-desync-conflict-resolution/beef-officer-commit-mapping.md) |
| 41 | Players **without the addon** must not soft-lock guild play; they remain invisible to BeefNet. | Guild-chat spectacle covers non-addon members. | Spec §8.2 · [14](../14-addon-messaging-beefnet/beefnet-mapping.md) · [00](../00-church-of-beef-implications.md) |

---

## E. Persistence

| # | Decision | Rationale | Sources |
|---|----------|-----------|---------|
| 42 | Database name **`ChurchOfBeefDB`**, scope **`SavedVariablesPerCharacter`** (not account-wide). | Alts prove the flesh anew; matches progress-as-character culture. | Spec §9, §15 · [00](../00-church-of-beef-implications.md) |
| 43 | **There is no server** — SV caches officer-committed records reconciled via BeefNet. | Classic cannot host trusted score servers for this product. | Spec §9 · [27](../27-desync-conflict-resolution/README.md) |
| 44 | **Alts start Fresh Beef** with separate standing in V1 (account merge is open, not shipped). | On-brand doctrine; avoids silent account-ladder assumptions. | Spec §9, §16.1 · [00](../00-church-of-beef-implications.md) |

---

## F. Scoring, instance, co-play, CLEU

| # | Decision | Rationale | Sources |
|---|----------|-----------|---------|
| 45 | Shared-instance credit requires a **qualifying instance** (`party` / `raid` / `pvp`) — **no city / open-world** co-play loops. | Anti-farm; matches “instance types only.” | Spec §7.2 · [15](../15-instance-completion-events/README.md) · [59](../59-coplay-guildmate-detection/beef-scoring-map.md) |
| 46 | Detect instance enter via **`PLAYER_ENTERING_WORLD` + `IsInInstance` / `GetInstanceInfo`**, not `ZONE_CHANGED*`. | PEW is reliable on load screens; zone-changed is historically flaky. | [15](../15-instance-completion-events/README.md) |
| 47 | Anti-AFK for drip buckets: player must **enter combat** in the bucket (`PLAYER_REGEN_DISABLED` / sticky), not mere presence. | Standing at the entrance with a guildmate earns nothing. | Spec §7.2 · [15](../15-instance-completion-events/README.md) |
| 48 | Co-play credit requires the **compound predicate**: qualifying instance (`party`/`raid`/`pvp`) **+** ≥1 other **connected guildmate** in the active group; peer **need not** run the addon. | Spec §7.1; detection is Unit/roster, never BeefNet `HELLO`. | Spec §7.1, §15 · [59](../59-coplay-guildmate-detection/README.md) · [59](../59-coplay-guildmate-detection/beef-scoring-map.md) |
| 49 | Ship predicate **`HasConnectedGuildmateInActiveGroup`** with correct **HOME vs INSTANCE** category selection. | Wrong category causes BG/home false negatives; proximity is not required. | [59](../59-coplay-guildmate-detection/beef-scoring-map.md) · [59](../59-coplay-guildmate-detection/detection-methods.md) |
| 50 | Prefer **`UnitIsInMyGuild` + normalized roster fallback**; do **not** rely on `GetGuildInfo(unit)` for co-play. | `GetGuildInfo` is proximity-fragile; false friend for credit. | [59](../59-coplay-guildmate-detection/README.md) |
| 51 | **Reject** proximity APIs (`UnitInRange` / `CheckInteractDistance`) and **`UnitIsAFK` hard gates** as pay walls. | False negatives / weak flags; combat sticky already covers AFK intent. | [59](../59-coplay-guildmate-detection/beef-scoring-map.md) |
| 52 | **Reject** credit for non-guild BG teammates or cross-guild strangers. | Ladder is guild-local; BG raids are full of other realms. | Spec §5 · [59](../59-coplay-guildmate-detection/beef-scoring-map.md) |
| 53 | **Ship** combat-gated instance drip + **BG end** (`GetBattlefieldWinner` non-nil) as completion bonus (capped). | BG end is the reliable Classic “finished content” signal. | [15](../15-instance-completion-events/README.md) · Spec §7.1–7.2 |
| 54 | Treat full 5-man/raid “clear” auto-credit as **optional/deferred**; no Classic first-class dungeon-complete event. | Completion bonus must degrade to drip-only if flaky (§16.4). | [15](../15-instance-completion-events/README.md) · Spec §16.4 · [00](../00-church-of-beef-implications.md) |
| 55 | **`ENCOUNTER_END` / `BOSS_KILL`** may feed progress/officer log only — **not** automatic full-clear standing without allowlist + prototype. | Boss progress ≠ run complete; locale/payload caveats. | [15](../15-instance-completion-events/README.md) |
| 56 | **Gora losses pay** (small participation). | If losses pay nothing, members dodge challenges and spectacle dies. | Spec §7.1 |
| 57 | **Avoid CLEU** (`COMBAT_LOG_EVENT*` / `COMBAT_LOG_EVENT_UNFILTERED`) for V1 standing / suggestions / `SCORE_EVENT` inputs — do not register even behind a dormant flag. | Cheaper roster/regen/instance APIs exist; CLEU is meter hot-path cost and toxicity bait. | [63](../63-combatlog-social-signals/beef-v1-recommendation.md) · [63](../63-combatlog-social-signals/README.md) · [15](../15-instance-completion-events/README.md) · [59](../59-coplay-guildmate-detection/README.md) |
| 58 | Per-day **caps** (especially instance drip) and officer manual adjust/wipe remain in force. | Caps beat farm metas; officers correct testimony. | Spec §7.2 |

---

## G. Suggestion queue (offline officers)

| # | Decision | Rationale | Sources |
|---|----------|-----------|---------|
| 59 | V1 pending suggestions: **local-persist suggestion queue + live `SUGGESTION` fanout only** — **no** shared BeefNet suggestion store / `SYNC_STATE` field. | Closes §16.5 toward cousin norms; ladder heal stays separate. | [67](../67-offline-officer-suggestion-sync/v1-recommendation.md) · [67](../67-offline-officer-suggestion-sync/README.md) · Spec §16.5 |
| 60 | Offline Officer+ clients **miss** live petitions by design; official ranks still heal via §8.3. | Petitions are testimony; commits are law — heal the law first. | [67](../67-offline-officer-suggestion-sync/README.md) · [27](../27-desync-conflict-resolution/README.md) |
| 61 | Soft-expire pending rows on reject, already-promoted, **~14 days**, or subject leaves guild; re-petition cooldown **≤1/day per rank step**. | Bounds SV growth and spam without inventing tombstone sync. | [67](../67-offline-officer-suggestion-sync/v1-recommendation.md) |
| 62 | Shared suggestion catch-up is a **V1.1 flag** (`syncPendingSuggestions`, default off) — grow-only union by id if ever enabled. | Ship when playtest proves on-duty process insufficient — not “someday.” | [67](../67-offline-officer-suggestion-sync/v1-recommendation.md) · [27](../27-desync-conflict-resolution/README.md) |

---

## H. Packaging, modules, dependencies

| # | Decision | Rationale | Sources |
|---|----------|-----------|---------|
| 63 | Ship **one** `ChurchOfBeef.toc` with **`## Interface: 20506`** (verify live); install under Anniversary `_anniversary_/Interface/AddOns`. | Single-flavor support path; avoid accidental Era load via broad `_Classic.toc`. | [30](../30-anniversary-vs-era-deltas/beef-multi-toc-packaging.md) · Spec §12, §15 · [00](../00-church-of-beef-implications.md) |
| 64 | Architecture is **plain-namespace layered** `Data/` / `Core/` / `Net/` / `UI/` + bootstrap — **no AceAddon / NewModule** for V1. | Keeps Core desktop-testable; matches “No Ace for V1” consensus. | [34](../34-lua-module-architecture/beef-v1-architecture.md) · [00](../00-church-of-beef-implications.md) · plan File structure |
| 65 | Layer rules: **UI never awards points**; **Net never invents ranks**; **Core never `CreateFrame`**; **Data never reads SV**. | Prevents spaghetti and keeps `tests/wow_stub.lua` viable. | [34](../34-lua-module-architecture/beef-v1-architecture.md) |
| 66 | **Solo load is mandatory** — no hard `## Dependencies:` / `RequiredDeps` for core. | Guild install friction beats zip size; hard deps break clean folders. | [42](../42-soft-deps-embeds/beef-v1-dependency-policy.md) · [00](../00-church-of-beef-implications.md) |
| 67 | Shared libs (if any): **embed** when a concrete trigger fires (CTL pacing, then LibDBIcon); **Ace3 / Masque / LSM deferred** as requirements. | Prefer zero libs until pain; soft peers are feature-detected only. | [42](../42-soft-deps-embeds/beef-v1-dependency-policy.md) · [00](../00-church-of-beef-implications.md) |

---

## I. UI & spectacle (V1 surface)

| # | Decision | Rationale | Sources |
|---|----------|-----------|---------|
| 68 | V1 UI locks: **`/beef` + minimap** same toggle; tabs **Ladder / My Standing / Officer**; **plain Classic frames**; **one throttled guild-chat promote/demote line** from approving officer; **media fallbacks**; frame **always created**; movable + clamp + saved position. | Edge social tool + cheapest stream spectacle; theatrical chrome is later. | Spec §10, §15 · [00](../00-church-of-beef-implications.md) |
| 69 | List widgets use **fixed Lua row pools** with data rebind; **no HybridScrollFrame** and **no true ScrollFrame for action rows** in V1 — add **`FauxScrollFrameTemplate` only when a list overflows** the tab viewport. | Seven ladder bands + short officer queues fit pools; Hybrid wants XML templates and in-client verify. | [57](../57-scrollframe-list-rows/beef-ladder-officer-lists.md) · [57](../57-scrollframe-list-rows/README.md) · [35](../35-xml-vs-lua-ui/) |
| 70 | High-risk officer confirms use **`StaticPopupDialogs`** with **`preferredIndex = 3`** (or `STATICPOPUP_NUMDIALOGS`); **demote / Council / Prophet / standing wipe** require modal + named subject; **Approve/Reject need no modal**. | Community taint-slot hygiene + fat-finger protection for nuclear rites. | [58](../58-staticpopup-confirms/preferredindex-and-slots.md) · [58](../58-staticpopup-confirms/beef-demote-prophet-confirms.md) · [58](../58-staticpopup-confirms/README.md) |
| 71 | Officer tab is **four zones**: **(A) pending queue**, **(B) evidence** for selection, **(C) rite controls** outside the scroll pool, **(D) Recent Actions** — master–detail, Gargul authority / RCLC selection IA, no vote chrome. | One job per zone keeps promotion night scannable; nuclear rites stay out of the petition pool. | [69](../69-officer-tab-ia/v1-ia-recommendation.md) · [69](../69-officer-tab-ia/tab-zones.md) · [69](../69-officer-tab-ia/README.md) · Spec §7.3, §10 |
| 74 | Announce opt-out is an **Officer-tab checkbox** labeled **“Announce promotions to guild chat”** (procedural), mirroring **`ChurchOfBeefDB.ui.announce`**, **default ON**. | Spectacle is the V1 brand channel; officers need a discoverable quiet switch without burying it in slash-only. | Spec §10, §15 |
| 75 | V1 settings surface is **starved**: **position + minimap hide + announce opt-out** only; toast mute only if playtest demands; **no** UI-scale override, strata picker, or per-event announce filters. | More sliders kill spectacle and fight player/`UIParent` scale ownership. | Spec §10, §15 · [43](../43-ui-scale-pixel-perfection/beef-guidance.md) |
| 76 | My Standing ships **text thresholds only** for Task 8; thin track for ranks 1–5 is optional post-playtest; **no** meter-dashboard breakdown chrome. | Avoid castbar/XP misread and density slop (track 70). | Spec §10, §15 · [70](../70-standing-breakdown-ui/beef-v1-recommendation.md) |
| 77 | **No Streamer Mode code in V1** — document coexistence (third-party StreamerMode does not mask `/beef`); V1.1 may add SV name-mask / quieter toasts; privacy **must not** silently disable guild announce. | No Classic Streamer Mode API; announce is public rite. | Spec §10, §15 · [61](../61-streamer-mode-privacy/beef-stream-privacy-implications.md) |
| 78 | V1 chrome stays **template-native** (Blizzard defaults + GameFont); provisional brand hex is **not law** until Anniversary screenshot lock; no Alliance/Horde panel skins. | Filter remaps + stream contrast need in-client proof; church brand is shared across both guilds. | Spec §10, §15 · [23](../23-color-brand-tokens/) · [02](../02-visual-language/) |
| 79 | V1 is **silent** (no SFX). Later spectacle audio is optional, **default off**, cleared/licensed only — never ripped Blizzard soundtrack in the zip. | Quiet-by-default social tool; packaging/ToS hygiene. | Spec §10, §15 · [20](../20-sound-sfx-feedback/04-beef-v1-v2.md) |
| 80 | Post-V1 heraldry commission **may accept** flock seal escalation + Council/Prophet shape break when funded; **delay art** until plain shell + chat spectacle work. | Words-first brand; art after process UI earns it. | Spec §10, §15 · [44](../44-custom-textures-media-packaging/) |
| 81 | Custom brand accents beyond **class-colored names** and **dual-encoded state colors** wait on hex lock / art pass — do not paint research scarlet into every FontString in Task 7. | Avoid retuning twice after screenshot pass. | Spec §10, §15 · [23](../23-color-brand-tokens/) |

> Row 68 is a **bundle lock** of the §10 surface checklist (still one glossary decision: the V1 chrome/spectacle bar). Rows 69–71 deepen list/confirm/Officer IA without unlocking theatrical chrome. Rows 74–81 lock the Jul 2026 polish decision-card recommendations.

---

## J. Diagnostics & privacy

| # | Decision | Rationale | Sources |
|---|----------|-----------|---------|
| 72 | `/beef debug` (and cousin dumps) follow an explicit **allow/deny** privacy list: allow build/protocol/flags/self aggregates; **deny** full `ChurchOfBeefDB`, full roster, officer notes, chat/whisper text, combat logs, raw wire payloads, filesystem paths — never dump to guild chat; gate verbose surfaces behind `COB.DEBUG`. | Support paste ≠ SV zip; stream/Discord audience ≠ guild-visible names. | [65](../65-debug-dumps-privacy/debug-dump-allow-deny.md) · [65](../65-debug-dumps-privacy/beef-privacy-policy.md) · [65](../65-debug-dumps-privacy/README.md) |

---

## K. Desktop testing

| # | Decision | Rationale | Sources |
|---|----------|-----------|---------|
| 73 | Offline Core/Data tests are a **zero-dep `dofile` harness** (`tests/wow_stub.lua` + `tests/run.lua` + suite modules) — **Lua 5.1 preferred**; defer busted/WoWUnit; green desktop suites **do not** replace in-game Net/UI/spectacle QA. | Matches Classic-addon culture and plan Task 1; keeps Core pure without a WoW emulator. | [73](../73-desktop-lua-testing/beef-v1-recommendation.md) · [73](../73-desktop-lua-testing/README.md) · [34](../34-lua-module-architecture/beef-v1-architecture.md) · plan Tasks 1–5 |

---

## Explicitly not locked (do not invent as V1 truth)

| Topic | Status | Pointer |
|-------|--------|---------|
| Exact standing thresholds (§4.2 table) | Draft scaffolding until guild-night data | Spec §16.6 |
| Council seat count | Default 4 sketched; leadership decision open | Spec §16.2 |
| Alt account-link / merge | Open; V1 stays per-character | Spec §16.1 |
| Standing decay / Lent reset | Off in V1; revisit if ladder saturates | Spec §16.3 |
| Anniversary proof of `ENCOUNTER_END` / `BOSS_KILL` coverage | Prototype gate | Spec §16.4 · [15](../15-instance-completion-events/README.md) |
| Turning on `syncPendingSuggestions` | V1.1 flag, default off | [67](../67-offline-officer-suggestion-sync/v1-recommendation.md) |
| AceAddon / AceConfig profiles | Post-V1 if options explode | [34](../34-lua-module-architecture/beef-v1-architecture.md) · [42](../42-soft-deps-embeds/beef-v1-dependency-policy.md) |
| Theatrical gothic chrome / favor bar / deep Gora show | Explicitly deferred | Spec §3.2 |
| Brand hex token constants | Lock after Anniversary screenshot pass | Spec §10, §15 · [23](../23-color-brand-tokens/) |
| Thin standing StatusBar (ranks 1–5) | Optional post-playtest; not Task 8 | Spec §10, §15 · [70](../70-standing-breakdown-ui/) |
| Streamer Mode SV preset shape (mask vs quieter vs both) | V1.1 product call | Spec §10, §15 · [61](../61-streamer-mode-privacy/) |
| Optional faction chip | Post-V1 only if streamers ask | Spec §10, §15 |

---

## Source track map (depth)

| Track | What it locks / deepens |
|-------|-------------------------|
| [00](../00-church-of-beef-implications.md) | Ecosystem pressure test of spec stance |
| [14](../14-addon-messaging-beefnet/) | `COB` / `GUILD` / CTL / sync anti-spam |
| [15](../15-instance-completion-events/) | Instance/completion signal ship vs defer |
| [16](../16-guild-roster-officer-edges/) | Rank-index Officer+ edges |
| [27](../27-desync-conflict-resolution/) | Revision register vs CRDT |
| [30](../30-anniversary-vs-era-deltas/) | Single-TOC Anniversary packaging |
| [34](../34-lua-module-architecture/) | Plain layered modules, no AceAddon |
| [42](../42-soft-deps-embeds/) | Solo load; embed-when-needed |
| [57](../57-scrollframe-list-rows/) | Fixed row pools; Faux on overflow |
| [58](../58-staticpopup-confirms/) | StaticPopup `preferredIndex` + high-risk confirms |
| [59](../59-coplay-guildmate-detection/) | Guildmate co-play predicate (group + guildmate + instance) |
| [63](../63-combatlog-social-signals/) | No CLEU for V1 scoring |
| [65](../65-debug-dumps-privacy/) | Debug dump allow/deny privacy |
| [67](../67-offline-officer-suggestion-sync/) | Local-persist suggestion queue; no shared store |
| [69](../69-officer-tab-ia/) | Officer tab four-zone IA |
| [73](../73-desktop-lua-testing/) | Zero-dep `dofile` unit harness |
| [Design spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) | Canonical §15 decisions log |

---

## Maintenance

When a locked decision changes: update the **design-spec decisions log** first, then edit the matching row here, then fix any contradicting track README “product truth” tables. Do not leave this glossary as a silent fork.
