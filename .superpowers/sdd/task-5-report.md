# Task 5 report — Quiet card copy (not a fake rank)

**Status:** DONE (no commit)  
**Spec:** 100-point **15**. OPEN_QUESTIONS **#21** not resolved.  
**POLISH:** not claimed.

## Implemented

- Gold plate is a real Church title, a live guild rank, or empty. Never `UNRECORDED`. Never `NEW`.
- Unwritten relationship (no Church human row, including a non-canon guild-rank plate): `The Pope has not written you yet. That is normal.`
- No Church title and no guild rank: gold plate empty; same Pope line.
- Entered-but-unranked stays: `UNRANKED` / `Recorded, no rank yet.`
- Matching canon guild title (no human row) still gets the §5 line (`Belonging`). That is #21 display, not a store write.
- Runtime ≠ `QUIET`: player-card Gathering body is `The gathering has started.` (replaces empty or posted Decree on that one plate). Ink parchment. No toast. No welcome.
- Minimap tooltip, only if the button is shown: adds `The gathering has started.` and keeps a posted Decree line. Hidden button does not fill. No toast.
- `CHURCH RECORDS` unchanged.

**Not done (forbidden files):** glue does not `PlayerCard:Refresh` on Runtime verbs. An already-open card updates on next Show/Refresh.

## TDD

### Invert (RED), before any product edit

Inverted `UNRECORDED` gold-plate pin → empty plate + Pope line; inverted `Guild rank.` → Pope line; added `COPY.unrecorded` / `unrecordedLine` / live Gathering / minimap tooltip pins.

```
lua tests/test_player_card.lua
# 309 passed, 17 failed
# FAIL: no UNRECORDED fake rank word expected nil got UNRECORDED
# FAIL: newness is the relationship line expected The Pope has not written you yet. That is normal. got Not yet in the Church's record.
# FAIL: unwritten gold plate is empty expected  got UNRECORDED
# FAIL: guild-rank plate uses the newness line expected The Pope has not written you yet. That is normal. got Guild rank.
# FAIL: live Runtime replaces empty Gathering copy expected The gathering has started. got No gathering is posted.

lua tests/test_minimap.lua
# FAIL: live empty tooltip adds the started line expected 3 got 2
# FAIL: live empty tooltip Gathering line expected The gathering has started. got Left-click: your card
```

### Implement, then green

```
lua tests/test_player_card.lua   # 326 passed, 0 failed
lua tests/test_minimap.lua       # 241 passed, 0 failed
lua tests/test_decree_ui.lua     # 762 passed, 0 failed (sibling tooltip still names the Decree)
```

Leftover `ASSEMBLY` before the subset (harness pollution): player_card / minimap / decree_ui **1325 passed, 0 failed**. `test_player_card` `reset()` calls `Runtime:ResetForTests` when present. Minimap **adds** the started line so a posted Decree line stays visible.

### Full harness

`lua tests/run.lua` was **16192 / 11** on the first invert-era run (this packet’s Quiet pins vs leftover Runtime). After isolation + add-not-replace, this packet’s suites stay green. A later full run aborted on **sibling Task 6** (`test_net_v2`, `test_console`, `test_gora`: `PetitionFromSender` / console Show) — those files are outside this exclusive set.

## Files

- `addon/ChurchOfBeef/UI/PlayerCard.lua`
- `addon/ChurchOfBeef/UI/Minimap.lua`
- `tests/test_player_card.lua`
- `tests/test_minimap.lua`

No `ChurchOfBeef.lua`, `DB.lua`, `Console.lua`, `Hud.lua`, `Codec.lua`, `Welcome.lua`, TOC, `Gora.lua`, `BeefNet.lua`. No Store writes. No `Ensure`. No inbound Proclaim. SCHEMA 7 and Interface `20506` untouched.

## Concerns

- Full `lua tests/run.lua` exit 0 is blocked by sibling-lane Task 6 inversions, not this packet.
- Open card will not pick up a live Gathering line until Show/Refresh (glue is exclusive-out).
- `tests/preview_dump.lua` (not a harness suite) still pins gold-plate `UNRECORDED`.
- No in-game `/reload` smoke. Do not claim POLISH:PASS.
