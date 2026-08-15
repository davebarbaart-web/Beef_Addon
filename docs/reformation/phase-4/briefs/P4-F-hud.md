# Phase 4 Lane F — Fight HUD (no live health)

Read: Ten Laws 6, 8, 10; Bible §10.7, §19.2; `.cursor/rules/gora-sanction.mdc` (HUD); `.cursor/rules/ui-juice-standards.mdc`; `.cursor/rules/quiet-event-modes.mdc`. Appendix A #1 is **open** — defined fallback: everything except live health. Lanes C and D are signed.

## Exclusive files

- `addon/ChurchOfBeef/UI/Hud.lua` (create)
- `tests/test_hud.lua` (create)
- Report: `docs/reformation/phase-4/reports/P4-F-hud.md`

**Do not** edit TOC, bootstrap, `tests/run.lua`, MainFrame, Console, Toasts, Gora, Store, Net. **Do not** scrape nameplates, combat log, or health. **Do not** invent a favor INPUT channel.

## Mission

Test-first. Isolated suite with `wow_ui_stub` + Common + Runtime + Store + Gora + Hud. Standalone wrap.

**Mode:** Event Mode only. Show only when Runtime is not QUIET **and** `Gora:GetSanctioned()` is a live pair. Hide in Quiet. Top-center default, movable. Appears at sanction; gone when the pair clears or the machine returns to QUIET.

**Functional-spectator compact card** (Bible fields): both fighters — name, class color on the **name** only, level, Church title, W/L record from Store. Head-to-head line when Store has history. **No live health.** No damage meters. No odds copy.

Favor split is Bible-named but needs an INPUT channel (unspecified). Do **not** invent favor. Omit the bar.

No sound this lane (Phase 5). No toasts. No center-screen alert pulse — this is the HUD, not a WA pulse.

## Do not git commit.
