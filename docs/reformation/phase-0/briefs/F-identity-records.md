# Phase 0 Lane F — Identity and records (never-delete)

Read first: `docs/reformation/phase-0/TEN_LAWS.md`, Bible §12, §13.5, §17.

## Mission

Create `.cursor/rules/identity-records.mdc` so identity work cannot rebuild per-character standing or 14-day departed sweeps (Audit V6).

## Bible sections you implement

§12.1–12.5 (hybrid identity, Rite of Recognition, permanence, edge cases, aggregation), §13.5 (Sacred Archive), §17 (public/private, curtain). Law 7.

## Exclusive file

- Create: `.cursor/rules/identity-records.mdc`
- Report: `docs/reformation/phase-0/reports/F-identity-records.md`

## Frontmatter

Description: account-level identity, human-confirmed linking, never-delete, Archive. Globs for Core/DB/Data and docs about records. `alwaysApply: false`.

## Must include

- Human owns: Church rank, Council, honorifics, membership history, aggregate identity.
- Character owns: name, class, level, professions, **Gora record**, gameplay history.
- **No self-service linking.** Rite of Recognition: Pope or Council confirms with the logged-in character (ritualized).
- History is never deleted: tombstones / inactive flags only; no prune, no departed sweep, no record expiry.
- Account-level SavedVariables (`ChurchOfBeefDB` per account, not per character) is the Bible direction.
- Name reuse / impersonation: identity is more than a name string; human confirmation is the guard. Shared accounts: no machinery (Pope resolves socially).
- Sacred Archive: one-action export/import, restore, integrity; weekly reminder in **cold** state only; Council cold mirror is read-only disaster recovery, not a second writer.
- Privacy: record events not behavior; no activity leaderboards; members see their own record; Curtain opt-out for displayed witnessed activity except rank / Knighting / sanctioned Gora results.
- Pope’s Notebook is private (§18.3 / §17).

## Do not invent

Curtain UX widgets, export file format, or migration of the old per-character DB (Phase 2). If tempted, OPEN_QUESTIONS.

## Do not

- `git commit`
- Edit other files except the report

## Report contract

Status, sections cited, confirmation that sweeps/self-link/per-character-as-law are banned.
