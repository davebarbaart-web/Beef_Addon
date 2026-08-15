# Phase 0 Lane C — Adversarial Review

**Lane:** Architecture overview rewrite  
**Artifact:** `.cursor/rules/architecture-overview.mdc`  
**Lane report:** `docs/reformation/phase-0/reports/C-architecture.md`

**Spec:** PASS  
**Quality:** Changes required

Rule not edited. No Critical Bible contradiction.

## Verdict

The rewrite describes the Bible product: Pope-authoritative star, named §20 states, module layers, Bible-first law table. It does not restore standing, Ladder/Scoring, Sync-as-authority, per-character SV, archived specs as law, invented Core/Net filenames, or extra ceremony states.

Bible §13.1 “per-client SavedVariables” and account-level `ChurchOfBeefDB` do **not** conflict. No `OPEN_QUESTIONS` item.

One Important quality gap: the rule labels Director Console, Records Book, and Decree as “§22.1 Event Mode surfaces.” That bucket is wrong and can hide Quiet-legal tools behind ASSEMBLY.

## Attack results

| Attack | Result |
|---|---|
| Standing / ladder / Scoring / Sync-as-authority leftover? | **No.** Old spine is gone: no `COB.Sync:OnLogin()`, no `Core/Ladder.lua` / Scoring extend-preference, no “UI never awards points,” no tabs/toasts as the map. “Not a points ladder” is the required one-liner negation. |
| Product law still pointing at archived specs? | **No.** Authority table is Bible → Adjudication → Audit → handoff. `docs/superpowers/specs/*` and `docs/archive/pre-reformation/` are marked historical only (brief-mandated). No “design spec / Data/Ranks.lua win.” |
| Per-character SV re-asserted? | **No.** “SV direction: account-level `ChurchOfBeefDB`.” `SavedVariablesPerCharacter` is absent. TOC still declares PerCharacter — packaging, Lane J, not this rule. |
| §13.1 “per-client SavedVariables” vs account-level `ChurchOfBeefDB`? | **Compatible.** No contradiction invented. See below. Do not open a product question. |
| Invented module filenames beyond keepers? | **No.** Named files are brief keepers: `Core/Common.lua`, `Core/Roster.lua`, `Core/DB.lua`, `Net/BeefNet.lua`, UI shell. `ceremony-runtime.mdc` is the brief’s detail pointer, not a Lua module. |
| Ceremony states wrong or extra? | **No.** Named only: **QUIET → ASSEMBLY → RITE (typed) → CONSEQUENCE → ASSEMBLY or QUIET** (§20.1). Pope owns transitions (§20.2). No AWAITING_POPE / SANCTION / FAVOR state. §19.2 rhythm is not used as the machine. |

## §13.1 vs account-level (not a conflict)

§13.1’s “per-client SavedVariables” is the **platform constraint**: no server; each WoW client has its own SV; communication is rate-limited addon messages. One writer is the Pope’s client; congregation SV is not a second authority.

Account-level `ChurchOfBeefDB` is the **identity scope** of that client store: `## SavedVariables:` (one file per WoW account on that client), not `## SavedVariablesPerCharacter:`. Law 7 / §12.1 (rank belongs to the human); Audit V6 / §6.3; Handoff Phase 2.

These compose: no server + one writer per Pope client + account-wide store on that client. The rule states the account-level direction and does not re-assert PerCharacter. Writer correctly left this unopened.

## Findings

### Critical

None.

### Important

1. **Director Console, Records Book, and Decree are mislabeled “Event Mode surfaces”** (Law 6; §14.1; §14.2; §18; §19.1–19.2; §20.2; §22.1).  
   Ceremony block: “§22.1 Event Mode surfaces (Gora, fight HUD, Director Console, Knighting, Records Book, Decree) hang on this skeleton.”  
   §22.1 is the MVP component list, not a mode assignment. §19.2 Event Mode is proclamations, cards, HUD, favor, outcomes, sound.  
   - **Decree** is the one Quiet Mode feature beyond presence (§14.1, §19.1, Law 6).  
   - **Records Book / profiles** are browsable on a Tuesday (§14.2).  
   - **Director Console** is how the Pope starts an event from QUIET (§20.2, §4.11, §18). If it is Event Mode only, QUIET → ASSEMBLY has no actor.  
   Always-on text can override glob-scoped `quiet-event-modes.mdc` for Core/Net agents. Tighten: Event Mode theater hangs on the runtime; Console / Decree / Records Book are not Event Mode–only.

### Minor

2. **Account-level SV is cited as “Bible §13”** (§12.1; §13.1; Audit §6.3; Handoff Phase 2).  
   Substance is correct. §13.1 is per-client / no-server / Pope store. Account-vs-character scope is §12 + Audit / Phase 2. A loose cite plus §13.1’s “per-client” wording is how a later agent re-derives PerCharacter. Prefer “§12 + Audit §6.3; per-client in §13.1 means no server.”

3. **Lane report still says `ceremony-runtime.mdc` does not exist.** Lane G has landed. Stale process note only.

## Confirmed (not findings)

| Check | Result |
|---|---|
| Frontmatter `alwaysApply: true`; description = star / runtime / layers / Bible | Holds |
| One-liner: ceremony / Gora / memory; `20506`; not raid tooling; not a points ladder | Holds |
| Layers + official-outcomes / verdicts / Pope-store line | Holds (brief replacement of “UI never awards points”) |
| Star: one writer; congregation display+input; witnesses report, never rule; one-way seq broadcast; §13.4 sender / free-text / version→Quiet | Holds |
| Repo map on workspace `addon/ChurchOfBeef/`; `docs/design/` law; archive retired | Holds |
| Entry points are lifecycle placeholders; Sync login path removed | Holds |
| Hard safety: no bots / injection / protected-action bypass; Lua/XML; no Retail-only APIs; §3.2 guarded reads | Holds |
| No thresholds, Grant, suggestions, Prophet, officer-as-ritualist | Holds |
| No new OPEN_QUESTIONS; no commit; rule not edited this review | Holds |

## Sections checked

- `docs/reformation/phase-0/TEN_LAWS.md` (Laws 1, 5, 6, 7)
- `docs/reformation/phase-0/briefs/C-architecture.md`
- `docs/reformation/phase-0/reports/C-architecture.md`
- `.cursor/rules/architecture-overview.mdc` (full, vs committed pre-rewrite)
- Bible §3.1–3.2, §4.10, §12.1, §13.1, §13.4, §14.1–14.2, §18, §19.1–19.2, §20.1–20.2, §22.1
- Audit V6, V7, §4 keepers, §6.3
- Handoff §0 authority stack; Phase 2 account-level SV
- `docs/design/OPEN_QUESTIONS.md` (nothing appended by this lane)
