# Phase 5 Lane A — Adversarial Review

**Lane:** The Decree (Core + persist)
**Exclusive files:** `addon/ChurchOfBeef/Core/Decree.lua`, `tests/test_decree.lua`, `addon/ChurchOfBeef/Core/DB.lua`, `tests/test_db.lua`
**Lane report:** `docs/reformation/phase-5/reports/P5-A-decree.md`
**Cited law:** Ten Laws 4, 5, 6, 7; Bible §14.1, §14.2, §13.1; `.cursor/rules/quiet-event-modes.mdc` (The Decree); brief `docs/reformation/phase-5/briefs/P5-A-decree.md`
**Writer:** [Decree](c4ee49cf-e160-497e-9874-fc1f2c8e49ff)

**Spec:** PASS
**Quality:** Approved

Single active proclamation. Stored fields only: `line` + optional `flavor`. Header is UI copy, not stored. Schema 7 adds root key `decree`. When `COB.Decree` is present, `Save` writes `Decree:Snapshot()` into `ChurchOfBeefDB.decree`. `Init` Restores only when `decree.line` is a string. Empty `{}` / missing `decree` do not Restore and do not wipe a live Decree. Decree missing: Init/Save still succeed; `decree` stays `{}` (not a Snapshot). Store and event persist are unchanged. Leftover `ladder` / `scoring` / `suggestions` stay at the SV root — not imported into `decree`, `store`, or `event`, not wiped. Isolated `test_decree.lua`: **129 passed, 0 failed**. Isolated `test_db.lua`: **515 passed, 0 failed**. Writer stayed inside exclusive files. `OPEN_QUESTIONS.md` #5 and #8 unchanged. No `Data/Popes.lua`. No Decree wire kind. No calendar / RSVP / SUMMON. No commit. Player `WTF/` not touched. This review did not invent deputy UX, a Pope list, a banner, or a wire kind.

## Verdict

Refutation of Laws 4, 5, 6, 7, Bible §14.1, quiet-event-modes “The Decree,” and “do not invent deputy / calendar / RSVP / wire / #8” **fails** for this lane’s exclusive files.

Law 4 is intact. `Set` / `Restore` store a Pope-supplied place-and-when string and an optional flavor string. Nothing generates narration, flavor copy, or a banner header. Nothing auto-announces. Extra fields (`title`, `header`, `author`, `deputy`, `postedAt`, `expiry`, place/when split) are dropped.

Law 5 and §13.1 are intact on the same terms as Phase 2 store persist and Phase 4 event persist. `DB` has no Post / SetDecree / IsRegisteredPope verbs. It copies the in-memory Decree onto the account SV and reloads a string-`line` table back into that same Decree. Persist-when-Decree-present on every client is the brief; `#8` is not coded.

Law 6 is intact in Core. This lane is the persist hook, not the parchment banner. Exclusive files do not CreateFrame, do not play sound, and do not add Quiet chrome. Calendar / RSVP / reminders / recurrence / attendance / SUMMON are absent. The banner lane was not launched.

Law 7 is intact on the honest path and on the named empties. `{}`, a missing decree (filled to `{}`), a table without `line`, and a non-string `line` do not call `Restore` and do not replace a live Decree. Leftover demo keys are neither imported nor swept. `Clear` removes the single active proclamation (brief-required). That is not Church history (ranks, Gora records, ceremony log live in `store`). A *valid* Snapshot may Restore over live memory — that is `/reload`, not a `SweepDeparted`, not the empty `{}` hook.

§14.1’s “one single active Decree” and the hard bound (no calendar / RSVP / reminders / recurrence / attendance) hold. Designated-deputy authorship stays `#5`. This review did not invent deputy UX, a Decree wire kind, `Data/Popes.lua`, or the banner, and did not commit.

## Confirmations

| Check | Result |
|---|---|
| Single active Decree; stored fields only `line` + optional `flavor`; header not stored | **Yes.** `parse` keeps `line` + `trim(flavor)`. Extra fields ignored. `Get` / `Snapshot` keys are `flavor,line` when flavor is set, `line` when flavor is nil. Header / title / author / deputy / `postedAt` / expiry / place-when split are `nil` on Set, Get, Snapshot, Restore, and Save. |
| Set fails on empty/missing line; Get is a copy; Clear removes; Snapshot is `{}` when unset | **Yes.** Suite + reviewer: `Set()` / `{}` / `""` / whitespace / non-string fail and leave live unchanged. Two `Get()` calls are distinct tables; mutating Get / Set-return / Snapshot does not change live. `Clear` → Get nil, Snapshot `{}`. |
| Restore only when `line` is a non-empty string; `{}` / missing / non-table do not wipe live | **Yes.** `Decree:Restore` refuses non-table, missing line, `""`, whitespace, non-string. Live line + flavor survive. Valid Snapshot Restores and still drops `deputy`. |
| Schema 7 is `{ version, ui, store, event, decree }`; store and event persist unchanged | **Yes.** `SCHEMA_VERSION = 7`. Fresh Init keys are exactly `decree,event,store,ui,version`. Schema 6 SV stamps to 7 when the `decree` hook is added. Downgrade 99 is kept. Reviewer triple-Save: human row + RITE/Gora + line/flavor all land; leftovers stay at the root. |
| Isolated no-Decree path: `decree` stays `{}`; Init/Save succeed; leftovers not imported or wiped | **Yes.** First section nils Store / Runtime / Decree then dofiles `DB.lua` only. Fresh and re-Save `decreeKeys` stay `""`; `line` stays `nil`. Leftover nested payload survives Init **and** Save. `decree.ladder` / `store.ladder` / `event.ladder` stay `nil`. |
| Init Restores decree only when `line` is a string; empty `{}` / missing does not Restore | **Yes.** `isDecreeSnapshot` is `type(decree) == "table" and type(decree.line) == "string"`. Spy: empty `{}` / missing / `{ future = true }` / `line = 1` / `line = true` → `restoreCalls == 0`; live Decree survives. |
| Core does not check `IsRegisteredPope`; no `Data/Popes.lua`; no Decree wire kind; no calendar / RSVP / SUMMON | **Yes.** `Decree.IsRegisteredPope` / `Calendar` / `RSVP` / `Summon` / `Grant` / `Post` are `nil`. `DB` has none of those tokens. No workspace `Data/Popes.lua`. Exclusive files have no wire kind / STATE field. `OPEN_QUESTIONS.md` #5 and #8 unchanged (mtime 07:23; writer files 07:42–07:44). |
| Isolation asserts in `test_decree.lua` wrapped in `if standalone then`; `test_db` isolation still works when Decree is niled | **Yes.** Isolation asserts (and Net-stub cleanup) are behind `if standalone then`. Isolated `test_db.lua` nils `COB.Decree` before dofile. Reviewer: hide Decree after load — Init/Save still succeed; disk Snapshot is not replaced. |
| Isolated suites green | **Yes.** Isolated `lua tests/test_decree.lua`: **129 passed, 0 failed**. Isolated `lua tests/test_db.lua`: **515 passed, 0 failed** (reviewer rerun, Lua 5.1.5). Writer counts match. |
| Writer did not edit TOC / bootstrap / `run.lua` / Store / Runtime / Archive / UI / Net / Sender / Console / `OPEN_QUESTIONS.md` | **Yes.** Writer files mtimes 07:42–07:44. Forbidden paths are older (TOC 07:31, `run.lua` 07:29, Console 07:28, `OPEN_QUESTIONS.md` 07:23, Runtime / Sender 06:37, Store / Archive / bootstrap Aug 14). TOC does not list `Core\Decree.lua`. `tests/run.lua` does not list `test_decree`. Integrator leftover. |

## Attack results

| Attack | Result |
|---|---|
| Law 4 — Core generates flavor / header / narration? | **No.** Flavor is stored only when the caller supplies a non-empty string. Header is never stored. `trim` is whitespace normalize, not copy. No Chronicle, no auto-announce. |
| Law 4 — `Set` / persist is the software posting in the Pope’s voice? | **No.** This is a Core table. Console Post and the parchment banner are later lanes. Persist copies what was already Set. |
| Law 5 — persist is a second writer / second source of truth? | **No.** `DB` does not post Decrees. `Save` copies `Decree:Snapshot()`. `Init` calls `Decree:Restore` on the same module. Congregation UI/Net are not called. No broadcast. |
| Law 5 / §13.1 — persist-when-Decree-present on every client is peer authority? | **No as product.** Brief: persist when `COB.Decree` is present. TOC does not list Decree yet. Once the integrator lists it, every client loads the module. This lane must not invent a registered-Pope list (`#8` — do not code). Later layers must not treat a congregation account SV as canonical proclamation. This review does not invent that gate. |
| Law 5 / §13.1 — Restore from SV is a competing database? | **No.** §13.1’s first sentence is per-client SavedVariables. The Pope’s account `decree` is the durability of the Pope’s Decree. Conflict resolution remains “one writer.” A congregation file that holds a local Snapshot after logout is a local hook, not a second Church. |
| Law 6 — this lane added Quiet chrome / calendar / RSVP / a banner? | **No.** Exclusive files are Core + tests + this persist hook. No `CreateFrame`, no sound, no minimap replay, no scheduler. Hard bound holds. Banner UI was not launched. |
| Law 7 — empty `{}` / missing decree Restores and wipes a live Decree? | **No.** `isDecreeSnapshot({})` is false. Missing decree is filled to `{}` and skipped. Live line + flavor survive. That was the empty hook the brief named. |
| Law 7 — leftover demo keys must be imported as Church history? | **No.** That would invent product: treat a banned points ladder as history. Brief: leftovers stay at the root; never copy into `decree`, `store`, or `event`. Suite + reviewer lock the non-import. |
| Law 7 — Init/Save wipe leftover `ladder` / `scoring` / `suggestions`? | **No wipe.** `applyDefaults` fills `version`, `ui`, `store`, `event`, and `decree` only. `snapshotDecreeToSv` replaces `decree` with a Snapshot; it does not touch root leftovers. Reviewer: leftovers survive empty-hook Init, Snapshot-shaped Init, Clear+Save, and triple Store+Runtime+Decree Save. |
| Law 7 — `Clear` / valid Snapshot over live is `SweepDeparted`? | **No.** `Clear` removes the single active proclamation (brief). Reviewer: a Snapshot-shaped `decree` *does* Restore and replace live memory. Writer disclosed this. Production `Init` runs once at ADDON_LOADED against an empty in-memory Decree — that is `/reload`, not a departed sweep. The Decree is not Church history. |
| Law 7 — refused Restore (empty-string / whitespace / incomplete) deletes disk or live? | **No.** Reviewer: `line = ""` and `line = "   "` call Restore; Decree refuses; live stays; SV blob is not wiped. Non-table `"COBARCH1:nope"` is replaced with `{}` (don’t-error) and does not Restore. |
| §14.1 — stored title / deputy / `postedAt` / expiry / place-when split / calendar? | **No.** Exclusive files store `line` + optional `flavor` only. Bible example header is UI copy. `#5` deputy authorship is not a stored field. |
| GATE1 / `#8` — registered-Pope list / `Data/Popes.lua` invented? | **No.** No Pope-name table, no `IsRegisteredPope`, no workspace data file. `#8` text in `OPEN_QUESTIONS.md` is unchanged. |
| Writer invented Console Post / Grant / a Decree wire kind, edited forbidden files, or committed? | **No.** Exclusive Writes only (mtimes). No commit. `ChurchOfBeef.lua` still Init on ADDON_LOADED and Save on PLAYER_LOGOUT. TOC / `run.lua` do not list Decree yet. |

Refutation of Law 4 (software never narrates), Law 5 (one Pope writer; persist is durability), Law 6 (Quiet bound; no calendar/RSVP/banner in this lane), Law 7 (never-delete; `{}` is not a wipe; leftovers are not history), Bible §14.1 (single proclamation; hard bound), and GATE1 `#8` (do not code the Pope list) **fails** for the exclusive files. The Snapshot Restore is `/reload`, not `SweepDeparted`.

## Isolated rerun counts

Reviewer rerun, Lua 5.1.5, workspace root. No `tests/run.lua` edit.

| Suite | Result |
|---|---|
| `lua tests/test_decree.lua` | **129 passed, 0 failed** (exit 0) |
| `lua tests/test_db.lua` | **515 passed, 0 failed** (exit 0) |

Writer report matches both counts. Full harness was not run (integrator-owned; `test_decree` is not in `suites`).

Reviewer probes (not added to the suite): Get/Set/Snapshot identity copies; leftover survival with and without Decree; niled-after-load Init/Save; empty-string / whitespace Restore-called-then-refused; non-table decree; triple Store+Runtime+Decree Save/Init; Clear+Save writes `{}`; fresh Init does not Snapshot a live Decree. **0 probe failures.**

## Leftovers (other lanes — expected; not fixed)

Writer leftovers are current. Additional live leftovers this lane correctly did not touch:

### #5 / #8 / later (do not invent here)

- **#5** designated-deputy authorship. Bible §14.1 names a deputy; this lane stores one proclamation and does not invent a deputy field or picker. `OPEN_QUESTIONS.md` #5 unchanged.
- **#8** registered-Pope / congregation-vs-Pope persist policy. This lane persists whenever `COB.Decree` is present. Exact file, edit path, and override UX are Phase 4 spec (`OPEN_QUESTIONS.md` #8; GATE1 §4). Do not code now. Do not create `Data/Popes.lua` in review.
- Congregation display of a local SV Decree is not canonical. Theatrical render remains Pope-originated (later Net / UI).
- Console Post button, parchment banner (once per login), minimap replay, Decree wire kind, SUMMON, calendar / RSVP / reminders / recurrence / attendance.

### Decree / DB (signed; do not “fix” here)

- `Restore` of a valid Snapshot replaces live memory. Honest logout/`/reload` starts from an empty process.
- `isDecreeSnapshot` is structural only. Any string named `line` counts — including `""` and whitespace. `Decree:Restore` then refuse-closes; live Decree stays. Honest `Save` emits a parseable Snapshot. Do not move Decree’s trim into `DB`.
- `Save` with Decree drops unknown `decree.future` (Snapshot replace). The no-Decree section still locks “unknown decree key survives Save.” Expected persist; not a root-leftover wipe.

### Integrator / bootstrap (writer did not edit)

- `ChurchOfBeef.toc` does not list `Core\Decree.lua`. Integrator lists after sign.
- `tests/run.lua` does not list `test_decree`. Full harness color is integrator-owned.
- `ChurchOfBeef.lua` — `DB:Init` on ADDON_LOADED; `DB:Save` on PLAYER_LOGOUT. Mid-session writes flush at logout / `/reload` only.

### Not this lane

- Existing player `ChurchOfBeefDB` may still contain leftover `ladder` / `scoring` / `suggestions`. They remain on disk and are not Church history.
- `ui.announce` remains a shipped default. Pre-existing; not a Decree field.
- Banner UI / Quiet parchment. Do not launch from this review.

## Findings

### Critical

None.

### Important

1. **A Snapshot-shaped Decree Restores.** Reviewer probe: a saved `{ line, flavor }` calls `Restore` and replaces a different live line. Writer disclosed this. After the first `Save` of a posted Decree, the empty `{}` hook is gone; the next `Init` Restores that Snapshot. Production `Init` is once per load against empty memory. Do not “fix” by refusing a valid line (invents a hold / authorship policy).

2. **`isDecreeSnapshot` is structural only.** Any string named `line` counts — including `""` and `"   "`. `Decree:Restore` then refuse-closes; live Decree stays; disk blob is not wiped. Honest `Save` emits a trimmed non-empty line. Do not special-case empty string in `DB`.

3. **Persist-when-Decree-present is every client once TOC lists Decree.** `#8` is not this wire. Later UI/Net must not treat a congregation SV `decree` as the Church’s proclamation, and must not invent a Pope list to “fix” it here.

### Nit

1. **Law 7 citation is slightly loose on leftover demo keys.** Comments and the suite say leftovers survive “because Law 7.” Law 7’s object is Church history, not unknown keys. The brief used the same stretch. Behavior is right: do not import, do not wipe, do not treat leftovers as product. Do not “fix” this by adding a wipe.

2. **Suite does not lock Snapshot-shaped Restore over a different live Decree.** Writer report states the `/reload` behavior. Reviewer probe confirms it. Coverage gap only.

3. **Suite does not lock Store+Runtime+Decree on the same `Save`.** Reviewer: all three Snapshots write; leftovers stay at the root. The no-Store / no-Runtime / no-Decree paths are locked separately.

4. **Suite does not lock whitespace `line` on disk.** Reviewer: Restore is called; Decree refuses; live stays. Empty-string is locked.

5. **`Save` with Decree drops unknown `decree.future`.** The no-Decree section still locks “unknown decree key survives Save.” With Decree, `db.decree = Snapshot()` replaces the table. Expected persist; not a root-leftover wipe.

6. **`test_decree.lua` leaks globals if added to the harness carelessly.** `CreateFrame` is stubbed and never restored. `ChurchOfBeefDB` is left as `{ sentinel = 1 }`. A Net stub is created when `COB.Net` is missing and cleared only `if standalone then`. Isolation asserts are correctly wrapped. Integrator should add `test_decree` with the same standalone discipline; do not “fix” product for a harness-order leak.

7. **`DB:Init(_now)` still ignores `now`.** Pre-existing. Persist does not invent a clock or an expiry.

## Brief contract

| Requirement | Result |
|---|---|
| Test-first; isolated `test_decree.lua` (Common + Decree only); isolation asserts in `if standalone then` | Met (129 / 0) |
| Isolated `test_db.lua` stays green when Decree is niled; persist section when present | Met (515 / 0). First section nils Store / Runtime / Decree then dofiles `DB.lua` only |
| Single active Decree; stored fields only `line` + optional `flavor`; header is UI copy | Met |
| `Set` fails on empty / missing `line`; `flavor` omitted or `""` is nil | Met (whitespace flavor also nil) |
| `Get` returns a copy or nil; never the live table | Met (suite + reviewer identity probe) |
| `Clear` removes; `Snapshot` is `{ line, flavor }` when set, else `{}` | Met |
| `Restore` only when `line` is a non-empty string; `{}` / missing / non-table do not wipe live | Met |
| `ResetForTests` only under `ChurchOfBeef._IN_TEST` | Met |
| Core does not check `IsRegisteredPope`; do not stub the Pope list true | Met |
| New root key `decree`; bump `SCHEMA_VERSION` to 7 | Met |
| `Save` writes `Decree:Snapshot()` when Decree exists | Met |
| Store and event persist unchanged | Met (suite + reviewer triple-Save) |
| `Init` Restores only when `decree.line` is a string | Met |
| Empty `{}` / missing `decree` do not Restore | Met |
| Decree missing: Init/Save succeed; do not invent a decree table beyond the empty hook | Met (`decree` hook is `{}`, not a Snapshot) |
| Leftover `ladder` / `scoring` / `suggestions` stay at the root; never copy into `decree` / `store` / `event`; never wipe | Met |
| Do not invent deputy UX, calendar / RSVP / reminders / recurrence / attendance, a Decree wire kind or STATE field, SUMMON, `#8`, Grant/standing, narration, Console Post, `Data/Popes.lua` | Met |
| Do not edit TOC / `ChurchOfBeef.lua` / `tests/run.lua` / Store / Runtime / Archive / UI / Net / Sender / Console | Met |
| Isolated suites must pass | Met (129 / 0 and 515 / 0) |
| No commit; do not invent product / OPEN_QUESTIONS answers; do not launch the banner | Met |

## Sections checked

- Brief `docs/reformation/phase-5/briefs/P5-A-decree.md`
- Writer report `docs/reformation/phase-5/reports/P5-A-decree.md`
- Ten Laws 4, 5, 6, 7 (`.cursor/rules/ten-laws.mdc`)
- `.cursor/rules/quiet-event-modes.mdc` (The Decree)
- Bible §14.1, §14.2, §13.1
- `docs/design/OPEN_QUESTIONS.md` (#5 and #8 unchanged)
- `addon/ChurchOfBeef/Core/Decree.lua`
- `addon/ChurchOfBeef/Core/DB.lua` (live + leftover / triple-Save / no-Decree / refused-Restore / crafted-empty-string probes)
- `tests/test_decree.lua` (live + isolated run: 129 / 0)
- `tests/test_db.lua` (live + isolated run: 515 / 0)
- `ChurchOfBeef.lua` Init/Save hooks (read only; not edited)
- `ChurchOfBeef.toc` (no `Core\Decree.lua`; `## SavedVariables: ChurchOfBeefDB`)
- `tests/run.lua` (no `test_decree`)
- Writer transcript ([Decree](c4ee49cf-e160-497e-9874-fc1f2c8e49ff)) — exclusive Writes only
- P2-E / P4-A persist leftovers (empty-array store Snapshot; persist-when-module-present) — not reopened as this lane’s defect
