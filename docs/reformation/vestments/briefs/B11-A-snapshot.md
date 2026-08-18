# B11-A — SNAPSHOT last pair / last favor

**Exclusive:** `addon/ChurchOfBeef/Net/Snapshot.lua`, `tests/test_net_snapshot.lua`

**Do not edit** Codec, BeefNet, Gora, glue, Runtime, TOC, `ChurchOfBeef.lua`, `tests/run.lua`. Do not commit. No new codec kinds. Isolation stays Common + Runtime + Codec + Snapshot (do **not** `dofile` Gora / Store / UI).

## Law

`BuildResponse` today copies Runtime Bible fields only. After `Continue()`, Runtime subjects are empty. After a ruling, `GetSanctioned` is nil. A late `Catchup` therefore lands with no fighters.

Overlay onto the **encoded** SNAPSHOT only. `BuildResponse` must not change Runtime (`assert_unchanged` pins stay). `ApplyResponse` still Restores Bible fields from the decoded message (fighters that landed on the wire Restore; favor is **not** a Bible field and stays off Restore — existing `_HandleSnapshot` glue paints favor).

```lua
-- when Runtime subjects lack two fighters:
--   live = Gora:GetSanctioned()           → overlay any non-QUIET state
--   last = Gora:GetLastSanctioned()       → overlay only when state == "CONSEQUENCE"
-- favor (Codec already allows it on SNAPSHOT response):
--   Console:GetCongregationFavorVisible() == true
--     and two fighters are on the outbound subjects
--     live → Gora:GetFavorSplit()
--     last (CONSEQUENCE only) → Gora:GetLastFavorSplit()
-- missing Gora / Console / methods → today's encode_expected path (no overlay)
```

Do not invent SUMMON. Do not persist favor. QUIET `BuildResponse` stays `nil, "no event"`.

Existing `assert_eq(wire, encode_expected(snap))` pins must keep passing — those paths have no `COB.Gora`.

## Tests

Append after the closed-set block. Stub `COB.Gora` / `COB.Console` in-file; do not load Gora.lua. Pin:

1. No Gora → `BuildResponse` still equals `encode_expected`.
2. Live `GetSanctioned` + ASSEMBLY + empty Runtime fighters → encoded subjects are the live pair. Runtime snapshot unchanged.
3. Last pair + `CONSEQUENCE` + empty Runtime fighters → encoded last pair. Favor overlay when toggle true. Toggle false omits favor.
4. Last pair + `ASSEMBLY` (post-Continue) → **no** last-pair overlay (wire matches Runtime empty fighters).
5. Runtime already has two fighters → do not replace them.
6. `ApplyResponse` of an overlay wire Restores those fighters. Isolation wrap stays (`COB.Net` / Store / UI still nil).

`lua tests/test_net_snapshot.lua` exit 0.

Report `docs/reformation/vestments/briefs/B11-A-snapshot-report.md` + diff.
