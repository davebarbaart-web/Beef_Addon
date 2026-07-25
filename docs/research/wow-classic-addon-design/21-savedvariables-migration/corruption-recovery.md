# Corruption and recovery

**Track:** [21 README](README.md)  
**Primary sources:** [WoWUIBugs #241](https://github.com/Stanzilla/WoWUIBugs/issues/241), [Saving variables between game sessions](https://warcraft.wiki.gg/wiki/Saving_variables_between_game_sessions), [SavedVariables](https://warcraft.wiki.gg/wiki/SavedVariables), Blizzard / WoWInterface restore threads

---

## 1. Failure modes (observed in the ecosystem)

| Mode | Symptoms | Likely cause |
|------|----------|--------------|
| Empty SV file | Addon resets to defaults | Interrupted write / crash / kill ([WoWUIBugs #241](https://github.com/Stanzilla/WoWUIBugs/issues/241)) |
| NUL-padded / truncated Lua | Parse failure or empty table | Partial disk write (WeakAuras sample attachment on #241) |
| Good `.bak` destroyed | Yesterday’s backup also bad | Client overwrites `.bak` from today’s broken `.lua` on next logout (#241) |
| Constant table overflow / NaN | Load error; possible `.bak` fallback loops | Oversized or invalid serialized values (Meorawr commentary on #241) |
| Wrong-path `SavedVariables.lua` | Settings never stick | Misplaced Blizzard SV file shadowing account path ([SavedVariables](https://warcraft.wiki.gg/wiki/SavedVariables)) |
| TOC scope change | “Lost everything” after update | Author moved Account ↔ PerCharacter without migration |
| Force-close / power loss | Missing last session’s changes | No mid-session flush ([Saving variables…](https://warcraft.wiki.gg/wiki/Saving_variables_between_game_sessions)) |

Blizzard engineers noted additional flush precautions after #241; community still reports rare corrupt saves afterward — design for loss.

---

## 2. Author-side hardening (persistence hygiene)

These reduce *how often* CoB eats itself; they do not eliminate client write bugs.

1. **Keep the SV file small.** Ladder cache = coarse records, not combat logs. Cap local event log length (My Standing). Huge SV files correlate with painful writes (WeakAuras scale war stories on #241).
2. **Batch mutations.** Prefer updating in-memory tables on meaningful events; rely on natural write boundaries. Avoid patterns that encourage megabyte dumps every logout.
3. **Validate on load.** After `ADDON_LOADED`, type-check critical fields (ladder map is a table; revision is a number ≥ 0; rank id ∈ 1..7). On failure: quarantine bad subtree, keep the rest, mark `needsSync = true`.
4. **Never store non-serializable types** (frames, functions) — silent drop on save looks like “random” loss ([Saving variables…](https://warcraft.wiki.gg/wiki/Saving_variables_between_game_sessions)).
5. **Identity stamp.** Store realm + character + guild name (or club id if available on target client) in `meta`. If stamp mismatches current session, clear local standing / suggestions; keep ladder cache only if guild identity still matches.
6. **Schema guard.** Unknown future schema → soft warn + read-only church data until upgrade (avoid clobbering newer files).

There is no public `SAVED_VARIABLES_ERROR` event today (#241 wish-list). Authors detect corruption indirectly (nil root, wrong types, checksum if you add one).

---

## 3. Recovery playbooks

### A. Single member — UI prefs / frame position lost

1. Reposition UI; `/reload` once to confirm write.
2. Optional later: import UI export string.
3. No BeefNet involvement.

### B. Single member — ladder looks empty or ancient

1. Confirm addon enabled and guilded.
2. Wait for login sync (spec §8.3); do not spam.
3. If peers online with higher revisions, cache refills.
4. If **no** peers online: keep empty/stale UI; officer login later heals the network.
5. Manual WTF restore only if they also lost local standing log they care about — ladder itself should not require it.

### C. Suspected file corruption (errors on load / BugSack)

1. Exit WoW completely.
2. Rename `ChurchOfBeef.lua` (and `.bak`) aside — do not delete yet.
3. If an external dated WTF backup exists, restore that file only.
4. Else boot with fresh nil SV; let sync rebuild ladder; accept local standing loss.
5. If errors persist with empty SV, the bug is code, not data.

### D. Whole WTF wiped / new PC

1. Reinstall addons into correct client tree.
2. CoB: empty per-character DB → sync from guild.
3. UI packs: restore WTF backup or re-import profile strings ([ElvUI export](https://github.com/tukui-org/ElvUI/wiki/export)).

### E. Officer machine dies

Highest operational risk: officers hold freshest commits (spec §8.3). Mitigation is **social redundancy**, not fancier SV:

- ≥2 officers run the addon regularly.
- Prefer commits that already propagated to several members before the officer’s disk dies.
- Optional process: officers keep a dated WTF backup of their main.

---

## 4. What recovery must not do

- **Silent full wipe of peers** when one client has empty SV — empty is not authoritative; revisions still win.
- **Trust a pasted ladder string** over officer commits.
- **Auto-apply** hand-edited standing as official rank.
- **Block gameplay** if SV missing — empty-state ladder UI (spec §11) and continue.

---

## 5. QA checklist (persistence)

Use alongside track 19 (testing) when that track lands:

- Fresh install → defaults; schema = CURRENT.
- Upgrade fixture with schema N−1 → migrates; no loss of ladder revisions.
- Delete SV mid-campaign → login sync restores official ranks from peer.
- `/reload` preserves frame position.
- Hard-kill client after granting local standing → document lossy window (expected).
- Wrong-guild character → local standing cleared or ignored; no cross-guild ladder bleed (Dreamscythe vs Doomhowl independence — spec §5).
