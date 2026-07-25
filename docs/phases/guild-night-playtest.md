# Guild-night playtest checklist (post-research)

**Purpose:** Close the remaining *live* knowledge gaps. Desk research through track **74** is done (gap audit [56](../research/wow-classic-addon-design/56-coverage-gap-audit/) post–Wave E); these items need the Anniversary client.

**Canon ops depth:** `docs/research/wow-classic-addon-design/51-guild-night-playbook/`  
**Implementer locks:** `docs/research/wow-classic-addon-design/74-v1-decision-glossary/`  
**Install/reload loop:** `.cursor/skills/church-of-beef-dev/SKILL.md`

## Preconditions

- [ ] Addon loads on Anniversary (`Interface` matches `GetBuildInfo()` / TOC `20506`)
- [ ] `/beef` opens in and out of combat
- [ ] At least **two** clients: one Officer+, one member
- [ ] BugGrabber + BugSack + `/console scriptErrors 1` on both
- [ ] Facilitators: Night Lead, Score Desk, Spectacle Watcher (see track 51)

## Night goals

1. **Pacing (§4.2 / track 64)** — Does a newbie’s first guild dungeon night reach Cooked eligibility without hitting Knight?
2. **Spectacle (§13.11 / track 72)** — One officer guild-chat promote line → unprompted guild reaction?
3. **Sync (tracks 14 / 47 / 68)** — Offline member catches up via `SYNC_*` without chat storms?
4. **Co-play (tracks 15 / 59)** — Instance drip pays with guildmate + combat; city/open-world pays 0?

## Capture (Score Desk)

| Metric | How | Target / note |
|--------|-----|----------------|
| Newbie standing Δ | My Standing before/after night | ~Cooked (50), not Knight (200) |
| Source mix | Instance / Ceremony / Gora | Instance should dominate first night |
| Suggestion→approve latency | Officer tab timestamps | Human-scale; note backlog |
| Announce reaction | Spectacle Watcher checkbox | Pass/fail for V1 social check |
| BeefNet errors | BugSack + `/beef debug` summary | No soft-locks for no-addon peers |
| Caps hit? | Daily instance/ceremony/gora | Tune if everyone maxes early |

## Do not expand research unless

- A playtest finds a **contradiction** with a locked decision in track 74 / spec §15
- Then update the **spec decisions log** first, then the glossary — do not fork policy into random research notes

## After the night

- [ ] Retune Cooked threshold / weights in `Data/Ranks.lua` (not docs/canon)
- [ ] File bugs for sync/UI only; leave liturgy copy tweaks for a second pass
- [ ] Separate nights for Dreamscythe vs Doomhowl (independent ladders)
