# Phase 0 Lane A — Archive the retired workspace law

Read first: `docs/reformation/phase-0/TEN_LAWS.md` and `docs/design/Demo_Build_Audit.md` (especially §1–2, §6.1, V1–V10).

## Mission

Archive (do **not** delete) the documents that encode the wrong product, so a future agent cannot treat them as law. Preserve git history for tracked files (`git mv`). Write a one-page `docs/archive/pre-reformation/WHY.md` explaining the turn, citing the Audit.

## Bible / Audit sections you implement

- Audit §1 executive verdict, §2 root cause, §6 step 1
- Handoff Phase 0 archive list
- Bible is **not** archived. `docs/design/` stays.

## Exclusive files / trees you may write

- `docs/archive/pre-reformation/**` (create)
- Move sources listed below **out** of their current homes into the archive
- Report: `docs/reformation/phase-0/reports/A-archive.md`

**Do not** edit `.cursor/rules` files you are not moving. **Do not** edit `README.md`, `AGENTS.md`, addon Lua, or `docs/design/`.

## Move these (git mv if tracked; otherwise move the file)

Into `docs/archive/pre-reformation/` keeping readable subfolders:

```
docs/superpowers/specs/*          → docs/archive/pre-reformation/specs/
docs/superpowers/plans/*          → docs/archive/pre-reformation/plans/
docs/canon/ranks.md               → docs/archive/pre-reformation/canon/ranks.md
docs/superpowers/ui-polished-direction-for-agents.md
                                  → docs/archive/pre-reformation/ui-polished-direction-for-agents.md
.cursor/rules/ladder-authority.mdc
.cursor/rules/scoring-coplay.mdc
.cursor/rules/canon-data.mdc
.cursor/rules/beefnet-messaging.mdc
```

Retired rules go to `docs/archive/pre-reformation/rules/`.

Leave `docs/superpowers/` as an empty-or-nearly-empty historical folder if needed; do not delete the folder if other non-listed files remain. If a listed path is missing, note it in the report — do not invent replacements.

## WHY.md requirements (one page)

- The demo was a well-engineered implementation of the wrong product (quote Audit §1).
- Root cause: workspace law predates Bible v1.1.1 and enforced a points-ladder (Audit §2).
- Cite V1–V10 by id in a short list (one line each).
- Point at `docs/design/Game_Design_Bible_v1.1.1.md` as the new product law.
- State that archived files are historical; they must not be followed.

## Do not

- `git commit`
- `git clean`, force-push, hard reset
- Touch addon code or tests
- Archive the Bible, Adjudication, Audit, or this Reformation tree

## Report contract

Write `docs/reformation/phase-0/reports/A-archive.md`: status (DONE / BLOCKED), exact paths moved, WHY.md path, any missing sources, Bible/Audit sections cited.
