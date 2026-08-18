# B12-B — Open Knighting line fallback (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §18.1 (glanceable Director Console); Law 10 / §19.3 (Director Console stays stock-pragmatic); Bible §20.2 (Open Rite is a Pope console action; broadcast carries active subjects); CONTINUE 2026-08-18 (no SUMMON; no post-show clipboard; `SaveNote` stays nil; Console stays plain); brief `docs/reformation/vestments/briefs/B12-B-knighting-open.md`.

Director Console stays stock. `Console:OpenRite("Knighting")` still uses `selectedHumanId` when that is an id. If it is missing, the rite falls back to `Knighting:GetLine()[1].humanId` when that is an id. Selected human still wins over a different line head. Gora fallback from B11-C stays. Other rite kinds unchanged. `SaveNote` stays nil. No SUMMON. No parchment. No tabs. Exclusive files only. No commit. Lane is not signed. **POLISH:CANDIDATE** at most.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console.lua` | TDD first. Nested `runB12B()` inside `runB8E()` (Lua 5.1 200-local cap): SaveNote nil; no SUMMON / parchment / tabs; Pope-predicate wrap — Enqueue a human with no `SelectHuman` → `OpenRite("Knighting")` Runtime `subjects.candidate` is that id; `SelectHuman` wins over a different line head; isolation wrap re-pin. |
| `addon/ChurchOfBeef/UI/Console.lua` | `OpenRite("Knighting")` falls back to `Knighting:GetLine()` head when `selectedHumanId` is not an id. Gora / Confession / Proclamation unchanged. `SaveNote` untouched. |
| `docs/reformation/vestments/briefs/B12-B-knighting-open-report.md` | This file |
| `docs/reformation/vestments/briefs/B12-B-knighting-open.diff` | B12-B-only unified diff of the exclusive files vs the pre-lane baseline |

Did not edit Knighting, Runtime, glue, TOC, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not commit.

`git diff` vs HEAD on these two files also includes Batches 3–11 (working tree already dirty). The brief diff is the B12-B-only delta, same pattern as B11-C.

## Contract

| Surface | Role |
|---------|------|
| `OpenRite("Knighting")` | `selectedHumanId` (an id) wins. Else `Knighting:GetLine()[1].humanId` when that is an id. Missing Knighting / `GetLine` / empty line / non-id head → today's empty subjects. |
| `OpenRite("Gora")` | Unchanged. Selected pair when both ids; else live then last sanctioned pair (B11-C). |
| Other rites | Unchanged. |
| `SaveNote` | nil |

### Desk

- Console stays stock. No custom media. No parchment.
- No SUMMON. No post-show ceremony summary. No CopyCeremonySummary. No tabs.
- Ritual plates unchanged.

## TDD

1. Extended `test_console.lua` first (line-head fallback, selected wins, SaveNote nil, isolation wrap). Isolation stayed under `if standalone then`. B12-B lives in `runB12B()` nested inside `runB8E()`.
2. Red: `lua tests/test_console.lua` — **1230 passed, 2 failed** (line-head candidate was nil).
3. Implemented `Console.lua`.
4. Green: `lua tests/test_console.lua` — **1232 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console.lua   # 1232 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console.lua` standalone | 1232 passed, 0 failed. Lua 5.1.5. Exit 0. |

**Isolated count:** 17 unique nil-module pins inside the opening `if standalone then` (Quiet shell, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Confession). Six loaded-module pins stay outside the wrap. B12-B re-pins Archive + Quiet shell + Toasts. Standalone suite: **1232 passed**.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Knighting / Runtime / TOC / glue not edited.
- Selected human still wins when it is an id. Line head fills Runtime `{ candidate = humanId }` only when selection is missing.
- `GetLine` is type-guarded. Missing module / method / empty line / non-id `humanId` leave subjects empty.
- Gora fallback from B11-C is untouched. Other rite kinds still pass `subjects = nil`.
- `Console.SaveNote` remains nil. Source has no `SUMMON THE FAITHFUL`, no `CopyCeremonySummary`, no parchment, no tabs.
- Isolation asserts remain behind `if standalone then`.
- No new locals in the main chunk. New pins are inside `runB12B()` nested in `runB8E()`.

## Concerns

- Client `/reload` smoke was not run. **POLISH:CANDIDATE** only.
- An empty line or missing `GetLine` still opens Knighting with empty subjects (today's behavior). The Pope can still open the rite without a candidate.
- Line-head fallback reads `Knighting:GetLine()` directly, not `Console:GetKnightingLine()`. Same `humanId` when the row is an id; Store name paint is not involved.
- B12-A ASSEMBLY Restore is a different lane. This only fills OpenRite subjects on the Pope console.
- Gate W stays OPEN. Gate V stays OPEN.

## Status

**DONE_WITH_CONCERNS.** Not signed. **POLISH:CANDIDATE.**
