# B4-INT — Batch 4 integrator (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** CONTINUE 2026-08-18 licenses 1–4; Bible §9, §10.2, §13.1, §13.4, §18.1, §18.5, §19.1–19.3; Laws 4, 5, 6; Batch 4 reviews all Spec PASS.

Bootstrap glue after Batch 4. `InstallWire` only: `bindLocalCharacter` also sets `Inputs:SetLocalCharacterId`; accepted inbound STATE sets `Inputs:SetInputTarget(sender)` and refreshes Inputs / ConsoleDock; Runtime `StartEvent` / `OpenRite` / `Continue` / `EndEvent` refresh those surfaces; `EndEvent` also `FighterCard:Hide`. Skip while `COB._inspecting` (inbound inspect hides Inputs + Dock). Slash: `/beef petition` and `/beef confess` bind `UnitName("target")` when it is a non-empty string — no Pope-name lookup. TOC lists `Core\Confession.lua`, `UI\Inputs.lua`, `UI\ConsoleDock.lua`. Harness lists `test_confession`, `test_inputs`, `test_console_dock`. Two-client honesty names live whisper-to-Pope `SendPetition` / `SendConfession` — still needs a caller-supplied target; no Pope name invented. Confession fan-out stays leftover. Walk boxes untouched. No commit. **Gate W is not closed. Gate V is not closed. POLISH:PASS is not claimed. V1 / MVP is not complete.**

## Files written

| Path | What changed |
|------|----------------|
| `addon/ChurchOfBeef/ChurchOfBeef.toc` | Listed `Core\Confession.lua` after Gora, `UI\ConsoleDock.lua` after Console, `UI\Inputs.lua` after FighterCard. Interface stays `20506`. |
| `tests/run.lua` | Listed `test_console_dock` next to `test_console`, `test_inputs` next to `test_fighter_card`, `test_confession` next to `test_gora`. |
| `addon/ChurchOfBeef/ChurchOfBeef.lua` | `bindLocalCharacter` also binds Inputs. Inbound STATE paints Inputs target + furniture Refresh. Runtime after-success refreshes Inputs / ConsoleDock. `EndEvent` Hides the fighter card. Slash `petition` / `confess`. |
| `addon/ChurchOfBeef/UI/MainFrame.lua` | `UI:Init` pcall-Inits FighterCard, Inputs, ConsoleDock when those modules exist. |
| `tests/test_wire_glue.lua` | Petition WHISPER pin is `"not a registered pope"`. Inputs / ConsoleDock Refresh spies. EndEvent Hide. Slash target bind. Inspect silent. |
| `docs/phases/two-client-smoke.md` | Honesty table: petition / confession INPUT are live whisper-to-Pope. Walk boxes not ticked. |
| `docs/REFORMATION_LOG.md` | Batch 4 verdicts only. Gates W / V stay OPEN. |
| `docs/reformation/vestments/briefs/B4-INT-report.md` | This file |

Did not edit Confession.lua, Gora.lua, BeefNet.lua, Console.lua, Hud.lua, FighterCard.lua, Inputs.lua, or ConsoleDock.lua. Did not edit `tests/test_ui.lua` (no compose pin went red). Did not invent a Pope name. Did not `SendChatMessage`. Did not tick two-client walk boxes.

## Contract

| Path | After success |
|------|----------------|
| `bindLocalCharacter` | existing Hud bind; also `Inputs:SetLocalCharacterId` when Inputs exists (same Store row as Hud) |
| Inbound accepted STATE | existing HUD favor paint; `Inputs:SetInputTarget(sender)`; `Inputs:Refresh`; `ConsoleDock:Refresh`. While inspecting: Hide Inputs + Dock; skip target / Refresh |
| `Runtime:StartEvent` / `OpenRite` / `Continue` | existing `SendState`; `Inputs:Refresh`; `ConsoleDock:Refresh` |
| `Runtime:EndEvent` | existing `SendState`; furniture Refresh; `FighterCard:Hide` if that function exists |
| `/beef petition` | `SetInputTarget(UnitName("target"))` when the name is a non-empty string, then `Inputs:Petition()` |
| `/beef confess` | same target bind, then `Inputs:Show()` (Show already Quiet-refuses) |

`CloseRite` still sends STATE only (not in the furniture list). Verdict `FighterCard:Hide` after Proclaim is optional and was not added.

Missing modules / functions are `pcall`'d no-ops. Skip furniture Refresh, card Hide, and Inputs local-id bind while `COB._inspecting`.

## TDD

1. Listed Confession / Inputs / ConsoleDock in TOC and `run.lua`. Extended `tests/test_wire_glue.lua` (petition WHISPER, furniture spies, EndEvent Hide, slash).
2. First red on isolated glue: whispered petition returned `"no event"` because a leftover Pope stub made `_LocalPope()` true and `Gora:Petition` ran with no event. Restored the unstubbed predicate. Not a BeefNet change.
3. Implemented bind / inbound / Runtime furniture / slash in `InstallWire` and the slash list. `UI:Init` pcall-Inits the three modules.
4. Isolated glue 364/0. Full harness 8139/0. No `test_ui.lua` interop edit.

Pope predicate stays the existing Beefina stub and is restored. Furniture spies are restored at suite end.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_confession.lua     # 158 passed, 0 failed
lua tests/test_inputs.lua         # 209 passed, 0 failed
lua tests/test_console_dock.lua   # 156 passed, 0 failed
lua tests/test_wire_glue.lua      # 364 passed, 0 failed
lua tests/test_net_v2.lua         # 523 passed, 0 failed
lua tests/run.lua                 # 8139 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_confession.lua` standalone | 158 passed, 0 failed. Exit 0. |
| `tests/test_inputs.lua` standalone | 209 passed, 0 failed. Exit 0. |
| `tests/test_console_dock.lua` standalone | 156 passed, 0 failed. Exit 0. |
| `tests/test_wire_glue.lua` standalone | 364 passed, 0 failed. Exit 0. |
| `tests/test_net_v2.lua` standalone | 523 passed, 0 failed. Exit 0. |
| `lua tests/run.lua` | 8139 passed, 0 failed. Exit 0. |

Conformance (glue): no `SendChatMessage`; no invented Pope name; slash does not read `Data/Popes.lua`; Quiet inspect path does not Refresh Inputs / Dock or Hide the card; inbound inspect Hides Inputs + Dock; GUILD petition stays `"unknown message type"`; whispered petition without a local Pope is `"not a registered pope"`; `SendPetition` / `SendConfession` honesty still requires a caller-supplied target.

TOC lists only existing files. `## Interface: 20506`.

## Self-review

- Exclusive B4 sources unedited. Glue lives in bootstrap + MainFrame Init + compose pins.
- Wraps attach only inside idempotent `InstallWire` (OnLogin). File load does not Refresh furniture.
- Fail-closed: inspecting, missing modules, `pcall` around Refresh / Hide / SetInputTarget / Petition / Show.
- No Pope name written. `#8` list stays David's.
- Two-client walk boxes were not ticked. Gate W and Gate V are not claimed closed.

## Concerns

- Exclusive lanes were not reopened. No compose fix on Confession / Gora / BeefNet / Console / Hud / FighterCard / Inputs / ConsoleDock.
- `tests/test_ui.lua` was not edited. MainFrame pcall-Init is a no-op when those modules are absent (isolated `test_ui` still does not load them).
- Glue suite still loads `Data/Ranks.lua` so Knighting can `SetRank`. Isolation still omits Popes; FighterCard / Inputs / ConsoleDock are spies.
- Client `/reload` smoke and the two-client walk were not run. The harness does not prove Anniversary theater.
- Confession **fan-out** stays leftover. Do not claim Gate W or Gate V closed. Do not claim POLISH:PASS. Do not claim V1 / MVP complete.

## Status

**DONE_WITH_CONCERNS.** Batch 4 lanes signed in the log. **Gate W stays OPEN.** **Gate V stays OPEN.**
