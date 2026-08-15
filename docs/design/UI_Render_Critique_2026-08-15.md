# Church of Beef — UI Render Critique, Batch 1
**Date:** 2026-08-15
**Reviewer role:** external UI design critique of the first ChatGPT concept batch
**Inputs:** 6 unique renders (Verdict + Records Book, Fight HUD, Gora Desk, Knighting Console, Ceremony Console, Decree placard), judged against `Game_Design_Bible_v1.1.1.md` (§5, §8, §10, §14.1, §17, §18, §19) and `UI_Rendering_Prompts.md`.
**Purpose:** handoff notes for the next render generation. Per the prompt pack's own rule, garbled/misspelled text is ignored throughout — this critique is about layout, hierarchy, invented mechanics, and art direction only.

---

## Verdict in one paragraph

These renders are competent generic WoW-addon windows, and that is the problem. The design's entire visual thesis — the hybrid visual law (§19.3): *plain backstage console vs. absurdly dignified ecclesiastical theater* — is absent. Every surface in this batch, theatrical and functional alike, came out in the same midtone stock-Blizzard frame, so the contrast that IS the comedy engine does not exist anywhere in the set. Worse, the image model quietly redesigned the product: it invented rank-ladder mechanics, eligibility thresholds, win percentages, favor points, attendance tracking, and a sortable records table — nearly all of which the Bible explicitly and permanently bans. The console layouts (screens 3–5) are salvageable skeletons. The theatrical surfaces (verdict, records, HUD, decree) need to be regenerated from scratch with much stronger art direction and a hard "banned mechanics" list appended to every prompt.

---

## The two systemic failures

### 1. The hybrid visual law is missing (highest priority)

§19.3 rules that functional surfaces (Director Console desks) stay stock-Blizzard pragmatic, while theatrical surfaces (proclamations, fighter cards, verdicts, the Records Book, the Decree) receive **the full ecclesiastical identity — non-negotiable**. In this batch:

- The Director Console renders (screens 3, 4, 5) are correctly plain. Good.
- But the Verdict window, Records Book, Fight HUD, and Decree are *equally* plain — same gray-brown frame, same fonts, same red rectangle buttons. No parchment, no wax seals, no blackletter, no iron fittings, no candle-glow. R4's prompt asked for a wax-seal stamp moment; what came back is a settings dialog.

When everything is plain, the product reads as one gray admin tool and the joke dies. The next batch must make the theatrical surfaces look like they came from a different century than the console. If a theatrical render comes back looking like a stock addon frame, discard it regardless of layout quality.

**Prompting fix:** the model is being gravity-pulled toward stock UI by the WoW-screenshot framing. For theatrical surfaces, prompt the *object* first ("an illuminated-manuscript proclamation page with iron fittings and a wax seal, presented as a game overlay"), not "an addon window." Keep the Master Style Block, but move the material description (parchment/iron/wax/blackletter) to the first sentence of each prompt — image models weight early tokens.

### 2. The renders invented banned mechanics

The prompt pack warned about exactly this ("renders that redesign the petition flow or add betting odds panels are noise"), and it happened in five of six screens. These are not nitpicks — if these renders inform the Cursor build, they will smuggle a rank-grind product into a design that explicitly rejects one. Every regeneration prompt should carry the **Canon Crib Sheet** (bottom of this doc) as a negative-direction block.

Violations found in this batch:

| Render element | Bible ruling it violates |
|---|---|
| Records Book as a date/victor/defeated ledger table + "Rankings" nav item | §10.9: "superlatives, not rankings; parchment pages, not sortable tables." A sorted ladder is *permanently rejected*. |
| "Eligibility Check: Level 60 ✓ / Member > 7 days ✓ / Attended 4+ Raids ✓" | §5: ranks are relationships, **no thresholds**. Knighting is a human ritual, not a gate check. This is the single worst element in the batch. |
| "No Recent Notes ✓" shown on the Knighting screen | §17/§18.3: notes are private absolutely. A red X here would leak moderation data on stream. |
| "Wins: 57%" on the challenger card | §10.9: records are stories, not analytics. No rates. |
| "Balanced: Even Match / Slight Advantage" matchup ratings | §10.5: show class matchup plainly **without editorializing about odds**. No ELO, no MMR, no hidden rating, ever. |
| "Congregation Approves +50 Favor" toast | §10.6: favor is a split, never a score. "The moment favor has a score, spectators optimize instead of cheering." No favor economy. |
| Attendance panel with 24/28 count, red "Absent" roster, MARK ABSENT button | §14.1 hard boundary: no attendance tracking. §4.9: record events, not behavior. Public absent-shaming is the exact failure mode the privacy contract bans. |
| W / L / **D** record columns | §10.8: outcomes are Victor, Cowardice, Void, or free ruling. There are no draws. |
| "Ruleset: Traditional Gora" | §10.3: "there is no standing rulebook. The ruleset is the Pope." |
| "Stakes: [dropdown]", "Allow Heals ☑", "Location: [dropdown]" | §10.3: stipulations are one free-text line spoken by the Pope; "no stipulations database, picker, or rules engine." |
| "Thickcut gains Holy Strength / Sirloin gains Mortal Wounds" | A Gora is an unmodified WoW duel. The addon must never imply it grants buffs/debuffs. |
| Invented ranks everywhere: Beef Cardinal, Templar, Acolyte, Initiate, Squire, Crusader, Guardian, Paladin-as-rank | §5: the only ranks are Fresh Beef, Cooked Beef, Beef Knight, Beef Lord, Beef Butcher, Beef Council. The Pope is not a rank. |
| "NOTIFY PARTIES" button; "All parties will be notified"; ANNOUNCE / WHISPER ALL | §18.2: the console **never announces in the Pope's place**. Sanction itself is the broadcast; the Pope's voice is the announcement. |
| "SAVE TO CHRONICLE" as a routine post-bout button | §4.4: if the software knows, David never enters it — records save themselves. Chronicle entry is MARK THIS MOMENT, a scarce Pope act (§16), not a save button. |

---

## Screen-by-screen

### Screen 1 — "Verdict: BEEF GORA" + Records Book

**What works:** Victor/Defeated facing panels with crossed-axes centerpiece is the right symmetry. Bout summary block (location, date, witnesses, duration) is good archival flavor — "Witnesses: 6" is exactly the right institutional voice.

**Structural problems:**

1. **Two different surfaces are fused into one window.** §10.8 separates *adjudication* (console: software proposes, Pope ratifies with one action) from the *verdict moment* (public theater: seal, sound, proclamation). This render shows a window that already displays "THE VICTOR" while still offering DECLARE VICTOR — the decision is presented as made and unmade simultaneously. Split it: (a) a plain console adjudication strip — "Duel ended — proposed: Thickcut def. Mugthok" with ratify verbs; (b) the ornate public verdict proclamation that plays after ratification (R4's stamp moment for COWARDICE, an equivalent gold-seal version for VICTOR).
2. **Four coequal red buttons.** DECLARE VICTOR / RECORD COWARDICE / VOID BOUT / SAVE TO CHRONICLE all render identically. Adjudication needs hierarchy: the proposed ruling as the single big affirmative target, Cowardice and Void as visually distinct secondary rulings (Void should look *cheap and shame-free* per §10.3 — a small quiet button, not a red alarm), and no Chronicle button at all.
3. **The Records Book is a leaderboard and must be thrown out entirely.** Columns, dates, a search field, and a "Rankings" nav tab — this is the permanently rejected surface. R6 already specifies the replacement: a two-page open tome, illuminated superlative entries (Most Sanctioned Victories, The Iron Chin, The Glorious Martyr, Greatest Rivalry with running tally), portrait medallions, zero tables. Regenerate R6 as a standalone object filling the frame, not a sub-window.
4. **Updated Record W/L/D table** — drop Draws; and consider whether the verdict beat needs a stat table at all versus one narrative line ("Their third meeting; Thickcut leads the rivalry").
5. This is a theatrical surface rendered plain — full ecclesiastical treatment required (parchment, seal, blackletter "SO RULED").

### Screen 2 — Fight HUD (live duel)

**What works:** Top-center placement, facing fighter panels, VS centerpiece with timer, favor bar concept, records shown. The bones match §10.7.

**Problems:**

1. **Scale.** HUD + favor bar + approval toast consume roughly a quarter of vertical screen space. R2's budget is **≤12% of screen height, one horizontal bar**. Fold the favor split INTO the HUD bar (a thin gauge beneath the fighter panels, as specced) and delete the floating toast layer entirely. The gameplay is the hero; this batch buries it.
2. **Kill the "+50 Favor" toast** (banned economy, see table above). Favor display is just the split bar moving.
3. **Portraits are photorealistic modern human faces.** This is the most jarring art-direction failure in the batch — they read as stock-photo webcam frames. Use in-game character portraits or engraved/painted medallion portraits in iron frames. Never photoreal humans.
4. **Missing specced content:** class-colored health bars (these are generic green/red), level, Church title, defense count, and the head-to-head line ("their third meeting — one apiece"). The head-to-head line is the rivalry engine; it belongs in the HUD.
5. The Director Console mini-panel (top-left) is fine as a concept but in the stream frame it should be minimized to a corner (R9 puts it bottom-left, small). Top-left competes with the theater.
6. Health bars per R2 should read as stained glass set in iron — a real chance for the ecclesiastical identity to show up in the HUD's materials while staying compact.

### Screen 3 — Director Console: Gora Desk

**Closest to spec in the batch.** Three-panel structure (petitioner queue → challenger details → proposed matchups) matches §18.1, and the big SANCTION plate is exactly the right instinct — one oversized sacred action, visually unlike everything else. Keep that plate; it's the best single element in the set.

**Fixes:**

1. **Rename and defang "Recommended Matchups."** Kill "Balanced: Even Match / Slight Advantage" — the software may show level proximity, class-vs-class, and head-to-head history plainly, but never a fairness verdict. Replace each rating line with the head-to-head story line: "They have met twice — one apiece." That's the context the Pope actually performs with. Consider retitling to "SENSIBLE PAIRINGS" or simply "PAIRINGS."
2. **Remove "Wins: 57%"** from challenger details. Record (7W–1L), rank, level, class, head-to-head — that's the full spec.
3. **Petition hygiene is missing** (§10.2): the queue should visibly badge *challenges* (who has DEMANDED whom — this is prime performance material and deserves a callout icon), show present-and-alive status, and offer a one-tap consequence-free dismiss per row. These are the details that make the desk feel like a live production tool rather than a matchmaking lobby.
4. **Match Settings block shrinks to two things:** one optional free-text stipulation line ("STIPULATION: …") and the per-event favor-display toggle (§10.6). Delete Stakes dropdown, Location dropdown, Allow Heals, Spectators Allowed — every one of them is rules-engine creep.
5. **Delete NOTIFY PARTIES.** Sanction is the notification; the console never speaks for the Pope.
6. Plainness level is correct here — do not ornament this surface beyond the small seal in the title bar. If anything, the next render could be *plainer* (stock Blizzard beveling) to widen the contrast against the theater.

### Screen 4 — Director Console: Knighting phase

**What works:** The three-panel IA is exactly §18.1's Presence + Knighting Queue + candidate detail. Numbered queue with the current candidate highlighted, candidate's zone/online status (finding the level-14 gnome is stage management), Referred By — all good. PAUSE QUEUE is a smart, spec-compatible affordance for latecomer chaos.

**Fixes:**

1. **Delete the Eligibility Check block entirely.** This is the batch's cardinal violation. There are no thresholds — no level gates, no tenure, no raid attendance, and absolutely no "No Recent Notes" surfacing private data. Replace that panel space with *context, not gates*: current rank, present/absent-from-queue, referrer, and (private-styled) the Pope's Notebook line if any.
2. **One sacred verb.** SKIP / PROMOTE / MARK KNIGHTED is three buttons doing one job. The Bible's verb is **KNIGHT THIS BEEF** — one large plate (same visual weight class as SANCTION) that performs everything and stages the next candidate. SKIP survives as a small quiet secondary. MARK KNIGHTED (manual data entry for something the software just did) violates §4.4 — delete.
3. **Add the targeting affordance:** clicking a queue row targets the candidate / places the raid marker (§8). A small crosshair/marker icon per row communicates this in a render.
4. **Fix the rank column.** Present roster shows Cardinal/Templar/Acolyte/Initiate/Guardian — none exist. Use only canon ranks (crib sheet below). This matters most on this screen because the roster is the rank taxonomy's showcase.
5. WHISPER ALL / ANNOUNCE: reframe or drop. The console can broadcast *state* (ceremony phase); it never writes words in the Pope's voice.

### Screen 5 — Director Console: Ceremony (Gathering runtime)

**What works:** The Ceremony Phase stepper (Assembly → Procession → Knighting → Gora) is the best conceptual element in the batch after the SANCTION plate — it's §20's runtime made visible and matches the historical Gathering arc (§7). Phase timer, notes field, event name: all reasonable.

**Fixes:**

1. **Delete the attendance system.** The 24/28 counter, the red Absent roster, and MARK PRESENT / MARK ABSENT are all banned (no attendance tracking, no behavior recording, no manual entry of what the software already knows). Replace with a **PRESENT** list only — people who are here, detected automatically. Absence is simply not a concept the UI has. This also fixes the tone problem: a red "Absent" wall of shame on stream is the opposite of "recognition over grind."
2. **ANNOUNCE NEXT STEP → ADVANCE PHASE.** The button should transition runtime state (which every client's theater follows); the Pope does the announcing with his voice.
3. **Redundancy:** the right-edge quest-tracker-style phase widget duplicates the console's phase panel on the same screen. Decide the split: console = Pope's control, tracker-widget = congregation's view. A render should show one or the other per POV, not both.
4. Plain styling is correct for this surface. The phase stepper's engraved plates are a nice touch that stays within "faint ecclesiastical."

### Screen 6 — The Decree placard

**Fixes:**

1. **Kill the subtitle "A Peculiar Institution."** Two independent reasons: (a) it's the UI winking — the institution acknowledging it is peculiar breaks the prime tone rule; (b) "the peculiar institution" is the historical euphemism for American slavery — an association this guild does not want on a stream title card. This phrase should go on the never-generate list.
2. **Wrong object.** R5 specifies a notice nailed to a church door: single aged parchment, one iron nail, curled corners, small wax seal, blackletter "A GATHERING IS DECREED," two serif lines, one gold rule. The render is a flat beige rectangle with bullet icons — it reads as a system tooltip. Regenerate with the object-first prompting approach.
3. **Placement:** upper-right collides with the minimap/quest-tracker territory. R5 says upper-center, quest-tracker sized, ignorable.
4. Content structure (place / time lines) is right. "Tonight at 8:00 PM (Realm Time)" is fine; leave room for the one optional flavor line §14.1 allows.

---

## Cross-cutting craft notes (apply to every regeneration)

1. **One sacred action per surface.** SANCTION, KNIGHT THIS BEEF, and the verdict ratification are the only oversized iron-plate buttons in the product. Everything else is a quiet secondary. Current renders average four identical red buttons per window — with no hierarchy, nothing is sacred.
2. **Define color roles and hold them.** In this batch red means primary, destructive, absent, and decorative simultaneously. Suggested semantics: muted gold = sacred/affirmative; oxblood = rulings and finality (verdict, cowardice); parchment = content field; charcoal/iron = chrome; class colors reserved exclusively for class identity. Avoid modern green checkmarks entirely — they read as a SaaS onboarding checklist (and the main place they appeared, the eligibility panel, is deleted anyway).
3. **Typography is doing no work.** Titles, labels, body, and buttons are all the same condensed caps. The system needs three voices: blackletter (theatrical titles only), weathered serif (theatrical body/records), stock Friz Quadrata-style (console). If the blackletter never appears, the church never appears.
4. **No photoreal humans anywhere.** Portraits are in-game renders or painted/engraved medallions.
5. **Legibility at streaming distance.** The Records Book rows, roster lines, and matchup cards are 10px-dense. Every congregation-facing surface should be legible in a 720p Twitch stream; test each render by shrinking it to 33% — if a first-time viewer can't parse fighter names and the favor split, it fails R2/R9's standard.
6. **The batch skews backstage.** Four of six screens are console. The signature theatrical set pieces — Sanction proclamation (R1), Cowardice stamp (R4), Records tome (R6), Knighting banner (R7) — are exactly the renders that don't exist yet, and they're the ones that define the art direction. Prioritize them in batch 2.

---

## Canon Crib Sheet — append to every future prompt

**Ranks (the only ones that exist):** Fresh Beef, Cooked Beef, Beef Knight, Beef Lord, Beef Butcher, Beef Council. The Beef Pope is a role, not a rank. Never invent ranks (no Cardinal, Templar, Acolyte, Initiate, Squire, Crusader, Guardian).

**Sacred verbs:** SANCTION BEEF GORA · KNIGHT THIS BEEF · DECLARE VICTOR · COWARDICE RECORDED · VOID · MARK THIS MOMENT · SUMMON THE FAITHFUL.

**Gora outcomes:** Victor, Cowardice, Void, free ruling. No draws.

**Never render:** leaderboards, ranked tables, sortable columns, "Rankings" tabs, win percentages, ELO/ratings, match-fairness labels, eligibility checklists, thresholds (level/tenure/attendance), attendance counters or Absent lists, favor points/scores/toasts (+50 etc.), wagering/stakes systems, rules dropdowns, XP/points/currencies/streak-scores, RSVP/calendar chrome, photoreal human portraits, modern flat design, green checkmark lists, the phrase "A Peculiar Institution."

**Always true:** the gameplay is the hero (UI never covers the action; HUD ≤12% height) · theatrical surfaces = full parchment/iron/wax/blackletter identity · console surfaces = plain stock-Blizzard with at most a small seal · the UI never tells jokes and never acknowledges that beef is funny · one oversized sacred button per surface, everything else quiet.

---

## Suggested batch 2 order

1. **R6 Records Book tome** (replaces the rejected table — highest-risk surface to get wrong in code later)
2. **R4 Cowardice verdict stamp** + a matching VICTOR gold-seal variant (establishes the verdict moment the fused Screen 1 was missing)
3. **R2 Fight HUD at true ≤12% scale** with favor folded in, stained-glass class-colored health, head-to-head line
4. **R1 Sanction proclamation** (the signature moment — still unrendered)
5. **R5 Decree re-do** (nail, curl, seal, upper-center)
6. **Gora Desk v2** (screen 3 skeleton with the fixes above — keep it plain)

Screens 3/4/5's layout skeletons are keepers; regenerate them last and only to apply the deletions above. Screen 1's Records Book and the eligibility panel from screen 4 should not survive in any form.
