# 08 — SavedVariables & settings UX (Classic / CoB)

**Audience:** coding agents polishing Church of Beef UI, prefs, and persistence.  
**Last updated:** 2026-07-26  
**Status:** Research synthesis for polish — **not** product law. Locked decisions stay in the [design spec](../../superpowers/specs/2026-07-25-church-of-beef-design.md) §9–§10 / [glossary 74](../wow-classic-addon-design/74-v1-decision-glossary/locked-v1-decisions.md).  
**Deep tracks:** [21 SavedVariables migration](../wow-classic-addon-design/21-savedvariables-migration/), [11 Onboarding & settings UX](../wow-classic-addon-design/11-onboarding-settings-ux/), sketch [05 Persistence](../wow-classic-addon-design/05-persistence-and-profiles.md).  
**Implementation today:** `addon/ChurchOfBeef/Core/DB.lua` + `## SavedVariablesPerCharacter: ChurchOfBeefDB` in the TOC.

---

## 1. Executive rules (read first)

1. **`ChurchOfBeefDB` is PerCharacter.** Alts start Fresh Beef. Do not flip TOC to account-wide mid-life.
2. **SV is a cache, not a server.** Officer commits + BeefNet revisions reconcile ladder state after wipe/corruption.
3. **Merge defaults; never replace the whole table** with a fresh defaults blob on login.
4. **Init only on `ADDON_LOADED` for `ChurchOfBeef`.** Never touch SV at file-scope load.
5. **Nest `ui` vs church data** (`ladder` / `scoring`). “Reset UI” must not wipe ladder.
6. **V1 settings budget is tiny:** frame position, minimap show/hide, announce opt-out (default ON). No options sprawl.
7. **Agents must never nuke player WTF** — see §8.

---

## 2. Per-character vs account

| TOC directive | Scope | Typical path |
|---------------|--------|--------------|
| `## SavedVariables` | Account-wide | `WTF/Account/<account>/SavedVariables/<AddOn>.lua` |
| `## SavedVariablesPerCharacter` | One realm + character | `WTF/Account/<account>/<Realm>/<Character>/SavedVariables/<AddOn>.lua` |

**Church of Beef V1 (locked):**

| Field | Global | Scope |
|-------|--------|--------|
| Everything in one table | `ChurchOfBeefDB` | `SavedVariablesPerCharacter` |

**Why per-character wins for Beef**

- Standing / ladder testimony is character progress culture (“flesh must prove itself anew”).
- Avoids accidental alt dossiers in one account file (privacy + support).
- Matches Classic guild tools that treat alt progression as separate.

**When account SV is justified (future only)**

| Data class | Prefer |
|------------|--------|
| Named UI profiles shared across alts / streamer presets | Account SV **second global** |
| Character standing, suggestions, day caps | Stay PerCharacter |
| Official ladder cache | PerCharacter (V1) or officer-synced; never “active profile” |

**Dual-global pattern (later):** keep `ChurchOfBeefDB` (char) and add e.g. `ChurchOfBeefAccountDB` (account). **Never** silently change the existing TOC line from PerCharacter → Account — that orphans old files and looks like data loss. TOC metadata changes need a **full client restart**, not just `/reload`.

**Client trees do not share WTF.** Anniversary / Era / `_classic_` installs each have their own tree. Copying Era SV into Anniversary is undefined.

Primary refs: [TOC Saved variables](https://warcraft.wiki.gg/wiki/TOC_format#Saved_variables), [Saving variables between game sessions](https://warcraft.wiki.gg/wiki/Saving_variables_between_game_sessions).

---

## 3. Load / write timing (agent pitfalls)

| Phase | Reality |
|-------|---------|
| File chunk executes | SV **not** ready |
| After SV load | `ADDON_LOADED` with addon name → `COB.DB:Init()` |
| During play | In-memory mutations; **no continuous flush** |
| `/reload`, logout, exit | Client writes declared globals to disk |
| `PLAYER_LOGOUT` | Last chance for a flush; do not rely on it for normal saves |

**Store only serializable types:** strings, numbers, booleans, plain tables. **Never** frames, functions, userdata. Frame position = `{ point, relativePoint, x, y }` numbers only (relativeTo must not be a frame reference).

Hard kill / power loss can lose the last session’s unsaved mutations — expected; design local standing as lossy.

Do **not** depend on Retail-era `## LoadSavedVariablesFirst` for Anniversary `20506`.

---

## 4. Defaults & first-run UX

### Philosophy

| Pattern | Fit for CoB? |
|---------|----------------|
| Full installer / wizard (ElvUI-scale) | **No** for V1 — wrong guess is not expensive |
| Zero-config + empty states | **Yes** — Fresh Beef, scoring paused out of guild, Officer tab gated |
| Soft one-time tip | Optional (`firstRunDone`); never block `/beef` |

### Defaults hygiene

Mirror AceDB’s spirit without requiring Ace:

1. Defaults structure matches live DB shape.
2. On init: if global nil → create full defaults + `version = CURRENT`.
3. If global exists → **deep-fill missing keys only**; preserve unknown keys (forward-compat).
4. Never “reset to defaults every login.”

### Locked / recommended V1 defaults

| Key | Default | Notes |
|-----|---------|-------|
| `version` | `1` | Schema stamp (`DB.lua`) |
| `ui.announce` | `true` | Officer checkbox; spectacle on |
| `ui.shown` | `false` | Do not force-open on login |
| `ui.point` | `nil` | Until player drags |
| `ui.minimapHide` | falsy / absent | Button shown (discoverability) |
| `ladder.records` / `.suggestions` | `{}` | Filled by play + sync |
| `scoring.granted` / `dayKey` | empty | Local caps |

Safe defaults beat a settings tree. Spec §10 settings budget: position, minimap, announce — toast mute only if playtest proves noise.

---

## 5. Schema migration

Blizzard does **not** version your file. Authors own migrations.

### Algorithm (industry + CoB)

```text
ADDON_LOADED (ChurchOfBeef)
  → ensure ChurchOfBeefDB is a table
  → if version missing, treat as 0/1
  → run ordered: if version < 2 then …; version = 2; end; …
  → merge defaults for missing keys (never clobber existing)
  → import into Core modules
```

| Situation | Behavior |
|-----------|----------|
| Brand new | Create schema CURRENT + defaults |
| Upgrade | Stepwise migrate, then merge |
| User deleted SV | Same as brand new; BeefNet refill ladder |
| `version` **higher** than code | Soft warn; **do not** down-migrate / strip unknown keys |
| Protocol mismatch (BeefNet) | Keep SV; refuse bad applies; sync later — **not** auto-wipe |

**Church data ≠ profile.** Even if AceDB arrives later, do not put `ladder` under a swappable `profile` namespace. Reset UI ≠ reset church.

Implementation already follows this in `Core/DB.lua` (`applyDefaults`, preserve unknown roots/`ui` keys, ordered migration hook).

---

## 6. Options panels & settings UX

### V1 surface (locked)

```text
/beef → Main frame
         ├─ Ladder
         ├─ My Standing
         └─ Officer (gated)
              └─ “Announce promotions to guild chat” ↔ ui.announce

Minimap → same toggle as /beef
```

- **Product UI ≠ prefs tree.** Ladder/standing stay custom frames.
- **One source of truth** for each pref (GUI checkbox and any future slash flag call the same setter).
- Slash-only for announce opt-out is **not** sufficient (glossary / spec).
- Defer Blizzard Interface Options / AceConfig until prefs grow (V2).
- Profile import/export strings: **UI cosmetics only**, never official ranks.

### Settings budget (do not expand casually)

| Pref | Where | Destructive? |
|------|--------|--------------|
| Frame position | Drag title bar → `ui.point` | No |
| Minimap hide | Minimap / tiny settings | No |
| Announce opt-out | Officer tab checkbox | No (quiet stream) |
| Toast mute | Only if playtest asks | No |
| “Reset UI” | Future | Yes → confirm; touch `ui` only |
| “Clear ladder” / standing wipe | Officer tools | Yes → heavy confirm; never silent |

Progressive disclosure: officers see officer prefs; members never see announce policy. Confirm demote / Prophet / standing correction (Ace `confirm` pattern in plain frames).

Anti-patterns: scoring-weight sliders in V1, duplicate slash+GUI flags, first-run checkbox walls, importing “full church state” paste strings.

---

## 7. Corruption, wipe, and recovery (product + support)

| Failure | Design response |
|---------|-----------------|
| Empty / NUL SV file | Treat as fresh; sync ladder from peers |
| Client `.bak` clobber | External dated WTF backup; do not trust `.bak` alone ([WoWUIBugs #241](https://github.com/Stanzilla/WoWUIBugs/issues/241)) |
| Single-client wipe | Official ranks return via `SYNC_REQUEST`; local standing/event log may stay gone |
| Officer disk dies | Social redundancy (≥2 officers), not fancier SV |

**Wipe-safe rule:** after `ChurchOfBeefDB = nil`, login + sync restores **official** ranks. Local testimony is lossy by design.

Keep SV small (≪ 1 MB target in checklist): capped event logs, no combat dumps, batch meaningful writes.

Support copy for guild IT: *“Deleting WTF does not excommunicate you — log in and sync. Alts are catechumens; do not paste Main’s lua as doctrine.”*

---

## 8. Agent safety rules — never nuke player WTF

These bind coding agents in this repo (also `.cursor/rules/verification.mdc` + church-of-beef-dev skill).

### Hard bans

| Do not | Why |
|--------|-----|
| Delete / overwrite player `WTF/**/ChurchOfBeefDB.lua` (or sibling SV) without **explicit user ask** | Destroys standing log, UI prefs, local cache |
| `git clean`, wipe `Interface/AddOns`, or wipe the WoW install | Collateral data loss |
| “Fix corruption” by deleting WTF as first step | Rename-aside + ask first |
| Commit player SV into the repo | Privacy + noise |
| Call `ResetForTests` / clear ladder outside harness (`ChurchOfBeef._IN_TEST`) | Wipes live state if mis-copied |
| Ship `/beef reset` that replaces the whole SV table without confirm + scope | Accidental excommunication UX |
| Auto-wipe ladder on BeefNet version mismatch | Cache can heal; wipe cannot |
| Scrape chat/combat logs or pack full SV into “support dumps” | Privacy track 65 |

### Safe agent patterns

| Do | How |
|----|-----|
| Change schema / defaults in **code** | `Core/DB.lua` merge + migrations; unit tests in `tests/test_db.lua` |
| Reproduce empty SV | Harness: `ChurchOfBeefDB = nil` then `DB:Init()` — not the player’s disk |
| Debug persistence | Ask user to `/reload` and report; optional private paste of **stripped** keys |
| Install addon | `rsync`/`cp` **only** `Interface/AddOns/ChurchOfBeef/` — never sync into `WTF/` |
| Document recovery | Rename file aside while game **closed**; restore from dated backup; else fresh + sync |
| Reset UI in product | Clear `ChurchOfBeefDB.ui` subtree only, after confirm |
| Future account prefs | New TOC global; migrate copy; leave PerCharacter church data alone |

### Install vs WTF (mental model)

```text
Interface/AddOns/ChurchOfBeef/   ← code you may overwrite on install
WTF/.../SavedVariables/          ← player data; agents do not touch
```

`rsync --delete` of the **addon folder** is fine for code updates. Pointing that at `WTF` is a catastrophic mistake.

---

## 9. CoB shape today (implementation map)

```lua
ChurchOfBeefDB = {
  version = 1,
  ui = { point, shown, announce, --[+ minimapHide] },
  ladder = { records = {}, suggestions = {} },
  scoring = { dayKey = "", granted = {} },
  -- unknown keys must survive Init
}
```

| Concern | Owner |
|---------|--------|
| Shape, defaults, migrate | `COB.DB` / `Core/DB.lua` |
| UI prefs in place | `UI/*.lua` write `ChurchOfBeefDB.ui` |
| Flush ladder/scoring into SV | `DB:Save()` before logout boundaries as needed |
| Authority | Officer commit + Net apply — **not** raw SV edits |

Tests already cover: defaults, merge without clobber, unknown-key survival, future schema stamp left alone (`tests/test_db.lua`).

---

## 10. Polish checklist (agents)

When touching settings / SV polish:

- [ ] Pref lives under `ui` (or intentional church subtree) — not a new top-level dump
- [ ] Default is safe for zero-config first night
- [ ] Missing key filled; existing value preserved; unknown keys kept
- [ ] No frame refs in SV; position is numbers only
- [ ] Announce stays discoverable on Officer tab; default ON
- [ ] No new destructive reset without confirm + scoped subtree
- [ ] Offline: `lua tests/run.lua` green if DB/defaults/migrations changed
- [ ] In-game: `/reload` survives the pref; never “fixed” by deleting WTF
- [ ] Did **not** edit player `WTF/**` unless the human explicitly asked

---

## 11. Sources (primary)

| Topic | URL |
|-------|-----|
| TOC Saved variables | https://warcraft.wiki.gg/wiki/TOC_format#Saved_variables |
| Saving between sessions | https://warcraft.wiki.gg/wiki/Saving_variables_between_game_sessions |
| SavedVariables paths | https://warcraft.wiki.gg/wiki/SavedVariables |
| AceDB init / defaults | https://www.wowace.com/projects/ace3/pages/getting-started |
| AceDB tutorial | https://www.wowace.com/projects/ace3/pages/ace-db-3-0-tutorial |
| AceConfig options tables | https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables |
| SV write / `.bak` bugs | https://github.com/Stanzilla/WoWUIBugs/issues/241 |
| ElvUI export (UI only) | https://github.com/tukui-org/ElvUI/wiki/export |
| WTF backup culture | https://xscarlife-gaming.com/wtf-folder/ |

In-repo depth: track [21](../wow-classic-addon-design/21-savedvariables-migration/) (account vs char, migration, backup, corruption, wipe-safe caches) and [11](../wow-classic-addon-design/11-onboarding-settings-ux/) (defaults, slash vs GUI, overwhelm).

---

## 12. Open doors (do not block V1 polish)

1. Account-wide UI profiles / streamer quiet preset (§16) — dual global, not TOC flip.
2. Soft first-run tip medium (chat vs footer).
3. Bliz Options mirror for announce on alts.
4. Cosmetic share-string for UI only.

Research here must not silently fork those into code without updating the design-spec decisions log.
