# B10-A — Gora last pair / last favor

**Exclusive:** `addon/ChurchOfBeef/Core/Gora.lua`, `tests/test_gora.lua`

**Do not edit** Hud, glue, Codec. Do not commit. Famous Upsets stay not computed. Favor stays memory-only.

## Law

`GetSanctioned()` stays **nil** after a ruling (existing pins). Consequence still needs the pair for STATE / HUD persist.

```lua
Gora:GetLastSanctioned()
Gora:GetLastFavorSplit()
```

On successful `clearLive` (victor / cowardice / void / free): snapshot the pair `{ fighterA, fighterB }` and the **then-current** favor split (compute before nilling `sanctioned`). Both are memory-only. Never SV.

Wipe last pair + last favor when `_Expire` has no event, on `ResetForTests`, and when a **new** `Sanction` starts (fresh bout).

`GetFavorSplit()` with no live pair stays `{0,0}` (keep those pins). Missing last → `GetLastSanctioned` nil; `GetLastFavorSplit` `{0,0}`.

## Tests

DeclareVictor → GetSanctioned nil; GetLastSanctioned names both ids; GetLastFavorSplit equals the pre-ruling split. New Sanction → last pair becomes the new pair (or nil until the next ruling — pick one and pin it: last pair is the just-cleared bout until the next Sanction **replaces** it with nil until the next clearLive, OR last pair stays until overwritten at next clearLive. **Pin: new Sanction nils last pair** so STATE does not keep the old bout once a new one is live. EndEvent / QUIET expire nils last. Isolation wrap stays.

`lua tests/test_gora.lua` exit 0.

Report `docs/reformation/vestments/briefs/B10-A-last-pair-report.md` + diff.
