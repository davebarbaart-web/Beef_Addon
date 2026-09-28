# Lane T — Theater collapse (UX rebuild)

You are working in `/Volumes/AI_Design_Drive/Beef_Addon`, a WoW TBC Classic Anniversary addon (Lua 5.1, plain global `ChurchOfBeef` / `COB`). Read these first, they are binding:

- `.cursor/rules/ten-laws.mdc`, `.cursor/rules/architecture-overview.mdc`, `.cursor/rules/verification.mdc`
- `.cursor/rules/lua-cob-modules.mdc`, `.cursor/rules/quiet-event-modes.mdc`, `.cursor/rules/ui-juice-standards.mdc`, `.cursor/rules/ceremony-runtime.mdc`, `.cursor/rules/testing.mdc`, `.cursor/rules/toc-lifecycle.mdc`, `.cursor/rules/wow-performance.mdc`
- `.agents/skills/church-of-beef-dev/SKILL.md`

## Where this fits

Lanes W (wire), K (Pope kit), and C (Church card) are done. This lane collapses the event theater to one persistent surface and retires dead scaffolding:

- The **fighter card** becomes a **sanction beat** — an introduction the Pope can dismiss, gone once the ruling lands. The **Fight HUD** is the single persistent Gora surface through the verdict.
- The retired **empty shell** (`UI/MainFrame.lua`) and the **roster status chip** (`UI/Status.lua`) die; the bootstrap owns UI Init.
- The **small-toast engine** (`Toasts:Show` and its queue) has zero callers — it dies. `Toasts:Proclaim` theater stays the one toast engine.
- Two glue gaps found in Lane K review get closed: the Pope's HUD refresh after a verdict, and the Decree banner showing when a Decree is posted.

## Binding contract

### 1. Fighter card = sanction beat (`UI/FighterCard.lua` + glue)

Behavior change is about **when Hide fires**, nothing else:

- Show: unchanged (glue `showFighterCard` on successful Sanction; congregation on inbound STATE carrying two fighters during ASSEMBLY/RITE).
- Hide (new): the card hides when a Gora verdict is recorded. In `ChurchOfBeef.lua` InstallWire, add `hideFighterCard()` (pcall-guarded like its neighbors) to the four verdict wraps (`Gora.DeclareVictor`, `Gora.Void`, `Gora.FreeRuling`, `Gora.CowardiceRecorded`) and to the `Runtime.CloseRite` wrap. EndEvent already hides it — keep.
- Congregation side: in the `_HandleState` glue wrap, hide the card when the inbound STATE's `state` is `"CONSEQUENCE"` in addition to the existing `"QUIET"` hide. RITE-with-fighters still shows.
- ESC dismissal, lastPair-while-shown, persist, and all dress stay exactly as they are. No auto-timer. No new wire fields.

### 2. HUD stays the persistent surface

`UI/Hud.lua` is **not edited** in this lane. It keeps lastPair through the verdict beat and exits at QUIET.

### 3. Retire the shell and the chip

- Delete `addon/ChurchOfBeef/UI/MainFrame.lua` and `addon/ChurchOfBeef/UI/Status.lua`; remove both from `addon/ChurchOfBeef/ChurchOfBeef.toc`.
- `ChurchOfBeef.lua`: replace `COB.UI:Init()` in `OnLogin` with a bootstrap-owned UI init that calls, in this order, each module's `Init` when present (pcall where the old UI:Init used pcall): `Minimap`, `RecordsBook`, `Hud`, `Console`, `Toasts`, `DecreeBanner`, `Sound`, `FighterCard`, `Inputs`, `Markers`. (ConsoleDock is already gone.) No shell frame, no `rememberSpecial` for `ChurchOfBeefFrame`, no roster event registration on a shell, no `ui.shown` reopen-on-login behavior (the SV key stays in DB defaults harmlessly — do not migrate or delete it).
- `/beef` slash: call `COB.RecordsBook:ToggleHome()` directly (guarded; keep the "UI not ready" chat fallback pointing at RecordsBook). `/beef minimap` and `/beef console` unchanged.
- `UI/Minimap.lua`: left-click calls `COB.RecordsBook:ToggleHome()` (guarded) instead of `COB.UI:Toggle()`. Right-click Decree replay unchanged.
- `UI/Decree.lua`: the OPEN CHURCH BOOK button calls `COB.RecordsBook:ToggleHome()` (guarded) instead of `COB.UI:Toggle()`.
- `Net/BeefNet.lua`: remove `NotifyStatus` and its call sites (the status chip it refreshed is gone). Keep `_WarnVersion` exactly as is — the one permitted Quiet notice.
- `UI/Console.lua`: `Console:Show` gains the roster kick the shell used to do — on Show, if `COB.Roster` exists: pcall `AttachLibrary` then `Refresh`; and if not `Roster:IsReady()` and `COB.Net.RequestRoster` exists, pcall `Net:RequestRoster(nil, true)`. Same shape the old `MainFrame` OnShow used. Presence reads Roster; the book does not need this kick.
- End state: **zero** references to `COB.UI` anywhere in `addon/` (grep proves it).

### 4. One toast engine

- `UI/Toasts.lua`: remove the small-toast engine — `Toasts:Show`, its queue/pump, the small `ChurchOfBeefToast` frame, and now-dead helpers. Keep `InitTheater` / `Proclaim` / `HideAll` / the theater beats (sanction, victor, cowardice, knighting, elevation) and their ESC/`UISpecialFrames` behavior byte-for-byte in copy. Keep `Init` (it can InitTheater).
- Rename the suite `tests/test_ui.lua` → `tests/test_toasts.lua` covering the Proclaim theater only; update `tests/run.lua`. Shell/Status pins die with their subjects.

### 5. Glue gap closures (`ChurchOfBeef.lua`)

- **Pope HUD after verdict:** add a pcall-guarded `Hud:Refresh()` to the four verdict wraps (alongside `proclaim`/`sendState`). Deterministic on the Pope client; do not rely on the STATE echo.
- **Decree banner on post:** `wrapAfter(COB.Decree, "Set", ...)` → pcall `COB.DecreeBanner:Show()`. This covers both `Console:PostDecree` and inbound DECREE (`_HandleDecree` → `Decree:Set`). The once-per-login reveal in `DecreeBanner:Init` is unchanged; login restore does not pass through `Set`, so no login double-show. `Decree:Set` returns a non-nil copy on success, so `wrapAfter` fires only on a real set. Clear keeps its existing wrapAlways banner refresh.

## Tests (TDD per suite: change the suite first, watch fail, implement, green)

- `tests/test_fighter_card.lua` — pins for the new Hide triggers (each verdict wrap hides; CloseRite hides; EndEvent still hides; ESC still dismisses; lastPair-while-shown unchanged) — the glue-side pins may live in `test_wire_glue.lua` where the wraps are spied; keep module pins in test_fighter_card.
- `tests/test_wire_glue.lua` — update glue pins: verdict wraps now also Refresh Hud and Hide the card; CloseRite hides the card; inbound STATE CONSEQUENCE hides the card; `Decree:Set` wrap shows the banner on PostDecree and on inbound DECREE; no banner show on login restore; remove any MainFrame/Status/small-toast references.
- `tests/test_toasts.lua` (renamed) — Proclaim theater only.
- `tests/test_minimap.lua` — left-click now drives `RecordsBook:ToggleHome` (spy), right-click unchanged.
- `tests/test_decree_ui.lua` — OPEN CHURCH BOOK drives `RecordsBook:ToggleHome`.
- `tests/test_console.lua` — add pins for the Console:Show roster kick (AttachLibrary/Refresh called; RequestRoster only when not ready).
- `tests/run.lua` — suite rename; no test_ui.
- `tests/preview_dump.lua` — update only what the shell/chip/small-toast removal breaks (it does not dofile MainFrame/Status today). Verify `COB_PREVIEW_DIR=$(mktemp -d) lua tests/preview_dump.lua` exits 0.
- `tests/wow_ui_stub.lua` — touch only if something above needs it.

Full harness `lua tests/run.lua` exits 0. Grep proof: no `COB.UI` references in `addon/`; no `MainFrame`/`Status`/`Toasts:Show` references outside their deleted files.

## Hard rules

- Lua 5.1. Multi-return errors. Getters return copies. Core untouched.
- Ten Laws: Quiet Mode — minimap + Decree only; no new chrome; the version-mismatch chat line stays the only Quiet notice; Event theater unchanged in dress and copy (byte-for-byte proclamation copy).
- Law 10: no dress changes on any surface in this lane.
- TOC lists only existing files; Interface stays 20506.
- Do not commit. Do not touch `WTF/`. Do not edit `docs/` except your report. Do not regenerate responsive renders.

## Report

Write your full report to `docs/reformation/ux-rebuild/briefs/T-theater-collapse-report.md`: what changed per file, test counts before/after per touched suite, full-harness result, preview_dump result, grep proofs, concerns. Return only: status (DONE / DONE_WITH_CONCERNS / BLOCKED / NEEDS_CONTEXT), one-line test summary, and concerns if any.
