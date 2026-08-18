# V-B — Sanction proclamation + verdict seals (stock textures only)

**Exclusive files:**
- `addon/ChurchOfBeef/UI/Toasts.lua`
- `tests/test_ui.lua`

**Do not edit** Console, Decree banner, Records, HUD, Sound, Core, TOC, bootstrap, OPEN_QUESTIONS, REFORMATION_LOG.

**Do not commit.** No custom media. Do not add sound cue names beyond `sanction` / `verdict` / `cowardice` / `elevation` / `knighting` (call `COB.Sound:Play` only; Sound.lua is not yours).

## Law

Bible §19.2–19.4, Law 4, Law 6. Batch 2 §C / §F. CONTINUE V-B.

Theatrical overlay: **center third** of the screen (panel width ≤ ~1/3 of `UIParent`, or ≤ 420px if parent width is unknown). Background dim **≤ 50%** (`SetColorTexture` / `WHITE8X8` black at alpha ≤ 0.5). Congregation (the world) stays visible. Timed beat via `C_Timer.After` (exists on 20506). No close button on sanction/verdict. No permanent `OnUpdate`.

Quiet Mode: if Runtime is missing or `state == "QUIET"`, **refuse** sanction/verdict/cowardice kinds (return false). `system` / `debug` stay as today.

## Kinds to add

```lua
sanction   -- proclamation
verdict    -- victor / void / free
cowardice  -- oxblood stamp
```

Fixed clerical copy only (fill names from fields; never generate oratory):

- Sanction: `A Beef Gora is Sanctioned` plus two names and optional `VS`. Optional stipulation is Pope-authored text already in fields — print it, do not rewrite it.
- Victor: `Victor declared: {name}.`
- Cowardice: `Cowardice recorded: {name}. So ruled by the Beef Pope.`
- Void: `Void.`
- Free: Pope `text` if non-empty, else `Free ruling.`

**Do not** write “Their third meeting”, sermons, or chat oratory. Optional `DEFAULT_CHAT_FRAME:AddMessage` may repeat the **same** clerical line. Never `SendChatMessage`.

No blood spatter. Gold = victory; oxblood = cowardice (tints on stock textures). `Interface\\QuestFrame\\QuestBG` / `WHITE8X8` / tooltip border only.

`Toasts:Proclaim(kind, fields)` (or extend `Celebrate`) builds that copy from `{ fighterA, fighterB, name, ruling, text, stipulation }`. Unknown kinds still do not mint copy.

Call `Sound:Play("sanction"|"verdict"|"cowardice")` when the kind shows **and** Sound exists. If Sound refuses Quiet, still show nothing (you already refused).

Do not wire Console/Gora in this lane. Tests Push/Proclaim directly. Integrator will wrap later.

## Tests (`test_ui.lua`)

Keep existing system/debug / MainFrame pins. Add:

- Proclaim sanction paints both names; dim frame alpha ≤ 0.5; panel not full-screen.
- Cowardice copy is exactly the clerical sentence with the given name.
- Victor / void / free copy as above; free uses Pope text when provided.
- Quiet Runtime → Proclaim returns false; no frame show.
- No `SendChatMessage`. Isolation stays under `if standalone then` if the file uses that wrap.

You may `dofile` Runtime in this suite for the Quiet pin.

## Verify

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_ui.lua
```

Must exit 0. Report `docs/reformation/vestments/briefs/V-B-toasts-report.md` + `V-B-toasts.diff`. **POLISH:CANDIDATE** at most.
