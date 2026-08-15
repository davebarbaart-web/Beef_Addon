# Church of Beef

A social ceremony, Gora, and memory layer for **World of Warcraft: Burning Crusade Classic Anniversary**.

The add-on is **not another game inside World of Warcraft**. It makes the things players already do — a duel, a promotion, a Gathering — feel like they happened inside the Church of Beef: sanctioned Beef Goras, Knighting, the Beef Pope as performer, and a persistent Church memory. The software is the stage manager. Humans generate the show.

It is **not** a raid-optimization or combat-assistance tool.

## Ranks

Ranks are kinds of relationship with the Church, not a points ladder. There are no thresholds. **The Beef Pope is not a rank.**

| Title | Relationship |
|-------|----------------|
| Fresh Beef | Recruitment — newly invited; low-commitment entry |
| Cooked Beef | Engagement — first voluntary step into the wider community |
| Beef Knight | Belonging — *I belong here.* |
| Beef Lord | Proven prestige — *I proved something here.* |
| Beef Butcher | Raiding Team role designation — *I raid for the Church.* Display-only in this phase |
| Beef Council | Trusted leadership — always a human judgment, never a score |

## Bans

No points, XP, currencies, dailies, streaks, or engagement scoring. No activity leaderboards. No ELO/MMR. A Beef Gora is an unmodified duel in the world.

Church history is never deleted. Identity is account-level: **rank belongs to the human; Gora records belong to the character.**

## Quiet Mode

Outside events the add-on is at most a **minimap presence** and the active **Decree**. The Decree is forthcoming; it does not ship today. No feeds, toasts, pips, or ambient surfaces in Quiet Mode.

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

## Usage

- `/beef` — toggle the main frame. The minimap button toggles the same frame.
- `/beef minimap` — show or hide the minimap button (the existing restore path if the button is hidden). Unrecognized arguments open the frame.

## Hard safety rules

These are firm project rules for every version:

- **No automation of gameplay.** No bots, no automated movement, targeting, spellcasting, or combat
  decision-making.
- **No injection** and no external process controlling the game.
- **No protected-action circumvention.**
- **Lua and XML only**, fully in-game.
- **TBC Classic Anniversary first** (`## Interface: 20506`). No Retail-only or Dragonflight-era APIs.
  Classic+ is a future port, not current scope.

The add-on may announce, record, display, and coordinate allowed information.
It must never play the game for anyone.

## Repository layout

```
addon/ChurchOfBeef/              Installable addon (Data/, Core/, Net/, UI/)
docs/design/                     Product law (Bible, Adjudication, Audit)
docs/archive/pre-reformation/    Retired law — historical only; do not follow
docs/reformation/                Reformation process
tests/                           Offline Lua harness for pure Core logic
```

Rank structure is Bible §5. Machine ids belong in `addon/ChurchOfBeef/Data/Ranks.lua` after Phase 1 — do not invent Beef Prophet or thresholds.

## Tests

Pure-logic Core modules are tested offline under desktop Lua (5.1 preferred; 5.4 works):

```bash
brew install lua@5.1 || brew install lua
lua tests/run.lua
```

Run from the repository root. A green harness proves nothing about the client.

## Definition of done

The current checkout is **not** the finished product. The demo is not done.

From Bible §22.3:

> The MVP is done when the Church runs one complete, real Gathering — assembly under a Decree, several Knightings, several sanctioned Beef Goras with fight HUD and favor — live on stream, with records persisting afterward and visible the next morning, with a first-time Twitch viewer able to understand the spectacle, and with David never opening Blizzard's guild roster and never touching an external spreadsheet during the performance.

Offline tests and `/reload` smoke cannot prove that.

## Design law

| Document | Role |
|----------|------|
| [`docs/design/Game_Design_Bible_v1.1.1.md`](docs/design/Game_Design_Bible_v1.1.1.md) | Sole product law |
| [`docs/design/Peer_Review_Adjudication.md`](docs/design/Peer_Review_Adjudication.md) | What the peer review accepted, deferred, or rejected |
| [`docs/design/Demo_Build_Audit.md`](docs/design/Demo_Build_Audit.md) | Why the prior demo was the wrong product |
| [`docs/archive/pre-reformation/`](docs/archive/pre-reformation/) | Archived law — historical only |

## For AI agents

Short orientation map: `AGENTS.md` at the Beef_Addon workspace root. Persistent rules: `.cursor/rules/` on that same root; install/test loop: `.cursor/skills/church-of-beef-dev/`.
