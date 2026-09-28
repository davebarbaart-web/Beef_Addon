# Church of Beef — V1 Verification Checklist

Walkable success criteria under **Bible §22.3** (canonical definition of done)
and the **§22.1** MVP component list. Product law:
[`Game_Design_Bible_v1.1.1.md`](../design/Game_Design_Bible_v1.1.1.md) §22.1–22.3,
§21. Ten Laws: [`TEN_LAWS.md`](../reformation/phase-0/TEN_LAWS.md).

This file replaces the pre-reformation roster-backed / Grant / standing /
threshold / Prophet checklist. Those are not V1 success.

A green offline harness (`lua tests/run.lua`) is a **precondition**, not a
substitute. One complete human Gathering is the definition of done.

**Do not claim V1 or MVP complete.** **Do not claim `POLISH:PASS`.** Agents
may attach `POLISH:CANDIDATE` only. A human signs polish after spectacle, not
after a green harness.

Tick a box by replacing `[ ]` with `[x]` and appending
`— YYYY-MM-DD, character`. Leave every box unchecked until a human walks it
on the Anniversary client.

## Honesty (today)

Event desks are hosted. **Do not tick leftovers as done.** A human walk
is still required before any Event box is ticked.

- `/beef` is player-opened Quiet: the **player card** (Church rank and
  its §5 relationship line, Gathering plate under rank, story rubrics
  `BEEF GORA` / `BEEF RIVALS` / `BEEF LEGACY` only when they have rows;
  height 380 with no story, 580 with a story; thin empty charcoal close
  band) with the **Records Book** behind its one button. A live guild
  rank name fills the gold plate when the store has no human row (canon
  titles get the §5 relationship line).
  `/beef console` opens the
  target-driven **Director Console**; Presence is a rank census, not a
  name dump. Fight HUD shows only for a real sanctioned pair in Event Mode.
- **`OPEN_QUESTIONS.md` #8** is coded as `Data/Popes.lua` (shipped name:
  **Thedave**) plus `ChurchOfBeefDB.ui.popeOverrides`. Rituals and
  STATE / SNAPSHOT accept on listed characters only. Designated-Council
  UX stays open.
- Coded and walkable: favor (HUD plates, whisper-to-Pope, Pope tallies),
  the Decree wire (Post → DECREE broadcast), STATE on every transition,
  HELLO-triggered re-broadcast for late joiners, petition INPUT.
- Named leftovers — stay unnamed-as-done: **SUMMON**, **confession inbox
  UI**, **live HUD health**, **cold-tools UI** (Archive / Canonize /
  Recognition / Honorific / Notebook are Core-only), **two-client smoke**.

`solo-smoke.md`, `two-client-smoke.md`, and `guild-night-playtest.md` were
rewritten against the Bible. They are not this file's law.

## Preconditions

Not a Gathering. Do not treat a green row here as MVP.

- [ ] **Harness.** From the checkout that has `tests/run.lua`,
      `lua tests/run.lua` exits 0
- [ ] **Install.** Addon copied to Anniversary
      `Interface/AddOns/ChurchOfBeef/`. Loop:
      `.cursor/skills/church-of-beef-dev/SKILL.md`. Never touch `WTF/`
- [ ] **Errors on.** `/console scriptErrors 1`. Prefer BugGrabber + BugSack
- [ ] **Two clients** ready for any net / ceremony / star walk (Pope writer +
      congregation display). One client is enough for Quiet Tuesday and the
      `/beef` Church card

---

## 1. Loads on Anniversary (`20506`)

- [ ] **Church of Beef** appears in the AddOns list on TBC Classic
      Anniversary. TOC `## Interface: 20506`. No "out of date" toggle needed
- [ ] `/reload` after install: no script errors. A fresh install with no
      `ChurchOfBeefDB` still loads
- [ ] No Retail-only APIs and no combat automation through a full session

## 2. Quiet Tuesday (§14.2, Law 6, §19.1)

A random Tuesday login sees **almost nothing, plus the Decree.** Do not
"fix" the quiet with a feed.

- [ ] Unbidden Quiet chrome is **minimap presence + the active Decree only**.
      No feeds, dashboards, bars, toasts, pips, or ambient sound
- [ ] When a Decree is already in the store: parchment
      **A GATHERING HAS BEEN DECREED** shows once per login; thereafter
      minimap right-click replays it. No calendar, RSVP, reminders,
      recurrence, or attendance. (Console **Post the Decree** is coded —
      do not tick Console Post here; this box is login parchment + replay)
- [ ] When no Decree is set: no empty parchment. Minimap left-click opens
      player-opened Quiet
- [ ] Quiet Mode is silent. The only Quiet notice allowed is the §13.4
      version-mismatch drop
- [ ] No in-game nagging of players who have not installed (§21.2)

## 3. `/beef` is player-opened Quiet

- [ ] `/beef` opens a real frame, not a chat-only reply, including on a
      fresh install. Esc / close hides it. Open/close in combat does not
      taint bags or character
- [ ] **Today this frame is the player card** — rank plate, Gathering
      plate under rank (live Decree line or muted `No gathering is posted.`),
      `BEEF GORA` / `BEEF RIVALS` / `BEEF LEGACY` only when they have
      rows, and a thin empty charcoal close band, with the Records
      Book behind **CHURCH RECORDS**. It is not the Director Console, not
      the Fight HUD, and not Event theater. Bible §14.2 destination is
      browsable identity/history — never a position among members
- [ ] `/beef minimap` hides the button; `/beef minimap` brings it back.
      `/beef` still opens the card when the button is hidden

---

## 4. §22.1 MVP components

Tick only when a human can walk the component on Anniversary — not when a
module file exists. Leftover-tagged rows stay unchecked until that walk is
possible.

- [ ] **1. Exceptional Beef Gora** — petition hygiene, sanction with
      stipulations, mute fighter cards, favor with split display,
      adjudication verbs (Victor / Cowardice / Void / free ruling),
      elevation, character records. **Today:** the full loop is coded —
      target-driven Sanction on the console, favor on HUD plates
      (whisper-to-Pope), four rulings, elevation beat, store writes.
      Needs a live walk on Thedave
- [ ] **2. Live Fight HUD** — Event Mode, sanctioned pair, defined
      no-live-health fallback (§10.7). **Today:** hosted; paints for a
      real sanctioned pair only. Live-health form waits on Appendix A
      item 1 / OPEN_QUESTIONS #2 — do not treat the no-health module as
      a validation pass
- [ ] **3. Beef Pope Director Console** — Presence, Knighting, Gora desk,
      MARK THIS MOMENT, Notebook (§18). **Today:** hosted at
      `/beef console` as the target-driven kit; verbs accept on listed
      Pope characters (shipped: Thedave). Notebook is Core-only
- [ ] **4. Knighting administration** — KNIGHT THIS BEEF workflow; no
      generic ceremony engine. **Today:** hosted; target the Beef, one
      click, record writes. Guild-rank write where the API permits is
      leftover (Bible §8) — not a "never promote" success
- [ ] **5. Ceremony runtime** — QUIET → ASSEMBLY → RITE (typed) →
      CONSEQUENCE, including late join, reload, Pope-disconnect recovery,
      and version degradation (§20). **Today:** the machine is coded and
      persisted; late join is Pope re-broadcast on HELLO; a hosted night
      has not been walked
- [ ] **6. Pope-authoritative synchronization** — star topology; sender
      validation (§13.1, §13.4). **Today:** coded; accepts listed-Pope
      senders only (Thedave shipped). Two-client walk is leftover
- [ ] **7. Basic Church identity** — player + linked characters (Rite of
      Recognition), rank, records, plain profile. Walkable as identity,
      not as a points ladder. **Today:** the player card shows identity,
      rank and relationship line, record, rivalries, distinctions;
      targeting a stranger and Knighting/Sanctioning them is the
      recognition (§12.2); the alt-linking rite UI is parked
- [ ] **8. Records Book** — §10.9 superlatives; no ranked ladder.
      **Today:** hosted behind **CHURCH RECORDS** — Chronicle across both
      leaves, superlatives only when held, leaf-caption navigation
- [ ] **9. The Decree** — single active proclamation, hard-bounded
      (§14.1). **Today:** banner on post and once per login, minimap
      right-click replay, Console **Post the Decree**, DECREE broadcast
- [ ] **10. Sound cues** — §19.4 MVP set, Event Mode only. **Today:**
      cues fire from theater after successful ritual verbs. Quiet stays
      silent
- [ ] **11. Manual overrides on every automated step** — software
      proposes; the Pope ratifies. Nothing auto-declares, auto-advances,
      or auto-announces in the Pope's voice
- [ ] **12. The Sacred Archive** — one-action export/import, weekly cold
      reminder, Council cold mirror (§13.5). Tick when a human can run
      that ritual from the Pope's working tool
- [ ] **13. Polish** — a first-time Twitch viewer understands the
      spectacle. **`POLISH:CANDIDATE` is not this box.** Do not claim
      `POLISH:PASS`

Stretch-MVP (may slip one release; not a substitute for §22.3):

- [ ] Post-show clipboard summary (§18.4)
- [ ] **SUMMON THE FAITHFUL** (§7) — **uncoded leftover.** Do not tick

---

## 5. Definition of done (Bible §22.3)

> The MVP is done when the Church runs one complete, real Gathering —
> assembly under a Decree, several Knightings, several sanctioned Beef
> Goras with fight HUD and favor — live on stream, with records persisting
> afterward and visible the next morning, with a first-time Twitch viewer
> able to understand the spectacle, and with David never opening
> Blizzard's guild roster and never touching an external spreadsheet
> during the performance.

A green harness does not tick this section.

- [ ] Assembly under a Decree
- [ ] Several Knightings
- [ ] Several sanctioned Beef Goras with fight HUD **and favor**
- [ ] Live on stream
- [ ] Records persist and are visible the next morning
- [ ] A first-time Twitch viewer understands the spectacle
- [ ] David never opens Blizzard's guild roster during the performance
- [ ] David never touches an external spreadsheet during the performance

Do not tick this section while two-client smoke, inbound congregation
Sound / Proclaim (**#27**), or **SUMMON** remain leftovers the night still
needs, or while **#8** designated-Council UX is still open. Hosted Console /
HUD / Records / favor / Decree are coded; they still need a human Gathering
walk. SUMMON is stretch-MVP; the Gathering still requires Decree,
Knightings, HUD, and favor.

## 6. Release gate — dress rehearsal

Before public release: at least one deliberately imperfect **dress
rehearsal** (guild-only, unstreamed, on an early ugly build) that includes,
on purpose: a late arrival, a UI reload, a disconnect (including the
Pope's), a no-show petitioner, and an interrupted or disputed Gora
(§22.3, §20.4).

Walk the script: [`dress-rehearsal.md`](dress-rehearsal.md). That file is
the run-of-show. This checklist does not author it.

- [ ] Dress rehearsal walked per [`dress-rehearsal.md`](dress-rehearsal.md).
      Do not tick from a harness or a paper read

§21.3: no breaking protocol change on a Gathering day. Dual-publish
(CurseForge + Wago) is OPEN_QUESTIONS #1 — not a box to invent as done.

---

## Not V1 success (cut)

Do not add these back as ticks:

- Roster-backed standing, Grant, thresholds, promote suggestions
- Activity buckets / shared-instance co-play pay
- Beef Prophet; Officer standing correction
- "Addon never calls guild promote" (contradicts Bible §8 — KNIGHT THIS
  BEEF may call promote where the API permits; that write is leftover,
  not a new box)
- Departed-member sweeps / record expiry
- Guild-chat promote spectacle

## Leftovers — do not tick as done

| Leftover | Why it stays unchecked |
|----------|------------------------|
| **#8** designated-Council remainder | `Data/Popes.lua` ships **Thedave** plus `ChurchOfBeefDB.ui.popeOverrides`. Rituals and STATE / SNAPSHOT accept on listed characters only. Designated-Council UX stays open. |
| **SUMMON THE FAITHFUL** | Uncoded leftover. Stretch-MVP (§22.1). |
| **Confession inbox UI** | No inbox surface. Stay unnamed-as-done. |
| **Live HUD health** | No-health HUD is hosted. Live-health form is leftover. |
| **Cold-tools UI** | Archive / Canonize / Recognition / Honorific / Notebook are Core-only. |
| **Two-client smoke** | Coded star still needs a Pope + congregation walk. |
