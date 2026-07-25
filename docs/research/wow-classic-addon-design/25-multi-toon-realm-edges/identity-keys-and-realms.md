# Identity keys and realm name forms

**Track:** 25 · **Last updated:** 2026-07-25

## 1. What can identify a “player” in-addon?

| Token | Source | Strengths | Weaknesses for Beef |
|-------|--------|-----------|---------------------|
| Bare name | `UnitName("player")`, chat, many GUILD addon senders on single-realm | Short; matches guild chat announces | Collides across realms; rename breaks; alt with same name on other realm is unrelated |
| `Name-Realm` | Roster `GetGuildRosterInfo` name field often includes realm (e.g. `"Arthas-Silvermoon"`) ([GetGuildRosterInfo](https://warcraft.wiki.gg/wiki/API_GetGuildRosterInfo)) | Disambiguates cross-realm | Format of realm half varies (normalized vs spaced); must normalize before compare |
| AceDB-style `"Name - Realm"` | AceDB builds `charKey = UnitName("player") .. " - " .. GetRealmName()` ([AceDB-3.0.lua](https://github.com/Vicious-wow/XIV_Databar/blob/master/Libs/AceDB-3.0/AceDB-3.0.lua)) | Ecosystem convention for account SV char tables | Spaces around `-`; uses **display** realm (`GetRealmName`), not normalized |
| Player GUID | `UnitGUID("player")` → `Player-<serverId>-<playerId>` ([UnitGUID](https://warcraft.wiki.gg/wiki/API_UnitGUID)); also last return of `GetGuildRosterInfo` | Stable across many rename cases; unique | Longer payloads; not what guild chat shows; not what BeefNet sender string is today (spec trusts **sender name**) |
| Battle.net account | Not exposed as a stable public id for alt-linking guildmates | — | Unavailable for “same human across alts in guild” |

**Spec trust model:** BeefNet validates officer commits by looking up the **server-supplied sender name** in the guild roster ([design spec §6.2](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)). Identity for *authority* is “roster-resolvable name,” not GUID. Identity for *ladder rows* should still be chosen deliberately so rename/transfer do not silently fork history.

## 2. Realm string: display vs normalized

| API / return | Typical shape | Use |
|--------------|---------------|-----|
| `GetRealmName()` | Spaces/punctuation as shown in UI (e.g. `"Earthen Ring"`) | AceDB `realm` / `char` keys; WTF folder naming often follows this family |
| `GetNormalizedRealmName()` | Spaces/hyphens removed (e.g. `"EarthenRing"`) | Paired with `GetRealmName` in wiki docs ([Wowpedia GetRealmName](https://wowpedia.fandom.com/wiki/API_GetRealmName)); safer for compact `Name-Realm` keys |
| `UnitName` / `UnitFullName` realm return | Normalized realm; `nil` for same-realm on `UnitName("player")` unless using `UnitFullName` ([UnitName](https://warcraft.wiki.gg/wiki/API_UnitName)) | Building full names; `UnitFullName("player")` always returns realm |
| `Ambiguate(fullName, context)` | Strips or keeps `-Realm` by context (`guild`, `mail`, `none`, …) ([Ambiguate](https://warcraft.wiki.gg/wiki/API_Ambiguate)) | Display only — **do not** use as storage key without a reverse-canonicalization step |

**Failure mode:** storing AceDB-style `"Beefina - Dreamscythe"` in one place and roster-style `"Beefina-Dreamscythe"` in another produces two ladder occupants for one person.

## 3. Recommended canonical forms (research recommendation)

For Church of Beef ladder / commit / sync records (design recommendation, not yet locked in spec):

1. **Canonical storage key:** `Name-NormalizedRealm` (no spaces around `-`), always fully qualified — even for same-realm members.
2. **Display:** `Ambiguate(canonical, "guild")` or bare name for same-realm UI and guild-chat announces.
3. **Ingress normalization:** every path that accepts a name (RANK_COMMIT target, SUGGESTION subject, roster walk, addon sender) runs through one `NormalizePlayerKey(name)` that:
   - accepts bare, `Name-Realm`, or `Name - Realm`
   - appends local normalized realm if bare
   - collapses spaces around `-`
4. **Optional secondary field:** `guid` when available from roster — for rename migration tooling later; not required for V1 authority if names stay consistent.

## 4. Multi-realm product topology (Church of Beef)

| Realm | Faction | Ladder |
|-------|---------|--------|
| Dreamscythe | Alliance | Independent Church A |
| Doomhowl | Horde | Independent Church B |

There is no cross-realm BeefNet (`GUILD` channel is guild-local). A key that includes realm is still useful **inside** one guild for forward-compat and for any future connected-realm weirdness, but it must never be used to merge the two churches.

## 5. What this track does *not* decide

- Officer+ index thresholds and roster-load races → track 16.
- Payload size of putting GUID on every `RANK_COMMIT` → track 14 budgets if added later.
