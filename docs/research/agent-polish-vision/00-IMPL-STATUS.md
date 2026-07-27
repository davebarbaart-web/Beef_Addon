# 00-IMPL-STATUS — Addon UI surfaces (reconcile)

**Date:** 2026-07-26  
**Checkout:** `/Volumes/AI_Design_Drive/Beef_Addon` → `addon/ChurchOfBeef/`  
(`.worktrees/feat-church-of-beef-v1/` is empty / unused for this pass.)  
**Harness:** `./scripts/run-tests.sh` → **1001+ passed, 0 failed** (exit 0)  
**TOC:** `## Interface: 20506`; all listed files exist; load order Data→Core→Net→UI→bootstrap.

> Research ≠ product law. Agents may claim **POLISH:CANDIDATE** only.  
> Do **not** claim V1 complete from this note.

---

## Parallel merge reconciled

| Surface | Files | Shipped |
|---------|-------|---------|
| Edge toasts | `UI/Toasts.lua`, callers in Net/Officer/Standing | `Push` / `Celebrate(kind, fields)` envelope queue; priority + interrupt + dedupe; `Show(text)` back-compat; AnimationGroup when real, else `C_Timer` alpha; **rawget** for `cobFadeIn`/`cobFadeOut`/`cobSnapOut` (stub `__index` noops must not look Play()-able); **`EnableMouse(false)` for lifetime** — Classic Translation/Scale hit-test ≠ paint ([56](56-wow-animationgroup-classic.md)); no buttons on toast |
| Sync status chip | `UI/Status.lua` (new), `Net/Sync.lua`, `UI/MainFrame.lua`, `UI/LadderTab.lua` | L0 chip on MainFrame; Sync `GetStatus()` read-only signals; Ladder L1 learning banner for `no_peers` only |
| Officer Commit juice | `UI/OfficerTab.lua` | Anticipation preview, commit-busy, Recognized toast after Core Commit, soft reject, error without celebrate |
| Standing credits | `UI/StandingTab.lua` | `Celebrate("credit", …)` for Gora/ceremony display only |
| Minimap / shell | `UI/Minimap.lua`, `UI/MainFrame.lua` | Hideable button + `/beef` shell; StatusChip footer wire |
| Tests | `tests/test_ui.lua`, `tests/test_officer_ui.lua` | Toast priority/dedupe; Status chip states; Officer Recognized copy; cobFadeIn stub regression |

---

## Conflict that looked like a red harness

Ladder agent saw `cobFadeIn` failures while Toast agent reported green. Cause: `wow_ui_stub` `__index` caches a **truthy noop function** for unknown keys. Mid-flight Toasts code that did `frame.cobFadeIn:Play()` treated that noop as an AnimationGroup. Toast path now uses `rawget` + table checks only; regression covered in `test_ui.lua`.

---

## Not done (human / client)

- In-game `/reload` smoke for `/beef`, Commit → `/g` + recipient toast  
- Two-client BeefNet / officer gate  
- **POLISH:PASS** and V1 checklist walk — human only  
See [00-PROMOTE-STATUS.md](00-PROMOTE-STATUS.md) playtest gates H0–H5.
