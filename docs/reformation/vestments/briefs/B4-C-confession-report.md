# B4-C — Private confession inbox (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §9, §13.4; Law 4; brief `docs/reformation/vestments/briefs/B4-C-confession.md`.

Memory-only private confession inbox on the Pope's client. Event-scoped like Gora petitions. Never SavedVariables. Never CreateFrame. Never Toasts / Sound / Net. No penance, sin categories, rewards, or fan-out. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 158 passed, 0 failed (`lua tests/test_confession.lua`). **19** isolation pins under `if standalone then`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_confession.lua` | Isolated suite. wow_stub + Common + Store + Runtime + Confession. Quiet refuse; StartEvent Receive; latest replaces; oldest-first copies; Dismiss; CallForward mark without announce; newline refuse; OpenRite / CONSEQUENCE / Continue keep; EndEvent / missing eventId wipe; ResetForTests; missing-Store desktop id; source greps. Isolation under `if standalone then`. |
| `addon/ChurchOfBeef/Core/Confession.lua` | `COB.Confession`. Receive / GetQueue / CallForward / Dismiss / ResetForTests. In-memory inbox keyed by character id. |
| `docs/reformation/vestments/briefs/B4-C-confession-report.md` | This file |
| `docs/reformation/vestments/briefs/B4-C-confession.diff` | B4-C-only unified diff of the exclusive implementation files |

Did not edit TOC, `tests/run.lua`, Store, Gora, BeefNet, UI, `ChurchOfBeef.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not commit.

## Contract

```lua
Confession:Receive(characterId, text)  -- latest text replaces; one row per character
Confession:GetQueue()                  -- copies, oldest-first
Confession:CallForward(characterId)    -- marks called; does not announce
Confession:Dismiss(characterId)
Confession:ResetForTests()             -- _IN_TEST only
```

- `characterId` must be a positive integer. Store present + `GetCharacter` nil → `nil, "unknown character"`. Store missing → unknown ids may still queue.
- `text` optional. Present and not a string, or embedded `"\n"` → `nil, "invalid text"`. Empty / whitespace-only → store no text.
- Quiet / missing Runtime / missing `eventId` → wipe, then `Receive` returns `nil, "no event"`.
- Same `eventId` survives `OpenRite` / CONSEQUENCE / `Continue`.
- Never writes Store / DB / SV. Getters return copies.

Public row: `{ characterId, text, called }`. `called` is boolean. `text` is nil when omitted or whitespace.

## TDD

1. Wrote `tests/test_confession.lua` first (API, isolation, Quiet refuse, replace, copies, Dismiss, CallForward, newline, rite survival, wipe, ResetForTests, missing Store).
2. Red: `lua tests/test_confession.lua` — `cannot open addon/ChurchOfBeef/Core/Confession.lua`.
3. Implemented `Confession.lua`.
4. Green: `lua tests/test_confession.lua` — **158 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_confession.lua   # 158 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_confession.lua` standalone | 158 passed, 0 failed. Exit 0. |

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive files only. Isolation asserts stay under `if standalone then`.
- Inbox is process memory. `_Expire` mirrors Gora petitions: no live event id wipes; leftover event ids drop.
- `CallForward` sets `called` only. No chat, addon message, Proclaim, or Play.
- Source has no `CreateFrame`, `SendChatMessage`, `SendAddonMessage`, `ChurchOfBeefDB`, `PlaySound`, `COB.Toasts`, `COB.Sound`, `COB.Net`, `Penance`, or `Grant(`.
- Load list is wow_stub + Common + Store + Runtime + Confession. No UI. No Ranks.

## Concerns

- **Integrator glue is still required.** TOC and `tests/run.lua` were not edited. B4-A / B4-D / B4-G must call this module; this lane does not wire Net or Console.
- **GetQueue has no present-and-alive filter.** Gora petitions hide absent ids; the brief asked only for copies, oldest-first.
- **Replace keeps first-arrival order and the `called` mark.** Latest text overwrites the line; it does not re-queue or clear the mark.
- **`called` is this lane's observable mark.** B4-D paints name + text and may ignore it.
- Client `/reload` was not run. Memory-only Core has no Quiet chrome to smoke.

## Status

**DONE_WITH_CONCERNS.** Not signed.
