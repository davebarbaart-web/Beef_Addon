# B6-A — Console honorific + Recognition

**Exclusive:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

**Do not edit** Store, Recognition.lua, Knighting, RecordsBook. Do not commit. Console stays stock. `SaveNote` stays nil. No WHISPER ALL. No Council confirmer button (#8).

## Law

Bible §15 (honorifics = Pope-granted plain text) and §12.2 (Rite of Recognition; no self-service).

1. **Honorific**
   - Stock EditBox + stock button `GRANT HONORIFIC`.
   - `Console:GrantHonorific(humanId, text)` → `Store:AddHonorific(humanId or selectedHumanId, text)`.
   - Text from the box when omitted. Trim; empty refuse. Embedded `"\n"` refuse. Never invent titles.
   - Pope-gated like other desk verbs (`isRegisteredPope`).

2. **Recognition**
   - `Console:BeginRecognition(humanId, characterId)` → `Recognition:Begin(..., "pope", now)` using selected human + selected character when args omitted.
   - `Console:CompleteRecognition()` / `Console:CancelRecognition()`.
   - Do not auto-Complete on the 30s metadata duration. Do not UnitName-bind. Do not pass `"council"`.
   - Missing Recognition module → refuse string. Isolation suite may keep `COB.Recognition == nil` and stub the verbs.

Keep existing desks, Sound `after()` pins, Recommended/CallForward/FlagMoment.

## Tests

GrantHonorific writes Store when Pope. Newline/empty refuse. BeginRecognition spies role `"pope"`. Complete/Cancel do not PlaySound. SaveNote nil. Isolation wrap stays.

`lua tests/test_console.lua` exit 0.

Report `docs/reformation/vestments/briefs/B6-A-console-identity-report.md` + diff.
