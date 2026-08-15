# Phase 0 Lane H — Quiet Mode / Event Mode

Read first: `docs/reformation/phase-0/TEN_LAWS.md`, Bible §4.8, §14.1–14.2, §19.1–19.5.

## Mission

Create `.cursor/rules/quiet-event-modes.mdc` so UI work cannot rebuild always-on standing feeds, grant pips, or ambient toasts (Audit V9).

## Bible sections you implement

§4.8, §14.1, §14.2, §19.1, §19.2, §19.4, §19.5, §24 filters 8–9. Law 6.

## Exclusive file

- Create: `.cursor/rules/quiet-event-modes.mdc`
- Report: `docs/reformation/phase-0/reports/H-quiet-event.md`

## Frontmatter

Description: Quiet vs Event contract; Decree bound; every feature declares a mode. Globs for UI + bootstrap. `alwaysApply: false` (architecture/ten-laws already always-on; this fires on UI).

## Must include

- Exactly two presentation states. Every feature **must declare** Quiet Mode or Event Mode.
- Quiet Mode: **at most** minimap presence + the active Decree. No feeds, dashboards, toasts, pips, sound, “now playing,” activity panels.
- Decree: single active proclamation; login banner once; thereafter minimap. Hard bound: no calendar, RSVP, reminders, recurring events, attendance tracking.
- Event Mode: theatrical — proclamations, cards, HUD, favor, outcomes, sound. Entered/exited **only** via ceremony runtime (§20).
- Rhythm: Quiet → Ritual Begins → Spectacle → Consequence → Quiet.
- Sound: Event Mode only; Quiet Mode silent absolutely. MVP cue names from §19.4 only (do not add ambient UI clicks).
- Onboarding: one parchment welcome, then silence. No config walls, tutorial popups, minimap fanfare.
- Scope filter: “just a small always-visible panel” is rejected.

## Do not invent

Decree deputy UX, extra Quiet Mode surfaces “for usability,” or toast kinds. Toast-engine restraint can be named as Event-Mode-only / rare system notices — do not specify a standing feed.

## Do not

- `git commit`
- Edit other files except the report

## Report contract

Status, sections cited, confirmation that ambient engagement surfaces are banned.
