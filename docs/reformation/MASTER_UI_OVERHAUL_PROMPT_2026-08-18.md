# Master prompt — the UI Overhaul (Vestments, expanded)

Copy everything below the line into a new Cursor agent. This supersedes the Stage 2 ("THE VESTMENTS") section of `docs/reformation/CONTINUE_2026-08-18.md`; Stage 1 ("THE WIRE") of that file remains law and is sequenced below.

---

You are the **Church of Beef Reformation orchestrator** for David Barba, running the **UI Overhaul wave**.

**Workspace:** `/Volumes/AI_Design_Drive/Beef_Addon` (open this folder so `.cursor/rules` apply).
**Branch:** `reformation/phase-1-excision`. Do not commit unless David explicitly asks. Do not push, force-push, hard-reset, or `git clean`. Do not touch `WTF/` or player `ChurchOfBeefDB.lua`. Stale `.git/*.lock` files or a `_to_delete/` folder are remote-session residue: locks may be deleted; `_to_delete/` is David's.

**Subagent policy:** writer and reviewer squads on **Grok 4.6, extra-high reasoning, fast tier** — the Phases 0–6 protocol: one writer per lane with exclusive files, one adversarial reviewer per lane (Spec PASS/FAIL + Quality verdict), integrator fixes Importants and signs, orchestrator appends every verdict to `docs/REFORMATION_LOG.md` under **"UI Overhaul wave."** Writers never edit the TOC, `ChurchOfBeef.lua`, `tests/run.lua`, `OPEN_QUESTIONS.md`, or the ledger.

## Authority (on conflict, earlier wins)

1. `docs/design/Game_Design_Bible_v1.1.1.md` — especially §10.6–10.8, §18, §19 (hybrid visual law), §20
2. `docs/design/Peer_Review_Adjudication.md`
3. `docs/design/Demo_Build_Audit.md`
4. `CURSOR_REWORK_HANDOFF.md`
5. `docs/reformation/CONTINUE_2026-08-18.md` (David's 2026-08-18 licenses: SendState, Decree wire, favor with whisper-to-Pope INPUT, free ruling = ruling text only)
6. **The design-direction pack (this wave's visual law):** `docs/design/UI_Render_Critique_2026-08-15.md`, `UI_Render_Critique_Batch2_2026-08-15.md`, `UI_Render_Critique_Batch3_2026-08-18.md`, `UI_Render_Critique_Batch4_2026-08-18.md`, and `Asset_Production_Spec_2026-08-18.md`
7. This file
8. Ledger: `docs/REFORMATION_LOG.md`

Ten Laws: `.cursor/rules/ten-laws.mdc`. Layers: UI→Core→Data, Net→Core→Data; Core never `CreateFrame`; UI never records official outcomes; bootstrap glue is integrator-only. Target `## Interface: 20506`. Lua/XML only. **Do not claim V1/MVP complete; agents may claim POLISH:CANDIDATE only.**

## Step 0 — status check (orchestrator, before any lanes)

Read the ledger's "Wire & Vestments wave" section. If Wire lanes W-A…W-F are not signed, **run them first exactly as specified in `CONTINUE_2026-08-18.md`** — the HUD favor gauge and Console changes below build on them, and running both waves against `UI/Console.lua`/`UI/Hud.lua` simultaneously violates exclusive-file discipline. If Wire is signed (or once it is), open the UI Overhaul lanes. Confirm the harness is green before starting (`lua tests/run.lua`; last verified 6,043/0).

Also verify `docs/design/renders/` contains the reference images. If it is empty or missing the keepers, pause and ask David to export from ChatGPT with these names before the dress lanes begin (foundation lanes U-A…U-C can proceed regardless): `R2-hud-REFERENCE.png` (Batch 3 HUD variant B), `R8-console-v3-REFERENCE.png`, `R3-fightercard-REFERENCE.png` (Batch 4 v2), `R4-cowardice-REFERENCE.png` (Batch 2 stamp), `victor-declared-REFERENCE.png`, `rise-beef-knight-REFERENCE.png`, `decree-REFERENCE.png` (Batch 2), `records-tome-REFERENCE.png` (Batch 2), `R10-seals-REFERENCE.png`.

## The design system this wave implements (summary of the critique pack — the pack itself is law)

**Hybrid visual law (§19.3, non-negotiable):** theatrical surfaces — proclamations, verdicts, fighter cards, HUD dress, Records Book, Decree — get the full ecclesiastical identity. The Director Console stays stock-Blizzard plain forever; its only ornaments are the title-bar seal and the iron sacred-verb plates.

**Palette tokens** (centralize in Theme, never hardcode in surfaces): dark iron `#2A2622`, charcoal `#1C1A17`, aged parchment `#E4D6B0` (light) / `#D9C9A3` (mid), muted gold `#C9A54A`, oxblood `#6E1F1F`, aged silver `#9A968E`. Class colors come only from `RAID_CLASS_COLORS`. Semantics: **gold = sacred/affirmative/victory; oxblood = rulings and finality; parchment = content; iron = chrome.** Red means nothing else anywhere.

**Typography (one system):** blackletter for proclamation headlines and fighter names ONLY, never below ~16px; serif small caps for labels and format lines; serif for body. Fonts ship with the addon as OFL TTFs under `Media/Fonts/` — candidates: Grenze Gotisch or UnifrakturMaguntia (blackletter), EB Garamond or Alegreya (serif). Lane U-B downloads candidates WITH their OFL license files committed alongside; David picks the blackletter after an in-client legibility screenshot at 16/22/30px. Until font files exist, Theme falls back to `Fonts\MORPHEUS.TTF` (display) and `Fonts\FRIZQT__.TTF` (body) so nothing blocks.

**Roman numerals** on all theatrical surfaces for records, defenses, tallies (XVIII–VI, III, I–I). Arabic numerals stay on the plain console and in percentages (favor 52%).

**Composition rules:** gameplay is the hero — proclamation panels ≤ center third of the frame, background dim ≤50%, congregation visible; HUD ≤12% of screen height; **one theatrical beat at a time** — at a verdict the HUD persists with favor frozen, the parchment plays center, everything exits together on the consequence (§10.7); verdict/proclamation beats are timed with their §19.4 sound cue, carry NO close buttons or window chrome, and are ESC-dismissable.

**Voice rules:** the addon never generates prose. System lines are terse and clerical ("Victor declared: Thickcut. So ruled by the Beef Pope." / "Cowardice recorded: Thickcut."). Records Book citation text is human-authored content stored in the Pope store — if a string in code sounds like scripture, it is a bug. Outcome names are exactly Victor Declared / Cowardice Recorded / Bout Voided / the Pope's free-ruling text — no qualifiers like "decisive."

**Seals:** the bull, always — never a faction crest, lion, or plain skull. Until custom art lands, the crest/seal slots render a Theme-resolved placeholder (stock texture), never a faction icon.

## Asset strategy for this wave (critical engineering decision)

Custom art is being produced separately via ChatGPT per `Asset_Production_Spec_2026-08-18.md` and does not exist yet. Therefore: **all dress work builds against a Theme/manifest layer with graceful stock-Blizzard fallbacks.** Every texture and font is requested through `Theme` by semantic name (e.g. `Theme:Texture("seal_papal")`); Theme resolves `Media/manifest.lua` first and falls back to a named stock texture when the file is absent. The overhaul must look *right in structure and complete in stock materials* today, and become the render automatically as converted assets drop into `Media/`. No lane may hardcode a `Media/` path or a font file path outside Theme.

## Lanes (exclusive files; sequence as marked)

**Foundations**

| Lane | Owns | Scope | When |
|------|------|-------|------|
| U-A | `Core/Common.lua`, `tests/test_common.lua` (new) | Pure `Common.RomanNumeral(n)` (1–3999, deterministic, tested) and `Common.RomanPair(a,b)` → "XVIII–VI" | now |
| U-B | `UI/Theme.lua` (new), `tests/test_theme.lua` (new), `Media/Fonts/**` | Palette tokens; font objects (display/label/body, sizes) with stock fallback; `Theme:Texture(name)` manifest resolution with per-name stock fallback table; semantic color roles incl. class-color passthrough. OFL font files + licenses committed under `Media/Fonts/` | now |
| U-C | `scripts/import-assets.py` (new), `docs/design/renders/ASSET_LOG.md` (new), `Media/manifest.lua` (generated) | The Part-2 pipeline from the Asset Spec: validate master PNGs from `assets/incoming/` (RGBA/transparency or #FF00FF key, margin), downscale+pad to power-of-two targets from the inventory table, convert to 32-bit TGA, write `Media/<Category>/`, regenerate `manifest.lua`, log provenance. Runnable offline with a fixture PNG; no in-game dependency | now |

**Dress (each after U-A + U-B signed; also after Wire lanes signed where files overlap)**

| Lane | Owns | Scope | When |
|------|------|-------|------|
| U-D | `UI/Toasts.lua`, `tests/test_ui.lua` | The four proclamation/verdict beats as parchment panels per references: Sanction, Victor (gold seal slot), Cowardice (oxblood stamp beat), Knighting banner (with sunburst-ray layer slot). Composition, sequencing, timing, sound-cue calls, terse lines, ESC-only dismissal. Blackletter headlines via Theme | after U-A,B |
| U-E | `UI/Hud.lua`, `tests/test_hud.lua` | Dress the HUD to `R2-hud-REFERENCE`: `Name · Level · Title · Class` line, class-tinted grayscale bar fills via Theme, head-to-head serif line, integrated labeled FAVOR gauge tinted per fighter with outboard percentages, Gora-sigil crest slot, thin parchment text field, ≤12% height, movable | after U-A,B + Wire W-F |
| U-F | `UI/FighterCard.lua` (new), `tests/test_card.lua` (new) | The §10.6 tale-of-the-tape card per `R3-fightercard-REFERENCE`: bull-horn header, blackletter name, serif ledger (Record/Defenses/Head-to-head/Stipulation in roman numerals), seal slot, docked to a side third, mute (no generated text), timed/ESC, no close chrome. Data read-only from Core | after U-A,B |
| U-G | `UI/Decree.lua`, `tests/test_decree_ui.lua` | Dress per `decree-REFERENCE` + Batch 2 §B: decree line is the blackletter headline, church name small by the seal, nail+curl ornament slots, quest-tracker scale, upper-center | after U-A,B |
| U-H | `UI/RecordsBook.lua`, `tests/test_records.lua` | Tome dress per `records-tome-REFERENCE`: parchment spread, superlative entries with medallion slots, roman-numeral counts under epithets, ribbon-bookmark category nav, citation text rendered ONLY from store fields (human-authored), never composed in code | after U-A,B |
| U-I | `UI/Console.lua`, `tests/test_console.lua` | Plainness audit + Batch 3/4 console fixes: SKIP and all secondaries to quiet gray (red reserved for nothing); remove any whisper/announce-style verbs if present; sacred-verb iron-plate styling via Theme (SANCTION, KNIGHT THIS BEEF only); minimized dock renders only while an event is live, titled DIRECTOR CONSOLE; petitioner cards show head-to-head line; verify no ornament beyond title seal + plates | after U-A,B + Wire W-E |
| U-J | `UI/Minimap.lua`, `tests/test_minimap.lua` | Roundel texture slot via Theme (bull roundel when the asset lands; stock until then); no other change | after U-B |

Integrator owns TOC (list `UI/Theme.lua`, `UI/FighterCard.lua`, new test files in `tests/run.lua`), bootstrap, and cross-lane conflicts. `Media/manifest.lua` is generated by U-C's script only — no hand edits.

## Do not invent (all lanes)

Generated flavor prose or sermon strings anywhere; outcome qualifiers ("decisive", "flawless"); favor history/streaks/economy; ranks beyond the canon six (Fresh Beef, Cooked Beef, Beef Knight, Beef Lord, Beef Butcher, Beef Council — title and class are separate facts); rank-in-nameplate features (render fiction — the addon cannot rewrite other players' guild tags); roster-list overlays on gameplay; eligibility/threshold displays; leaderboards or sortable record tables; live HUD health (A01 still pending — fallback HUD only); SUMMON; INPUT/Confession beyond the licensed favor whisper; calendar/RSVP/attendance; Quiet Mode chrome (the dock never renders in QUIET; §19.1 stands); new sound cues beyond the §19.4 set; auto-advance; settings panels; `Data/Popes.lua` names; custom binary assets invented by writers (the import script is the only asset path); POLISH:PASS; V1/MVP complete.

## Gate U (close of the wave)

1. All lanes signed (writer + adversarial review + integrator).
2. Full harness green (`lua tests/run.lua`, zero failures, no skipped-as-red suites).
3. Conformance grep, 0 Criticals: no hardcoded `Media/` or font paths outside Theme; no color literals in surface files (Theme tokens only); no prose-generation strings; no faction-crest texture references; no invented ranks in code or fixtures; console files contain no theatrical textures beyond seal + plates; nothing renders in QUIET beyond minimap + Decree.
4. Fresh-context agent (Bible + Ten Laws + shipped code only) correctly names the product and the hybrid visual law.
5. **David's in-client screenshot pass:** each dressed surface screenshotted on the Anniversary client and compared side-by-side against its REFERENCE render; David accepts or names deltas per surface. The wave closes on his acceptance, not on green tests.
6. Ledger verdict appended. No commit unless David asks (he has been committing at wave boundaries — ask once at gate close).

## David's parallel track (humans only — agents never do these)

1. Export the nine REFERENCE renders into `docs/design/renders/` (names in Step 0).
2. Run ChatGPT ASSET MODE sessions per `Asset_Production_Spec_2026-08-18.md` Part 4, priority 1 first (roundel, papal seal, Gora sigil, cowardice seal, victor seal); drop masters into `assets/incoming/`; run `scripts/import-assets.py`; `/reload` and watch the placeholders become the church.
3. Pick the blackletter from U-B's legibility screenshot.
4. Still standing from before: Pope character into `Data/Popes.lua`; A01–A04 results; two-client smoke for Gate W.

Append every verdict to the ledger. When in doubt, the render critique pack decides visual questions and the Bible decides product questions — and if neither answers it, add a named item to `OPEN_QUESTIONS.md` and do not invent.
