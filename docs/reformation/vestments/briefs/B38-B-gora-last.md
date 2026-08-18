# B38-B — last-pair SNAPSHOT overlay is Gora-only

**Exclusive:** `addon/ChurchOfBeef/Net/Snapshot.lua`, `tests/test_net_snapshot.lua`

**Do not edit** Codec, Gora, glue. Do not commit. No dest on Codec.

## Law

Bible §10.7 persist is the Gora pair. B32-A HUD already forgets leftover lastPair when `riteType ~= "Gora"`. `BuildResponse` (~93–102) overlays `GetLastSanctioned` on **any** CONSEQUENCE with fewer than two fighters. After Gora → Continue → Knighting CloseRite, the wire still carries leftover last Gora pair.

Last-pair overlay only when `snap.riteType == "Gora"`. Live `GetSanctioned` overlay stays. Candidate overlay stays B14-A (ASSEMBLY / RITE Knighting). Existing Gora CONSEQUENCE last-pair pins stay.

## Tests

After the B14-A block. Existing Gora empty CONSEQUENCE + `GetLastSanctioned` still overlays. Knighting (or Confession) CONSEQUENCE + last pair stub does **not** overlay leftover fighters. Isolation wrap stays.

`lua tests/test_net_snapshot.lua` exit 0.

Report `docs/reformation/vestments/briefs/B38-B-gora-last-report.md` + diff.
