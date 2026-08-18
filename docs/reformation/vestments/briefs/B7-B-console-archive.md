# B7-B — Console Archive, Canonize, Flag Upset

**Exclusive:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

**Do not edit** Store, Archive.lua, Gora. Do not commit. Console stays **stock**. `SaveNote` stays nil. No WHISPER ALL. No post-show ceremony summary. No SUMMON.

## Law

Bible §13.5 one-action Archive export/import. Bible §16 Canonize. §10.9 Famous Upsets are Pope-flagged.

1. **Archive**
   - Stock EditBox `ArchiveBox` + stock `EXPORT ARCHIVE` / `IMPORT ARCHIVE`.
   - `Console:ExportArchive()` → `Archive:Export()`; put blob in the box; if `type(CopyToClipboard)=="function"` pcall it with the blob only (Anniversary Os API). Missing API is OK (box still fills).
   - `Console:ImportArchive(blob)` → `Archive:Check` then `Archive:Import`. Blob from arg or box. Bad blob refuse; do not wipe (Law 7).
   - Pope-gated. Missing Archive module → refuse (isolation keeps Archive nil and stubs).

2. **Canonize**
   - Stock EditBox + `CANONIZE`.
   - `Console:CanonizeMoment(momentId, text)` → `Store:CanonizeMoment`. If `momentId` omitted, use the latest `GetMarkedMoments()` id. Text from box when omitted.

3. **Flag Upset**
   - Stock `FLAG UPSET`.
   - `Console:FlagFamousUpset(characterId, opponentId)` → `Store:FlagFamousUpset`. Default to proposed bout / selected fighters (victor = selected character if set, else fighterA). Never compute an upset.

No Sound on these three. No Toasts. No SendChatMessage.

## Tests

Stub Archive Export/Import/Check. Export fills box. Import calls Check then Import. CopyToClipboard spy optional. Canonize/FlagUpset reach Store when Pope. SaveNote nil. Isolation wrap stays.

`lua tests/test_console.lua` exit 0.

Report `docs/reformation/vestments/briefs/B7-B-console-archive-report.md` + diff.
