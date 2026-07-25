# Track 25 — Multi-character, multi-realm, guild transfer edges

**Track id:** `25-multi-toon-realm-edges`  
**Last updated:** 2026-07-25  
**Sole focus:** Identity edges that break or fork Church of Beef ladder/standing state: alts, same-account scope, realm strings in keys, guild membership changes, renames, and realm transfers.  
**Out of scope:** Guild roster timing, Officer+ rank-index gates, offline-show flags (track [16](../16-guild-roster-officer-edges/)). BeefNet throttle/payload budgets (track [14](../14-addon-messaging-beefnet/)). No addon implementation in this folder.

## Product truth (from V1 spec)

| Locked stance | Value |
|---------------|-------|
| Persistence | `SavedVariablesPerCharacter: ChurchOfBeefDB` |
| Alts | Separate characters; Fresh Beef + zero standing (on-brand) |
| Cross-realm church state | **None** — Dreamscythe Alliance and Doomhowl Horde each run an independent ladder |
| Leave guild | Record retained but hidden; restored if they return (§11) |
| Open question §16.1 | Account-level alt linking — doctrine, not a V1 feature |

Source: [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §5, §9, §11, §15–§16.

## Index

| Note | Covers |
|------|--------|
| [identity-keys-and-realms.md](identity-keys-and-realms.md) | Name vs GUID vs `Name-Realm`; display vs normalized realm; AceDB key shapes |
| [alts-and-account-scope.md](alts-and-account-scope.md) | Per-char SV, account SV, AceDB namespaces, “same human” limits |
| [guild-change-and-ladder-scope.md](guild-change-and-ladder-scope.md) | Join/leave/switch guild; guild-scoped ladder cache; dual-realm church |
| [rename-transfer-fallout.md](rename-transfer-fallout.md) | Rename/transfer WTF paths; ladder orphans; points recovery |
| [beef-implications.md](beef-implications.md) | Concrete V1/V2 recommendations for Church of Beef |
| [annotated-urls.md](annotated-urls.md) | Primary URLs with steal/adapt notes |

## Top insights for Beef (read this first)

1. **V1 identity is a character string, not a Battle.net account.** Per-character SV + officer commits keyed by player name means every alt is a new flock member. That matches doctrine; do not invent silent account merge.

2. **Realm string format is a fork bomb.** AceDB uses `"Name - RealmWithSpaces"`; roster/`UnitName` often use `Name-NormalizedRealm`; `Ambiguate` strips realm for same-realm guild UI. Pick one canonical ladder key and normalize every ingress (commit target, sender, roster name).

3. **Dreamscythe ≠ Doomhowl is already product law.** No shared ladder, no shared BeefNet, no shared SV. Dual-faction “Church of Beef” is two churches with the same brand.

4. **Guild switch without guild-scoped cache = contaminated ladder.** Spec keeps leave/return records; it does not yet say “key official records by guild name + realm.” Without that, a player who gquits Church A and joins Guild B can still show A’s ladder from SV until sync overwrites — or worse, merge ghosts.

5. **Rename/transfer breaks name-keyed state harder than GUID-keyed state.** Per-char WTF folders are under `<realm>/<charName>`; rename orphans the folder. Ladder rows keyed by old name become ghosts. Roster exposes `guid` — useful for a later migrate tool; V1 can stay name-keyed if officers have a manual “recognize rename” path.

6. **There is no automatic “same account” link for guildmates’ alts.** Account SV only shares data among *your* characters on *this* client install tree. Officers cannot see that Beefina and BeefinaAlt are the same player without social knowledge or an explicit officer mapping feature.

## Provenance

Search/extract dumps under [`.raw/`](.raw/). Prefer Warcraft Wiki / WowAce / Blizzard forum guides over listicles for technical claims.
