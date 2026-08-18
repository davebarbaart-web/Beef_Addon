# B32-C — Latest confession line clears called (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §9 (software organizes the queue; it does not write the Pope’s response); §13.4 (free text stays on the Pope desk; no theater); Law 4; B4 leftover (`Receive` overwrite kept `called`, so after Call Forward a new line still painted mute `"  called"`); brief `docs/reformation/vestments/briefs/B32-C-called-reset.md`. Header: “Latest line replaces.” Exclusive files only. No commit. Lane is not signed.

When `Receive` replaces an existing inbox row, it now sets `called = false` after writing `text` / `eventId`. `seq` is not touched, so oldest-first order does not jump. New rows stay `called = false`. `CallForward` still sets `called = true`. `Dismiss` still removes the row. Empty / whitespace still store no text. No theater. No fan-out.

**Isolated count:** 184 passed, 0 failed (`lua tests/test_confession.lua`). Isolation wrap stays under `if standalone then` at file load (**19** nil pins).

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_confession.lua` | TDD first. B32-C pins after CallForward (reuse the called first-arrival): Receive same id → `called == false`, text is the new line, queue length 2, oldest stays first. CallForward after replace still marks and does not reorder. Whitespace / omitted replace still store no text and also clear `called`. Source pin: `existing.called = false`. Isolation wrap stays. |
| `addon/ChurchOfBeef/Core/Confession.lua` | Existing-row `Receive` sets `existing.called = false`. Does not reassign `seq`. New-row `called = false` stays. `CallForward` / `Dismiss` / `_Expire` unchanged. No Toasts / Sound / Net. |
| `docs/reformation/vestments/briefs/B32-C-called-reset-report.md` | This file |
| `docs/reformation/vestments/briefs/B32-C-called-reset.diff` | B32-C-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Console, Net, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add theater, fan-out, Toasts, or Sound. Did not commit.

Both exclusive files were untracked (`??`) before this lane. The brief diff is the B32-C-only delta against the pre-lane inbox (overwrite left `called` unchanged).

## Contract

| Surface | Role |
|---------|------|
| `Receive` (existing row) | Overwrite `text` and `eventId`. Set `called = false`. Keep `seq`. |
| `Receive` (new row) | Unchanged. `called = false`. Assign `nextSeq`. |
| `CallForward` | Unchanged. Sets `called = true`. Does not announce. |
| `Dismiss` | Unchanged. Removes the row. |
| Empty / whitespace | Unchanged. Accepted; store no text. Replace still clears `called`. |
| Newline / non-string | Unchanged. `nil, "invalid text"`. |

### Unchanged

- Quiet / missing `eventId` refuse (`nil, "no event"`).
- OpenRite / CONSEQUENCE / Continue keep. EndEvent / missing eventId wipe.
- Oldest-first `GetQueue` copies. Public row is still `{ characterId, text, called }`.
- `ResetForTests` still `_IN_TEST` only.
- Isolation wrap. 19 nil pins. Load list stays wow_stub + Common + Store + Runtime + Confession.

## TDD

1. Extended `tests/test_confession.lua` first (B32-C pins after CallForward: Receive same id clears `called`, stores the new line, keeps order; CallForward after replace still marks; whitespace / omitted still no-text and also clear `called`; source pin `existing.called = false`). Isolation wrap and B4 Quiet / Dismiss / rite-survival / wipe / source-negative pins untouched.
2. Red: `lua tests/test_confession.lua` — **179 passed, 5 failed** (`latest line clears called`; `GetQueue shows called cleared`; `whitespace replace also clears called`; `empty replace leaves called false`; `existing-row Receive clears called`). CallForward mark / no-announce / order-after-replace / empty-no-text / isolation pins stayed green.
3. Existing-row `Receive` sets `existing.called = false`. `seq` untouched.
4. Green: `lua tests/test_confession.lua` — **184 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_confession.lua   # 184 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_confession.lua` standalone | **184 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 184 passed, 0 failed. Isolation wrap stays (19 nil pins at file load). Wrap pattern unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Console / Net / glue / TOC were not edited.
- Replace clears `called` and keeps `seq`. New rows stay uncalled. CallForward still marks. Dismiss still removes.
- Empty / whitespace still store no text. Newline / non-string still refuse.
- No theater. Source still has no `CreateFrame`, chat, addon message, SV, PlaySound, Toasts, Sound, Net, Penance, or `Grant(`.
- Isolation wrap stays. Main-chunk locals stay under the Lua 5.1 200-local cap (linear suite; no nest required).

## Leftovers

- **Console paint is not this lane.** B20-A appends mute `"  called"` from `row.called`. After this Core fix, `GetQueue` returns `called == false` on a later line, so the next Refresh should drop the token. The desk is unproven here.
- **No client smoke.** Anniversary Call Forward then a new confession line is not walked in-game this lane.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **`seq` is not on the public copy row.** Order is pinned by `GetQueue` position only.
- **GetQueue still has no present-and-alive filter.** B4 leftover; out of this brief.
- **B32-B Console `Dismiss` of a confession** is a sibling lane. This Core `Dismiss` is unchanged.

## Status

**DONE_WITH_CONCERNS.** Isolated **184 / 0**. Isolation wrap **19**. Not signed. No Gate / **POLISH:PASS** claim. Gate W stays OPEN. Gate V stays OPEN.
