# Phase 0 Lane C — Architecture overview (rewrite)

Read first: `docs/reformation/phase-0/TEN_LAWS.md`, Bible §3, §13.1, §20, and current `.cursor/rules/architecture-overview.mdc` (you replace it).

## Mission

Rewrite `.cursor/rules/architecture-overview.mdc` so the always-on repo map describes the **Bible product**: Pope-authoritative star, ceremony runtime, module layers — not a standing ladder.

## Bible sections you implement

§3 (platform), §4.10, §13.1 (star), §13.4 (trust), §20 (runtime skeleton), §22.1 (what hangs on the skeleton). Audit §4 keepers for engineering layers.

## Exclusive file

- Rewrite: `.cursor/rules/architecture-overview.mdc`
- Report: `docs/reformation/phase-0/reports/C-architecture.md`

## Frontmatter

Keep `alwaysApply: true`. New description: star topology, ceremony runtime, module layers, Bible as product law.

## Must include

- Product one-liner: social ceremony / Gora / memory layer for TBC Anniversary (`## Interface: 20506`). Not raid/combat tooling. Not a points ladder.
- Product law table: Bible → Adjudication → Audit → handoff. `docs/superpowers/specs/*` and archived rules are historical.
- Layers (survive): UI→Core→Data and Net→Core→Data; never Core→UI. Core never `CreateFrame`. Data never reads SV. **Update the old “UI never awards points” line** to: UI never records official outcomes or invents ranks; Net never invents ranks or verdicts; only the Pope’s Core store is authoritative.
- Architecture: Pope client = single writer; congregation = display + inputs to the console; witnesses report, never rule (§13.1).
- Ceremony runtime states named only: QUIET → ASSEMBLY → RITE (typed) → CONSEQUENCE → ASSEMBLY/QUIET (§20). Detail belongs in `ceremony-runtime.mdc`.
- Repo map: `addon/ChurchOfBeef/` is on this workspace (not “docs-only main”). `docs/design/` is product law. `docs/archive/pre-reformation/` is retired law.
- Entry points may stay as lifecycle placeholders (`ADDON_LOADED` / `PLAYER_LOGIN` / `/beef`) but **must not** mention Sync-as-peer-authority, per-character standing, or Ladder/Scoring as the spine. SV: account-level `ChurchOfBeefDB` is the Bible direction (§13); do not re-assert SavedVariablesPerCharacter.
- Edit preferences: extend planned modules; TOC only lists existing files; do not invent product from `docs/research/` or the archive.
- Hard safety: no bots, injection, protected-action bypass, Retail-only APIs.

## Must not include

- Thresholds, standing, Grant, suggestions, Beef Prophet, officer-as-ritualist
- “design spec / Data/Ranks.lua win” as product law
- New module filenames you invent beyond existing keepers (BeefNet, Common, Roster, DB, UI shell)

## Do not

- Edit other rules
- `git commit`

## Report contract

Status, sections cited, what you removed from the old overview.
