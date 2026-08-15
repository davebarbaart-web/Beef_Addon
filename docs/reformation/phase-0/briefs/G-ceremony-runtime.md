# Phase 0 Lane G — Ceremony runtime + BeefNet v2 law

Read first: `docs/reformation/phase-0/TEN_LAWS.md`, Bible §20, §13.1, §13.4, §4.11.

## Mission

Create `.cursor/rules/ceremony-runtime.mdc` so Net/runtime work cannot rebuild peer SYNC_STATE authority or attendance-timesheet ceremonies (Audit V5, V7).

## Bible sections you implement

§20.1–20.4, §13.1, §13.4, §4.11 (Tuesday floor), §7 (SUMMON is one button, later phase). Transport keepers: Audit §4 BeefNet (throttle, inbound limits, framing, version discard) — name them as keep; do not specify new opcode names unless the Bible names the *kind*.

## Exclusive file

- Create: `.cursor/rules/ceremony-runtime.mdc`
- Report: `docs/reformation/phase-0/reports/G-ceremony-runtime.md`

## Frontmatter

Description: Pope-owned state machine, broadcasts, snapshots, degradation. Globs for Core/Net. `alwaysApply: false`.

## Must include

- States: QUIET → ASSEMBLY → RITE (Knighting / Gora / Confession / Proclamation) → CONSEQUENCE → ASSEMBLY or QUIET.
- **Pope client owns every transition.** Zero-setup start for small ceremonies. No event configuration required to begin.
- Broadcast: sequence-numbered, one-way from the Pope. Snapshot request/response over whisper for late join / reload.
- Congregation inputs (petition, favor, confession text) route to the Pope console only; they never trigger public theater.
- Theatrical UI only from registered Pope senders. Protocol version on every message; stale clients → Quiet Mode + gentle notice.
- Pope disconnect: hold, then “awaiting the Pope”; no client promotes itself; Pope console resumes from persisted event state.
- Inputs re-sendable; console deduplicates by character.
- Keep BeefNet transport discipline (prefix/channel/size/throttle/rate limits). Custom CHANNEL addon chat remains forbidden.
- No generic ceremony builder (Adjudication §5 rejected).

## Do not invent

Exact hold-timeout seconds, opcode strings, or snapshot schema. Omit or OPEN_QUESTIONS.

## Do not

- `git commit`
- Edit other files except the report

## Report contract

Status, sections cited, confirmation that peer-authority sync and auto-advance are banned.
