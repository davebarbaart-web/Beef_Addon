# Welcome parchment copy — 2026-09-14

**Status:** Draft strings for Wave 2 Task 4 (`UI/Welcome.lua`). Copy only. Do not implement `Welcome.lua` from this file.

**Owns:** 100-point items **9–10**. Bible **§19.5** (one parchment, first launch, then silence). Newcomer test: 100-point plan §2.

**Not this brief:** `/beef help` (item 12), unrecorded card line (item 15), Inputs refuse reasons (item 24 / 112), version-mismatch notice (§13.4).

---

## What the sheet is

One Quiet parchment. First launch only (`ChurchOfBeefDB.ui.welcomeSeen`). Then never again. Not the Decree. Not a toast. Not a feed. No sound. One Close. No settings. No Next tip.

Audience: a zip-install recruit who has never read the Bible. The sheet orients, then gets out of the way. The first real encounter with the addon should be a ceremony, not this surface (§19.5, §21.2).

---

## Hard constraints (Wave 2)

Must land, in this order:

1. This is meetup night + sanctioned duels (not raid tools).
2. Tuesday is almost nothing: the bull, and a notice when one is posted.
3. Left-click the bull, or `/beef`, opens your name.
4. When the gathering starts: **Ask to fight**.
5. A later, separate beat: when two names appear on the fight bar, pick a side. Favor plates exist only then. Do **not** say “click a name” in the same breath as Ask to fight — they will click guild roster names during ASSEMBLY.
6. You do not run the show.

Must not appear on the sheet:

- “Director Console”
- `/beef console` (congregation must not be advertised a desk)
- Jokes, puns, grill/meat gags (Law 10 — the UI never tells jokes)
- The Pope’s voice, oratory, “The Pope welcomes you,” first-person Church speech (Law 4 — software never narrates)
- Fake ranks, `NEW`, “Gora” as a verb they should perform (English first: sanctioned duels)
- Tutorial OS, Discord, settings, “click anyone,” stacking/Decree instructions

Close label: `CLOSE` (same as the player card).

---

## Layout rule — not copy

If a Decree is already showing, or Runtime ≠ QUIET, **do not stack** a second parchment. Skip welcome, or wait until the Decree is closed. One surface. The Decree *is* the sheet in that moment.

Do **not** put this rule on the parchment. Recruits do not need a sentence about overlapping banners.

Implementer pins (Wave 2 Task 4, not this draft): `MODE = "QUIET"`; no sound; `welcomeSeen` fills `false` and is set **on Close only**; `pcall` Welcome Init; `SCHEMA_VERSION` stays 7. Theatrical parchment via Theme (Law 10).

---

## Sequence (why the line break exists)

Wave 1 locked “Ask to fight, then click a name to pick a side.” That fails: during ASSEMBLY the only Event chrome is the Inputs strip. Favor plates appear only when two names are on the fight bar.

So Ask to fight is its own paragraph. The fight-bar beat is the next paragraph. Same sheet, not the same breath.

`/beef help` (item 12) should stay the short echo: bull / `/beef` = your name; night = Ask to fight, then pick a side when two names appear. Do not let help collapse those back into one clause.

---

## Variant A — plain (recommended)

**Title**

```
CHURCH OF BEEF
```

**Body**

```
Meetup nights and sanctioned duels.

Most days: the bull on the minimap, and a notice if one is posted. That is Tuesday.

Left-click the bull, or type /beef, to open your name.

When the gathering starts, Ask to fight.

When two names appear on the fight bar, click a name to pick a side.

You do not run the show.
```

**Close**

```
CLOSE
```

---

## Variant B — slightly ecclesiastical

**Title**

```
CHURCH OF BEEF
```

**Body**

```
The guild’s meetup nights, and the duels the Church sanctions.

On ordinary days the bull remains, and a notice when one is posted. Tuesday needs nothing more.

Left-click the bull, or type /beef, to open your name.

When the gathering starts: Ask to fight.

When two names stand on the fight bar, pick a side.

You do not run the show.
```

**Close**

```
CLOSE
```

Tone check: clerical, not character. No “Behold,” no “faithful,” no Pope mouth. Still Law 10 / Law 4.

---

## Recommendation

**Ship Variant A.**

The newcomer test is a randomly invited stranger, not a reader of the Bible. §19.5 is near-invisible; plain copy is shorter and quieter. Variant B’s “the duels the Church sanctions” and “Tuesday needs nothing more” edge toward narration (Law 4) without teaching a new fact. Item 12’s help line is already plain — the parchment and the slash should sound like the same addon.

If David wants more parchment dignity later, swap the body strings. Do not add a second sheet, a Next tip, or `/beef console`.

---

## Ready-to-paste table (Variant A)

For `Welcome.lua` `COPY` (or equivalent). Do not invent extra keys.

| Key | String |
|-----|--------|
| `title` | `CHURCH OF BEEF` |
| `what` | `Meetup nights and sanctioned duels.` |
| `tuesday` | `Most days: the bull on the minimap, and a notice if one is posted. That is Tuesday.` |
| `name` | `Left-click the bull, or type /beef, to open your name.` |
| `ask` | `When the gathering starts, Ask to fight.` |
| `favor` | `When two names appear on the fight bar, click a name to pick a side.` |
| `role` | `You do not run the show.` |
| `close` | `CLOSE` |

Paint `ask` and `favor` as separate FontStrings (or two paragraphs with a blank line). Do not concatenate them.

---

## Rejected lines (do not revive)

| Line | Why |
|------|-----|
| Ask to fight, then click a name to pick a side. | Wave 2: same breath; they click guild names |
| Open the Director Console / `/beef console` | Congregation is theater, not administration |
| The Pope welcomes you. / Thus the Church… | Law 4 |
| Welcome to the grill. / Don’t be a raw recruit. | Law 10 |
| Tuesday is quiet unless we ping you. | Invents a feed |
| If a notice is already up, ignore this. | Layout rule, not copy |
| Click a name in the guild to ask. | Wrong target; Ask to fight is the strip |
