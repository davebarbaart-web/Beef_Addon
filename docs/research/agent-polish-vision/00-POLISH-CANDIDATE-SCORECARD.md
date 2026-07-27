# 00-POLISH-CANDIDATE-SCORECARD — Shipped UI (agent critique)

**Label:** **POLISH:CANDIDATE** only  
**Date:** 2026-07-26  
**Author / agent:** polish-critique (desktop)  
**Client smoke:** **no** (blocked — Anniversary `/reload` not run this pass)  
**Checkout:** `/Volumes/AI_Design_Drive/Beef_Addon` → `addon/ChurchOfBeef/UI/`  
**Surfaces:** MainFrame · Ladder · Standing · Officer · Toasts · Minimap · Status  
**Rubric:** [`25-ui-polish-critique-rubric.md`](25-ui-polish-critique-rubric.md)  
**Impl reconcile:** [`00-IMPL-STATUS.md`](00-IMPL-STATUS.md)  
**Doctrine:** Classic shell; brand in words; agents never claim **POLISH:PASS** or V1 complete.

> Research ≠ product law. Spec §10/§15 + [`ui-polished-direction-for-agents.md`](../../superpowers/ui-polished-direction-for-agents.md) win on conflict.  
> This card is a critique artifact for human playtest — not a PASS.

---

## Scorecard

```text
COB UI critique — all V1 product surfaces
Author / agent: polish-critique    Client smoke: no    Date: 2026-07-26

1 Hierarchy ............. 4/5   Evidence: Standing title hero → standing → text next-threshold
                                 (StandingTab.lua); Officer Approve primary + anticipation
                                 preview; nuclear rites spaced from Approve; Ladder bands
                                 title-first; scripture footer garnish only.
2 Spacing ............... 4/5   Evidence: MainFrame 12px content inset + SetClampedToScreen;
                                 toast now 360×72 TOP@-160 with wrap + UI_SCALE_CHANGED
                                 re-anchor (Toasts.lua). Officer RECENT_ROWS=2 documents
                                 density at default 360h — still a nit.
3 Juice ................. 4/5   Evidence: T1 = Announce:Promotion + Celebrate("promote");
                                 queue priority/dedupe/coalesce MAX_QUEUE=5; silent V1;
                                 short AnimationGroup / C_Timer; commit-busy. Credit
                                 combat defer stubbed OFF (intentional). Dwells provisional.
4 Lore fit .............. 5/5   Evidence: Titles via COB.Ranks.Title; thresholds from Core
                                 suggestion / Ranks.Threshold (never forked in UI strings);
                                 announce checkbox "Announce promotions to guild chat";
                                 liturgy in Announce.lua; no tip jar / Media brand.
5 Classic authenticity .. 4/5   Evidence: BasicFrameTemplate shell; UIPanelButtonTemplate;
                                 GameFont*; opaque toast backdrop; Interface 20506; no
                                 Ace/Masque/SharedMedia. Mild custom confirm Backdrop +
                                 tab-as-button (not PanelTabs) — Anniversary-safe.
6 Performance ........... 5/5   Evidence: MarkDirty/_RefreshActive only when shown;
                                 toast OnUpdate one-shot then nil; Status C_Timer holds;
                                 fixed Ladder/Officer row pools; no permanent juice OnUpdate.
7 Accessibility ......... 4/5   Evidence: Approve/Reject text labels (+ Approve: Title);
                                 Pending ">" + gold; You word+gold; petition pip+border;
                                 own confirm for demote/Council/Prophet/wipe; Officer tab
                                 officerOnly. Minimap hide = SetShown /run only (nit).
8 Taint safety .......... 5/5   Evidence: Insecure CreateFrame under UIParent; :Show/:Hide
                                 (not ShowUIPanel); no SecureActionButton; steppers instead
                                 of UIDropDownMenu; own confirm child (no StaticPopup);
                                 CloseButton HookScript.

Total ................... 35/40
Mean .................... 4.4
Hard fails .............. none
Verdict ................. polish-ready (desktop) — still requires H1–H3 human smoke
Top fixes ............... see § Follow-ups
```

### Machine sidecar

```text
decision: pass
label: POLISH:CANDIDATE
blockers: []
soft_blockers: [H1-client-smoke, H2-two-client, H3-spectacle]
top_fixes: ≤5 (below)
client_smoke: no
mean: 4.4
total: 35/40
```

---

## Hard fails scanned

| Hard fail (rubric) | Result |
|--------------------|--------|
| UI grants points / invents ranks | **Clear** — tabs call Core; titles from `Ranks.lua` |
| Center-screen WA / social pulse | **Clear** — edge toast TOP only |
| Tip jar / donate CTA | **Clear** |
| `uiScale` / `UIParent:SetScale` | **Clear** |
| `SecureActionButton` / ShowUIPanel for panel | **Clear** |
| Color-only Approve/Reject/Pending | **Clear** — text (+ preview) dual-encode |
| No confirm on demote/Prophet/Council | **Clear** — `OfficerTab:_Confirm` |
| Permanent business `OnUpdate` | **Clear** — idle scripts nil'd |
| Standing as StatusBar / HP metaphor | **Clear** — text thresholds |
| Retail-only APIs / Media required to load | **Clear** — TOC `20506`; stock textures |

---

## Blockers vs nits

### Blockers (block human **POLISH:PASS** / spectacle claims — not code hard fails)

| ID | Item | Why |
|----|------|-----|
| **H1** | Single-client `/reload` smoke | Visual scores + toast dwells are desktop-provisional (F12) |
| **H2** | Two-client Commit / BeefNet | Officer gate + peer rank appearance unproven in-client |
| **H3** | Spectacle craft | One officer `/g` + recipient toast — harness cannot prove |

No **code** hard-fail blockers remain after toast geometry easy-win (this pass).

### Nits (debt — do not block CANDIDATE)

| # | Nit | Where |
|---|-----|--------|
| N1 | Officer panel dense at default 480×360 (Recent = 2 rows by design) | `OfficerTab.lua` |
| N2 | Minimap angle SV exists; drag-along-ring not wired | `Minimap.lua` |
| N3 | Minimap hide only via `ChurchOfBeef.Minimap:SetShown(false)` / README — no in-panel toggle | settings budget starved (intentional) |
| N4 | Credit `deferInCombat` hook documented but OFF for V1 | `Toasts.lua` |
| N5 | Tab chrome = `UIPanelButtonTemplate` row, not Classic PanelTabs | `MainFrame.lua` |
| N6 | Exact toast enter/hold ms still need Anniversary eye | F12 / H1 |

---

## Follow-ups (≤5) — this pass

| # | Fix | Action taken |
|---|-----|--------------|
| 1 | Toast plate height/wrap to rubric band (280–360 × 64–96) + scale re-anchor | **Done** — `Toasts.lua` → 360×72, word-wrap, `UI_SCALE_CHANGED` / `DISPLAY_SIZE_CHANGED` |
| 2 | Human **H1** smoke script (below) | **Document** — agent cannot run Anniversary client |
| 3 | Human **H2** two-client Commit | **Document** |
| 4 | Human **H3** spectacle (`/g` + toast) | **Document** |
| 5 | Optional later: minimap ring drag persist `ui.minimapAngle` | **Document only** (~30–45 min; not required for CANDIDATE) |

No further code revises this round (stop cap: easy wins only; no UI swarm).

---

## Human smoke script (H1 / H2 / H3)

Pointers: [`00-PROMOTE-STATUS.md`](00-PROMOTE-STATUS.md) · [`32-human-checkpoint-handoff.md`](32-human-checkpoint-handoff.md) · skill § install/reload.

### Preflight (agent-owned — already green per IMPL-STATUS)

- [x] Offline harness preferred green (`./scripts/run-tests.sh` / `lua tests/run.lua`)
- [x] TOC `## Interface: 20506`; listed files exist
- [x] Installable unit: `addon/ChurchOfBeef/` → `Interface/AddOns/ChurchOfBeef/`

### H1 — Single-client smoke (~15 min)

```
1. /console scriptErrors 1
2. Install / update ChurchOfBeef → /reload
3. /beef — frame opens (Ladder default); Esc / close hides; drag + reload restores position
4. Tabs: Ladder bands + Your title footer; My Standing title/standing/next text (no bar);
   Officer visible only if Officer+
5. Minimap: hover glance (title · standing · next); left-click toggles; optional
   /run ChurchOfBeef.Minimap:SetShown(false) then /beef still works
6. Combat: open/close /beef mid-trash — no taint errors; bags/character pane still work
7. Standing: Record Gora (if peer available) or Start/Close Ceremony (officer) —
   credit toast TOP edge, not center; BugSack clean
8. Footer idle = "Eternal Grazing."; sync chip may briefly replace it
```

**Pass H1:** no script errors; process UI readable; toast edge-only.  
**Fail H1:** load error, combat toggle broken, StatusBar/center pulse, unreadable glass.

### H2 — Two-client net (~30–45 min)

```
Clients: Officer+ A + Member B (same guild), both with addon.
1. B earns / has pending petition (or officer-facing suggestion on A)
2. A: Officer tab → select petition → Approve: <title> → Commit
3. B: rank updates (BeefNet / sync); forged / non-officer commit ignored
4. A announce checkbox ON → one /g line; opt-out → Commit still works, no /g
5. Officer tab hidden on B if not Officer+
```

**Pass H2:** peer rank correct; forged ignored; announce opt-out = chat only.  
**Fail H2:** peer invents rank; double `/g`; member sees Officer rites that stick.

### H3 — Spectacle craft (short guild moment)

```
1. Real promote (or demote) with announce ON
2. Guild chat: exactly one officer-origin line
   ("The Church recognizes …" / demote/council/prophet liturgy)
3. Recipient (addon): private edge toast; non-addon members still see /g
4. No multi-line liturgy, no peer echo, no center flash, no SFX
```

**Pass H3:** chat + toast corridor honored (craft sign-off still human).  
**Fail H3:** spam, silent promote with announce ON, WA-style center pulse.

### After human signs

- Per-surface **POLISH:PASS** = human only  
- V1 complete = dated [`docs/phases/v1-checklist.md`](../../phases/v1-checklist.md) walk (**H5**) — not this card

---

## Critique checklist (brief)

| # | Question | Desktop answer |
|---|----------|----------------|
| 1 | Member without addon notices promote? | **Yes if announce ON** — `Announce.lua` guild line |
| 2 | Chrome still Blizzard if tint fails? | **Yes** — BasicFrameTemplate + stock fonts/textures |
| 3 | Officer Approve in combat without taint? | **Designed yes** — insecure frames; **needs H1** |
| 4 | Announce one throttled line + SV opt-out? | **Yes in code** — throttle + `ui.announce`; **needs H2/H3** |

---

## Changelog

| Date | Note |
|------|------|
| 2026-07-26 | Initial POLISH:CANDIDATE scorecard; toast 72px easy-win applied; mean **4.4** (35/40) |
