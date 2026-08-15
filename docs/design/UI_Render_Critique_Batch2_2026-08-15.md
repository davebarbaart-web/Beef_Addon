# Church of Beef — UI Render Critique, Batch 2
**Date:** 2026-08-15
**Scope:** 5 unique renders — Director Console v2, the Decree (Goldshire), the Sanction Proclamation, Fight HUD v2, the Records of the Gora tome, the Cowardice verdict stamp — judged against `Game_Design_Bible_v1.1.1.md` and the Batch 1 critique (`UI_Render_Critique_2026-08-15.md`).
**Text-garble rule still applies:** misspellings and name inconsistencies are ignored; structural inventions are not.

---

## Verdict in one paragraph

This batch fixed the biggest problem in the project. The hybrid visual law now exists on screen: the Director Console stayed stock-plain while the Sanction proclamation, verdict stamp, Records tome, and Decree came back in full parchment-iron-wax-blackletter identity — and the contrast between them finally reads as the design statement it's supposed to be. Four of six renders are keepers as art direction. The remaining problems are now second-order and specific: one invented rank ("Beef Squire" / "Beef Paladin") keeps leaking into fighter plates and queues, the theatrical overlays dim the game world far too aggressively (the gameplay-is-the-hero rule is being lost to mood lighting), the software has started *writing prose in the Pope's voice* (Records Book scripture, verdict chat oratory — both banned), and the console is still missing its second sacred verb: there is a SANCTION plate but no KNIGHT THIS BEEF plate. Fix those four and this direction is ready to inform code.

---

## Scoreboard vs. Batch 1

| Batch 1 finding | Status in Batch 2 |
|---|---|
| Hybrid visual law absent — everything plain | **Fixed.** Theater is ornate, console is plain. The core thesis is on screen. |
| Records Book as banned leaderboard table + Rankings tab | **Fixed.** Tome, superlatives, medallions, rivalry spread, zero tables. |
| Eligibility Check thresholds panel | **Fixed.** Gone entirely; replaced with rank/referrer/location context. |
| Attendance tracker, Absent shaming, MARK PRESENT/ABSENT | **Fixed.** PRESENT-only roster. |
| Win %, "Balanced: Even Match" odds labels | **Fixed.** Head-to-head lines ("1 – 0 vs …") replaced ratings. Exactly right. |
| "+50 Favor" points toast | **Fixed.** No favor economy anywhere in this batch. |
| Photoreal human portraits | **Fixed.** Painted WoW-style portraits and medallions throughout. |
| HUD oversized, favor floating separately | **Mostly fixed.** Single top bar ≈ spec height; favor folded in. Detail issues below. |
| Four coequal red buttons per window | **Fixed.** One SANCTION plate + one small SKIP. (New problem: a missing verb — below.) |
| Invented ranks (Cardinal, Templar, Acolyte, Squire…) | **Half-fixed.** The Present roster is now perfectly canon — all six real ranks. But "Beef Squire" survives in the Knighting Queue and the Sanction plate, "Beef Paladin" in the HUD, and Acolyte/Templar/Initiate still haunt background nameplates. |
| W/L/D draws column | **Fixed.** Records now read "18 – 6". |
| "A Peculiar Institution" | **Fixed.** Gone. |

That is 11 of 12 major findings addressed. Whatever you pasted into the GPT prompt worked — keep pasting it.

---

## The four remaining systemic issues

### 1. One invented rank keeps regenerating: "Beef Squire" (and "Beef Paladin")

The Present roster proves the model *can* hold the canon list — it renders all six real ranks perfectly. But everywhere a *fighter or candidate* is labeled, the model reaches for RPG-flavored fillers: Beef Squire (Knighting Queue, Sanction plate), Beef Paladin (HUD), plus Acolyte/Templar/Initiate in crowd nameplates. Two corrections for the prompt:

- A Knighting Queue candidate's current rank is **Cooked Beef** (that's who gets Knighted — the Cooked→Knight funnel). Never "Squire."
- A fighter plate shows Church title + class as **separate facts**: "Beef Knight · Warrior," never a fused "Beef Paladin."

Suggested prompt line: *"The only Church titles that may appear anywhere, including background nameplates: Fresh Beef, Cooked Beef, Beef Knight, Beef Lord, Beef Butcher, Beef Council. 'Squire', 'Paladin', 'Acolyte', 'Templar', 'Initiate' etc. are classes or forbidden — a title plate reads 'Beef Knight · Warrior'."*

### 2. The dimming is eating the game world

Sanction proclamation and Cowardice verdict both darken gameplay to near-black (~85–90% dim) and fill well over half the frame. Bible §1/R1/R4: the world is the show; the proclamation occupies the center third, "dramatic but not covering the crowd entirely." At this dim level, a first-time Twitch viewer sees a static parchment JPEG, not a guild event. Regenerate both with: panel ≈ one-third of frame width, background dim ~40–50%, congregation clearly visible and lit (they are the reaction shot — the crowd IS the comedy). The verdict stamp can stay bigger than the sanction (it's the heaviest beat in the product) but the crowd must survive it.

### 3. The software has started speaking in the Pope's voice

Two places, both violations of "the card is mute / the console never announces in the Pope's place" (§10.6, §18.2, §4.2):

- **Verdict chat oratory:** "Thickcut has been found wanting in courage… Let it be known across the Valley of Strength… May all who bear witness remember. Beef endures." That's five lines of generated sermon. The system line is terse and clerical — *"Cowardice recorded: Thickcut. So ruled by the Beef Pope."* — and the oratory comes out of David's mouth on stream, not the addon.
- **Records Book scripture:** "His victories are not merely won—they are ordained," "This is not hatred. This is devotion. This is Beef." As *mood text in a render*, gorgeous — and honestly, "always chewing" is the right voice. But flag hard for the Cursor handoff: **every prose line in the Records Book is human-authored content** (Pope-written epithets and citations, entered via MARK THIS MOMENT / honorifics), never generated by the addon. The data model stores a superlative + holder + optional human citation. If the addon auto-writes scripture, it automates the color commentary, which is the one sin §4.2 exists to prevent.

Renders may keep placeholder prose; the critique note is for the code phase and for keeping GPT from designing an auto-poetry panel.

### 4. The Knighting desk has no verb

The console now has exactly one sacred plate — SANCTION — which belongs to the Gora Desk. The Knighting Queue's entire interaction model is **KNIGHT THIS BEEF** (§8): one plate, same iron-slab weight class as SANCTION, that performs everything and stages the next candidate. Right now the queue's only button is SKIP, styled in alarm-red as if skipping were destructive. Fix: add the KNIGHT THIS BEEF plate under the candidate panel; restyle SKIP as a small quiet secondary. Two desks, two plates, and the visual grammar "big iron slab = sacred verb" becomes a system.

---

## Screen-by-screen

### A — Director Console v2 (Present / Knighting Queue / Gora Desk)

**Keep:** overall plainness with the single bull seal in the title bar (exactly the §19.3 "faintest ecclesiastical touch"); canon rank roster with rank-colored shields; parchment-tinted petitioner cards; head-to-head lines; Challenged field; the SANCTION plate.

**Fix:**

1. **Add KNIGHT THIS BEEF** (issue 4 above); demote SKIP.
2. **Queue ranks → Cooked Beef** (issue 1). Also the candidate detail block contradicts itself — "NEXT: Beef Knight" over a candidate whose CURRENT RANK reads "Beef Knight." Structure it as: current rank (Cooked Beef) → next rank (Beef Knight), and REFERRED BY should be a *person's name*, not "Beef Council."
3. **SANCTION has no visible object.** Three petitioner cards, no selected pairing — what exactly gets sanctioned? Add a "proposed bout" slot directly above the plate: `Juicyj vs Meat Is Murder` + the one-line STIPULATION field (§10.3) + the favor-display toggle (§10.6). The Pope taps a pairing, it loads the slot, SANCTION fires. This is the single most important interaction-clarity fix in the batch.
4. **"Present: No" rows shouldn't exist.** §10.2: the pool shows only petitioners who are present and alive. Either filter Crusade Ready out or gray the whole card to ~40% with the petition retained but visibly un-sanctionable. A red "No" the Pope must read is the wrong model — absence should be self-evident.
5. **Add the one-tap dismiss** per petitioner card (§10.2's consequence-free dismissal) — a small quiet ✕, not a red button. The current gold icon per card is illegible as an affordance.
6. **Challenge callouts deserve a badge.** "Challenged: Meat Is Murder" as a data row undersells the oldest dueling tradition there is. Give called-out petitions a small crossed-gauntlet marker on the card edge — the Pope should spot a DEMAND at a glance.
7. Present roster: fine as a rank legend for a render; for the next pass show it as a real roster (multiple members per rank, needs-Knighting flags on Cooked Beef rows — §18.1).

### B — The Decree (Goldshire)

**Keep:** the object itself — nailed parchment, curled corner, wax bull seal, quest-tracker scale, upper-center, untouched gameplay. This is R5 essentially solved, and it passes the "notice on a church door" test.

**Fix:**

1. **Hierarchy is inverted.** "A GATHERING IS DECREED" — the actual proclamation — is the smallest line, while CHURCH OF BEEF is the headline. Swap: the decree line is the big blackletter; the institution is the signature (small line near the seal, or omitted entirely — the bull seal *is* the letterhead). §14.1 specifies the decree text as the header.
2. **Drop the cross glyphs** (✠) flanking the church name. Two reasons: the Church's mark is the bull, and real ecclesiastical crosses drift the addon toward actual-religion iconography it doesn't want. Bull sigils or gold rules instead.
3. Parchment reads slightly bright/clean against the master palette — one notch more aged/candle-warm, and it stops looking like a printed card.
4. Leave visual room for the one optional flavor line §14.1 allows under place/time.

### C — The Sanction Proclamation

**Keep:** parchment + iron corner fittings, gold bull ornament, blackletter headline, facing name plates with VS, wax seal with ribbon. The object is right.

**Fix:**

1. **Panel too big, world too dark** (issue 2). Center third; congregation visible.
2. "Beef Squire" on Marbled's plate (issue 1) — "Beef Knight · Warrior" / "Cooked Beef · Warrior" format.
3. **Add the head-to-head line** when history exists — one italic serif line under the VS row: *"Their third meeting — one victory each."* §10.6 names this as sanction-presentation material and it's the single cheapest drama upgrade available.
4. The name plates are visually starved relative to the headline — slightly larger, with class color on the name or plate edge. The headline announces; the plates are what the crowd actually reads.
5. Candles mounted on the corner fittings read a little prop-like; candle *glow* on the parchment edges (R1's "the document is the light source") beats literal candlesticks.

### D — Fight HUD v2

**Keep:** single top-center bar at roughly spec height, painted portraits in iron frames, records inline, and — the star — **"THIRD MEETING · ONE VICTORY EACH"** dead center. That line is the rivalry engine rendered exactly as §10.7 intends. The composition finally proves the HUD can carry a 40-body scrum.

**Fix:**

1. **Both health bars are generic green.** Spec is class color (and R2's stained-glass-set-in-iron treatment — the one place the cathedral identity belongs inside the HUD). Two green bars also means at a glance you can't tell whose is whose from color alone.
2. **The favor gauge is unreadable as favor.** The gold-vs-red split under the crest has no labels, no percentages, and its colors map to neither fighter — it currently reads as a cast bar or a shared resource. Fix: tint each half to its fighter (class color or portrait-frame accent), add small percentages at each end, and a tiny "FAVOR" label or thumb sigil at center. A first-time viewer must decode it in one second.
3. **The center crest is the Horde faction icon.** Wrong institution — this slot belongs to the Gora sigil (crossed axes / bull). Faction iconography also breaks on Alliance-side events.
4. "Beef Paladin" (issue 1) → "Beef Lord · Paladin" format; add levels (spec: name, class color, level, title, record) and defense count where relevant.
5. No timer this round — fine; the Bible doesn't require one. If it returns, put it small under the head-to-head line, never bigger than the fighters' names.

### E — The Records of the Gora (tome)

**Keep:** almost everything. Two-page spread, illuminated capitals, superlative entries with medallions and wax-ribbon seals, the Greatest Rivalry facing-portraits page with crossed swords and **III – III** in roman numerals, no columns, no ranks, no search box. This is the §10.9 replacement for the rejected leaderboard, rendered correctly on the first try. The roman-numeral tally is an inspired detail — adopt it as the *system-wide* convention for counts in theatrical surfaces (records, defenses, tallies), because Roman numerals read as chronicle, not stat.

**Fix:**

1. **Mark all prose as human-authored** (issue 3). For the render itself no change needed; for the spec handoff, each entry = superlative title + holder + optional *Pope-written* citation. The addon never writes "his victories are ordained."
2. **Superlatives should carry their number, chronicle-style.** "Most Sanctioned Victories — Highbeef" shows no count; "XIV VICTORIES" in small caps/roman numerals under the epithet keeps it liturgical while still answering the bragging question.
3. The bottom red ribbons are begging to be **category bookmarks** — label them (VICTORIES · RIVALRIES · MARTYRS · COWARDICE) and they become the tome's navigation without adding any modern chrome. Add a subtle page-turn corner affordance.
4. Scale note for implementation (not the render): this is a browsable window, not an event overlay — it should open at something like 70% frame height, movable, world visible. As a full-bleed mood piece it's fine.
5. Asset-production warning: the three medallion portraits are stylistically inconsistent (one near-neon green). Fine in concept art; the real asset set needs one engraver's hand — reference R10's "style consistency across the set matters more than detail."

### F — The Cowardice Verdict stamp

**Keep:** the best render across both batches. Stamp mid-impact, wax seal with Latin motto ring and fleeing-figure sigil, "SO RULED BY THE BEEF POPE," "BEEF IS ETERNAL" engraved on the stamp barrel (keep that forever). This is R4 achieved — institutional finality with zero winking.

**Fix:**

1. **The red spatter reads as blood.** A court does not bleed on its paperwork; it drips wax. Recolor/reshape the spatter as wax droplets and ink flecks — the violence is bureaucratic, which is funnier.
2. **Dim level** (issue 2): the congregation is nearly gone. This beat plays *in front of* forty witnesses; keep them visible. The stamp moment can hold 50–60% of frame — it's the heaviest consequence in the product — but not on a black void.
3. **Replace the chat sermon** with the terse clerical line (issue 3).
4. The stray "Church of Beef / Gora Judge" unit frames top-left are render noise — exclude via negative prompt ("no player/target unit frames during verdict overlay").
5. For implementation: this is a timed beat with its own sound (§19.4 — Cowardice gets its own cue), entering at ratification, exiting to the consequence. No close button, no interaction. The render already implies this — preserve it in spec.

---

## Paste-ready block for the next GPT round

> KEEP: overall art direction from this batch — plain console vs. ornate parchment/iron/wax theater; painted portraits; roman-numeral tallies; the "BEEF IS ETERNAL" stamp barrel; the head-to-head line in the HUD.
> CHANGES, all renders: (1) The only Church titles that exist: Fresh Beef, Cooked Beef, Beef Knight, Beef Lord, Beef Butcher, Beef Council — title and class are separate facts ("Beef Knight · Warrior"); never Squire, Paladin-as-title, Acolyte, Templar, Initiate, anywhere, including background nameplates. (2) Theatrical overlays cover at most the center third of the screen with background dimmed no more than ~50% — the congregation must stay clearly visible. (3) The addon never writes sentences in chat or flavor prose; system lines are terse and clerical ("Cowardice recorded: Thickcut. So ruled by the Beef Pope."). (4) Director Console: add a second iron plate, KNIGHT THIS BEEF, under the Knighting candidate; make SKIP small and quiet; add a "proposed bout" slot above SANCTION showing the selected pairing plus a one-line STIPULATION field; petitioners not present are grayed out, never listed with a red "No". (5) Fight HUD: class-colored stained-glass health bars; favor split tinted to each fighter with small percentages and a FAVOR label; replace the Horde crest with the Gora bull/crossed-axes sigil; add fighter levels. (6) Decree: "A GATHERING IS DECREED" is the large blackletter headline, the church name is small near the seal; replace cross glyphs with bull sigils. (7) No blood spatter — wax droplets and ink only.

## Batch 3 priorities

1. **R3 Fighter Card** — still never rendered, and it's a §10.6 MVP surface (tale of the tape: name, class/portrait, level, title, record, defenses, head-to-head line, stipulation line, small seal).
2. **R7 Knighting Proclamation** ("RISE, BEEF KNIGHT") — the other signature ceremony beat, still unrendered.
3. **Victor verdict** — gold-seal counterpart to the Cowardice stamp (DECLARE VICTOR needs its moment; today only the coward gets theater).
4. **Console v3** — KNIGHT THIS BEEF plate + proposed-bout slot + stipulation line (the two fixes that change interaction, not just paint).
5. **HUD v3** — class-color/stained-glass bars, labeled favor split, Gora sigil.
6. **R9 full stream-frame composition** — now that the pieces exist, prove they compose: HUD + minimized console + a verdict fading, world ≥80%.

Both critique docs now live in `docs/design/` alongside the prompt pack so the render history and the reasoning travel together.
