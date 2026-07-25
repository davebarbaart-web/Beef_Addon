# Persistence, SavedVariables, and Profile Systems

**Last updated:** 2026-07-25  
**Primary sources:** [TOC SavedVariables](https://warcraft.wiki.gg/wiki/TOC_format#Saved_variables), [AceDB in Getting Started](https://www.wowace.com/projects/ace3/pages/getting-started), Church of Beef design spec §9.

---

## 1. Blizzard primitives

| TOC field | Scope | Path concept |
|-----------|-------|--------------|
| `SavedVariables` | Account (all chars on account) | `WTF/Account/<account>/SavedVariables/` |
| `SavedVariablesPerCharacter` | One character | `WTF/Account/<account>/<realm>/<char>/SavedVariables/` |

Rules of thumb used across serious addons:

- **Character progress / unlocks / attunements / ladders** → per-character (or explicit realm+char keys inside account SV).
- **UI layout & cosmetic prefs** → often profiled (account SV with named profiles).
- Never assume SV exist before `ADDON_LOADED` for your addon.

---

## 2. AceDB scope model (industry standard mental model)

Even without using Ace, the AceDB namespaces are the vocabulary players and authors share:

| Namespace | Persists for |
|-----------|----------------|
| `char` | This character |
| `realm` | All chars on realm |
| `factionrealm` | Same faction on realm |
| `class` / `race` / `faction` | Matching chars |
| `profile` | User-selected named profile (usually UI settings) |
| `global` | Entire account |

Profiles: `SetProfile`, `GetCurrentProfile`, `GetProfiles`, copy/delete/reset — exposed via AceDBOptions UI (“Profiles” group with dual-spec hooks in some UIs). ElvUI Classic Anniversary explicitly supports dual-spec profile switching in its changelog era notes.

---

## 3. Church of Beef V1 mapping

Design decisions already locked:

| Data | Storage | Rationale |
|------|---------|-----------|
| Official ladder cache + revisions | Per-character SV | Spec §9; alts prove themselves |
| Local standing / event log | Per-character | Scoring is character-bound |
| Pending suggestions | Per-character | Tied to that char’s play |
| UI frame position / prefs | Per-character (V1) | Simplest; matches SV choice |

**Open question (spec §16):** account-level alt linking — would require either account `SavedVariables` or officer-side mapping. Do not sneak account SV in without revisiting doctrine.

---

## 4. Profile UX patterns worth copying later

When Beef grows settings (announce opt-out, toast density, theme):

1. Separate **“Church data”** (ladder commits) from **“UI profile”** (position, scale, mute announces).
2. Offer **Default / Streamer / Minimal** named presets rather than infinite ElvUI-like knobs.
3. Export/import of UI prefs (string share) is a Classic community expectation for UI packs — optional V2.
4. Never put officer-authoritative ladder state only in a swappable cosmetic profile.

---

## 5. Sync vs SavedVariables

BeefNet reconciles official records across clients (spec §8.3). Persistence implications:

- SV is a **cache**, not a server.
- Higher revision wins; login `SYNC_REQUEST` fills gaps.
- Editing SV to inflate standing is expected-possible; officer gate is anti-cheat (spec §6.3).
- Avoid writing SV every combat event — batch on meaningful changes / logout to reduce IO hitch risk (general addon hygiene).

---

## 6. Multi-client / Anniversary caution

Separate install trees mean separate WTF trees. A player’s Era character DB will not appear on Anniversary. Document this in README for guild installers.

---

## Sources

- [TOC format — Saved variables](https://warcraft.wiki.gg/wiki/TOC_format#Saved_variables)
- [Ace3 Getting Started — AceDB](https://www.wowace.com/projects/ace3/pages/getting-started)
- Design spec §9, §16
