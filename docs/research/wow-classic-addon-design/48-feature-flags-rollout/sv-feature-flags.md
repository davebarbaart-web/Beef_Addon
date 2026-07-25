# SavedVariables feature flags

**Track:** [48 README](README.md)  
**Related:** [21 schema-versioning-migration](../21-savedvariables-migration/schema-versioning-migration.md), [21 account-vs-character](../21-savedvariables-migration/account-vs-character.md)

## 1. What “SV flags” mean in Classic

Blizzard persists declared globals as Lua tables under `WTF/…/SavedVariables/` ([Saving variables between game sessions](https://warcraft.wiki.gg/wiki/Saving_variables_between_game_sessions); [SavedVariables](https://warcraft.wiki.gg/wiki/SavedVariables)). Authors invent their own:

- Booleans: `enabled`, `debug`, `announce`, module on/off
- Nested feature maps: `features.confessions = false`
- Numeric knobs mistaken for flags: thresholds, timeouts (prefer canon data for Beef thresholds)

There is **no** platform feature-flag service. A flag is only as strong as (a) defaults merge on load, (b) UI that exposes it, and (c) every code path that checks it.

## 2. Ecosystem patterns

| Pattern | Who uses it | Steal / avoid |
|---------|-------------|----------------|
| **Personal options vs group-affecting options** | RCLootCouncil: personal General settings vs Master Looter Options that only apply when you are ML ([Options](https://rclootcouncil.com/wiki/Options)) | Steal: split `ui` (personal) from officer/canon settings that affect guild |
| **Announce opt-out** | Gargul “Announce loot to chat” + quality floor ([Announcing Loot](https://github.com/papa-smurf/Gargul/wiki/Announcing-Loot-in-Chat)); Beef already locks per-officer announce opt-out (spec §10) | Steal: spectacle noise is a local flag, not a protocol change |
| **Session-only disable** | RCLC “Disabled” response / temp disable reset on logout-reload ([Options](https://rclootcouncil.com/wiki/Options)) | Steal for raid-night panic switch; avoid for ladder authority |
| **Debug / Account Mode** | All The Things exposes Debug Mode in settings; changelogs show debug prints being retired once logic is solid ([ATT files / changelogs](https://www.curseforge.com/wow/addons/all-the-things)) | Steal: named debug mode; avoid leaving it on by default |
| **Defaults merge, don’t clobber** | Community defensive init: `MyAddonDB = MyAddonDB or {}` then fill missing keys ([addon-dev references](https://github.com/TheMizeGuy/wow-addon-dev/blob/main/references/savedvariables-and-load-order.md)) | Required for adding new V2 flags without wiping V1 prefs |

## 3. Recommended shape for Church of Beef

Keep flags under **UI / local prefs**, never under ladder rows:

```text
ChurchOfBeefDB
├── schema
├── ui
│   ├── announce              -- officer spectacle opt-out (V1)
│   ├── features              -- staged product surfaces (V2+)
│   │   ├── ceremonialDashboard
│   │   ├── confessionsFeed
│   │   └── streamContrast
│   └── … frame position, minimap, toasts
├── ladder / standing / suggestions
└── meta
    ├── lastProtoMajorSeen
    └── flagsSeen             -- optional: which feature keys ever existed
```

Rules:

1. **Default off** for anything deferred in spec §14 (V2 dashboard, confessions, stream contrast).
2. **Defaults merge** when adding keys (track 21) — old installs must not nil-crash.
3. **Do not** store “I am an officer” in SV; recompute from roster every time (track 16).
4. **Do not** let a member flag enable `RANK_COMMIT` emit or accept.

## 4. Runtime debug vs SV debug

| Style | Example | Use when |
|-------|---------|----------|
| In-memory global | Plan: `COB.DEBUG = true` | Dev machines; must default false |
| SV-persisted debug | `ui.debugVerboseSync = true` | Officer Alpha testers who need logs across reloads |
| Packaging strip | `@do-not-package@` around debug slash | Anything that must not exist in Release zips |

Plan Task 8 already points at temp `/beef debug standing` behind `COB.DEBUG`. Prefer **packaging strip** for Release; SV or in-memory for Alpha.

## 5. Antipatterns

| Antipattern | Why it hurts Beef |
|-------------|-------------------|
| One mega `experimental = true` that unlocks commits + UI + verbose net | Too coarse; one toggle becomes a footgun |
| Shipping V2 surfaces on by default “to get feedback” | Guild night noise; hard to tell V1 bugs from V2 |
| Storing feature flags account-wide while ladder is per-character | Confusing alt behavior when §16 alt policy is still open |
| Using schema version as a feature flag | Schema = file shape; features = product; conflating them forces migrations for toggles |

## 6. Insight

SV flags are ideal for **spectacle, scoring heuristics, and local UX**. They are a weak control for **authority** (editable on disk — spec §6.3 already accepts that for standing). Gate authority with roster checks and protocol validation; use SV flags to stage V2 chrome.
