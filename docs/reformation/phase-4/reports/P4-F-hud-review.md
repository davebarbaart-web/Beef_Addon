# Phase 4 Lane F — Adversarial Review

**Lane:** Fight HUD (no live health)
**Exclusive files:** `addon/ChurchOfBeef/UI/Hud.lua`, `tests/test_hud.lua`
**Lane report:** `docs/reformation/phase-4/reports/P4-F-hud.md`
**Cited law:** Ten Laws 6, 8, 10; Bible §10.7, §19.2; `.cursor/rules/gora-sanction.mdc` (HUD); `.cursor/rules/ui-juice-standards.mdc`; `.cursor/rules/quiet-event-modes.mdc`; brief `docs/reformation/phase-4/briefs/P4-F-hud.md`
**Writer:** [HUD](f5e7b876-de7a-4b48-9243-87111a88b7f9)

**Spec:** PASS
**Quality:** Approved

Event Mode spectator card only. `Hud.MODE = "Event"`. Show when Runtime is not QUIET **and** `Gora:GetSanctioned()` is a live pair. Hide in Quiet, and when the pair clears. Both fighters: name (class color on the name only), level, Church title from Store + `Ranks.Title`, Store W/L. Head-to-head line when Store already has history. No live health, nameplate scrape, combat-log scrape, favor bar, favor INPUT, sound, toast, or WA center pulse. Top-center default (`TOP` / `TOP` / `0` / `-24`), movable, clamped. Isolated suite: **226 passed, 0 failed**. Writer stayed inside exclusive files. Integrator listed `UI/Hud.lua` and `test_hud` after the writer. `OPEN_QUESTIONS.md` #2 unanswered. No `Data/Popes.lua`. No commit. This review did not invent favor, live health, or a Pope list, and did not edit `Hud.lua` or the suite.

## Verdict

Refutation of Laws 6, 8, 10, Bible §10.7 / §19.2, and “no health scrape / no favor INPUT / Event Mode only” **fails** for this lane’s exclusive files.

Law 6 is intact. The surface declares Event Mode. `Refresh` paints only when `Runtime:Snapshot().state ~= "QUIET"` and `GetSanctioned()` has both fighter ids. QUIET, ASSEMBLY without a pair, and a cleared pair hide the widget. Reviewer: a stubbed leftover pair while QUIET still hides. `awaitingPope` with a live pair stays shown — that is Event Mode degraded, not Quiet chrome. No toast, pip, sound, or always-visible Tuesday panel.

Law 8 is intact. The card reads Store records (W/L, head-to-head). It does not start a duel, scrape health, parse the combat log, mint a meter, emit odds, or score favor. Combat remains WoW’s.

Law 10 is intact on the terms the brief set. This is a compact spectator card, not a joke surface and not a WA pulse. Class tint is on names only. Level, title, record, and “VS” stay parchment or muted. Unlinked characters get no invented Fresh Beef. `Ranks.Title` `"Unknown"` is omitted. Charcoal panel + muted-gold border when `BackdropTemplate` is present; stock `GameFont*` otherwise. Missing backdrop methods do not fail load. `POLISH:CANDIDATE` only.

§10.7’s compact fields that this lane may paint are present. Live health stays out (Appendix A #1 open; defined fallback). Favor stays out (INPUT unspecified — do not invent a channel). Defense count stays out (Store still nils `defenses` / `defenseCount`; `#9` is not this paint). The Bible’s “persists through the verdict beat” is overridden by the brief: gone when the pair clears. Lane C clears the pair on a ruling, so the card exits at ratification. Writer disclosed that. Do not “fix” it here.

§19.2 is intact. The HUD does not enter or exit Event Mode. It keys off the runtime plus a sanctioned pair. When the machine returns to QUIET, Event chrome goes.

This review did not invent a favor INPUT channel, a health scrape, or a Pope list, and did not commit.

## Confirmations

| Check | Result |
|---|---|
| Event Mode only; show when not QUIET + live `GetSanctioned` pair; hide in Quiet / when the pair clears | **Yes.** `MODE = "Event"`. `eventLive()` is `Snapshot().state ~= "QUIET"`. `livePair()` requires both `fighterA` and `fighterB`. Suite: QUIET hidden; ASSEMBLY without a pair hidden; characters alone hidden; sanction shows; `DeclareVictor` hides mid-event; `EndEvent` hides. Reviewer: QUIET + stubbed pair still hidden; incomplete pair hidden; missing Runtime / missing `GetSanctioned` hidden; `Restore` QUIET expires the pair and hides. |
| Both fighters: name (class color on name only), level, title, Store W/L; head-to-head when Store has history | **Yes.** Names and levels from Store. `RAID_CLASS_COLORS` on `nameA` / `nameB` only. Title via `Store:RankForCharacter` + `Ranks.Title`; unlinked stays empty, not Fresh Beef. W/L is `gora.wins`-`gora.losses`. Head-to-head is fighter A’s Store row when `fights > 0` (`"1-0"`), hidden otherwise. No “meeting” / odds copy. Stipulation is not painted (reviewer). |
| No live health, nameplate / combat-log scrape, favor bar, sound, toast | **Yes.** `GetView().health` / `.favor` always nil. No `UnitHealth`, `COMBAT_LOG`, `NamePlate`, `C_NamePlate`, `StatusBar`, `PlaySound`, `Toasts`, `SendChatMessage`. No `Hud.Favor` / `SendFavor` / `INPUT` / `GetHealth` / `ScrapeHealth`. Scripts are drag only — no `OnClick` / `OnEnter` / `OnUpdate`. Suite stubs stay at 0. Reviewer source grep also clean for `UnitHealthMax`, `CombatLog`, `PlaySoundFile`, `SetMinMaxValues`, `CreateTexture`. |
| Not a WA center pulse; top-center movable | **Yes.** Default `TOP` / `UIParent` / `TOP` / `0` / `-24`. Movable, clamped. Drag writes `ChurchOfBeefDB.ui.hud` point fields only (no frame reference). Invalid saved point falls back to top-center. `SetFrameStrata("HIGH")` is a card, not an alpha pulse. ui-juice: do not ban this as “center-screen.” |
| Isolated suite green | **Yes.** Reviewer rerun, Lua 5.1.5: `lua tests/test_hud.lua` → **226 passed, 0 failed**. Loads wow_ui_stub + Common + Ranks + Store + Runtime + Gora + Hud. Isolation asserts in `if standalone then`. Writer count matches. Full harness (integrator list): **5248 / 0**. |
| Writer did not edit TOC / bootstrap / `run.lua` / MainFrame / Gora / Store | **Yes.** Transcript Writes: `tests/test_hud.lua` (first), `UI/Hud.lua`, this lane’s report. StrReplace: suite only. Mtimes: Hud 07:28:51, suite 07:28:34, report 07:29:21. TOC / `run.lua` 07:29:32 list `UI\Hud.lua` / `test_hud` — integrator, after the writer. Bootstrap 21:25 Aug 14; MainFrame 21:43 Aug 14; Store 22:07 Aug 14; Gora 07:16 (Lane C). No `Hud:Init` / `Hud:Refresh` in bootstrap, MainFrame, or Console. No commit (`Hud.lua` still untracked). |

## Attack results

| Attack | Result |
|---|---|
| Law 6 — hidden frame after `Init` is an always-visible Tuesday panel? | **No.** `build()` ends `Hide`. Quiet `Refresh` calls `paintHidden`. A Tuesday login that called `Init` would still show nothing. Integrator has not called `Init` yet. |
| Law 6 — `awaitingPope` / Knighting rite with a live pair is Quiet chrome? | **No.** `awaitingPope` is Event Mode degraded (ceremony-runtime). Knighting + pair still keys off pair + not QUIET, as the brief wrote. No pair → hidden even in ASSEMBLY / RITE. |
| Law 6 — QUIET Restore leaves a leftover pair and the HUD stays up? | **No.** `GetSanctioned` expires on QUIET. Reviewer: `Restore` QUIET → pair nil → hidden. Even a stubbed leftover pair while QUIET stays hidden (`eventLive` is false). |
| Law 6 — first `Refresh` with no frame auto-`Init`s a visible flash? | **No.** `Init` builds hidden, then `Refresh`. No `OnUpdate`. No toast trap fire. |
| Law 8 — Store W/L / head-to-head is combat analytics / ELO? | **No.** Bible-named records. No duration, DPS, class win rate, rating, or odds. `view.odds` / `headToHead.score` are nil. |
| Law 8 — fallback “everything except live health” still scrapes HP another way? | **No.** No unit/nameplate/combat-log/tooltip health API. No `StatusBar`. No `CreateTexture` meter. Suite `healthReads == 0`. |
| Law 8 — `EnableMouse` + name click is betting / favor? | **No.** Drag persist only. `OnClick` / `OnEnter` nil. `Hud.INPUT` nil. Favor omitted. |
| Law 10 — `GameFont*` + tooltip border is stock chrome on theater, so fail? | **No as this lane.** Brief: “functional-spectator compact card.” Writer applied charcoal / muted gold / parchment ink and claimed `POLISH:CANDIDATE`. Custom media must not fail load. Not a joke surface. Not Changes required. |
| Law 10 — class color leaks onto title / level / record / VS / H2H? | **No.** Suite + reviewer: those widgets are not Warrior/Mage tinted. H2H has no class tint. |
| Law 10 / Law 4 — “VS” or head-to-head `"1-0"` is generated flavor (“rubber match”)? | **No.** Structural chrome and a Store record. Stipulation `"no pots"` is not painted. `Narrate` / `Announce` nil. Cards stay mute. |
| §10.7 — missing live health / favor / defense count is a spec fail? | **No.** Appendix A #1 open; brief fallback is everything except live health. Favor needs an INPUT channel — brief: omit the bar. Defenses are stripped by Store (`#9`). Do not invent any of the three. |
| §10.7 — hide on ruling violates “persists through the verdict beat”? | **No as this lane.** Brief: gone when the pair clears or the machine returns to QUIET. Lane C clears on a ruling. Writer leftover, not a Hud.lua bug. Do not keep the card after `GetSanctioned()` is nil. |
| §19.2 — HUD starts Event Mode / stays up after QUIET? | **No.** No Runtime verbs. `EndEvent` / QUIET `Refresh` hides. The HUD does not ring the Sanction bell (Phase 5). |
| “No favor INPUT” — Codec still has favor, so this surface is the channel? | **No.** No send, no inbox, no pick-a-side click, no split bar. `view.favor` is always nil. Channel remains unspecified. |
| “Event Mode only” — `state ~= "QUIET"` treats a nil `state` as live? | **Coverage only.** Reviewer stub `{ state = nil }` can show if a pair is also forced. Production `Snapshot()` always has a named state. Brief is “not QUIET,” not an allowlist. Do not add a sixth state here. |
| Writer invented health / favor / a Pope list, edited forbidden files, or committed? | **No.** Exclusive Writes only. No `Data/Popes.lua`. `#2` still says Appendix A item 1 decides HUD final form. No commit. |

Refutation of Law 6 (Quiet contract; Event chrome gone in QUIET), Law 8 (unmodified duel; no scrape / meters / odds), Law 10 (hybrid law; class color on names only; UI never jokes), Bible §10.7 (compact card; fallback without live health; no invented favor or defense paint), §19.2 (theater hangs on the runtime), and “no health scrape / no favor INPUT / Event Mode only” **fails** for the exclusive files.

## Leftovers (other lanes — expected; not fixed)

Writer leftovers are current except the integrator listing (already done).

### Integrator (listing landed — wiring did not)

- `ChurchOfBeef.toc` lists `UI\Hud.lua` after `MainFrame.lua`. Interface stays `20506`. Writer did not edit TOC.
- `tests/run.lua` lists `test_hud`. Writer did not edit it. Full harness **5248 / 0**.
- Bootstrap / MainFrame / Console still do not call `Hud:Init` or `Hud:Refresh`. The file can load; the card will not appear until someone paints after sanction / ruling / runtime transitions. That is still this leftover. Do not treat the TOC line as in-game smoke.

### Appendix A #1 / favor / defenses (do not invent here)

- `OPEN_QUESTIONS.md` #2 / Appendix A item 1: live health stays out. No nameplate or combat-log workaround.
- Favor split is Bible-named and needs an INPUT channel. Omit the bar. Do not invent the channel or a Pope toggle this lane.
- Defense count is Bible-named on the HUD. Store still strips `defenses` / `defenseCount` (`#9`). Not painted.

### Bible §10.7 verdict beat (brief wins)

- Bible: persists through the verdict beat; exits with the consequence. Brief + Lane C: hide when `GetSanctioned()` is nil, including mid-CONSEQUENCE after a ruling. Do not reopen as a Hud.lua defect.

### Net / congregation / other surfaces

- This HUD reads local Runtime + Gora + Store. A congregation client stays blank until that client has a live pair. Do not invent Net paint or a Pope list here.
- Sound is Phase 5. Mute fighter cards, Director Console, Records Book, and Decree are other surfaces.
- `POLISH:CANDIDATE` only. No `/reload` smoke — wiring is not this lane. A human Gathering (Bible §22.3) was not run.

### Out of scope (do not invent here)

- Favor INPUT, live health, Pope list, defense increment, odds copy, WA pulse, Quiet chrome.

## Findings

### Critical

None. No one-line Law 6, 8, 10, §10.7 / §19.2, health scrape, favor INPUT, or Quiet-surface breach in the exclusive files.

### Important

1. **Listing is not wiring.** TOC / `run.lua` already name the file. Nothing calls `Refresh` after Sanction / ruling / `EndEvent`. Until that lands, the card never appears and never hides from a live client. Correct for this lane. Do not add `Hud:Init` in review.

2. **Hide-on-ruling is the brief, not a miss.** Congregation theater will drop at ratification, not at `EndEvent`. If a later lane wants the Bible’s verdict-beat persist, that is a product call — do not keep painting after `GetSanctioned()` is nil in this file.

3. **Local Core only.** Congregation display depends on the Pope-authoritative pair existing on that client. This lane must not open a Net path or a Pope list to “fix” a blank congregation HUD.

### Nit

1. **Writer leftover map is stale** (`P4-F-hud.md`). `tests/run.lua` already lists `test_hud`; TOC already lists `UI\Hud.lua`. Integrator, not a writer miss. Wiring leftover is still live.

2. **`state ~= "QUIET"` is the brief, not an allowlist.** Reviewer: a crafted nil `state` can show. Production Snapshot always names a state. Do not add `AWAITING_POPE` as a sixth name.

3. **Missing Store still shows a blank pair.** Reviewer: names `""`, W/L `0-0`, `health` / `favor` nil. Fail-open display given a live pair. Honest TOC loads Store first.

4. **Career W/L and head-to-head both paint `"1-0"`.** Distinguished by slot (beside level vs bottom). Mute is correct — do not add “meeting” copy.

5. **`EnableMouse(true)` makes the 420×80 card a click catcher while shown.** Drag requires it. Not favor INPUT. Not Quiet chrome.

6. **Stock `GameFont*` on a theatrical card.** Brief asked for a compact spectator surface; writer claimed `POLISH:CANDIDATE`. In-game polish is later.

7. **Suite does not lock QUIET + stubbed leftover pair, missing Runtime/Gora, or stipulation-not-painted.** Reviewer probes confirm all three. Coverage gaps only.

## Brief contract

| Requirement | Result |
|---|---|
| Test-first; isolated wow_ui_stub + Common + Runtime + Store + Gora + Hud; Ranks dofiled for titles; standalone wrap | Met (226 / 0). Transcript: suite first, then `Hud.lua`. |
| Event Mode only; show when not QUIET + live `GetSanctioned` pair; hide in Quiet / when pair clears | Met |
| Both fighters: name, class color on the name only, level, Church title, Store W/L | Met |
| Head-to-head when Store has history; no odds / meeting narration | Met |
| No live health; no nameplate / combat-log scrape | Met |
| Do not invent favor INPUT; omit the bar | Met |
| No sound, no toasts, no WA center pulse; top-center movable | Met |
| Do not edit TOC / bootstrap / `run.lua` / MainFrame / Console / Toasts / Gora / Store / Net | Met (integrator listed after) |
| Isolated `test_hud.lua` must pass | Met (226 / 0) |
| No commit; do not invent product / OPEN_QUESTIONS answers | Met |

## Sections checked

- `docs/reformation/phase-0/TEN_LAWS.md` Laws 6, 8, 10
- Brief `docs/reformation/phase-4/briefs/P4-F-hud.md`
- Writer report `docs/reformation/phase-4/reports/P4-F-hud.md`
- Bible §10.7, §19.2 (also §10.6 favor, §19.1 Quiet, §19.3 hybrid, Appendix A #1 — not rebuilt)
- `.cursor/rules/gora-sanction.mdc` (Fight HUD)
- `.cursor/rules/ui-juice-standards.mdc`
- `.cursor/rules/quiet-event-modes.mdc`
- `addon/ChurchOfBeef/UI/Hud.lua`
- `tests/test_hud.lua` (isolated run: 226 / 0)
- `addon/ChurchOfBeef/Core/Gora.lua` `GetSanctioned` / `_Expire` (read only; mtime 07:16)
- `addon/ChurchOfBeef/Core/Store.lua` W/L / `headToHeads` / stripped defenses (read only; mtime Aug 14)
- `addon/ChurchOfBeef/Core/Runtime.lua` Snapshot / QUIET (read only)
- Writer transcript ([HUD](f5e7b876-de7a-4b48-9243-87111a88b7f9)) — exclusive Writes only
- `ChurchOfBeef.toc` / `tests/run.lua` (integrator listing; writer did not edit)
- `ChurchOfBeef.lua` / `UI/MainFrame.lua` / `UI/Console.lua` (no `Hud:` callees)
- `addon/ChurchOfBeef/Data/` (no `Popes.lua`)
- `docs/design/OPEN_QUESTIONS.md` (writer did not edit; #2 unanswered)
- Full harness: 5248 / 0
- Reviewer probes (throwaway; suite not edited): QUIET + stubbed pair hides; missing Runtime/Gora hide; QUIET Restore expires pair; incomplete pair hides; missing Store shows blank names without health/favor; no OnClick/OnEnter/OnUpdate; Frame not StatusBar; source scrape/sound/bar tokens absent; VS/H2H not class-tinted; GetView H2H is a copy; stipulation not painted; no `Data/Popes.lua`
