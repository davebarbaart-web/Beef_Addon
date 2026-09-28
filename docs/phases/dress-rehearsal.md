# Dress rehearsal — guild-only, unstreamed

**Status:** NOT RUN. Do not tick this file as done. Do not date a pass.

**Law:** Bible §22.3 (release gate), §20.4 (chaos test), §20.1–20.3 (runtime), §7 (Gathering), §10 (Gora), §18 (Console).  
**Quality bar:** `.cursor/rules/ceremony-runtime.mdc` (Chaos test).  
**Install / reload:** `.cursor/skills/church-of-beef-dev/SKILL.md`  
**Companion:** [`v1-checklist.md`](v1-checklist.md) is the §22.3 walk. This file is the chaos night only.

A green harness (`lua tests/run.lua`) and the offline chaos suite (`tests/test_ceremony_chaos.lua`) are preconditions, not this rehearsal. [`solo-smoke.md`](solo-smoke.md), [`two-client-smoke.md`](two-client-smoke.md), and [`guild-night-playtest.md`](guild-night-playtest.md) are load / star / small-Gathering prep. Do not walk them as this chaos night. Do not treat [`two-client-smoke.md`](two-client-smoke.md) as already passed — that walk is a named leftover.

---

## What this is

The Bible’s **release gate** before public release: one deliberately imperfect Gathering, guild-only, unstreamed, on an early ugly build. Live-event failure modes only appear under real crowds.

The night must include, **on purpose**:

1. A late arrival
2. A UI reload
3. A disconnect, including the Pope’s
4. A no-show petitioner
5. An interrupted or disputed Gora

A confused client is acceptable for **five seconds** and embarrassing for **thirty**. That is a human quality bar, not a timeout to code, and not a hold-timer in SavedVariables.

**Cast is two addon clients minimum:** the Pope’s client (writer) and one congregation client (display + input). More installed bodies are better. The streamed §22.3 Gathering (Twitch viewer, several Knightings, several Goras with HUD and favor) is a later product pass — not this file.

---

## What this is not

- Not a claim that V1 / MVP is complete.
- Not `POLISH:PASS`.
- Not a paper-prototype console night (Bible §22.3 pre-code validation is a different gate). A scribe may still take notes of what David wishes the console showed. That does not pass this rehearsal.
- Not a license to invent SUMMON, live HUD health, cold-tools UI, a confession inbox, congregation `EnsureCharacterByName`, or inbound congregation parchment so the boxes can turn green.
- Not a walk that resolves OPEN_QUESTIONS **#26** or **#27**.
- Not a substitute tick of [`two-client-smoke.md`](two-client-smoke.md).

---

## Honest map — coded now vs leftover

The kit is a **hosted Pope desk plus Quiet card**, not an empty Quiet shell. Mark every beat against this table. Do not invent a path so a leftover beat can be ticked.

| Surface | Coded today | Leftover (do not invent tonight) |
|---------|-------------|-------------------------------|
| Quiet Tuesday | Hideable minimap. `/beef` is the **player card** (`UI/PlayerCard.lua`): Church rank and its §5 relationship line, Gathering plate, story rubrics only when they have rows. **CHURCH RECORDS** opens the Records Book. Unbidden chrome is minimap + the active Decree. | Welcome parchment is not this script. No feed, dashboard, bar, toast, pip, or ambient sound. |
| Decree | Banner on Post and once per login. Minimap **right-click** replay. Console **Post the Decree**. DECREE broadcast from a listed Pope. | Deputy UX (#5). Calendar / RSVP / reminders. |
| Director Console | `/beef console` is the target-driven desk for a **listed Pope**. `Data/Popes.lua` ships **Thedave**; `ChurchOfBeefDB.ui.popeOverrides` may add names. Presence is a rank census, not a name dump. Rituals refuse unless the local character is listed. | Designated-Council UX (#8 still open). Notebook / Archive / Canonize / Recognition / Honorific buttons (cold-tools UI). |
| Ceremony runtime | Core machine QUIET → ASSEMBLY → RITE → CONSEQUENCE. Hosted start / end from the Console. Event object persists in `ChurchOfBeefDB.event`. STATE on every transition. `awaitingPope` is a flag, not a sixth state. | Net caller for `MarkPopeLost`. Awaiting-the-Pope degrade paint. |
| BeefNet | HELLO presence / version on GUILD. STATE on transitions. HELLO-triggered STATE re-broadcast for late joiners. SNAPSHOT send / Accept on listed-Pope senders. INPUT: petition and favor as whisper-to-Pope. | Inbound congregation `Toasts:Proclaim` / parchment (#27). Clerical beat on STATE (#27). |
| Knighting | Hosted **KNIGHT THIS BEEF** on the Console (target the Beef, one click). Core writes Church rank. Pope-local Sound wrap may fire. | Guild promote where the API permits. Congregation parchment / bell (#27). Queue / raid-marker assist. |
| Gora | Hosted sanction and four Pope rulings on the Console. Petition INPUT and favor INPUT (whisper-to-Pope). No auto-declare. Combat is WoW’s. | Zip-fresh petition may refuse `unknown character` (#26). Congregation must not `EnsureCharacterByName`. Mute-card replica on the wire. Congregation parchment (#27). |
| Fight HUD | Hosted. Shows only for a **real sanctioned pair** in Event Mode. No live health. Favor plates are coded. | Live health (Appendix A #1 / OPEN_QUESTIONS #2). A01 is **NOT RUN**. |
| Sound | Event-only cue names. **Pope-local wraps** after successful ritual verbs. Quiet is silent. | Inbound congregation Sound / Proclaim (#27). Custom assets. SUMMON chime. |
| Records | Store persist. Records Book hosted behind **CHURCH RECORDS** (superlatives, not a ladder). | Cold-tools Archive button. Famous Upset flag verb. |
| SUMMON THE FAITHFUL | Nothing. Stretch-MVP (§22.1). | A ping protocol, gathering-point widget, or extra assembly feature. |
| `#8` Pope list | `Data/Popes.lua` + `popeOverrides`. STATE / SNAPSHOT / rituals accept on listed characters only. | Designated-Council store field, broadcast, and override UX. Do not stub the predicate. |
| `#26` / `#27` | Refuse paths only. No congregation Store mint. No inferred Proclaim kind. | Petition-as-recognition on the Pope desk. Clerical beat so second clients get parchment. |

**Tonight’s honest outcome:** humans can stage the Gathering from the hosted Console on Thedave (Decree Post, start, Knighting, sanction, rulings, HUD for a real pair, favor plates, Pope-local cues). Congregation clients may receive STATE after HELLO. They must **not** be expected to show inbound parchment. Two-client smoke has not been signed. That is leftover, not a pass.

---

## Cast

| Role | Who | Client |
|------|-----|--------|
| **Pope** | David, on the listed Pope character (shipped: **Thedave**) | Writer client. Opens `/beef console`. Does not open Blizzard’s guild roster during the night (§8 acceptance test). |
| **Congregation A** | Installed member, present from login | Display + input. `/beef` is the player card. Does not `EnsureCharacterByName`. |
| **Late arriver** | Installed member | Logs in (or `/reload`s in) **during** a rite — Failure 1. |
| **No-show** | Named petitioner | Stays in the city, AFK, or logged off — Failure 4. Does not have to run the addon. |
| **Fighters** | Two members | Unmodified WoW duel for the Gora beats. |
| **Scribe** (optional) | Anyone with a clock | Times confused-client windows against the five / thirty bar. Does not run software. |

More installed bodies are better. One Pope client + one congregation client is the floor.

---

## Preconditions

Leave every box `[ ]`. A human ticks later, with date + character, when the night is actually walked. **Do not tick them in this authoring pass.** Agents do not tick this file.

- [ ] Same guild, two Anniversary clients, both running Church of Beef (`## Interface: 20506`)
- [ ] Addon reinstalled from `addon/ChurchOfBeef/` — skill §2. Player `WTF/` untouched
- [ ] `/console scriptErrors 1` on both clients (BugGrabber + BugSack preferred)
- [ ] `/reload` on both — no script errors
- [ ] `lua tests/run.lua` was green on this checkout (agent or human). That is not a rehearsal pass
- [ ] Guild-only. Not streamed. Early ugly build is expected
- [ ] Pope character is listed (`Data/Popes.lua` or `ChurchOfBeefDB.ui.popeOverrides`). Shipped name: **Thedave**. If rituals refuse, stop. Do not stub `IsRegisteredPope`. Agents do not edit `WTF/`
- [ ] Roles assigned: Pope, Congregation A, Late arriver, No-show, two Fighters
- [ ] Venue chosen by humans (inn / fountain / arena). Software does not pick it. **No SUMMON button.** People walk
- [ ] Scribe knows the quality bar: confused ≤ 5 s is acceptable; ≥ 30 s is embarrassing

---

## Do not invent (read before anyone types `/run`)

These make a leftover look like a pass. They are forbidden on this night:

1. **Congregation Store mint (#26).** Do not `EnsureCharacterByName` / `CreateHuman` / `LinkCharacter` on the pew. Do not silent-link alts. Zip-fresh petition may refuse `unknown character` — name it and continue. Recognition is target + Knight / Sanction.
2. **Inbound parchment (#27).** Do not infer Victor / Void / Free / Cowardice / Knighting from `state` + `riteType`. Do not treat missing congregation Proclaim / bell as a Sound-caller bug. Pope-local wraps may fire; second-client parchment waits on #27.
3. **SUMMON.** Do not invent a ping, a gathering-point addon message, or a second assembly feature. People walk.
4. **Live HUD health.** Do not scrape nameplates. A01 is **NOT RUN**. Cards without health are the legal fallback.
5. **Cold-tools UI.** Do not invent Archive / Canonize / Recognition / Honorific / Notebook / confession-inbox frames so a leftover can tick.
6. **Stub `#8`.** Do not force `IsRegisteredPope` true. Do not treat a character named “Pope” as listed. Do not invent designated-Council UX. List the character, or stop.
7. **Fake Post / fake Gora.** Do not `/run ChurchOfBeef.Decree:Set(...)`. Do not write Store rows so the HUD or book can fill. Do not `/run` Core verbs to manufacture a resume.
8. **Auto-declare.** Do not type a win into chat as the Church record. The Gora is the duel plus a Pope ruling.

A leftover beat stays leftover. Note it. Move on.

---

## Night 0 — Quiet / install (coded Quiet)

Walk this first. Prove Quiet chrome and the player card before anyone starts the event.

**Pope client and Congregation A, both online, still in QUIET.**

1. **Load**
   - [ ] Both clients: addon listed as Church of Beef, Interface `20506`
   - [ ] No script error on login
   - [ ] Minimap button present (or `/beef minimap` brings it back)

2. **Quiet Tuesday (Law 6)**
   - [ ] Unbidden chrome is the minimap + the active Decree only
   - [ ] `/beef` opens the **player card**, not the Director Console, not the Fight HUD, not a Standing tab
   - [ ] **CHURCH RECORDS** on that card opens the Records Book
   - [ ] No toast, pip, feed, or sound on a cold login
   - [ ] Congregation does not mint a local Church row

3. **Decree**
   - [ ] Listed Pope can **Post the Decree** from `/beef console`. Do not `/run Set`
   - [ ] Banner header is **A GATHERING HAS BEEN DECREED**; dismiss; minimap **right-click** replays
   - [ ] Congregation seeing the banner after a Pope **DECREE** broadcast is the wire. A leftover local SV line without a Post this session is not canonical theater
   - [ ] No calendar, RSVP, reminder, recurrence, or attendance

4. **Desk door (Pope only)**
   - [ ] On Thedave, `/beef console` opens the target-driven Director Console
   - [ ] Closing it returns Quiet chrome (minimap + Decree). The desk is not unbidden
   - [ ] Presence reads as a rank census, not a name dump

5. **Wire that actually moves**
   - [ ] HELLO may go out (presence / version)
   - [ ] A guildmate without the addon online does not break either client

**Night 0 note:** both clients quiet, `/beef` is the card, Console is `/beef console` on a listed Pope. **Not** the release gate.

---

## Night 1 — Assembly under a Decree

Human staging is the product (Bible §7). Software’s named contributions are the Decree, one SUMMON, the runtime, and the Console. SUMMON is leftover. Walk the humans anyway.

| Beat | Human action | Bible expect | Tonight |
|------|--------------|--------------|---------|
| Decree beforehand | Pope posts a single line from the Console | Login parchment; minimap replay; DECREE on the wire | **Coded.** Console Post + broadcast. Do not `/run Set` |
| SUMMON THE FAITHFUL | One button pings installed clients with the gathering point | Stretch-MVP | **Leftover.** People walk. Do not invent a ping |
| Assembly | Members gather at the inn / fountain. Controlled chaos, then sudden order, is David’s | Runtime ASSEMBLY. Congregation theater from Pope STATE | **Coded start.** Listed Pope one-clicks start from `/beef console`. STATE goes out. Inbound parchment waits on #27 |
| Zero-setup start | Pope one-clicks start. No event wizard | `StartEvent` — Tuesday floor (§4.11, §20.2) | Hosted Console. Refuses if not a listed Pope |

- [ ] Humans assembled without a SUMMON button
- [ ] Pope posted the Decree from the Console (not `/run`)
- [ ] Pope started the event from the Console
- [ ] Pope did not open Blizzard’s guild roster
- [ ] Software did **not** auto-announce, auto-advance, or narrate
- [ ] Leftover named: SUMMON, inbound congregation parchment (#27), designated-Council UX

---

## Night 2 — Knighting (at least one)

Bible §8: newcomers line up; Pope calls one forward; kneel; Pope judges; **KNIGHT THIS BEEF**. Latecomers insert without reordering pain.

| Beat | Human action | Bible expect | Tonight |
|------|--------------|--------------|---------|
| Presence | Pope glances who is here and who needs Knighting | Console Presence desk | **Coded.** Rank census, not a name dump. No online bit (#13) |
| Call forward | Pope’s voice. Candidate walks and kneels | Targeting / raid marker where API permits | Humans point. Appendix A item 5 is not this night |
| KNIGHT THIS BEEF | One Pope click | Church record + guild promote where permitted + proclamation + queue advance-on-command | **Coded verb** on the Console. Guild-rank write is leftover. Congregation parchment waits on #27 |
| Bell | Installed clients hear Knighting | §19.4 | **Pope-local wrap** may fire. Do not expect the pew to hear it (#27) |

Walk at least one kneel so Failure 1 (late arrival) has a rite to interrupt.

- [ ] At least one human Knighting was performed in the world
- [ ] **KNIGHT THIS BEEF** was a Pope Console click — not a `/run`
- [ ] Software did not auto-advance a queue
- [ ] Software did not announce in the Pope’s voice
- [ ] Leftover named: guild promote, inbound parchment / pew bell (#27)

---

## Night 3 — Sanctioned Gora (at least one clean, then the failures)

Loop (Bible §10.1): **Petition → assisted matchmaking → SANCTION BEEF GORA → mute cards → favor → unmodified duel → Pope ratifies → records → possible elevation.**

| Beat | Human action | Bible expect | Tonight |
|------|--------------|--------------|---------|
| Petition | Member steps forward (may name an opponent) | Input to Pope console only. Present-and-alive pool. One-tap dismiss | **Coded INPUT** (whisper-to-Pope). Humans may also speak. Zip-fresh name may refuse `unknown character` (#26). Congregation must not mint a row |
| Matchmaking | Pope picks a pair | Recommend: levels, H2H, class. No ELO | Pope decides. Target-driven sanction. No pairing score |
| SANCTION BEEF GORA | One Pope click. Optional one-line stipulation spoken | Cards + sanction bell on installed clients | **Coded verb.** HUD for that real pair. Pope-local cue may fire. Pew parchment waits on #27 |
| Favor | Spectators pick a side | Split bar. Pope toggle. No score | **Coded.** HUD plates; whisper-to-Pope; Pope tallies. Not a score |
| Duel | Unmodified WoW duel in the circle | Combat is WoW’s | **Shipped by absence.** Addon does not fight |
| Adjudication | Pope names the ruling | DECLARE VICTOR / COWARDICE RECORDED / VOID / free ruling. Software may propose; Pope ratifies | **Coded verbs** on the Console. No duel-chat auto-propose (Appendix A #2). No auto-declare |
| HUD | Congregation + stream legibility | Event Mode card; no-health fallback is legal | **Hosted** for a real sanctioned pair. No live health (A01 **NOT RUN**). Do not invent Store rows so it can show |
| Elevation | Separate beat if the Pope judges a Knight’s win fair | `ElevateToLord` + elevation cue | Hosted if earned. Pope-local cue may fire. Never auto |

Walk **one clean Gora** (two fighters, duel to a natural end, Pope speaks a victor) so the later VOID / dispute has a contrast. Then run the five failures.

- [ ] One unmodified duel was fought in the world after **SANCTION BEEF GORA**
- [ ] Pope spoke the ruling. Software did not auto-declare
- [ ] Fight HUD appeared only for that sanctioned pair — no live health
- [ ] Favor plates were available on the HUD (whisper-to-Pope). Missing pew parchment is #27, not a favor fail
- [ ] Congregation did not `EnsureCharacterByName`
- [ ] Leftover named: #26 unknown-character refuse, #27 inbound parchment, live HUD health, A02 propose

---

## The five deliberate failures

Do these **on purpose**. Time the confused-client window. Five seconds is acceptable. Thirty is embarrassing. Do not code a timer to “meet” the bar.

Each failure has a **Bible expect** (what the product must do) and a **Tonight** line (what this checkout actually does). Tick only what a human observed. Leftover expect stays leftover.

### 1. Late arrival

**When:** Mid-Knighting or mid-Gora — not in QUIET.

**Human action:** Late arriver logs in, or comes through the loading screen, with the addon already installed.

**Bible expect (§20.3):** Client whispers a snapshot request to the Pope’s client only. Pope answers. Late arriver lands in the current theater (rite type, subjects, sequence) within seconds. No GUILD fan-out. No Officer+ / Council answer.

**Tonight:** The Pope’s client re-broadcasts STATE when a guildmate HELLOs during a live event. Late arriver needs no slash. SNAPSHOT Accept is listed-Pope only. HUD may paint if a sanctioned pair is live. Do **not** expect inbound Proclaim parchment (#27). Do not mint a local Store row. Two-client smoke is leftover — this is the walk, not a prior pass.

- [ ] Late arriver joined during a live rite (human staging was mid-ceremony)
- [ ] No client other than the Pope answered a snapshot
- [ ] Late arriver did **not** invent theater from a peer
- [ ] Late arriver did **not** `EnsureCharacterByName`
- [ ] Confused-client window: _____ seconds (scribe). Acceptable / embarrassing
- [ ] Leftover named: inbound parchment (#27), two-client smoke unsigned

### 2. UI reload

**When:** Still mid-rite. Do **both** clients, one at a time.

**Human action:**

1. Congregation A: `/reload` during the rite.
2. After they are back: Pope: `/reload` during the same rite (or the next).

**Bible expect:** Congregation reload requests a snapshot and lands mid-rite. Pope reload resumes from the persisted event object in his account SV (`ChurchOfBeefDB.event`). Console is where he left it. No one else becomes writer.

**Tonight:** Event persist is shipped. Listed Pope `/reload` should still have a desk and a live event — do not `/run StartEvent` to manufacture it. Congregation returns via HELLO → STATE re-broadcast. HUD may return for the sanctioned pair. Inbound parchment still waits on #27. `awaitingPope` is not a sixth state and is not painted as one.

- [ ] Congregation `/reload` mid-rite — no script error
- [ ] Pope `/reload` mid-rite — no script error
- [ ] Pope Console still had the night (event / pair), not a cold Quiet-only desk
- [ ] Player `WTF/` was not deleted
- [ ] No client promoted itself to writer
- [ ] Confused-client window: _____ seconds
- [ ] Leftover named: inbound parchment (#27), awaiting-Pope paint

### 3. Disconnect, including the Pope’s

**When:** After reload, still treating the night as live.

**Human action:**

1. Congregation A: exit to character select (or hard close), then log back in.
2. Pope: same — **the Pope’s client disconnects** while the congregation is still in the world. Then the Pope logs back in.

**Bible expect (§20.3):** Clients hold last state briefly, then degrade to a quiet-leaning **“awaiting the Pope”** presentation. That is Event Mode degraded — not a sixth state, not Quiet chrome, not a toast or pip. **No client promotes itself.** On reconnect, the Pope console resumes from the persisted event object. Congregation does not answer snapshot requests.

**Tonight:** No client promotes itself. Hold duration is unspecified — do not invent seconds. Degrade paint / `MarkPopeLost` on the wire is not a claimed ship. After the Pope logs back in, persist should restore the event and STATE / HELLO may move again. Do not `/run StartEvent` to manufacture a resume. Quiet-looking chrome while the Pope is gone is not a sixth state.

- [ ] Congregation disconnect / reconnect — no script error; no self-promotion
- [ ] **Pope** disconnect / reconnect — no script error; no other client took over
- [ ] No sixth state named `AWAITING_POPE` appeared
- [ ] No toast / pip / sound on disconnect
- [ ] Confused-client window (Pope gone): _____ seconds
- [ ] Leftover named: no `MarkPopeLost` caller, no degrade paint

### 4. No-show petitioner

**When:** Pope is taking Gora petitions (voice / `/s` / INPUT). The named No-show does not arrive.

**Human action:** Someone petitions (speaks or sends INPUT) for the No-show, or the No-show petitioned earlier and then vanished. Pope must continue the night without them.

**Bible expect:** Petitions are event-scoped. Pool shows present-and-alive. Pope one-tap dismisses, consequence-free. No auto-open of a Gora, no auto-end of the event, no snapshot Apply of INPUT. Soft re-petition cooldown exists in law; duration is unspecified — do not invent one. Congregation crash mid-petition: input is re-sendable; console deduplicates by character.

**Tonight:** Petition INPUT is whisper-to-Pope. A zip-fresh name may refuse `unknown character` (#26) — that is leftover recognition, not a license to mint on the pew. Hosted dismiss is consequence-free if the desk has the row. The Pope continues with his voice either way. Software must not auto-advance. Congregation must not `EnsureCharacterByName` so the No-show “exists.”

- [ ] Named No-show never entered the circle
- [ ] Pope continued the night (next petitioner, or a Gora without them)
- [ ] Software did not auto-open a Gora or auto-end the event
- [ ] Software did not paint the No-show’s name as public theater
- [ ] Congregation did not mint a Store row for the No-show
- [ ] Leftover named: #26 unsigned / Ensure-on-Pope, confession inbox UI, re-petition cooldown UX

### 5. Interrupted or disputed Gora

**When:** A second duel is live, or about to be. Do **one** of these — both if the crowd can stand it.

**Interrupted:** a third player walks the circle, a disconnect mid-duel, a guard, a heckler, or the Pope calls it off before a natural end.

**Disputed:** both fighters claim the win, or the flee/result is unclear.

**Human action:** Pope speaks **VOID** (interference / weirdness — one tap, no shame) or a **free ruling**. He may re-rule later. He may encourage a rematch. Combat stays WoW’s.

**Bible expect:** Software proposes from duel system messages if Appendix A #2 ever validates; Pope ratifies. VOID is immediate. Disconnect mid-Gora: console suggests Void, rematch encouraged. No auto-declare. No ELO. HUD persists through the verdict beat, then exits with the consequence. Cowardice Recorded is a first-class ruling with its own cue.

**Tonight:** Listed Pope Console wrappers run `Void` / `FreeRuling` / `CowardiceRecorded` / `DeclareVictor`. They do **not** refuse as if `Popes.lua` were missing. HUD may stay up through the beat for that sanctioned pair (no live health). Favor plates may still show. Sound is Pope-local. Congregation parchment waits on #27. Duel-chat propose is leftover (A02). Software must not invent a winner.

- [ ] An interrupted **or** disputed Gora happened on purpose
- [ ] Pope spoke VOID or a free ruling (or Cowardice / Victor) in the world
- [ ] The ruling was a Console click on the listed Pope — or voice plus a named leftover if the desk refused for a reason other than “not a registered pope”
- [ ] Software did not auto-declare a winner
- [ ] Software did not write a typed member self-report as the Gora
- [ ] No live health bar appeared (A01 leftover — expected)
- [ ] Confused-client window: _____ seconds
- [ ] Leftover named: inbound parchment (#27), A02 propose, live HUD health

---

## Close / next morning

Bible §22.3 also asks: records persist and are visible the next morning; David never opened the guild roster and never touched a spreadsheet during the performance.

| Beat | Bible expect | Tonight |
|------|--------------|---------|
| End event | Pope one-clicks End. Event Mode chrome dies. Quiet returns | **Coded.** Hosted End from `/beef console` |
| Records persist | Account SV store + event. History is never deleted | **Coded** if a real Console write happened. Do not delete `WTF/` to “prove” it |
| Records Book next morning | Player-opened parchment superlatives | **Coded.** `/beef` → **CHURCH RECORDS**. Empty pages are honest when nothing was written |
| Sacred Archive | One-action export | **Leftover** cold-tools UI. Codec may exist; there is no Archive button |
| Spreadsheet / roster | David never opened either during the night | **Human test.** Software cannot open them for him |

- [ ] Pope ended the night from the Console. Software did not auto-end
- [ ] Event chrome did not linger into Tuesday (HUD gone; no toast / pip / sound)
- [ ] David’s note: opened Blizzard guild roster? yes / no
- [ ] David’s note: touched an external spreadsheet? yes / no
- [ ] Next morning: Records Book opened from **CHURCH RECORDS**? (human walk — do not tick from this authoring pass)
- [ ] Leftover named: Archive button, confession inbox UI, SUMMON

---

## Release-gate pass (do not tick)

This block is the Bible §22.3 rehearsal. It stays unchecked until a human walks the night. **Coded desks do not tick it.** Inbound congregation parchment waits on #27. Two-client smoke is leftover. Do not tick this block to close a phase.

- [ ] Guild-only, unstreamed, real crowd, early ugly build
- [ ] Assembly under a **posted** Decree (Console Post, not a `/run`)
- [ ] Pope started the event from the **hosted** Console — zero configuration
- [ ] At least one Knighting via **KNIGHT THIS BEEF** (hosted)
- [ ] At least one sanctioned Gora with **hosted** HUD (no-health fallback is legal; A01 **NOT RUN**)
- [ ] Congregation **favor** was available (HUD plates, whisper-to-Pope). Pew parchment is not required (#27)
- [ ] Failure 1 late arrival: HELLO re-broadcast from the Pope; no peer theater
- [ ] Failure 2 `/reload`: congregation catch-up + Pope resume from SV
- [ ] Failure 3 disconnect **including the Pope’s**: no self-promotion (degrade paint leftover)
- [ ] Failure 4 no-show petitioner: dismiss / continue; no auto-advance; no pew Ensure
- [ ] Failure 5 interrupted or disputed Gora: Pope VOID or free ruling; no auto-declare
- [ ] No client confused longer than thirty seconds on any failure
- [ ] Records visible the next morning from **CHURCH RECORDS**
- [ ] David never opened the guild roster and never touched a spreadsheet
- [ ] Writer was a listed Pope (`Data/Popes.lua` / overrides) — not a stub invented for the night
- [ ] SUMMON was not required (stretch). If used, it was one ping, nothing more

**Release gate:** NOT RUN.

---

## Leftovers (named, not fixed in this script)

1. **SUMMON THE FAITHFUL** — stretch-MVP. People walk.
2. **Confession inbox UI** — confession whisper may exist; there is no inbox frame.
3. **Live HUD health** — Appendix A #1 / OPEN_QUESTIONS #2. No-health cards are legal, not an A01 pass.
4. **Cold-tools UI** — Archive / Canonize / Recognition / Honorific / Notebook are Core-only.
5. **Two-client smoke** — [`two-client-smoke.md`](two-client-smoke.md) is NOT RUN. This night does not tick it.
6. **#26 Petition-as-recognition** — no congregation `EnsureCharacterByName`. Zip-fresh INPUT may refuse `unknown character`. Do not silent-link.
7. **#27 Clerical beat / inbound Proclaim** — Pope-local Sound wraps only. Do not claim second-client parchment.
8. **#8 designated-Council** — Pope list ships; Council designation UX does not.
9. **No guild promote** from Core on KNIGHT THIS BEEF where the API permits.
10. **No `MarkPopeLost` caller / degrade paint.** Hold duration stays unspecified.
11. **A02 duel-chat propose** — leftover. Pope ratifies; software does not auto-declare.
12. **Scoped out:** post-show clipboard, Decree deputy, Curtain UX, Forever TOC.

---

## After the night (when a human actually walks it)

- File bugs for script errors, self-promotion, auto-declare, Quiet leaks, pew Store mint, or a confused client past thirty seconds.
- Do not resolve leftover product by inventing SUMMON, congregation `EnsureCharacterByName`, inbound Proclaim, live health, or cold-tools UI in a bugfix.
- Do not answer OPEN_QUESTIONS **#26** or **#27** from this walk.
- Do not claim V1 / MVP complete. The streamed Gathering in Bible §22.3 is still the definition of done.
- Do not tick **Release gate** above unless the hosted night was real.
- Agents do not tick this file.
