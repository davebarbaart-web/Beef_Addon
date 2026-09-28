## Task 4: Welcome parchment

**Files:** `UI/Welcome.lua` (new); `ChurchOfBeef.toc`; `Core/DB.lua` `applyDefaults`; `ChurchOfBeef.lua` `initUi`; `tests/test_welcome.lua` (register in `tests/run.lua` `suites`); `tests/test_db.lua`

**Spec items:** 100-point **9–10**. Bible **§19.5**. Copy: `docs/superpowers/plans/2026-09-14-welcome-copy.md` **Variant A only**.

### Pins

- Missing `ui.welcomeSeen` fills `false`; unknown `ui` keys survive (`streamerMode` pin stays); `SCHEMA_VERSION == 7` (never stamp 8).
- One §19.5 sheet, first launch only. `MODE = "QUIET"`. No sound. No toast.
- Copy must not say “Director Console.” Must not concatenate Ask-to-fight and fight-bar favor into one breath.
- If a Decree is already showing (`DecreeBanner:IsShown()`) **or** Runtime ≠ `QUIET`, do not stack: skip welcome. Do **not** set `welcomeSeen` on skip (so a later Quiet first-launch can still show it). One parchment.
- `pcall` Welcome Init via existing `initModule` (same helper as Task 1).
- Flag `welcomeSeen` on **Close only**.

### Copy (verbatim Variant A)

| Key | String |
|-----|--------|
| `title` | `CHURCH OF BEEF` |
| `what` | `Meetup nights and sanctioned duels.` |
| `tuesday` | `Most days: the bull on the minimap, and a notice if one is posted. That is Tuesday.` |
| `name` | `Left-click the bull, or type /beef, to open your name.` |
| `ask` | `When the gathering starts, Ask to fight.` |
| `favor` | `When two names appear on the fight bar, click a name to pick a side.` |
| `role` | `You do not run the show.` |
| `close` | `CLOSE` |

Paint `ask` and `favor` as **separate FontStrings** (or two paragraphs with a blank line). Do not concatenate them.

Close label: `CLOSE` (same as the player card).

### Implementation notes

- Theatrical parchment via Theme (Law 10 / `.cursor/rules/ui-juice-standards.mdc`). Follow `UI/Decree.lua` + `UI/PlayerCard.lua` Theme helpers: no hardcoded hex, ink discipline (charcoal/iron on parchment; gold only on dark bands).
- New file `addon/ChurchOfBeef/UI/Welcome.lua`. TOC: `UI\Welcome.lua` after Theme, before `ChurchOfBeef.lua`. Interface stays `20506`.
- `defaultUi()` and `applyDefaults`: if `ui.welcomeSeen == nil` then `false`.
- `initUi`: call `initModule("Welcome", COB.Welcome)` **after** `DecreeBanner` so the stack check can see a shown Decree.
- `ResetForTests` under `COB._IN_TEST`: hide/nil frame; do not write SV unless a Close test does.
- Do not fire Sound. Do not call `Toasts:Proclaim`. Do not advertise `/beef console`.
- Do not invent OPEN_QUESTIONS answers. No congregation Store writes.

### Tests

`tests/test_welcome.lua` (isolated, like `test_decree_ui.lua` / `test_player_card.lua`):

- `Welcome.MODE == "QUIET"`
- Source / COPY has no “Director Console”
- `ask` and `favor` exist as separate strings; `ask` does not contain “click a name”
- Init when `welcomeSeen` is false and QUIET and no Decree → frame shown
- Close → `ChurchOfBeefDB.ui.welcomeSeen == true` and frame hidden
- Second Init after Close → not shown
- Init when `DecreeBanner:IsShown()` → not shown, `welcomeSeen` still false
- Init when Runtime state is `ASSEMBLY` → not shown, `welcomeSeen` still false
- No Sound / Proclaim calls

`tests/test_db.lua`: missing `welcomeSeen` fills `false`; unknown ui keys survive; version stays 7.

Register `test_welcome` in `tests/run.lua` `suites` (and the on-disk `test_*.lua` contract).

`lua tests/run.lua` must exit 0.

### Do not

- Commit. David has not asked.
- Touch `UI/Hud.lua`, `UI/Console.lua`, `Net/Codec.lua`.
- Drop `BackdropTemplate` anywhere.
- Claim `POLISH:PASS` / MVP.
