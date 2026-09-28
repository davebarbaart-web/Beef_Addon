# Guild-night playtest — small Gathering prep

**Status:** NOT RUN. Do not tick this file as done. Do not date a pass.

**Purpose:** A live guild night after [`solo-smoke.md`](solo-smoke.md) and [`two-client-smoke.md`](two-client-smoke.md). A small real Gathering attempt — not the streamed MVP, not the chaos dress rehearsal. Humans tick with date + character. Leave every box `[ ]` until a human walks it on Anniversary.

**Law:** [`Game_Design_Bible_v1.1.1.md`](../design/Game_Design_Bible_v1.1.1.md) §7 (Gathering), §14.1 (Decree), §18 (Console), §20 (runtime), §22.3 (definition of done). Ten Laws: [`.cursor/rules/ten-laws.mdc`](../../.cursor/rules/ten-laws.mdc) and [`TEN_LAWS.md`](../reformation/phase-0/TEN_LAWS.md). On conflict, the Bible wins.

**Install / reload:** [`.cursor/skills/church-of-beef-dev/SKILL.md`](../../.cursor/skills/church-of-beef-dev/SKILL.md). Reinstall `addon/ChurchOfBeef/` → Anniversary `Interface/AddOns/ChurchOfBeef/`. **Never touch `WTF/`** or player `ChurchOfBeefDB.lua`.

**Companions (do not duplicate):**

| File | What it is | This night |
|------|------------|------------|
| [`v1-checklist.md`](v1-checklist.md) | The Bible §22.3 walk | Point at it. Do not tick §22.3 here. |
| [`dress-rehearsal.md`](dress-rehearsal.md) | The **chaos night** — late arrival, reload, Pope disconnect, no-show, disputed Gora | Point at it. Do **not** run those five failures here. |

This file replaces the deleted roster-backed standing / Score Desk / Cooked-eligibility / suggestion-fanout night. That product is gone. Do not cite archive specs or research playbooks as law.

Tick a box by replacing `[ ]` with `[x]` and appending `— YYYY-MM-DD, character`. **Do not tick boxes in an authoring pass.**

---

## What this is

Bible §7: human staging is the product. Not every Gathering is the full arc. A Tuesday Knighting of one nervous newcomer in front of six members is a complete, legitimate ceremony and must cost the Pope nothing to run (§4.11).

This night is that small attempt: assembly under a Decree, Knighting if a human has earned it, a sanctioned Gora with Fight HUD and favor if a real pair exists, then records that persist and Quiet that returns.

Cast is two addon clients: the Pope’s client (writer) and one congregation client (display + input). More installed bodies are welcome. They are not required to invent a crowd. The two-client smoke sheet is leftover — this night uses two clients; it does not close that sheet.

---

## What this is not

- Not the streamed §22.3 Gathering (Twitch viewer, several Knightings, several Goras with HUD **and favor**). Walk that on [`v1-checklist.md`](v1-checklist.md) when a human can.
- Not the dress rehearsal. The five deliberate failures live only in [`dress-rehearsal.md`](dress-rehearsal.md).
- Not a claim that V1 / MVP is complete.
- Not `POLISH:PASS`.
- Not a Score Desk night. There is no standing Δ, no threshold, no instance drip, no Cooked eligibility points, no suggestion fanout.
- Not a license to invent SUMMON, designated-Council UX, an online-bit Presence, inbound congregation Proclaim/Sound, or fake Store Gora rows so the HUD can show.
- Not Appendix A. A01–A04 Results are **NOT RUN** (owner David). Do not fill them from this night.

---

## Honesty (today)

Quiet Tuesday plus the hosted player card, Records Book, Decree, Director Console, Fight HUD, and favor. STATE and HELLO rebroadcast are coded. Two-client smoke is leftover.

| Surface | Tonight |
|---------|---------|
| Quiet Tuesday | Unbidden chrome is minimap + the active Decree. `/beef` is the player-opened **player card** (§14.2): Church rank and its §5 relationship line, Gathering plate under rank, story rubrics only when they have rows. The **Records Book** (Chronicle + held superlatives) opens from **CHURCH RECORDS** on that card. |
| Director Console | Hosted Pope tool: `/beef console` (OPEN_QUESTIONS #11 names the slash; this night uses it; does not resolve #11). Not unbidden Quiet chrome. Congregation `/beef` stays the player card. |
| Rituals | Accept on listed Pope characters. Shipped name: **Thedave** (`Data/Popes.lua` or `ChurchOfBeefDB.ui.popeOverrides`). Do not stub `IsRegisteredPope` true. Agents never edit `WTF/`. |
| Fight HUD | Hosted. Event Mode only. Needs Runtime ≠ QUIET **and** a live sanctioned pair. No fake characters. No fake Store Gora rows. No `InspectProgress` as a pass path. |
| Favor | Coded: HUD plates, whisper-to-Pope, Pope tallies. Split reaches congregation via STATE when the Pope’s per-event display toggle is on. No scores, streaks, or economy. |
| STATE / HELLO | STATE is sent on every Runtime transition, and after `RecordFavor` or the congregation-favor toggle. A guildmate HELLO during a live event re-broadcasts STATE from the Pope client. Two-client smoke is leftover — do not treat this night as that walk. |
| Inbound Proclaim / Sound | Pope-local theater after successful verbs. Congregation inbound Proclaim / Sound waits on OPEN_QUESTIONS #27. Do not invent a beat field or infer kind. |
| Presence | Rank census (Church titles, live guild titles, Unrecorded) — not a name dump and not an online-bit. OPEN_QUESTIONS #13 is unanswered. Do not invent “here.” |
| SUMMON THE FAITHFUL | Uncoded. Stretch-MVP (§22.1). People walk. |
| `#8` designated-Council remainder | Pope list is coded (Thedave). Designated-Council UX stays open. Do not invent Council designation UX. |
| `#26` Petition-as-recognition | Unanswered. Do not mint zip-fresh names on either client. |
| Live HUD health | Appendix A A01 **NOT RUN**. No-health cards are the Bible fallback (§10.7), not an A01 pass. |
| A02–A04 | Results **NOT RUN** (owner David). This night does not close them. |

`ChurchOfBeef:InspectProgress()` is owner inspection only. It does **not** write Store Gora rows. It is not this night.

---

## Facilitators

| Role | Who | Client |
|------|-----|--------|
| **Pope** | David, on the Pope character (**Thedave**) | Writer. Opens `/beef console`. Does not open Blizzard’s guild roster during the night if he can help it (§8). |
| **Congregation** | One installed member, present from login | Display + input. `/beef` opens the player card. **CHURCH RECORDS** opens the Records Book. Does not run the Console. |

No Score Desk. No Night Lead desk. No Spectacle Watcher.

Optional humans (not software roles): one candidate if Knighting is earned; two fighters if a real Gora pair exists. They do not have to run the addon for the world ritual to happen (§13.6). Installed clients get the richer surface.

---

## Preconditions

Leave every box `[ ]`. A human ticks later, with date + character.

Solo smoke is the load / Quiet walk if a human has done it on this checkout. Two-client smoke is leftover (NOT RUN). Neither sheet is this night’s law. Do not walk standing, Score Desk, or suggestion fanout here.

- [ ] [`solo-smoke.md`](solo-smoke.md) walked on this checkout (install / Quiet / `/beef` player card — not the deleted ladder)
- [ ] [`two-client-smoke.md`](two-client-smoke.md) walked on this checkout (Pope writer + congregation display — leftover; do not treat an unchecked box as a star pass)
- [ ] `lua tests/run.lua` exits 0 on this checkout (agent or human). That is not a Gathering pass
- [ ] Same guild, two Anniversary clients, both running Church of Beef (`## Interface: 20506`)
- [ ] Addon reinstalled from `addon/ChurchOfBeef/` — skill §2. Player `WTF/` untouched
- [ ] `/console scriptErrors 1` on both clients (BugGrabber + BugSack preferred)
- [ ] `/reload` on both — no script errors
- [ ] Pope character is listed (`Data/Popes.lua` ships **Thedave**, or `ChurchOfBeefDB.ui.popeOverrides`). If not listed, Console rituals refuse. Stop. Do not stub the predicate. Do not `/run` Core verbs to fake a pass
- [ ] A single Decree is already posted (§14.1). Console **Post the Decree** if the desk needs a new one. Do not `/run ChurchOfBeef.Decree:Set`. Do not `InspectProgress`
- [ ] Venue chosen by humans (inn / fountain / arena). Software does not pick it. **No SUMMON button.** People walk
- [ ] Guild-only is fine. This is not the streamed §22.3 night

---

## Night goals

Match the Bible. Tick only what a human observed. Leftover stays leftover.

1. **Assembly under a Decree** (§7, §14.1, §20.1 ASSEMBLY). Members gather. The Pope starts the event from the hosted Console — zero configuration (§4.11, §20.2). Software does not auto-announce, auto-advance, or narrate (Law 4).
2. **Knighting if earned** (§8). A newcomer who attended, approached, and knelt. **KNIGHT THIS BEEF** is a Pope click, not a points threshold. If nobody has earned it, skip. That is honest, not a fail.
3. **Sanctioned Gora with HUD and favor if a real pair exists** (§10). Two humans, unmodified WoW duel, Pope **SANCTION BEEF GORA**, then a Pope ruling. Fight HUD and favor plates only after that sanction while the event is live. If there is no real pair, skip. Do not invent Store rows so the HUD can show.
4. **Records persist** (§10.9, §12, Law 7). Real writes stay in the account store and are visible from the Records Book afterward (Chronicle + held superlatives). Empty Chronicle after a night with no writes is honest.
5. **Quiet before and after** (Law 6, §19.1). Unbidden chrome is minimap + Decree only. Event chrome dies when the Pope ends the event.

### Cannot walk yet

Do not invent a path so these look done.

| Leftover | Why tonight cannot close it |
|----------|-----------------------------|
| Inbound Proclaim / Sound | Congregation inbound waits on OPEN_QUESTIONS #27. Do not invent a beat or infer kind. Pope-local theater after a verb is not that close. |
| Two-client smoke | Coded star still needs the leftover [`two-client-smoke.md`](two-client-smoke.md) walk. This night uses two clients; it does not tick that sheet. |
| Presence “here” | Desk is a rank census, not an online-bit. OPEN_QUESTIONS #13 is unanswered. Do not invent “here.” |
| Petition-as-recognition | OPEN_QUESTIONS #26 is unanswered. Do not mint zip-fresh names. |
| Live HUD health | A01 Results **NOT RUN**. No-health fallback is legal (§10.7). Do not scrape nameplates. |
| SUMMON THE FAITHFUL | Uncoded. Stretch-MVP. People walk. |
| A01–A04 Results | Owner David. **NOT RUN.** This night is not those sheets. |
| Designated-Council UX | `#8` remainder. Pope list is coded (Thedave). Do not invent Council designation UX. |
| Streamed §22.3 pass | Several Knightings, several Goras with HUD **and favor**, Twitch viewer, next-morning book. Walk [`v1-checklist.md`](v1-checklist.md) later. |
| Five chaos failures | Walk [`dress-rehearsal.md`](dress-rehearsal.md) on a different night. |

---

## Do not invent (read before anyone types `/run`)

These make a leftover look like a pass. They are forbidden on this night:

1. **Fake Store Gora rows.** Do not write characters or results so the HUD or Records Book can fill. No `InspectProgress` as a Gathering path.
2. **Stub `#8`.** Do not force `IsRegisteredPope` true. Do not treat a character named “Pope” as listed. List the character (Thedave ships), or stop.
3. **`/run Decree:Set`.** Do not manufacture a banner so the Decree beat can be ticked. Console **Post the Decree** is the coded path.
4. **A second favor path.** Favor is coded (HUD plates, whisper-to-Pope). Do not invent a raid-marker “vote,” a second opcode, scores, streaks, or an economy.
5. **SUMMON.** Do not invent a ping, a gathering-point addon message, or a second assembly feature.
6. **Auto-declare.** Do not type a win into chat as the Church record. The Gora is the duel plus a Pope ruling.
7. **The five dress-rehearsal failures.** Late arrival, reload-as-chaos, Pope disconnect, no-show, disputed Gora belong on [`dress-rehearsal.md`](dress-rehearsal.md).
8. **Score Desk metrics.** No standing Δ, no Cooked threshold, no instance-drip mix, no suggestion latency.
9. **`#13` / `#26` / `#27`.** Do not invent an online-bit Presence, a Store write for zip-fresh petitioners, or a congregation clerical beat so inbound Proclaim / Sound can fire.

A leftover beat stays leftover. Note it. Move on.

---

## Walk — Quiet before

**Pope client and Congregation, both online, still in QUIET.**

1. **Load**
   - [ ] Both clients: addon listed as Church of Beef, Interface `20506`
   - [ ] No script error on login
   - [ ] Minimap button present (or `/beef minimap` brings it back)

2. **Quiet Tuesday (Law 6, §14.2)**
   - [ ] Unbidden chrome is the minimap + the active Decree only
   - [ ] No feed, dashboard, bar, toast, pip, or sound on a cold login
   - [ ] Congregation `/beef` opens the **player card** (Gathering plate under rank), not the Records Book, a Standing tab, Officer desk, or Console
   - [ ] **CHURCH RECORDS** on that card opens the Records Book (Chronicle + held superlatives)
   - [ ] Pope `/beef console` opens the Director Console. It is not unbidden. Closing it returns the client to Quiet chrome

3. **Decree (§14.1)**
   - [ ] Login parchment header is **A GATHERING HAS BEEN DECREED** (once per login)
   - [ ] Dismiss; minimap right-click replays
   - [ ] No calendar, RSVP, reminder, recurrence, or attendance
   - [ ] Congregation seeing a **local** SV Decree is not canonical theater. Canonical theater is Pope-originated broadcast only (§13.4)

---

## Walk — Assembly under a Decree

Human staging is the product (Bible §7). Software’s named contributions are the Decree, one SUMMON, the runtime, and the Console. SUMMON is leftover. Walk the humans anyway.

| Beat | Human action | Bible expect | Tonight |
|------|--------------|--------------|---------|
| Decree beforehand | Already posted | Login parchment; minimap replay | Precondition. Console **Post the Decree** if needed. Do not `/run Set` |
| SUMMON THE FAITHFUL | One button pings the gathering point | Stretch-MVP | **Leftover.** People walk |
| Assembly | Members gather. Controlled chaos, then sudden order, is David’s | Runtime ASSEMBLY. Congregation theater from Pope STATE | Pope **Start Event** from `/beef console` if listed (Thedave). STATE is sent on the transition. If rituals refuse, stop |
| Zero-setup start | Pope one-clicks start. No event wizard | `StartEvent` — Tuesday floor (§4.11, §20.2) | Hosted Console. Refuse if not listed |

- [ ] Humans assembled without a SUMMON button
- [ ] Pope started the event from the Console **or** rituals refused and the leftover was named
- [ ] Pope did not open Blizzard’s guild roster (note yes / no in Capture)
- [ ] Software did **not** auto-announce, auto-advance, or narrate
- [ ] Congregation did not invent theater from a peer

---

## Walk — Knighting (if earned)

Bible §8: newcomers line up; Pope calls one forward; kneel; Pope judges; **KNIGHT THIS BEEF**. Earned means attended, approached, knelt — not a standing number.

If nobody has earned Knighting tonight, skip this section. Do not knight a volunteer so a box can turn green.

| Beat | Human action | Bible expect | Tonight |
|------|--------------|--------------|---------|
| Presence | Pope glances who is here and who needs Knighting | Console Presence desk | Hosted Console. Presence is a rank census, not an online-bit (#13 unanswered). Roster sense is display, not authority |
| Call forward | Pope’s voice. Candidate walks and kneels | Targeting / raid marker where API permits | Leftover assist is fine. Humans point. A04 **NOT RUN** |
| KNIGHT THIS BEEF | One Pope click | Church record + guild promote where permitted + proclamation | Church store is truth. Guild-rank write is leftover (A04). Do not require a Blizzard promote as a pass. Congregation inbound Proclaim / Sound waits on #27 |
| Bell | Installed clients hear Knighting | §19.4 | Pope-local cue after the verb is coded. Congregation inbound Sound waits on #27. Do not invent a cue |

- [ ] Skipped — nobody earned Knighting (honest)
- [ ] **Or** at least one human Knighting was performed in the world
- [ ] **KNIGHT THIS BEEF** was a Pope Console click (if listed) — not a `/run`
- [ ] Software did not auto-advance a queue
- [ ] Software did not announce in the Pope’s voice

---

## Walk — Sanctioned Gora (if a real pair exists)

Loop (Bible §10.1): **Petition → assisted matchmaking → SANCTION BEEF GORA → mute cards → favor → unmodified duel → Pope ratifies → records → possible elevation.**

Favor is coded. HUD needs a real sanctioned pair. No pair → skip. Do not seed the store.

| Beat | Human action | Bible expect | Tonight |
|------|--------------|--------------|---------|
| Petition | Member steps forward (may name an opponent) | Input to Pope console only | Petition INPUT is whisper-to-Pope. Do not mint zip-fresh names (#26 unanswered). Humans may still speak |
| Matchmaking | Pope picks a pair | Recommend only. No ELO | Pope decides. No pairing score |
| SANCTION BEEF GORA | One Pope click. Optional one-line stipulation spoken | Cards + sanction bell | Hosted Console if listed. Pope-local bell after the verb is coded. Congregation inbound Sound waits on #27 |
| Favor | Spectators pick a side | Split bar. Pope toggle. No score | **Coded.** HUD plates, whisper-to-Pope, Pope tallies. Congregation split follows the Pope toggle |
| Duel | Unmodified WoW duel in the circle | Combat is WoW’s | Addon does not fight |
| Adjudication | Pope names the ruling | DECLARE VICTOR / COWARDICE RECORDED / VOID / free ruling | Pope ratifies. No auto-declare. A02 **NOT RUN** — do not invent a chat parser. Congregation inbound Proclaim waits on #27 |
| HUD | Congregation + stream legibility | Event Mode card; no-health fallback is legal | Hosted. Only if Runtime ≠ QUIET **and** the pair was sanctioned. Congregation paints from Pope STATE. A01 **NOT RUN** |
| Elevation | Separate beat if the Pope judges a Knight’s win fair | `ElevateToLord` | Only if earned. Never auto |

- [ ] Skipped — no real pair (honest)
- [ ] **Or** one unmodified duel was fought in the world after **SANCTION BEEF GORA**
- [ ] Pope spoke the ruling. Software did not auto-declare
- [ ] Fight HUD appeared only for that sanctioned pair — **or** leftover named (no pair / not listed / Runtime still QUIET)
- [ ] Favor plates appeared for that pair **or** leftover named (no pair / Pope toggle off / Runtime still QUIET). Do not invent a second pick-a-side UI
- [ ] No Store Gora rows were invented so the HUD could show

---

## Walk — Close / Quiet after

| Beat | Bible expect | Tonight |
|------|--------------|---------|
| End event | Pope one-clicks End. Event Mode chrome dies. Quiet returns | Hosted **End Event** if the event was started. STATE is sent on the transition |
| Records persist | Account SV store. History is never deleted | Shipped Core **if** a real write happened |
| Records Book | Player-opened parchment: Chronicle first, superlatives only when held — not a ladder | `/beef` then **CHURCH RECORDS** on either client. Empty Chronicle is honest when nothing was written |
| Spreadsheet / roster | David never opened either during the night | Human test. Capture yes / no |

- [ ] Pope ended the night from the Console **or** in voice if rituals refused
- [ ] Event chrome did not linger into Quiet (HUD gone; no toast / pip / sound)
- [ ] Player card opened from `/beef` afterward; Records Book from **CHURCH RECORDS** — empty Chronicle **or** showing only real writes
- [ ] A `/reload` on the Pope client after the night still shows those real writes (do not delete `WTF/` to “prove” persist)
- [ ] Software did not auto-end

---

## Capture (human-observable)

No standing Δ. No threshold. No Score Desk. No instance drip. No Cooked eligibility points.

| Observation | How | Note |
|-------------|-----|------|
| David opened Blizzard’s guild roster during the night? | Ask David | yes / no. §8 acceptance test |
| David touched an external spreadsheet during the night? | Ask David | yes / no. §22.3 |
| Quiet stayed quiet before assembly? | Both clients, cold login | Minimap + Decree only. No toast / pip / sound |
| Quiet returned after End Event? | Both clients | HUD gone. No leftover Event chrome |
| Decree posted and replayable? | Login parchment + minimap | Header **A GATHERING HAS BEEN DECREED**. Console Post is coded. No calendar |
| Pope listed? | Console ritual click | Thedave ships. Listed → verb may fire. Unlisted → refuse. Do not stub |
| Knighting earned and performed? | World kneel + Console click | Skip if not earned. Not a points gate |
| Real Gora pair existed? | Two humans, unmodified duel | Skip if not. Do not seed the store |
| Fight HUD shown? | Both clients after Sanction | Hosted. Congregation paints from Pope STATE (sent on transitions). Two-client smoke leftover — do not treat this night as that walk. No-health is legal. A01 **NOT RUN** |
| Favor UI shown? | Watch both clients | Coded on HUD plates when a sanctioned pair exists. Congregation split follows the Pope toggle. No scores |
| Inbound Proclaim / Sound on congregation? | Watch congregation client | Waits on OPEN_QUESTIONS #27. Pope-local theater is not that close. Do not invent a beat |
| SUMMON used? | Watch both clients | Must be **no** (leftover) |
| Congregation invented theater from a peer? | Watch congregation client | Must be **no** (Law 5) |
| Software auto-declared / auto-advanced / narrated? | Watch both clients | Must be **no** (Law 4) |
| Records persist? | `/beef` → **CHURCH RECORDS** after `/reload` | Chronicle + held superlatives. Only real writes. Empty Chronicle is honest |
| Script errors? | BugSack / `scriptErrors` | Name the stack. Do not delete `WTF/` |
| Fake Store Gora rows written? | Ask / inspect Records | Must be **no** |

---

## Do not expand research unless

A night finds a **contradiction** with the Bible (not with an archived spec, not with a research playbook).

Then the **orchestrator** appends a named, bounded item to `docs/design/OPEN_QUESTIONS.md`. This lane does not edit that file. Do not fork policy into research notes.

---

## After the night (when a human actually walks it)

- File bugs for script errors, self-promotion, auto-declare, Quiet leaks, or invented theater from a peer.
- Do not resolve leftover product by inventing SUMMON, Council designation, an online-bit Presence, zip-fresh Store writes, a congregation clerical beat, or fake Store rows.
- Do not claim V1 / MVP complete. The streamed Gathering in Bible §22.3 is still the definition of done — walk [`v1-checklist.md`](v1-checklist.md).
- Do not tick this file’s Status to done from a green harness.
- Chaos (late arrival, reload, Pope disconnect, no-show, disputed Gora) is a **different night**: [`dress-rehearsal.md`](dress-rehearsal.md).

**This night:** NOT RUN.
