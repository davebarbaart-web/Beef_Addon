# Wave 2 plan vs live code (14 Sep 2026)

> **Addendum (same day, after Tasks 1 and 3 landed).** The body below is a *morning* snapshot. Do **not** implement against it as if boot safety and slash/desk are still open.
>
> | Task | Now | Do not undo |
> |------|-----|-------------|
> | 1 Boot safety | **Done.** Every `initUi` Init is `initModule` → `pcall`. Hud throw still reaches `Net:Init`. Chat: `<Name> failed to start.` BackdropTemplate kept. Review: `.superpowers/sdd/task-1-review.md` | Do not unwrap Inits. Do not drop BackdropTemplate without a live 20506 abort. |
> | 2 Leftover honesty | **Done** for the plan’s file list, including guild-night rewrite (Status still NOT RUN). | Do not tick phase Status boxes. Do not mark #11 resolved. |
> | 3 Slash + console gate | **Done.** Unknown args print help (no card toggle). Congregation help has no “Director Console.” Listed Pope second line: desk is `/beef console`. `Show`/`Toggle` do not mint the 560×600 desk unless listed Pope. Verbs still `not a registered pope`. | Do not restore unknown-arg → Toggle pins. |
>
> Tasks 4–14 and Task 15 remain open. Body sections for Tasks 1 and 3, and the “slash still toggles / Show ungated / partial pcall” lines in “Plan assumptions,” are **stale**.
>
> **Addendum (same evening, after Tasks 4–14 landed).** The morning table and “Per-task status” body below are **stale**. Do not implement against them. Live SDD: `.superpowers/sdd/progress.md`. Reviews: `task-N-review.md` (1–13 Approved; 14 in flight). Task 15 is a human two-client walk (`docs/superpowers/plans/2026-09-14-task-15-walk.md`). Do not tick `docs/phases/*`. Do not claim §22.3 / `POLISH:PASS` / MVP. #21 / #26 / #27 stay unanswered.

**Checkout:** `/Volumes/AI_Design_Drive/Beef_Addon` as of 14 Sep 2026.  
**Plan:** `docs/superpowers/plans/2026-09-14-church-of-beef-first-night-wave-2.md`  
**Review:** `docs/superpowers/specs/2026-09-14-church-of-beef-wave-2-review.md`

Read-only comparison. No Lua edited. No product invented. **Harness green is not used as a completeness claim.** Two-client smoke (plan Task 15) is not walked here and is not ticked.

Judgment: **Already done** = every material pin of that task is live. **Partially** = some intended Wave 2 deliverables exist; others do not. **Not started** = live code still matches the pre-Wave-2 failure the plan named (or only satisfies a “do not regress” constraint that was already true).

---

## Per-task status

| Task | Status | Plan stale? |
|------|--------|-------------|
| 1 Boot safety | Partially | Yes — some `pcall`s already exist (Lane T). The pin is not met. |
| 2 Stop lying in leftovers | Partially | Yes — leftover table, README Decree, BeefNet header, `#11`, and zip gitignore already match the plan. Dress rehearsal / guild-night still lie. |
| 3 Slash honesty + console gate | Not started | No |
| 4 Welcome parchment | Not started | No |
| 5 Quiet card copy | Partially | Mild — gold plate already avoids `NEW`; Wave 2 relationship + live Gathering line are absent. |
| 6 Sender-keyed INPUT + unsigned desk | Not started | Mild — pew never calls `EnsureCharacterByName`. Petition / favor still key on payload id. |
| 7 Version drop + PROTOCOL 2 | Not started | No |
| 8 Packed display names + 240-byte pin | Not started | No |
| 9 Latest-wins without dropping favor | Not started | No |
| 10 Login restore + Pope rebroadcast | Not started | Mild — `DB:Init` already does not gate restore on `UnitName`. Login split / snapshot gate / Pope `sendState()` after `InstallWire` are absent. |
| 11 Pope-only Gora persist | Not started | Mild — `SCHEMA_VERSION` is already 7 (plan says stay 7). No `gora` persist. |
| 12 Ask to fight (no Store write) | Not started | No |
| 13 HUD copy | Not started | Mild — free-ruling toast already says `Free ruling.` and never `The Pope ruled.` |
| 14 Pope desk | Not started | No |

Task 15 (two-client smoke) is out of this table. It is not walked. Do not treat any row above as night-ready.

---

## Task 1 — Boot safety — **Partially**

**Plan:** every `initUi` Init in `pcall`; after a forced Hud Init failure, `Net:Init` still runs; one chat line `Church of Beef: <module> failed to start.`; invert Inputs BackdropTemplate pin if inherit is dropped; Hud inherit source pin.

**Live:** `initUi` still runs Minimap / RecordsBook / PlayerCard / Hud **bare**. Console, Toasts, DecreeBanner, Sound, FighterCard, Inputs, Markers are `pcall`’d. `OnLogin` calls `initUi()` then `Net:Init()` — a Hud throw never reaches the net.

```13:60:addon/ChurchOfBeef/ChurchOfBeef.lua
-- UI init lives on the bootstrap now that the Quiet shell is retired (Lane T).
-- Order and guards match the retired UI:Init — Minimap / RecordsBook /
-- PlayerCard / Hud run bare; Console, Toasts, DecreeBanner, Sound,
-- FighterCard, Inputs, and Markers are pcall'd.
local function initUi()
  if COB.Minimap and COB.Minimap.Init then
    COB.Minimap:Init()
  end
  -- ...
  if COB.Hud and COB.Hud.Init then
    COB.Hud:Init()
  end
  if COB.Console and COB.Console.Init then
    pcall(COB.Console.Init, COB.Console)
  end
  -- ...
end

function COB:OnLogin()
  initUi()
  if COB.Net and COB.Net.Init then
    COB.Net:Init()
  end
```

No `failed to start` string in addon Lua. Hud and Inputs still inherit `BackdropTemplate`:

- `UI/Hud.lua`: `CreateFrame("Frame", FRAME_NAME, parent, "BackdropTemplate")`
- `UI/Inputs.lua`: `CreateFrame("Frame", FRAME_NAME, UIParent, "BackdropTemplate")`

`tests/test_inputs.lua` still pins `_template == "BackdropTemplate"`.

**Stale:** the plan writes as if wrapping starts from zero. Partial Lane T wraps are already there. The Wave 2 pin (Hud + chat line + always `Net:Init`) is not.

---

## Task 2 — Stop lying in leftovers — **Partially**

**Plan:** rewrite the v1-checklist leftover table so Console / HUD / Records / favor / Popes / Decree wire are coded; keep dress rehearsal and Appendix A Results as NOT RUN; README “Decree ships”; BeefNet header not “always false until #8”; gitignore `ChurchOfBeef.zip`; do not mark `#11` resolved.

**Already matching the plan**

- `docs/phases/v1-checklist.md` leftover table (lines 233–243) names designated-Council remainder, SUMMON, confession inbox UI, live HUD health, cold-tools UI, two-client smoke. Intro already says favor, Decree wire, STATE, HELLO rebroadcast, petition INPUT are coded; `Data/Popes.lua` ships Thedave.
- `README.md`: “The Decree ships as that Quiet Mode parchment”.
- `Net/BeefNet.lua` header: STATE / SNAPSHOT / DECREE send when the local player is a listed Pope (`Data/Popes.lua` + `popeOverrides`). No “always false until #8”.
- `.gitignore`: `/ChurchOfBeef.zip` and `/addon/ChurchOfBeef.zip`.
- `docs/design/OPEN_QUESTIONS.md` #11: congregation `/beef` is the player card; row is not marked resolved.

**Still lying (plan work remains)**

`docs/phases/dress-rehearsal.md` **Status: NOT RUN** (keep that). The “Honest map” table is still Gate-5 fiction:

| Surface | Live lie in dress-rehearsal.md |
|---------|--------------------------------|
| Quiet Tuesday | “Empty `/beef` shell” |
| Decree | “Console **Post**. Decree on the wire.” leftover |
| Director Console | “**Never shown.** No slash.” |
| BeefNet | “`#8` registered-Pope list. Live STATE paint.” leftover |
| Fight HUD | “**Never `Init`ed.**” |
| `#8` | “`IsRegisteredPope` is always `false`.” |

`docs/phases/guild-night-playtest.md` **Status: NOT RUN** (keep). Body still says favor leftover, “No favor UI appeared (leftover — expected)”, “Console does not call `SendState` today”.

Appendix A leftover *sentences*: A03 / A05 / A06 already say Thedave + `popeOverrides` ship. `docs/validation/A13-login-reload.md` still says “If `#8` is still fail-closed… Do not code `#8`.”

**Stale:** an implementer who rewrites the leftover table, README, BeefNet header, or gitignore is repeating landed work. The remaining honesty work is dress rehearsal + guild-night + A13 sentences.

---

## Task 3 — Slash honesty + console gate — **Not started**

**Plan:** unknown args print help (do not toggle the card); `/beef help` one line; second line `/beef console` only for listed Pope; gate `Console:Show` before `Init()` builds the 560×600 desk.

**Live slash** (`ChurchOfBeef.lua`): no `help` branch. Comment and code: “Unrecognised arguments open the player card.” Bare `/beef` and unknown args call `PlayerCard:Toggle()`. `/beef console` calls `console:Show()` with no Pope check.

`tests/test_wire_glue.lua` still pins the opposite of Wave 2:

```
assert_eq(cardToggles, 2, "unrecognised arguments toggle the player card")
```

`Console:Show` builds on first open:

```1528:1530:addon/ChurchOfBeef/UI/Console.lua
function Console:Show()
  if not self.frame then self:Init() end
```

No `IsRegisteredPope` gate before `Init()`. `InspectProgress` still opens the desk for any local character. Verb refuse string `not a registered pope` already exists (`REFUSE`) — keep that.

---

## Task 4 — Welcome parchment — **Not started**

**Plan:** new `UI/Welcome.lua`, TOC line, `ui.welcomeSeen`, `SCHEMA_VERSION == 7`, first-launch Quiet sheet, no stack on a live Decree.

**Live:** no `Welcome.lua` anywhere. `ChurchOfBeef.toc` has no Welcome entry. `Core/DB.lua` `defaultUi()` is `{ point = nil, shown = false, announce = true }` — no `welcomeSeen`. `SCHEMA_VERSION = 7` already (constraint, not this task). No `tests/test_welcome.lua` in `tests/run.lua`.

---

## Task 5 — Quiet card copy — **Partially**

**Plan:** gold plate is a Church title or live guild rank; newness is `The Pope has not written you yet. That is normal.`; do not paint `NEW`; when Runtime ≠ QUIET, Gathering line (and minimap tooltip if shown) says the gathering has started; keep `CHURCH RECORDS`.

**Live `UI/PlayerCard.lua` `COPY`:**

```lua
unrecorded = "UNRECORDED",
unrecordedLine = "Not yet in the Church's record.",
unranked = "UNRANKED",
unrankedLine = "Recorded, no rank yet.",
records = "CHURCH RECORDS",
noDecree = "No gathering is posted.",
```

No `NEW` token in this file. Guild-rank gold plate exists (`string.upper(model.guildRank)` + `Guild rank.`). Unguilded / unstored still paints **`UNRECORDED` on the gold plate** — the Wave 2 review’s fake-rank failure, not the new relationship line.

Gathering plate paints the posted Decree line only. No Runtime live check. Minimap tooltip names the Decree when posted; it does not say the gathering has started.

**Stale:** “do not paint NEW” is already true. The Wave 2 copy string and live Gathering line are not.

---

## Task 6 — Sender-keyed INPUT + unsigned desk — **Not started**

**Plan:** INPUT ignore payload `characterId`; key by `Names.Key(sender)`; unsigned name-key rows; unknown opponent ignored (not `unknown opponent`); no congregation `Ensure`; no `#26` resolution.

**Live pew bind** already does **not** mint. `bindLocalCharacter` walks existing `Store:Snapshot().characters` and sets Hud/Inputs ids on a name match. No `EnsureCharacterByName` in `ChurchOfBeef.lua`. Console still uses `EnsureCharacterByName` as the **Pope target-verb** spine (lawful; not this task).

**Live apply still refuses zip-fresh:**

`Net:_HandlePetition` resolves opponent by store name; miss → `"unknown opponent"`. Then `Gora:Petition(decoded.characterId, namedOpponentId)`.

```244:255:addon/ChurchOfBeef/Core/Gora.lua
function Gora:Petition(characterId, namedOpponentId)
  -- ...
  if not knownCharacter(characterId) then return nil, "unknown character" end
  if namedOpponentId ~= nil then
    -- ...
    if not knownCharacter(namedOpponentId) then return nil, "unknown opponent" end
```

`Net:_HandleFavor` → `Gora:RecordFavor(decoded.characterId, pick)` which writes `favorPicks[characterId]` (payload id). `_HandleConfession` still uses `decoded.characterId`.

`Gora:GetPetitions(presentAndAlive)` only returns store ids present in that table. `Console:GetPetitions()` passes `presentCharacterIds()`. No unsigned name-key row.

**Stale:** the plan’s “invert pew Ensure” pin describes a Wave 1 license that this checkout never shipped. The work (sender key, unsigned desk, ignore unknown opponent) has not started. `#26` is still open in `OPEN_QUESTIONS.md`.

---

## Task 7 — Version drop + PROTOCOL 2 — **Not started**

**Plan:** `Codec.PROTOCOL = 2`; skew drops Event chrome to Quiet and shows the §13.4 sentence once; invert chaos / v2 “skew does not drop” pins; no clerical kind.

**Live:** `Net/Codec.lua` `PROTOCOL = 1`. `Net/BeefNet.lua` `PROTOCOL = 1`. `STATE_KEYS` / `SNAPSHOT_RES_KEYS` have no `names` field. Extra colon part still `"unknown field"`.

`_WarnVersion` chat is:

```
a guildmate is running BeefNet v%s; this client speaks v%d. Update for matching addon messages.
```

Not the Bible §13.4 “the Church's software has advanced” Quiet notice. Mismatch returns `"protocol mismatch"` and does **not** force Runtime QUIET / hide Event chrome.

Harness still pins the opposite of Wave 2:

- `tests/test_net_codec.lua`: `Codec.PROTOCOL == 1`
- `tests/test_net_v2.lua`: `Net.PROTOCOL == 1`; `"version skew does not drop the live event"`
- `tests/test_ceremony_chaos.lua`: `"version skew does not drop the live rite"`

---

## Task 8 — Packed display names + 240-byte pin — **Not started**

**Plan:** packed fighter / candidate names; fail-closed on `:`; pin `#payload <= 240` through `Net:Send`; inbound stash; Snapshot allowlist; congregation HUD names in ASSEMBLY; fighter card must not re-show on post-verdict RITE + lastPair.

**Live Codec / Snapshot:** subjects are store integer ids only (`encodeSubjects` / `parseSubjects`). No names overlay. `Snapshot:ApplyResponse` Restores Bible fields only (`eventId`, `state`, `riteType`, `subjects`, `sequence`).

`ChurchOfBeef.lua` `stateFields()` overlays fighter **ids** from `GetSanctioned` / `GetLastSanctioned`. No name stash / `lastCast`.

Hud `livePair()` uses `GetSanctioned()` else Runtime fighters **only when `state == "RITE"` and `riteType == "Gora"`**. ASSEMBLY sanction (Pope already sanctions in ASSEMBLY) does **not** paint a congregation pair from Runtime subjects.

Inbound `_HandleState` wrap: self-echo skip exists for the Pope card, but congregation still `showFighterCard()` whenever STATE is not QUIET/CONSEQUENCE and fighters exist — including post-verdict **RITE + lastPair** (the night-one tape-back the review named).

---

## Task 9 — Latest-wins without dropping favor — **Not started**

**Plan:** ceremony apply only if `sequence` is **greater**; favor overlay when `eventId` matches and `sequence >= current`; different `eventId` still applies; equal seq must not fire theater; invert chaos rewind pin.

**Live:** `Net:_HandleState` always `Runtime:Restore({...})` with no sequence compare. `Runtime:Restore` replaces the event object. `Snapshot:ApplyResponse` is the same Restore. Favor is not applied on Restore (`Snapshot.lua`: “favor stays off Restore”). Favor paint is a separate inbound Hud overlay in bootstrap — not the Task 9 overlay rule.

`RecordFavor` wrap sends STATE but does not increment Runtime sequence (`Gora:RecordFavor` only writes `favorPicks`). The review’s “seq > current drops every favor STATE” hole is still live.

---

## Task 10 — Login restore + Pope rebroadcast — **Not started**

**Plan:** do not gate `restoreEventFromSv` on `UnitName` in `DB:Init`; on `PLAYER_LOGIN`, non-Pope Restore QUIET / skip SV event **before** `initUi`; Pope keeps the event; `RequestSnapshot` only after accepted Pope HELLO or live STATE this session, local still QUIET, once per login; if local Pope and Runtime ≠ QUIET after `InstallWire`, `sendState()` once.

**Live `DB:Init`:** restores store, then event, then decree. **No `UnitName` gate** (the forbidden Wave 1 move is already absent).

**Live `OnLogin`:** `initUi()` → `Net:Init()` → `InstallWire()`. No congregation skip. No Pope `sendState()` after wire. `RequestSnapshot` exists on `Net` but has **zero callers** in addon Lua.

HELLO rebroadcast already exists (`COB._OnPeerHello` → listed Pope `sendState()`). That is not the login `/reload` rebroadcast in Task 10.

**Stale:** “do not gate restore on UnitName” is already true. The login split and Pope-after-wire send are not.

---

## Task 11 — Pope-only Gora persist — **Not started**

**Plan:** Gora Snapshot/Restore of sanctioned, petitions (including unsigned keys), favorPicks, lastSanctioned, eventId; `SCHEMA_VERSION` stays 7; restore after event restore; Pope-only Save/Restore; C_Timer debounce with logout fallback.

**Live `Core/Gora.lua`:** no `Snapshot` / `Restore`. Memory-only `sanctioned` / `petitions` / `favorPicks`. Verdicts still refuse `no sanctioned gora` after process death — the review’s desk hole.

`Core/DB.lua` header: schema 7 is `{ version, ui, store, event, decree }`. No root `gora`. `SCHEMA_VERSION = 7` already.

`wow_stub.lua` has **no `C_Timer`** (plan assumption still true).

---

## Task 12 — Ask to fight — **Not started**

**Plan:** face **Ask to fight**; header not `EVENT INPUT`; hide strip on listed Pope; dest line and send dest share Net `defaultDest()`; reasons: not in a guild / send failed / already asked / Knighting not a fight; success → asked/waiting; no Store mint.

**Live `UI/Inputs.lua`:**

- Header: `"EVENT INPUT"`. Button: `"Petition"`.
- `tests/test_inputs.lua` pins `"EVENT INPUT"` and **forbids** `IsRegisteredPope` in source (Wave 2 must invert).
- Enabled only when `eventLive()` **and** `localCharacterId` is a number **and** (bound target or `Popes.List[1]`). Zip-fresh with empty store never gets an id (`bindLocalCharacter` miss) → Petition stays disabled (`no character`).
- Dest **line** is bound target else `Popes.List[1]`, not `Net._lastStateSender`. Send already falls through `Net:SendPetition` → `resolveDest` / `defaultDest()`. Display and send helpers are not the same.
- No hide-on-Pope. No not-in-guild / send-failed / already-asked / Knighting copy. No asked/waiting state.
- Still inherits `BackdropTemplate`.

No congregation Store mint on this path (id is lookup-only). That is the starting refuse path, not an Ask-to-fight strip.

---

## Task 13 — HUD copy — **Not started**

**Plan:** hover “Click to pick this side.”; footer **Pick a side** before first pick; `Void.` → “This fight does not count.”; cowardice headline must say fled; sanction: one plain “sanctioned duel” line; no “The Pope ruled.”; HUD after a ruling reads as ruled until Continue.

**Live Hud:** no `OnEnter` / `GameTooltip` / “Click to pick” / “Pick a side”. Favor footer is `FAVOR`. `livePair` / `pickPair` ignore ASSEMBLY Runtime fighters (see Task 8).

**Live `UI/Toasts.lua` `clericalCopy`:**

- Sanction headline: `"A Beef Gora is Sanctioned"` (review: still pomp).
- Cowardice: `"Cowardice recorded: " .. name .. ". So ruled by the Beef Pope."` — does not say fled.
- Void: `"Void."`
- Free: `"Free ruling."` when text missing — **already** avoids “The Pope ruled.”
- Victor body still: `"So ruled by the Beef Pope."`

Inbound Proclaim / Sound stay Pope-local wraps. Congregation inbound fire is still `#27` (out of slice). Do not treat toast copy as two-client proof.

**Stale:** only the free-ruling refuse (“do not say The Pope ruled”) is already true.

---

## Task 14 — Pope desk — **Not started**

**Plan:** listed-Pope card door **or** `/beef` help already told him; `PHASE_HINT` names the next verb; `after()` paints refuse on `GateStatus`; petition row fills next empty Fighter A/B (or “use this petitioner”); pair name buttons select only; `DECLARE VICTOR` commits; invert `PairVictor` → `DeclareVictor`.

**Live**

- `UI/PlayerCard.lua`: no Console control, no `/beef console` door.
- Slash: listed Pope’s bare `/beef` opens **his card**, same as congregation. Help does not mention the desk. `/beef console` works if he already knows it.
- `PHASE_HINT` names the rite, not the next click:

```65:74:addon/ChurchOfBeef/UI/Console.lua
local PHASE_HINT = {
  QUIET = "No gathering is live.",
  ASSEMBLY = "Gathering live — no rite open.",
  RITE = "Rite open.",
  CONSEQUENCE = "Consequence — rule, then continue.",
}
```

- `after()` refreshes only on success; refusals (`start from quiet`, `event ends from assembly or consequence`, `Set Fighter A and Fighter B first`) are not painted. `GateStatus` only shows `not a registered pope`.
- Petition row click is `SelectCharacter` only — does not fill Fighter A/B.
- `PairVictorA` / `PairVictorB` call `Console:DeclareVictor(self._cobVictorId)` immediately. Names **are** the verdict.

```1449:1462:addon/ChurchOfBeef/UI/Console.lua
frame.PairVictorA = verb("", function(self)
  Console:DeclareVictor(self._cobVictorId)
end, 140)
-- ...
frame.DeclareVictor = verb("DECLARE VICTOR", function() Console:DeclareVictor() end)
```

Unsigned petition names cannot appear until Task 6 exists.

---

## Plan assumptions that are already true (do not “implement” them)

These are constraints / leftovers the checkout already satisfies. They do not make Tasks 1–14 done.

| Assumption | Live |
|------------|------|
| `SCHEMA_VERSION` stays 7 | `Core/DB.lua` `SCHEMA_VERSION = 7` |
| No congregation pew `EnsureCharacterByName` | Bootstrap bind is lookup-only |
| `restoreEventFromSv` not gated on `UnitName` in `DB:Init` | True |
| `#11` is the player card; do not mark resolved | True |
| `#26` / `#27` unanswered | Still open |
| `wow_stub.lua` has no `C_Timer` | True |
| `wow_ui_stub` accepts `BackdropTemplate` | Tests still pin inherit; not client proof |
| Interface `20506` | TOC `## Interface: 20506` |
| Verb refuse `not a registered pope` | Console `REFUSE` |
| `CHURCH RECORDS` not renamed | True |
| No `NEW` title word on the card | True |
| Free-ruling toast is `Free ruling.` | True |
| v1 leftover table / README Decree / zip gitignore / BeefNet `#8` header | Already honest (Task 2 remainder is other docs) |

---

## Plan assumptions that are still accurate (work remains)

- `Codec.PROTOCOL` / `Net.PROTOCOL` are **1**.
- `Gora:Petition` still returns `unknown character` / `unknown opponent`.
- INPUT handlers still pass `decoded.characterId`.
- No `UI/Welcome.lua`. No `welcomeSeen`.
- No Gora Snapshot/Restore. Pope `/reload` still loses the sanctioned pair.
- `OnLogin` does not split congregation / Pope restore and does not `sendState()` after `InstallWire`.
- `RequestSnapshot` is never called from bootstrap.
- Slash unknown args still toggle the card (`test_wire_glue.lua` pins it).
- `Console:Show` is ungated; `PairVictor*` still declare; `PHASE_HINT` is rite copy; `after()` swallows refuses.
- Inputs still `EVENT INPUT` / Petition; tests forbid `IsRegisteredPope`.
- Version-skew tests still pin “does not drop the live event.”
- Dress rehearsal + guild-night leftover sentences still describe a Gate-5 skeleton.
- Inbound names, PROTOCOL 2, 240-byte Send pin, latest-wins favor overlay: absent.

---

## File map vs disk

| Plan file | Live 14 Sep 2026 |
|-----------|------------------|
| `UI/Welcome.lua` | Missing |
| `ChurchOfBeef.toc` Welcome line | Missing |
| `tests/test_welcome.lua` | Missing |
| `Net/Codec.lua` `PROTOCOL = 2` | Still `1` |
| `Core/DB.lua` `ui.welcomeSeen` / root `gora` | Absent; version 7 |
| `Core/Gora.lua` Snapshot/Restore | Absent |
| `ChurchOfBeef.lua` `initUi` all-pcall + login split + name stash + desk door | Partial pcall only; rest absent |
| `.gitignore` `ChurchOfBeef.zip` | Present |

---

## How to use this

Implement remaining Wave 2 tasks (4–14) against the **plan + addendum**, not the stale Task 1/3 body below. Skip leftover-table / README / gitignore / BeefNet-header rewrites unless those files regress. Do not invert “pew Ensure” — it is not in live bootstrap. Do not unwrap `initModule` / restore unknown-arg Toggle. Do not bump schema to 8. Do not resolve `#26` / `#27`. Do not tick Task 15 or `docs/phases/*` from this document or from `lua tests/run.lua`.
