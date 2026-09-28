# Task 4 Review — Welcome parchment

Read: brief, report, `UI/Welcome.lua`, TOC (Welcome + Interface), `Core/DB.lua` `defaultUi` / `applyDefaults`, `ChurchOfBeef.lua` `initUi`, `tests/test_welcome.lua`, Variant A copy. Did not git-diff the tree. Did not re-run the full harness.

---

### Spec Compliance

| Pin | Verdict |
|-----|---------|
| `SCHEMA_VERSION == 7` (never stamp 8) | **Met.** `DB.lua` keeps `SCHEMA_VERSION = 7`. `applyDefaults` fills `ui.welcomeSeen` without a version bump. `test_db.lua` pins version 7 on fill / keep / post-event-persist. |
| Interface `20506` | **Met.** TOC `## Interface: 20506`. |
| Missing `ui.welcomeSeen` → `false`; unknown `ui` keys survive | **Met.** `defaultUi()` includes `welcomeSeen = false`. `applyDefaults` sets only when `nil`. `streamerMode` pin stays. |
| One §19.5 sheet, `MODE = "QUIET"`, no sound, no toast | **Met.** `Welcome.MODE = "QUIET"`. No `PlaySound*` / `Sound` / `Toasts` / `Proclaim` in source. Isolated suite spies stay at 0. |
| Variant A copy only; no “Director Console”; ask / favor not one breath | **Met.** `COPY` matches the 2026-09-14 Variant A table verbatim. `ask` and `favor` are separate FontStrings (`AskText` / `FavorText`) with a `md` gap. Source has no “Director Console” and no `/beef console`. |
| Skip (do not stamp) if Decree showing or Runtime ≠ `QUIET` | **Met at Init.** `shouldShow()` is unseen + not `DecreeBanner:IsShown()` + `Runtime:Snapshot().state == "QUIET"`. Skip hides an existing frame and does not call `markSeen`. |
| `welcomeSeen` on Close only | **Met.** `Init` does not write SV. Skip does not write SV. `ResetForTests` does not write SV. `Welcome:Close` / CLOSE `OnClick` is the stamp. |
| `pcall` Init via existing `initModule`, after `DecreeBanner` | **Met.** `initUi` calls `initModule("Welcome", COB.Welcome)` immediately after `DecreeBanner`. `initModule` is the Task 1 `pcall`. |
| TOC `UI\Welcome.lua` after Theme, before bootstrap | **Met.** Theme → … → Decree → Welcome → Toasts → Sound → `ChurchOfBeef.lua`. File exists. |
| No congregation `Ensure`; no inbound Proclaim; no Store mint | **Met.** Welcome writes only `ChurchOfBeefDB.ui.welcomeSeen`. Tests grep out `EnsureCharacterByName` / `CreateHuman` / `LinkCharacter` / `Proclaim`. Isolated suite does not load Store. |
| `ResetForTests` under `_IN_TEST`: hide/nil, no SV | **Met.** |
| Tests registered | **Met.** `tests/run.lua` `suites` lists `test_welcome` after `test_decree_ui`. On-disk `test_welcome.lua` matches the contract. Isolated pins match the brief’s list (MODE, copy, show, Close, second Init, Decree skip, ASSEMBLY skip, no Sound / Proclaim). |
| No `BackdropTemplate`; no Hud / Console / Codec work in this surface | **Met** in the files read. Welcome does not use `BackdropTemplate`. |

Item 10’s “already up” stack rule is implemented as an **Init-time** gate, which is what the brief asked (`initUi` after `DecreeBanner` so a shown login Decree wins). Persist-restored Decree (`DecreeBanner:Init` shows synchronously when `getDecree()` is set) and persist-restored `ASSEMBLY` are covered.

---

### Strengths

- Quiet contract is clean: one unbidden parchment, then silence. No settings, Next tip, slash advert, inbound theater, or congregation identity write.
- Copy is clerical and exact. Ask-to-fight and fight-bar favor stay separate breaths — the Wave 2 reason this sheet exists.
- Theme-only paint (iron / charcoal / gold / parchment). Gold ink sits on the charcoal title band and the iron CLOSE plate; body ink is charcoal, role ink is iron. Matches Law 10 ink discipline and the Decree / PlayerCard helper style.
- Frame is built only when `shouldShow()` is true. A Decree or live-event skip does not `CreateFrame`, so a later Quiet first-launch can still build and show the sheet.
- `DecreeBanner:Init` is synchronous: login reveal `Show()` happens before Welcome’s `IsShown()` check. That is the right order for a persisted Decree.
- Isolated suite is tight and honest: no TOC/bootstrap/Store/DB/Net/Console/HUD. `ResetForTests` is asserted both ways. Report correctly refuses `POLISH:PASS` / MVP and names the red full harness as out of scope.

---

### Issues (Critical / Important / Minor)

#### Critical

None.

#### Important

1. **Post-Init stack is still possible on a first install.** `OnLogin` runs `initUi()` (Welcome may `Show`) and only then `Net:Init` / `InstallWire`. A zip-install recruit with no persisted event/decree who then receives inbound `Decree:Set` (wire `Show`) or a STATE that leaves `QUIET` can sit under a live Decree or Event chrome with the welcome still up. Item 10 / the copy plan say one surface; the brief only contracted the Init gate. Residual, not a missed pin — hide-without-stamp if Decree appears or Runtime leaves `QUIET` while the sheet is showing would close it. Same-session retry after a skip is not required (“later Quiet first-launch”).

2. **No client `/reload` smoke.** Report already says harness-green only. `verification.mdc` still wants install → `/reload` on touched UI. Not a code defect. **POLISH:CANDIDATE** at most.

#### Minor

1. **Escape via `UISpecialFrames` hides without Close.** `welcomeSeen` stays false, so the sheet can return next login. That matches “flag on Close only.” Call it intentional, not a miss.
2. **Footer band is empty.** CLOSE is in the title band (same 56×24 plate as the player card). Fine; the 40px footer is unused chrome.
3. **`applyFont` treats a nil `SetFont` return as failure** and falls through to `SetFontObject` (same trap as PlayerCard / Decree). Stock `GameFont*` may win in client even when the Theme path was set. Shared, not Welcome-only.
4. Isolated suite pins ASSEMBLY skip only. Implementation is `state ~= "QUIET"` (RITE / CONSEQUENCE included). Brief asked ASSEMBLY; no extra pin needed.
5. `test_db.lua` end `Runtime:ResetForTests` is extra hygiene so later Quiet suites do not inherit leftover ASSEMBLY. Report already names it. Assertions themselves are welcomeSeen / schema 7.

---

### Assessment

Contracted Wave 2 Task 4 pins are met: SCHEMA 7, Interface 20506, Variant A, Quiet one-sheet, Close-only `welcomeSeen`, Init-time skip without stamp, no congregation Ensure, no inbound Proclaim, no Director Console copy. Isolated welcome + DB pins match the brief. Residual stacking after Net comes up, and the missing in-game smoke, are follow-ups — not pin failures.

**Task quality:** Approved
