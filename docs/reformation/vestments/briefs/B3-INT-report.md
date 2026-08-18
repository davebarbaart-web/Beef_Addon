# B3-INT — Batch 3 integrator (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** CONTINUE 2026-08-18 license 4; Bible §8, §10.6, §13.1, §19.2–19.4; Laws 4, 5, 6; Batch 3 reviews all Spec PASS.

Bootstrap glue after Batch 3. `InstallWire` only: successful `Knighting:KnightThisBeef` / `ElevateToLord` call `Toasts:Proclaim` with the human name from `Store:GetHuman`; successful `Gora:Sanction` also `FighterCard:Show` / `Refresh` when that module exists. Skip while `COB._inspecting`. TOC lists `UI\FighterCard.lua`. Harness lists `test_fighter_card`. Two-client honesty names live `Net:RequestSnapshot(target)` — still needs a target; no Pope name invented. Walk boxes untouched. No commit. **Gate W is not closed. Gate V is not closed. POLISH:PASS is not claimed. V1 / MVP is not complete.**

## Files written

| Path | What changed |
|------|----------------|
| `addon/ChurchOfBeef/ChurchOfBeef.toc` | Listed `UI\FighterCard.lua` next to Hud. Interface stays `20506`. |
| `tests/run.lua` | Listed `test_fighter_card` next to `test_hud`. |
| `addon/ChurchOfBeef/ChurchOfBeef.lua` | `humanName` / `showFighterCard`. Knighting wraps → `proclaim("knighting"|"elevation")`. Sanction wrap also shows the mute card. |
| `tests/test_wire_glue.lua` | Knighting Proclaim pins (`Sirloin` from `GetHuman`). FighterCard Show / Refresh spy. Inspect / refuse / missing-module no-ops. Loads Ranks so `SetRank` can accept Knight / Lord. |
| `tests/test_ui.lua` | Interop only: cue-name pin watches `Sound:Play`, not `PlaySound`. B3-C feeds `PlaySound` a kit id (or nothing when `SOUNDKIT` is missing). |
| `docs/phases/two-client-smoke.md` | Honesty table + the following sentence: `Net:RequestSnapshot(target)` is live congregation whisper. Walk boxes not ticked. |
| `docs/REFORMATION_LOG.md` | Batch 3 verdicts only. Gates W / V stay OPEN. |
| `docs/reformation/vestments/briefs/B3-INT-report.md` | This file |

Did not edit Toasts.lua, Gora.lua, Console.lua, Sound.lua, or FighterCard.lua. Did not invent a Pope name. Did not `SendChatMessage`. Did not tick two-client walk boxes.

## Contract

| Verb | After success |
|------|----------------|
| `Knighting:KnightThisBeef` | `proclaim("knighting", { name })` — `name` from `Store:GetHuman(result.id).name` |
| `Knighting:ElevateToLord` | `proclaim("elevation", { name })` — same GetHuman read |
| `Gora:Sanction` (existing) | existing sanction Proclaim, then `FighterCard:Show` and `FighterCard:Refresh` if those functions exist |

`humanName(id)` reads `Store:GetHuman(id).name` when Store exists. Missing Store, unknown id, or empty name → that field is omitted. No invented name strings.

`proclaim()` and `showFighterCard()` no-op while `COB._inspecting`, when the target module / function is missing, and are `pcall`'d so glue does not throw.

## TDD

1. Extended `tests/test_wire_glue.lua` (knighting Proclaim + FighterCard Show spy) and listed FighterCard in TOC / `run.lua`.
2. First red on isolated glue: `KnightThisBeef` refused — suite had not loaded `Data/Ranks.lua`, so `Store:SetRank` rejected rank 3. Loaded Ranks. Not a Core change.
3. Implemented `humanName` / `showFighterCard` and the three wraps in `InstallWire`.
4. Isolated glue 302/0. Full harness then red on six B3-A `PlaySound` cue-name pins (B3-C kit-id path; `SOUNDKIT` nil in that suite).
5. Interop: `tests/test_ui.lua` spies `Sound:Play`. Isolated `test_ui` 302/0 again. Full harness 7448/0.

Pope predicate stays the existing Beefina stub and is restored. Knighting wraps and the FighterCard spy are restored at suite end.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_fighter_card.lua   # 263 passed, 0 failed
lua tests/test_wire_glue.lua      # 302 passed, 0 failed
lua tests/run.lua                 # 7448 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_fighter_card.lua` standalone | 263 passed, 0 failed. Exit 0. |
| `tests/test_wire_glue.lua` standalone | 302 passed, 0 failed. Exit 0. |
| `lua tests/run.lua` | 7448 passed, 0 failed. Exit 0. |

Conformance (glue): no `SendChatMessage`; no invented fighter or Pope names; Quiet inspect path does not Proclaim or Show the card; missing Toasts / missing FighterCard do not break the Core verbs; refused verbs do not Proclaim or Show; `RequestSnapshot` honesty still requires a caller-supplied target.

TOC lists only existing files. `## Interface: 20506`.

## Self-review

- Knighting / Gora / Toasts / FighterCard sources unedited. Glue lives in bootstrap.
- Wraps attach only inside idempotent `InstallWire` (OnLogin). File load does not Proclaim or Show cards.
- Fail-closed: inspecting, missing modules, `pcall` around Proclaim / GetHuman / Show / Refresh.
- No Pope name written. `#8` list stays David's.
- Two-client walk boxes were not ticked. Gate W and Gate V are not claimed closed.

## Concerns

- Console Event-cue `after()` and `Toasts:Proclaim` may still play the same §19.4 cue twice (V-INT leftover). Do not edit Console or Sound.
- `tests/test_ui.lua` was not in the B3-INT exclusive set. It is a compose fix: B3-A pinned `PlaySound` argument `"sanction"`; B3-C made `PlaySound` a kit number and a no-op without `SOUNDKIT`. The name contract now lives on `Sound:Play`.
- Glue suite now loads `Data/Ranks.lua` so Knighting can `SetRank`. Isolation still omits Popes, FighterCard (spy only), Toasts, Sound, Officer, DB.
- Client `/reload` smoke and the two-client walk were not run. The harness does not prove Anniversary theater.
- Do not claim Gate W or Gate V closed. Do not claim POLISH:PASS. Do not claim V1 / MVP complete.

## Status

**DONE_WITH_CONCERNS.** Batch 3 lanes signed in the log. **Gate W stays OPEN.** **Gate V stays OPEN.**
