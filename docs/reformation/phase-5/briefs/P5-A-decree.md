# Phase 5 Lane A — The Decree (Core + persist)

Read: Ten Laws 4, 5, 6, 7; Bible §14.1, §14.2, §13.1; `.cursor/rules/quiet-event-modes.mdc` (The Decree). Gate 4 is closed. Phase 4 leftover: no Decree.

## Exclusive files

- `addon/ChurchOfBeef/Core/Decree.lua` (create)
- `tests/test_decree.lua` (create)
- `addon/ChurchOfBeef/Core/DB.lua`
- `tests/test_db.lua`
- Report: `docs/reformation/phase-5/reports/P5-A-decree.md`

**Do not** edit TOC, `ChurchOfBeef.lua`, `tests/run.lua`, Store, Runtime, Archive, UI, Net, Sender, Console. Integrator lists the new files after they exist.

## Mission

Test-first. Isolated `test_decree.lua` (Common + Decree only). Wrap isolation asserts in `if standalone then`. Keep isolated `test_db.lua` green when Decree is absent (today it nils Store/Runtime then dofiles `DB.lua` — that path must still work). When Decree is present, add a persist section.

Bible §14.1: one **single** active proclamation. Example shape, not a scheduler:

> **A GATHERING HAS BEEN DECREED**  
> *Goldshire Inn — Sunday, 7:00 PM*  
> *(one optional line of flavor)*

- The header line is **UI copy**, not a stored field. Do not store a title, author, deputy, `postedAt`, expiry, place/when split, or calendar timestamp.
- Stored fields only: `line` (the place-and-when string) and optional `flavor` (string or nil).
- `Set({ line, flavor })` replaces the single active Decree. Empty / missing `line` fails (`nil, reason`). `flavor` omitted or `""` is nil.
- `Get()` returns a **copy** `{ line, flavor }` or nil. Never hand out the live table.
- `Clear()` removes the active Decree.
- `Snapshot()` is `{ line, flavor }` when set, else `{}`.
- `Restore(snap)` only when `line` is a non-empty string. Empty `{}` / missing / non-table does **not** wipe a live Decree.
- `ResetForTests` for the harness only (`ChurchOfBeef._IN_TEST`).
- Core does **not** check `IsRegisteredPope`. UI will gate later. Do not stub the Pope list true.

**Persist.** New root key `decree`. Bump `SCHEMA_VERSION` to **7** (`{ version, ui, store, event, decree }`). Phase 2/4 said bump only when adding a root key — this is that key.

- `DB:Save` writes `ChurchOfBeefDB.decree = Decree:Snapshot()` when `COB.Decree` exists. Store and event persist are unchanged.
- `DB:Init` Restores `decree` only when it looks like a Decree snapshot (`line` is a string). Empty `{}` / missing `decree` does **not** call `Restore`.
- `Decree` missing: Init/Save still succeed; do not invent a decree table beyond the empty hook.
- Leftover `ladder` / `scoring` / `suggestions` stay at the SV **root**. Never copy them into `decree`, `store`, or `event`. Never wipe them.

Update existing schema-6 root-key asserts in `test_db.lua` so they expect the `decree` hook and schema 7. Isolated no-Decree path: `decree` stays `{}`.

## Do not invent

Deputy UX (#5), calendar / RSVP / reminders / recurrence / attendance, a Decree wire kind or STATE field, SUMMON, `#8`, Grant/standing, narration, Console Post button (later lane), congregation-vs-Pope persist policy.

## Do not git commit.
