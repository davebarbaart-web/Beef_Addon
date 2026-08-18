# B9-B — Gora ruling ceremony log (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §18.1, §10.8; Law 4; brief `docs/reformation/vestments/briefs/B9-B-gora-log.md`.

After successful `writeBoth`, DeclareVictor / CowardiceRecorded / Void append a type-only ceremony row (type + two ids + time). No 4th-arg text. FreeRuling unchanged (still 4-arg with optional Pope line). Famous Upsets stay not computed. Favor stays memory-only. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 432 passed, 0 failed (`lua tests/test_gora.lua`). **10** isolation pins under `if standalone then`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_gora.lua` | TDD first. Victor / cowardice / void append matching type and two ids; no text/scripture. Refused verbs do not append. Missing AppendCeremony still writes the bout and clears the pair. FreeRuling pins stay. Famous Upsets not-computed pin stays. Isolation wrap stays. |
| `addon/ChurchOfBeef/Core/Gora.lua` | After successful `writeBoth`, `AppendCeremony("victor"|"cowardice"|"void", { id, id }, now)` when present. No 4th arg. FreeRuling untouched. |
| `docs/reformation/vestments/briefs/B9-B-gora-log-report.md` | This file |
| `docs/reformation/vestments/briefs/B9-B-gora-log.diff` | B9-B-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Store, Knighting, Console, TOC, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not commit.

## Contract

```lua
Store:AppendCeremony("victor", { winnerId, loserId }, now)
Store:AppendCeremony("cowardice", { fleerId, otherId }, now)
Store:AppendCeremony("void", { a, b }, now)
```

- Call only after both `RecordGoraResult` writes succeed.
- Guard `if COB.Store.AppendCeremony` — missing is OK; the bout still records and `clearLive` still runs.
- No 4th-arg text on these three (software never narrates).
- Refused verbs (no pair, outsider) do not append. Pair still clears on success.
- Do not auto-set `famousUpset`.
- `FreeRuling` stays `AppendCeremony("free", { a, b }, now, line)`.

## TDD

1. Extended `tests/test_gora.lua` first (type + two ids, no text/scripture, refuse does not append, missing AppendCeremony, FreeRuling / Famous Upsets pins stay, isolation wrap stays).
2. Red: `lua tests/test_gora.lua` — ceremony log empty after DeclareVictor (`expected 1 got 0`).
3. Appended the three type-only calls after successful `writeBoth`.
4. Green: `lua tests/test_gora.lua` — **432 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_gora.lua   # 432 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_gora.lua` standalone | **432 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 10 pins under `if standalone then` at file load (Net, UI, DB, Officer, Archive, Recognition, Popes, Sender, Codec, Snapshot). Wrap unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run. Store, Knighting, and Console were not edited.

## Self-review

- Exclusive implementation files only. Getters still return copies. Expected failures are `nil, err`.
- Ceremony append sits after both Store writes, before `clearLive`, matching FreeRuling.
- Source has no 4th-arg text on victor / cowardice / void. No `famousUpset` write. No Narrate / scripture generator.
- FreeRuling still passes `line` as the 4th arg. Favor map is unchanged.
- Isolation asserts stay under `if standalone then`.

## Isolated count

**432 passed, 0 failed.** Isolation wrap: **10**.

## Concerns

- **`AppendCeremony`’s return is ignored.** After both Store writes, a failed append still `clearLive`s and returns success. Same as FreeRuling (W-B review). Current Store cannot fail these 3-arg calls.
- **Participant order is verb-named, not pair-order.** Victor is `{ winnerId, loserId }`; cowardice is `{ fleerId, otherId }`; void is `{ fighterA, fighterB }`. B9-C must not assume A-then-B on every row.
- **Missing-AppendCeremony pin is extra.** The brief licenses the guard; the suite now stubs `Store.AppendCeremony = nil` on DeclareVictor only. Cowardice / Void share the same guard and are not separately stubbed.
- **`at` is `resolveTime()`, not a verb argument.** Same clock as FreeRuling. The victor clock stub (2100) is not re-pinned on the ceremony row.
- **Favor-path Void now logs.** Shared success path. Existing favor tests do not assert the log.
- **No client smoke / full harness.** Memory-only Core. B9-C owns the console desk.

## Status

**DONE_WITH_CONCERNS.** Isolated **432 / 0**. Isolation wrap **10**. Not signed.
