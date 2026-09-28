# Task 12 Report — Ask to fight (no Store write)

**Status:** DONE  
**Commits:** none  
**Interface:** 20506 (unchanged)  
**SCHEMA_VERSION:** 7 (unchanged)  
**PROTOCOL:** 2 (unchanged)

## What landed

Congregation Event strip face is **Ask to fight**. Header is not `EVENT INPUT`. Listed Pope (`Sender:IsRegisteredPope`) hides the strip. Dest line and `SendPetition` dest both use `Net:DefaultDest()` (last accepted STATE sender, else `Popes.List[1]`). Fireable reasons paint on the strip, not a toast. Successful send paints asked / waiting. Zip-fresh empty store does not mint a Store id; the closed wire may carry placeholder `characterId` 1 (Task 6 apply ignores it).

### Per-file

- `addon/ChurchOfBeef/UI/Inputs.lua`  
  Face / header **Ask to fight**. `ReasonText` on the root (TitleBar still two labels). Hide when `Sender:IsRegisteredPope(local)`. `petitionDest()` = bound target else `Net:DefaultDest()` else `List[1]`. Send passes that dest. Reasons: not in a guild; send failed; you already asked (event-scoped, no TTL); this is a Knighting, not a fight (strip stays up so the line can fire). After send: **Asked. Waiting.** No Store mint; missing `localCharacterId` → placeholder `1`. BackdropTemplate kept.

- `addon/ChurchOfBeef/Net/BeefNet.lua`  
  Exported `Net:DefaultDest()` — same helper as local `defaultDest()`.

- `tests/test_inputs.lua`  
  Inverted Petition / `EVENT INPUT` / `IsRegisteredPope`-forbid pins. Added hide-on-Pope, dest line == send dest, fireable reasons, asked / waiting, empty-store does not Ensure.

- `tests/test_net_v2.lua`  
  `DefaultDest` export + dest equals SendPetition when no explicit target.

### Pins (verified in tree)

| Pin | Evidence |
|-----|----------|
| Face / header **Ask to fight**; not `EVENT INPUT` / `"Petition"` | `test_inputs.lua` source + `HeaderText` / button |
| Hide on listed Pope (`IsRegisteredPope`) | source require + `runTask12` Pope stub |
| Dest line == send dest (`DefaultDest`, last STATE sender beats `List[1]`) | `runTask12` Steakina vs Popeonius; recipient / Net-default pins |
| Not in a guild / send failed / already asked / Knighting | `runTask12` face + return why |
| Asked / waiting after send | ReasonText `Asked. Waiting.`; second click `you already asked` |
| Empty store does not Ensure | `runTask12` Store spies stay 0; placeholder id 1; view id stays nil |
| Unknown opponent does not refuse | existing opponent suite (Chuckroast still attaches) |

## Tests

```text
lua tests/test_inputs.lua   # 608 passed, 0 failed
lua tests/test_net_v2.lua   # 869 passed, 0 failed
lua tests/run.lua           # 16902 passed, 0 failed
```

## Do-not list

No commit. No phase ticks. No `UI/Console.lua` / `UI/Hud.lua` / `Core/DB.lua` / `Core/Gora.lua` / `ChurchOfBeef.lua`. No BackdropTemplate drop. No POLISH:PASS / MVP.

## Concerns

1. Placeholder id is integer `1` (Codec `isId` requires ≥ 1). Apply ignores it. Zip-fresh still does not write Store or set `localCharacterId`.
2. Knighting **refuses** with the strip visible so the reason can fire. Listed Pope **hides** the strip (desk already has petitions).
3. Already-asked is event-scoped: it clears when Runtime returns to QUIET. No TTL clock.
4. Opponent dest-same now compares `petitionDest()`, so targeting the whisper dest (the Pope) omits opponent. Named unknown still attaches and does not refuse.
5. No client `/reload` smoke this slice. Two-client Ask still belongs to Task 15.
6. Reason line sits beside a 96-wide stock button on a 360 strip; long copy may clip in-game. Harness does not prove layout.
