# B14-A — SNAPSHOT Knighting candidate overlay

**Exclusive:** `addon/ChurchOfBeef/Net/Snapshot.lua`, `tests/test_net_snapshot.lua`

**Do not edit** Runtime, Codec, Gora, Knighting.lua, glue, TOC, `ChurchOfBeef.lua`, `tests/run.lua`. Do not commit. No new codec kinds. Isolation stays Common + Runtime + Codec + Snapshot (do **not** `dofile` Knighting / Gora / Store / UI). Stub `COB.Knighting` in-file, same pattern as the B11-A `COB.Gora` stub.

## Law

`BuildResponse` already overlays a Gora live / last pair onto the **encoded** SNAPSHOT when Runtime lacks two fighters. Knighting has the same late-join hole: `StartEvent` / `Continue` write empty subjects; `OpenRite("Knighting")` is what puts `subjects.candidate` on Runtime. A congregation `Catchup` during ASSEMBLY (line standing, rite not opened) or a RITE Knighting whose Runtime snapshot lost the candidate therefore lands with no candidate.

Overlay onto the **encoded** SNAPSHOT only. `BuildResponse` must not change Runtime (`assert_unchanged` pins stay). `ApplyResponse` still Restores Bible fields; a candidate that landed on the wire Restores. Favor stays off Restore.

```lua
-- when Runtime subjects lack a numeric candidate:
--   Knighting:GetLine()[1].humanId
--     overlay when state == "ASSEMBLY"
--     overlay when state == "RITE" and riteType == "Knighting"
--   do NOT overlay on RITE Gora / Proclamation / other rites
--   do NOT overlay on CONSEQUENCE
--   do NOT overlay on QUIET (BuildResponse still nil, "no event")
-- missing Knighting / GetLine / empty line / missing humanId
--   → today's encode (no candidate overlay)
-- Runtime already has a number candidate → do not replace it
-- fighter overlay (B11-A) is unchanged and may coexist:
--   ASSEMBLY + live pair + line head → wire has both fighters and candidate
```

Preserve fighters when writing the candidate overlay (mirror of `overlaySubjects` keeping `candidate`). Use `pcall` on `GetLine`. Do not invent SUMMON. Do not persist favor. Do not mutate Runtime.

Anniversary note: this file does not CreateFrame. Catch-up Restore of ASSEMBLY subjects with a candidate is already legal (B12-A).

## Tests

Append after the B11-A / B13-A overlay block. Stub `COB.Knighting` in-file. Pin:

1. No Knighting → existing `encode_expected` pins still pass.
2. ASSEMBLY + empty Runtime candidate + `GetLine()[1].humanId == 77` → encoded candidate is 77. Runtime snapshot unchanged.
3. RITE Knighting + empty Runtime candidate + line head → overlay. Runtime unchanged.
4. RITE Gora + empty Runtime candidate + line head → **no** candidate overlay.
5. CONSEQUENCE + line head → **no** candidate overlay.
6. Runtime already has candidate `7` + different line head → keep `7`.
7. Live fighter overlay + line head on ASSEMBLY → wire has fighters `{31,32}` **and** candidate `77`.
8. `ApplyResponse` of a candidate overlay wire Restores that candidate, stays ASSEMBLY. Isolation wrap stays (`COB.Net` / Store / UI still nil).
9. Empty line / missing `humanId` / `GetLine` throwing → no overlay, no throw from `BuildResponse`.

`lua tests/test_net_snapshot.lua` exit 0.

Report `docs/reformation/vestments/briefs/B14-A-snapshot-candidate-report.md` + diff.
