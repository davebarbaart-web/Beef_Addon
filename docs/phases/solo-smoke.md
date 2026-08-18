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
the slash actually hosts today: Records Book, hideable minimap, Decree
banner when a line is set, Director Console (stock desks; rituals refuse
until the local character is listed as Pope). Owner inspection
(`InspectProgress`) is a `/run`, not a slash.

Account store is schema **7**: `{ version, ui, store, event, decree }`.

## What this is not

- Not a Gathering. Not the streamed §22.3 night.
- Not `POLISH:PASS`. Not V1 / MVP complete.
- Not a roster-backed standing ladder, Grant walk, Officer tab, or
  Beef Prophet map. Those products are deleted.
- Not a Fight HUD walk. The HUD shows only for a **real sanctioned pair**.
  Do not invent Store Gora rows so a card appears.
- Not two-client BeefNet, dress-rehearsal chaos, favor, SUMMON, or
  CurseForge upload.

---

## Honesty (today)

| Surface | What a human will see |
|---------|------------------------|
| Quiet Tuesday | Almost nothing. Minimap present. Decree parchment **hidden until a line is Set**. No feeds, dashboards, bars, toasts, pips, or sound. |
| `/beef` | Opens the **Records Book** (parchment superlatives, §14.2 / §10.9). Empty pages until real Gora rows exist. Not a Ladder. Mouse wheel turns leaves (up Previous, down Next), including over the title bar, Close, ribbons, and page buttons. Page titles use stock `Fonts\\MORPHEUS.ttf` (FRIZQT / GameFont fallback) and re-apply that face on the book title and page title when the leaf turns. Hide remounts a missing OnHide so ESC still re-lists `ChurchOfBeefRecordsBook`. Show / Init remount a missing OnHide. pageIndex stays. |
| Minimap (no Decree) | Same as `/beef` — Records Book. |
| Minimap (Decree set) | Left-click **replays** the banner. Does not open the Book. |
| `/beef minimap` | Hides or shows the button. `/beef` still opens the Book when the button is hidden. |
| Decree | Stored `line` + optional `flavor`. Header **A GATHERING HAS BEEN DECREED** is UI copy. Banner once per login; thereafter minimap replay. No calendar, RSVP, reminders, recurrence, or attendance. Console **Post Decree** exists and refuses unless listed; `/run Decree:Set` is the unlisted path. After Clear, the banner Refreshs itself (wipe + hide). Hide still blanks leftover line/flavor. Hide remounts `ChurchOfBeefDecree` on `UISpecialFrames`. ESC / widget Hide after Clear also blanks leftover Goldshire. |
| `/beef console` | Opens the Director Console (stock desks). OPEN_QUESTIONS #11. Ritual buttons refuse unless the local character is listed as Pope. Desk now also has EXPORT / IMPORT ARCHIVE, CANONIZE, and FLAG UPSET (Pope-local; no theater). The desk body scrolls (stock mouse wheel, 36px step). Focused boxes ClearFocus on ESC (the desk stays). ESC dismisses the named desk once (`UISpecialFrames` deduped; Hide / Refresh remount a missing OnHide so ESC still re-lists `ChurchOfBeefConsoleFrame`). The Event dock drag persists to account SV. ESC hides the dock until Expand / Show or a **new** event (same-event Refresh does not pop it back). Hide / Show / Refresh / Init remount the named dock on `UISpecialFrames` and remount a missing OnHide so dismiss persist still writes. Theater owns §19.4 cues when Proclaim exists (the desk does not double-play). KNIGHT THIS BEEF does not demote a Lord. ELEVATE TO LORD does not demote a Butcher or Council. Confession inbox rows click-select the confessor; Call Forward still paints mute `"  called"`; a later line from the same confessor clears that token. Stock Dismiss drops a petition and, when Confession is loaded, the same id from the inbox. Successful Dismiss also drops leftover character selection so Call Forward / Declare Victor do not fire on the dismissed petitioner. Successful Dismiss of a pair member also drops leftover proposed pair / Recommend so leftover Flag Upset / Sanction do not fire on the dismissed fighter. Third-id Dismiss keeps the pair. Open Gora after Continue does not reopen leftover last fighters; the live sanctioned pair and a desk pick still win. Recommend paints mute `"  names  "` when a petition named the other combatant and the Pope had not already selected the pair; End Event / a new Start Event / a QUIET Refresh (including glue `Runtime:EndEvent`) clears that line. The selected pair still clears only on successful Start / End Event. Successful End Event also drops leftover human / character selection so Call Forward / Dismiss / KNIGHT THIS BEEF do not fire on the previous person. Start Event keeps a Quiet pick. No second Dismiss. Presence lists Store names (`here` false) while the guild roster is only a login seed; those rows dim at stock `SetAlpha(0.45)` and do not gain an "offline" word. Hidden leftover Presence buttons reset to alpha 1 when the list shrinks. |
| Pope list | `Sender:IsRegisteredPope` is true only when the local name is in `Data/Popes.lua` or `ChurchOfBeefDB.ui.popeOverrides`. Shipped name: **Thedave**. Other characters stay fail-closed. Do not invent more names. |
| Fight HUD | Inited; stays hidden in QUIET and without a live sanctioned pair. This smoke will not show it. Fighter card, Proclaim, and the small Event toast dismiss with ESC (`UISpecialFrames`); no close button and no panel whoosh. The Quiet shell Show remounts its OnHide. Hide remounts that OnHide and re-lists `ChurchOfBeefFrame` so ESC persist still writes `shown = false`. Already-hidden Hide also writes `shown = false` even when OnHide does not fire again. ESC on the small toast advances one queued toast. An interrupting toast does not lose the queued row. Fighter-card and HUD names use stock `Fonts\\MORPHEUS.ttf`. Shown HUD names re-tint after that face / GameFont apply so class color survives `SetFontObject`. Mute defense integers are `SetWidth(28)` so they do not grow into VS. A successful Target keeps the last candidate / fighter mark token and fighter names so the next Mark* can still clear it. Congregation Inputs confess text is trimmed; whitespace-only text omits the field and still whispers. `SendConfession` also trims on the wire so a padded body does not encode spaces. Pope-gated `SendSnapshot` refuses a whitespace dest before encode. Proclaim headlines re-apply that face on each shown beat. Fighter-card Show / Refresh / Hide restore a missing OnHide. Hide remounts `ChurchOfBeefFighterCard` on `UISpecialFrames`. Congregation Inputs confess box ClearFocuses on ESC (the panel stays) and sits below the 12px drag handle. Quiet Hide blanks leftover confess text; dest stays. Quiet HUD Refresh drops leftover congregation favor. Inputs drag from the TitleBar. Congregation favor plates send only during a Gora RITE. Knighting leftover fighters (and a prior Gora lastPair during a non-Gora RITE or CONSEQUENCE, including after Knighting Continue) do not paint the HUD. SNAPSHOT and live STATE last-pair overlay are Gora-only; Knighting CONSEQUENCE catch-up does not carry leftover Gora fighters. End Event Forgets leftover raid marks (Quiet sweep). Clear still refuses Quiet. Fighter-card Show / Refresh remount `ChurchOfBeefFighterCard`. HideAll remounts `ChurchOfBeefToast` and `ChurchOfBeefProclaim`. Existing-frame toast Init remounts both names. The Event dock Show / Refresh / Init remount a missing OnHide. A new candidate / fighter mark clears the previous raid mark. Grouped self-mark and Clear use the `player` token even if `GetNumGroupMembers` is missing. Petition may name `UnitName("target")` as opponent when that name is not the Pope whisper dest and the player name read is a non-empty trimmed string. Whisper dest is trimmed; whitespace-only dest is no target. The Gora desk still shows Store petitioners and Store presence while the guild roster is only a login seed. |
| `InspectProgress()` | Owner inspection only. Not a slash. Sets a Goldshire Decree (persists), opens banner + Records + Console, plays one `sanction` cue inside `StartEvent` / `EndEvent`, returns Runtime to **QUIET**. Does **not** write Store Gora rows. Console buttons still refuse. |

Slash (spaces stripped): `/beef`, `/beef minimap`, `/beef console`, `/beef petition`, `/beef confess`, `/beef catchup`. Unrecognised arguments open the Records Book.

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

- [ ] Unbidden chrome is the **minimap only** when no Decree is set.
      No parchment. No feeds, dashboards, bars, toasts, pips, or ambient
      sound
- [ ] Quiet Mode is silent. The only Quiet notice allowed is the §13.4
      version-mismatch drop (not expected on one client, one build)
- [ ] No in-game nagging of players who have not installed (§21.2)

### 3. `/beef` opens the Records Book (§14.2)

- [ ] `/beef` opens the **Records Book**, not a chat-only reply, including
      on a fresh install. Esc / close hides it
- [ ] Pages exist as parchment superlatives (Most Sanctioned Victories,
      Longest Streak, and the rest of the §10.9 set). They are **empty**
      until real Gora rows exist. That is correct, not a broken Book
- [ ] This is **not** a Ladder, Standing tab, Officer desk, Grant surface,
      or points history. No Beef Prophet. Ranks, when they appear later,
      are exactly the six in Law 9. The Pope is not a rank
- [ ] Minimap left-click (no Decree set) opens the same Book

### 4. `/beef minimap`

- [ ] `/beef minimap` hides the button
- [ ] `/beef` still opens the Records Book while the button is hidden
- [ ] `/beef minimap` again shows the button

### 5. Decree (§14.1)

Listed Pope: use Console **Post Decree** (line + optional flavor). Unlisted
character: Set from `/run`. Either path is smoke, not a Gathering Post.

```
/run ChurchOfBeef.Decree:Set({ line = "Goldshire Inn — Sunday, 7:00 PM", flavor = "The Gathering." })
```

Then `/reload` so the login banner can fire once.

- [ ] After Set + `/reload`: parchment **A GATHERING HAS BEEN DECREED**
      shows **once** with the line and optional flavor. Dismiss it
- [ ] Minimap left-click **replays** the banner. It does not open the
      Records Book while a Decree is active
- [ ] `/beef` still opens the Records Book (player-opened Quiet), not a
      calendar
- [ ] No calendar, RSVP, reminders, recurrence, or attendance chrome

### 6. `/beef console` (Bible §18; OPEN_QUESTIONS #11)

- [ ] `/beef console` opens the **Director Console**. Stock desks
      (Presence, Knighting, Gora, runtime Start / End). Functional /
      stock-template, not theatrical parchment
- [ ] Esc / close hides it. This is a player-opened Pope tool, not
      unbidden Quiet chrome
- [ ] Ritual buttons **refuse** unless the local character is a listed
      Pope. Start Event, Open Gora, KNIGHT THIS BEEF, and the other verbs
      do not start a night on an unlisted character
- [ ] Shipped Pope name is **Thedave**. Log in as Thedave for ritual
      verbs to accept. Other characters stay fail-closed unless listed
      in `ChurchOfBeefDB.ui.popeOverrides`. Do not invent more names.
- [ ] Software does not auto-announce, auto-advance, or narrate (Law 4)

### 7. Owner inspection — `InspectProgress()` (not a slash)

```
/run ChurchOfBeef:InspectProgress()
```

Owner inspection only. Not `#8`. Not a Gathering start.

- [ ] Goldshire Decree is Set (persists): line
      `Goldshire Inn — Sunday, 7:00 PM`, flavor `The Gathering.`
      Banner, Records Book, and Director Console are open
- [ ] One `sanction` cue plays **inside** `StartEvent` / `EndEvent`.
      Runtime is **QUIET** again when the call returns
- [ ] Store has **no** new Gora rows. Fight HUD does **not** appear
      (no sanctioned pair — do not fake one)
- [ ] Console buttons still refuse on an unlisted character

### 8. Combat

- [ ] Open and close `/beef` mid-trash — no taint; bags and character
      pane still work. No script errors

---

## Out of scope this smoke

Do not walk these here. Do not invent a path so they can be ticked.

- Live Gathering (assembly, several Knightings, several sanctioned Goras)
- Congregation favor
- SUMMON THE FAITHFUL
- INPUT / Confession channel
- Live HUD health (Appendix A item 1) — and any HUD without a sanctioned pair
- Two-client BeefNet / STATE / SNAPSHOT / whisper catch-up
- Dress-rehearsal chaos (late arrival, Pope disconnect, no-show, disputed Gora)
- CurseForge / Wago / WoWI upload
- `POLISH:PASS`
- V1 / MVP complete (Bible §22.3)

Do not add Grant, standing, thresholds, Beef Prophet, or an Officer tab
back as boxes.

---

## Pass / fail

**Pass:** steps 1–8 clean against the Bible product. Quiet Tuesday is
minimap + Decree only. `/beef` is the Records Book, not a ladder. Minimap
hides and returns. Decree banner once per login, then minimap replay; no
calendar or RSVP. `/beef console` opens stock desks; rituals refuse until
David lists the Pope character. `InspectProgress` shows Goldshire + Book +
Console, one sanction cue, Runtime back to QUIET, no Store Gora rows, no
HUD. Combat toggle does not taint. No script errors.

**Fail:** load error; `/beef` is a Ladder / Standing / Officer / Grant
surface; Quiet feeds, toasts, pips, or sound; HUD appears without a
sanctioned pair; rituals fire for an unlisted character; `InspectProgress`
writes Gora rows or leaves Runtime out of QUIET; calendar / RSVP;
Prophet / Grant / standing chrome; script errors; combat taint.

A pass here is **not** a Gathering, **not** dress rehearsal, and **not**
MVP done.

---

## Leftovers (named, not fixed in this script)

1. **Pope list ships Thedave.** Rituals accept on that character. Other
   characters refuse unless listed in `ChurchOfBeefDB.ui.popeOverrides`.
   Do not invent more names.
2. **Console Post Decree** — on the desks; refuses unless listed. `/run`
   remains the unlisted Set path. Not a Gathering Post.
3. **Fight HUD** — needs a real sanctioned pair. No fake Store rows.
   Live health is Appendix A item 1 / OPEN_QUESTIONS #2.
4. **Favor, SUMMON, INPUT / Confession** — uncoded. Out of scope.
5. **Sound callers** — Console plays the five Event cues after successful
   ritual verbs. Quiet stays silent. `InspectProgress` still plays one
   `sanction` inside StartEvent/EndEvent.
6. **Two-client star / dress rehearsal / §22.3 Gathering** — later files.
7. **Scoped out:** CurseForge upload, `POLISH:PASS`, V1 complete.

---

## After the walk (when a human actually walks it)

- File bugs for script errors, Quiet leaks, a Ladder / Grant / Prophet
  surface, HUD without a sanctioned pair, or rituals that fire without a
  listed Pope.
- Do not resolve leftovers by inventing a Pope name, fake Gora rows, a
  calendar, or a favor UI.
- Do not claim V1 / MVP complete. Do not claim `POLISH:PASS`.
- Do not tick this file from a harness or a paper read.
