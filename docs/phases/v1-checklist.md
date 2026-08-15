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

Most Event boxes cannot be walked yet. **Do not tick leftovers as done.**

- `/beef` is player-opened Quiet: the **Records Book**. `/beef console`
  opens the Director Console. Fight HUD shows only for a real sanctioned
  pair in Event Mode.
- **`OPEN_QUESTIONS.md` #8** is coded as empty `Data/Popes.lua` plus
  `ChurchOfBeefDB.ui.popeOverrides`. Rituals and STATE / SNAPSHOT stay
  fail-closed until David lists a Pope character. Designated-Council UX
  stays open.
- Named leftovers — stay unnamed-as-done: **favor**, **SUMMON**,
  **INPUT / Confession**, **Decree wire**, **Console `SendState`**,
  **live HUD health**.

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
      empty `/beef` shell

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
      minimap left-click replays it. No calendar, RSVP, reminders,
      recurrence, or attendance. (Posting a Decree from a hosted Console is
      leftover — do not tick Console Post here)
- [ ] When no Decree is set: no empty parchment. Minimap left-click opens
      player-opened Quiet
- [ ] Quiet Mode is silent. The only Quiet notice allowed is the §13.4
      version-mismatch drop
- [ ] No in-game nagging of players who have not installed (§21.2)

## 3. `/beef` is player-opened Quiet

- [ ] `/beef` opens a real frame, not a chat-only reply, including on a
      fresh install. Esc / close hides it. Open/close in combat does not
      taint bags or character
- [ ] **Today this frame is an empty Quiet shell.** It is not the Director
      Console, not the Fight HUD, not the Records Book, and not Event
      theater. Bible §14.2 destination is browsable identity/history, not a
      standing ladder. Do not tick hosted Records or Console on this box
- [ ] `/beef minimap` hides the button; `/beef minimap` brings it back.
      `/beef` still opens the shell when the button is hidden

---

## 4. §22.1 MVP components

Tick only when a human can walk the component on Anniversary — not when a
module file exists. Leftover-tagged rows stay unchecked until that walk is
possible.

- [ ] **1. Exceptional Beef Gora** — petition hygiene, sanction with
      stipulations, mute fighter cards, favor with split display,
      adjudication verbs (Victor / Cowardice / Void / free ruling),
      elevation, character records. **Today:** Core verbs exist; **#8**
      fail-closes them; **favor** is uncoded; Console is **unhosted**
- [ ] **2. Live Fight HUD** — Event Mode, sanctioned pair, defined
      no-live-health fallback (§10.7). **Today: unhosted.** Live-health
      form waits on Appendix A item 1 / OPEN_QUESTIONS #2 — do not treat
      the no-health module as a validation pass
- [ ] **3. Beef Pope Director Console** — Presence, Knighting, Gora desk,
      MARK THIS MOMENT, Notebook (§18). **Today: unhosted.** No slash.
      Rituals fail-closed on **#8**
- [ ] **4. Knighting administration** — KNIGHT THIS BEEF workflow; no
      generic ceremony engine. **Today:** Core verb; **unhosted**; **#8**
      fail-closed. Guild-rank write where the API permits is leftover
      (Bible §8) — not a "never promote" success
- [ ] **5. Ceremony runtime** — QUIET → ASSEMBLY → RITE (typed) →
      CONSEQUENCE, including late join, reload, Pope-disconnect recovery,
      and version degradation (§20). **Today:** Core machine exists; a
      hosted night does not
- [ ] **6. Pope-authoritative synchronization** — star topology; sender
      validation (§13.1, §13.4). **Today:** fail-closed until **#8**
- [ ] **7. Basic Church identity** — player + linked characters (Rite of
      Recognition), rank, records, plain profile. Walkable as identity,
      not as a points ladder
- [ ] **8. Records Book** — §10.9 superlatives; no ranked ladder.
      **Today: unhosted** (no slash, not wired to `/beef` or the minimap)
- [ ] **9. The Decree** — single active proclamation, hard-bounded
      (§14.1). Banner + minimap replay exist when a line is in the store.
      Console Post is leftover
- [ ] **10. Sound cues** — §19.4 MVP set, Event Mode only. **Today:** the
      verb exists; **callers are not wired**. Quiet stays silent
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

Do not tick this section while **#8**, hosted Console / HUD / Records,
**favor**, Sound callers, or **SUMMON** remain leftovers that the night
still needs. SUMMON is stretch-MVP; the Gathering still requires Decree,
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
| **#8** registered-Pope / designated-Council | Uncoded. Rituals and star sync fail-closed |
| **Hosted Director Console** | Module exists; no slash; not wired to `/beef` |
| **Hosted Fight HUD** | Module exists; not hosted into a night |
| **Hosted Records Book** | Module exists; not wired to `/beef` or minimap |
| **Favor** | Uncoded. §22.3 requires it on the Gathering |
| **Sound callers** | Verb exists; nothing plays it |
| **SUMMON THE FAITHFUL** | Uncoded. Stretch-MVP (§22.1) |
