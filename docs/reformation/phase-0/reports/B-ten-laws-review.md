# Phase 0 Lane B — Adversarial Ten Laws review

**Spec compliance:** FAIL
**Quality:** Changes required

Two Critical always-on collisions found (Law 1 bare “streaks” vs Bible §10.9; Law 7 bare “no pruning” vs Bible §5). “Bible wins” on line 8 is not enough. Reviewer added the two authorized clarifying clauses to `.cursor/rules/ten-laws.mdc`. No new law. No commit. No OPEN_QUESTIONS invented.

## Verdict

Lane B delivered the required always-on file: frontmatter, Bible-as-law opener, numbered Ten Laws with TEN_LAWS.md cites, hard-safety paragraph, OPEN_QUESTIONS pointer. It did not soften a ban with “except,” and it did not invent product.

As submitted, Laws 1 and 7 still **contradict the Bible** when read as stop-words. Line 8 (“On conflict, the Bible wins”) does not repair an unambiguous ban whose own cites never reach the colliding sections. Lane I already had to encode the streaks distinction because Law 1 would refuse §10.9.

After the two clauses, those Criticals are closed. Residual Important: Law 6’s Quiet Mode list is handoff-faithful and thinner than cited §4.8 / §19.1.

## Critical

1. **Law 1’s bare word “streaks” refuses Bible §10.9 fight-record streaks.** (Bible §4.6, §10.4, §10.6, §10.9; TEN_LAWS.md Law 1; `ten-laws.mdc` Law 1 as submitted; Lane I report concern.)
   - Submitted Law 1: “No points, XP, currencies, dailies, **streaks**, thresholds, or engagement scoring of any kind.” Cites §4.6, §4.9 only.
   - Bible §4.6 bans **engagement streaks**. Bible §10.6 bans **favor streaks**. Bible §5 / §10.4 require post-Lord **streaks** as record prestige. Bible §10.9 requires character-level streaks and MVP Records Book category **Longest Streak** (also The Undefeated).
   - An always-on agent will treat “streaks” as a refuse-and-stop token and will not implement Longest Streak, current-streak display, or unbeaten-record pages.
   - **“Bible wins” on line 8 is not enough.** It only helps if the agent already suspects a conflict. Law 1’s cite trail never reaches §10.9. Always-on rules fire before agents open the Bible. Lane I (`reports/I-records-not-points.md`) already recorded this collision.
   - This is **Critical (rule contradicts Bible)**, not a comment-level nit.
   - **Fixed this review (one clause, no new law):** Law 1 now cites §10.6 / §10.9 and states that “streaks” here means engagement and favor economies, not fight-record streaks or Records Book Longest Streak (narrative record, not an economy).

2. **Law 7’s “no pruning” refuses Bible §5 Council exit and misreads Fresh Beef purges.** (Bible §5 Fresh Beef / Council exit; §12.3; TEN_LAWS.md Law 7; `ten-laws.mdc` Law 7 as submitted.)
   - Submitted Law 7: “Church history is never deleted. **No pruning**, no departed-member sweeps, no record expiry.” Cites §12 only.
   - Bible §12.3: Church **history** is never deleted; leave-and-return finds the record intact; rank restoration is a human call; character records survive the character.
   - Bible §5: “the Council must be **prunable** by the same human judgment that appoints it.” That is a role change, not a history wipe. The fact of having been Council remains.
   - Bible §5 Fresh Beef: inactive Fresh Beef may be removed in Beef Purges; **other addons handle recruit/mass-removal; this addon does not duplicate them.** Guild-roster removal is not Church-history deletion. This addon must not sweep the Church record when another addon purges the guild roster.
   - An always-on agent will refuse a human “leave Council” verb as pruning, and may refuse tombstone/inactive on guild leave as a departed-member sweep — or, conversely, invent a Church-side Fresh purge. `identity-records.mdc` has more nuance but is **not** always-on.
   - **“Bible wins” is not enough.** Law 7 cites §12 only; the agent never sees §5.
   - **Fixed this review (one clause, no new law):** Law 7 now cites §5 and states: history is never deleted; human Council exit is a role change; Fresh Beef guild purges are other addons; this addon does not sweep Church records; guild-roster removal is not history deletion.

## Important

1. **Law 6 Quiet Mode list is thinner than the sections it cites.** (Bible §4.8, §19.1, §19.4; TEN_LAWS.md Law 6.)
   - Law 6 / handoff: no feeds, toasts, pips, or ambient surfaces.
   - §4.8: no feeds, **dashboards**, toasts, or **sound**.
   - §19.1: no **bars**, feeds, toasts, or **sound**. Quiet Mode is silent (§19.4).
   - Handoff-faithful, not a “no X except” softening. Still a gap: an agent following only Law 6 can ship a Quiet Mode dashboard, bar, or sound. Left unpatched (reviewer limited to two authorized clauses). Bible wins does not reliably close it (same cite-vs-stop-word problem, lower severity than forbidding a required feature).

2. **Law 1 bare “currencies” vs Bible’s metaphorical “prestige currencies.”** (Bible §5 Lord; §10.4; Law 1.)
   - §5: after Lord, “the scarce prestige currencies become Records Book superlatives and Pope-granted honorifics.”
   - Same compression pattern as “streaks,” lower practical risk: agents are likelier to implement the named Records Book than to refuse it as a currency. No third clause added.

3. **Lane B report did not flag either collision.** (`reports/B-ten-laws.md`)
   - Status DONE, path, cite list, “OPEN_QUESTIONS appended: none.” No concerns. Lane I had to discover Law 1 vs §10.9 independently.

## Minor

1. **Law 1 dropped the handoff’s Audit V1 cite.** TEN_LAWS.md Law 1 cites “Bible §4.6, §4.9; Audit V1.” Not a product invention; Audit remains in the authority stack.

2. **Law 3 is stricter than §6 “not normally delegable.”** Absolute “they do not perform rituals” matches TEN_LAWS.md. Tightening, not softening. Dangerous direction would be the reverse.

3. **Law 4 “flavor text” vs §10.9 narrative framing.** Mute cards / no Pope-voice generation (§4.2, §10.6) are correct. §10.9 still requires legend-framing of records (Glorious Martyr). Agents could over-read “flavor text” and refuse category epithets. Handoff-faithful; not patched.

4. **Law 1 / Law 9 “thresholds” vs §5 Knight prose** (“the threshold where full Church identity features become expected”). Points-threshold ban is correct. Unlikely stop-word.

## Softening / invented product

| Check | Result |
|-------|--------|
| Softened ban (“no points except…”) | **No** (as submitted). The two reviewer clauses define scope of existing words; they do not rebalance the points economy. |
| Invented product | **No.** Rule is TEN_LAWS.md compressed. No new ranks, verbs, thresholds, or resolved OPEN_QUESTIONS. |
| Invented answers in OPEN_QUESTIONS | **None appended** (correct; Bible already answers streaks vs economy and history vs role/purge). |
| Prophet / officer-as-ritualist / legacy points | **Absent.** |

## Confirmed (not findings)

| Check | Result |
|-------|--------|
| Frontmatter `alwaysApply: true` + required description | Present |
| Opens with Bible path; on conflict the Bible wins | Present (line 8) — insufficient alone; see Critical 1–2 |
| Ten numbered laws with TEN_LAWS.md Bible cites | Present |
| Hard safety (automation / injection / protected-action / Lua/XML / 20506 / Classic+ guarded reads) | Present; punctuation-only vs TEN_LAWS.md |
| OPEN_QUESTIONS pointer; do not invent / do not resolve | Present |
| Concise, no jokes (Law 10) | ~26 lines after clauses |
| Exclusive file + report; no commit | Holds |
| Laws 2, 3, 5, 8, 9, 10 vs cited Bible | Faithful enough; no Critical |

## Sections checked

- `docs/reformation/phase-0/TEN_LAWS.md` (all 10 + hard safety)
- Brief `briefs/B-ten-laws.md` (mission, exclusive file, frontmatter, content, do-nots, report contract)
- Report `reports/B-ten-laws.md`
- `.cursor/rules/ten-laws.mdc` (as submitted and after two clauses)
- Bible §4.2, §4.4, §4.6, §4.8, §4.9, §5 (Fresh Beef purges; Council exit; ranks; “prestige currencies”), §6, §10.4, §10.6, §10.8, §10.9, §12.1–12.3, §13.1, §17, §19.1, §19.3, §19.4
- Handoff §2 (Ten Laws source)
- `records-not-points.mdc` / `reports/I-records-not-points.md` (prior Law 1 vs §10.9 note)
- `identity-records.mdc` (never-delete; not always-on)
- `docs/design/OPEN_QUESTIONS.md` (no Lane B append)
