# B5-C — Console line, recommend, call-forward, zone mark (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §8, §9, §10.2, §18.1; Law 10 / §19.3; CONTINUE license 4 (stock only); brief `docs/reformation/vestments/briefs/B5-C-console-verbs.md`.

Director Console stays stock-pragmatic. `GetKnightingLine()` copies `Knighting:GetLine()` when that API exists, else `{}`, and paints Store names. Enqueue / Skip are `stockButton` furniture (not ritual plates); KNIGHT THIS BEEF / ELEVATE TO LORD stay ritual. `Recommend()` calls `Gora:Recommend` for the selected pair, else a named-opponent petition, else the first two petitions; on success `SelectFighters` updates Proposed Bout. **Never Sanction.** Mute suggestion is `nameA vs nameB` plus `1-0` when H2H exists. `CallForward` marks Confession only — no Toasts, `SendChatMessage`, or Sound. `FlagMoment` with a nil location passes trimmed `GetSubZoneText()` (empty → nil). `after()` Sound pins stay. `SaveNote` stays nil. Exclusive files only. No commit. Lane is not signed.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console.lua` | TDD first. GetKnightingLine / Enqueue / Skip / Recommend / CallForward API; stock furniture vs ritual plates; Recommend never Sanction; CallForward no theater; FlagMoment zone stub; SaveNote nil; isolation wrap kept. Knighting GetLine/Enqueue/Skip stubbed when the real module has not landed them. |
| `addon/ChurchOfBeef/UI/Console.lua` | Line list + Enqueue / Skip furniture. Recommend + mute suggestion. Call Forward furniture. FlagMoment reads GetSubZoneText when location is nil. Ritual `after()` cues unchanged. |
| `docs/reformation/vestments/briefs/B5-C-console-verbs-report.md` | This file |
| `docs/reformation/vestments/briefs/B5-C-console-verbs.diff` | B5-C-only unified diff of the exclusive files vs the pre-lane baseline |

Did not edit Knighting.lua, Confession.lua, Gora.lua, Markers.lua, Toasts, TOC, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not commit.

## Contract

| Method | Role |
|--------|------|
| `GetKnightingLine()` | Fresh copies of `Knighting:GetLine()` when that function exists; else `{}`. Adds `name` from `Store:GetHuman`. Mutating a copy does not rewrite the line. |
| `Enqueue(humanId?)` | Pope-gated. `Knighting:Enqueue(humanId or selectedHumanId)`. Stock button. No Sound. |
| `Skip(humanId?)` | Pope-gated. `Knighting:Skip(humanId or selectedHumanId)`. `stockButton`, not ritual. No Sound. |
| `Recommend(a?, b?)` | Pope-gated. `Gora:Recommend` for explicit ids, else selected fighters, else first named-opponent petition, else first two petitions. Success → `SelectFighters` + mute suggestion. Never `Gora:Sanction`. |
| `CallForward(characterId?)` | Pope-gated. `Confession:CallForward` then Refresh. No Toasts, chat, or Sound. |
| `FlagMoment(location?, now?)` | Existing Pope gate. If `location` is nil and `GetSubZoneText` is a function, pass the trimmed string (empty → nil). |
| `SaveNote` | nil |

### Desk

- Knighting line list under the Knighting header. Enqueue / Skip are `UIPanelButtonTemplate` furniture.
- KNIGHT THIS BEEF / ELEVATE TO LORD remain ritual plates.
- Recommend is furniture above SANCTION. Suggestion FontString is `nameA vs nameB` plus mute `1-0` when Store H2H exists. No `demanded` / `odds` / `meeting`.
- Call Forward is furniture under the confession inbox.
- No WHISPER ALL. No Notebook persist. No custom media.

## TDD

1. Extended `test_console.lua` first (API, isolation, stock vs ritual, line copies/names, Recommend never Sanction, CallForward no theater, GetSubZoneText, SaveNote). Isolation stayed under `if standalone then`.
2. Implemented `Console.lua`.
3. Green: `lua tests/test_console.lua` — **630 passed, 0 failed**.

Pope predicate uses the suite’s existing `Sender.IsRegisteredPope = function() return true end` wrap. No Pope name. No `Data/Popes.lua`. Confession is stubbed; this suite does not load `Confession.lua`. Knighting line APIs are stubbed only when `GetLine` / `Enqueue` / `Skip` are missing; Store+Runtime+Knighting pin the real API when B5-A has landed.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console.lua   # 630 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console.lua` standalone | 630 passed, 0 failed. Lua 5.1.5. Exit 0. |

**Isolated count:** 17 nil-module pins inside `if standalone then` (Quiet shell, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Confession). Six loaded-module pins stay outside the wrap. Standalone suite: **630 passed**.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Recommend never calls Sanction. CallForward does not play Sound, toast, or `SendChatMessage`.
- Getters return copies. Expected failures stay `nil, err`.
- Enqueue / Skip / Recommend / Call Forward are furniture: enabled when the Pope predicate is false; the methods stay refuse-closed.
- `after()` still plays knighting / elevation / sanction / verdict / cowardice. New verbs add no cues.
- `Console.SaveNote` remains nil. Source has no `WHISPER ALL`.
- Isolation asserts remain behind `if standalone then`.
- Existing Proposed Bout, favor, Post Decree, FREE RULING, Dismiss, and MARK THIS MOMENT pins stayed green.

## Concerns

- Client `/reload` smoke was not run. The left column grew (`DESK_H` 400, frame 700) to fit the line list and Call Forward; glanceability on Anniversary is unproven.
- `Knighting:GetLine` / `Enqueue` / `Skip` are stubbed in this suite until B5-A lands. Integrator still wires the real line into the full harness.
- `Confession.lua` is not loaded here. CallForward is proven against a stub. No theater path was added.
- Recommendation H2H reads fighter **A**’s Store row only. History that exists only on B paints names, no score.
- Furniture buttons stay visually enabled for a non-Pope; clicks still refuse. Same Dismiss pattern as B4-D.
- Button label is `Enqueue` (brief said `Line` / `Enqueue`). Skip label is `Skip`.

## Status

**DONE_WITH_CONCERNS.** Not signed.
