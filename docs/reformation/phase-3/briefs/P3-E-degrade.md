# Phase 3 Lane E — Pope-disconnect degrade (not a sixth state)

Read: Ten Laws 4, 5, 6; Bible §20.3; `.cursor/rules/ceremony-runtime.mdc` (Disconnect). Lane A is signed.

## Exclusive files

- `addon/ChurchOfBeef/Core/Runtime.lua`
- `tests/test_runtime.lua`
- Report: `docs/reformation/phase-3/reports/P3-E-degrade.md`

**Do not** edit TOC, bootstrap, `tests/run.lua`, BeefNet, Codec, Snapshot, Sender, UI, DB.

## Mission

Test-first. Keep the existing isolated runtime suite green, then add degrade cases.

§20.3: on Pope disconnect, clients **hold last state**, then degrade to a quiet-leaning **"awaiting the Pope"** presentation. That is **Event Mode degraded** — not a sixth state, not Quiet chrome, not a toast/pip. **No client promotes itself.**

Hold duration is **unspecified**. Do **not** invent seconds. Harness-driven verbs only:

- **MarkPopeLost()** — while not QUIET, set an `awaitingPope` flag. State / rite / subjects / sequence **do not change**.
- **ClearPopeLost()** — clear the flag (Pope resumed). State unchanged.
- Illegal to `StartEvent` / `OpenRite` / `CloseRite` / `Continue` / `EndEvent` as a “promotion” while `awaitingPope` — those verbs stay Pope-owned; this lane does not add a congregation takeover. Existing verbs may still run in the harness as the Pope client (the writer of the machine). Do not add a second writer.

`Snapshot` / `Restore` must round-trip `awaitingPope` if set (so reconnect can resume). Do not add holdSeconds or a timer.

Version-mismatch Quiet notice stays in BeefNet (`_WarnVersion`). Do not invent a second notice or a toast.

Do not invent Director Console, persist-into-SV (later), or auto-EndEvent on disconnect.

## Do not git commit.
