# A07 — SavedVariables size and write behavior

**Appendix A item:** 7  
**Owner:** David  
**Result:** NOT RUN

Cited: Bible Appendix A item 7; §13.1 (per-client persistence, no server); §13.5 (Sacred Archive); §12 / Law 7 (history is never deleted); §16 (Chronicle); Audit V6 (account-level store).

## Dependent feature

Records, Chronicle, and Archive export/import. The Pope's store is the single writer (§13.1). The Church's history cannot depend on one SavedVariables file (§13.5): one-action export, restorable import, weekly cold reminder, Council cold mirror.

Appendix A: SavedVariables size and write behavior on the live Anniversary client.

This item does not invent Archive file format, reminder widgets, Grant/standing, or a Chronicle consumption surface.

## Bible fallback

Appendix A item 7 names **no** standalone fallback. The Appendix A closer applies: if size or write behavior fails validation, a design fallback decision happens *before* implementation improvises one.

Do not invent a prune, expiry, or per-character split to "keep SV small." Law 7 / §12.3: Church history is never deleted. Account-level `## SavedVariables: ChurchOfBeefDB` is already law (Audit V6).

Shipped `Core/DB.lua` persist and `Core/Archive.lua` codec are not a pass of live size or write facts.

## Live-client method (Anniversary TBC, Interface 20506)

This client's installed addon, account-level `ChurchOfBeefDB`. `/console scriptErrors 1`. **Agents and this sheet do not touch `WTF/` or the player SavedVariables file.** David may look at the file size himself.

1. **Restore timing.** Fresh login. Record whether in-game `ChurchOfBeefDB` is populated at `ADDON_LOADED` (addon name `ChurchOfBeef`) vs still empty until later. Note schema keys present (`version`, `ui`, `store`, `event`, `decree`) without dumping player contents into this repo.
2. **Write on reload.** Change one harmless persisted value the addon already owns (for example a Decree line via the existing Set path, or a UI position the addon already saves). `/reload`. Record whether the change survived. Do not add a new persist path.
3. **Write on logout.** Repeat a small change, then a full logout/login (not only `/reload`) if available. Record whether the client wrote on logout.
4. **Size.** David records the on-disk size of this account's `ChurchOfBeefDB.lua` after the steps above. Write the number on this sheet. Do not delete records to shrink it. Do not commit the file.
5. **Archive observation (optional).** If an export string is already reachable from the Pope store, record its length vs the SV file size. Do not invent a new export format. Do not import into a second writer.
6. **Write facts on this sheet.** When the client writes, how large the file is, whether `/reload` and logout both persist. No prune. No Grant/standing keys.

Do not change addon Lua from this sheet.

## Not a pass

- Harness green on `test_db` / `test_archive` / `test_store`
- Schema 7 existing in `Core/DB.lua`
- `Archive` encode/decode in desktop Lua
- Account-level TOC `SavedVariables` line alone

## Leftovers

- Archive export file/string format and weekly cold reminder (do not invent)
- Council cold mirror (read-only; not a second writer)
- Chronicle consumption surfaces (§16 later)
- OPEN_QUESTIONS #8 local override table is not this item
