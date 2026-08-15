# Dress rehearsal — guild-only, unstreamed

**Status:** NOT RUN. Do not tick this file as done. Do not date a pass.

**Law:** Bible §22.3 (release gate), §20.4 (chaos test), §20.1–20.3 (runtime), §7 (Gathering), §10 (Gora), §18 (Console).  
**Quality bar:** `.cursor/rules/ceremony-runtime.mdc` (Chaos test).  
**Install / reload:** `.cursor/skills/church-of-beef-dev/SKILL.md`  
**Companion:** [`v1-checklist.md`](v1-checklist.md) is the §22.3 walk. This file is the chaos night only.

A green harness (`lua tests/run.lua`) and the offline chaos suite (`tests/test_ceremony_chaos.lua`) are preconditions, not this rehearsal. [`solo-smoke.md`](solo-smoke.md), [`two-client-smoke.md`](two-client-smoke.md), and [`guild-night-playtest.md`](guild-night-playtest.md) are load / star / small-Gathering prep. Do not walk them as this chaos night.

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
- Not a license to invent `Data/Popes.lua`, a SUMMON protocol, a favor channel, or a hosted Director Console so the boxes can turn green.

---

## Honest map — shipped skeleton vs leftover

Gate 5 closed on an **everyday-layer skeleton**, not a live Gathering. Mark every beat against this table. Do not invent a path so a leftover beat can be ticked.

| Surface | Shipped today | Leftover (do not invent tonight) |
|---------|---------------|----------------------------------|
| Quiet Tuesday | Hideable minimap. Empty `/beef` shell. Slash is `/beef` and `/beef minimap` only. | Player-opened Records Book. Onboarding parchment. |
| Decree | Core `{ line, flavor }`. Login banner + minimap replay **if** a Decree is already in account SV. | Console **Post**. Decree on the wire. Deputy UX (#5). Calendar / RSVP. |
| Director Console | Module loads. Stock desks exist. Rituals refuse `not the registered pope`. **Never shown.** No slash. | Host. `/beef` wiring. `PLAYER_LOGIN` Init. Notebook persist. Post Decree. |
| Ceremony runtime | Core machine QUIET → ASSEMBLY → RITE → CONSEQUENCE. Zero-config `StartEvent`. Event object persists in `ChurchOfBeefDB.event`. `awaitingPope` is a flag, not a sixth state. | Hosted start button. Congregation theater. Net caller for `MarkPopeLost`. |
| BeefNet | HELLO presence / version on GUILD. STATE / SNAPSHOT codecs exist and **fail-closed**. INPUT is codec-only. | `#8` registered-Pope list. Live STATE paint. Whisper snapshot catch-up. Live INPUT / petition / favor / confession channel. |
| Knighting | Core `KnightThisBeef` / `ElevateToLord` write Church rank only. | Hosted KNIGHT THIS BEEF. Guild promote where the API permits. Queue / targeting / raid markers. Proclamation. Knighting bell. |
| Gora | Core petition / sanction / four Pope rulings write the store. No auto-declare. Combat is WoW’s. | Hosted SANCTION / verdicts. Mute fighter cards on congregation clients. Favor. Sanction bell. |
| Fight HUD | Module loads. Would show only when Runtime ≠ QUIET **and** a live sanctioned pair. No live health. `favor = nil`. **Never `Init`ed.** | Host. Favor split. Live health (Appendix A #1 / OPEN_QUESTIONS #2). |
| Sound | Event-only verb: `sanction`, `verdict`, `elevation`, `knighting`, `cowardice`. Quiet is silent. **No callers.** | Wired cues. Custom assets (Appendix A sound item). Canonization seal. SUMMON chime. |
| Records | Store persist. Records Book module (superlatives, not a ladder). **Unhosted.** | `/beef` / minimap open. Next-morning book. Famous Upset flag verb. |
| SUMMON THE FAITHFUL | Nothing. Stretch-MVP (§22.1). | A ping protocol, gathering-point widget, or extra assembly feature. |
| `#8` | `Sender:IsRegisteredPope` is always `false`. | `Data/Popes.lua`, override UX, stubbing the predicate true. |

**Tonight’s honest outcome:** the guild can stage the human Gathering (assembly, kneel, unmodified duels, Pope voice). The addon will stay a Quiet shell plus, at most, a local Decree banner. Rituals, theater, HUD, favor, bells, and catch-up will not fire. That is leftover, not a pass.

---

## Cast

| Role | Who | Client |
|------|-----|--------|
| **Pope** | David, on the Pope character | Writer client. Does not open Blizzard’s guild roster during the night (§8 acceptance test). |
| **Congregation A** | Installed member, present from login | Display + input. Stays for the whole night. |
| **Late arriver** | Installed member | Logs in (or `/reload`s in) **during** a rite — Failure 1. |
| **No-show** | Named petitioner | Stays in the city, AFK, or logged off — Failure 4. Does not have to run the addon. |
| **Fighters** | Two members | Unmodified WoW duel for the Gora beats. |
| **Scribe** (optional) | Anyone with a clock | Times confused-client windows against the five / thirty bar. Does not run software. |

More installed bodies are better. One Pope client + one congregation client is the floor.

---

## Preconditions

Leave every box `[ ]`. A human ticks later, with date + character, when the night is actually walked. **Do not tick them in this authoring pass.**

- [ ] Same guild, two Anniversary clients, both running Church of Beef (`## Interface: 20506`)
- [ ] Addon reinstalled from `addon/ChurchOfBeef/` — skill §2. Player `WTF/` untouched
- [ ] `/console scriptErrors 1` on both clients (BugGrabber + BugSack preferred)
- [ ] `/reload` on both — no script errors
- [ ] `lua tests/run.lua` was green on this checkout (agent or human). That is not a rehearsal pass
- [ ] Guild-only. Not streamed. Early ugly build is expected
- [ ] Roles assigned: Pope, Congregation A, Late arriver, No-show, two Fighters
- [ ] Venue chosen by humans (inn / fountain / arena). Software does not pick it. **No SUMMON button.** People walk
- [ ] Scribe knows the quality bar: confused ≤ 5 s is acceptable; ≥ 30 s is embarrassing

---

## Do not invent (read before anyone types `/run`)

These make a leftover look like a pass. They are forbidden on this night:

1. **`#8`.** Do not add `Data/Popes.lua`. Do not stub `IsRegisteredPope` true. Do not treat a character named “Pope” as registered.
2. **Hosted Console.** Do not `/run ChurchOfBeef.Console:Toggle()`. Do not `/run ChurchOfBeef.Runtime:StartEvent()`. `/beef` is the empty Quiet shell. That is correct.
3. **Fake Post.** Do not `/run ChurchOfBeef.Decree:Set(...)` so a banner appears and the Decree beat can be ticked.
4. **Favor.** Do not invent a pick-a-side UI, a whisper opcode, or a raid-marker “vote.” Congregation cheers in `/s`.
5. **SUMMON.** Do not invent a ping, a gathering-point addon message, or a second assembly feature. People walk.
6. **Auto-declare.** Do not type a win into chat as the Church record. The Gora is the duel plus a Pope ruling. Core rulings exist; the hosted verbs do not.

A leftover beat stays leftover. Note it. Move on.

---

## Night 0 — Quiet / install (shipped skeleton)

Walk this first. It is the only stretch the current load list can actually prove.

**Pope client and Congregation A, both online.**

1. **Load**
   - [ ] Both clients: addon listed as Church of Beef, Interface `20506`
   - [ ] No script error on login
   - [ ] Minimap button present (or `/beef minimap` brings it back)

2. **Quiet Tuesday (Law 6)**
   - [ ] Unbidden chrome is the minimap only — unless a Decree is already in that account’s SV, in which case the parchment may show once
   - [ ] `/beef` opens the empty Quiet shell, not a Console, HUD, Records Book, Standing tab, or Officer desk
   - [ ] No toast, pip, feed, or sound on a cold login
   - [ ] Status chip (if the shell is open) does not claim “syncing” or “synced”

3. **Decree — honest leftover**
   - [ ] There is **no** Console Post. If no Decree is already persisted, no parchment appears. That is leftover, not a failed banner
   - [ ] If a Decree *is* already in SV: banner header is **A GATHERING HAS BEEN DECREED**; dismiss; minimap left-click replays; `/beef` stays the empty shell
   - [ ] Congregation seeing a **local** SV Decree is not canonical theater. Do not treat it as Pope-originated broadcast

4. **Wire that actually moves**
   - [ ] HELLO may go out (presence / version). No STATE theater. No snapshot catch-up
   - [ ] A guildmate without the addon online does not break either client

**Night 0 pass (skeleton only):** both clients quiet, `/beef` empty, no invented host. **Not** the release gate.

---

## Night 1 — Assembly under a Decree

Human staging is the product (Bible §7). Software’s named contributions are the Decree, one SUMMON, the runtime, and the Console. Two of those are leftover. Walk the humans anyway.

| Beat | Human action | Bible expect | Tonight |
|------|--------------|--------------|---------|
| Decree beforehand | Pope has already posted a single line | Login parchment; minimap replay | **Leftover Post.** Banner only if SV already holds a line. Do not `/run Set` |
| SUMMON THE FAITHFUL | One button pings installed clients with the gathering point | Stretch-MVP | **Leftover.** People walk. Do not invent a ping |
| Assembly |  Members gather at the inn / fountain. Controlled chaos, then sudden order, is David’s | Runtime ASSEMBLY. Congregation theater from Pope STATE | **Leftover host + leftover `#8`.** Runtime Core exists; nothing starts it from UI; STATE will not send |
| Zero-setup start | Pope one-clicks start. No event wizard | `StartEvent` — Tuesday floor (§4.11, §20.2) | **Leftover host.** Console `StartEvent` exists and refuses `not the registered pope` |

- [ ] Humans assembled without a SUMMON button
- [ ] Pope did not open Blizzard’s guild roster
- [ ] Software did **not** auto-announce, auto-advance, or narrate
- [ ] Leftover named: no Post, no SUMMON, no hosted start, `#8` fail-closed

---

## Night 2 — Knighting (at least one)

Bible §8: newcomers line up; Pope calls one forward; kneel; Pope judges; **KNIGHT THIS BEEF**. Latecomers insert without reordering pain.

| Beat | Human action | Bible expect | Tonight |
|------|--------------|--------------|---------|
| Presence | Pope glances who is here and who needs Knighting | Console Presence desk | **Leftover host.** Module can list; it is not shown |
| Call forward | Pope’s voice. Candidate walks and kneels | Targeting / raid marker where API permits | **Leftover.** Humans point. Appendix A item 5 is not this night |
| KNIGHT THIS BEEF | One Pope click | Church record + guild promote where permitted + proclamation + queue advance-on-command | **Leftover host + leftover `#8` + leftover guild promote.** Core writes rank 3 only if a later host calls it |
| Bell | Installed clients hear Knighting | §19.4 | **Leftover callers.** `Sound:Play("knighting")` exists; nothing rings it |

Walk at least one kneel so Failure 1 (late arrival) has a rite to interrupt.

- [ ] At least one human Knighting was performed in the world
- [ ] Software did not auto-advance a queue
- [ ] Software did not announce in the Pope’s voice
- [ ] Leftover named: unhosted Console, `#8`, no guild promote, unwired Sound

---

## Night 3 — Sanctioned Gora (at least one clean, then the failures)

Loop (Bible §10.1): **Petition → assisted matchmaking → SANCTION BEEF GORA → mute cards → favor → unmodified duel → Pope ratifies → records → possible elevation.**

| Beat | Human action | Bible expect | Tonight |
|------|--------------|--------------|---------|
| Petition | Member steps forward (may name an opponent) | Input to Pope console only. Present-and-alive pool. One-tap dismiss | **Leftover INPUT channel.** Humans speak. Core `Petition` exists; nothing hosts it |
| Matchmaking | Pope picks a pair | Recommend: levels, H2H, class. No ELO | **Leftover host.** Core `Recommend` exists |
| SANCTION BEEF GORA | One Pope click. Optional one-line stipulation spoken | Cards + sanction bell on installed clients | **Leftover host + leftover `#8` + leftover Sound.** Core `Sanction` exists |
| Favor | Spectators pick a side | Split bar. Pope toggle. No score | **Leftover.** Do not invent a vote |
| Duel | Unmodified WoW duel in the circle | Combat is WoW’s | **Shipped by absence.** Addon does not fight |
| Adjudication | Pope names the ruling | DECLARE VICTOR / COWARDICE RECORDED / VOID / free ruling. Software may propose; Pope ratifies | **Leftover host.** Core verbs write the store. No duel-chat auto-propose (Appendix A #2). No auto-declare |
| HUD | Congregation + stream legibility | Event Mode card; no-health fallback is legal | **Leftover host.** Module never `Init`ed |
| Elevation | Separate beat if the Pope judges a Knight’s win fair | `ElevateToLord` + elevation cue | **Leftover host + leftover Sound.** Core writes rank 4 only if called |

Walk **one clean Gora** (two fighters, duel to a natural end, Pope speaks a victor) so the later VOID / dispute has a contrast. Then run the five failures.

- [ ] One unmodified duel was fought in the world
- [ ] Pope spoke the ruling. Software did not auto-declare
- [ ] No favor UI appeared (leftover — do not invent one)
- [ ] No Fight HUD appeared (leftover host)
- [ ] No sanction / verdict bell (leftover callers)

---

## The five deliberate failures

Do these **on purpose**. Time the confused-client window. Five seconds is acceptable. Thirty is embarrassing. Do not code a timer to “meet” the bar.

Each failure has a **Bible expect** (what the product must do when leftovers land) and a **Tonight** line (what the skeleton actually does). Tick only what a human observed. Leftover expect stays leftover.

### 1. Late arrival

**When:** Mid-Knighting or mid-Gora — not in QUIET.

**Human action:** Late arriver logs in, or comes through the loading screen, with the addon already installed.

**Bible expect (§20.3):** Client whispers a snapshot request to the Pope’s client only. Pope answers. Late arriver lands in the current theater (rite type, subjects, sequence) within seconds. No GUILD fan-out. No Officer+ / Council answer.

**Tonight:** SNAPSHOT send and Accept are fail-closed (`#8`). Nobody answers. Late arriver sees Quiet: minimap, empty `/beef`, maybe a local Decree. That is leftover, not a catch-up pass.

- [ ] Late arriver joined during a live rite (human staging was mid-ceremony)
- [ ] No client other than the Pope answered a snapshot (none will — leftover `#8`)
- [ ] Late arriver did **not** invent theater from a peer
- [ ] Confused-client window: _____ seconds (scribe). Acceptable / embarrassing
- [ ] Leftover named: `#8`, whisper catch-up, hosted theater

### 2. UI reload

**When:** Still mid-rite. Do **both** clients, one at a time.

**Human action:**

1. Congregation A: `/reload` during the rite.
2. After they are back: Pope: `/reload` during the same rite (or the next).

**Bible expect:** Congregation reload requests a snapshot and lands mid-rite. Pope reload resumes from the persisted event object in his account SV (`ChurchOfBeefDB.event`). Console is where he left it. No one else becomes writer.

**Tonight:** Event persist is shipped Core (schema 7 Restores a string `state`). There is no hosted Console to resume, and STATE / SNAPSHOT will not move. After `/reload`, both clients are Quiet shells again. `awaitingPope` is not painted. That is leftover host + leftover `#8`, not a resume pass.

- [ ] Congregation `/reload` mid-rite — no script error
- [ ] Pope `/reload` mid-rite — no script error
- [ ] Player `WTF/` was not deleted
- [ ] No client promoted itself to writer
- [ ] Confused-client window: _____ seconds
- [ ] Leftover named: unhosted Console / HUD, `#8` catch-up

### 3. Disconnect, including the Pope’s

**When:** After reload, still treating the night as live.

**Human action:**

1. Congregation A: exit to character select (or hard close), then log back in.
2. Pope: same — **the Pope’s client disconnects** while the congregation is still in the world. Then the Pope logs back in.

**Bible expect (§20.3):** Clients hold last state briefly, then degrade to a quiet-leaning **“awaiting the Pope”** presentation. That is Event Mode degraded — not a sixth state, not Quiet chrome, not a toast or pip. **No client promotes itself.** On reconnect, the Pope console resumes from the persisted event object. Congregation does not answer snapshot requests.

**Tonight:** `Runtime:MarkPopeLost` exists. Nothing on the wire calls it. There is no “awaiting the Pope” paint. Hold duration is unspecified — do not invent seconds. After login, Quiet shell. Persist would restore a Snapshot-shaped `event` **if** one had been written; Night 1 never hosted `StartEvent`, so `event` is likely `{}` and Init will not Restore. Do not `/run StartEvent` to manufacture a resume.

- [ ] Congregation disconnect / reconnect — no script error; no self-promotion
- [ ] **Pope** disconnect / reconnect — no script error; no other client took over
- [ ] No sixth state named `AWAITING_POPE` appeared
- [ ] No toast / pip / sound on disconnect
- [ ] Confused-client window (Pope gone): _____ seconds
- [ ] Leftover named: no `MarkPopeLost` caller, no degrade paint, unhosted resume

### 4. No-show petitioner

**When:** Pope is taking Gora petitions in the world (voice / `/s`). The named No-show does not arrive.

**Human action:** Someone petitions (speaks) for the No-show, or the No-show petitioned earlier and then vanished. Pope must continue the night without them.

**Bible expect:** Petitions are event-scoped. Pool shows present-and-alive. Pope one-tap dismisses, consequence-free. No auto-open of a Gora, no auto-end of the event, no snapshot Apply of INPUT. Soft re-petition cooldown exists in law; duration is unspecified — do not invent one. Congregation crash mid-petition: input is re-sendable; console deduplicates by character.

**Tonight:** No live INPUT channel. No hosted dismiss. Core `Dismiss` is consequence-free **if** called; it will not be. The Pope continues with his voice. Software must not auto-advance. That last part the skeleton already honors: nothing auto-opens a rite.

- [ ] Named No-show never entered the circle
- [ ] Pope continued the night (next petitioner, or a Gora without them)
- [ ] Software did not auto-open a Gora or auto-end the event
- [ ] Software did not paint the No-show’s name as theater
- [ ] Leftover named: INPUT channel, hosted petition desk, re-petition cooldown UX

### 5. Interrupted or disputed Gora

**When:** A second duel is live, or about to be. Do **one** of these — both if the crowd can stand it.

**Interrupted:** a third player walks the circle, a disconnect mid-duel, a guard, a heckler, or the Pope calls it off before a natural end.

**Disputed:** both fighters claim the win, or the flee/result is unclear.

**Human action:** Pope speaks **VOID** (interference / weirdness — one tap, no shame) or a **free ruling**. He may re-rule later. He may encourage a rematch. Combat stays WoW’s.

**Bible expect:** Software proposes from duel system messages if Appendix A #2 ever validates; Pope ratifies. VOID is immediate. Disconnect mid-Gora: console suggests Void, rematch encouraged. No auto-declare. No ELO. HUD persists through the verdict beat, then exits with the consequence. Cowardice Recorded is a first-class ruling with its own cue.

**Tonight:** Core `Void` / `FreeRuling` / `CowardiceRecorded` / `DeclareVictor` write the store **if** a later host calls them. Console wrappers refuse `#8`. HUD is unhosted. Sound is unwired. Duel-chat propose is leftover (A02). The Pope’s voice is the ruling. Software must not invent a winner. The skeleton already does not auto-declare.

- [ ] An interrupted **or** disputed Gora happened on purpose
- [ ] Pope spoke VOID or a free ruling (or Cowardice / Victor) in the world
- [ ] Software did not auto-declare a winner
- [ ] Software did not write a typed member self-report as the Gora
- [ ] No favor bar, no HUD, no verdict bell (leftover — expected tonight)
- [ ] Confused-client window: _____ seconds
- [ ] Leftover named: hosted verdicts, HUD through the beat, Sound, A02 propose

---

## Close / next morning

Bible §22.3 also asks: records persist and are visible the next morning; David never opened the guild roster and never touched a spreadsheet during the performance.

| Beat | Bible expect | Tonight |
|------|--------------|---------|
| End event | Pope one-clicks End. Event Mode chrome dies. Quiet returns | **Leftover host.** Nothing to end on the wire |
| Records persist | Account SV store + event. History is never deleted | **Shipped Core** — if any Core write happened. Night 1–3 hosted none |
| Records Book next morning | Player-opened parchment superlatives | **Leftover host.** `/beef` is still empty |
| Sacred Archive | One-action export | **Leftover Console action.** Codec exists |
| Spreadsheet / roster | David never opened either during the night | **Human test.** Software cannot open them for him; leftover Console is why he still might |

- [ ] Pope ended the night in voice. Software did not auto-end
- [ ] Event chrome (none tonight) did not linger into Tuesday
- [ ] David’s note: opened Blizzard guild roster? yes / no
- [ ] David’s note: touched an external spreadsheet? yes / no
- [ ] Next morning: Records Book opened from the addon? **leftover — do not tick as a product pass**
- [ ] Leftover named: unhosted Records, no Archive button, no hosted EndEvent

---

## Release-gate pass (do not tick)

This block is the Bible §22.3 rehearsal. It stays unchecked until a human walks a build that actually hosts the night. **The current skeleton cannot satisfy it.** Do not tick it to close Phase 6.

- [ ] Guild-only, unstreamed, real crowd, early ugly build
- [ ] Assembly under a **posted** Decree (Console Post, not a `/run`)
- [ ] Pope started the event from the **hosted** Console — zero configuration
- [ ] At least one Knighting via **KNIGHT THIS BEEF** (hosted)
- [ ] At least one sanctioned Gora with **hosted** HUD (no-health fallback is legal)
- [ ] Congregation **favor** was available (leftover today — do not invent)
- [ ] Failure 1 late arrival: snapshot from the Pope; theater within the quality bar
- [ ] Failure 2 `/reload`: congregation catch-up + Pope resume from SV
- [ ] Failure 3 disconnect **including the Pope’s**: awaiting-the-Pope degrade; no self-promotion
- [ ] Failure 4 no-show petitioner: dismiss / continue; no auto-advance
- [ ] Failure 5 interrupted or disputed Gora: Pope VOID or free ruling; no auto-declare
- [ ] No client confused longer than thirty seconds on any failure
- [ ] Records visible the next morning from the hosted Records Book
- [ ] David never opened the guild roster and never touched a spreadsheet
- [ ] `#8` was a real registered-Pope list, not a stub invented for the night
- [ ] SUMMON was not required (stretch). If used, it was one ping, nothing more

**Release gate:** NOT RUN.

---

## Leftovers (named, not fixed in this script)

1. **`#8` fail-closed rituals** — `IsRegisteredPope` always false. STATE / SNAPSHOT never send or Accept. Console verbs refuse.
2. **Unhosted Console / HUD / Records** — modules load; bootstrap and `/beef` never show them. No Console slash.
3. **No Console Post** — Decree banner cannot be produced from the night’s UI.
4. **Unwired Sound** — five cue names exist; nothing calls `Play`.
5. **No favor** — no INPUT channel, no split bar.
6. **No SUMMON** — stretch-MVP. People walk.
7. **No live INPUT** — petition / favor / confession do not travel.
8. **No guild promote** from Core on KNIGHT THIS BEEF. Guild-rank map is a nil stub.
9. **No live HUD health** — Appendix A #1 / OPEN_QUESTIONS #2. Fallback (cards without health) is also unhosted.
10. **No `MarkPopeLost` caller / degrade paint.** Hold duration stays unspecified.
11. **No monotonic-sequence gate** on Restore (named leftover from the offline chaos suite).
12. **Scoped out:** Confession transport, post-show clipboard, onboarding wall, Decree deputy, Curtain UX.

---

## After the night (when a human actually walks it)

- File bugs for script errors, self-promotion, auto-declare, Quiet leaks, or a confused client past thirty seconds.
- Do not resolve leftover product by inventing `#8`, SUMMON, favor, or a Console slash in a bugfix.
- Do not claim V1 / MVP complete. The streamed Gathering in Bible §22.3 is still the definition of done.
- Do not tick **Release gate** above unless the hosted night was real.
