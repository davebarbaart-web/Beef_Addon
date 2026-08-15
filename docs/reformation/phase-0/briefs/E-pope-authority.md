# Phase 0 Lane E — Pope authority (+ rewrite officer-guild-roster)

Read first: `docs/reformation/phase-0/TEN_LAWS.md`, Bible §5 (guild-rank mapping), §6, §8, §13, §18.

## Mission

1. Create `.cursor/rules/pope-authority.mdc` — ceremonial sovereignty and star-authority.
2. Rewrite `.cursor/rules/officer-guild-roster.mdc` so it no longer encodes “officers perform rituals / never call guild promote APIs / officer-index is the Church.” Keep Classic roster API edges that remain true.

## Bible sections you implement

§5 (display vs truth), §6 (sovereignty; Council supports operations not rituals), §8 (KNIGHT THIS BEEF), §13.1–13.4, §18.1–18.3. Audit V3.

## Exclusive files

- Create: `.cursor/rules/pope-authority.mdc`
- Rewrite: `.cursor/rules/officer-guild-roster.mdc`
- Report: `docs/reformation/phase-0/reports/E-pope-authority.md`

## pope-authority.mdc

Frontmatter: description of Pope/Council split + registered-Pope senders; globs for Core/Net/UI; `alwaysApply: false`.

Must include:

- Pope actions (not delegable as rituals): Knighting, sanction, verdicts, elevation, canonization, major proclamations. One-click verbs on the Director Console.
- Council/officers: operations, logistics, non-ceremonial correction as the Bible allows. They do **not** close ceremonies or knight.
- Software proposes; Pope ratifies. No auto-declare, auto-advance, auto-announce in the Pope’s voice, no generated narration.
- Star: one writer (Pope client). Theatrical UI renders only from registered Pope character senders (§13.4). Player free text → Pope console only.
- KNIGHT THIS BEEF: Church record + guild-rank promotion **where the API permits** + proclamation + queue advance **on command** (never auto).
- Guild rank = public display; Church store = truth; reconcile drift; ask the Pope when ambiguous (§5).
- No Pope, no rituals. Data does not decay while he is offline.

## officer-guild-roster.mdc rewrite

Keep: 0-based `rankIndex`, `C_GuildInfo.GuildRoster()` / 10s throttle, wait for `GUILD_ROSTER_UPDATE`, realm-qualified names, do not flip `SetGuildRosterShowOffline`.

Remove/replace: Officer+ as ritual gate; “addon must not call guild promote/demote APIs” as a blanket ban (Bible requires promote-where-permitted on KNIGHT THIS BEEF — guard it, don’t forbid the verb); standing correction; independent ladders-as-product; “not in a guild → pause scoring.”

Retarget: roster sensing serves Presence desk and display-vs-truth mapping. Authority checks for **theater and writes** are registered-Pope (and Council for the operational subset the Bible names), not `rankIndex ≤ 1`.

Do not invent the registered-Pope configuration UX.

## Do not

- `git commit`
- Touch other rules

## Report contract

Status, sections cited, list of old officer-rule sentences you deleted.
