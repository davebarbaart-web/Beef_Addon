# B5-C — Console line, recommend, call-forward, zone mark

**Exclusive:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

**Do not edit** Knighting.lua, Confession.lua, Gora.lua, Markers.lua, Toasts. Do not commit. Console stays **plain / stock**. No Notebook persist. No WHISPER ALL. Keep theater Sound pins (do not remove `after()` cues).

## Law

Bible §8, §9, §10.2, §18.1.

1. **Knighting line (stock list)** — `Console:GetKnightingLine()` returns `Knighting:GetLine()` copies if the module exists, else `{}`. Paint names from Store. Stock buttons:
   - `Line` / `Enqueue` → `Knighting:Enqueue(selectedHumanId)`
   - `Skip` (stockButton, not ritual) → `Knighting:Skip(selectedHumanId)`
   Keep KNIGHT THIS BEEF / ELEVATE TO LORD as ritual plates.
2. **Recommend** — `Console:Recommend()` calls `Gora:Recommend(a,b)` for the proposed bout pair (selected fighters, else first two petitions / named opponent). On success `SelectFighters` so Proposed Bout updates. **Never Sanction.** Paint a mute one-line suggestion (`nameA vs nameB` plus `1-0` if H2H exists). No prose (`demanded`, `odds`).
3. **CallForward** — `Console:CallForward(characterId)` → `Confession:CallForward`. Refresh. No Toasts, no SendChatMessage, no Sound.
4. **FlagMoment** — if `location` is nil and `type(GetSubZoneText) == "function"`, pass that string (trim; empty → nil) into `Store:FlagMoment`. Existing Pope gate stays.

## Tests

Extend test_console.lua. Stub Knighting GetLine/Enqueue/Skip if the real module is loaded (it will be in full harness — pin against real API when Store+Runtime+Knighting exist). Recommend does not call Sanction. CallForward does not play Sound. FlagMoment with GetSubZoneText stub passes the zone. Isolation wrap stays. SaveNote still nil.

`lua tests/test_console.lua` exit 0.

Report `docs/reformation/vestments/briefs/B5-C-console-verbs-report.md` + diff.
