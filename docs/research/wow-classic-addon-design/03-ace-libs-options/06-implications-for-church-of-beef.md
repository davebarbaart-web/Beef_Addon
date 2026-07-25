# Implications for Church of Beef

**Last updated:** 2026-07-25  
**Maps to:** [design spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §§5–10, §16  
**Depends on:** docs 01–05 in this track

---

## 1. Architecture verdict

| Layer | V1 (spec-aligned) | Later Ace-shaped upgrade |
|-------|-------------------|---------------------------|
| Bootstrap | TOC + `ADDON_LOADED` init of `ChurchOfBeefDB` | AceAddon `OnInitialize` / `OnEnable` |
| Modules | Folders `Core/`, `Net/`, `UI/`, `Data/` | Optional AceAddon modules with same boundaries |
| Ladder / standing | Per-character SavedVariables | Stay character-bound (`db.char` or keep per-char SV) |
| UI prefs | Same per-char DB is OK | Move to AceDB `profile` (+ AceDBOptions) |
| Options | Few toggles inside `/beef` or slash | AceConfig + Dialog; Profiles group |
| Minimap | Required button | Prefer LibDBIcon + LDB when embedding libs |
| BeefNet | Raw/classic addon messages + throttle discipline | AceComm optional for split/reassemble; **trust model unchanged** |
| Media | Default fonts; fallback required | Optional LibSharedMedia Register/Fetch |

**Bottom line:** Ace3 is the right *ecosystem* to design toward, not a V1 requirement. The expensive mistake would be stuffing official ladder state into user-resettable profiles.

---

## 2. Top options / profile insights

1. **Keep church data out of “Profiles”.** Official ranks, revisions, and standing logs are not UI skins. Profile reset must not excommunicate the guild.
2. **AceDB `true` ≠ per-character SV.** Omitting the default profile argument yields a char-named profile; `true` selects shared `"Default"`. TOC `SavedVariablesPerCharacter` is a separate Blizzard mechanism — CoB V1 already chose it.
3. **Officer gating is roster rank-index (spec §6.2), surfaced via `hidden`/`disabled`.** Do not substitute `CanEditOfficerNote()` as the sole gate; note permissions and “Officer” fantasy ranks diverge across guilds.
4. **Confirm destructive executes.** Demote, standing wipe, Prophet bestowal, Council seat changes — AceConfig `confirm` is the norm; mirror it in custom UI.
5. **Slash + GUI parity for settings knobs only.** `/beef` opens the ladder product; `/beef config` (or an Options tab) should own mute/announce/threshold — not bury ladder gameplay only in AceConfig.
6. **LibSharedMedia is post-V1 chrome.** Soft-dep only; never block load on missing Church fonts.
7. **LibDBIcon is the minimap off-ramp** from fragile Minimap parenting once any LibStub stack is embedded.
8. **AceComm does not replace BeefNet validation.** Throttling/splitting help; officer commit checks and revision merge rules remain product logic.
9. **Plan migration keys now.** Even in plain SV, namespace like `ui`, `ladder`, `pending`, `net` so an AceDB defaults table can mirror them later without a second redesign.
10. **Alt linking (§16) is a storage doctrine change**, not an Ace checkbox. Account-wide AceDB `global`/`realm` standing would violate current “flesh must prove itself anew” V1 stance unless consciously revised.

---

## 3. Suggested adoption ladder (non-binding)

| Stage | Libs / patterns | Trigger |
|-------|-----------------|---------|
| V1 | No Ace required; structured SV; custom UI; throttle-aware BeefNet | Spec success criteria |
| V1.x | LibStub + LDB + LibDBIcon | Minimap friction with collectors / themes |
| V2 settings | AceDB (account SV for prefs) + AceConfig + AceDBOptions | More than ~5 user settings or named presets |
| V2 media | Optional LSM + SharedMediaWidgets | Theatrical art pass |
| Optional | AceComm / AceSerializer | Payload size or multi-chunk sync pain |

---

## 4. Explicit non-goals for this research track

- Implementing addon Lua/XML
- Changing the approved design spec (research informs; spec remains authority)
- Choosing CurseForge vs Wago packaging (see packaging track elsewhere)
- Retail Midnight API chasing
