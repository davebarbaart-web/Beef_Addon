# W-B — Gora favor tally + FreeRuling per license 3

**Exclusive files (only these):**
- `addon/ChurchOfBeef/Core/Gora.lua`
- `tests/test_gora.lua`

**Do not edit:** Store, Codec, Net, UI, TOC, bootstrap, `tests/run.lua`, OPEN_QUESTIONS, REFORMATION_LOG.

**Do not commit.** TDD. Isolation asserts: `if standalone then`.

## Law

CONTINUE 2026-08-18 licenses 2–3. Bible §10.6. Core never `CreateFrame`. No persist to SavedVariables. No favor history, streaks, accuracy, economy, wagering.

W-C (parallel) will make `Store:RecordGoraResult` accept `ruling = "free"` **without** `won`, and store optional `text` on the result row. Your `FreeRuling` must call Store that way. If you run before W-C lands, Store tests may fail until both exist — still write the new contract.

## 1. Favor tally (memory only)

One standing pick per member. Latest pick replaces earlier. Cleared at each **successful** `Sanction`. Never written to SV / Store / Archive.

API (names fixed — do not invent a `Favor` economy table as a public product object; methods are fine):

```lua
Gora:RecordFavor(characterId, pickId)  -- member id, fighter id
Gora:GetFavor()                        -- copy: map memberId → pickId (or empty {})
Gora:GetFavorSplit()                   -- copy: { a = n, b = n } for sanctioned fighterA/fighterB; zeros if none
```

Rules:

- `characterId` and `pickId` are store integers ≥ 1.
- `RecordFavor` requires a live sanctioned pair; `pickId` must be fighterA or fighterB; else error string.
- Same member picking again replaces the prior pick (map write). No list of past picks.
- `GetFavor` / `GetFavorSplit` return copies; mutating the return must not change live state.
- `Sanction` (success) clears the tally **after** writing the new pair (new bout starts empty).
- Failed Sanction does not clear.
- `ResetForTests` clears the tally. Out-of-harness Reset still refuses and must not wipe.
- Verdicts (`DeclareVictor` / `CowardiceRecorded` / `Void` / `FreeRuling`) may leave the tally; the next Sanction clears. Do not persist across events via SV.
- `_Expire` (event ended) should clear the tally with the live pair (event-scoped). If `_Expire` already drops sanctioned/petitions, also drop picks.

Do **not** keep `assert_eq(Gora.Favor, nil)` if you add methods; remove that leftover assertion. Do not add `Gora.HUD`, ELO, etc.

## 2. FreeRuling — license 3

A FREE RULING records the Pope’s ruling text on the bout and ceremony log and **writes no win/loss**.

Change `writeBoth` so `ruling == "free"` does **not** set `won` (same as void). If `text` is a non-empty trimmed string, set `fields.text` on both sides.

`Gora:FreeRuling(text)`:

- Still requires a sanctioned pair.
- `text` optional; non-string → error; trim; empty → nil.
- Call Store without `won`.
- After both Store writes succeed, if `Store.AppendCeremony` exists, call `Store:AppendCeremony("free", { a, b }, now, line)` — 4th arg is optional Pope-authored text (human, not software narration). If AppendCeremony rejects 4 args until W-C lands, still call it; W-C will accept `text`.
- `clearLive` as today.
- Return `{ ruling = "free", text = line }`.

Update tests that expect `results[1].won == false` for free. New expect: `won == nil`, wins/losses unchanged, `results[1].text` equals the trimmed line when provided, nil when omitted.

Add tests:

- RecordFavor / replace / reject outsider pick / reject with no sanction.
- Sanction clears prior picks.
- GetFavorSplit counts `{ a = 2, b = 1 }` after three members pick.
- Copies do not alias.
- FreeRuling does not increment wins or losses on either character.
- ResetForTests clears picks.

## Verify

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_gora.lua
# Full suite may fail Store free-ruling until W-C lands. Isolated Gora tests that hit Store need W-C.
```

If isolated Gora+Store tests fail only on `won` until W-C, note that in the report. Do not edit Store.

No commit.
