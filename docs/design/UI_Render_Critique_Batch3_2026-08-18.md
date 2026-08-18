# Church of Beef — UI Render Critique, Batch 3
**Date:** 2026-08-18
**Scope:** 6 unique renders — Fight HUD variant A (with black verdict box + minimized console), Fight HUD variant B, Director Console v3, "Victor Declared" parchment, the Fighter Card (R3, first render) — judged against `Game_Design_Bible_v1.1.1.md`, the Batch 1–2 critiques, and the Wire & Vestments wave handoff (`CONTINUE_2026-08-18.md`).
**Text-garble rule still applies.** Structural inventions do not.

---

## Verdict in one paragraph

This batch crossed the line from "concept exploration" to "reference art." Fight HUD variant B is the spec, achieved: correct `Name · Level · Title · Class` format with canon ranks, class-colored bars, the head-to-head line, a labeled FAVOR gauge with percentages, and the Gora sigil where a faction crest used to be. Console v3 landed nearly every Batch 2 ask — KNIGHT THIS BEEF plate, Cooked Beef → Beef Knight queue framing, the Proposed Bout slot with a STIPULATION line above SANCTION, per-card dismiss ✕, and grayed-out absent petitioners. The Victor Declared parchment adopted the terse clerical voice word for word. The remaining work is no longer "fix the design" — it's **pick the winners and kill the forks**: the batch contains two incompatible HUDs, two incompatible verdict languages, a regression of invented ranks in one corner widget, and a recurring faction-crest problem that has now survived three batches. Decide those four things and this art direction is ready to hand to the Vestments lanes as reference.

---

## Scoreboard vs. Batch 2 asks

| Batch 2 ask | Status |
|---|---|
| Title and class as separate facts ("Beef Knight · Warrior") | **Done** in HUD-B and Fighter Card. HUD-A omits it; Victor-screen side widget regresses (below). |
| Canon ranks only | **Mostly done** — HUD-B, Console, Fighter Card, and even crowd nameplates ("Fresh Beef Ribeye <Church of Beef>") are canon. One regression: the Victor screen's left-edge roster (Cardinal/Paladin/Templar/Acolyte/Initiate). |
| Favor split labeled, percentages, fighter-tinted | **Done** in HUD-B (52/48, FAVOR label, gold/blue halves matching the fighters). HUD-A's version is unlabeled green/blue that reads as a second health bar. |
| Replace Horde crest with Gora sigil in HUD | **Done in HUD-B.** HUD-A uses a bull skull (closer, but demonic); Fighter Card seal is the Horde crest; Victor seal is a lion. The seal problem persists everywhere except HUD-B. |
| KNIGHT THIS BEEF plate; SKIP small and quiet | **Done.** Two iron plates now exist, one per desk. SKIP is small (still red — make it gray). |
| Knighting candidate as Cooked Beef → Beef Knight | **Done, verbatim** ("Current: Cooked Beef / Next: Beef Knight"). |
| Proposed Bout slot + one-line STIPULATION above SANCTION | **Done** ("Thickcut vs Mugthok" / "First to bleed."). This fixes the sanction-has-no-object problem completely. |
| Absent petitioners grayed, not red-flagged | **Done** — Longmeat and Steakness render at ~40% opacity. Exactly right. |
| One-tap dismiss per petition | **Done** (✕ per card). |
| Terse clerical verdict line | **Done, word for word:** "Victor declared: Thickcut. So ruled by the Beef Pope." |
| Center-third overlay, ≤50% dim, crowd visible | **Done** on Victor Declared — amphitheater crowd clearly readable. |
| No blood spatter | **Done.** |
| Kill WHISPER ALL / console speaking for the Pope | **Not done** — WHISPER ALL survives, third batch running. |

---

## The four decisions this batch forces

### 1. There are two HUDs. Ship B, kill A.

HUD-A (bull-skull crest, "GORA" nameplate, detached favor bar) and HUD-B (integrated iron bar, titles, head-to-head, labeled favor) are different products. **B is the reference.** A's specific failures, so the reasons travel with the verdict: no titles or head-to-head line (the rivalry engine, gone); generic green-vs-blue bars where blue reads as *mana* to any WoW player; a favor bar recolored to match the health bars so it reads as a second health readout; a detached second row eating extra vertical space; and a skull crest that reads necromancer, not church. Nothing in A needs to survive except one idea — the **minimized Director Console** in the corner (SANCTION plate + expand control), which is R9's requirement and should be re-rendered as its own small study.

### 2. There are two verdict languages. The parchment is the verdict; kill the black box.

HUD-A's floating "VERDICT / Thickcut / DECISIVE VICTORY" tooltip and the Victor Declared parchment are competing for the same beat. The parchment wins — it's the theatrical surface the hybrid visual law demands, and it already has the right voice. The black box fails three ways: it's a stock dark frame on a theatrical beat (Law: theater gets full identity); it stacks *on top of* the HUD and favor bar so the consequence moment is the busiest the screen ever gets, when it should be the cleanest; and "DECISIVE VICTORY" invents an outcome qualifier — the four rulings are Victor, Cowardice, Void, and free ruling, and adjectives like "decisive" are the Pope's spoken flourish, never the software's. Sequence per §10.7: HUD persists through the verdict beat, favor bar freezes, parchment plays center-screen, everything exits together on the consequence.

### 3. The seal is the bull. Always. On everything.

Three batches, same drift: Fighter Card wax seal = Horde crest; Victor Declared gold seal = a lion (an *Alliance* lion, presented to a Horde congregation — the one joke the institution must never accidentally tell); HUD-A = generic demon-skull. HUD-B got it right. The fix is a standing prompt line, and it's also exactly why render R10 (the iconography & seal sheet) should be the next generation priority — one canonical bull-seal family (papal seal, Gora sigil, cowardice sigil, chronicle mark) that every future render references. Until R10 exists, this regression will keep happening.

### 4. The Victor screen's left-edge roster widget: kill it entirely.

It regresses to invented ranks (Beef Cardinal/Paladin/Templar/Acolyte/Initiate) — but the deeper problem is that the widget itself is not a surface that exists. A persistent congregation-roster overlay during a verdict is exactly the "always-visible panel" §19.1 warns kills products, it duplicates the console's Present desk, and it clutters the frame at the most theatrical moment. Add to the negative prompt: *no roster list overlays on gameplay; the only Event Mode congregation surfaces are the HUD, proclamations, and the favor prompt.*

---

## Screen-by-screen

### Fight HUD variant B — the keeper

**Adopt as the V-D reference render.** Format line, canon titles, class-colored stained-bar halves, head-to-head center line, labeled favor with outboard percentages, Gora sigil crest, ~10% height, crowd and fighters fully readable. Remaining polish, all minor:

1. The bar chrome is clean dark iron but the *parchment* half of the identity is absent — the R2 brief wanted "iron-and-parchment." A thin parchment field behind the name/title text (like the Console's petitioner cards) would tie the HUD to the rest of the theater without adding weight.
2. Favor halves are gold/blue matching the fighters — good — but the FAVOR label plate sits exactly where the eye expects a cast-bar spark. A small thumb-or-bell sigil on the label would disambiguate at streaming distance.
3. Portraits: the left portrait is a lion-ish beast head while the right is a proper character portrait — unify on painted character portraits (Batch 2 standard).
4. Head-to-head line placement is perfect; keep it in small caps serif, never blackletter (blackletter at 11px smears on stream).

### Director Console v3 — reference layout, three fixes and two sample-data notes

The structure is now §18.1 achieved: Presence / Knighting Queue with plate / Gora Desk with petitions → Proposed Bout → STIPULATION → SANCTION. Fixes:

1. **WHISPER ALL: kill it** (third request). The console never speaks in the Pope's place — §18.2 is unambiguous. If the underlying need is "get everyone's attention," that is SUMMON THE FAITHFUL, which is deliberately out of scope and still wouldn't be a whisper.
2. **Head-to-head context disappeared from petitioner cards** — v2 had "Head-to-Head: 1–0 vs Meat Is Murder" and v3 dropped it for Reason/Note free text. Restore it; it's the §10.5 context the Pope performs with. Collapse Reason/Note into one optional note line (petition free text, private to the console per §13.4).
3. **SKIP is still alarm-red** — make it the same quiet gray as CLOSE-type secondaries. Red on this console should mean nothing at all (SANCTION and KNIGHT THIS BEEF are iron, everything else is furniture).
4. *Sample data:* six of eight visible members are Beef Council. Council is scarce trusted leadership — a roster that's 75% Council teaches the wrong pyramid to anyone using these renders as code fixtures. Realistic mix: mostly Beef Knights, a few Fresh/Cooked, one or two Council, one Lord.
5. *Sample data:* drop "v3" from the title bar in the final; version numbers are workshop chrome. And the Proposed Bout should name people who exist in the visible petition queue, so the interaction story reads coherently.

### Victor Declared — right voice, wrong font and seal

The beat itself is correct: center panel ~40%, crowd visible, moderate dim, iron corner pins, terse ruling. Fixes:

1. **Typography breaks the system.** "VICTOR DECLARED" is rendered in Trajan-style roman caps; Batch 2's sanction proclamation established blackletter as the theatrical display voice ("A Beef Gora is Sanctioned"). One display face for all proclamations — blackletter headline, serif body. As rendered, sanction and verdict look like different addons.
2. **The seal is an Alliance lion** — bull, always (decision 3).
3. Redundant copy: headline "VICTOR DECLARED" + body "Victor declared: Thickcut." Say it once each way: headline VICTOR DECLARED, body "Thickcut. So ruled by the Beef Pope."
4. The gold-seal-for-victory / red-wax-for-cowardice duality (this render vs. Batch 2's stamp) is excellent and should be codified: **gold = elevation and victory; oxblood = cowardice and finality.** Add to the style law.

### Fighter Card (R3, first appearance) — right contents, wrong costume

Everything *inside* the frame is right, and several things are exactly right: `Thickcut / Level 60 / Beef Knight · Warrior` in the corrected format, **roman-numeral record XVIII–VI** (the Batch 2 convention, adopted), Defenses III, Head-to-head I–I vs Mugthok, a stipulation line, and a mute card — no generated hype text. Fixes:

1. **The frame is death-knight gothic, not church.** Twin skulls at the top corners and spiked black iron read Scourge; R3 specifies an illuminated-manuscript page — iron *and gold flourish*, heraldic banner top carrying the fighter's name in blackletter, worn parchment. Keep the parchment interior and stat-ledger layout; replace the skull furniture with bull heraldry and gold rules.
2. Seal: Horde crest → bull (decision 3).
3. Stat-row icons are generic Warcraft glyphs; fine as placeholders, but the R10 sheet should eventually supply a matched engraved set (record = crossed axes, defenses = shield, head-to-head = facing bulls, stipulation = scroll).
4. *Sample-text caution:* "Winner may petition for lordship" reads like a rules-engine clause. Stipulations are the Pope's spoken color ("no potions; combatants shall be nude") — and lordship isn't petitioned, it's earned by a fair win (§10.4). Harmless in a render, but don't let it seed the code fixtures.
5. Composition note: at this width the card covers the ring where the fighters stand. R3 places it "at the side of gameplay" — dock it left or right third, fighters visible beside it.

---

## Paste-ready block for the next GPT round

> KEEP: Fight HUD variant B exactly as structured (it is now the reference); Console v3 layout; the Victor Declared beat's scale, dim, and wording; the Fighter Card's contents, format line, and roman numerals; gold-vs-oxblood verdict duality.
> KILL: the other HUD (skull crest, detached favor bar); the black "VERDICT / DECISIVE VICTORY" tooltip — the parchment IS the verdict, and outcome names are only Victor Declared / Cowardice Recorded / Bout Voided; the left-edge congregation roster overlay (no roster lists over gameplay, ever); WHISPER ALL on the console.
> CHANGES, all renders: (1) Every seal, crest, and wax impression is the BULL — never the Horde crest, never a lion, never a plain skull. (2) One theatrical display face: the blackletter from "A Beef Gora is Sanctioned" for every proclamation headline; serif for body; never roman movie-poster caps. (3) The only ranks: Fresh Beef, Cooked Beef, Beef Knight, Beef Lord, Beef Butcher, Beef Council — including side widgets and nameplates; title and class stay separate facts. (4) Console sample roster: mostly Beef Knights, a couple Fresh/Cooked, one Lord, at most two Council; petitioner cards regain the head-to-head line; SKIP goes quiet gray; drop "v3" from the title. (5) Fighter Card: replace skull frame furniture with bull heraldry + gold flourish, dock the card to one side of the screen, bull wax seal. (6) HUD-B polish: thin parchment field behind name/title text, painted character portraits both sides, small sigil on the FAVOR label.
> NEXT: render R10 — the iconography & seal sheet (papal bull seal, Gora sigil, cowardice fleeing-figure, chronicle mark, minimap roundel, at two sizes) — so every future render pulls from one canonical seal family.

## Batch 4 priorities

1. **R10 seal & icon sheet** — root-causes the faction-crest drift and feeds real asset production.
2. **R7 Knighting proclamation** ("RISE, BEEF KNIGHT") — the last signature ceremony beat never yet rendered.
3. **Minimized console study** — the corner dock from HUD-A's screen, done properly: SANCTION plate + expand, nothing else.
4. **R9 full stream frame** — HUD-B + minimized console + a verdict parchment mid-fade, world ≥80%, as the composition proof.
5. **Fighter Card v2** with the church frame.

## Handoff note to the Cursor wave

HUD-B and Console v3 are now good enough to serve as the visual reference for Vestments lanes **V-D (HUD dress)** and the console's *permanent plainness check* respectively; Victor Declared joins the Batch 2 Cowardice stamp as the two verdict beats for **V-B**. When these renders are saved to `docs/design/renders/`, name them so the lanes can cite them (e.g. `R2-hud-REFERENCE.png`, `R8-console-v3-REFERENCE.png`) — the wave's lane briefs already point at the critique docs.
