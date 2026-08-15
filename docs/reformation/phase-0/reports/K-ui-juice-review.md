# Phase 0 Lane K — Adversarial Review

**Lane:** UI juice / hybrid visual law  
**Artifact:** `.cursor/rules/ui-juice-standards.mdc`  
**Lane report:** `docs/reformation/phase-0/reports/K-ui-juice.md`  
**Mode sibling:** `.cursor/rules/quiet-event-modes.mdc`

**Spec:** PASS  
**Quality:** Changes required

Rule not edited. No Critical Bible contradiction.

## Verdict

Hybrid visual law holds. Stock-chrome-only and V1-silent doctrine are dead in this rule. Custom media is barred from functional desks. The UI is forbidden to joke. No juice OS, tween bus, hex palette, toast-kind enum, or Media file list was invented.

The §19.1 Quiet toast ban versus the §13.4 / §20.3 stale-client notice is **not** resolved inside this rule. Lane K did not invent a toast kind. It also did not name the Bible-required notice. Critique question 2 treats any Quiet toast as a fail, which can reject the notice if an implementer reuses the toast engine (Audit §4; Lane H carve-out). That is an Important quality gap, not a Spec fail.

Leaving the Fight HUD off the §19.3 theatrical list is **correct restraint**, not a Bible miss. Expanding the kept WA-pulse ban into “no center-screen alert frames” is the residual HUD risk.

## Attack results

| Attack | Result |
|---|---|
| Stock-chrome-only or V1-silent doctrine surviving? | **No** in this rule. Functional stock is Law 10 / §19.3, not Audit V10’s blanket chrome ban. Event Mode has §19.4 cues. Archived UI-brief-as-law pointer is gone. |
| Custom media on functional desks? | **Banned.** “Only where theater lives”; anti-pattern “custom media on functional surfaces.” Matches §19.3. |
| Quiet Mode toasts / sound / pips? | **Ambient layer banned** (§19.1, Law 6, Audit V9). Sound: Quiet silent absolutely (§19.4). Pips banned. Decree + minimap remain. |
| §19.1 toast ban vs §13.4 gentle stale-client notice — invent a kind or wrongly ban the notice? | **Neither cleanly.** No kind invented (correct). Notice not named; Critique Q2 can over-ban it (Important). Mode contract is delegated to `quiet-event-modes.mdc`, which already carves the rare system notice. |
| Fight HUD unclassified — Bible miss or correct restraint? | **Correct restraint.** §19.2 lists HUD as Event Mode theater; §19.3’s ecclesiastical list omits it. Classifying HUD as stock or parchment would invent a product answer. |
| Jokes in UI / juice OS / hex tokens invented? | **No.** “Comedy engine” is §19.3 contrast language; “UI itself never tells jokes” is present. Hex / OS / tween bus are anti-patterns, not shipped systems. Materials are Bible names (dark iron, charcoal, aged parchment, muted gold). |

## Findings

### Critical

None.

### Important

1. **Quiet “no toasts” + Critique Q2 can reject the §13.4 notice** (Bible §19.1, §13.4, §20.3, §21.3; Law 6; Audit §4 Toasts row; Lane H “Notices and onboarding”).  
   §19.1 / Law 6: Quiet Mode has no toasts. §13.4 / §20.3: a stale client drops to Quiet Mode **with a gentle “the Church’s software has advanced” notice**. Audit §4: keep the toast engine for Event Mode consequence beats **and rare Quiet Mode system notices**. Lane H states that exception and forbids inventing kinds.  
   Lane K restates §19.1 absolutely (“no toasts”) and asks, before done: “Does Quiet Mode stay silent (no toast, sound, or pip)?” It never says the §13.4 notice is not an ambient toast. Same UI globs fire both rules. A juice-first agent can refuse the Bible-required notice, or invent a new surface to avoid the word “toast.”  
   Required change (integrator; not a new kind): one pointer that the Quiet toast ban is the ambient/engagement layer (V9); rare system notices live in `quiet-event-modes.mdc` / §13.4. Do not add a `staleClient` kind enum here.

2. **“No center-screen alert frames” can be read as banning the Fight HUD** (Bible §10.7, §19.2; brief: keep “no center-screen WA pulses”).  
   §10.7: HUD is top-center by default, movable, Event Mode only, the spectator-legibility feature. The brief kept **WA-style pulses**. The rule writes “No center-screen **alert frames** / WA-style pulses.” Top-center HUD is horizontally center-screen. Combined with HUD’s absence from the theatrical list, a sloppy agent can reject the HUD as juice.  
   Required change: keep the WA-pulse / ambient-alert ban; do not let it swallow §10.7. Do not classify HUD chrome in this rule.

### Minor

3. **Lane K report does not record the §13.4 tension or the HUD gap.**  
   `K-ui-juice.md` reports a clean swap to hybrid law. True for V10 / V1-silent / media-on-desks. It does not cite §13.4 / §20.3 or say HUD is deliberately unclassified. A later agent reading only the lane report will miss both.

4. **§19.5 onboarding is absent** (owned by Lane H; brief scoped K to §19.1–19.4).  
   Critique questions do not ask whether first-launch juice became tutorial popups or minimap fanfare. Residual process risk only.

## What was checked and held

- **V10 resolved as hybrid, not stock-only.** Functional: Director Console desks, lists, settings — stock Blizzard templates, pragmatic, `GameFont*`. Theatrical list matches §19.3 / Law 10 exactly: proclamations, fighter cards, seals, verdicts, Records Book, Decree. Custom media permitted and expected only on theater; missing media must not fail load.
- **V1-silent / T0–T1 / standing-toast doctrine removed.** No T0 private edge-toast, T1 `/g` promote spectacle, “V1 silent — no SFX,” “Standing: text thresholds,” Officer Dismiss critique, announce-checkbox-deferred, or archived `docs/superpowers/ui-polished-direction-for-agents.md` as law. Authority is Bible §19 + `quiet-event-modes.mdc`.
- **Quiet ambient layer stays dead.** No feeds, toasts, pips, sound, or extra always-visible chrome in the juice Mode section. Decree is the Quiet theatrical exception (parchment banner, §14.1 / §19.3) — custom media on Decree is legal; that is not a Quiet toast.
- **Sound set is §19.4 only.** Sanction bell, Verdict, Elevation, Knighting, Cowardice Recorded; later Canonization seal. No ambient whooshes. Event Mode rhythm copied from §19.2 / §4.8.
- **No invented juice OS.** Anti-patterns name and reject juice OS / tween bus / hex palette token systems. No `#` tokens. No Media file list. “Consequence beats” is handoff/brief language, not a kind table.
- **No jokes in chrome.** §19.3 comedy-from-contrast + “UI itself never tells jokes” + “no meme clutter” + Law 4 “software never narrates.”
- **Law 1 display-only.** UI displays Core / Pope-ratified outcomes; never awards points, standing, or ranks.
- **Kept engineering bans** match the brief: no permanent `OnUpdate` for juice, no `uiScale` mutation, dual-encode status, class color on names only, `POLISH:CANDIDATE` only.
- **HUD / favor visual class not invented.** §19.2 names HUD (and favor) as Event Mode presentation; §19.3’s ecclesiastical list does not. OPEN_QUESTIONS.md still has only HUD *feasibility* (item 2), not visual class. Correct: do not resolve. Optional later append if Design Lead wants the gap tracked — this review does not append.
- **Frontmatter / exclusive files.** Description updated; globs UI + bootstrap; `alwaysApply: false`. Only the rule + `K-ui-juice.md` were written by the lane. No commit.

## Sections checked

- `docs/reformation/phase-0/TEN_LAWS.md` (Laws 1, 4, 6, 10; do-not-invent)
- `docs/reformation/phase-0/briefs/K-ui-juice.md`
- `docs/reformation/phase-0/reports/K-ui-juice.md`
- `.cursor/rules/ui-juice-standards.mdc` (full)
- `.cursor/rules/quiet-event-modes.mdc` (Notices and onboarding; Quiet/Event; sound)
- Bible §4.8, §10.7, §13.4, §14.1–14.2, §18.5, §19.1–19.5, §20.3, §21.3, §22.1 items 2 and 10
- Law 10 theatrical list vs §19.2 Event Mode list (HUD present in §19.2, absent in §19.3)
- Audit V9, V10, §4 Toasts.lua keep/rework, §7.1 hybrid recommendation (confirmed in Bible v1.1.1)
- `docs/design/OPEN_QUESTIONS.md` item 2 (HUD feasibility only)
- `CURSOR_REWORK_HANDOFF.md` Phase 4 toast-engine re-aim; Phase 4 HUD line

## Brief contract

Must-include hybrid split, joke ban, theater-only custom media, Quiet silent / Event §19.4 cues, kept motion-taint-performance bans, Bible §19 + `quiet-event-modes.mdc` authority, and removal of T0/T1 / V1-silent / standing-threshold / Dismiss-critique / archived-brief-as-law are all present. “Do not invent” juice OS / tween bus / hex tokens / toast kinds / Media lists was observed. Report Status / cited sections / old-doctrine list match the rewrite.
