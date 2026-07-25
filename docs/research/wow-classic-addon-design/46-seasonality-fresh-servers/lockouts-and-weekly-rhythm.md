# Lockouts & weekly rhythm

## Mechanic (Classic / TBC)

TBC raids (Karazhan through Sunwell) use **strict instance-based lockouts**: once saved to a Raid ID, you cannot enter a different ID of that raid until the lockout expires. Boss progress is on the instance; if the raid finishes without you, the ID is empty for you too ([Raid lockout — Wowpedia](https://wowpedia.fandom.com/wiki/Raid_lockout)).

Calendar resets (post–patch 1.9 design): fixed weekly schedule, not “N days after first save.” Community docs list most TBC raids as **Tuesday ~11:59** (region/server specifics vary; **EU commonly Wednesday**) ([Raid lockout](https://wowpedia.fandom.com/wiki/Raid_lockout)). Heroic dungeons reset **daily**.

Players inspect saves with `/raidinfo`. Addon API surface (for later optional use): `GetNumSavedInstances` / `GetSavedInstanceInfo(index)` — returns name, lockout id, reset countdown, raid flag, encounter progress, etc. ([warcraft.wiki.gg API_GetSavedInstanceInfo](https://warcraft.wiki.gg/wiki/API_GetSavedInstanceInfo)).

## What lockouts mean for Beef scoring

| Temptation | Why to resist in V1 |
|------------|---------------------|
| “Grant big points only on first lockout of the week” | Duplicates raid attendance addons; fights co-play drip design; fails when guild splits IDs |
| “Zero points if already locked” | Punishes late joiners helping alts / scrap clears; anti-spectacle |
| “Auto season reset every Tuesday” | Spec forbids automatic decay; weekly wipe is worse than phase Lent |
| “Read lockouts to verify suggestions” | Self-reported standing is already advisory; officers are anti-cheat ([spec §6.3](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) |

**Keep:** daily instance caps + combat-active buckets + completion bonus ([spec §7.2](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)). Those already respect “you cannot infinitely farm the same heroic tonight” without parsing Raid IDs.

## Weekly rhythm Beef *should* acknowledge (product / ceremony)

1. **Raid week** — natural unit for “who showed up for the flock,” stream arcs, Gora after-raid theater.
2. **Maintenance gap** — Tuesday/Wednesday downtime is a dead zone for BeefNet sync; login `SYNC_REQUEST` after restart already covers stale caches (track 14/27).
3. **Split IDs / pug saves** — social drama (locked to wrong ID) is officer lore, not a scoring bug. Addon should not try to “fix” Blizzard lockouts.
4. **Alts** — each character has its own saves and its own Fresh Beef standing; weekly lockouts reinforce why per-character doctrine feels fair.

## Optional post-V1 uses of saved-instance APIs

Safe, non-authoritative ideas only:

- Officer debug: “are we all on the same Kara ID?” display
- Ceremony flavor: toast when the guild’s first weekly lock of a tier is taken
- Standing breakdown hint: “raid week active” chrome — never a hard gate

Instance *completion* reliability remains track [15](../15-instance-completion-events/); lockouts are orthogonal.

## Reset layers cheat sheet

| Clock | Blizzard | Beef standing | Beef season label |
|-------|----------|---------------|-------------------|
| Daily | Heroic reset | Daily caps tick | Unchanged |
| Weekly | Raid ID reset | Unchanged | Unchanged |
| Phase (months) | New tier / patch | Unchanged (V1) | Advance label; optional Lent |
| Fresh launch | Empty realm | Empty ladder | Season 0 / founding |
