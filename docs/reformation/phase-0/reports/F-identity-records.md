# Phase 0 Lane F — Identity / records report

**Status:** DONE

**Cited:** Bible §12.1–12.5 (hybrid identity, Rite of Recognition, permanence, edges, aggregation); §12.6 (Fallen deferred; permanence holds); §13.5 (Sacred Archive); §17 (public/private, Curtain); §18.3 (Notebook, via §17); §4.9 (events not behavior); Law 7; Audit V6.

**Written:**

- `.cursor/rules/identity-records.mdc`
- `docs/reformation/phase-0/reports/F-identity-records.md` (this file)

**Not written / not invented:** Curtain UX widgets; Archive export file format; per-character → account SV migration (Phase 2). Curtain interaction details already sit in `docs/design/OPEN_QUESTIONS.md` #4. No commit made. `OPEN_QUESTIONS.md` not edited.

## Ban confirmation

Sweeps, self-link, and per-character-as-law are banned in the rule:

| Banned | Rule coverage |
|--------|----------------|
| Departed sweeps / prune / expiry (`SweepDeparted`, 14-day grace) | Non-negotiables + banned table |
| Self-service / same-account auto-link | Rite of Recognition only; no BattleNet linker |
| Per-character SV / "alts start fresh" as law | Account-level `## SavedVariables: ChurchOfBeefDB` |

## Concerns

- `.cursor/rules/build-packaging.mdc` still states per-character SV is intentional and "Do not switch to account-wide." That line will fight this rule until Lane J (or whoever owns packaging keepers) retires it.
- Demo code still implements the banned model (`## SavedVariablesPerCharacter` in the TOC; `Ladder:SweepDeparted`; `Core/DB.lua` comments). Phase 0 did not touch Lua. Phase 2 owns the SV switch.
- `Core/Common.lua` comments still say `Names.Key` answers "is this the same person." The new rule treats Key/Display as character-spelling normalization only.
