# W-C — Store free ruling (license 3)

**Exclusive files (only these):**
- `addon/ChurchOfBeef/Core/Store.lua`
- `tests/test_store.lua`

**Do not edit:** Gora, Codec, Net, UI, TOC, bootstrap, `tests/run.lua`, OPEN_QUESTIONS, REFORMATION_LOG.

**Do not commit.** TDD. Isolation: `if standalone then`.

## Law

CONTINUE 2026-08-18 license 3 / OPEN_QUESTIONS #10 (resolved):

> A FREE RULING records the Pope's ruling text in the bout record and ceremony log and writes no win/loss to either character. Not a fifth W/L outcome, not a silent Void. Store must accept a free ruling without a `won` field.

Victor / Cowardice / Void unchanged.

## 1. `RecordGoraResult`

For `ruling == "free"`:

- `won` must be **absent or nil**. If `won == true` or `won == false`, return `nil, "free ruling has no won flag"` (wording may match style of existing errors).
- Do **not** increment `wins`, `losses`, or the signed streak.
- Still record a bout: append `rulings` and `results`; increment head-to-head `fights` (same as Void — the fight happened). Do not increment h2h wins/losses.
- `results` row: `ruling = "free"`, `won = nil`, `text` = trimmed string or nil. `famousUpset` stays boolean as today (default false).
- `fields.text`: if present, must be a string; trim; empty → nil. Non-string → error.
- `opponentId` rules unchanged.

For `ruling == "void"`: keep current (`won` forced nil; no W/L).

For `victor` / `cowardice`: still require `won == true` or `false`.

Replace the suite block that records `free` + `won = true` and expects a victory. That product is revoked.

## 2. `AppendCeremony`

Keep `AppendCeremony(entryType, participantIds, now)`.

Add optional 4th argument `text` (Pope-authored ruling text — not software narration):

```lua
Store:AppendCeremony(entryType, participantIds, now, text)
```

- Existing 3-arg callers must keep working (Recognition, tests).
- If `text` is nil, entry has no `text` field (or `text == nil`).
- If `text` is a string, trim; empty → treat as nil; store on the entry as `text`.
- Non-string `text` → error.
- Do not add `narration` / `scripture` / generated prose.

W-B will call `AppendCeremony("free", { a, b }, now, line)`.

## 3. Restore / Snapshot

If a restored character result has `ruling == "free"` and `won == nil` plus optional `text`, keep it. Do not invent `won = false` on restore. Do not wipe unknown leftover keys (existing policy).

## Tests

- Free without `won` writes the row; wins/losses/streak unchanged; `results[#].won == nil`; `results[#].text` set when provided.
- Free + `won = true` / `false` refused; store unchanged.
- Free omitted text → `text == nil`.
- Void / victor / cowardice assertions unchanged.
- AppendCeremony 3-arg still works; 4-arg stores text; empty text omitted.

## Verify

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_store.lua
lua tests/run.lua
```

Full suite may show Gora free-ruling asserts still expecting `won == false` until W-B lands. Do not edit Gora. Note that in the report.

No commit.
