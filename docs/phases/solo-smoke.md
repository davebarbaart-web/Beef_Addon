# Solo smoke — Quiet Tuesday + hosted surfaces

**Status:** NOT RUN. Do not tick this file as done. Do not date a pass.

**Purpose:** Single-client Anniversary walk of the shipped Quiet Tuesday and
the player-opened hosted surfaces. Do this **before**
[`two-client-smoke.md`](two-client-smoke.md) and
[`dress-rehearsal.md`](dress-rehearsal.md). This is **not** a Gathering.
This is **not** MVP done (Bible §22.3). A green harness is a precondition,
not a substitute.

**Law:** [`Game_Design_Bible_v1.1.1.md`](../design/Game_Design_Bible_v1.1.1.md)
§14 (Decree; Tuesday identity), §18 (Director Console), §19.1 (Quiet Mode),
§20 (ceremony runtime), §22.3 (definition of done — later). Ten Laws:
[`.cursor/rules/ten-laws.mdc`](../../.cursor/rules/ten-laws.mdc) — especially
Law 1 (no points), Law 6 (Quiet Mode), Law 9 (six ranks; no Prophet).

**Install / reload:** [`.cursor/skills/church-of-beef-dev/SKILL.md`](../../.cursor/skills/church-of-beef-dev/SKILL.md).
Never touch `WTF/` or player `ChurchOfBeefDB.lua`.

**Companions:** [`v1-checklist.md`](v1-checklist.md) is the §22.3 Gathering
walk. [`dress-rehearsal.md`](dress-rehearsal.md) is the chaos night. This
file is the one-client Tuesday.

Agents prep install + harness. Humans tick boxes with date + character.

Tick a box by replacing `[ ]` with `[x]` and appending
`— YYYY-MM-DD, character`. Leave every box unchecked until a human walks it
on the Anniversary client.

---

## What this is

A one-client load of Church of Beef on TBC Classic Anniversary
(`## Interface: 20506`). Prove Quiet Tuesday holds, then open the surfaces
the slash actually hosts today: the **player card** (`/beef`), the
chronicle-first **Records** behind it, the hideable minimap roundel, the
**Decree** banner when a line is set, and the **Director Console**
(`/beef console`) — the target-driven Pope kit. Owner inspection
(`InspectProgress`) is a `/run`, not a slash.

Account store is schema **7**: `{ version, ui, store, event, decree }`.

## What this is not

- Not a Gathering. Not the streamed §22.3 night.
- Not `POLISH:PASS`. Not V1 / MVP complete.
- Not a roster-backed standing ladder, Grant walk, Officer tab, or
  Beef Prophet map. Those products are deleted.
- Not a Fight HUD walk. The HUD shows only for a **real sanctioned pair**.
  Do not invent Store Gora rows so a card appears.
- Not two-client BeefNet, dress-rehearsal chaos, SUMMON, or
  CurseForge upload.

---

## Honesty (today)

| Surface | What a human will see |
|---------|------------------------|
| Quiet Tuesday | Almost nothing. Minimap roundel present. Decree parchment **hidden until a line is Set**. No feeds, dashboards, bars, toasts, pips, or sound. |
| `/beef` | Toggles the **player card** (320 wide; height 380 with no story, 580 with a story; movable): your name and class on a dark plate; your **Church rank** on a gold plate with its Bible §5 relationship line ("Belonging", "Proven prestige" …) and Knighting date; guild and Blizzard rank in small type; a **Gathering** plate under rank (live Decree line or muted `No gathering is posted.`); story rubrics `BEEF GORA` / `BEEF RIVALS` / `BEEF LEGACY` only when they have rows (roman Gora pair with longest streak and defenses for a Lord; up to three head-to-head rivalries; held superlatives then honorifics); thin empty charcoal close band (no Decree). The gold plate shows the live guild rank when the store has no human row (canon titles get the §5 relationship line; any other name, including Guild Master, is labeled "Guild rank."). `GetGuildInfo` is often empty on login — the card kicks the roster and repaints on `GUILD_ROSTER_UPDATE`. Honest empties: `UNRECORDED` only when no guild rank is readable yet; empty story sections collapse. One button, **CHURCH RECORDS**, opens the book and the card steps aside. Never a position among members (§10.9). No feed. |
| Records Book | Opens on the **Chronicle**, which spans both leaves (14 dated rows, newest first; "Nothing has been written yet." when empty). Footer: **‹ PREVIOUS**, "Leaf I of III · Chronicle", **NEXT ›** — Previous hides on the first leaf, Next on the last. Superlative leaves appear only when someone holds them and carry a faint papal watermark on the right leaf. No tabs. Mouse wheel turns leaves. |
| Minimap | Left-click toggles the player card. Right-click replays the active Decree (nothing when none is posted). Tooltip: **GUILD GATHERING**, "Left-click: your card". Drag moves the roundel. |
| `/beef minimap` | Hides or shows the roundel. `/beef` still opens the card while hidden. |
| Decree | Stored `line` + optional `flavor`. Header **A GATHERING HAS BEEN DECREED** is UI copy. Banner once per login; thereafter minimap right-click. A new Set (Console **Post the Decree** or inbound DECREE) shows the banner again for that decree. **YOUR CARD** dismisses the notice and opens the player card. No calendar, RSVP, reminders, recurrence, or attendance. |
| `/beef console` | The **Director Console**: one compact stock panel. Phase line in human words ("No gathering is live." / "Gathering live — no rite open." / "Knighting rite open." / "Gora rite open." / "Consequence — rule, then continue."). One primary verb per phase: **Start the gathering**; **Open a Knighting rite** / **Open a Gora rite**; **Close this rite**; **Continue** / **End the gathering**. A target line ("Targeting: …") drives **KNIGHT THIS BEEF**, **Add to the line** (when the subject still needs Knighting), **Fighter A/B** + stipulation + **SANCTION BEEF GORA**, and the verdict plates. **Elevate to Lord** appears when the subject is a Beef Knight during an event. **Mark this moment** is always available during an event. Secondary strips: **Waiting to be knighted**, **Asked to fight**, **Presence** as a rank census (counts by Church title and live guild title, plus Unrecorded) — not a name dump. Cold tools (Archive, Canonize, Recognition, Honorific, Notebook, ceremony log, confession inbox) are **not** in the UI — Core-only. |
| Pope list | `Sender:IsRegisteredPope` is true only when the local name is in `Data/Popes.lua` or `ChurchOfBeefDB.ui.popeOverrides`. Shipped name: **Thedave**. Other characters stay fail-closed ("not a registered pope"). Targeting an NPC does not create a subject. |
| Fight HUD | Inited; stays hidden in QUIET and without a live sanctioned pair. This smoke will not show it. The **fighter card** is a sanction beat: it shows at sanction and hides at the ruling, rite close, or event end (ESC dismisses earlier). Proclaim toasts dismiss with ESC. |
| Event Inputs | A small stock **EVENT INPUT** strip during a live event: recipient (bound target, else the listed Pope) and one **Petition** button. Favor picks live on the HUD plates during a Gora rite. |
| `InspectProgress()` | Owner inspection only. Not a slash. Sets a Goldshire Decree (persists), opens banner + card + Console, plays one `sanction` cue inside `StartEvent` / `EndEvent`, returns Runtime to **QUIET**. Does **not** write Store Gora rows. Rituals still refuse on unlisted characters. |

Slash (spaces stripped): `/beef`, `/beef minimap`, `/beef console`.
Unrecognised arguments open the player card. There is no `/beef petition`,
`/beef confess`, or `/beef catchup` — congregation sends target the listed
Pope by default, and the Pope's client re-broadcasts STATE when a guildmate
HELLOs during a live event (late joiners need no action).

---

## Preconditions

Not a Gathering. Do not treat a green row here as MVP.

- [ ] `lua tests/run.lua` → `0 failed` (agent or human). That is not this smoke.
- [ ] Addon installed to Anniversary `_anniversary_`
      `Interface/AddOns/ChurchOfBeef/`. Loop: church-of-beef-dev skill §2.
      Never touch `WTF/`
- [ ] `/console scriptErrors 1` (prefer BugGrabber + BugSack)
- [ ] One Anniversary client. Guild membership is not required for this
      walk. Presence on the Console may be empty if unguilded — that is
      not a fail

If a prior session already left a Decree in account SV, the parchment may
show on login. That is correct Quiet chrome (Law 6), not a fail. To walk
the hidden-until-Set case without touching `WTF/`:
`/run ChurchOfBeef.Decree:Clear()` then `/reload`.

---

## Walk (~15–20 min)

Walk steps 1–4 **before** setting a Decree if the store is still empty.

### 1. Load

- [ ] Addon listed as **Church of Beef** on TBC Classic Anniversary.
      TOC `## Interface: 20506`. No "out of date" toggle needed
- [ ] `/reload` after install: no script errors. A fresh install with no
      `ChurchOfBeefDB` still loads

### 2. Quiet Tuesday (Bible §14.2, §19.1, Law 6)

A random Tuesday login sees **almost nothing, plus the Decree.** Do not
"fix" the quiet with a feed.

- [ ] Unbidden chrome is the **minimap roundel only** when no Decree is
      set. No parchment. No feeds, dashboards, bars, toasts, pips, or
      ambient sound
- [ ] Quiet Mode is silent. The only Quiet notice allowed is the §13.4
      version-mismatch drop (not expected on one client, one build)
- [ ] No in-game nagging of players who have not installed (§21.2)

### 3. `/beef` is the player card (§12.5, §14.2)

- [ ] `/beef` toggles the **player card**, not a chat-only reply, including
      on a fresh install. Esc, **CLOSE**, or `/beef` again hides it. Drag
      from the title band; the position survives `/reload`
- [ ] The card reads in five seconds: your name in class color, the
      **rank plate** (or `UNRECORDED` / "Not yet in the Church's record."),
      the relationship line under it, a **Gathering** plate under rank
      (live Decree line or muted `No gathering is posted.`), and
      `BEEF GORA` / `BEEF RIVALS` / `BEEF LEGACY` only when they have
      rows. Empty story collapses; height 380 with no story, 580 with a
      story. Thin empty charcoal close band (no Decree). **No counters,
      no state words, no feed, no position among members.**
- [ ] The blackletter display face actually renders on the name, the rank
      plate, and the record (not Friz fallback). Gold text sits only on the
      dark plates; parchment text is charcoal / iron / oxblood. Nothing
      overlaps the **CHURCH RECORDS** button at the default UI scale
- [ ] **CHURCH RECORDS** hides the card and opens the Records Book on the
      **Chronicle**. Empty store: "Nothing has been written yet." and no
      superlative leaves at all; footer reads "Leaf I of I · Chronicle"
      with neither **‹ PREVIOUS** nor **NEXT ›** shown
- [ ] This is **not** a Ladder, Standing tab, Officer desk, Grant surface,
      or points history. No Beef Prophet. Ranks, when they appear, are
      exactly the six in Law 9. The Pope is not a rank
- [ ] Minimap left-click toggles the same card

### 4. `/beef minimap`

- [ ] `/beef minimap` hides the roundel
- [ ] `/beef` still opens the player card while the roundel is hidden
- [ ] `/beef minimap` again shows the roundel

### 5. Decree (§14.1)

Listed Pope: use Console **Post the Decree** (line + optional flavor).
Unlisted character: Set from `/run`. Either path is smoke, not a Gathering
Post.

```
/run ChurchOfBeef.Decree:Set({ line = "Goldshire Inn — Sunday, 7:00 PM", flavor = "The Gathering." })
```

- [ ] A new Set shows the parchment **A GATHERING HAS BEEN DECREED** with
      the line and optional flavor (no `/reload` needed for the post
      itself). Dismiss it
- [ ] After `/reload` the banner shows **once** more (login reveal), then
      stays quiet
- [ ] Minimap **right-click** replays the banner. Left-click still opens
      the player card
- [ ] No calendar, RSVP, reminders, recurrence, or attendance chrome

### 6. `/beef console` (Bible §18; OPEN_QUESTIONS #11)

- [ ] `/beef console` opens the **Director Console**: one compact stock
      panel, not theatrical parchment. Esc / close hides it
- [ ] Every verb **refuses** with "not a registered pope" on an unlisted
      character. Shipped Pope name is **Thedave** — log in as Thedave for
      the verbs to accept
- [ ] As Thedave: **Start the gathering** works with zero setup. The phase
      line and verbs follow the runtime in human words. **End the
      gathering** returns to "No gathering is live."
- [ ] Target a guildmate: the target line names them with their Church
      rank. **KNIGHT THIS BEEF** on a targeted stranger creates their
      record and Knights them in one action (that *is* the recognition —
      §12.2). Targeting an NPC does nothing
- [ ] The strips (**Waiting to be knighted**, **Asked to fight**,
      **Presence**) read as short lists or one-line empty states, never
      blank wells
- [ ] Software does not auto-announce, auto-advance, or narrate (Law 4)

### 7. Owner inspection — `InspectProgress()` (not a slash)

```
/run ChurchOfBeef:InspectProgress()
```

Owner inspection only. Not a Gathering start.

- [ ] Goldshire Decree is Set (persists): line
      `Goldshire Inn — Sunday, 7:00 PM`, flavor `The Gathering.`
      Banner, player card, and Director Console are open
- [ ] One `sanction` cue plays **inside** `StartEvent` / `EndEvent`.
      Runtime is **QUIET** again when the call returns
- [ ] Store has **no** new Gora rows. Fight HUD does **not** appear
      (no sanctioned pair — do not fake one)
- [ ] Console verbs still refuse on an unlisted character

### 8. Combat

- [ ] Open and close `/beef` mid-trash — no taint; bags and character
      pane still work. No script errors

---

## Out of scope this smoke

Do not walk these here. Do not invent a path so they can be ticked.

- Live Gathering (assembly, several Knightings, several sanctioned Goras)
- Congregation favor split display (needs a live sanctioned Gora)
- SUMMON THE FAITHFUL
- Confession inbox UI (transport exists; the desk inbox is parked)
- Live HUD health (Appendix A item 1) — and any HUD without a sanctioned pair
- Two-client BeefNet / STATE / SNAPSHOT walk
- Dress-rehearsal chaos (late arrival, Pope disconnect, no-show, disputed Gora)
- CurseForge / Wago / WoWI upload
- `POLISH:PASS`
- V1 / MVP complete (Bible §22.3)

Do not add Grant, standing, thresholds, Beef Prophet, or an Officer tab
back as boxes.

---

## Pass / fail

**Pass:** steps 1–8 clean against the Bible product. Quiet Tuesday is
minimap + Decree only. `/beef` is the player card, not a ladder or a
dashboard. Minimap hides and returns. Decree banner on post and once per
login, then minimap right-click replay; no calendar or RSVP.
`/beef console` is the target-driven kit; verbs refuse until the character
is a listed Pope; a Tuesday Knighting runs off the target with no scroll
hunt. `InspectProgress` shows Goldshire + card + Console, one sanction
cue, Runtime back to QUIET, no Store Gora rows, no HUD. Combat toggle does
not taint. No script errors.

**Fail:** load error; `/beef` is a Ladder / Standing / Officer / Grant
surface or a metrics dashboard; Quiet feeds, toasts, pips, or sound; HUD
appears without a sanctioned pair; rituals fire for an unlisted character;
a targeted NPC becomes a Church record; `InspectProgress` writes Gora rows
or leaves Runtime out of QUIET; calendar / RSVP; Prophet / Grant /
standing chrome; script errors; combat taint.

A pass here is **not** a Gathering, **not** dress rehearsal, and **not**
MVP done.

---

## Leftovers (named, not fixed in this script)

1. **Pope list ships Thedave.** Rituals accept on that character. Other
   characters refuse unless listed in `ChurchOfBeefDB.ui.popeOverrides`.
   Do not invent more names.
2. **Cold tools are Core-only.** Archive export/import, Canonize,
   Recognition rite, Grant Honorific, Notebook, and the confession inbox
   have no UI. Do not invent a panel for them in this smoke.
3. **Fight HUD** — needs a real sanctioned pair. No fake Store rows.
   Live health is Appendix A item 1 / OPEN_QUESTIONS #2.
4. **SUMMON** — uncoded. Out of scope.
5. **Sound cues** — the five Event cues play after successful ritual
   verbs via theater. Quiet stays silent. `InspectProgress` still plays
   one `sanction` inside StartEvent/EndEvent.
6. **Two-client star / dress rehearsal / §22.3 Gathering** — later files.
7. **Scoped out:** CurseForge upload, `POLISH:PASS`, V1 complete.

---

## After the walk (when a human actually walks it)

- File bugs for script errors, Quiet leaks, a Ladder / Grant / Prophet
  surface, HUD without a sanctioned pair, rituals that fire without a
  listed Pope, or a target verb that acts on an NPC.
- Do not resolve leftovers by inventing a Pope name, fake Gora rows, a
  calendar, or a cold-tools panel.
- Do not claim V1 / MVP complete. Do not claim `POLISH:PASS`.
- Do not tick this file from a harness or a paper read.
