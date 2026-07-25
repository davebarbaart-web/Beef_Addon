# Track 21 — SavedVariables, profile migration, backup, corruption recovery

**Track id:** `21-savedvariables-migration`  
**Last updated:** 2026-07-25  
**Sole focus:** How Classic clients persist addon state — Account vs Character SV, schema versioning, migration, backup/export, corruption recovery, and wipe-safe design for guild sync caches.  
**Out of scope:** AceDB API surface and options UX (track [03](../03-ace-libs-options/), superseded sketch [05-persistence](../05-persistence-and-profiles.md)); BeefNet protocol, CTL, message budgets (track [14](../14-addon-messaging-beefnet/)). This track only covers **disk persistence implications** of those systems. No addon implementation lives here.

## Product truth (from V1 spec)

| Locked default | Value |
|----------------|-------|
| Global name | `ChurchOfBeefDB` |
| TOC scope | `## SavedVariablesPerCharacter` (not account-wide) |
| Stores | UI prefs + frame position; cached ladder (official records + revisions); pending suggestions; local standing / event log |
| Authority story | SV is a **cache** of officer-committed records; no server; BeefNet reconciles via revisions |
| Alt doctrine | Per-character; alts start Fresh Beef (account merge = open question §16) |

Source: [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §6.3, §8.3, §9, §11, §15–§16.

## Index

| Note | Covers |
|------|--------|
| [account-vs-character.md](account-vs-character.md) | TOC directives, WTF paths, load/write timing, what may be stored |
| [schema-versioning-migration.md](schema-versioning-migration.md) | Schema stamps, stepwise migrations, defaults merge, profile vs church-data split |
| [backup-export.md](backup-export.md) | WTF folder backups, `.bak` files, in-game export/import strings |
| [corruption-recovery.md](corruption-recovery.md) | Partial writes, NUL corruption, crash exits, recovery playbooks |
| [wipe-safe-guild-caches.md](wipe-safe-guild-caches.md) | Designing ladder caches so SV wipe ≠ guild history loss |
| [church-of-beef-mapping.md](church-of-beef-mapping.md) | Explicit CoB data-class → persistence / recoverability matrix |
| [annotated-urls.md](annotated-urls.md) | Primary URLs with steal/adapt notes |

## Top insights for Beef (read this first)

1. **Per-character SV is the correct V1 shape — and it is also a recovery liability.** Spec §9 locks `SavedVariablesPerCharacter`. That means each Dreamscythe / Doomhowl character holds its own ladder cache file. A wipe of one character’s SV does not wipe the guild’s history *if* peers still hold higher-revision commits — but it *does* wipe that character’s local standing log and UI prefs unless rebuilt.

2. **SV is a cache, not a server.** Spec §8.3 / §9: official state is the set of revisioned officer commits replicated across clients. Persistence design must assume any single `ChurchOfBeefDB` file can vanish, corrupt, or be edited by hand (spec §6.3). Recovery path for ladder data is login `SYNC_REQUEST`, not “restore my WTF.”

3. **Stamp a schema version from day one; migrate stepwise.** Blizzard provides no built-in schema versioning ([Saving variables…](https://warcraft.wiki.gg/wiki/Saving_variables_between_game_sessions)). Community convention: integer `version` (or `schema`) on the root table; run ordered `if version < N` migrations once at `ADDON_LOADED`. Never replace the whole table with defaults — merge missing keys.

4. **Separate “church data” from “UI prefs” inside the same SV table.** Even without Ace profiles, nest `ui` vs `ladder` / `standing` / `suggestions`. Future account-wide UI profiles (spec §16 alt policy / streamer presets) must never relocate officer-authoritative ladder state into a swappable cosmetic profile.

5. **Client `.bak` is not a trustworthy backup.** WeakAuras / WoWUIBugs reports document partial writes (empty or NUL-padded `.lua`) and a failure mode where a subsequent logout **overwrites** the good `.bak` with the broken file ([WoWUIBugs #241](https://github.com/Stanzilla/WoWUIBugs/issues/241)). Guild installers should keep dated copies of the whole client `WTF` tree (and optionally in-game export of UI prefs only).

6. **Wipe-safe = reconstructible from peers + officers.** Design every guild-shared field so that after `ChurchOfBeefDB = nil`, a clean login + BeefNet sync restores official ranks. Keep irreplaceable local-only data (event log for “My Standing”) small and clearly labeled as non-authoritative / lossy-on-wipe.

7. **Anniversary install trees do not share WTF.** `_classic_`, `_classic_era_`, Anniversary / TBC trees are separate under the game install ([WTF backup guides](https://xscarlife-gaming.com/wtf-folder/); Blizzard forum path notes). Document for guild installers: copying Era SV into Anniversary is undefined and usually wrong.

## Provenance

Search/extract dumps under [`.raw/`](.raw/). Prefer Warcraft Wiki / WowAce / WoWUIBugs / ElvUI wiki over listicles for technical claims. Do not treat this track as a substitute for [14 BeefNet](../14-addon-messaging-beefnet/) sync design.
