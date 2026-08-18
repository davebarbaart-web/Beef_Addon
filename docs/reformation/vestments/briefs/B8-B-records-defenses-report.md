# B8-B — Records Most Successful Defenses (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §10.9, §14.2, §19.3; Law 4, Law 7, Law 10; OPEN_QUESTIONS #9 (resolved); brief `docs/reformation/vestments/briefs/B8-B-records-defenses.md`. CONTINUE 2026-08-18 license 4 (stock only). B7-C scripture leaf kept.

Bible §10.9 page **Most Successful Defenses** is already titled. The page fills from `Store:CountDefenses` when present, else the same #9 derive: sitting-Lord victories after `elevationAt` (`won == true`, `at >= elevationAt`). `maxHolders`: empty when best < 1; list only the top count. `PAGE_TITLES` stays the nine Bible names. The old always-empty / "do not derive from elevationAt" pin is flipped. Exclusive files only. No commit. Lane is not signed. **POLISH:CANDIDATE** at most.

**Isolated count:** 372 passed, 0 failed (`lua tests/test_records.lua`). **11** isolation pins under `if standalone then`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_records.lua` | TDD first. Source pin reads `CountDefenses`. Empty-store pin stays empty (best < 1). Flipped omit pin: Lord + two post-elevation wins → `Lordalt` with count 2; pre-elevation-only wins stay off the page. `PAGE_TITLES` count 9. Isolation wrap stays. `gora.defenses` still nil. |
| `addon/ChurchOfBeef/UI/RecordsBook.lua` | Prefer `Store:CountDefenses`; same derive if missing. `maxHolders` on `defenses`. Roman paint matches other superlatives. `PAGE_TITLES` untouched. No stored increment. No generated prose. |
| `docs/reformation/vestments/briefs/B8-B-records-defenses-report.md` | This file |
| `docs/reformation/vestments/briefs/B8-B-records-defenses.diff` | B8-B-only unified diff of the exclusive implementation files |

Did not edit PAGE_TITLES, Store, Console, TOC, bootstrap, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not commit. Did not write `gora.defenses`. Did not invent a tenth page.

## Contract

### Most Successful Defenses

| Source | Empty | Superlative |
|--------|--------|-------------|
| `Store:CountDefenses(id)` when present; else walk that character's `gora.results` after the linked human's `elevationAt` (`won == true`, `at >= elevationAt`) | best < 1 (empty store, unlinked, no `elevationAt`, pre-elevation-only wins) | only the top count; shared holds list both |

Page entries carry `name`, `characterId`, `defenses` (arabic measure). Painted body is `Name —` roman. The book does not increment or store a defense field.

`PAGE_TITLES` stays the nine Bible names. Tournament Champions stays empty.

### Unchanged

- `PAGE_TITLES` — nine Bible names, Bible order. OPEN_QUESTIONS #3 parked.
- Honorifics, scripture, ribbons, prev/next, stock QuestBG / MORPHEUS / `UI-Quickslot2`.
- Quiet, no sound, no search, not a ladder. Show / Hide still do not write Store.
- `gora.defenses` remains stripped by Store. The book never writes it.

## TDD

1. Extended `test_records.lua` first (CountDefenses source pin, flipped empty-page pin, Lord + two post-elevation wins → count 2, pre-elevation-only off the page, nine titles). Isolation wrap untouched.
2. Red: page still forced empty; Lord wins after elevation did not list.
3. Implemented prefer-Store / same-derive fill + roman paint.
4. Green: `lua tests/test_records.lua` — **372 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_records.lua   # 372 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_records.lua` standalone | 372 passed, 0 failed. Lua 5.1.5. Exit 0. |

**Isolated count:** 11 pins under `if standalone then` (Runtime, Gora, Officer, UI, Net, DB, Sender, Minimap, Toasts, Console, Hud). Wrap unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive files only. Nine Bible titles unchanged vs this lane’s baseline.
- Source has no `Media\\`, `ordained`, `folk hero`, `on this day`, `unrecognized`, `PlaySound`, `SLASH_`, `AddHonorific`, `FlagMoment`, or `CanonizeMoment`. Source reads `CountDefenses`.
- UI reads Store copies / CountDefenses only. It does not write a defense increment.
- `maxHolders` empty when best < 1; only the top count is listed.
- Quiet: no sound, no tenth page, no jokes.

## Concerns

- **B8-A not landed here.** `Store:CountDefenses` is absent on this checkout. The page uses the same #9 derive (`won == true` after `elevationAt`) until that method exists, then prefers it. If B8-A later filters rulings beyond `won == true`, the fallback could diverge until Store ships.
- **No client smoke.** Defenses leaf paint is roman II on stock parchment. Long name + count wrap was not eyeballed. **POLISH:CANDIDATE** only.
- No Defenses ribbon. Prev/Next still reach the titled page. Not pinned as a miss; brief did not ask for a bookmark.
- Cowardice-as-defense is covered only by `won == true` (B8-A law). This suite seeds two post-elevation victories, not a cowardice ruling.
- Integrator glue was not required. `/reload` was not run.

## Status

**DONE_WITH_CONCERNS.** Not signed. **POLISH:CANDIDATE.**
