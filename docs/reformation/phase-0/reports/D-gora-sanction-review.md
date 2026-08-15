# Phase 0 Lane D — Adversarial Review

**Lane:** Gora sanction  
**Artifact:** `.cursor/rules/gora-sanction.mdc`  
**Lane report:** `docs/reformation/phase-0/reports/D-gora-sanction.md`

**Spec:** PASS  
**Quality:** Changes required

Rule not edited. No Critical Bible contradiction.

## Verdict

Conformance with Bible §10.1–10.10 and Laws 4, 5, 7, and 8 holds. A Gora exists only after **SANCTION BEEF GORA**. Combat is an unmodified duel. ELO/MMR/hidden rating, `GrantGora` / pair-pay, typed self-report, auto-declare, invented TTL/health hacks/extra outcome enums, the `goraLordWin` elevation gate, a ranked ladder, a rules engine, and a favor economy are banned in the rule text. Petition hygiene, mute cards, Event Mode HUD with the no-live-health fallback, and the four adjudication verbs match the Bible. No numbers were invented.

The rule is not tight enough for Phase 4. Four Important holes can rebuild analytics, sit-the-champ-as-record, or a pairing score without tripping the written bans.

## Attack results

| Attack | Result |
|---|---|
| ELO / points / typed self-report | **Held.** Unmodified duel; no ELO/MMR/hidden rating; no `GrantGora` / pair-pay; no member- or officer-typed win/loss/draw; Audit V4 rebuild list is explicit. |
| Auto-declare | **Held in product text.** “Nothing auto-declares”; record stores the Pope’s ruling; elevation never auto. Softness: “may propose,” and auto-advance / auto-sanction are not restated here (Law 4). |
| Invented TTL / health hack / extra outcomes | **Held.** Expiry is “~the current event”; cooldown duration omitted; HUD fallback is everything except live health; no nameplate/combat-log HP estimator; verbs are DECLARE VICTOR / COWARDICE RECORDED / VOID / free ruling only. |
| Beating-a-Lord gate | **Held for elevation.** `goraLordWin` / sit-the-champ / demotion / decay / mandatory defense are banned. Residual: undefined “defenses” as a record category (Important). |
| Ranked ladder | **Held.** Records Book = parchment superlatives; “never a ranked / sortable ladder”; no “#1 rating.” |
| Rules engine | **Held.** No standing rulebook, picker, or stipulations database; one-line stipulation at sanction; practice defaults copied from §10.3, marked not-a-picker. |
| Favor economy | **Held.** Pick-a-side; split bar; Pope always sees; congregation toggle default on; no favor scores, streaks, accuracy records, economy, or wagering. |

## Findings

### Critical

None.

### Important

1. **Streak exception is not locked to sanctioned-Gora W/L** (Law 1; §4.6; §10.6; §10.9).  
   Law 1 bans streaks flatly. Bible wins: §10.9 requires streaks as Gora *stories* (Longest Streak, The Undefeated). This rule lists “streaks” as a required character record and bans favor streaks, but it never says the only legal streak is a sanctioned-Gora win/loss streak. A later agent can file login, Gathering-attendance, or favor-accuracy counters as “Gora record streaks.” Tighten: sanctioned-Gora W/L only; engagement / login / daily / favor / accuracy streaks remain banned.

2. **Famous Upsets can be computed** (§10.9; §10.5; Law 8).  
   Bible: “Famous Upsets — Pope-flagged.” The rule names the category and bans analytics / odds / ratings, but it does not say upsets are Pope-flagged and never inferred from level, class, or record. Auto-detecting an “upset” is a hidden fairness engine.

3. **Undefined “defenses” can rebuild sit-the-champ as a record** (Audit V4; §5; §10.4; §10.6; §10.9).  
   Elevation no longer requires beating a sitting Lord. The rule still requires defense counts on cards/HUD and “Most Successful Defenses” without saying do not invent a title-defense / champ-bout definition. Bible never defines a defense. “A Lord does not lose the title by losing fights” (§5) plus “no demotion / no mandatory defense” blocks the worst reading, not a Phase 4 schema that counts only wins over Lords — or only Lords’ title bouts — as defenses. Do not resolve the definition; fence it (OPEN_QUESTIONS or “do not invent”).

4. **Matchmaking can become a pairing score or auto-sanction** (§10.5; Law 4; §4.2; §18.2).  
   “Recommend only: level proximity, freshness…” plus “the system identifies sensible matches” can ship as `matchQuality = 87` or a ranked suggestion list — a hidden rating of the *pair*, which §10.5 forbids as surely as fighter ELO. Non-negotiables restate auto-declare and auto-announce, not Law 4’s auto-advance queues, and never say nothing auto-sanctions the next pair. Show unlabeled or fact-labeled pairs; do not score them; the Pope clicks SANCTION.

### Minor

5. **“May propose” is weaker than §10.8** (Law 4; §4.4).  
   Bible: “the software **proposes** the outcome and the Pope **ratifies**.” The rule’s “Duel system messages may propose” lets an agent skip the proposer (David types) or treat proposing as optional enough to time out into a declare. Use: software proposes; it does not declare.

6. **Head-to-head line vs mute cards** (§10.6; §4.2).  
   Bible’s example (“this is the rubber match”) is generated color. The rule requires a head-to-head line and also “No generated flavor.” It does not say the line is factual counts only. Do not invent the copy.

7. **Petition desk fields omitted** (§10.2).  
   Hygiene is complete. The pool contents (player, character, class, level, rank, record, head-to-head) are not listed. Not a contradiction; a later desk can invent extra columns.

8. **Level ~2 can be implemented as a hard filter** (Law 1 thresholds; §10.3; §10.5).  
   The rule says the Pope may waive it. It does not say it is not a threshold and not a hide-the-mismatch filter. Deliberate mismatches are entertainment (§10.3).

## What was checked and held

- **Loop §10.1.** Petition → assisted matchmaking → SANCTION → mute cards → favor → unmodified duel → Pope ratifies → records → possible elevation. Sanction is not skippable.
- **Petition hygiene §10.2.** Expiry ~current event; present and alive; one-tap dismiss; soft re-petition cooldown with no duration; named opponent official only when the Pope announces.
- **Ruleset is the Pope §10.3.** No engine/picker/DB; optional one-line stipulation; practice defaults match Bible (come as you are; duel’s natural end; flee → propose COWARDICE; interference → propose VOID; disconnect suggests Void; rematches at pleasure). Flee is correctly *propose*, not §10.3’s looser “triggers the ruling.”
- **Lord milestone §10.4.** Knight + fair sanctioned win + Pope ceremony; attainable; no demotion/decay/mandatory defense/beating-a-Lord.
- **Matchmaking §10.5.** Factors named; no odds copy; no ratings; software recommends, Pope decides.
- **Sanction / cards / favor §10.6.** One console action; mute tale-of-the-tape fields; favor is sides only; split bar; Pope visibility; congregation toggle default on.
- **HUD §10.7 / §4.8.** Event Mode, sanctioned fight only; Quiet Mode: no HUD, no favor, no Gora feed; defined no-live-health fallback; Appendix A item 1 / OPEN_QUESTIONS #2; no health hack.
- **Adjudication §10.8 / Law 4.** Four verbs + free ruling; no extra typed outcomes (no DRAW/forfeit enum); no auto-declare; elevation is its own beat.
- **Records §10.9–10.10 / Law 7.** Character owns the Gora record; stories not analytics; named MVP superlatives; no seasons/resets/decay/expiry.
- **Law 5.** Witnesses report; no peer self-reported authority over outcomes.
- **Audit V4 rebuild list.** Challenge + `RecordResult` + `GrantGora`; member/officer self-report; pair-pay cooldown as product.
- **No invented numbers.** No seconds for TTL/cooldown. `~2` is Bible text. OPEN_QUESTIONS: none added (correct for TTL/health; see Finding 3 for the defense gap they also did not invent).

## Sections checked

- `docs/reformation/phase-0/TEN_LAWS.md` (Laws 1, 4, 5, 7, 8; Bible-wins)
- `docs/reformation/phase-0/briefs/D-gora-sanction.md`
- `docs/reformation/phase-0/reports/D-gora-sanction.md`
- `.cursor/rules/gora-sanction.mdc`
- Bible §4.2, §4.4, §4.6, §4.8, §5 (Lord attainable; no title loss), §6, §10.1–10.10, §13.1, §18.2, §19.1, Appendix A item 1, Appendix B items 2–3
- Adjudication: no ELO; favor pick-a-side; Lord attainable; ruleset is the Pope; ranked ladder rejected; Gora rules engine rejected
- Audit V4 (`GrantGora`, typed result, `goraLordWin`)
- `docs/design/OPEN_QUESTIONS.md` items 2–3
- Adjacent (attack only): `.cursor/rules/ten-laws.mdc` Law 1 streaks; `.cursor/rules/records-not-points.mdc` narrative-streak wording; `.cursor/rules/pope-authority.mdc` auto-advance / officers do not sanction

## Brief contract

Frontmatter, globs (Core/UI/Net; `alwaysApply: false`), must-include bans and verbs, loop, hygiene, rules-as-Pope, matchmaking, mute cards, favor, HUD fallback, adjudication verbs, Lord milestone, Records Book, and the lane report’s Status / sections / ELO-points-self-report confirmation are all present. No other files edited. No commit.
