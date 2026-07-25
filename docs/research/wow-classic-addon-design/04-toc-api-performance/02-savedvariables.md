# SavedVariables Patterns

**Last updated:** 2026-07-25  
**Primary sources:** [Saving variables between game sessions](https://warcraft.wiki.gg/wiki/Saving_variables_between_game_sessions), [TOC format — SavedVariables](https://warcraft.wiki.gg/wiki/TOC_format#SavedVariables), [AceDB-3.0](https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0)

---

## 1. Two official scopes

| TOC directive | On-disk location (conceptual) | Semantics |
|---------------|-------------------------------|-----------|
| `## SavedVariables: Name` | `WTF/Account/<account>/SavedVariables/<Addon>.lua` | Restored for **any** character on the account |
| `## SavedVariablesPerCharacter: Name` | `WTF/Account/<account>/<realm>/<character>/SavedVariables/<Addon>.lua` | Separate copy **per character** |

Both declare **global variable names**. The client serializes those globals at logout and restores them at load. If the global is `nil` on first load, the addon must initialize defaults.

Church of Beef V1 (design spec §9): **`SavedVariablesPerCharacter: ChurchOfBeefDB`** — alts start Fresh Beef; intentional.

---

## 2. Load / save lifecycle

From the wiki’s load-order description:

1. TOC / scripts load for an addon.
2. Saved variables for that addon are loaded and executed.
3. `ADDON_LOADED` fires for that addon (arg1 = addon name).
4. Later, `PLAYER_LOGOUT` is the last chance to mutate SV before the client writes them to disk.

**Norms:**

- Initialize / migrate SV on `ADDON_LOADED` when `arg1` matches the addon name.
- Use `PLAYER_LOGOUT` only for last-minute flush work (compact logs, final timestamps).
- Do not assume SV exist before `ADDON_LOADED`.
- `## LoadSavedVariablesFirst: 1` exists for rare cases that need SV before scripts; avoid unless required.

---

## 3. Design patterns (without prescribing libraries)

### 3.1 Raw table under one global

Most modern addons store **one table** under the declared global (`ChurchOfBeefDB = ChurchOfBeefDB or {}`) and nest keys (`db.standing`, `db.ui`, `db.ladderCache`).

Pros: simple, Classic-safe, no LibStub.  
Cons: you own migrations, defaults, and profile UX.

### 3.2 AceDB-3.0 over account-wide SV

AceDB expects a TOC `## SavedVariables:` (account file) and then **internally** partitions into scopes:

| AceDB type | Intent |
|------------|--------|
| `char` | Per-character |
| `realm` / `factionrealm` | Shared on realm (and faction) |
| `class` / `race` / `faction` | Cross-character slices |
| `profile` | User-switchable profiles (default is character-specific profile name unless overridden) |
| `global` | Account-wide, not profile-scoped |
| `account` | Account-wide (AceDB naming; see library docs) |

Passing `true` as default profile uses a shared `"Default"` profile across characters ([WelcomeHome / AceDB docs](https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0)).

**Conflict with V1 product stance:** AceDB’s usual pattern is **account-wide TOC SV + char/profile namespaces**. Church of Beef V1 wants **true per-character TOC SV** so alts do not share ladder standing by accident. If AceDB is adopted later, either:

- keep `SavedVariablesPerCharacter` and treat AceDB carefully (or skip AceDB), or  
- use account SV **only** for UI chrome profiles while keeping ladder/standing in a separate per-character global.

Do not silently flip V1 to account-wide ladder state.

### 3.3 What to store (social addon)

| Store | Why |
|-------|-----|
| UI prefs / frame position | Comfort |
| Cached official ladder + revisions | Offline reconciliation (design §8.3) |
| Pending suggestions / local standing log | My Standing + officer queue |
| Schema / db version integer | Migrations |

| Avoid storing | Why |
|---------------|-----|
| Huge unrotated event transcripts | Login cost ∝ SV file size |
| Duplicate canon rank tables | Canon lives in `Data/Ranks.lua` |
| Secrets / tokens | No server; nothing to encrypt usefully |

---

## 4. Trust model (product-relevant)

SavedVariables are **editable text on disk**. For Church of Beef:

- Local standing is **self-reported testimony**.
- Officer `RANK_COMMIT` is the anti-cheat (design §6.3).
- Persistence research implication: optimize for **small, migratable, reconciliable** caches — not tamper-proof ledgers.

---

## 5. Performance / size norms

- Prefer sparse tables; prune old local event logs.
- Login hitch scales with SV deserialize size — keep ChurchOfBeefDB “a few hundred KB” class unless proven otherwise; multi-MB SV files are a smell for a social ladder addon.
- Never write SV from a hot `OnUpdate` path; mutate in memory and let logout persist (or rare explicit flush patterns if ever needed).

---

## 6. Church of Beef V1 checklist

| Item | Spec / research stance |
|------|------------------------|
| TOC | `## SavedVariablesPerCharacter: ChurchOfBeefDB` |
| Init | Defaults + migration on `ADDON_LOADED` |
| Alts | Independent Fresh Beef |
| Account merge | Explicitly **not** V1 |
| Optional later | Account-wide prefs only, never automatic ladder merge without product decision |
