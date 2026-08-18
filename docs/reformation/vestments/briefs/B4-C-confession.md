# B4-C — Private confession inbox (Core)

**Exclusive:** create `addon/ChurchOfBeef/Core/Confession.lua`, `tests/test_confession.lua`

**Do not edit** TOC, `run.lua`, Store, Gora, BeefNet, Toasts. Integrator lists the files after you. Do not commit. Do not persist to SavedVariables. Do not fan-out. Do not invent penance, sin categories, or rewards.

## Law

Bible §9, §13.4. The add-on may organize a queue and capture confession text **privately to the Pope's console**. Free-typed player text never auto-renders in public theater. Software does not write the Pope's response.

Memory-only, event-scoped (same expire idea as Gora petitions: wipe when Runtime is QUIET / no live `eventId`; survive OpenRite / CONSEQUENCE / Continue).

```lua
Confession:Receive(characterId, text)  -- latest text replaces; one row per character
Confession:GetQueue()                  -- copies, oldest-first
Confession:CallForward(characterId)    -- marks called; does not announce
Confession:Dismiss(characterId)
Confession:ResetForTests()             -- _IN_TEST only
```

- `characterId` must be a positive integer id. Unknown-to-Store ids may still queue if Store is missing (desktop); if Store exists and `GetCharacter` is nil for that id, refuse `unknown character`.
- `text` optional. If present must be a string. Empty / whitespace-only → store no text. Embedded `"\n"` → refuse `invalid text`.
- Never write Store / DB / SV. Never call Toasts, Sound, Net, or CreateFrame.
- `CallForward` does not SendChatMessage and does not Proclaim.
- GetQueue copies so mutating a row cannot rewrite the inbox.

## Tests

Isolated: wow_stub + Common + Store + Runtime + Confession. Isolation under `if standalone then`.

Quiet Receive refuses. StartEvent → Receive → GetQueue one row. Latest replaces. Dismiss removes. EndEvent wipes. Continue keeps. CallForward marks without announcing. Newline refused. ResetForTests.

`lua tests/test_confession.lua` exit 0.

Report `docs/reformation/vestments/briefs/B4-C-confession-report.md` + diff.
