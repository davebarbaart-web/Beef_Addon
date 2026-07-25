# UI / art direction — agent briefing

**Audience:** Coding agents implementing Church of Beef UI (and later art).  
**Not humans-only theater** — this pack exists so agents execute without re-litigating visual policy.  
**Last locked:** 2026-07-25 (polish decision cards → design spec §10 / §15 · glossary 74–81).

## Authority order (do not invert)

1. **Product law** — `docs/superpowers/specs/2026-07-25-church-of-beef-design.md` (§10 UI, §15 decisions)
2. **Implementer locks** — `docs/research/wow-classic-addon-design/74-v1-decision-glossary/locked-v1-decisions.md` (esp. rows 68–71, **74–81**)
3. **Machine canon** — `addon/ChurchOfBeef/Data/Ranks.lua` (titles/thresholds; never invent numbers in UI/art)
4. **This brief + Cursor canvases** — orientation and build checklist (below)
5. **Research tracks** — depth when disputed; scrapes (`.firecrawl/`, `**/.raw/`) are **not** product truth

If a canvas and the spec disagree, **spec wins**. Update the spec decisions log — do not silently fork policy in UI Lua.

## Doctrine (one line)

*Classic Blizzard shell for process UI; brand in words (guild chat + private toasts); custom gothic/heraldry only after V1 earns it.*

## Agent read order before any UI `CreateFrame`

| Step | Read | Why |
|------|------|-----|
| 1 | This file | Map + bans |
| 2 | Spec §10 + §15 rows for announce/settings/Standing/Streamer/hex/SFX | Law |
| 3 | Glossary 68–71, 74–81 | Normative checklist |
| 4 | Cursor canvas **cob-v1-ui-build-prep** (build bible) | Templates, frame tree, motion, copy IDs, QA |
| 5 | Cursor canvas **cob-polished-ui-north-star** (orientation) | Phases, anti-patterns, links |
| 6 | Plan Task 7+ in `docs/superpowers/plans/2026-07-25-church-of-beef-v1.md` | File layout / sequencing |
| 7 | Rules: `addon-module-layers`, `wow-ui-taint-lockdown`, `wow-performance`, `packaging-assets` | Hard constraints |

**Optional depth (only if needed):** tracks `02-visual-language`, `32-microcopy-tone-voice`, `69-officer-tab-ia`, `70-standing-breakdown-ui`, `43-ui-scale-pixel-perfection`, `17-stream-overlay-readability`.

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
- Opaque high-contrast panels; GameFont*; class color on **names** only; dual-encode pending/approve/reject
- Spectacle: throttled `/g` line (officer checkbox, default ON) + private edge toast; **no** center-screen WA pulses
- Settings: position + minimap hide + announce only
- Standing: **text thresholds** only (no hero StatusBar)
- Silent (no SFX); no custom Media required; missing media must not fail load
- Guest on player `uiScale` — never set `uiScale` / `UIParent:SetScale`
- No AceAddon, Masque, SharedMedia hard deps; no SecureActionButton “to open a panel”; no tip jars
- No Streamer Mode code in V1 (coexistence note OK)

## Phased execution for agents

| Phase | Agent job | Done means |
|-------|-----------|------------|
| **V1 UI (Task 7+)** | Implement against build-prep + this brief | `/beef` works; QA checklist; no custom art |
| **V1.1** | Streamer SV preset shape (pick mask vs quieter vs both); never kill guild announce | Spec amendment + code |
| **Art / spectacle pass** | Commission package → TGA PoT → `Media/` with fallbacks; optional SFX default off | Shell still Classic; seals/toast/minimap only |

## Anti-patterns (reject in review)

WA center pulses for social · Details!-dense rosters · item-quality rainbow for ranks · ElvUI-flat as brand · glass/low-alpha panels · SecureActionButton for panels · in-game donation CTAs · standing-as-HP/castbar · Retail-only templates without Anniversary verify · forking thresholds into copy/art docs

## When stuck

1. Spec §15 / glossary row — already locked?  
2. Build-prep canvas — concrete template/copy ID?  
3. Research track — deepen, then **log** any new product choice in spec §15 (do not leave it only in a PR).  
4. In-client Anniversary smoke — visual truth beats desktop speculation.
