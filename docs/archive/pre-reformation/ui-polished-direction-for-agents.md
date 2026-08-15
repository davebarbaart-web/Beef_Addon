# UI / art direction — agent briefing

**Audience:** Coding agents implementing Church of Beef UI (and later art).  
**Not humans-only theater** — this pack exists so agents execute without re-litigating visual policy.  
**Last locked:** 2026-07-25 (polish decision cards → design spec §10 / §15 · glossary 74–81).  
**Juice / critique vocabulary (thin promote):** 2026-07-26 — from `docs/research/agent-polish-vision/` ([`00-SYNTHESIS.md`](../research/agent-polish-vision/00-SYNTHESIS.md)); research ≠ product law.

## Authority order (do not invert)

1. **Product law** — `docs/superpowers/specs/2026-07-25-church-of-beef-design.md` (§10 UI, §15 decisions)
2. **Implementer locks** — `docs/research/wow-classic-addon-design/74-v1-decision-glossary/locked-v1-decisions.md` (esp. rows 68–71, **74–81**)
3. **Machine canon** — `addon/ChurchOfBeef/Data/Ranks.lua` (titles/thresholds; never invent numbers in UI/art)
4. **This brief + Cursor canvases** — orientation and build checklist (below)
5. **Research tracks** — depth when disputed; scrapes (`.firecrawl/`, `**/.raw/`) are **not** product truth

If a canvas and the spec disagree, **spec wins**. Update the spec decisions log — do not silently fork policy in UI Lua.

**Constitution (roster-backed, §15 Accept 2026-07-26):** Church titles mirror the live guild roster. Standing creates promote **suggestions**; officers promote in Blizzard’s guild UI. Guild-chat promote announce is **deferred**. T0 = edge toast / officer queue only. ADR-0006 is superseded.

## Doctrine (one line)

*Classic Blizzard shell for process UI; brand in words (guild chat + private toasts); custom gothic/heraldry only after V1 earns it.*

## Agent read order before any UI `CreateFrame`

| Step | Read | Why |
|------|------|-----|
| 1 | This file | Map + bans + juice vocabulary |
| 2 | Spec §10 + §15 rows for announce/settings/Standing/Streamer/hex/SFX | Law |
| 3 | Glossary 68–71, 74–81 | Normative checklist |
| 4 | Cursor canvas **cob-v1-ui-build-prep** (build bible) | Templates, frame tree, motion, copy IDs, QA |
| 5 | Cursor canvas **cob-polished-ui-north-star** (orientation) | Phases, anti-patterns, links |
| 6 | Plan Task 7+ in `docs/superpowers/plans/2026-07-25-church-of-beef-v1.md` | File layout / sequencing |
| 7 | Rules: `addon-module-layers`, `wow-ui-taint-lockdown`, `wow-performance`, `packaging-assets` | Hard constraints |
| 8 | Skill § Polish loop in `.cursor/skills/church-of-beef-dev/SKILL.md` | Verify → critique → capped revise |

**Optional depth (only if needed):** tracks `02-visual-language`, `32-microcopy-tone-voice`, `69-officer-tab-ia`, `70-standing-breakdown-ui`, `43-ui-scale-pixel-perfection`, `17-stream-overlay-readability`. Research juice depth: [42](../research/agent-polish-vision/42-v1-vs-v2-juice-scope.md) · [30](../research/agent-polish-vision/30-writing-effective-agent-goals.md) · [29](../research/agent-polish-vision/29-superpowers-loop-patterns.md) · [49](../research/agent-polish-vision/49-adversarial-overengineering.md) · [50](../research/agent-polish-vision/50-adversarial-tos-safety.md) · [51](../research/agent-polish-vision/51-adversarial-performance-vs-juice.md).

**Art / Media agents (post-V1 only):** canvas **cob-post-v1-art-commission** + track `44-custom-textures-media-packaging`. Do **not** commission or add `Media/` during Task 7–10.

## Cursor canvases (IDE beside chat)

These live under the Cursor project `canvases/` folder (not always inside the git tree). Open beside chat when present:

| Canvas | Role |
|--------|------|
| `cob-polished-ui-north-star.canvas.tsx` | Orientation / phases / bans / index |
| `cob-v1-ui-build-prep.canvas.tsx` | **Primary implementer checklist** |
| `cob-post-v1-art-commission.canvas.tsx` | Artist handoff (later) |
| `cob-polish-decision-cards.canvas.tsx` | Logged recommendations (historical) |
| `visual-polish-acceptance-checklist.canvas.tsx` | In-client QA gate |

If a canvas is missing from the environment, follow **this brief + spec §10/§15 + glossary** — do not invent a third UI religion.

## V1 non-negotiables (agent checklist)

- Lua `CreateFrame` primary; inherit Classic FrameXML templates (`BasicFrameTemplate`, `UIPanelButtonTemplate`, `BackdropTemplate`, …)
- Tabs: Ladder / My Standing / Officer+ only; UI → Core → Data; **UI never awards points**
- Opaque high-contrast panels; GameFont*; class color on **names** only; dual-encode pending / eligible / dismiss
- Spectacle (roster-backed V1): private edge toast + officer queue + Ladder move after guild-UI promote; `/g` announce **deferred**; **no** center-screen WA pulses
- Settings: position + minimap hide; announce control dormant until roster-diff announcer
- Standing: **text thresholds** only (no hero StatusBar)
- Silent (no SFX); no custom Media required; missing media must not fail load
- Guest on player `uiScale` — never set `uiScale` / `UIParent:SetScale`
- No AceAddon, Masque, SharedMedia hard deps; no SecureActionButton “to open a panel”; no tip jars
- No Streamer Mode code in V1 (coexistence note OK)

## Juice hierarchy (spend from the top)

1. **Ladder honesty** — roster bands move when officers promote in the Blizzard guild UI
2. **Private edge toast** — addon users; queue-capped; non-modal; must not steal combat clicks
3. **In-panel feedback** — officer queue copy (“promote in the guild roster”), dual-encode
4. **Short motion** — alpha/offset on Beef frames only; self-clearing
5. **Guild chat** — deferred until a roster-diff announcer (not V1 playtest law)
6. **SFX** — post-V1, default off
7. **Custom art** — post-V1 art pass

If a promote suggestion is fulfilled in the guild UI and the Ladder does not move, polish has failed social criterion §13.11 even if toasts look great.

## Celebration tiers (V1)

| Tier | Alias | Triggers | Channels | V1? |
|------|-------|----------|----------|-----|
| **T0** Private | Small | Suggestion; Gora/ceremony credit | Edge toast only | YES |
| **T1** Social | Medium | Guild-UI promote (Ladder move); future roster-diff `/g` | Toast + Ladder; `/g` deferred | PARTIAL |
| **T2+** / Epic | Epic / theater | Dashboards, SFX stacks, center theater | Beyond V1 budget | NO (park) |

**Caps:** coalesce concurrent toasts; toast mute only if guild-night proves noise.  
**Scarce seats (Council/Prophet):** stronger copy when shown from roster map — never unlocks T2+/Epic or center pulses.

## Announce / ToS corridor (V1)

Roster-backed path (ADR-0006 superseded by §15 Accept):

- Guild-chat promote announce is **deferred** — do not ship a dead “Announce promotions” control that claims to work
- No multi-line liturgy; no announce on suggestion, score grant, or login sync
- No peer echo of legacy `RANK_COMMIT` / sync as if it changed ranks
- No auto-congrats bots, tip jars, RAID_WARNING SFX, Secure* panel openers, or center WA pulses
- Mute-by-type within settings law = coalesce + (post-playtest) toast mute only

## Motion / perf budget

| Allowed | Forbidden |
|---------|-----------|
| Show/Hide + short alpha; brief self-clearing `AnimationGroup` / `C_Timer` on Beef frames | Permanent `OnUpdate` for juice / scoring / net |
| Small toast slide/offset; enter timing **provisional** (~160–300 ms) until client smoke | UIParent shake, full-screen flash, particles, ModelFrame ceremonies |
| Local row highlight; optional one-shot title scale (**frame-local** — never `uiScale`) | Idle breathing glow; forever row/minimap animators; tab crossfade of whole shell |
| Coalesce bursts; dirty-flag paint when panel open; no full ladder rebuild per toast/message | Paint-per-`CHAT_MSG_ADDON`; combat-fovea center modality |

Idle panels stay quiet — no forever animators when `/beef` is closed.

## Settings budget (restated)

| Pref | V1 |
|------|-----|
| Frame position | Always |
| Minimap show/hide | Yes (plain hideable button; do not add Ace/LDB hard deps for polish) |
| Announce opt-out | Hidden / dormant until roster-diff announcer |
| Toast mute | Only if guild-night proves noise |
| Per-event announce filters / `uiScale` | Out |

## Critique checklist (before claiming UI polish)

1. Does the Ladder move when an officer promotes in the guild UI (peers need not run the addon)?
2. Does chrome still read as Blizzard if custom tint fails?
3. Can an officer open `/beef` and Dismiss / correct standing in combat without taint pain?
4. Are promote prompts honest (“guild roster”) with announce still deferred/hidden?

**Stop caps:** max **2** critique→revise rounds; role budget **1** implementer + **0–1** critic; no UI swarm. Harness green ≠ spectacle PASS.

## Done for UI polish

| Label | Who | Meaning |
|-------|-----|---------|
| **POLISH:CANDIDATE** | Agent | In-game smoke for touched path + critique clean enough to ask human |
| **POLISH:PASS** | Human only | Signed craft/spectacle for that surface |
| **V1 complete** | Human only | Full dated `docs/phases/v1-checklist.md` walk |

Agents may claim **POLISH:CANDIDATE** only. Never claim “polished/done” or V1 complete from desktop taste.

## Phased execution for agents

| Phase | Agent job | Done means |
|-------|-----------|------------|
| **V1 UI (Task 7+)** | Implement against build-prep + this brief | `/beef` works; smoke + critique CANDIDATE; no custom art |
| **V1.1** | Streamer SV preset shape (pick mask vs quieter vs both); never kill guild announce | Spec amendment + code |
| **Art / spectacle pass** | Commission package → TGA PoT → `Media/` with fallbacks; optional SFX default off | Shell still Classic; seals/toast/minimap only |

## Anti-patterns (reject in review)

WA center pulses for social · Details!-dense rosters · item-quality rainbow for ranks · ElvUI-flat as brand · glass/low-alpha panels · SecureActionButton for panels · in-game donation CTAs · standing-as-HP/castbar · Retail-only templates without Anniversary verify · forking thresholds into copy/art docs · juice OS / tween bus / intensity matrices · Media/SFX in Task 7–10 · peer `/g` echo · multi-line announce liturgy · permanent OnUpdate animators · claiming polish PASS without `/reload` smoke

## When stuck

1. Spec §15 / glossary row — already locked?  
2. Build-prep canvas — concrete template/copy ID?  
3. Research track — deepen, then **log** any new product choice in spec §15 (do not leave it only in a PR).  
4. In-client Anniversary smoke — visual truth beats desktop speculation.  
5. Polish loop — Goal → verify → critique → stop (skill §); escalate product ambiguity, do not invent.
