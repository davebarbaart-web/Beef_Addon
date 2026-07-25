# Church of Beef

A social guild and streamer-event add-on for **World of Warcraft: Burning Crusade Classic Anniversary**.

Church of Beef turns the guild into a living religious-sports-entertainment institution: a seven-title
rank ladder, standing points earned by playing together, officer-approved promotions, and guild-chat
spectacle when someone is elevated (or excommunicated).

It is **not** a raid-optimization or combat-assistance tool.

## The ladder

| Order | Title | How you get there |
|------:|-------|-------------------|
| 1 | Fresh Beef | Default |
| 2 | Cooked Beef | Standing threshold → officer approval |
| 3 | Beef Knight | Standing threshold → officer approval |
| 4 | Beef Lord | Standing threshold → officer approval |
| 5 | Beef Butcher | Standing threshold → officer approval |
| 6 | Beef Council | Appointed; seat-limited |
| 7 | Beef Prophet | Bestowed by decree; unique |

The addon **suggests** promotions from your standing. Characters with a real WoW guild rank of
Officer or higher **approve or reject** them. Standings are self-reported advisory testimony;
officer approval is the real gate.

## Install

Fast path on this Mac (Anniversary default tree):

```bash
./scripts/install-anniversary.sh
```

Or copy by hand:

```
addon/ChurchOfBeef/  →  <TBC Anniversary client>/Interface/AddOns/ChurchOfBeef/
```

Install path must be exactly `Interface/AddOns/ChurchOfBeef` (folder name matches the `.toc`).
Reload (`/reload`) and confirm **Church of Beef** appears in the AddOns list.

Nothing outside that folder is needed at runtime: stock Blizzard UI textures/fonts only — no custom `Media/`.

## Usage

- `/beef` — open the main frame. The minimap button toggles the same frame; it has no
  subcommands, and any arguments are ignored. To hide the minimap icon without unloading the
  addon, run `/run ChurchOfBeef.Minimap:SetShown(false)` — the choice persists.
- Tabs: **Ladder** (all seven ranks), **My Standing** (your own points and recent testimony), and
  **Officer**, which only appears once the client knows you are Officer or higher
- The Officer tab carries the guild-chat announce opt-out. It is on by default, and turning it
  off silences this client's announcements without changing the promotion itself.
- Data is stored per character in `ChurchOfBeefDB` (SavedVariablesPerCharacter). Alts start fresh.

## Hard safety rules

These are firm project rules for every version:

- **No automation of gameplay.** No bots, no automated movement, targeting, spellcasting, or combat
  decision-making.
- **No injection** and no external process controlling the game.
- **No protected-action circumvention.**
- **Lua and XML only**, fully in-game.
- **TBC Classic Anniversary first** (`## Interface: 20506`). No Retail-only or Dragonflight-era APIs.
  Classic+ is a future port, not V1 scope.

The addon may announce, track, record, display, coordinate, and sync allowed information.
It must never play the game for anyone.

## Repository layout

```
addon/ChurchOfBeef/   Installable addon (Data/ canon, Core/, Net/, UI/)
docs/canon/           Prose lore only — never duplicates the numbers
docs/phases/          Roadmap and V1 verification checklist
docs/superpowers/     Design spec and implementation plan
tests/                Offline Lua test harness for pure Core logic
```

Machine-readable canon (rank ids, titles, thresholds, seats) lives only in
`addon/ChurchOfBeef/Data/Ranks.lua` — a WoW TOC can only load files inside the addon folder, so that
is the single source of truth.

## Tests

Pure-logic Core modules are tested offline under desktop Lua (5.1 preferred; 5.4 works):

```bash
brew install lua@5.1 || brew install lua
lua tests/run.lua
```

Run from the repository root. Test suites appear as tasks land; a missing suite is not a failure.

The harness covers pure logic only — it stubs the WoW API, so a green run proves nothing about
the client.

## In-game verification is still required

BeefNet replication, login sync, the frames, and the guild-chat spectacle cannot be proven
offline. Before calling V1 done:

1. Install (`./scripts/install-anniversary.sh`) → `/reload` → `/beef`
2. Walk [`docs/phases/v1-checklist.md`](docs/phases/v1-checklist.md) with `/console scriptErrors 1`
   (BugGrabber + BugSack preferred)
3. For a real guild night, use [`docs/phases/guild-night-playtest.md`](docs/phases/guild-night-playtest.md)

Network and officer boxes need two characters — one Officer+, one member. The social criterion
needs an actual guild night: if a promotion passes unnoticed in guild chat, V1 has failed even
with every function working.

## Design spec

Full V1 design: [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](docs/superpowers/specs/2026-07-25-church-of-beef-design.md)

## For AI agents

Short orientation map: `AGENTS.md` at the Beef_Addon workspace root (the directory that contains `.worktrees/`). Persistent rules: `.cursor/rules/` on that same root; install/test loop: `.cursor/skills/church-of-beef-dev/`.
