# B9-D — Victor clerical close (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §19.3; Law 4, Law 10; Batch 3 critique (terse clerical verdict); cowardice already closes “So ruled by the Beef Pope.”; brief `docs/reformation/vestments/briefs/B9-D-victor-copy.md`. CONTINUE 2026-08-18: no SUMMON, no post-show clipboard, no custom media. V-B / B3-A / B5-D Quiet / cue / Morpheus pins kept.

Victor clerical copy (and the matching headline) is now `Victor declared: <name>. So ruled by the Beef Pope.` Void / free / sanction / knighting / elevation copy unchanged. No adjectives. No jokes. Morpheus headlines stay. Quiet still refuses Proclaim. Exclusive files only. No commit. Lane is not signed. **POLISH:CANDIDATE** at most.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_ui.lua` | TDD first. Flipped the two pins that expected `Victor declared: Thickcut.` to the new close. Cowardice pin unchanged. Quiet refuse, isolation wrap, and other kind pins stay. |
| `addon/ChurchOfBeef/UI/Toasts.lua` | `clericalCopy` victor sentence appends `. So ruled by the Beef Pope.` Same string is the single-line headline. Other kinds untouched. |
| `docs/reformation/vestments/briefs/B9-D-victor-copy-report.md` | This file |
| `docs/reformation/vestments/briefs/B9-D-victor-copy.diff` | B9-D-only unified diff of the exclusive files vs the pre-lane baseline |

Did not edit Console, HUD, Knighting, Sound, Core, TOC, bootstrap, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add Media files. Did not invent a cue name. Did not `SendChatMessage`. Did not commit.

## Contract

| Kind | Copy |
|------|------|
| `verdict` + `ruling = "victor"` | `Victor declared: {name}. So ruled by the Beef Pope.` |
| `cowardice` | `Cowardice recorded: {name}. So ruled by the Beef Pope.` (unchanged) |
| `verdict` + `ruling = "void"` | `Void.` (unchanged) |
| `verdict` + `ruling = "free"` | Pope `text` if non-empty, else `Free ruling.` (unchanged) |
| `sanction` | `A Beef Gora is Sanctioned` + names + `VS` (unchanged) |
| `knighting` / `elevation` | `RISE, BEEF KNIGHT` / `RISE, BEEF LORD` (unchanged) |

Single-line victor still sits on the headline FontString (stock Morpheus, `GameFontNormalLarge` fallback). Body stays empty. Quiet / missing Runtime still return `false, "quiet"` and do not show. Cue remains `Sound:Play("verdict")`. No new sound names.

## TDD

1. Flipped `test_ui.lua` victor copy + headline pins first.
2. Changed the one `clericalCopy` return in `Toasts.lua`.
3. Green: `lua tests/test_ui.lua` — **321 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_ui.lua   # 321 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_ui.lua` standalone | **321 passed, 0 failed.** Lua 5.1.5. Exit 0. |

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Isolated count

**321 passed, 0 failed.** **11** isolation pins under `if standalone then` (Console, Hud, RecordsBook, Gora, Knighting, Runtime, Sound, Codec, Sender, Archive, Recognition). Wrap unchanged.

## Self-review

- Exclusive implementation files only. Console / HUD / Knighting not edited.
- Quiet refuses. Cowardice pin exact. Void / free / sanction / knighting / elevation pins stay.
- Isolation asserts stay under `if standalone then`.
- Source has no `SendChatMessage(`, `COB.Console`, `COB.Gora`, `COB.Knighting`, `"decisive"`, or generated oratory.
- `MORPHEUS` / `MORPHEUS.ttf` source pins stay. No new cue names. No custom Media.

## Concerns

- **No client smoke.** The longer single-line Morpheus headline is unsmoked on 20506. A long name plus the close may wrap inside the center-third panel the same way cowardice already can. **POLISH:CANDIDATE** only.
- Batch 3 also sketched a two-line split (`VICTOR DECLARED` / `{name}. So ruled by the Beef Pope.`). This lane follows the brief’s single clerical sentence, not that split.
- Integrator still lists the files in the TOC and `run.lua`. Console / Gora still do not call Proclaim (pre-existing).
- Full `lua tests/run.lua` was not run.

## Status

**DONE_WITH_CONCERNS.** Isolated **321 / 0**. Isolation pins **11**. Not signed. **POLISH:CANDIDATE.**
