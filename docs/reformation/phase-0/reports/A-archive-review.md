# Phase 0 Lane A — Adversarial archive review

**Spec compliance:** PASS
**Quality:** Changes required

Critical WHY.md canon error found and corrected in this review (one sentence). Move contract holds. Residual Important wording in WHY.md § "The turn" still echoes Audit §1's two-invention claim.

## Verdict

The listed sources were **moved, not deleted**. Bible / Adjudication / Audit remain in `docs/design/`. The four retired domain rules are **gone** from `.cursor/rules/` and live under `docs/archive/pre-reformation/rules/`. Tracked moves show as `R` / `RM` (git rename). Untracked listed files were `mv`'d. No commit. Reformation tree not archived.

WHY.md does not treat archived files as law and does not invent a new product. As submitted, it **did** contradict Bible v1.1.1 §5 by calling Beef Butcher invented. That sentence is now fixed. A weaker form of the same claim remains in the narrative paragraph.

## Critical

1. **WHY.md V2 restated Audit's stale "invented Butcher" as current canon.** (Bible §5 "Beef Butcher — The Raiding Team"; Bible "What Changed in v1.1.1"; Law 9; Audit V2 / §4 `Data/Ranks.lua` row / §7.2 — all superseded on the *name*.)
   - Submitted text: `invented Beef Butcher / Beef Prophet`.
   - Bible v1.1.1: Butcher is confirmed canon — a real Church rank / role designation reserved for the Raiding Team; previously misidentified in the audit as an agent invention. Prophet is the invented rank. The old law's *grind-capstone Butcher* is what was wrong.
   - **Fixed this review (that sentence only):** V2 now says invented Prophet; grind-capstone Butcher is the error; the name is canon as a raid-team role (Bible §5).
   - No other archived file or rule was edited.

## Important

1. **WHY.md "The turn" still says "a seven-rank linear ladder including invented ranks."** (Bible §5; v1.1.1 changelog; Audit §1.)
   - Audit §1's "two invented ranks" was Butcher + Prophet. After v1.1.1 only Prophet is invented. The seven-rung demo ladder included Butcher as a points capstone — wrong *treatment*, not an invented *name*. Left unedited (reviewer limited to the Critical sentence).

2. **WHY.md stacks Audit as tertiary product law with no v1.1.1 supersession note.** (Bible §5 vs Audit §4 "no Butcher" / §7.2 "Butcher dies".)
   - The stack matches `CURSOR_REWORK_HANDOFF.md` §0 (Bible wins on conflict). After the V2 fix, WHY.md itself no longer re-bans the name. An agent who then reads Audit §4/§7 as law can still re-import the stale ruling. Out of Lane A to patch the Audit.

## Minor

1. **Two tracked archives are `RM` (rename + modify), not a clean `git mv`:** `2026-07-25-church-of-beef-v1.md`, `2026-07-25-church-of-beef-design.md`. The diffs are the 2026-08-01 truth-pass / leap-forward edits already in the working tree; they traveled with the move. Not a post-archive rewrite. History still preserved.

2. **`docs/research/**` still cites `docs/superpowers/specs|plans|ui-polished-…` as "product law" / "Approved V1 spec."** Research is not law (`architecture-overview.mdc`, `AGENTS.md`). Broken links and stale "approved spec" labels can still lure a careless agent. Out of Lane A exclusive files.

3. **Lane A report (`A-archive.md`) did not catch the WHY.md Butcher slip.** Move table itself is accurate.

## Confirmed (not findings)

| Check | Result |
|-------|--------|
| `docs/superpowers/specs/*` → `docs/archive/pre-reformation/specs/` (5 files) | Moved; source dir empty |
| `docs/superpowers/plans/*` → `docs/archive/pre-reformation/plans/` (5 files) | Moved; source dir empty |
| `docs/canon/ranks.md` → `docs/archive/pre-reformation/canon/ranks.md` | `git mv`; source `docs/canon/` empty |
| `ui-polished-direction-for-agents.md` | Moved to archive root |
| Four domain rules → `docs/archive/pre-reformation/rules/` | Present; absent from `.cursor/rules/` |
| `docs/design/Game_Design_Bible_v1.1.1.md` | In place |
| `docs/design/Peer_Review_Adjudication.md` | In place |
| `docs/design/Demo_Build_Audit.md` | In place |
| `docs/reformation/` | Not archived |
| WHY.md: Audit §1 quote, §2 root cause, V1–V10 list, Bible as law, "historical / must not be followed" | Present |
| Addon / tests / commit | Untouched / no commit |

## Sections checked

- Brief `A-archive.md` (mission, move list, WHY.md contract, do-nots, report contract)
- Report `A-archive.md` (paths, missing-sources claim, left-in-place list)
- `TEN_LAWS.md` Law 9
- `CURSOR_REWORK_HANDOFF.md` §0 authority stack, §3 Phase 0 archive list
- Audit §1, §2, §3 V1–V10, §4 retire rows, §6 step 1, §7.2 Butcher/Prophet ruling
- Bible "What Changed in v1.1.1"; §5 (full rank set, Butcher as raid-team role)
- WHY.md (full)
- Archive tree vs empty `docs/superpowers/{specs,plans}` and `docs/canon/`
- `.cursor/rules/` (retired four gone; engineering + new Phase 0 rules remain)
- `docs/design/` (Bible, Adjudication, Audit, OPEN_QUESTIONS)
- git status rename detection on tracked sources
