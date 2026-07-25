# Profiles, Import/Export, and Settings Portability

**Last updated:** 2026-07-25

---

## 1. AceDB namespaces (shared vocabulary)

Even without Ace, authors and players talk in AceDB scopes ([AceDB-3.0 Tutorial](https://www.wowace.com/projects/ace3/pages/ace-db-3-0-tutorial)):

| Namespace | Meaning |
|-----------|---------|
| `profile` | Named, user-switchable settings (most UI prefs) |
| `char` | This character only |
| `realm` / `factionrealm` | Realm-scoped |
| `global` | Entire account |
| `class` / `race` / `faction` | Matching characters |

Defaults table mirrors these keys. Init only after SV load.

Callbacks for UI refresh after profile ops: `OnProfileChanged`, `OnProfileCopied`, `OnProfileReset`, etc. ([AceDB Tutorial](https://www.wowace.com/projects/ace3/pages/ace-db-3-0-tutorial)).

---

## 2. AceDBOptions standard Profiles UI

[Getting Started](https://www.wowace.com/projects/ace3/pages/getting-started) and AceDBOptions source/docs expose a ready-made group via `GetOptionsTable(db)` including (localized strings observed in library):

| Control | Purpose |
|---------|---------|
| Current / choose profile | Switch active profile |
| New | Create empty profile |
| Copy From | Copy settings into current |
| Reset Profile | Restore defaults (with confirm) |
| Delete a Profile | Remove unused profiles (confirm) |

Intro copy emphasizes per-character flexibility: different settings per character via profile choice ([AceDBOptions localization / API usage](https://www.wowace.com/projects/ace3/pages/getting-started)).

[Ace3 for Dummies](https://warcraft.wiki.gg/wiki/Ace3_for_Dummies) shows Profiles as a **child Bliz options page** under the addon.

**Do not mutate** the shared options table returned by `GetOptionsTable` ([Getting Started](https://www.wowace.com/projects/ace3/pages/getting-started) note).

---

## 3. Import / export patterns in the wild

| Pattern | Mechanism | Exemplars | Notes |
|---------|-----------|-----------|-------|
| **Share string** | Serialize → encode → paste in chat/Discord | WeakAuras (community culture; Wago import tutorials) | Best for *content packs*, not whole SavedVariables dumps |
| **In-addon Import/Export UI** | Profiles tab paste/copy | ElvUI Profiles Import/Export ([Tukui changelog](https://tukui.org/elvui) explicitly mentions Import/Export pages; community guides document `/ec` → Profiles → Import) | Expect invalid-string errors; confirm before overwrite |
| **WTF file copy** | Manual `SavedVariables/*.lua` backup | Power users / ElvUI guides | Document path; fragile across clients |
| **In-game profile send** | Addon messaging of profile payload | ElvUI “Allow Profile Sharing” / share global+private (*changelog mentions*) | Opt-in; bandwidth/trust concerns |

Church of Beef ladder state is **not** a cosmetic profile — it is officer-committed, revisioned cache ([spec §8–§9](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)). Import/export must never overwrite `RANK_COMMIT` authority via a pasted string without officer judgment.

---

## 4. Separation rule (critical for Beef)

| Data class | Profile / import? | Why |
|------------|-------------------|-----|
| Frame position, scale, hide minimap, mute toasts, announce opt-out | Yes (UI prefs) | Harmless to copy across alts |
| Local standing / event log | No (char progress) | Spec: alts prove themselves |
| Official ladder cache + revisions | No (sync cache) | BeefNet + officer commits own this |
| Officer rank-index threshold | Guild policy — careful | Wrong import could mis-gate approvals |

This matches the library doc [05-persistence-and-profiles.md](../05-persistence-and-profiles.md).

---

## 5. Named presets vs infinite profiles

ElvUI-scale profile trees overwhelm casual guildmates. Prefer **few named presets** for social addons:

| Preset | Intent |
|--------|--------|
| Default | Normal guild night |
| Streamer | Louder toasts / announces on |
| Quiet | Mute guild-chat announce opt-out + fewer toasts |

Reset-to-defaults with confirm is more valuable than dozens of empty profile slots.

---

## 6. Church of Beef relevance

| Phase | Recommendation |
|-------|----------------|
| **V1** | Per-character SV only (already locked). No AceDB profiles. No import/export. |
| **V2** | Optional UI-pref profiles or account SV for cosmetics; keep ladder per-char / net-synced. |
| **Never** | “Import ladder string” as member self-serve — that fights officer anti-cheat stance (spec §6.3). |
| **Officer tooling** | Manual standing adjust already covers corrections; no need for profile import of scores. |

---

## Sources

- [AceDB-3.0 Tutorial](https://www.wowace.com/projects/ace3/pages/ace-db-3-0-tutorial)
- [Ace3 Getting Started — AceDBOptions](https://www.wowace.com/projects/ace3/pages/getting-started)
- [Ace3 for Dummies — User Profiles](https://warcraft.wiki.gg/wiki/Ace3_for_Dummies)
- [ElvUI — Tukui](https://tukui.org/elvui)
- [05-persistence-and-profiles.md](../05-persistence-and-profiles.md)
- Design spec §6.3, §8–§9, §16
