# Task 1 review — Boot safety

**Scope (this gate only):** `initUi` / `initModule` / `initChat` in `ChurchOfBeef.lua`, plus the `test_wire_glue.lua` boot-safety pins and the `test_hud.lua` BackdropTemplate inherit pin.

`ChurchOfBeef.lua`, `test_wire_glue.lua`, and `test_hud.lua` also carry unrelated working-tree history (fighter-card glue, slash, HELLO rebroadcast, HUD dress). That work is **out of scope** and is not scored here.

**Spec-compliance:** PASS

**Task quality:** Approved

The implementer report is accurate for this slice. BackdropTemplate was not dropped. Harness result 15998/0 was not re-run (per gate instruction).

---

## Verdict

Task 1 matches the brief. Every `initUi` module Init is inside `pcall`. After a throwing Hud Init, later modules still Init and `OnLogin` still calls `Net:Init` (and `InstallWire`). Failure prints one prefixed chat line. The Hud inherit string is pinned in source; Inputs’ BackdropTemplate assert is left alone because the inherit was not dropped.

The slice is small, correctly layered (bootstrap owns per-module Init), and does not invent product answers or touch SCHEMA_VERSION / TOC Interface / player WTF.

---

## Spec pins

| Pin | Result | Evidence |
|-----|--------|----------|
| Every `Init` in `initUi` is inside `pcall` | Met | `initModule` → `pcall(mod.Init, mod)` for Minimap, RecordsBook, PlayerCard, Hud, Console, Toasts, DecreeBanner, Sound, FighterCard, Inputs, Markers |
| After a forced Hud Init failure, `Net:Init` still runs | Met | `OnLogin` calls `initUi()` then `COB.Net:Init()`. `test_wire_glue.lua` throws Hud.Init and asserts `netInits` increments |
| One chat line `Church of Beef: <module> failed to start.` | Met | `initChat` uses the existing `\|cffffaa00Church of Beef\|r: ` prefix + `name .. " failed to start."`. Test finds `Hud failed to start.` |
| Wrap Minimap, RecordsBook, PlayerCard, Hud, and every other Init | Met | All current UI `Init` owners are on the list. Theme / Sound / Markers have no `Init`; the type guard no-ops them |
| Always reach `Net:Init()` | Met | `Net:Init` sits after `initUi()`, not inside a UI `pcall` |
| Invert `test_inputs.lua` BackdropTemplate **only if** inherit dropped | Met (correct no-op) | Inherit remains on Hud (`CreateFrame(..., "BackdropTemplate")`) and Inputs. `test_inputs.lua` `_template` asserts stay |
| Hud source pin for `_template` / inherit string | Met | `test_hud.lua` source-finds `CreateFrame("Frame", FRAME_NAME, parent, "BackdropTemplate")` |
| Do not claim the template is missing until a live 20506 abort | Met | Inherit left in place; report says so |
| `lua tests/run.lua` exit 0 | Reported met | Implementer: 15998 passed, 0 failed. Not re-run |

---

## Strengths

- Helpers are the right size: `initChat` for the one Church prefix, `initModule` for the pcall + skip-if-missing, `initUi` as the explicit module list.
- `pcall(mod.Init, mod)` is a real colon call. Missing module / missing `Init` returns without chat noise.
- `OnLogin` stays linear: `initUi()` → `Net:Init()` → `InstallWire()`. A UI abort cannot skip Net.
- Tests match the pin, not a weaker substitute: contract order, Console throw still continues, Hud throw still Inits later modules + Net + InstallWire, chat contains the Hud failure line. Stubs are saved/restored; the chat hook is restored **before** the asserts.
- Hud pin is a source string, which is what the brief asked for — the desktop stub will not catch a client inherit abort, and the comment says so.
- Did not drop `BackdropTemplate` on speculation. Did not invert `test_inputs.lua`.
- Bootstrap-only change. No Core→UI, no congregation store writes, no SCHEMA_VERSION / Interface churn.

---

## Issues

### Critical

None.

### Important

None.

### Minor

1. **Chat pin is a substring.** The suite asserts `m:find("Hud failed to start.")`. It does not assert the `Church of Beef:` prefix or that AddMessage ran exactly once. Implementation is correct; the test would also pass a bare `Hud failed to start.` dump.

2. **`initChat` is not itself pcall’d.** If `DEFAULT_CHAT_FRAME:AddMessage` threw on the failure path, `initModule` would re-raise and `OnLogin` would never reach `Net:Init`. Unlikely on a live client; the only leak in the “always reach Net” story.

3. **Minimap still Inits DecreeBanner internally.** `MinimapButton:Init` calls `DecreeBanner:Init` before `initUi` reaches the banner slot. A banner abort during Minimap is reported as `Minimap failed to start.`, then DecreeBanner is tried again (idempotent `loginRevealDone`). Pre-existing coupling; boot safety still holds because the outer Minimap `pcall` contains it.

---

## Out of scope (not scored)

Unrelated working-tree edits in the same files: fighter-card hide/show, CloseRite, peer HELLO, slash → PlayerCard, InspectProgress copy, HUD-B dress / favor-destination pins, ConsoleDock removal. Those belong to other tasks.

Hud.lua / Inputs.lua / test_inputs.lua were listed on the brief and correctly left unchanged.

---

## Task quality

**Approved.**

Requirements are met with a small, testable bootstrap change and the two requested pins. Remaining notes are test tightness and a pre-existing Minimap→DecreeBanner call — not fix-before-pass.
