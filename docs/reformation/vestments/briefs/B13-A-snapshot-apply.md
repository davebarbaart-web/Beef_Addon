# B13-A — ASSEMBLY overlay ApplyResponse

**Exclusive:** `addon/ChurchOfBeef/Net/Snapshot.lua`, `tests/test_net_snapshot.lua`

**Do not edit** Runtime, Codec, Gora, glue. Do not commit. Isolation stays Common + Runtime + Codec + Snapshot.

## Law

B12-A lets Runtime Restore fighters in ASSEMBLY. B11-A already encodes a live `GetSanctioned` overlay onto ASSEMBLY SNAPSHOT. Pin that **ApplyResponse of that wire Restores** those fighters and keeps ASSEMBLY. Favor stays off Restore. BuildResponse still must not mutate Runtime.

If the pin already exists and passes, keep it and add the missing ASSEMBLY land (today only CONSEQUENCE / RITE overlays are Applied). Do not overlay last pair onto ASSEMBLY. Do not add codec kinds.

## Tests

After the existing live-overlay encode pins: `ApplyResponse(liveWire)` is true; landed state is ASSEMBLY; fighters are the stub ids; Runtime was unchanged by BuildResponse; favor is nil on the Restore snapshot. Isolation wrap stays.

`lua tests/test_net_snapshot.lua` exit 0.

Report `docs/reformation/vestments/briefs/B13-A-snapshot-apply-report.md` + diff.
