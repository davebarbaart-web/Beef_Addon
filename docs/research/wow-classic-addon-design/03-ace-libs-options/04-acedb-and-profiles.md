# AceDB-3.0 and Profile Patterns

**Last updated:** 2026-07-25  
**Sources:** [AceDB-3.0 API](https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0), [AceDB-3.0 Tutorial](https://www.wowace.com/projects/ace3/pages/ace-db-3-0-tutorial), [Getting Started — AceDB](https://www.wowace.com/projects/ace3/pages/getting-started), [AceDBOptions-3.0](https://www.wowace.com/projects/ace3/pages/api/ace-dboptions-3-0), CoB design spec §9 / §16.  
**Correction:** Parallel deep-research incorrectly claimed `New(..., true)` forces per-character SavedVariables. Primary docs say otherwise (below).

---

## 1. Two different “per character” concepts

| Concept | Mechanism | What it means |
|---------|-----------|----------------|
| **TOC `SavedVariablesPerCharacter`** | Blizzard writes a separate SV file per character path | Physical isolation; CoB V1 choice for `ChurchOfBeefDB` |
| **AceDB `db.char` scope** | Logical partition **inside** an account-wide SV table | Same file, keys keyed by character |
| **AceDB default profile = character name** | When `defaultProfile` omitted, AceDB uses a **character-specific profile name** | Affects `db.profile` only, not TOC file layout |
| **AceDB `defaultProfile = true`** | Uses shared profile named `"Default"` | All chars start on the same profile unless switched |

**Critical AceDB API fact** ([AceDB:New](https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0)):

- Omit third argument → character-specific **profile** as default.
- Pass `true` → shared global profile `"Default"`.
- Pass a string → that exact profile name (no token expansion; `"char"` is literally the name `"char"`).

Tutorials assume TOC line `## SavedVariables: MyAddonDB` (account-wide file). AceDB’s char/realm/faction/… scopes then simulate finer sharing **inside** that file.

---

## 2. Scope table (industry vocabulary)

From AceDB tutorial / API:

| Scope | Sharing boundary |
|-------|------------------|
| `char` | This character only |
| `realm` | All chars on this realm |
| `factionrealm` | Same faction + realm |
| `faction` / `class` / `race` | Matching chars on the account |
| `locale` | Client locale bucket (listed in API; less used day-to-day) |
| `global` | Entire account |
| `profile` | User-selected named profile (usual home for UI settings) |

Defaults tables mirror these keys. Magic keys `['*']` and `['**']` supply smart defaults for undefined children (module enable maps, etc.).

---

## 3. Lifecycle and namespaces

| Rule | Source guidance |
|------|-----------------|
| Create DB in `OnInitialize` (after ADDON_LOADED) | Tutorial: creating earlier lets real SV overwrite your table |
| Child namespaces via `RegisterNamespace` | Modules get isolated defaults; **linked to parent profile**; no independent `SetProfile` |
| Profile APIs | `SetProfile`, `GetCurrentProfile`, `GetProfiles`, `CopyProfile`, `DeleteProfile`, `ResetProfile`, `ResetDB` |
| Callbacks | Profile change / reset hooks (refresh UI when profile swaps) |

---

## 4. AceDBOptions profile UX (what players expect)

`AceDBOptions-3.0:GetOptionsTable(db[, noDefaultProfiles])` returns a ready-made AceConfig group commonly mounted at `options.args.profiles`.

Typical player-facing actions in that standard block:

- Choose active profile
- Create new profile
- Copy from another profile
- Delete / reset

This is why “Profiles” tabs feel identical across Ace addons — they often **are** the same options table.

Some UIs layer **LibDualSpec** (Retail-leaning) for spec-based profile auto-switch. Classic Anniversary / TBC anniversary relevance is limited; do not plan CoB V1 around dual-spec profile switching.

---

## 5. Contemporary split: “data” vs “UI profile”

| Bucket | Typical AceDB home | CoB V1 analogue |
|--------|--------------------|-----------------|
| Progression / ladder / standing | `char` or non-profile tables | Per-character SV (locked doctrine: alts prove themselves) |
| Guild-wide officer config | `realm` / `factionrealm` / `global` | Spec keeps officer threshold in canon/settings; account-wide prefs are an open question (§16) |
| Frame position, scale, toast mute, announce opt-out | `profile` | Currently folded into same per-char SV — fine for V1 |
| Named presets (“Streamer”, “Minimal”) | Multiple `profile` names | Post-V1 nicety |

**Do not put official ladder commits only in `db.profile`.** Players reset/copy profiles expecting UI changes, not excommunication of Beef Prophets.

---

## 6. Conflict with CoB V1 TOC choice

Design spec §9: `SavedVariablesPerCharacter: ChurchOfBeefDB`.

| Path | Implication |
|------|-------------|
| Stay on per-character TOC (V1) | Plain table persistence; AceDB optional later with a **migration** (account SV + scopes, or AceDB on per-char files with reduced cross-char profile value) |
| Move to account `SavedVariables` + AceDB scopes | Enables true cross-alt UI profiles and realm buckets; must revisit alt doctrine before merging ladder standing |
| Hybrid | Account SV for UI profiles + per-char SV for ladder — two DB names; more moving parts |

**Research recommendation:** keep V1 TOC as specified. If AceDB is adopted later for UI profiles, prefer **account SavedVariables for prefs** while keeping ladder/standing character-bound (either `db.char` or a second per-char SV). Never silently make standing account-wide.

---

## 7. Profile copy / reset norms worth stealing even without Ace

1. Separate **destructive** actions (reset standing, demote, wipe suggestions) from **profile reset** (UI defaults).
2. Confirm dialogs on wipe/reset (AceConfig `confirm` pattern).
3. Offer a small set of named presets rather than infinite ElvUI-grade knobs.
4. On profile change, refresh frame position/visibility from the new profile and leave network-authoritative ladder data alone.
