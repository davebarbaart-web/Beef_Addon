# Schema versioning and migration patterns

**Track:** [21 README](README.md)  
**Primary sources:** [Saving variables between game sessions](https://warcraft.wiki.gg/wiki/Saving_variables_between_game_sessions), [Ace3 Getting Started — AceDB](https://www.wowace.com/projects/ace3/pages/getting-started), community defensive-init patterns (see `.raw/search-savedvariables-core.json`)

---

## 1. Why versioning is author-owned

Blizzard serializes whatever globals you declare; it does **not** provide schema IDs, migrations, or forward/back compatibility. When you add/remove keys across addon releases, old files load as-is. Authors who “reset to defaults every login” destroy user data; authors who never migrate leave dead fields and nil crashes.

---

## 2. Recommended root shape (conceptual)

Keep a single root table (matches CoB’s one global) with:

| Field | Role |
|-------|------|
| `schema` or `version` | Integer; current file format |
| `ui` | Frame position, toast prefs, announce opt-out, minimap |
| `ladder` | Official records keyed by player; each with `revision`, rank, standing snapshot, metadata |
| `standing` | Local advisory points + capped event log |
| `suggestions` | Pending promotion suggestions visible to this client |
| `meta` | Optional: last sync time, last known addon major, guild realm stamp |

**Do not** overload AceDB-style `profile` for ladder rows even if Ace is adopted later ([AceDB Getting Started](https://www.wowace.com/projects/ace3/pages/getting-started) — profile is for user-selected setting sets). Track 03 owns Ace details; here the rule is: **church data ≠ profile**.

---

## 3. Migration algorithm (pattern)

Industry convention (defensive init / schema migration sections in addon-dev references):

1. On `ADDON_LOADED` for your addon name, ensure the global is a table (`or {}`).
2. If `schema` missing, treat as schema `1` (or `0` → migrate to `1`).
3. Run **ordered** steps: `if schema < 2 then … schema = 2 end`, then `< 3`, etc.
4. Each step only transforms data; never skip versions in production (a player may jump 1 → 4 in one update — run 2 then 3 then 4).
5. After migrations, **merge defaults** for missing keys (deep-fill nils; do not clobber existing values).
6. Persist happens automatically on next write boundary; no special “save now” API.

AceDB’s `New(svName, defaults)` covers defaults + namespaces; it does **not** replace explicit schema migrations for renamed keys or structural changes. If Beef stays plain Lua in V1, implement the integer ladder yourself; if Ace arrives later, still keep an explicit `schema` field for church-data reshapes.

---

## 4. Migration categories that matter for guild addons

| Change type | Safe approach | Risky approach |
|-------------|---------------|----------------|
| Add optional UI key | Defaults merge | Require reinstall |
| Rename rank id / standing field | Copy old → new; keep old one release; then drop | Delete old immediately without copy |
| Change revision semantics | Bump schema; recompute or invalidate cache; force sync | Silently reinterpret numbers |
| Split one table into two | Migrate in place; write both; then stop writing old | Flip TOC Account↔PerChar |
| Raise major BeefNet protocol | Soft-warn; discard incompatible commits (spec §8.2); may leave SV cache stale until sync | Auto-wipe ladder on version mismatch |

**Incompatible major protocol vs schema:** protocol mismatch (BeefNet) should not automatically wipe SV. Prefer: keep cache, refuse apply, sync when compatible peers exist. Schema migrations are for **local file shape**; protocol versions are for **wire format** (track 14).

---

## 5. Profile migration (cosmetic) vs data migration (church)

| Concern | Profile / UI | Church data |
|---------|--------------|-------------|
| User expectation | Export/import, copy between chars | Survive wipe via sync |
| Reset command | “Reset UI to defaults” OK | “Reset ladder” must be officer-gated / confirm-heavy |
| Sharing | String export (ElvUI-style) welcome | Exporting official ladder as a share string invites forgery aesthetics; prefer BeefNet |
| Dual-spec / named profiles | Future streamer presets | Never bind RANK_COMMIT cache to active profile name |

ElvUI documents profile export/import as copy/paste text from a Profiles panel ([ElvUI export wiki](https://github.com/tukui-org/ElvUI/wiki/export)) — steal that UX only for **UI**, not for authoritative ranks.

---

## 6. First-run vs upgrade vs wipe

| Situation | Detection | Behavior |
|-----------|-----------|----------|
| Brand new | Global nil / empty table | Create schema = CURRENT; defaults; empty ladder |
| Upgrade | `schema < CURRENT` | Run migrations; merge defaults |
| User deleted SV file | Same as brand new | Empty ladder until BeefNet sync |
| User hand-edited standing | Still loads | Spec §6.3 — officer gate is anti-cheat; no crypto |
| Downgrade addon | `schema > CURRENT` | Soft warn; do not down-migrate destructively; prefer refuse write of unknown future fields or quarantine |

Downgrades are rare in guild distribution; still avoid writing a lower schema over a higher one without an explicit “I know” reset.

---

## 7. Timing notes (Ace-adjacent, not Ace tutorial)

AceDB must be created in `OnInitialize` (or later), not at file scope — SV are not ready in the main chunk ([Ace3 Getting Started](https://www.wowace.com/projects/ace3/pages/getting-started)). Plain Lua Beef should mirror that: **no mutations of `ChurchOfBeefDB` at file load**; all init/migration in the `ADDON_LOADED` handler for `ChurchOfBeef`.
