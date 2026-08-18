# W-B — Gora favor expire-path fix

**Status:** DONE (task-gate only; do not treat the lane as signed)

**Cited:** CONTINUE 2026-08-18 license 2; brief `docs/reformation/wire/briefs/W-B-gora-favor.md`; failed review `docs/reformation/wire/briefs/W-B-gora-favor-review.md` Important #1.

Closes the event-scope hole only. Store / Codec / Net / UI / TOC / bootstrap / `tests/run.lua` / OPEN_QUESTIONS / REFORMATION_LOG / Data/Popes.lua not edited. No commit.

## What changed

| Path | What changed |
|------|----------------|
| `tests/test_gora.lua` | TDD first. Added pick → Void → `EndEvent` → `StartEvent` (no Gora call in the QUIET window) → first `GetFavor` is empty. Existing same-event Void-leaves-pick pin kept. Isolation stays under `if standalone then`. |
| `addon/ChurchOfBeef/Core/Gora.lua` | File-local `favorEventId` tags the tally to the event the picks belong to. `_Expire` wipes picks when `liveEventId()` is missing **or different**. Does not wipe merely because `sanctioned` is nil. `RecordFavor` stamps the tag from the live pair. `wipeFavor` keeps map + tag together on Sanction / Reset / expire. |
| `docs/reformation/wire/briefs/W-B-gora-favor-fix-report.md` | This file |
| `docs/reformation/wire/briefs/W-B-gora-favor-fix.diff` | `git diff -- addon/ChurchOfBeef/Core/Gora.lua tests/test_gora.lua` after the fix |

Verdict leftovers still stand for the same event’s consequence beat. A new event’s first Gora read no longer inherits last event’s map.

## Isolated `test_gora.lua`

```
Tests finished: 401 passed, 0 failed
```

Lua 5.1. Exit 0. (Pre-fix TDD run: 399 passed, 2 failed on the new StartEvent leak pin.)

Full harness was not re-run. Isolated Gora is the gate for this fix.

## Leftover concerns

- Review Minors 1–4 are unchanged: `RecordFavor` still does not use `knownCharacter`; `AppendCeremony` return is still ignored; whitespace-only FreeRuling is still pinned on the return value only; leftover-tally after a verdict is still only exercised via Void (`clearLive` is shared).
- `git diff` vs HEAD also includes the earlier uncommitted W-B favor/FreeRuling work, not only this expire-path edit. The expire-path hunks are in `_Expire`, `favorEventId` / `wipeFavor`, `RecordFavor` tagging, and the new StartEvent test.
- Do not sign W-B from this report. Do not claim V1 / MVP complete.
