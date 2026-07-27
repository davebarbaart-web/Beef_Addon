# 19 — Onboarding UX (guild / social addons)

**Audience:** Cursor agents implementing or polishing Church of Beef first-session UX  
**Last updated:** 2026-07-26  
**Scope:** First `/beef` open, empty ladder, member vs Officer+ paths, progressive disclosure, implement/test script  
**Out of scope:** Detailed empty-state *copy* authorship (→ track [41](../wow-classic-addon-design/41-empty-states-degraded-ux/), sibling [20](20-empty-states-disclosure.md)); AceConfig trees; Retail Settings APIs; combat HUD tutorials

**Authority reminder:** This brief is research guidance. Product law stays in [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../superpowers/specs/2026-07-25-church-of-beef-design.md) §10–§11, §13 and glossary rows 68–76. Do not fork thresholds or invent settings here.

---

## 1. Executive verdict

Church of Beef should ship **zero-config social onboarding**, not an ElvUI/Questie-style installer.

| Principle | Locked / recommended |
|-----------|----------------------|
| Philosophy | **Zero-config** — safe defaults mean no blocking wizard ([track 11](../wow-classic-addon-design/11-onboarding-settings-ux/first-run-and-defaults.md)) |
| Discoverability | `/beef` + minimap same toggle; empty slash opens a **real frame** (spec §10) |
| Teach via | Honest empty states + ambient help (footer / tip / first toast), not coach marks over the world |
| Role split | **Member path** = Ladder + My Standing; **Officer+ path** = same + gated Officer tab |
| Disclosure | Surface the **loop** first (earn → suggest → bless → guild chat); hide rites / nuclear confirms until Officer+ |
| Settings | Starve V1 prefs (position, minimap hide, announce opt-out) — do not onboard into a preferences tree |

Success for first session is **not** “player configured the addon.” It is: they see the seven ranks, know they are Fresh Beef, understand how standing rises, and (if Officer+) know where petitions live. Spectacle still needs a later guild-night promote (spec §13.11) — unit tests cannot prove that.

---

## 2. Ecosystem patterns (steal / skip)

### 2.1 Two first-run philosophies

| Pattern | Fits when | Classic exemplars | Beef V1 |
|---------|-----------|-------------------|---------|
| **Wizard / installer** | Wrong default breaks the product | ElvUI installer; Questie first-login setup | **Skip** |
| **Zero-config** | Defaults are safe; value appears immediately | Meters/lists that open empty-but-honest; silent-until-needed alerts | **Adopt** |

Rule of thumb from track 11: interrupt only when a wrong guess is expensive. Beef’s defaults (Fresh Beef / 0, scoring paused out of guild, Officer tab hidden) are already safe.

### 2.2 Soft overlays (optional cousin)

Guild-tool cousin **GRIP** ships a dismissible Home onboarding overlay once, persisted as `_onboardingDismissed`, with a smart-dismiss if the user already has real data ([WoWInterface changelog](https://www.wowinterface.com/downloads/info27072-GRIP-GuildRecruitmentAutomation.html); [README quick start](https://github.com/JesperLive/GRIP)).

**Steal:** one dismissible tip + SV flag; skip overlay if ladder/standing already populated.  
**Skip for V1 default:** full multi-page overlay chrome. Prefer in-frame empty copy (cheaper, on-brand, no bleed). If a soft tip is added, keep it to **one surface** (chat print *or* footer banner — not both every login).

### 2.3 Empty states as the onboarding surface

Product UX literature treats empty states as the real first-run UI, not a 404 ([UserOnboard — Empty States](https://www.useronboard.com/onboarding-ux-patterns/empty-states/)):

1. **Educate** — what this space becomes when full  
2. **CTA** — one next action toward value  
3. **Personality** — light brand (heading), not a meme wall  

Rule of thumb: **two parts instruction, one part delight.** Timing matters — end the first open on the Ladder (the product), not buried Settings.

Slash + minimap remain the Classic discoverability stack ([slash vs GUI](../wow-classic-addon-design/11-onboarding-settings-ux/slash-commands-vs-gui.md); [ImprovedGuildWindow](https://github.com/totalllyswede/ImprovedGuildWindow)-style `/igw` → real window).

---

## 3. First `/beef` open — contract

### 3.1 Must happen (hard)

| # | Behavior | Spec / research |
|---|----------|-----------------|
| 1 | Frame **exists** on load or first `/beef` — never chat-only silence | Spec §10 failure mode |
| 2 | Default tab = **Ladder** | Track 00 implication; product surface first |
| 3 | All **seven ranks** visible as structure (empty shelves OK) | Spec §13.3; track 41 Scenario A |
| 4 | Local player highlighted as **Fresh Beef** (or committed title) with standing | Spec §10 My Standing / Ladder |
| 5 | **Officer tab button hidden** unless `LocalIsOfficer()` | Spec §11 |
| 6 | Minimap left-click = same toggle as `/beef` | Spec §10 |
| 7 | No Retail-only APIs; no SecureActionButton “to open panel” | UI brief / glossary |

### 3.2 Soft teach (recommended, non-blocking)

| Surface | Content seed | Persistence |
|---------|--------------|-------------|
| Optional one-shot chat | `Church of Beef: /beef opens the Church. Standing is local until an officer blesses a rank.` | `ChurchOfBeefDB.ui.firstRunTipDone` (or equivalent) |
| Minimap tooltip | Open ladder · `/beef` | Always |
| Footer / tip line | One scripture **or** one loop tip — not a settings dump | Spec §10 one-line footer |
| `/beef help` | Short chat card (slash map + loop in 4 lines) | Track 11 tutorial patterns |

### 3.3 Must not happen

- Blocking multi-step wizard on login  
- Fake demo occupants / seeded ladder theater  
- Auto-opening Officer tab for members (or showing grey disabled Officer chrome)  
- Spamming first-run tip every `/reload`  
- Opening into Settings / announce checkbox as the hero  
- World coach marks, forced `/reload` tours, ARPG finger overlays  

---

## 4. Empty ladder — state matrix for first session

Keep **rank chrome always** (seven shelves). Swap the banner / chip / Standing body by situation. Copy slots live in track [41 beef-copy-ux-map](../wow-classic-addon-design/41-empty-states-degraded-ux/beef-copy-ux-map.md); agents should reuse those strings, not invent a second voice.

| State | Ladder | My Standing | Officer | Next action taught |
|-------|--------|-------------|---------|-------------------|
| **A — Fresh install, in guild** | Empty shelves + “ranks await” banner | Fresh Beef · 0; events empty | Hidden (member) or quiet empty queue (officer) | Play with a guildmate / open Standing |
| **B — Not in a guild** | Preview shelves + “no flock” | Scoring paused | Hidden / unreachable | Join guild via Blizzard Guild UI |
| **C — Syncing / cache** | Keep cache; chip “Syncing…” | Unchanged | Keep local queue | Wait; don’t wipe UI |
| **D — No peers / no officers** | Cache or empty shelves; honest chip | Standing may still accrue | Quiet empty ≠ “broken” | Social availability ≠ transport failure |
| **E — Peers without addon** | Blessed ranks only | Normal | Normal | Guild-chat spectacle covers non-installers |

**Compound priority (from track 41):** unguilded → not Officer+ → sync pending → empty content. Never label a quiet empty queue as “sync failed.”

---

## 5. Member path vs Officer+ path

Onboarding is **role-gated with the same check as the tab**, not a separate tutorial tree.

```text
                    /beef or minimap
                            │
                            ▼
                     ┌─────────────┐
                     │   Ladder    │  ← default first open
                     └─────────────┘
                            │
              ┌─────────────┴─────────────┐
              ▼                           ▼
       My Standing                  Officer tab?
       (all guilded)                only if Officer+
              │                           │
              ▼                           ▼
     Loop: earn standing          Zones A–D (queue /
     see next threshold           evidence / rites /
     wait for bless               recent actions)
```

### 5.1 Member first-session goals

1. Find the window (`/beef` / minimap).  
2. See self on Ladder (Fresh Beef highlight).  
3. Read My Standing: 0 + next threshold title (text only — no hero StatusBar in V1).  
4. Understand **one** next verb: share an instance with a guildmate (peer need not run the addon).  
5. Never see Approve / Demote / Prophet chrome.

### 5.2 Officer+ first-session goals

Everything in §5.1, plus:

1. Officer tab visible and openable.  
2. Empty queue is **success-tone** (“No petitions yet…”) while **rites stay visible** (demote / Council / Prophet must not vanish) — [69 empty-states-ia](../wow-classic-addon-design/69-officer-tab-ia/empty-states-ia.md).  
3. Announce checkbox present, procedural label, **default ON** (spec §10).  
4. Nuclear actions confirm via StaticPopup; Approve/Reject do not.  
5. Soft teach: suggestions appear when members cross thresholds — officers bless; guild chat carries spectacle.

### 5.3 Help copy split

| Audience | Teach | Hide |
|----------|-------|------|
| Member | Earn standing → petition → officer bless → `/g` line | Wire types, revision numbers, rites |
| Officer | Queue → evidence → Approve; announce opt-out; nuclear confirms | Member “how do I get points” essay on Officer tab |

---

## 6. Progressive disclosure (V1 budget)

Disclose in **layers of need**, not pages of a wizard.

| Layer | When revealed | Surfaces |
|-------|---------------|----------|
| **L0 Discover** | Install | Minimap icon, `/beef`, AddOns list name |
| **L1 Product** | First open | Ladder shelves + local highlight |
| **L2 Self** | Tab click or first open secondary glance | My Standing thresholds / empty events |
| **L3 Soft tip** | Once | Chat print or footer tip (`firstRunTipDone`) |
| **L4 Loop toast** | First suggestion / first approve | Toast copy teaches officer step |
| **L5 Officer tools** | Officer+ only | Pending queue; announce checkbox |
| **L6 Nuclear rites** | Officer+ + intentional action | Demote / Council / Prophet + modal |
| **L7 Settings** | Rare | Minimap hide (± toast mute if playtest demands) — never hero |

### Ace-shaped techniques without Ace

Mirror AceConfig progressive disclosure even in plain frames ([reducing overwhelm](../wow-classic-addon-design/11-onboarding-settings-ux/reducing-configuration-overwhelm.md)):

- `hidden` / role gate → Officer tab  
- `confirm` → nuclear rites  
- `order` by frequency → Ladder before Standing before Officer  
- Separate **product UI** from **prefs** — ladder never lives inside an options tree  

### Disclosure anti-patterns

| Anti-pattern | Why it hurts Beef |
|--------------|-------------------|
| First-run wall of checkboxes | Kills guild-night vibe |
| Scoring-weight sliders in V1 | Canon lives in `Data/Ranks.lua` |
| Showing Officer chrome disabled for members | Looks broken; hide instead |
| Teaching `RANK_COMMIT` in UI | Internal wire name ≠ player language |
| Nag “install the addon” every open | Spec relies on guild-chat spectacle for non-addon peers |

---

## 7. Agent implementation rules

1. **Read before CreateFrame:** [`ui-polished-direction-for-agents.md`](../../superpowers/ui-polished-direction-for-agents.md) + spec §10.  
2. **Empty = structured:** seven rank rows always; banner/chip carries honesty.  
3. **UI never awards points;** onboarding copy must not imply auto-promote.  
4. **Reuse track 41 / 32 copy** — do not invent a third microcopy dialect in polish PRs.  
5. **One soft tip max** per character until dismissed; never re-show after `firstRunTipDone`.  
6. **Smart-skip tip** if standing > 0 or any committed ladder row exists (GRIP-style “experienced user” guard).  
7. **Combat:** opening `/beef` must remain safe (ordinary frames); do not gate first open behind combat.  
8. **Research ≠ law:** if this brief conflicts with spec §15 / glossary, update the decisions log — do not silently ship the research fork.

---

## 8. First-session script (agents implement + test)

Use this as the acceptance script for onboarding polish. Offline harness cannot cover it — run on TBC Classic Anniversary (`## Interface: 20506`) with `/console scriptErrors 1` (prefer BugGrabber + BugSack). Install via [church-of-beef-dev skill](../../../.cursor/skills/church-of-beef-dev/SKILL.md).

### 8.1 Preconditions

```bash
# From Beef_Addon workspace root
./scripts/run-tests.sh   # or: cd .worktrees/feat-church-of-beef-v1 && lua tests/run.lua
# Install addon/ChurchOfBeef → $WOW_ADDONS_DIR/ChurchOfBeef
```

| Client | Role | Guild |
|--------|------|-------|
| A | Member (non-Officer+) | In Beef guild |
| B | Officer+ | Same guild |
| C | Optional | **No guild** (unguilded smoke) |

Fresh character WTF preferred for true first-open (do **not** delete player `WTF/**/ChurchOfBeefDB.lua` without explicit ask — use a throwaway alt).

### 8.2 Member path (Client A) — ~5 minutes

| Step | Action | Pass criteria |
|------|--------|---------------|
| M0 | Login → AddOns list | **Church of Beef** present; Interface 20506 |
| M1 | `/beef` | Real movable frame; default **Ladder**; seven ranks visible |
| M2 | Inspect Ladder | Local highlight Fresh Beef (or canon title); no fake names |
| M3 | Empty / quiet banner | On-brand empty copy (not “No data”); next step mentions guildmate instance |
| M4 | My Standing tab | Standing 0 + next threshold **text**; events empty line OK |
| M5 | Officer tab | **Not visible** |
| M6 | Minimap click | Toggles same frame |
| M7 | `/beef` again | Toggles closed/open; no Lua error |
| M8 | Optional tip | At most one first-run tip; survives dismiss; gone after `/reload` |
| M9 | `/reload` | Frame position persists; tip does not re-spam |
| M10 | Combat open | `/beef` still opens (no soft-lock) |

### 8.3 Unguilded path (Client C) — ~2 minutes

| Step | Action | Pass criteria |
|------|--------|---------------|
| U1 | `/beef` | Frame opens; not-in-guild empty (preview shelves OK) |
| U2 | Standing | Scoring paused copy |
| U3 | Net | No BeefNet send spam / no errors |
| U4 | Officer | Hidden |

### 8.4 Officer+ path (Client B) — ~5 minutes

| Step | Action | Pass criteria |
|------|--------|---------------|
| O1 | `/beef` | Ladder first (same L0–L2 as member) |
| O2 | Officer tab visible | Opens; zones present per Task 9 / track 69 |
| O3 | Empty queue | Success-tone empty; **rites chrome still shown** |
| O4 | Announce checkbox | Label procedural; default **checked** |
| O5 | Approve path (if test data) | Approve needs no modal; demote/Prophet need StaticPopup |
| O6 | Member check | On Client A after B blesses: ladder updates (BeefNet) — two-client gate |

### 8.5 Progressive disclosure spot-checks

| Check | Pass |
|-------|------|
| No settings wall on first open | Prefs not hero |
| No wire jargon in UI | No `RANK_COMMIT` / `SYNC_STATE` in player chrome |
| Toast teach (when first suggestion fires) | Mentions officers / Officer tab — not internal types |
| Footer | ≤ one line; brand or loop — not a checkbox list |

### 8.6 Agent “done” for onboarding polish

Mark onboarding UX done only when:

- [ ] §8.2 M0–M10 green on Anniversary  
- [ ] §8.3 U1–U4 green  
- [ ] §8.4 O1–O4 green (O5–O6 when Commit/BeefNet ready)  
- [ ] BugSack empty through the script  
- [ ] Copy aligned with track 41 / 32 (no freelance voice)  
- [ ] Spec §13 items 2–3 still true on a **fresh** install (no prior SV)

Guild-night spectacle (spec §13.11) remains a **human product pass** — not claimed done by this script alone.

---

## 9. Suggested `/beef help` card (content only)

```text
Church of Beef
  /beef            Open the ladder
  /beef help       This message
Minimap button toggles the same window.
Standing rises from shared instances, Gora, and ceremonies.
Promotions need Officer approval — then guild chat hears it.
```

---

## 10. Open questions (do not block V1)

1. Soft tip = chat print, footer banner, or neither until playtest?  
2. Right-click minimap → Help vs future Settings?  
3. When (if ever) Bliz Interface Options for announce discoverability on alts?  

Log answers in spec §15 / glossary if product locks change.

---

## 11. Sources

### In-repo

- [11-onboarding-settings-ux](../wow-classic-addon-design/11-onboarding-settings-ux/) — first-run, tutorials, overwhelm, CoB relevance  
- [41-empty-states-degraded-ux/beef-copy-ux-map.md](../wow-classic-addon-design/41-empty-states-degraded-ux/beef-copy-ux-map.md) — scenario copy  
- [69-officer-tab-ia](../wow-classic-addon-design/69-officer-tab-ia/) — officer empty + zones  
- [00-church-of-beef-implications.md](../wow-classic-addon-design/00-church-of-beef-implications.md) — first `/beef` shows Ladder + Standing  
- [Design spec §10–§13](../../superpowers/specs/2026-07-25-church-of-beef-design.md)  
- [UI direction for agents](../../superpowers/ui-polished-direction-for-agents.md)  
- [v1-checklist.md](../../phases/v1-checklist.md)

### External

- [UserOnboard — Empty States](https://www.useronboard.com/onboarding-ux-patterns/empty-states/) — educate / CTA / personality; two parts instruction, one part delight  
- [GRIP — WoWInterface](https://www.wowinterface.com/downloads/info27072-GRIP-GuildRecruitmentAutomation.html) — dismissible onboarding + smart-dismiss  
- [GRIP README](https://github.com/JesperLive/GRIP) — `/grip` + minimap quick start  
- [ImprovedGuildWindow](https://github.com/totalllyswede/ImprovedGuildWindow) — slash → real guild window pattern  
- [Questie README](https://github.com/Questie/Questie) — slash + minimap discoverability  
- [Ace3 for Dummies](https://warcraft.wiki.gg/wiki/Ace3_for_Dummies) — empty slash → GUI convention  
- [AceConfig Options Tables](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables) — progressive disclosure primitives  

### Sibling polish-vision notes

- [20-empty-states-disclosure.md](20-empty-states-disclosure.md) — state machine / sync honesty (detail)  
- [05-minimap-ldb-patterns.md](05-minimap-ldb-patterns.md) — launcher UX  
- [07-chat-spectacle-ux.md](07-chat-spectacle-ux.md) — post-onboarding spectacle  
- [08-savedvars-settings-ux.md](08-savedvars-settings-ux.md) — `firstRunTipDone` / never nuke WTF  

---

## 12. One-line doctrine

**Open the Church empty but honest; teach the loop in the ladder; gate the rites — never onboard into a settings cathedral.**
