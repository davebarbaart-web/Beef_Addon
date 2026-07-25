# Church of Beef implications (multi-toon / realm / transfer)

**Track:** 25 · **Last updated:** 2026-07-25  
**Maps to:** design spec §5, §6.2–§6.3, §8–§9, §11, §15–§16

## 1. Keep (already correct)

| Spec choice | Why it survives these edges |
|-------------|------------------------------|
| Per-character SV | Alts prove themselves; matches progress culture |
| No cross-realm ladder | Dreamscythe / Doomhowl isolation matches GUILD BeefNet |
| Leave → hide, return → restore | Right social default **if** records are guild-scoped |
| Officer commit as truth | Rename/transfer recovery can be human theater, not crypto |
| Sender name trust for commits | Aligns with server-authored addon message identity |

## 2. Close before implementation bites

| Gap | Risk | Recommended V1 stance |
|-----|------|------------------------|
| No canonical player key | Duplicate ladder rows (`Name` vs `Name-Realm` vs `Name - Realm`) | One normalizer; store `Name-NormalizedRealm` |
| Official cache not guild-scoped | Wrong-church ladder after gquit/rejoin | Nest records under `guildName@realm` |
| Local standing not guild-scoped | Instant suggestion after joining new guild | Partition or reset standing on guild change |
| Rename has no officer path | Ghost titles + Fresh Beef twin | Document officer tombstone + re-commit (runbook in [rename-transfer-fallout.md](rename-transfer-fallout.md)) |
| Alt policy undecided (§16.1) | Feature creep via account SV | Ship doctrine A; no silent merge |

## 3. Dual-church operational rules

1. **Never** merge Alliance Dreamscythe and Horde Doomhowl state in UI, sync, or docs examples.
2. Brand copy may say “Church of Beef”; machine strings should include realm/guild when debugging.
3. Streamers with both factions = two independent ladders; celebrate both, do not sum standing.
4. Anniversary vs other Classic flavors = third isolation axis (install/WTF tree) — say so in guild install README.

## 4. V1 vs later

| Item | V1 | Later |
|------|----|-------|
| Player key normalizer | Yes | — |
| Guild-scoped official cache | Yes (small schema choice) | — |
| GUID stored alongside name | Optional field if cheap | Migrate/rename tool |
| Officer “link alt → main” | No | Only if leadership picks §16.1 option B |
| Account SV for UI prefs | No (keep simple) | Split Church data vs UI profile |
| Automatic WTF rename repair | Impossible in-addon | External player guide only |
| Cross-realm church | Never (product law) | Never |

## 5. Interactions with other tracks (pointers only)

- **Track 14 (BeefNet):** fully-qualified keys lengthen payloads; keep commits small; do not add GUID to every packet unless migrate requires it.
- **Track 16 (roster/officer):** membership wait on `PLAYER_GUILD_UPDATE` overlaps; officer index remap after reorg is their lane — this track only needs guild **name** for scope.
- **Persistence root doc:** account vs per-char vocabulary; this track adds guild/realm/rename edges on top.

## 6. Decision log candidates (for spec maintainers)

If research is accepted into the design spec later (not done by this track):

1. Canonical player key = `Name-NormalizedRealm`.
2. Official + local standing partitioned by `GuildName@NormalizedRealm`.
3. Rename recovery = officer manual re-commit; no auto GUID merge in V1.
4. §16.1 remains open; default doctrine unchanged.
