# W-C — Store free ruling (report)

**Status:** DONE

**Cited:** CONTINUE 2026-08-18 license 3; OPEN_QUESTIONS #10 (resolved); brief `docs/reformation/wire/briefs/W-C-store-free.md`.

A FREE RULING records Pope-authored text on the bout and ceremony log and writes no win/loss. Not a fifth W/L outcome, not a silent Void. Victor / Cowardice / Void unchanged. No narration / scripture / generated prose. Exclusive files only. No commit.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_store.lua` | Revoked `free` + `won = true` victory. Added free-without-won, refuse boolean `won`, text trim/omit/non-string, AppendCeremony 3-arg + 4-arg, Restore keeps `won == nil` + leftover keys. |
| `addon/ChurchOfBeef/Core/Store.lua` | `RecordGoraResult` accepts `free` with absent/`nil` `won`; refuses boolean `won`; stores optional trimmed `text`. `AppendCeremony(..., text)` optional 4th arg. |
| `docs/reformation/wire/briefs/W-C-store-free-report.md` | This file |

Did not edit Gora, Codec, Net, UI, TOC, bootstrap, `tests/run.lua`, OPEN_QUESTIONS, REFORMATION_LOG.

## Contract

### `RecordGoraResult` — `ruling == "free"`

- `won` must be absent or `nil`. `won == true` or `won == false` → `nil, "free ruling has no won flag"`. Store unchanged.
- No increment of `wins`, `losses`, or signed streak. No h2h wins/losses.
- Still appends `rulings` and `results`; increments h2h `fights` (same as Void).
- Result row: `ruling = "free"`, `won = nil`, `text` = trimmed string or nil, `famousUpset` boolean (default false).
- `fields.text` if present must be a string; trim; empty → nil. Non-string → `nil, "text must be text"`.
- `opponentId` rules unchanged.

### `RecordGoraResult` — other rulings

- `void`: `won` forced nil; no W/L. Unchanged.
- `victor` / `cowardice`: still require `won == true` or `false`. Unchanged.

### `AppendCeremony(entryType, participantIds, now, text)`

- 3-arg callers unchanged (Recognition, existing tests).
- Optional 4th arg `text`: nil → no `text` field; string → trim, empty → omit; non-string → error.
- No `narration` / `scripture` fields.

### Restore / Snapshot

- No `ensureCharacter` change. Restored `ruling == "free"` with `won == nil` and optional `text` is kept. Does not invent `won = false`. Leftover keys survive (existing deepcopy policy).

## TDD

1. Replaced the revoked `free` + `won = true` victory block and added the new asserts.
2. Red: `lua tests/test_store.lua` — free + boolean `won` still wrote; free without `won` returned nil (`ruling needs a won flag`); later asserts aborted on nil `free`.
3. Green: implemented Store; suite 330 passed, 0 failed.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_store.lua   # 330 passed, 0 failed
lua tests/run.lua          # 5970 passed, 9 failed (not W-C)
```

| Suite | Result |
|-------|--------|
| `tests/test_store.lua` | 330 passed, 0 failed |
| `tests/test_gora.lua` | 392 passed, 0 failed |
| `tests/test_console.lua` | 301 passed, 0 failed |
| `tests/test_recognition.lua` | 163 passed, 0 failed (3-arg AppendCeremony) |
| `tests/test_archive.lua` / `tests/test_db.lua` | green |
| `lua tests/run.lua` | 9 failed in `test_net_codec` (W-A: `EncodeDecree` / favor wire types). Aborted that suite. |

## Self-review

- Exclusive files only. Getters still return copies. Expected failures are `nil, err`.
- Free is not a W/L outcome and not Void-with-shame: fight happened (h2h `fights`++), no streak/W/L.
- Text lives on the result row and optional ceremony entry only — not on `rulings[]`, not as software narration.
- `won` values that are neither boolean nor nil (e.g. `0`) are accepted on free and coerced to nil, matching the brief's "refuse only `true`/`false`".
- `AppendCeremony` will store a 4th-arg string on any `entryType`, not only `"free"`. W-B calls `"free"`; Recognition stays 3-arg.

## Gora note (do not edit)

The brief expected Gora to still write `free` + `won = false` until W-B lands. **In this workspace W-B has already landed:** `Gora:FreeRuling` calls `writeBoth` without a `won` flag and `AppendCeremony("free", { a, b }, now, line)`. `test_gora` now asserts `won == nil` and no W/L. Isolated Gora/console suites are green against this Store. No Gora two-loss fallout to note beyond that alignment.

Full-harness red is W-A (`test_net_codec`), not Gora and not this lane.

No commit.
