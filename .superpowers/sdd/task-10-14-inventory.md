# Wave 2 Tasks 10–14 inventory

**Checkout:** `/Volumes/AI_Design_Drive/Beef_Addon`  
**Date:** 2026-09-14  
**Kind:** read-only file:line facts. No addon Lua edited.  
**Plan:** `docs/superpowers/plans/2026-09-14-church-of-beef-first-night-wave-2.md` Tasks 10–14  
**Hazard note (Task 11):** `docs/superpowers/plans/2026-09-14-shared-account-sv.md`

Task 3 already landed: listed-Pope slash help names `/beef console`, and `Console:Show` / `Toggle` refuse to mint the desk for a non-Pope. Do not undo that while doing Task 14.

Paths below are under `addon/ChurchOfBeef/` unless a `tests/` prefix is given.

---

## Task 10 — Login restore + Pope rebroadcast

**Plan pins:** do not gate `restoreEventFromSv` on `UnitName` inside `DB:Init`; on `PLAYER_LOGIN`, non-Pope Restore QUIET / skip SV event **before** `initUi`; Pope keeps the restored event; `RequestSnapshot` only after accepted Pope HELLO or live STATE this session, local still QUIET, once per login; if local Pope and Runtime ≠ QUIET after `InstallWire`, `sendState()` once.

### `DB:Init` — always restores event for whoever loads

`Core/DB.lua:4-11` documents schema 7 as `{ version, ui, store, event, decree }`. Event Restore runs when `state` is a string; empty `{}` / missing does not Restore.

`Core/DB.lua:15` `SCHEMA_VERSION = 7`.

`Core/DB.lua:33-40` `defaultDb()` keys: `version`, `ui`, `store`, `event`, `decree`. No `gora`.

`Core/DB.lua:52-69` `applyDefaults` ensures those same keys. No `UnitName`. No `IsRegisteredPope`. No `welcomeSeen` fill here (still absent).

`Core/DB.lua:84-87` `isEventSnapshot` = `type(event) == "table" and type(event.state) == "string"`.

`Core/DB.lua:111-116` `restoreEventFromSv(db)`: if Runtime has `Restore` and the SV event is snapshot-shaped, `runtime:Restore(db.event)`. No role check.

`Core/DB.lua:151-162` `DB:Init(_now)`:

1. Create `ChurchOfBeefDB` or `applyDefaults`.
2. `restoreFromSv` (store).
3. `restoreEventFromSv` (event).
4. `restoreDecreeFromSv` (decree).
5. Return `ChurchOfBeefDB`.

`_now` is unused. Comment at `Core/DB.lua:151`: call only from `ADDON_LOADED` — SV is not ready at file load.

**Confirmed: no `UnitName` gate inside `DB:Init`.** `Core/DB.lua` has zero matches for `UnitName`, `IsRegisteredPope`, `Sender`, or `player`. `tests/test_db.lua:1094` pins `DB.IsRegisteredPope == nil`.

Do **not** add a `UnitName` check here. `ADDON_LOADED` is too early; the Pope would skip his own restore (`docs/superpowers/plans/2026-09-14-shared-account-sv.md` §3 / Task 10 brief).

### Who calls Init

`ChurchOfBeef.lua:6-10` `COB:OnLoad()` → `COB.DB:Init()`.

`ChurchOfBeef.lua:578-590` frame: `ADDON_LOADED` + `ChurchOfBeef` → `OnLoad`; `PLAYER_LOGIN` → `OnLogin`; `PLAYER_LOGOUT` → `OnLogout`.

### Event restore is everyone, including pew

`tests/test_db.lua:718-765`: Save a live `RITE` + `Gora` snapshot, `ResetForTests` Runtime to QUIET, `DB:Init()` → Runtime is `RITE` again. No Pope predicate in that path.

`tests/test_db.lua:132` pins fresh root keys `"decree,event,store,ui,version"`.

Congregation starting QUIET at login is **not** implemented. `OnLogin` never Restores QUIET and never skips `db.event`.

### `OnLogin` — no restore split, no snapshot ask, no self-send

`ChurchOfBeef.lua:48-54`:

```
initUi()
COB.Net:Init()
self:InstallWire()
```

No `IsRegisteredPope`. No `Runtime:Restore({ state = "QUIET", ... })`. No skip of leftover `ChurchOfBeefDB.event`. No `RequestSnapshot`. No `sendState()` after the wire.

`initUi` is `ChurchOfBeef.lua:34-46` (pcall every UI Init — Task 1). Theater frames Init against whatever Runtime `DB:Init` already Restored.

### `sendState` exists; it is not called at the end of `InstallWire`

`ChurchOfBeef.lua:172-177` `sendState()`: skip if `_inspecting`; `pcall(Net.SendState, Net, stateFields())`.

`ChurchOfBeef.lua:392-576` `InstallWire`:

- Idempotent via `_wireInstalled` (`392-394`).
- Wraps Runtime / Gora / Knighting / Console / Decree / Store verbs so **later** writes send STATE.
- Ends with `bindLocalCharacter()` (`559`) then assigns `COB._OnPeerHello` (`565-574`).
- **No** `sendState()` after those two lines.

Pope `/reload` with a restored live event therefore does **not** rebroadcast until someone clicks a wrapped verb or a guildmate HELLO fires `_OnPeerHello`.

### HELLO rebroadcast is not the Task 10 login send

`ChurchOfBeef.lua:565-574` `_OnPeerHello`: no-op unless Runtime snapshot `state` is a non-`QUIET` string **and** `Sender:IsRegisteredPope(UnitName("player"))`. Then `sendState()`.

`Net/BeefNet.lua:568-586` `HandleHello`: after peer HELLO (not self), `pcall(COB._OnPeerHello, sender)`.

`tests/test_wire_glue.lua:441-457` pins live-event + listed Pope HELLO sends STATE; QUIET does not.

That is catch-up for a **peer** HELLO, not “after `InstallWire` on login.”

### `RequestSnapshot` — Net API only; bootstrap never calls it

`ChurchOfBeef.lua` has **zero** `RequestSnapshot` tokens.

`Net/BeefNet.lua:16-21` header: `RequestSnapshot` is congregation whisper, not Pope-gated; blank dest → last accepted STATE sender, then `Popes.List[1]`.

`Net/BeefNet.lua:97-115` `defaultDest` / `resolveDest`.

`Net/BeefNet.lua:498-517` `Net:RequestSnapshot(target, nowSeconds)`: `resolveDest` → `Snapshot:Request()` or `Codec:EncodeSnapshot({ role = "request" })` → `_TransmitWhisper`.

`Net/BeefNet.lua:876-909` `Net:Init`: prefix, addon/roster events, `RequestRoster`, `SendHello`. **No** `RequestSnapshot`.

`Net/Snapshot.lua:83-87` `BuildResponse`: `Runtime:Snapshot().state == "QUIET"` → `nil, "no event"`. A Tuesday whisper to `List[1]` while QUIET is a no-response, not a restore. Plan: do not add that Tuesday ask.

`UI/Inputs.lua` also never calls it (`tests/test_inputs.lua:198` source-forbids `RequestSnapshot`).

`tests/test_net_v2.lua:601-627` pins RequestSnapshot as un-gated whisper when a dest exists; `607-609` no dest → `false, "no target"`.

### Task 10 gap list (still open)

| Pin | Live |
|-----|------|
| No `UnitName` in `DB:Init` | Already true. Keep it. |
| Pew: skip/Restore QUIET **before** `initUi` | Absent |
| Pope keeps SV event | Happens for everyone today (too much, not too little) |
| Gated `RequestSnapshot` (HELLO/STATE this session, local QUIET, once) | Zero callers |
| Pope `sendState()` once after `InstallWire` if ≠ QUIET | Absent |
| Decree leftover (#113) | `restoreDecreeFromSv` still runs for everyone in `Init`. Plan: prefer not expanding |

---

## Task 11 — Pope-only Gora persist

**Plan pins:** `Gora:Snapshot` / `Restore` of `sanctioned`, petitions (incl. unsigned name-keys), `favorPicks`, `lastSanctioned`, `eventId`; schema stays 7; restore **after** event; Pope-only Save/Restore; `ResetForTests` must not Save.

### Gora has no Snapshot / Restore

`Core/Gora.lua` public functions (no `Snapshot`, no `Restore`):

`_Expire` `130`, `_Prune` `174`, `Challenge` `195`, `Cancel` `215`, `IsChallenged` `225`, `GetPending` `232`, `Petition` `244`, `Dismiss` `263`, `GetPetitions` `270`, `Recommend` `285`, `Sanction` `313`, `GetSanctioned` `339`, `GetLastSanctioned` `344`, `Propose` `353`, `GetProposal` `365`, `DeclareVictor` `420`, `CowardiceRecorded` `434`, `Void` `448`, `FreeRuling` `461`, `RecordFavor` `479`, `GetFavor` `492`, `GetFavorSplit` `501`, `GetLastFavorSplit` `506`, `ResetForTests` `512`.

`Core/Gora.lua:16-23`: `favorPicks` “Never SV / Store / Archive”; `lastSanctioned` “Memory only. Never SV.”

Verdicts refuse `"no sanctioned gora"` when `self.sanctioned` is nil (`420-422`, `434-436`, `448-450`, `461-463`, `479-481`). After `/reload`, memory is empty even if Runtime Restored `RITE`.

`Net/Snapshot.lua:83-132` is **wire** catch-up (`Runtime:Snapshot` + `GetSanctioned` / `GetLastSanctioned`). It is not Gora persist and does not write `ChurchOfBeefDB`.

### DB has no `gora` root

`Core/DB.lua:4`, `33-40`, `66-68`, `164-172`: roots are `version`, `ui`, `store`, `event`, `decree` only.

`tests/test_db.lua:132` `rootKeys` == `"decree,event,store,ui,version"`.

`tests/test_db.lua:141` `ChurchOfBeefDB.store.gora == nil` (store hook is not a Gora schema). Per-character `character.gora` inside Store snapshots is a **record ledger**, not the live desk.

If Task 11 adds root `gora`: `applyDefaults` / `ensureTable`, update `rootKeys`. **Do not stamp schema 8.** Empty `{}` must not replace live memory (same gate shape as event/decree).

### Restore order today (and why gora must be second)

`DB:Init` order: store → **event** → decree (`158-160`).

`Gora:_Expire` `Core/Gora.lua:130-138`: if `liveEventId()` is nil (Runtime `QUIET` or no `eventId`), wipe `petitions`, `sanctioned`, `proposal`, favor, last pair.

`liveEventId` `Core/Gora.lua:84-90`: `Runtime:Snapshot()`; nil if missing, `state == "QUIET"`, or `eventId` not a ≥1 integer.

If a future `gora` Restore runs **before** event Restore, the next `_Expire()` (any getter/verb) sees QUIET and clears the pair.

### Where `ResetForTests` would accidentally Save

**Today nothing in ResetForTests calls `DB:Save`.** The only addon `DB:Save` caller is `ChurchOfBeef.lua:56-59` `OnLogout`.

`DB:Save` `Core/DB.lua:165-173`: if `ChurchOfBeefDB` is a table, `applyDefaults`, then `snapshotToSv` + `snapshotEventToSv` + `snapshotDecreeToSv`. Unconditional on whoever is logged in. No Pope gate. Adding `db.gora = Gora:Snapshot()` here without a Pope gate is the shared-account wipe (`shared-account-sv.md` §3).

`wrapAfter` `ChurchOfBeef.lua:298-308`: runs `afterFn` when `orig(...)` returns **`result ~= nil`**.

These test resets all return **`true`** when `COB._IN_TEST`:

| Module | Line | Returns |
|--------|------|---------|
| `Gora:ResetForTests` | `Core/Gora.lua:512-520` | `true` (clears pending/petitions/sanctioned/proposal/favor/last) |
| `Store:ResetForTests` | `Core/Store.lua:185-188` | `true` |
| `Runtime:ResetForTests` | `Core/Runtime.lua:175-178` | `true` |
| `Net:ResetForTests` | `Net/BeefNet.lua:912-929` | `true` |
| `Console:ResetForTests` | `UI/Console.lua:1583-1598` | `true` |
| `Inputs:ResetForTests` | `UI/Inputs.lua:401-410` | `true` (comment `15-16`: does **not** wipe SV) |

`Gora:ResetForTests` does **not** call `_Expire`, `Sanction`, `Snapshot`, or `Save`. It assigns fields and local wipes. Accidental Save happens only if Task 11:

1. `wrapAfter(COB.Gora, "ResetForTests", saveFn)` — `true` fires the wrap.
2. Loops `pairs(Gora)` / all public methods and wraps `ResetForTests` with the write-path Save.
3. Puts `Gora:Snapshot()` into `DB:Save` with no Pope gate, then a suite calls `ResetForTests` then `DB:Save()` (the harness already calls `DB:Save()` directly — Task 11 brief).
4. Wraps `Gora:_Expire` with Save: ResetForTests itself would not fire it, but the next `GetSanctioned` after a pew QUIET login would Save an empty desk over the shared file.

`DB` has **no** `ResetForTests`.

Safe wrap targets for “successful writes”: `Sanction`, `Petition`, `Dismiss`, `RecordFavor`, `DeclareVictor`, `Void`, `FreeRuling`, `CowardiceRecorded`, Runtime verbs, Store writers — **exclude** every `ResetForTests`, and do not Save from `_Expire` on a congregation QUIET client.

### Persist debounce / stub

Plan: `if C_Timer and C_Timer.After then` else write-path / `PLAYER_LOGOUT`. `wow_stub.lua` has no `C_Timer` (freshness + Task 11 brief). Tests must still call `DB:Save()` directly.

---

## Task 12 — Ask to fight (no Store write)

**Plan pins:** face **Ask to fight**; header not `EVENT INPUT`; hide strip on listed Pope (`IsRegisteredPope`); dest line and send dest share `Net` `defaultDest()`; fireable reasons; asked/waiting after send; do not mint `localCharacterId` via Store.

### Face / header strings

`UI/Inputs.lua:236-251` build:

| Widget | String | Line |
|--------|--------|------|
| Header | `"EVENT INPUT"` | `238` |
| Empty dest | `"No recipient"` | `243` |
| Button | `"Petition"` | `246` |
| Tooltip title | `"Petition"` | `251` |
| Tooltip body | `"Request consideration for a Beef Gora. Your selected player is included when eligible."` | `251` |

Dest paint `UI/Inputs.lua:80-82`: `To: ` .. bound target **or** `listedPope()`, else `"No recipient"`.

`tests/test_inputs.lua:188, 204, 224` pin `"Petition"` and `"EVENT INPUT"`. Invert those when the face changes.

No `"Ask to fight"`, no asked/waiting copy, no not-in-guild / send-failed / already-asked / Knighting reason strings. `UI/Inputs.lua` has zero `IsInGuild` / `already asked` / `Knighting` tokens.

### `eventLive` keeps the strip up during Knighting

`UI/Inputs.lua:96-101`: live iff Runtime snapshot exists and `state ~= "QUIET"`. Any ASSEMBLY / RITE (Knighting included) / CONSEQUENCE shows the strip (`375-379`, `388-393`). Plan #107 can land here.

`readyToSend` `267-280`: Quiet → hide, `false`. No dest and no `listedPope()` → `false, "no target"`. `localCharacterId` not a number → `false, "no character"`. Else `true`.

Enable `84`: `live and hasCharacter and (hasTarget or pope ~= nil)`.

### `localCharacterId` mint

`UI/Inputs.lua:48` module local, starts `nil`.

`UI/Inputs.lua:317-327` `SetLocalCharacterId`: number → keep; else `nil`. Does **not** call Store.

Only writer in production glue: `ChurchOfBeef.lua:186-207` `bindLocalCharacter`:

- Requires `Store:Snapshot`, `Names.Key`, `UnitName`.
- Walks `snap.characters` for `Names.Key(row.name) == me`.
- On match: `Hud:SetLocalCharacterId(row.id)` and `Inputs:SetLocalCharacterId(row.id)`.
- On miss: **returns without setting**. Does **not** `EnsureCharacterByName` / `CreateHuman` / `CreateCharacter`.

`EnsureCharacterByName` lives on `Core/Store.lua:299` and Pope-desk `UI/Console.lua:391-393` only. Not on Inputs or bootstrap bind.

Zip-fresh empty store → `localCharacterId` stays `nil` → Petition disabled (`no character`). Plan: do not mint an id via Store; Task 6 apply ignores payload id.

`Inputs:ResetForTests` `401-404` clears the id.

### `IsRegisteredPope` presence

**Absent** in `UI/Inputs.lua`. Hide-on-Pope is not implemented.

`listedPope` `UI/Inputs.lua:64-71` is `COB.Popes.List[1]` only (recipient line + enable). Not `Sender:IsRegisteredPope`.

`tests/test_inputs.lua:176, 625, 931, 1032, 1107` source-forbid `IsRegisteredPope`. **Invert** those scans when Task 12 hides the strip on a listed Pope.

### Dest helper mismatch

Net (send):

`Net/BeefNet.lua:97-115` `defaultDest()` = `destName(Net._lastStateSender)` else `destName(Popes.List[1])`. `resolveDest(target)` = explicit dest else that default.

`Net/BeefNet.lua:437-457` `SendPetition(fields, target)` always `resolveDest(target)` then whisper.

Inputs (face):

`UI/Inputs.lua:6-12` comment: bound target, else `List[1]`, else `"No recipient"`. **Does not mention `_lastStateSender`.**

`UI/Inputs.lua:64-71` + `80-82`: face dest = `inputTarget` or `List[1]`.

So with `inputTarget == nil` and a remembered STATE sender ≠ `List[1]`, the line can say `To: List[1]` while the whisper goes to `_lastStateSender`.

`tests/test_inputs.lua:339` pins face fallback `"To: Popeonius"` from `List[1]`.

### `Petition()` send path

`UI/Inputs.lua:351-363`:

1. `readyToSend()` — may hide + return `false, why`.
2. Require `COB.Net.SendPetition` else `false, "no net"`.
3. `fields = { characterId = localCharacterId }`.
4. Optional `fields.opponent` from `petitionOpponent()` (`329-348`): pcall `UnitName("target")` / `("player")`; omit if dest-same, player-same, missing API, or empty trim.
5. `return COB.Net:SendPetition(fields, inputTarget)`.

`inputTarget` may be `nil`; Net then `resolveDest`. Success return is not painted (no asked/waiting). Send failure is not painted on the face.

Inputs never call `Gora:Petition` (`tests/test_inputs.lua:169-170`).

---

## Task 13 — HUD copy + toast gloss + card re-show

**Plan pins:** hover “Click to pick this side.”; footer **Pick a side** before first pick; Void / Cowardice / Sanction gloss; no “The Pope ruled.”; HUD after a ruling reads as ruled until Continue; fighter card must not resurrect on post-verdict `RITE` + lastPair.

### Hud hover / footer

`UI/Hud.lua` has **zero** `OnEnter` / `GameTooltip` / `"Click to pick"` / `"Pick a side"`.

Plates `UI/Hud.lua:910-987`: `pickA` / `pickB` are mouse-enabled buttons. Scripts: `OnClick` → `clickPlate("A"|"B")` only.

`clickPlate` `476-482`: silent `return` if `localCharacterId` is not a number or `pickPair()` is nil. Then `Hud:PickFavor`.

Footer label is **`FAVOR`**:

- Build default `961`, hidden `971`.
- `paintFavor` `436` sets `"FAVOR"` whenever a favor table is painted.
- `tests/test_hud.lua:876` pins `favorLabel:GetText() == "FAVOR"`.

`vs` is `"VS"` (`918`). No ruled / winner / “fight does not count” HUD copy.

`displayPair` `377-396`: live pair, else keep `lastPair` through `RITE`/`CONSEQUENCE` unless riteType is no longer Gora. `Refresh` `1028-1044`: if event live and `displayPair()` exists, `paintShown` — still VS + FAVOR after a ruling.

`livePair` / `pickPair` (`303-316`, `463-474`): `GetSanctioned()` else Runtime fighters only when `state == "RITE"` and `riteType == "Gora"`. ASSEMBLY sanction does not paint congregation plates from Runtime subjects (Task 8 / #39). After `DeclareVictor`, `GetSanctioned()` is nil; HUD persist is `lastPair` (`22-23`, `367-369`).

Romans: `romanPairText` `554-563` / `recordText` `565-567`. Plan: optional this slice.

### Toast strings (`clericalCopy`)

`UI/Toasts.lua:211-266`:

| Kind | Headline / body / chat | Lines |
|------|------------------------|-------|
| `sanction` | Head `"A Beef Gora is Sanctioned"`; body `A\nVS\nB` [+ stipulation] | `214-226` |
| `cowardice` | `"Cowardice recorded: " .. name .. ". So ruled by the Beef Pope."` | `228-232` |
| `verdict` / `victor` | Head `"VICTOR DECLARED"`; body `name .. ". So ruled by the Beef Pope."`; chat `"Victor declared: " .. name .. ". So ruled by the Beef Pope."` | `237-241` |
| `verdict` / `void` | `"Void."`, `""`, `"Void."` | `243-244` |
| `verdict` / `free` | Pope `fields.text` if non-empty; else `"Free ruling."` | `246-249` |

No `"fled"`. No `"This fight does not count."`. No `"sanctioned duel"`.

`tests/test_toasts.lua:247-254` pins sanction headline. `308-311` pins cowardice sentence. `347` pins `"Void."`. `360` pins `"Free ruling."`.

Inbound `Toasts:Proclaim` from congregation STATE is still OPEN_QUESTIONS **#27** (out of slice). Pope-local wraps in `InstallWire` already `proclaim(...)`.

### “The Pope ruled.” presence

**Absent** in `addon/ChurchOfBeef/**/*.lua`.

Free-ruling default is already `"Free ruling."` (`UI/Toasts.lua:249`). Do not add `"The Pope ruled."` as a Void/free fallback (Wave 2 review §3; Law 4).

Near-miss (do not treat as the banned string): `"So ruled by the Beef Pope."` on cowardice + victor (`231`, `240-241`).

The banned sentence appears only in superseded plan copy (`docs/superpowers/plans/2026-09-14-church-of-beef-first-night-congregation.md`) and as a Wave 2 forbid.

### Fighter-card re-show on `RITE` + lastPair

`ChurchOfBeef.lua:350-360` `showFighterCard` → `FighterCard:Show` + `Refresh`.

`ChurchOfBeef.lua:446-455` `DeclareVictor` wrap: proclaim, **`hideFighterCard`**, `refreshHud`, `sendState`. Same hide on Void / FreeRuling / Cowardice (`457-482`). `CloseRite` wrap hides (`400-403`).

Runtime does **not** leave `RITE` on a verdict (`tests/test_gora.lua:306` Sanction does not OpenRite; verdicts only `clearLive`). `stateFields` `ChurchOfBeef.lua:91-94` + `158-160`: after live pair is gone, `GetLastSanctioned` overlays fighters onto STATE when `state` is `RITE` or `CONSEQUENCE` and `riteType == "Gora"`.

Inbound wrap `ChurchOfBeef.lua:508-537`:

- On accepted `_HandleState`:
  - `selfEcho` = `Net:IsSelf(sender)` — **Pope only** skips the card branch (`522-524`).
  - `QUIET` or `CONSEQUENCE` → `hideFighterCard` (`525-527`).
  - **Else** (includes post-verdict **`RITE`**) if `subjects.fighters[1]` and `[2]` → **`showFighterCard()`** (`529-532`).

Congregation therefore re-shows the tape on the verdict STATE (still `RITE` + lastPair). Pope self-echo does not. Comments at `515-521` name this echo hole on the Pope client; the congregation branch is the night-one #111 bug.

`UI/FighterCard.lua` has no Runtime-state watcher; it only Shows when glue calls it.

---

## Task 14 — Pope desk

**Plan pins:** listed-Pope door on the card **or** help already told him; `PHASE_HINT` names the next verb; `after()` paints refuses; petition row fills next empty Fighter A/B (no auto-sanction); pair names select only; `DECLARE VICTOR` commits.

### `PHASE_HINT` table

`UI/Console.lua:65-74`:

```
PHASE_HINT = {
  QUIET = "No gathering is live.",
  ASSEMBLY = "Gathering live — no rite open.",
  RITE = "Rite open.",
  CONSEQUENCE = "Consequence — rule, then continue.",
}
RITE_HINT = {
  Knighting = "Knighting rite open.",
  Gora = "Gora rite open.",
}
```

Paint `UI/Console.lua:1003-1010`: `PHASE_HINT[state]` or QUIET; if `RITE`, `RITE_HINT[riteType]` or `PHASE_HINT.RITE`.

Build default `1416-1418` starts at `PHASE_HINT.QUIET`.

These name the **rite**, not the next click (spec #102). Visible phase verbs are still the real next clicks (`1026-1041`): Quiet → `Start the gathering`; Assembly → `Open a Knighting rite` / `Open a Gora rite` / `End the gathering`; Rite → `Close this rite`; Consequence → `Continue` / `End the gathering`. `KNIGHT THIS BEEF` / `SANCTION BEEF GORA` already work in ASSEMBLY (`1070-1074`, `1088-1130`).

### Pair buttons vs `DeclareVictor`

`UI/Console.lua:1088-1089` comment: pair line has “clickable verdict names” whenever a Gora lives.

`goraLive` `995`: `(RITE or CONSEQUENCE) and riteType == "Gora"`.

`UI/Console.lua:1106-1123`: `PairVictorA` / `PairVictorB` shown when goraLive and that slot is an id; label = `characterName(pair*)`; `_cobVictorId` = that id.

`UI/Console.lua:1449-1462`:

- `PairVictorA` OnClick → `Console:DeclareVictor(self._cobVictorId)`
- `PairVictorB` OnClick → `Console:DeclareVictor(self._cobVictorId)`
- `DeclareVictor` button → `Console:DeclareVictor()` (subject / “Target the victor”)

`Console:DeclareVictor` `2106-2127`: Pope gate; resolve id; `Gora:DeclareVictor(id)`; on success, victor becomes working subject; `after()`.

`tests/test_console.lua:1357-1366` **pins the fat-finger**: “The pair line's fighter names are clickable verdicts”; click `PairVictorB` → that character’s `gora.wins == 1` and live pair cleared. **Invert** this pin: names select; `DECLARE VICTOR` commits.

### Petition row click

Strip header `"Asked to fight"`, empty `"No petitions."` (`1495`).

`paintDesk` petition config `1187-1196`:

- `rows = Console:GetPetitions()`
- `onRow` → `Console:SelectCharacter(row.characterId)` + `Refresh`
- `onAction` → `Console:Dismiss(row.characterId)` (label `"Dismiss"`)

`paintStrip` `714-745`: row `OnClick` is `config.onRow` only. Comment `715-716`: “Row clicks set the working subject.”

`SelectCharacter` `1860-1868`: sets `self.subject` from the character id. Does **not** `SetFighterA` / `SetFighterB` / `Sanction`.

`tests/test_console.lua:1455-1457` pins: clicking the petition row selects the petitioner.

`GetPetitions` `1757-1759` → `Gora:GetPetitions(presentCharacterIds())`.

`presentCharacterIds` `190-220`: roster-ready store character ids (complete roster ∩ store names, or all store ids if roster incomplete). Numeric ids only.

`Gora:GetPetitions` `270-282`: copies entries whose `presentAndAlive[id] == true`. Unsigned name-key petitions (Task 6) cannot appear until Gora + this filter know how to paint a name without a store id.

### `after()` / `GateStatus` (desk refuse paint)

`UI/Console.lua:53` `REFUSE = "not a registered pope"`.

`after` `1891-1896`: `Refresh()` **only when `result ~= nil`**. Errors are returned, not painted.

`applyGate` `1225-1228`: `GateStatus` is `""` or `REFUSE`. No other strings.

`Runtime:EndEvent` `Core/Runtime.lua:237-241`: from RITE → `nil, "event ends from assembly or consequence"`. End-during-Gora-RITE is invisible on the desk.

Other silent refuses (same `after` shape): `"start from quiet"` (`Runtime.lua:195`), `"Set Fighter A and Fighter B first"` (`Console.lua:2070`), `"Target the victor"` (`2114`), `"no sanctioned gora"` (`Gora.lua:422`).

### Pope door on `PlayerCard`

`UI/PlayerCard.lua` has **zero** `Console` / `desk` / `Director` / `/beef console` tokens.

`COPY` `30-48`: `records = "CHURCH RECORDS"`, `close = "CLOSE"`. No desk label.

Buttons:

- `CloseButton` `559-562` → `PlayerCard:Hide()`
- `RecordsButton` `706-709` → `PlayerCard:OpenRecords()` → hide card, `RecordsBook:Show()` (`896-900`)

Bare `/beef` `ChurchOfBeef.lua:646-649` → `PlayerCard:Toggle()`. Same for a listed Pope.

**Slash door (Task 3, already live):** `ChurchOfBeef.lua:597-604` `slashHelp`: congregation line names Ask to fight; if `Sender:IsRegisteredPope(UnitName("player"))`, second line `"The desk is /beef console."` `/beef console` `631-638` calls `Console:Show()`.

`Console:Show` `1528-1530`: if no frame and not listed Pope, **return without Init** (do not mint 560×600). Keep this.

Task 14 still open: card has no desk control; `PHASE_HINT` / pair / petition / `after()` as above. Help-only door exists; bare `/beef` on Thedave is still his card, not the desk.

---

## Cross-task collisions

| File | Tasks that must stay serial |
|------|-----------------------------|
| `ChurchOfBeef.lua` | 10 (login split, `sendState`, gated snapshot), 11 (Save wraps), 14 (door wire if not card-only) |
| `Core/DB.lua` | 10 (do not add UnitName), 11 (`gora` root, schema 7) |
| `UI/Hud.lua` | 13 (copy); Task 8 owns names / ASSEMBLY pair |
| `UI/Console.lua` | 14 (hints, pair, petition, after); Task 6 unsigned rows |
| `UI/Inputs.lua` | 12 |
| `UI/PlayerCard.lua` | 14 door; Task 5 Gathering line |
| `UI/Toasts.lua` | 13 gloss only; no inbound Proclaim |

`SCHEMA_VERSION` stays **7**. Do not claim §22.3 or `POLISH:PASS`.
