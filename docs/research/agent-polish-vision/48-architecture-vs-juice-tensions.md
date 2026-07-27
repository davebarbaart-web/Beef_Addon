# 48 — Architecture vs juice tensions (adversarial)

**Lane:** Agent polish vision  
**Date:** 2026-07-26  
**Maps to:** [design spec](../../superpowers/specs/2026-07-25-church-of-beef-design.md) §2, §6, §10, §15 · [UI agent brief](../../superpowers/ui-polished-direction-for-agents.md) · rules `architecture-overview`, `addon-module-layers`, `wow-ui-taint-lockdown`, `wow-performance`, `verification`  
**Cousins:** [02 Lua vs XML](02-lua-vs-xml-frames.md) · [03 taint/lockdown](03-taint-lockdown-ux.md) · [04 media](04-media-fonts-textures.md) · [12 progression loops](12-social-progression-loops.md)  
**Status:** Research guidance for agents — **not** product law. Spec + `.cursor/rules` win on conflict. This note argues *where polish pressure will try to break those contracts* and how to refuse without shipping bland UI.

---

## 1. Verdict

Church of Beef wants **guild-night spectacle** (throttled `/g` liturgy, private edge toast, legible ladder prestige) inside a **strict layered Classic addon** (UI→Core→Data, Net→Core→Data, no Core frames, no bots/injection/Retail APIs, idle when closed).

Those goals are compatible **only if juice stays in the display/announce shell** and never becomes:

- a second authority path (points, ranks, officer gate),
- a permanent animator / combat scanner,
- a secure-template or Blizzard-chrome hijack,
- or a Retail/WA center-screen religion.

**Doctrine restated for polish agents:** *Brand lives in words + one private toast; process UI stays Classic shell; Core stays headless; safety bans are not “V1 temporary.”*

Ambitious V2/V3 theater (ceremonial dashboard, favor meter, confession feed) must **widen surfaces under the same contracts** — not invent Core→UI callbacks, Net-invented ranks, or combat automation “for the show.”

---

## 2. The two poles (what is actually in conflict)

### 2.1 Architecture non-negotiables (hard)

| Contract | Meaning in practice |
|----------|---------------------|
| **Layer arrows** | UI→Core→Data; Net→Core→Data; **never** Core→UI |
| **No Core `CreateFrame`** | Scoring, Ladder, Officer, DB are headless; no fonts, toasts, or slash in Core |
| **UI never awards points** | Tabs/toasts/announce display outcomes; `Scoring` / `Ladder` own grants & commits |
| **Net never invents ranks** | Validate → Core apply APIs; roster Officer+ gate before `RANK_COMMIT` apply |
| **No AceEvent bus (V1)** | After Commit: direct `COB.UI:RefreshLadder()` (or thin equivalent) |
| **Safety / ToS shape** | Announce/track/sync only — no bots, injection, protected-action bypass, gameplay automation |
| **Client floor** | Anniversary `20506` only; no Retail/DF-only APIs or unverified Retail templates |
| **Taint / lockdown** | Fully insecure product windows; no SecureActionButton “to open a panel”; no EasyMenu / blind StaticPopup |
| **Performance** | UI closed → events only; no permanent `OnUpdate` business logic; combat ≠ ladder rebuild storms |
| **Verification** | Green `lua tests/run.lua` for Core/Data; in-client smoke for UI/Net/spectacle; two clients for guild/net |

### 2.2 Ambitious juice (what agents will want)

| Ambition | Why it feels necessary | Legitimate V1 home |
|----------|------------------------|--------------------|
| **Promotion spectacle** | Rank change nobody sees failed social check (§13) | Officer-origin throttled `/g` + private edge toast |
| **Motion / “feel”** | Toasts that pop feel dead without fade | Short `AnimationGroup` / `C_Timer` on **UI** toast regions |
| **Heraldry / gothic brand** | Brand context is cathedral/Scarlet/absurd clergy | **Words** in V1; custom `Media/` seals only in post-V1 art pass |
| **Standing drama** | Progress bars / HP metaphors scream “juice” | **Text thresholds only** (no hero StatusBar) |
| **Instant feedback on drip/Gora** | Short loop psychology | Toast + Standing history line — still Core-authored grants |
| **Officer ceremony chrome** | Approve should feel like a rite | Opaque Classic panel + procedural copy; nuclear rites get named confirm |
| **Streamer moments** | Capture-friendly pops | Guild chat line (visible without addon) + opaque toast; no center WA pulse |
| **V2/V3 theater** | Confessions, favor meter, dashboard | New **UI** surfaces + Core data APIs — same layer rules |
| **SFX / particles** | Celebration culture from other games | V1 silent; later SFX default **off**; no ripped Blizzard audio |

---

## 3. Adversarial tensions (where polish agents cheat)

Each row is a **predicted failure mode**: the juice argument an agent will make, the architecture it violates, and why “it still works in my `/reload`” is not enough.

### T1 — Core fires the celebration

**Juice argument:** “After `Ladder:Commit`, Core should `PlaySound` / spawn toast so peers can’t forget.”  
**Breaks:** Core→UI / Core `CreateFrame` / headless Core.  
**Why it dies later:** Desktop harness cannot host frames; Core tests become client-coupled; second UI surface (minimap LDB, future overlay) double-fires or races.

### T2 — Toast or announce grants standing

**Juice argument:** “Show the toast *and* `+5` in the same UI click handler for snappiness.”  
**Breaks:** UI never awards points; scoring authority; anti-AFK / caps live in Core.  
**Why it dies later:** Peers applying wire commits diverge from local UI-granted standing; officer audit lies.

### T3 — Net paints ranks for “live feel”

**Juice argument:** “On `RANK_COMMIT` receipt, Net updates the ladder FontStrings immediately.”  
**Breaks:** Net→UI skip; Net invents display truth without Core apply.  
**Why it dies later:** Revision / roster-gate bugs become invisible UI ghosts; sync reconcile fights painted chrome.

### T4 — AceEvent / message bus “for polish hooks”

**Juice argument:** “Broadcast `COB_RANK_COMMITTED` so toasts, minimap, scripture footer, and future WA bridges all subscribe.”  
**Breaks:** V1 “no AceEvent bus”; invites Core→UI via event tables and circular load.  
**Resolution shape:** Keep **direct** UI refresh after local Commit; peers refresh after Core apply returns. Optional thin `COB.UI.Notify*` later still lives in UI, called from bootstrap/Net dispatch *after* Core — not a general bus.

### T5 — Permanent `OnUpdate` “breathing” prestige

**Juice argument:** “Ladder seals pulse; standing bar eases every frame; proximity to Prophet glows.”  
**Breaks:** Performance non-negotiable; combat idle; “invisible next to WA/Details.”  
**Why it dies later:** Raid frames + nameplates already tax the client; social addon must not join that war.

### T6 — Center-screen WeakAuras-class pulse

**Juice argument:** “True spectacle needs screen center / full-screen atlas / combat-text style.”  
**Breaks:** Spec §10 / briefing / glossary — spectacle = `/g` + **edge** toast; anti-pattern list.  
**Why it dies later:** Stream clutter, combat occlusion, brand becomes generic alert spam.

### T7 — SecureActionButton / ShowUIPanel “so it feels Blizzard”

**Juice argument:** “Open `/beef` like a real panel; bind a secure button for combat-safe toggle.”  
**Breaks:** Taint/lockdown rules; Secure* for panels forbidden; combat mutations on protected paths.  
**Why it dies later:** Sticky taint breaks bags/options; lockdown blocks the “juice” mid-trash pull.

### T8 — EasyMenu / stock dropdown / StaticPopup slot fight

**Juice argument:** “Officer Reject needs a quick Blizzard dropdown; demote needs stock popup.”  
**Breaks:** Shared FrameXML taint / slot collision (track 03).  
**Resolution:** Custom insecure confirms; named `COB_*` StaticPopup with `preferredIndex` if used at all.

### T9 — Retail templates / DF APIs for prettier chrome

**Juice argument:** “`DefaultPanelTemplate` / NineSlice helpers look modern.”  
**Breaks:** `20506` floor; unverified Retail templates.  
**Resolution:** Classic-verified `BasicFrameTemplate` / `BackdropTemplate` / `UIPanelButtonTemplate` only.

### T10 — Custom Media hard-required for “brand juice”

**Juice argument:** “Ship gothic TGA now or the UI isn’t Church.”  
**Breaks:** V1 media policy; packaging; missing-media-must-not-fail-load.  
**Resolution:** Stock paths + word brand in V1; art pass adds PoT TGA with fallbacks later.

### T11 — Standing-as-HP / item-quality rainbow ranks

**Juice argument:** “Progress bar + epic purple title = prestige.”  
**Breaks:** Spec locks (text thresholds; class color on **names** only; dual-encode status).  
**Why it dies later:** Misread as combat power / loot rarity; colorblind hierarchy collapses.

### T12 — Multi-line guild liturgy / peer echo spam

**Juice argument:** “Three-line hymn on promote; every peer re-announces for presence.”  
**Breaks:** Throttle + officer-origin-only announce; RTT / filter culture; Net spam budgets.  
**Resolution:** One CTL-paced line from approving officer; peers toast privately.

### T13 — Instance drip / combat scan for “alive” juice

**Juice argument:** “OnUpdate proximity / unit aura scan so co-play feels magical.”  
**Breaks:** Safety (no combat tooling vibe); performance; scoring-coplay event model.  
**Resolution:** Event + low-rate ticker buckets; anti-AFK requires combat *in bucket*, not frame scans.

### T14 — Streamer Mode kills announce “for privacy juice”

**Juice argument:** “Hide everything on stream including `/g`.”  
**Breaks:** Spec — privacy must never silently disable officer guild announce; Streamer Mode not in V1 code.  
**Resolution:** V1.1 SV preset may quiet *private* toasts / mask names; announce stays officer-controlled.

### T15 — Reset / wipe SV for “clean demo juice”

**Juice argument:** “Agent clears `ChurchOfBeefDB` so the toast demo is pretty.”  
**Breaks:** Verification agent bans; destroys player standing.  
**Resolution:** Harness-only `ResetForTests` under `_IN_TEST`; never touch player WTF without explicit ask.

### T16 — Layer inversion via “helper” in ChurchOfBeef.lua

**Juice argument:** “Bootstrap can CreateFrame and call Scoring in one closure — not really Core→UI.”  
**Breaks:** Spirit of layers; becomes untestable god-object.  
**Resolution:** Bootstrap wires lifecycle only; CreateFrame stays under `UI/`; grants stay under `Core/`.

---

## 4. Resolution patterns (allowed architecture for juice)

Use these as **constructive** defaults when a polish task feels blocked by rules.

| Pattern | How it works | Satisfies |
|---------|--------------|-----------|
| **Display shell** | UI reads Core snapshots; dirty-flag refresh ≤10 Hz when open | Layers + performance |
| **Outcome pipeline** | Grant/Commit in Core → Net broadcast → UI refresh + Announce/Toast | Authority + spectacle |
| **Word brand** | Liturgical copy IDs in guild line + toast title/body | Brand without Media |
| **Edge motion only** | Toast alpha/slide via `AnimationGroup` or `C_Timer`; tear down when idle | Juice + no permanent OnUpdate |
| **Precreate insecure chrome** | Toast pool / main frame exist before combat; show/hide only | Lockdown safety |
| **Officer-origin spectacle** | Announce after *successful local* commit; peers never `/g` echo | Anti-spam + social check |
| **Fail-soft media** | Missing texture → stock path; frame still opens | Packaging + load safety |
| **Harness-first Core** | Pure Lua tests own ladder/scoring; client owns toast/announce QA | Verification split |
| **Phase the theater** | V1 process UI → V1.1 streamer SV → art/SFX pass → V2 dashboard | Ambition without contract break |
| **Direct refresh, not bus** | `COB.UI:Refresh*()` from known call sites after Core returns | V1 coupling rule |

### Call-site sketch (legal)

```text
Officer Approve click (UI)
  → Ladder:Commit / reject (Core)     -- authority
  → BeefNet send (Net)                -- optional wire
  → Announce:GuildLine (UI/Net helper)-- officer client only, gated
  → UI:RefreshLadder + Toasts:Show    -- juice
  -- Core never calls Toasts
```

```text
Peer CHAT_MSG_ADDON (Net)
  → roster Officer+ gate
  → Ladder:ApplyRemoteCommit (Core)
  → UI:Refresh* + private toast       -- local juice only
  -- no SendChatMessage on apply
```

---

## 5. Resolution table (tension → do / don’t)

| # | Tension | Resolution (do) | Forbidden shortcut (don’t) |
|---|---------|-----------------|----------------------------|
| 1 | Celebration needs a trigger | UI/bootstrap calls Toast/Announce **after** Core commit/apply returns | Core `CreateFrame`, Core `PlaySound`, Core→`COB.UI` |
| 2 | Snappy standing feedback | Core grant APIs; UI shows result toast/history | Points awarded in `Toasts.lua` / tab OnClick |
| 3 | Live ladder on wire | Net → Core apply → UI refresh | Net writing FontStrings / ladder tables |
| 4 | Multiple listeners for promote | Explicit `Refresh*` / `NotifyPromote` in UI module | AceEvent / global message bus in V1 |
| 5 | Motion / prestige pulse | Short toast anim; static ladder chrome when closed | Permanent `OnUpdate`, per-row forever AnimationGroups |
| 6 | “Real” spectacle | Throttled `/g` + private **edge** toast | Center-screen WA pulse, full-screen atlas, combat text hijack |
| 7 | Blizzard-native open | Insecure `:Show()` / `:Hide()` on Beef root | `SecureActionButton*`, `ShowUIPanel` for `/beef` |
| 8 | Officer confirms / menus | Own insecure confirm; careful named StaticPopup | Raw `EasyMenu` / stock dropdown / blind `StaticPopup_Show` |
| 9 | Prettier panels | Classic-verified templates + opaque backdrops | Retail-only templates / DF APIs without Anniversary proof |
| 10 | Gothic brand | Liturgical microcopy; post-V1 `Media/` + fallbacks | Hard-dep custom fonts/textures; load fail on missing file |
| 11 | Progress drama | Text “Title · standing · next threshold” | Hero StatusBar; item-quality colors on ranks |
| 12 | Guild presence | One officer-origin announce; peers private toast | Multi-line hymns; peer `/g` echo; announce-before-commit |
| 13 | Co-play “alive” feel | Event + capped bucket tickers; combat-in-bucket anti-AFK | Per-frame proximity/aura combat scans |
| 14 | Stream privacy | Document coexistence; V1.1 quiet *private* surfaces | Silently kill guild announce; fake Streamer Mode in V1 |
| 15 | Clean demo state | Test harness reset under `_IN_TEST` only | Delete/overwrite player `WTF/**/ChurchOfBeefDB.lua` |
| 16 | Bootstrap convenience | Lifecycle wire only; keep CreateFrame in `UI/` | God-file that scores + frames + net in one closure |
| 17 | SFX celebration | Later pass, default off, original/cleared assets | V1 forced sounds; ripped Blizzard audio |
| 18 | Combat officer flow | Insecure Approve → SV + message; defer protected touches | Open GuildFrame / options from Commit; secure headers |
| 19 | Perf vs dirty UI | Dirty flags; coalesce ≤10 Hz when open | Rebuild full ladder per BeefNet message |
| 20 | Ambition vs V1 scope | Park dashboard/favor/confessions in V2+ under same layers | Smuggle V2 theater into Task 7–10 as “just juice” |

---

## 6. Reviewer red flags (reject in PR)

Treat as **architecture bugs**, not taste nits:

1. `CreateFrame` / `CreateFontString` / `CreateTexture` under `Core/`  
2. `COB.Scoring` / `COB.Ladder` called from toast display *to mutate* standing  
3. `SendAddonMessage` / `SendChatMessage` inside Core  
4. `SecureActionButtonTemplate` / `SecureHandler*` on product chrome  
5. Permanent `OnUpdate` on a frame that exists while UI closed  
6. Center-anchored promote fireworks / fullscreen overlay for social events  
7. Retail template names not verified on `20506`  
8. TOC listing missing Media or Lua files  
9. Announce path that can fire without successful Commit  
10. Agent scripts that wipe player WTF or call `ResetForTests` outside harness  

---

## 7. What “ambitious” still looks like (so agents don’t under-ship)

Architecture is a **channel**, not a muffler. High-ambition *legal* juice:

- Liturgical, specific promote/demote copy (procedural officer labels; meme voice in toast/guild line per glossary).  
- Opaque high-contrast toast with crisp hold + fade; queue cap respected.  
- Ladder occupancy + local highlight that reads at stream distance.  
- Dual-encoded pending/approve/reject (color **and** text).  
- Officer tab that feels like clergy process without becoming Details!-dense.  
- Post-V1: hard-edged seals, optional SFX default off, still Classic shell.  
- V2+: ceremonial dashboard as **more UI modules + Core queries**, not a second addon religion.

If a design only works by inverting layers, it is **not** Church of Beef polish — it is a different product.

---

## 8. Authority reminder

| Question | Wins |
|----------|------|
| May we center-pulse? | Spec §10 / §15 — **no** |
| Who awards points? | Core Scoring / Ladder only |
| Who CreateFrames? | UI (+ bootstrap wire) only |
| Rank numbers / titles | `Data/Ranks.lua` |
| Is this note law? | **No** — log product changes in spec §15 |

---

## 9. Depth links

| Need | Path |
|------|------|
| Module map | `.cursor/rules/addon-module-layers.mdc` |
| Taint / lockdown | [03-taint-lockdown-ux.md](03-taint-lockdown-ux.md) · `.cursor/rules/wow-ui-taint-lockdown.mdc` |
| Motion construction | [02-lua-vs-xml-frames.md](02-lua-vs-xml-frames.md) § polish |
| Media / seals | [04-media-fonts-textures.md](04-media-fonts-textures.md) |
| Performance | `.cursor/rules/wow-performance.mdc` |
| Agent UI briefing | [ui-polished-direction-for-agents.md](../../superpowers/ui-polished-direction-for-agents.md) |
| Verification bans | `.cursor/rules/verification.mdc` |
