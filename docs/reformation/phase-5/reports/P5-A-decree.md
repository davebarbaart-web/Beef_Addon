# Phase 5 Lane A — The Decree (Core + persist)

**Status:** DONE

**Cited:** Ten Laws 4, 5, 6, 7; Bible §14.1, §14.2, §13.1; `.cursor/rules/quiet-event-modes.mdc` (The Decree); brief `docs/reformation/phase-5/briefs/P5-A-decree.md`. Gate 4 leftover: no Decree.

Single active proclamation. Stored fields only: `line` (required string) and optional `flavor` (string or nil). Header **A GATHERING HAS BEEN DECREED** is UI copy, not a stored field. Schema 7 adds root key `decree`. When `COB.Decree` is present, `Save` writes `Decree:Snapshot()` into `ChurchOfBeefDB.decree`; `Init` Restores only when `decree.line` is a string. Empty `{}` / missing `decree` does not Restore. Decree missing: Init/Save still succeed; `decree` stays `{}` (not a Snapshot). Store and event persist are unchanged. Leftover `ladder` / `scoring` / `suggestions` stay at the SV root — not imported into `decree`, `store`, or `event`, not wiped. TOC / bootstrap / `tests/run.lua` / Store / Runtime / Archive / UI / Net / Sender / Console not edited. No commit. Player `WTF/` not touched.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_decree.lua` | Created first. Isolated suite: Common + Decree only. Isolation asserts wrapped in `if standalone then`. |
| `addon/ChurchOfBeef/Core/Decree.lua` | Set / Get (copy) / Clear / Snapshot / Restore / ResetForTests. |
| `tests/test_db.lua` | Schema 7 + empty `decree` hook on the no-Decree path. Decree persist cases dofile Common + Decree + DB. |
| `addon/ChurchOfBeef/Core/DB.lua` | `SCHEMA_VERSION` 6→7. `Save` writes `Decree:Snapshot()` when Decree exists. `Init` Restores only when `decree.line` is a string. |
| `docs/reformation/phase-5/reports/P5-A-decree.md` | This file |

## Schema

- **`SCHEMA_VERSION`:** 7 (bumped because the `decree` key was added).
- Fresh Init: `{ version = 7, ui, store = {}, event = {}, decree = {} }` whether or not Decree is loaded. Init does not Snapshot.
- `Save` with Decree: `decree` becomes the Decree Snapshot (`{ line, flavor }` when set, else `{}`). Not a title, header, author, deputy, `postedAt`, or expiry.
- `Save` without Decree: `decree` remains `{}` if that is what is on disk. No Snapshot-shaped proclamation is invented.
- Store and event persist are unchanged: `Save` still writes `Store:Snapshot()` / `Runtime:Snapshot()` when those modules exist.

## API

| Method | Role |
|--------|------|
| `Set({ line, flavor })` | Replaces the single active Decree. Empty / missing `line` fails (`nil, reason`). `flavor` omitted or `""` is nil. Extra fields (title, header, deputy, …) are ignored. |
| `Get()` | Copy `{ line, flavor }` or nil. Never the live table. |
| `Clear()` | Removes the active Decree. |
| `Snapshot()` | `{ line, flavor }` when set, else `{}`. |
| `Restore(snap)` | Only when `line` is a non-empty string. Empty `{}` / missing / non-table does not wipe a live Decree. |
| `ResetForTests()` | No-op unless `COB._IN_TEST`. |

Core does not check `IsRegisteredPope`. UI will gate later.

## Verification

- Isolated suite (`lua tests/test_decree.lua`): **129 passed, 0 failed**.
- Isolated suite (`lua tests/test_db.lua`): **515 passed, 0 failed**.
- No-Decree section: Init/Save still work; empty `decree` hook survives; leftovers are not imported or wiped. Isolated path still dofiles `DB.lua` only (Store / Runtime / Decree niled first).
- With-Decree section: empty `{}` / missing decree / non-string `line` do not call `Restore` and do not wipe the live Decree. Empty-string `line` calls `Restore`; Decree refuses and leaves live memory. Snapshot-shaped decree Restores once. Round-trip keeps line + flavor. Leftovers stay at the root.
- Lua 5.1. This lane did not edit `tests/run.lua`. Full harness was not run.

## Leftovers (other lanes — not fixed)

- **#5** deputy UX is not coded. Bible §14.1 names a designated deputy; this lane stores one proclamation and does not invent a deputy field or picker.
- **#8** registered-Pope / congregation-vs-Pope persist policy is not coded. This lane persists whenever `COB.Decree` is present.
- Console Post button, parchment banner, minimap replay, and a Decree wire kind were not invented (later lanes).
- Calendar / RSVP / reminders / recurrence / attendance / SUMMON were not invented.

## What this lane refused to invent

Deputy UX, calendar, RSVP, reminders, recurrence, attendance, a Decree wire kind or STATE field, SUMMON, `#8`, Grant/standing, narration, Console Post, `Data/Popes.lua`, title / author / `postedAt` / expiry / place-when split, a Pope-list stub, or an `IsRegisteredPope` check in Core.

## Concerns

- After the first `Save` of a posted Decree, `decree` is Snapshot-shaped. The next `Init` Restores that Snapshot. That is `/reload`, not the empty `{}` hook.
- `Save` of an unset Decree writes `{}`. The next `Init` does not call `Restore` on that `{}`.
- A crafted `decree.line` string (including `""`) still calls `Restore` when the field is a string; Decree refuses empty / whitespace and leaves the live Decree unchanged. DB does not special-case empty string.
- `OPEN_QUESTIONS.md` was not edited. #5 and #8 stay open.
