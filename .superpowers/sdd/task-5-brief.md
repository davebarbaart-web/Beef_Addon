## Task 5: Quiet card copy (not a fake rank)

**Files:** `UI/PlayerCard.lua`; `UI/Minimap.lua`; `tests/test_player_card.lua`; `tests/test_minimap.lua`

**Spec item:** 100-point **15**. Do not resolve OPEN_QUESTIONS **#21**.

### Pins

- Gold plate stays a **real** Church title or the live guild rank. Do **not** paint `NEW` or keep `UNRECORDED` as if it were a seventh rank.
- Newness is the relationship line, verbatim: `The Pope has not written you yet. That is normal.`
- When the gold plate shows a guild rank (no Church human row), that same relationship line is the newness line — not `Guild rank.`
- When there is neither a Church title nor a guild rank: gold plate is empty (not `UNRECORDED` / `NEW`); relationship is still the Pope-has-not-written line.
- Entered-but-unranked (`UNRANKED` / `Recorded, no rank yet.`) stays. That person was written.
- When Runtime ≠ `QUIET`, the existing Gathering line (`DecreeText`) says `The gathering has started.` No toast. Do not reopen welcome. Do not hide a posted Decree line if you can keep both without inventing a second surface — prefer replacing the empty “No gathering is posted.” line with the started sentence when Runtime is live; if a Decree line is posted, you may keep the Decree line **and** still make it obvious the gathering has started (one Gathering plate, not a toast). Simplest lawful read: when Runtime ≠ QUIET, Gathering body is `The gathering has started.`
- Minimap tooltip (only if the button is shown): when Runtime ≠ QUIET, add/replace a line that the gathering has started. No toast. Quiet Mode otherwise unchanged.
- Do **not** rename `CHURCH RECORDS` to History.

### Invert

- `tests/test_player_card.lua` pin `UNRECORDED` on the gold plate → empty or guild title; relationship is the new line.
- Any `COPY.unrecorded` / `unrecordedLine` asserts.

### Do not

- Commit.
- Touch `ChurchOfBeef.lua`, `Core/DB.lua`, `UI/Console.lua`, `UI/Hud.lua`, `Net/Codec.lua`.
- Invent ranks. No Store writes. No `EnsureCharacterByName`.
- Claim `POLISH:PASS`.

`lua tests/run.lua` must exit 0.
