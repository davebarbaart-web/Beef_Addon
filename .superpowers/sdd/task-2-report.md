# Task 2 report — Honesty docs and install

Date: 2026-09-14. Plan: `docs/reformation/ux-rebuild/plans/2026-09-13-player-card-gathering.md` Task 2. Brief: `.superpowers/sdd/task-2-brief.md`.

Docs-only plus Anniversary rsync. No addon Lua edits. No commit. No `git add`. No zip-upload. **POLISH:CANDIDATE** only — not POLISH:PASS, not V1/MVP.

## What you implemented

Honesty files now match Task 1 (`UI/PlayerCard.lua`): identity + Gathering plate; empty story collapses; height 380 / 540; thin charcoal close band; **CHURCH RECORDS** remains the one door.

**Honesty values used verbatim** (from the brief):

- 320 wide
- height 380 with no story, 540 with a story
- Gathering plate under rank (live Decree line or muted `No gathering is posted.`)
- story rubrics `BEEF GORA` / `BEEF RIVALS` / `BEEF LEGACY` only when they have rows
- thin empty charcoal close band
- **CHURCH RECORDS** still the one door
- guild-title display sentence stays
- no feed / no position

## Files changed

### `docs/phases/solo-smoke.md`

- Honesty table `/beef` row: dropped fixed `320×540` and footer Decree / always-on ledgers / empty-ledger copy (`No sanctioned bouts.` / `No rivalries yet.` / `None yet.`). Now 320 wide; 380 empty / 540 with story; Gathering plate; collapse; thin empty charcoal close band; **CHURCH RECORDS**; no feed / no position.
- Guild-title sentence kept: gold plate shows the live guild rank when the store has no human row (canon titles get the §5 relationship line; any other name, including Guild Master, is labeled "Guild rank."). `GetGuildInfo` / `GUILD_ROSTER_UPDATE` sentence kept.
- §3 walk box that still named **SANCTIONED GORA** / **RIVALRIES** / **DISTINCTIONS** and the Decree footer was aligned so a human walker is not looking for the old card. Same file; same `/beef` honesty.

### `docs/phases/v1-checklist.md`

- Honesty bullet 1 and §3 "Today this frame is the player card" still described footer-era peers (record / rivalries / distinctions / the Decree). Rewritten to Gathering plate, collapse, new rubrics, 380 / 540, thin empty charcoal close band.
- Guild-title sentence kept: a live guild rank name fills the gold plate when the store has no human row (canon titles get the §5 relationship line).
- Component 7 "Today" left as-is (identity / rank / record / rivalries / distinctions — no footer Decree, no old rubric names).

### `docs/REFORMATION_LOG.md`

Appended short **Gathering headline (2026-09-13)** after the guild-titles note. **POLISH:CANDIDATE**. Historical "Player card (2026-09-13)" entry left in place.

Not touched: addon Lua, TOC, `WTF/`, other phase files, `progress.md`.

## Tests

Docs-only; ran to confirm Task 1 still green.

```
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/run.lua
```

```
Tests finished: 15987 passed, 0 failed
```

Exit 0.

## Install

```
WOW_ADDONS_DIR=/Applications/World of Warcraft/_anniversary_/Interface/AddOns
rsync -a --delete /Volumes/AI_Design_Drive/Beef_Addon/addon/ChurchOfBeef/ \
  "$WOW_ADDONS_DIR/ChurchOfBeef/"
```

Confirmed:

- Dest: `/Applications/World of Warcraft/_anniversary_/Interface/AddOns/ChurchOfBeef`
- Path is AddOns, not `WTF/`
- Installed `ChurchOfBeef.toc` is `## Interface: 20506`
- Installed `UI/PlayerCard.lua` contains both required tokens:

```
22:local CARD_H_EMPTY, CARD_H_STORY = 380, 540
37:  gathering = "GATHERING",
522:  frame:SetHeight(CARD_H_EMPTY)
745:    frame:SetHeight(CARD_H_EMPTY)
```

## Self-review

- No addon Lua. No Core→UI. No product answers invented.
- Quiet / Law 6: docs still name minimap + Decree as unbidden chrome; `/beef` stays player-opened identity + Gathering, not a feed.
- §10.9: "no position" kept on the `/beef` row and the log note.
- Interface stays `20506`.
- No commit. No `git add`.

## Concerns

- In-game `/reload` + `/beef` smoke is not this task. Task 1 already noted the 380 floor is unmeasured in the client.
- `v1-checklist.md` component 7 "Today" still says "record, rivalries, distinctions" without the new rubric names. Left per brief (update only if it still said footer Decree / old rubrics).
- Historical Reformation Log "Player card (2026-09-13)" paragraph still describes the first rebuild (footer Decree, 320×540). The new Gathering-headline note is the current honesty.
