# 45 — BeefNet / sync status UX (connecting · stale · conflict · success)

**Audience:** Coding agents polishing Church of Beef mesh status (footer chip, soft warns, commit toasts) without forking ladder authority into Net or UI.  
**Last updated:** 2026-07-26  
**Status:** Research synthesis for polish — **not** product law. Spec §8 / §10–§11, glossary, and [`ui-polished-direction-for-agents.md`](../../superpowers/ui-polished-direction-for-agents.md) win on conflict.  
**Parent machine:** [20 empty states & disclosure](20-empty-states-disclosure.md) owns `UIStatus` enum, priority, and banner vs chip. **This note** deepens the four player-facing feedback families and the layer contract that keeps Net from inventing ranks.  
**Hard rules:** [`.cursor/rules/beefnet-messaging.mdc`](../../../.cursor/rules/beefnet-messaging.mdc) · [`addon-module-layers.mdc`](../../../.cursor/rules/addon-module-layers.mdc) · [`ladder-authority.mdc`](../../../.cursor/rules/ladder-authority.mdc).  
**Wire truth today:** `addon/ChurchOfBeef/Net/Sync.lua` (settle ~6s, consume ~45s, officer-first jitter) · `Net/BeefNet.lua` (validate → Core apply).  
**Client:** TBC Classic Anniversary (`## Interface: 20506`).

---

## Executive summary

Sync UX must keep the **cached ladder readable** while reconciling, treat most wire failures as **silent**, surface protocol mismatch as a **once-per-session soft warn**, and reserve toast/`/g` spectacle for **commits** — not login sync success. Status lives in UI; Net/Sync stay frameless. Details and copy families follow.

## 1. Executive rules (read first)

1. **Net validates shape + Officer+; Core owns merge; UI only presents.** Net never invents `rankId`, titles, thresholds, or seat winners. After accept: `Ladder:ApplyRemoteCommit` / `Commit` → `RefreshLadder` + optional toast built from **Core/Data** titles.
2. **Status is mesh honesty, not ladder content.** Connecting / stale / conflict / success chips must not invent occupants while waiting.
3. **Keep the cache visible while connecting.** Never blank the ladder into “No data” during settle / roster wait / sync ([20 §1](20-empty-states-disclosure.md)).
4. **Timeout is not failure.** Silence after consume → `cached` or `no_peers` — calm L0 chip, never a blocking modal or red panic ([spec §8.3](../../superpowers/specs/2026-07-25-church-of-beef-design.md)).
5. **Most “conflicts” are silent.** Older revision / replay / forged non-officer drops make **no** toast. Only protocol skew and hard gates speak ([BeefNet today](../../../addon/ChurchOfBeef/Net/BeefNet.lua)).
6. **Success juice is short and private.** Login sync success = brief chip → idle. Live commit success = edge toast + ladder refresh (and officer `/g` spectacle when opted in) — not a second status sermon.
7. **One frame-level presenter.** Prefer a single `UIStatus` chip on the main frame over per-tab sync strings inventing their own religion ([20 §7](20-empty-states-disclosure.md)).

---

## 2. Layer contract (non-negotiable)

```text
CHAT_MSG_ADDON (GUILD / COB)
  → Net: decode, type gate, roster Officer+ (commits), hold if roster unread
  → Core Ladder: ApplyRemoteCommit / ImportSuggestion  (revision merge lives HERE)
  → UI: RefreshLadder + toast/chip from Core getters + Ranks.Title
```

| Layer | May | Must not |
|-------|-----|----------|
| **Net / Sync** | Emit status *signals* (`pendingRequest`, merge count, hold depth, version warn once); pace CTL; suppress duplicate sync replies | Decide titles; “fix” ranks from cache guesses; invent occupants for empty shelves; toast with hardcoded rank names |
| **Core** | Revision win / lose; commit; suggestion import; officer gate | `CreateFrame`; paint chips; SendAddonMessage |
| **UI** | Map `UIStatus` + soft flags → FontString chip / banner / toast copy; dual-encode severity | Award points; call ApplyRemoteCommit with homemade records; claim “synced to Prophet” without Core record |

**Copy rule:** Any string that names a rank title must come from `COB.Ranks.Title(rankId)` (or equivalent Data helper) after Core has accepted the record. Status chips talk about **mesh** (“Syncing ladder…”, “Using cached ladder”), never about inventing who sits where.

**Roster-backed amendment watch:** If [roster-backed ladder design](../../superpowers/specs/2026-07-25-roster-backed-ladder-design.md) retires BeefNet rank replication, keep this *feedback shape* but rename chips to roster readiness language and drop “ladder sync success” — do not leave a zombie Net rank UX in UI Lua. Log the product move in spec §15.

---

## 3. Four feedback families

Map onto [20 §6 `UIStatus`](20-empty-states-disclosure.md). Soft flags decorate settled states; they are not exclusive states.

| Family | Player question | UIStatus / flags | Severity | Default surface |
|--------|-----------------|------------------|----------|-----------------|
| **Connecting** | “Is the Church still waking up?” | `settling`, `roster_wait`, `syncing` | neutral / info | L0 chip only |
| **Stale** | “Am I looking at old testimony?” | `cached`, `no_peers` (+ optional `few_peers`) | calm warn | L0; L1 only if cache empty (first-install A) |
| **Conflict** | “Did something disagree / get refused?” | soft `version_warn`; silent Core rejects; hold-for-roster | soft warn or **silent** | chat once / chip; almost never toast |
| **Success** | “Did catch-up or a commit land?” | brief `synced` → `ready`; commit/suggestion toasts | positive, short | chip 1–2s **or** edge toast — not both for the same event |

---

## 4. Connecting UX

### 4.1 Phases (wire → chip)

Aligned with `Sync:OnLogin` / roster gates:

| Phase | Wire / host truth | Chip copy (default) | Ladder body |
|-------|-------------------|---------------------|-------------|
| Settle | `PLAYER_LOGIN` → ~`RequestDelay` (6s) before send | Quiet, or `Starting Church…` | Show SV cache if any |
| Roster wait | In guild, `RosterReady()` false; holds may pile | `Waiting for guild roster…` | Keep cache; **never** flash unguilded |
| Syncing | `SYNC_REQUEST` out; `pendingRequest` live; consume window open (~45s) | `Syncing ladder…` | Keep cache; dirty-refresh only on real merges |
| (Optional) Held | Answers arrived before roster | Stay on roster-wait / syncing | No “Applying forged ranks” copy |

### 4.2 Connecting micro-rules

| Do | Don’t |
|----|-------|
| One quiet chip; Classic `GameFont*` | Indeterminate StatusBar / Retail skeleton loader |
| Allow `/beef` immediately | Modal “Please wait for sync” |
| Coalesce UI refresh ≤10 Hz when open ([perf rule](../../../.cursor/rules/wow-performance.mdc)) | Rebuild full ladder per inbound chunk |
| End connecting on merge **or** consume timeout | Infinite `Syncing…` |
| Treat not-in-guild as hard gate (banner), not as sync | Confuse unguilded with “no peers” |

### 4.3 Motion / juice

Connecting is **competence juice**, not celebration ([11 §8 technique 18](11-game-juice-fundamentals.md)):

- No overshoot, no green flash, no toast spam on login settle.
- Optional: chip alpha 0→1 in ~150–200ms ease-out when entering `syncing`; no loop pulse.
- Combat: FontString updates on insecure Beef frames are fine; never touch protected Blizzard chrome to “show sync.”

---

## 5. Stale UX

Stale means **honest cache**, not corruption. Spec: if no peer answers, keep cached view and reconcile later (§8.3).

| Outcome | Condition | Chip | Banner? |
|---------|-----------|------|---------|
| Cached | Consume elapsed + local official records nonempty | `Using cached ladder` | No |
| No peers | Consume elapsed + empty official cache | `No peers online` | Yes — first-install / learning empty (A), not “sync failed” |
| Few peers | Soft flag after ready/cached | `Few Church peers online` (optional) | No |
| No officers | Soft flag | `No officers online` | No — petitions may wait; ladder cache still valid |

### 5.1 Stale honesty rules

1. **Never red-banner “DESYNC”** for quiet nights — guilds are sparse; silence is normal.  
2. **Never clear ranks** to perform stale. Showing yesterday’s Council is correct until a higher revision arrives.  
3. **Officer tab quiet ≠ stale mesh** — “No petitions” is celebratory empty, not sync failure ([20 §3](20-empty-states-disclosure.md)).  
4. **Suggestions are not ladder sync** — offline officers miss live `SUGGESTION` by V1 design; do not chip that as `cached`.  
5. Auto-dismiss `cached` chip after idle (~8–12s) or on next successful merge; leave `no_peers` until peer appears or player closes the frame.

### 5.2 Copy tone

Procedural, short, stream-safe. Personality lives in lore footers elsewhere — status chips stay calm:

| Prefer | Avoid |
|--------|-------|
| Using cached ladder | STALE / OUT OF DATE / ERROR 503 |
| No peers online | Install Church of Beef!! |
| Waiting for guild roster… | Loading authentic ranks… |

---

## 6. Conflict UX (what “conflict” means here)

There is **no** player-facing three-way merge UI. Convergence is deterministic in Core (higher `revision` → later `updatedAt` → greater `updatedBy`). “Conflict” in this polish note means **refused or incompatible wire events**, not a diff editor.

### 6.1 Conflict taxonomy → feedback

| Event | Who decides | Player feedback | Why |
|-------|-------------|-----------------|-----|
| Replay / older `RANK_COMMIT` | `Ladder:ApplyRemoteCommit` returns false | **Silent** | Normal fanout cost (BeefNet today) |
| Sync record loses revision race | Same Core merge | **Silent** | Would spam on every chunk |
| Non-officer / forged commit | Net `ValidateRankCommit` | **Silent** drop | Do not teach attackers via UI |
| Malformed payload | Net parse | **Silent** | Noise |
| Roster not ready | Net/Sync hold queue | Stay on connecting chip; no “conflict” word | Fail closed, not drama |
| Major protocol mismatch | Net `_WarnVersion` (once / session) | Soft **chat** line + soft flag `version_warn` on chip | Spec §11; already implemented pattern |
| Incompatible commit discarded | Net version gate | Covered by version warn; no per-message toast | Avoid storm |
| Local Commit rejected (validation / seats) | Core → Officer UI | Officer tab / action status line — **not** BeefNet chip | Different plane |

### 6.2 Version-warn presentation

| Channel | Copy shape | Cadence |
|---------|------------|---------|
| Chat (existing) | Soft amber Church prefix; name peer major vs local `PROTOCOL` | Once per session (`warnedVersion`) |
| L0 chip (optional polish) | `BeefNet version mismatch` while flag set | Hide after ~10s or on dismiss; never block `/beef` |
| Toast | **No** | Toasts are for recognition outcomes |

Do **not** dual-encode version warn as reject-red celebrate-fail juice. It is a soft coordination issue, not an excommunication.

### 6.3 What agents must not build

| Temptation | Reject |
|------------|--------|
| “Conflict: keep local or accept remote?” modal | Revision rules already chose; modal forks trust |
| Net rewriting `rankId` to “resolve” | Layer violation |
| UI inventing a third rank to display during hold | Shows fake Church |
| Per-dropped-commit error toast | Login storms + CTL noise |
| Progress bar of held queue depth for members | Officer debug only (L3), not V1 default |

---

## 7. Success micro-feedback

Two success planes — do not conflate them.

### 7.1 Login / catch-up success (`synced`)

| Beat | Timing | Surface | Copy |
|------|--------|---------|------|
| Enter | First useful merge (`MergeState` / apply count > 0) while `pendingRequest` ours | L0 chip | `Synced` or `Ladder updated` |
| Hold | ~1.0–2.0s | Chip visible | No motion beyond optional ease-out |
| Exit | Auto → `ready` | Chip hidden | — |

Rules:

- **One** success chip per login consume window — not one per chunk.  
- If merge count is 0 but a valid empty-signed answer is impossible today (unsigned/empty ignored), stay on connecting until timeout → stale family.  
- **No toast** for login sync success — toast budget is for human-meaningful rites (promote, petition, credit).  
- Do not announce sync success in guild chat.

### 7.2 Live commit / suggestion success (recognition)

| Event | Source of truth | Feedback |
|-------|-----------------|----------|
| Local officer Commit | Core commit return + `Ranks.Title` | Instant ladder row update + private toast; optional `/g` from officer client |
| Remote `RANK_COMMIT` applied | Core `ApplyRemoteCommit` true | Toast `"{name} is now {title}."` + refresh (existing Net→toast pattern) |
| Remote suggestion (officer) | Core `ImportSuggestion` | Toast petition line + Officer tab dirty |
| Remote apply false (stale rev) | Core | Silent — **not** success, not conflict UX |

Juice polarity ([11](11-game-juice-fundamentals.md)): success may use brief dual-encoded positive chip/toast; errors stay sharp and short with **no** overshoot. Parallel channel sync: toast title string and guild announce must use the **same** `rankId` → `Ranks.Title` path.

### 7.3 Success anti-patterns

| Anti-pattern | Why |
|--------------|-----|
| Toast + chip + RaidNotice for one sync | Spectacle inflation; stream noise |
| “Synced 14 ranks” debug in default UI | Privacy + clutter; keep counts for `/beef` debug later |
| Celebratory bounce on `cached` | Cached is degraded honesty, not a win |
| Net crafting title strings without Data | Drift from canon |

---

## 8. Surface map & presenter API (agent sketch)

Research-only shape — names may match existing modules when implemented:

```text
COB.Sync / COB.Net  →  signals only (no frames)
COB.UI.Status       →  Compute() → UIStatus + softFlags
                    →  Present() updates one FontString chip
COB.Toasts          →  recognition only (commits, petitions, credits)
```

| Signal (from Net/Sync/host) | UI interpretation |
|-----------------------------|-------------------|
| `not IsInGuild()` | `unguilded` |
| `pendingRequest` set, before send | `settling` / then `syncing` |
| `RosterReady() == false` | `roster_wait` (or hold connecting) |
| `MergeState` / apply returned > 0 for our req | `synced` |
| Consume cleared + records > 0 | `cached` |
| Consume cleared + records == 0 | `no_peers` |
| `_WarnVersion` fired | soft `version_warn` |
| No Officer+ in roster cache | soft `no_officers` |

Presenter priority stays in [20 §6.2](20-empty-states-disclosure.md). Chip lives on main frame footer/header; tabs do not each invent sync chrome.

---

## 9. Timing budget (V1)

| Token | Value | Notes |
|-------|-------|-------|
| Login settle before `SYNC_REQUEST` | ~6s (`Sync.RequestDelay`) | Quiet chip OK |
| Officer reply jitter | 1–3s | Freshest source first |
| Member reply jitter | 4–8s | Suppression floor |
| Consume window | ~45s | Then stale family |
| `synced` chip hold | 1–2s | Then `ready` |
| `cached` chip hold | 8–12s or until dismiss | Calm |
| Version chat warn | Once / session | Existing `warnedVersion` |
| UI dirty coalesce | ≤10 Hz when open | Perf rule |
| Outbound pacing | ≥0.5s (`SendInterval`) | No status spam on wire |

No permanent `OnUpdate` for status — drive from events, `C_Timer.After`, and refresh hooks already used by Net/Sync.

---

## 10. Color & dual-encode (status only)

Per [18 color hierarchy](18-color-hierarchy-readability.md) and V1 UI direction:

| Family | Encode | Hue role |
|--------|--------|----------|
| Connecting | Word alone (neutral GameFont) | No spinner color language required |
| Stale (`cached` / `no_peers`) | Word + optional dim/warn token | Dual-encode if tinted; never color-only |
| Conflict (`version_warn`) | Word + amber chat (existing) | Soft; not reject-red |
| Success (`synced` / commit toast) | Word + brief positive token on toast path | Commit toasts may use dual-encode; sync chip stays understated |

Never paint status with item-quality rainbow or class color (class color = **names** only).

---

## 11. Agent acceptance checklist

- [ ] Connecting never blanks SV ladder occupants  
- [ ] Consume timeout always exits to `cached` or `no_peers`  
- [ ] Older revision / forged / malformed = silent (no toast)  
- [ ] Protocol mismatch = once-per-session soft warn; commits still gated  
- [ ] Login sync success = brief chip only (no toast, no `/g`)  
- [ ] Live apply toast titles from `Ranks.Title` after Core accept  
- [ ] Net/Sync files contain no `CreateFrame` status widgets  
- [ ] UI status presenter does not call Commit / invent records  
- [ ] Officer empty queue copy ≠ stale/conflict copy  
- [ ] `/beef` opens in all `UIStatus` values  
- [ ] Two-client smoke: offline during promote → login sync chip path → correct Core rank (not UI guess)

---

## 12. Sources & depth

**In-repo**

- [20 empty states / UIStatus machine](20-empty-states-disclosure.md) — parent enum & priority  
- [11 game juice](11-game-juice-fundamentals.md) — error ≠ reward; parallel channel sync  
- [14 BeefNet mapping](../wow-classic-addon-design/14-addon-messaging-beefnet/beefnet-mapping.md) — wire types & failure table  
- Design spec §8.2–§8.3, §11; plan Task 12  
- Rules: `beefnet-messaging`, `ladder-authority`, `addon-module-layers`, `wow-performance`

**Code anchors**

- `Net/Sync.lua` — `OnLogin`, `MergeState`, `OnSyncState`, hold/release  
- `Net/BeefNet.lua` — `HandleRankCommit` silent lose; `_WarnVersion`; toast only after apply  
- `Core/Ladder.lua` — `ApplyRemoteCommit` revision predicates  

---

## 13. Out of scope

- Changing wire framing, CTL budgets, or revision predicates (tracks 14 / 27)  
- Full microcopy voice bible (track 32)  
- Implementing the chip Lua in this research note  
- Roster-backed authority product decision (amendment draft — follow spec if locked)  
- Suggestion store sync (explicitly not V1 shared BeefNet store)

---

## 14. Sourced practices (UX / sync status)

| Practice | Source / reason |
|----------|-----------------|
| Stale data visible beats blanking | Offline-first / cache-then-reconcile; CoB SV ladder must remain readable during `SYNC_REQUEST` |
| Soft success, loud conflict only when actionable | Error ≠ reward ([11](11-game-juice-fundamentals.md)); protocol mismatch = once/session warn |
| Status as peripheral chrome | Process UI doctrine — sync chip must not compete with ladder / Commit |
| Event-driven refresh, not poll | [Wowpedia OnUpdate](https://wowpedia.fandom.com/wiki/UIHANDLER_OnUpdate); `wow-performance.mdc` |
| Dual-encode warn states | Color hierarchy [18](18-color-hierarchy-readability.md); never color-only |

Wire timing numbers are **sourced from CoB `Net/Sync.lua`** (`RequestDelay`, jitter bands, `ConsumeSeconds`) — not invented here.

---

## 15. CoB-specific application

| Module | Role |
|--------|------|
| `Net/Sync.lua` | Login request, peer reply race, merge — **no** status frames |
| `Net/BeefNet.lua` | Commit apply / silent lose / version warn — toast only after Core accept |
| `Core/Ladder.lua` | Revision truth |
| `UI/*` (future chip presenter) | Maps `UIStatus` → words; never invents ranks |

Implement against parent enum in [20](20-empty-states-disclosure.md). Keep connecting/synced understated; reserve toast spectacle for commits ([46](46-toast-celebration-system.md)).

---

## 16. Agent rules

1. Net/Sync must not `CreateFrame` status widgets — UI presents only.  
2. Never blank cached ladder occupants while `connecting`.  
3. Older revision / forged / malformed → silent (no toast).  
4. Login sync success → brief chip only (no `/g`, no toast).  
5. No permanent `OnUpdate` for status animation.  
6. Two-client smoke required before claiming sync UX done (`verification.mdc`).  
7. Do not change wire contracts from a UI polish prompt — escalate to BeefNet tracks.

---

## 17. Open questions

1. Chip placement: title bar vs footer vs Standing strip? (playtest)  
2. Hold duration for `cached` chip: 8–12s vs sticky until next successful sync?  
3. Should `no_peers` offer a manual “Request sync” button in V1 or stay automatic-only?  
4. Roster-backed ladder amendment — does status copy need “awaiting officer truth” language?  
5. Mute interaction with toast mute (if playtest adds it) — independent SV keys?
