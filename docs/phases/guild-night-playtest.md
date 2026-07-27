# Guild-night playtest checklist (roster-backed)

**Purpose:** Close remaining *live* knowledge gaps after [`solo-smoke.md`](solo-smoke.md). Desk research is not a substitute for an Anniversary client.

**Canon ops depth:** `docs/research/wow-classic-addon-design/51-guild-night-playbook/`  
**Product law:** roster-backed amendment + parent design spec §15 Accept note  
**Install/reload loop:** `.cursor/skills/church-of-beef-dev/SKILL.md`

## Preconditions

- [ ] [`solo-smoke.md`](solo-smoke.md) passed on at least one Officer+/GM character
- [ ] Addon loads on Anniversary (`Interface` matches `GetBuildInfo()` / TOC `20506`)
- [ ] `/beef` opens in and out of combat
- [ ] BugGrabber + BugSack + `/console scriptErrors 1`
- [ ] Facilitators: Night Lead, Score Desk (Spectacle Watcher optional — `/g` announce deferred)

**Note:** Two addon clients are useful for suggestion fanout, but **not required** to prove the ladder — ranks mirror the live guild roster for everyone.

## Night goals

1. **Pacing (§4.2 / track 64)** — Does a newbie’s first guild dungeon night reach Cooked eligibility without hitting Knight?
2. **Roster promote (amendment §11)** — Officer sees a suggestion → promotes in Blizzard guild UI → Ladder moves; suggestion clears. No addon Commit.
3. **Suggestion fanout (optional)** — Member crosses threshold on client A; Officer+ on client B sees the queue toast / row when both run the addon.
4. **Co-play (tracks 15 / 59)** — Instance drip pays with guildmate + combat; city/open-world pays 0?

## Capture (Score Desk)

| Metric | How | Target / note |
|--------|-----|----------------|
| Newbie standing Δ | My Standing before/after night | ~Cooked (50), not Knight (200) |
| Source mix | Instance / Ceremony / Gora | Instance should dominate first night |
| Suggestion→guild-promote latency | Officer tab + guild UI | Human-scale; note backlog |
| Ladder honesty | Spectacle Watcher optional | Rank bands match WoW guild ranks after promotes |
| BeefNet errors | BugSack | Soft-ignore legacy commits; no soft-locks for no-addon peers |
| Caps hit? | Daily instance/ceremony/gora | Tune if everyone maxes early |

## Do not expand research unless

- A playtest finds a **contradiction** with a locked decision in the roster amendment / spec §15
- Then update the **spec decisions log** first — do not fork policy into random research notes

## After the night

- [ ] Retune Cooked threshold / weights in `Data/Ranks.lua` (not docs/canon)
- [ ] File bugs for sync/UI only; leave liturgy copy tweaks for a second pass
- [ ] Decide whether missing `/g` spectacle needs a roster-diff announcer (amendment §14)
- [ ] Separate nights for Dreamscythe vs Doomhowl (independent ladders)
