# Church of Beef — UI Render Critique, Batch 4
**Date:** 2026-08-18
**Scope:** 5 unique renders — Fighter Card v2, Victor Declared composition with minimized Director Console, the Quiet-scene console dock, the Knighting Proclamation (R7, first render), and the R10 Iconography & Seals sheet — judged against the Bible, Batches 1–3, and the Wire & Vestments handoff.
**Companion doc:** `Asset_Production_Spec_2026-08-18.md` (the custom-asset inventory and ChatGPT delivery requirements David requested — read together).

---

## Verdict in one paragraph

Batch 4 delivered three of the four things Batch 3 asked for by name: the Fighter Card got its church frame (bull-horn crest, gold flourish, blackletter name, and a proper **bull wax seal**), the minimized console dock exists as its own study, and — most importantly — **R10 landed**: a genuinely strong, internally consistent seal family that solves the faction-crest drift at the root. R7 (Rise, Beef Knight) also exists at last, with an all-canon-rank crowd. The batch's one remaining *systemic* problem is typography: the theater now speaks three different display voices — blackletter on the Sanction proclamation and Fighter Card, Trajan-style roman on Victor Declared, and a soft storybook serif on the Knighting banner. Until one display face rules every proclamation, the product will read as three addons wearing the same palette. That, plus the R10 gap list and one Quiet Mode rule violation, is the whole critique — this direction is otherwise ready for asset production, which is exactly where the companion spec takes it.

---

## Scoreboard vs. Batch 3 asks

| Batch 3 ask | Status |
|---|---|
| Fighter Card: church frame, bull heraldry, no skulls | **Done.** Bull-horn crest finial, gold-on-iron frame, parchment ledger, blackletter name. |
| Fighter Card: bull wax seal | **Done** — red wax bull, correct. |
| Fighter Card docked to one side, fighters visible | **Done** — left third, ring and both fighters clear. |
| Minimized console study (SANCTION + expand, nothing else) | **Done** — two variants delivered (see fix 3). |
| R10 seal & icon sheet | **Done, and strong.** See R10 section for the gap list. |
| R7 Knighting proclamation | **Done** (first render). Typography and sunburst notes below. |
| Every seal is the bull | **Mostly** — Fighter Card and Knighting banner: bull. Victor Declared still wears the lion (unchanged resubmit). |
| One blackletter display face for proclamations | **Not done** — now three faces across the theater. Elevated to the batch's #1 issue. |
| Victor Declared: blackletter headline, bull seal, dedup copy | **Not addressed** — the render is a straight resubmit of Batch 3's. Carry all three fixes forward. |

---

## The three remaining issues

### 1. One display face. Pick the blackletter and enforce it everywhere.

Sanction proclamation (Batch 2) and the Fighter Card name: blackletter. Victor Declared: Trajan movie-poster caps. Knighting banner: rounded title-case storybook serif ("Rise, Beef Knight"). Three ceremonial surfaces, three voices — the institution should have exactly one. The rule to lock: **blackletter for every proclamation headline and fighter name; serif small caps for labels and format lines; serif for body text.** The Knighting banner is the biggest offender — "Rise, Beef Knight" in a friendly rounded serif reads as a children's book, not a 900-year-old institution conferring belonging. Same banner, blackletter "RISE, BEEF KNIGHT", instantly correct. (This rule is also now an *asset* decision — the font files ship with the addon — so the companion spec assigns real OFL font candidates.)

### 2. The R10 sheet is excellent — here is what's missing from it.

What's there is consistent, palette-correct, and production-ready in style: papal bull wax seal with motto ring, Gora shield (bull + crossed axes), cowardice sigil (fleeing figure, charging bull — good escalation of the R4 mark), chronicle book-mark, minimap roundel, and a 9-glyph engraved set, each at two sizes and four finishes (gold/silver/iron/oxblood). Against the original R10 brief, four sigils are missing and should be the next sheet: **the kneeling-knight sigil** (Knighting — the banner currently improvises a paladin-helm medallion where this belongs), **the cleaver** (Beef Butcher / Raiding Team), **the council-ring** (Beef Council), and **the bell** (the Sanction bell — the sound the whole product is named around deserves its mark). Also worth adding now that they exist as surfaces: a **victor's gold laurel-bull seal** (the Victor Declared stamp, so the lion dies permanently) and a **favor thumb-or-palm sigil** for the HUD gauge label. The sidebar's own navigation ("Rank & Vestments", "Oratory Color") is accidentally a to-do list — a rank-icon sheet for the six canon ranks is the obvious follow-up, since the console's Present list needs exactly that set.

One tone note: the sheet's footer, "All seals and sigils property of the Church of Beef. Use only to spread the Word." — keep forever, that is the institution's voice exactly. "v1.0.0 – For the Beef!" — drop the exclamation mark; the Church does not exclaim in its own reference documents.

### 3. The minimized console appeared in Quiet Mode. That placement is illegal.

Two dock variants were delivered: "DIRECTOR CONSOLE" with a collapse chevron over the verdict scene (correct), and a "CHURCH OF BEEF"-titled SANCTION dock over a *quiet Orgrimmar street with no event running*. The second violates the Quiet contract (§19.1: minimap presence and the Decree, nothing else) — a standing SANCTION button on an ordinary Tuesday is exactly the ambient chrome the Bible bans, and SANCTION with no event is a gun on the mantelpiece of the wrong play. Rule for all future renders and for code: **the dock exists only while an event is live, only on the Pope's screen, titled DIRECTOR CONSOLE.** Keep variant one, delete variant two. (The verdict-scene composition, incidentally, is quietly the best R9 proof yet: HUD persisting through the beat with favor frozen at 52/48, parchment center, dock bottom-left, world everywhere else. That sequencing is exactly §10.7 and should be cited as the composition reference.)

---

## Screen-by-screen (remaining notes only)

**Fighter Card v2.** Keeper; promote to `R3-fightercard-REFERENCE`. Residual nits: the stock red ✕ and the little corner star are workshop chrome — the broadcast card is a timed/ESC-dismissed beat and should carry no close furniture; "I–1 vs Mugthok" mixes roman and arabic — the convention is roman everywhere on theatrical surfaces; and the sample stipulation "Winner may petition for lordship" still reads as a rules clause (lordship is earned by a fair win, §10.4 — and stipulations are spoken color, so sample text should sound spoken: "No potions. First to yield."). The four ledger glyphs should swap to the R10 engraved set (axes for record, shield for defenses, facing-bulls for head-to-head, scroll for stipulation) once cut as assets.

**Victor Declared.** Unchanged resubmit — the three Batch 3 fixes stand: blackletter headline, bull-gold seal (new R10 victor mark), body reads "Thickcut. So ruled by the Beef Pope." once, not twice.

**Knighting Proclamation (R7).** Right shape, right scale, right format line, all-canon crowd (a genuinely satisfying detail — Fresh Beef through Beef Council all present and correct). Fixes: blackletter headline (issue 1); replace the paladin-helm medallion with the R10 kneeling-knight sigil when it exists; and the R7 brief's engraved-sunburst rays behind the banner are absent — that woodcut glory is what separates "achievement toast" from "proclamation," and right now the flat beige bar leans toast. The moment should also center the kneeling candidate below the banner; the render's crowd faces camera with no kneeler, which undersells the ceremony the banner crowns.

**Feasibility flag (both crowd scenes):** nameplates showing Church rank in the guild-name slot ("Tenderloin <Fresh Beef>") are a render fiction — the addon cannot rewrite other players' guild tags on Classic nameplates. Fine as concept-art shorthand; do not let it into code fixtures or feature promises. The in-world rank signal remains raid markers on active subjects (§8) and the HUD/cards.

---

## Paste-ready block for the next GPT round

> KEEP: Fighter Card v2 frame and seal (reference); the verdict-scene composition with HUD persisting and dock bottom-left (reference); the entire R10 sheet style.
> CHANGES: (1) ONE display typeface for all proclamation headlines and fighter names — the blackletter from "A Beef Gora is Sanctioned"; never Trajan caps, never rounded storybook serif. Serif small caps for labels, serif for body. Re-render "Victor Declared" and "Rise, Beef Knight" headlines in that blackletter. (2) Victor Declared seal becomes a gold bull (never a lion); body line appears once: "Thickcut. So ruled by the Beef Pope." (3) Knighting banner: add restrained engraved-woodcut sunburst rays behind the banner; kneeling candidate centered below it; swap the helm medallion for a kneeling-knight sigil. (4) The minimized console is titled DIRECTOR CONSOLE and appears ONLY during a live event — never over quiet gameplay. (5) Roman numerals only on theatrical surfaces (I–I, never I–1). (6) No close buttons, stars, or window chrome on broadcast beats (fighter card, proclamations, verdicts).
> NEXT SHEET (R10b): kneeling-knight sigil, cleaver (Beef Butcher), council-ring, the Sanction bell, a gold victor bull-seal, a favor palm/thumb sigil — same style, sizes, and finishes as R10. Then a rank-icon sheet: Fresh Beef, Cooked Beef, Beef Knight, Beef Lord, Beef Butcher, Beef Council, one 64px icon each, same engraved family.
> ASSET MODE: when we request individual assets (not mockups), follow the delivery rules in `Asset_Production_Spec_2026-08-18.md` — single asset per image, true transparent background, no scene, no watermark, straight-on, master-size renders.

## Batch 5 priorities

1. **R10b missing-sigils sheet + rank-icon sheet** (feeds asset production directly)
2. **Victor Declared v2 and Rise-Beef-Knight v2** with the unified blackletter (the last two theatrical surfaces off-system)
3. **First true asset deliveries** per the production spec — start with the minimap roundel and papal bull seal (smallest, most reused)
4. **R9 full stream frame** re-render using only reference-grade elements (HUD-B, dock, parchment verdict) as the final composition proof
