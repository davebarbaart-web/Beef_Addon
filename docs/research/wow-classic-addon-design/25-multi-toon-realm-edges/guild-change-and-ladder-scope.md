# Guild changes and ladder scope

**Track:** 25 · **Last updated:** 2026-07-25  
**Note:** This is about *membership identity* and *which ladder you are in*. Roster refresh timing / Officer+ index checks belong in track 16 — cite events lightly only where membership identity needs them.

## 1. Spec behaviors already locked

| Situation | Spec §11 behavior |
|-----------|-------------------|
| Not in a guild | Empty-state ladder; scoring paused |
| Player leaves the guild | Record retained but **hidden** from ladder; restored if they return |
| Cross-realm church | None — each guild runs its own ladder (§5 / §15) |

BeefNet channel is `GUILD` ([design spec §8](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)). Leaving the guild immediately ends live commits/sync for that character; cached SV remains on disk.

## 2. Membership detection (identity, not officer gate)

`GetGuildInfo("player")` can return **nil at load even when the player is guilded**; wiki guidance is to wait until guild info is available on `PLAYER_GUILD_UPDATE` / `GUILD_ROSTER_UPDATE` before firing guild logic ([GetGuildInfo](https://warcraft.wiki.gg/wiki/API_GetGuildInfo)).

For this track, the identity consequences are:

1. **Do not key a “current church” snapshot until `guildName` is known.**
2. **`PLAYER_GUILD_UPDATE` is the membership edge** (join / leave / rank change). Treat leave → hide ladder occupants for *this* guild’s records; treat join → show that guild’s scoped cache (or empty + sync).
3. Deep roster races for officer validation stay in track 16.

## 3. The missing scope key: guild name (+ realm)

Official ladder state in V1 is “officer-committed records replicated in per-character SV.” If those records are a flat map of `playerKey → rank/standing/revision` with **no guild id**:

| Edge | Failure |
|------|---------|
| Gquit Church of Beef, join “Random PUG Guild” | SV still holds Church ladder; UI may show wrong institution until a peer syncs empty/other state — or never, if new guild has no BeefNet |
| Rejoin Church later | Spec wants restore — works only if records were retained *and* still attributed to Church |
| Two churches same account (Dreamscythe / Doomhowl) | Separate SV files per char/realm already isolate *characters*, but a **single** character cannot be in both; the danger is officer tooling that assumes one global ladder table if account SV is added later |

**Research recommendation:** Scope official cache as:

```text
ChurchOfBeefDB.guilds[<GuildName>@<NormalizedRealm>].players[<PlayerKey>] = record
```

(or equivalent). On leave: mark inactive / hide. On join: select that guild’s bucket. Never display another guild’s bucket.

Guild name alone can collide across realms in theory; include realm. Guild rename (rare / GM) is an officer migrate event — same family as character rename.

## 4. Dual-realm Church of Beef (product topology)

| Church instance | Realm | Faction | BeefNet mesh |
|-----------------|-------|---------|--------------|
| Alliance flock | Dreamscythe | Alliance | Guild A only |
| Horde flock | Doomhowl | Horde | Guild B only |

Implications:

- Stream “Church of Beef” brand can be shared; **ladder state must not**.
- Officers are not cross-realm officers. An Alliance officer cannot `RANK_COMMIT` a Horde main.
- Lore/UI copy may say “the Church”; machine state must say which guild@realm.
- Hardcore / Era / Anniversary installs are additional isolation axes (separate WTF), already covered in persistence research — do not merge those either.

## 5. Join / leave / kick edges for points vs official rank

| Layer | On leave | On return | On join different guild |
|-------|----------|-----------|-------------------------|
| Local standing / event log (self-reported) | Keep in per-char SV or freeze | Resume; still advisory | Still on disk — should not fuel suggestions for new guild without reset or guild-scope |
| Official rank (officer commits) | Hide | Show again if same guild@realm bucket | Do not import previous guild’s rank into new guild |
| Pending suggestions | Irrelevant outside guild | May be stale | Drop or ignore for wrong guild |
| Scoring | Paused when not in guild (§11) | Resume | Resume only for new guild’s rules |

**Suggestion fuel hygiene:** if local standing is not guild-scoped, a grind on Church A then gquit/join Church B could create an instant suggestion in B. Prefer guild-scoping local standing too, or reset local standing on guild change (officer-facing choice; recommend **reset or partition**).

## 6. “Restored if they return” — precise reading

Spec intends social continuity for members who leave and come back to the **same** church guild. It should not mean:

- restore after rename without migrate
- restore after realm transfer to a different church instance
- restore into a differently named guild that happens to use the addon

Officer judgment remains the anti-cheat ([§6.3](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)); a returning member with implausible retained standing is comedy content, not a protocol bug.
