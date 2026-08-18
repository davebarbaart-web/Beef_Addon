# B6-B — Records Book identity leaf (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §12.1, §14.2, §15; Law 4, Law 10; OPEN_QUESTIONS #3; brief `docs/reformation/vestments/briefs/B6-B-records-identity.md`. CONTINUE 2026-08-18 license 4 (stock only).

Right parchment leaf paints **identity**, not a tenth ladder page. Local-player honorifics (as given) plus `Store:GetMarkedMoments()` locations. `PAGE_TITLES` stays the nine Bible names. No generated prose. Exclusive files only. No commit. Lane is not signed. **POLISH:CANDIDATE** at most.

**Isolated count:** 331 passed, 0 failed (`lua tests/test_records.lua`). **11** isolation pins under `if standalone then`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_records.lua` | TDD first. Right-leaf widgets. Missing bind → blank honorifics. Seed `Duke of the Fountain` / `Defender of the Faith` + `FlagMoment("Goldshire Inn")` → those strings, not `ordained` / `folk hero`. Unlinked local character does not borrow another human's title. Source greps refuse narration / writers. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/RecordsBook.lua` | `Honorifics` + `Moments` FontStrings on the right leaf. Resolve `UnitName("player")` via `Names.Key` → character → human. Paint honorifics as given. Paint moment `location` only. `PAGE_TITLES` untouched. |
| `docs/reformation/vestments/briefs/B6-B-records-identity-report.md` | This file |
| `docs/reformation/vestments/briefs/B6-B-records-identity.diff` | B6-B-only unified diff of the exclusive implementation files |

Did not edit Console, Store, TOC, bootstrap, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add, rename, or delete `PAGE_TITLES`. Did not commit.

## Contract

### Right leaf (identity)

| Widget | Source | Empty |
|--------|--------|--------|
| `frame.Honorifics` | Local `UnitName("player")` → `Names.Key` → first matching `Snapshot().characters` row → `humanId` → `GetHuman.honorifics`, listed as given | Missing name, missing character, or unbound character → `""`. No invented label. |
| `frame.Moments` | `Store:GetMarkedMoments()` `location` strings, store order | Nil / empty location omitted. No date, no `at`. |

Honorifics are titles, not counts: no `toRoman` on this leaf. Left `Body` still paints superlatives (roman measures stay there). `GetPages` stays the nine Bible pages.

### Unchanged

- `PAGE_TITLES` — nine Bible names, Bible order. OPEN_QUESTIONS #3 parked.
- Left-leaf superlatives, ribbons, prev/next, roman paint, stock QuestBG / MORPHEUS / `UI-Quickslot2`.
- Quiet, no sound, no search, not a ladder. Show / Hide still do not write Store.

## TDD

1. Extended `test_records.lua` first (right leaf, missing bind, seed honorific + location, no `ordained` / `folk hero`, nine titles). Isolation wrap untouched.
2. Red: `right leaf exists` / `Honorifics` / `Moments` missing; seed strings absent.
3. Implemented right-leaf FontStrings + resolve/paint.
4. Green: `lua tests/test_records.lua` — **331 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_records.lua   # 331 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_records.lua` standalone | 331 passed, 0 failed. Lua 5.1.5. Exit 0. |

**Isolated count:** 11 pins under `if standalone then` (Runtime, Gora, Officer, UI, Net, DB, Sender, Minimap, Toasts, Console, Hud). Wrap unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive files only. Nine Bible titles unchanged vs this lane's baseline.
- Source has no `Media\\`, `ordained`, `folk hero`, `on this day`, `unrecognized`, `PlaySound`, `SLASH_`, `AddHonorific`, or `FlagMoment`.
- UI reads Store copies only. It does not grant honorifics or mark moments.
- Missing bind leaves honorifics blank. Marked locations still paint (Church-wide, not local-only).
- Quiet: no sound, no tenth page, no jokes.

## Concerns

- **No client smoke.** Stock QuestBG plus two FontStrings may read as a quest log facing page. **POLISH:CANDIDATE** only.
- **Name reuse (§12.4).** First `Snapshot` character whose `Names.Key` matches the local player wins. Schema replacement is out of scope; do not invent a durable key here.
- **Unbound local character stays blank** even when another human already holds honorifics. Recognition is B6-A / the Rite, not this leaf.
- **Moment rows with no location are omitted.** `FlagMoment(nil)` still stores a row; there is nothing to paint.
- **Honorific list can grow** (Law 7). Long wrap may crowd the moments string on a short tome. Moments sit `BOTTOM` of honorifics with a 16px gap; no cap invented.
- Chrome title / page title still span the full 720-wide frame (pre-existing V-C). Identity sits on the right leaf only.
- Integrator glue was not required (RecordsBook is already TOC-listed). `/reload` was not run.

## Status

**DONE_WITH_CONCERNS.** Not signed. **POLISH:CANDIDATE.**
