# Phase 0 Lane E — Adversarial review (pope-authority)

**Lane:** E — Pope authority + officer-guild-roster rewrite  
**Artifacts:** `.cursor/rules/pope-authority.mdc`, `.cursor/rules/officer-guild-roster.mdc`, `docs/reformation/phase-0/reports/E-pope-authority.md`, `docs/design/OPEN_QUESTIONS.md` item 8  
**Law:** Bible §4.2, §4.4, §5, §6, §8, §13.1–13.4, §18.1–18.3; Ten Laws 3–5, 9; Audit V3; Appendix A item 4  
**Rule edited:** no (no Critical Bible contradiction)

| Axis | Verdict |
|------|---------|
| **Spec** | **PASS** |
| **Quality** | **Changes required** |

Ceremonial sovereignty, star trust, KNIGHT THIS BEEF promote-where-permitted, and the software-proposes / Pope-ratifies bans are present and Bible-aligned. The six assigned attacks do not refute conformance. One leftover mapping phrase can still send Phase 1 back to Audit V3.

---

## Attacks (assigned)

### A1 — Officer+ / `rankIndex` still a ritual gate — does not land

Both rules forbid the demo gate. `pope-authority.mdc`: `rankIndex ≤ 1` / Officer+ is **not** the Church and **not** a ritual gate. `officer-guild-roster.mdc`: do **not** gate rituals or canonical writes on `rankIndex ≤ OfficerRankIndexMax`; `CanGuildInvite` / `CanEditOfficerNote` / `IsGuildOfficer()` are not Church authority. Theater and canonical writes go to registered-Pope senders (and designated Council only for the §13.3 operational subset).

`rankIndex` is kept as a Classic sensing edge (0-based, display / Presence only). That is the brief’s keep list, not a rebuilt Officer+ church.

Demo `Core/Officer.lua` still implements `IsOfficerIndex` / `LocalIsOfficer`. The lane report names this as expected until Phase 1. Out of exclusive scope; not a Spec fail of the rule set.

**Residual (Quality):** see F1 (`index → Church id only`) and F2 (leftover “not Officer+” fail-closed sentence).

### A2 — Blanket ban on guild promote still present — does not land

The old officer-rule sentence “Addon must not call guild promote/demote APIs” is gone from both exclusive files. `pope-authority.mdc` § KNIGHT THIS BEEF: Church record + guild-rank promotion **where the API permits** + proclamation + queue advance **on command**. Guild-rank write is a capability guard (Appendix A item 4), not an Officer+ ritual gate. `officer-guild-roster.mdc`: guard the call; do not forbid the verb; congregation clients never write guild rank.

This matches Bible §5 / §8. Other elevations correctly write the Church store only — the Bible names the dual-write only on KNIGHT THIS BEEF. Officers may still change ranks in the Blizzard UI; the console reconciles drift (§5).

Out-of-lane: `addon-module-layers.mdc` was aligned to the same exception (integrator). Not Lane E’s exclusive file.

### A3 — Council performing rituals — does not land

Named Pope-only verbs: Knighting, sanctioning Goras, verdicts, elevation, canonization, major proclamations (§6, §13.3). Officers and Council do **not** close ceremonies, knight, sanction, declare verdicts, elevate, or canonize. Operations: logistics, activities (dungeons, raids, informal fights), and **non-ceremonial** record correction as §13.3 allows.

§12.2 Rite of Recognition (Pope or Council, ritualized linking) is not in this named list and is Lane F. Lane E’s blanket “they do not perform rituals” must not be read to repeal §12.2. See F3.

### A4 — Invented registered-Pope UX — does not land

Both rules: do **not** invent registered-Pope (or designated-Council) configuration UX. No settings screen, slash registrar, character picker, or “first click is Pope” bootstrap. The phrase “registered Pope character” is Bible §13.4, not a new surface. “UI ‘I am the Pope’ is not enough on the wire” is a trust rule, not a panel.

### A5 — OPEN_QUESTIONS #8: real gap or invented product? — real gap (correct filing)

Bible §13.3–13.4 and §6 **assume** registered Pope character senders and designated Council for non-ceremonial correction. They do not specify which characters, where the lists live, or who may change them. §18.1 / §4.11 require zero setup; that tension is why the lists cannot be silently invented.

Item 8 states the gap and forbids a configuration UX until David / Design Lead answers. It does **not** specify a settings screen. Filing the gap is correct; specifying a settings screen would have been wrong.

### A6 — Auto-advance / auto-announce surviving — does not land

`pope-authority.mdc` never: auto-declare outcomes, auto-advance queues, auto-announce in the Pope’s voice, generate narration / flavor / Chronicle scripture. Stage manager may **surface** who is next; anything with a verb happens in the Pope’s voice (§4.2, §18.2).

KNIGHT THIS BEEF queue advance is “only because the Pope clicked.” That is §8 “stages the next candidate” as part of the one Pope action, not the console advancing the queue itself (§18.2). Proclamation to installed clients is likewise inside the Pope verb, not software announcing in his place.

---

## Findings

### Critical

None.

### Important

**F1 — Leftover `index → Church id` mapping phrase** (`officer-guild-roster.mdc`, Roster timing; Audit V3; Bible §5)

> Never map Church display from `rankName` strings — index → Church id only

Not using `rankName` strings is a true Classic edge (brief keep). “Index → **Church id**” is the demo’s rankIndex→ChurchRank mapping in new clothes. Audit §4 on `Core/Roster.lua`: replace that mapping with display-vs-truth; keep the read/refresh machinery.

A slot-index → *intended display rank* table may exist so the console can detect Blizzard-UI drift (§5). It is not the member’s Church id. Church store is truth; `rankIndex` is public display. The same file says that in the code comment, then contradicts it with “Church id.”

**Required change (wording, not product invention):** say index → intended-display-rank for drift detection only; never treat live roster index as Church identity or as authority to knight, sanction, or write canon. Do not keep “Church id” as the thing the index maps to.

Not Critical: surrounding sentences already deny roster authority. The defect is the rebuild path for V3.

### Minor

**F2 — Leftover Officer+ fail-closed sentence** (`officer-guild-roster.mdc`)

> Until a snapshot exists: Presence is empty / unknown — do not treat that as "not Officer+"

Correct negation of the old gate; it still teaches the Officer+ concept as the thing you might fail closed to. Prefer: until a snapshot exists, Presence is empty / unknown — do not infer Church authority or the absence of it.

**F3 — Blanket “do not perform rituals” vs §12.2** (Law 3, §6 vs §12.2)

Lane E’s named verb list is right. §12.2 gives Council a short ritualized Rite of Recognition (Lane F). Integrators must not let Lane E’s blanket line repeal that. No Lane E edit required unless someone reads the blanket as closing Recognition.

**F4 — “Major proclamations” vs Decree deputy** (§6, §14.1; OPEN_QUESTIONS #5)

§6: major proclamations are Pope-controlled, not normally delegable. §14.1: Pope or one designated deputy posts the Decree. #5 is already open. Lane E must not be read as closing #5 or inventing deputy UX. It does not invent that UX.

**F5 — Empty registered-Pope list vs zero setup** (§4.11, §18.1; item 8)

Lane E does not restate the Tuesday zero-setup floor. Combined with “theatrical UI renders only from a registered Pope character,” a Phase 1 agent could build a blocking setup wall. Item 8 already forbids inventing the UX. Hold: do not invent the list; do not invent a setup wall; small ceremony still begins as a Pope click.

---

## What was checked and held

- **Law 3 / §6.** Pope holds ceremonial sovereignty. Named rituals are not delegable. Council/officers support operations; they do not close ceremonies or knight.
- **Law 4 / §4.2 / §4.4 / §18.2.** Software proposes; Pope ratifies. No auto-declare, auto-advance, auto-announce, generated narration. Stage manager may surface who is next.
- **Law 5 / §13.1–13.4.** One writer (Pope client). Congregation = display + input to the Pope console. Witnesses report, never rule. Theatrical UI only from registered Pope character senders. Player free text → Pope console only.
- **Law 9 / §5.** Guild rank = public display; Church store = truth; reconcile silently when unambiguous; ask the Pope when not. No Officer+ church. Rank structure not reopened here (Lane I).
- **§8 KNIGHT THIS BEEF.** One Pope-commanded action: Church record, guild-rank promotion where the API permits, proclamation to installed clients, queue advance on that click. Capability guard, not a blanket ban, not a congregation/Council promote verb.
- **§18.1–18.3.** One-click Director Console verbs; console never advances/announces/auto-declares; Notebook not in scope to invent. Presence desk named as roster’s job.
- **Audit V3.** Officer+ index gating and officer-close Knighting are named as the failure this rewrite exists to stop.
- **Appendix A item 4.** Guild-rank write is a permission/capability check, not sovereignty.
- **No invented Pope-list UX.** Item 8 is a real unspecified-assumption gap, correctly bounded.
- **Brief keep list.** 0-based `rankIndex`; `C_GuildInfo.GuildRoster()` / 10s throttle; wait for `GUILD_ROSTER_UPDATE`; realm-qualified names; do not flip `SetGuildRosterShowOffline`.
- **Brief delete list.** Officer+ ritual gate; receivers re-check rank index as Church authority; independent ladder-as-product; pause scoring when not in guild; standing correction as officer product; blanket promote/demote ban; live roster as title authority.

## Sections checked

- `docs/reformation/phase-0/TEN_LAWS.md` (Laws 3–5, 9; Bible-wins; do not invent)
- `docs/reformation/phase-0/briefs/E-pope-authority.md`
- `docs/reformation/phase-0/reports/E-pope-authority.md`
- `.cursor/rules/pope-authority.mdc`
- `.cursor/rules/officer-guild-roster.mdc`
- `docs/design/OPEN_QUESTIONS.md` item 8 (and #5, #7 as adjacent)
- Bible §4.2, §4.4, §4.11, §5, §6, §8, §12.2 (attack only), §13.1–13.4, §14.1 (attack only), §18.1–18.3, Appendix A item 4
- `docs/design/Demo_Build_Audit.md` V3; Audit §4 Roster / Officer dispositions
- Adjacent (attack only): `.cursor/rules/addon-module-layers.mdc` promote exception; `Core/Officer.lua` leftover index gate; Lane F Recognition

## Brief contract

`pope-authority.mdc` frontmatter (Pope/Council split + registered-Pope senders; Core/Net/UI globs; `alwaysApply: false`), must-include sovereignty / operations / propose-ratify / star / KNIGHT THIS BEEF / display-vs-truth / no-Pope-no-rituals, and the officer-rule rewrite (Classic edges kept; Officer+ ritual gate and blanket promote ban removed) are all present. Report lists deleted sentences. Item 8 filed without inventing UX. Exclusive files only; no commit.

---

**Spec PASS. Quality: Changes required.**

Close F1 (rephrase `index → Church id` to display-mapping / drift detection only) before treating Lane E as gate-clean. F2–F5 are wording / cross-lane holds. The assigned attacks do not justify Spec FAIL.
