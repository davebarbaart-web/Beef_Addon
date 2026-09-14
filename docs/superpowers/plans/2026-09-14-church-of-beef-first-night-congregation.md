# First-night congregation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** A zip-install recruit can understand Tuesday, ask to fight, pick a side, and see named fighters and closed proclamation kinds on a second client — and the Pope can `/reload` mid-Gora without losing the bout.

**Architecture:** Extend existing keepers. Put display fields on STATE; bind congregation self-identity locally without a rank write; Proclaim from accepted Pope STATE; persist the Gora desk on the Pope; do not invent a store-sync protocol.

**Tech Stack:** Lua 5.1, `ChurchOfBeef` / `COB`, `## Interface: 20506`, offline harness `lua tests/run.lua`, Anniversary install via `.agents/skills/church-of-beef-dev/SKILL.md`.

**Spec:** `docs/superpowers/specs/2026-09-14-church-of-beef-100-point-plan-design.md` items 1–50, 51, 54, 66–68, 8 (zip ignore).

## Global Constraints

- Bible v1.1.1 wins. Do not invent OPEN_QUESTIONS answers (#2, #3, #4, #5, #8 Council, #13, #14, #15, #22–#25).
- No points, Grant, standing, ELO, pairing scores, computed Famous Upsets, store-gossip, SUMMON, Forever TOC, HUD health hacks.
- UI → Core → Data; Net → Core → Data; Core never `CreateFrame`; Data never reads SV.
- `lua tests/run.lua` exit 0 after every Core/Data/Net/glue change.
- TOC lists only existing files. Interface stays `20506`.
- Never touch player `WTF/`. Agents do not tick Appendix A Results or claim `POLISH:PASS` / MVP complete.
- Quiet Mode: one welcome parchment first launch only; then minimap + Decree. No feed.
- Commits only when David (or the invoking user) asked — this planning session already authorized the spec/plan docs. Implementation commits wait for the execution pass unless the user asks mid-task.

---

## File map

| File | Responsibility this plan |
|------|--------------------------|
| `docs/phases/v1-checklist.md` | Honest leftover table |
| `docs/phases/dress-rehearsal.md` | Current-product chaos script, NOT RUN |
| `docs/phases/guild-night-playtest.md` | Current-product small night |
| `docs/validation/A03-sender-integrity.md` (and A05, A06, A13) | Leftover lines only |
| `README.md` | Decree ships |
| `docs/design/OPEN_QUESTIONS.md` | #11 text only |
| `addon/ChurchOfBeef/Net/BeefNet.lua` | Header; `_WarnVersion`; inbound apply; whisper dest |
| `addon/ChurchOfBeef/ChurchOfBeef.lua` | Slash; `initUi`; bind; persist debounce; STATE overlay; inbound Proclaim |
| `addon/ChurchOfBeef/UI/Console.lua` | Show-gate for non-Pope |
| `addon/ChurchOfBeef/UI/Welcome.lua` | New. §19.5 parchment |
| `addon/ChurchOfBeef/ChurchOfBeef.toc` | Notes + Welcome.lua |
| `addon/ChurchOfBeef/UI/PlayerCard.lua` | Unrecorded copy; surface names |
| `addon/ChurchOfBeef/Data/Ranks.lua` | Relationship sentences |
| `addon/ChurchOfBeef/UI/Inputs.lua` | Ask to fight; reasons; hide on Pope |
| `addon/ChurchOfBeef/UI/Hud.lua` | Tooltips; Arabic records; labels; no BackdropTemplate |
| `addon/ChurchOfBeef/Net/Codec.lua` | Optional display fields on STATE |
| `addon/ChurchOfBeef/Core/Runtime.lua` | Latest-wins Restore |
| `addon/ChurchOfBeef/Core/DB.lua` | Congregation must not Restore event; Pope persist Gora blob |
| `addon/ChurchOfBeef/Core/Gora.lua` | Snapshot / Restore of live desk |
| `addon/ChurchOfBeef/UI/Toasts.lua` | Void/free/sanction gloss; inbound kinds unchanged |
| `addon/ChurchOfBeef/UI/RecordsBook.lua` | Empty gloss; return door; mutual hide |
| `.gitignore` | `ChurchOfBeef.zip` |
| Tests matching each keeper | Fail first, then implement |

---

### Task 1: Wave 0 honesty (docs + zip ignore)

**Files:**
- Modify: `docs/phases/v1-checklist.md` (leftover table at bottom)
- Modify: `docs/phases/dress-rehearsal.md`
- Modify: `docs/phases/guild-night-playtest.md`
- Modify: `docs/validation/A03-sender-integrity.md`, `A05-raid-markers.md`, `A06-targeting-by-name.md`, `A13-login-reload.md` (leftover sentences only; Result stays NOT RUN)
- Modify: `README.md`
- Modify: `docs/design/OPEN_QUESTIONS.md` item 11 only
- Modify: `addon/ChurchOfBeef/Net/BeefNet.lua` (file header comment only)
- Modify: `.gitignore` (add `/ChurchOfBeef.zip`)
- Do not add `ChurchOfBeef.zip` to git

**Interfaces:**
- Consumes: spec items 1–8
- Produces: docs that match live `/beef`, `/beef console`, Thedave, favor, STATE

- [ ] **Step 1: Rewrite the leftover table** in `v1-checklist.md` so it no longer claims Console / HUD / Records / favor / `#8` are unhosted. Named leftovers that stay: SUMMON, live HUD health, confession inbox UI, cold-tools UI, two-client walk, dress rehearsal, A01–A04 Results.

- [ ] **Step 2: Rewrite dress-rehearsal and guild-night** to the 2026-09-13 surfaces. Both files keep `Status: NOT RUN`. Do not tick boxes.

- [ ] **Step 3: Fix README Decree line and OPEN_QUESTIONS #11** to “player card.” Do not resolve other questions.

- [ ] **Step 4: Replace the BeefNet header sentence** that says STATE send is always false until `#8`. Describe listed Pope + `popeOverrides`.

- [ ] **Step 5: Add `/ChurchOfBeef.zip` to `.gitignore`.** Do not `git add` the zip.

- [ ] **Step 6: Commit docs only** (when the execution pass is authorized):

```bash
git add docs/phases/v1-checklist.md docs/phases/dress-rehearsal.md \
  docs/phases/guild-night-playtest.md docs/validation/A03-sender-integrity.md \
  docs/validation/A05-raid-markers.md docs/validation/A06-targeting-by-name.md \
  docs/validation/A13-login-reload.md README.md docs/design/OPEN_QUESTIONS.md \
  addon/ChurchOfBeef/Net/BeefNet.lua .gitignore
git commit -m "$(cat <<'EOF'
docs: align phase leftover tables with the hosted Gathering kit

Stop sending the next agent to rebuild Console, favor, and Popes that already ship.
EOF
)"
```

---

### Task 2: Slash help and Pope-only console

**Files:**
- Modify: `addon/ChurchOfBeef/ChurchOfBeef.lua` (slash handler ~600–644)
- Modify: `addon/ChurchOfBeef/UI/Console.lua` (`Console:Show`)
- Modify: `tests/test_console.lua`
- Test: add cases in `tests/test_console.lua` and a small slash block in `tests/test_wire_glue.lua` if slash is covered there

**Interfaces:**
- Consumes: `Sender:IsRegisteredPope(name)` → boolean
- Produces: `Console:Show()` returns `nil, "not a registered pope"` for congregation; does not create a visible desk

- [ ] **Step 1: Write the failing test**

```lua
-- tests/test_console.lua
do
  -- after Init, with Sender stubbed false
  local shown, err = COB.Console:Show()
  assert_eq(shown, nil, "congregation Show hides the desk")
  assert_eq(err, "not a registered pope", "refuse string")
end
```

Also pin slash: argument `"help"` does not call `PlayerCard:Toggle`. Unknown `"xyz"` does not toggle.

- [ ] **Step 2: Run** `lua tests/run.lua` — expect FAIL on congregation Show or help.

- [ ] **Step 3: Implement**

`Console:Show` — if not `Sender:IsRegisteredPope(UnitName("player"))` then do not `frame:Show()`; return `nil, "not a registered pope"`. Optional one chat line: this desk is the Pope’s.

Slash:

```lua
if argument == "help" then
  DEFAULT_CHAT_FRAME:AddMessage("|cffffaa00Church of Beef|r: left-click the bull or /beef opens your card. On gathering night: Ask to fight, then click a name to pick a side.")
  return
end
if argument ~= "" and argument ~= "minimap" and argument ~= "console" then
  DEFAULT_CHAT_FRAME:AddMessage("|cffffaa00Church of Beef|r: unknown command. /beef help")
  return
end
```

`/beef console` still calls `Show` (which now refuses congregation).

- [ ] **Step 4: `lua tests/run.lua`** — expect `Tests finished: N passed, 0 failed`.

- [ ] **Step 5: Commit** `feat: hide the Director Console from congregation slash`

---

### Task 3: §19.5 welcome parchment

**Files:**
- Create: `addon/ChurchOfBeef/UI/Welcome.lua`
- Create: `tests/test_welcome.lua`
- Modify: `addon/ChurchOfBeef/ChurchOfBeef.toc` (Notes + `UI\Welcome.lua` before PlayerCard)
- Modify: `addon/ChurchOfBeef/ChurchOfBeef.lua` `initUi` (pcall Welcome:Init)
- Modify: `tests/run.lua` (register `test_welcome`)
- Modify: `addon/ChurchOfBeef/Core/DB.lua` defaults `ui.welcomeSeen`

**Interfaces:**
- Consumes: `ChurchOfBeefDB.ui.welcomeSeen` boolean
- Produces: `COB.Welcome:Init()` shows once when `welcomeSeen` is not true; sets `welcomeSeen = true` on Close. MODE = `"QUIET"`.

- [ ] **Step 1: Write `tests/test_welcome.lua`**

```lua
ChurchOfBeef = ChurchOfBeef or {}
ChurchOfBeef._IN_TEST = true
dofile("tests/wow_stub.lua")
dofile("tests/wow_ui_stub.lua")
-- dofile Theme + Welcome after DB defaults
-- 1) first Init shows frame
-- 2) Close sets ChurchOfBeefDB.ui.welcomeSeen
-- 3) second Init does not show
-- 4) no sound; MODE QUIET
-- 5) copy contains "meetup" or "gather" and "/beef" and does not contain "Director Console"
```

- [ ] **Step 2: Run suite — FAIL** (`cannot open` or missing `COB.Welcome`).

- [ ] **Step 3: Implement `Welcome.lua`.** Theatrical parchment via Theme (Law 10). One Close button. Copy from spec item 10. No settings. No Next tip.

- [ ] **Step 4: TOC Notes** — one plain sentence, e.g. `Meetup notices and sanctioned guild duels for the Church of Beef.`

- [ ] **Step 5: `lua tests/run.lua`** exit 0.

- [ ] **Step 6: Commit** `feat: first-launch welcome parchment, then silence`

---

### Task 4: Newcomer Quiet copy (card, ranks, book door)

**Files:**
- Modify: `addon/ChurchOfBeef/UI/PlayerCard.lua` (`COPY`)
- Modify: `addon/ChurchOfBeef/Data/Ranks.lua` (`relationship` strings)
- Modify: `addon/ChurchOfBeef/UI/Decree.lua` (footer label)
- Modify: `addon/ChurchOfBeef/UI/Minimap.lua` (tooltip)
- Modify: `addon/ChurchOfBeef/UI/RecordsBook.lua` (empty chronicle + return control)
- Modify: `tests/test_player_card.lua`, `tests/test_ranks.lua`, `tests/test_records.lua`, `tests/test_decree_ui.lua`

**Interfaces:**
- Consumes: spec items 15–17, 20–22, 49–50
- Produces: `Ranks.Relationship(3) == "I belong here."`; `PlayerCard.COPY.records` and Decree footer share **History** / **Your card** as chosen in spec §8 item 17

Chosen pair (locked): **Your card** and **History**.

- [ ] **Step 1: Failing pins**

```lua
assert_eq(COB.Ranks.Relationship(3), "I belong here.")
assert_eq(COB.Ranks.Relationship(4), "I proved something here.")
assert_eq(COB.PlayerCard.COPY.unrecorded, "NEW") -- or the chosen word; implementer picks one locked string and pins it
assert_eq(COB.PlayerCard.COPY.unrecordedLine, "The Pope has not written you yet. That is normal.")
```

Use these exact strings so later tasks do not drift:

```lua
unrecorded = "NEW"
unrecordedLine = "The Pope has not written you yet. That is normal."
records = "HISTORY"
```

Decree footer button: `YOUR CARD` → `YOUR CARD` may stay as the header pomp; the label string becomes `Your card` if the button text is the door. Pin `Your card`.

Ranks:

```lua
{ id = 1, title = "Fresh Beef",   relationship = "Just joined." },
{ id = 2, title = "Cooked Beef",  relationship = "Part of the wider Church." },
{ id = 3, title = "Beef Knight",  relationship = "I belong here." },
{ id = 4, title = "Beef Lord",    relationship = "I proved something here." },
{ id = 5, title = "Beef Butcher", relationship = "I raid for the Church." },
{ id = 6, title = "Beef Council", relationship = "Trusted leadership." },
```

- [ ] **Step 2: Run — FAIL** on relationship strings.

- [ ] **Step 3: Implement copy.** Records empty: `Nothing has been written yet.` plus `This page fills in after a Gathering.` Return control calls `RecordsBook:Hide` + `PlayerCard:Show`. `PlayerCard:Toggle` hides the book; `RecordsBook:Show` hides the card.

- [ ] **Step 4: `lua tests/run.lua`** exit 0.

- [ ] **Step 5: Commit** `feat: newcomer Quiet copy and card/book doors`

---

### Task 5: Version notice drops theater

**Files:**
- Modify: `addon/ChurchOfBeef/Net/BeefNet.lua` `_WarnVersion`
- Modify: `addon/ChurchOfBeef/Core/Runtime.lua` (`Restore` latest-wins — if not already in Task 9, do latest-wins here only if this task needs Quiet drop)
- Modify: `tests/test_net_v2.lua` (invert the pin that live event survives skew)
- Modify: `addon/ChurchOfBeef/ChurchOfBeef.lua` if Quiet drop must Hide HUD/Inputs/FighterCard

**Interfaces:**
- Consumes: `Net:IsCompatible`
- Produces: `_WarnVersion()` chats `Church of Beef: the Church's software has advanced. Update the addon.` once per session; congregation Event surfaces Hide

- [ ] **Step 1: Change `test_net_v2.lua`** so version skew **does** hide Event furniture (or force Runtime presentation Quiet). Delete the pin *“version skew does not drop the live event.”*

- [ ] **Step 2: Run — FAIL** if production still leaves HUD shown.

- [ ] **Step 3: Implement** `_WarnVersion` copy + call a bootstrap `dropStaleTheater()` that Hides Hud, Inputs, FighterCard, Toasts; does not wipe Store.

- [ ] **Step 4: `lua tests/run.lua`** exit 0.

- [ ] **Step 5: Commit** `fix: version mismatch drops Event chrome`

---

### Task 6: Congregation self-bind (no rank)

**Files:**
- Modify: `addon/ChurchOfBeef/ChurchOfBeef.lua` `bindLocalCharacter`
- Modify: `tests/test_wire_glue.lua`
- Modify: `addon/ChurchOfBeef/Core/Store.lua` only if `EnsureCharacterByName` needs a no-rank path (it already creates unranked)

**Interfaces:**
- Consumes: `Store:EnsureCharacterByName({ name = UnitName("player") })` → `characterId, humanId`
- Produces: `Hud:SetLocalCharacterId(id)` and `Inputs:SetLocalCharacterId(id)` on congregation after login even when the snapshot started empty. **Does not** `SetRank`.

- [ ] **Step 1: Failing glue test** — empty Store, stub `UnitName` → `"Freshling"`; after `bindLocalCharacter()`, Inputs view `characterId` is a number; `Store:RankForCharacter(id)` is nil.

- [ ] **Step 2: Run — FAIL** (bind still no-ops).

- [ ] **Step 3: Implement**

```lua
local function bindLocalCharacter()
  -- existing walk of Snapshot characters first
  -- if none matched:
  if not (COB.Store and COB.Store.EnsureCharacterByName) then return end
  local name = UnitName("player")
  local id = select(1, COB.Store:EnsureCharacterByName({ name = name }))
  if type(id) == "number" then
    pcall(COB.Hud.SetLocalCharacterId, COB.Hud, id)
    if not skipSend() then
      pcall(COB.Inputs.SetLocalCharacterId, COB.Inputs, id)
    end
  end
end
```

Do not broadcast this row. Do not invent a net kind.

- [ ] **Step 4: `lua tests/run.lua`** exit 0.

- [ ] **Step 5: Commit** `feat: bind congregation self without a Church rank`

---

### Task 7: Ask to fight + honest disable + hide on Pope

**Files:**
- Modify: `addon/ChurchOfBeef/UI/Inputs.lua`
- Modify: `tests/test_inputs.lua`

**Interfaces:**
- Consumes: `localCharacterId`, `listedPope()`, `eventLive()`, `Sender:IsRegisteredPope`
- Produces: button text `Ask to fight`; `frame.ReasonText` one of `Event is not live.` / `The Pope has not written you yet.` / `No Pope in range.`; `Inputs:Refresh` hides if local Pope

- [ ] **Step 1: Pins**

```lua
assert_eq(frame.PetitionButton:GetText(), "Ask to fight")
-- live + no characterId
assert_eq(frame.ReasonText:GetText(), "The Pope has not written you yet.")
-- local pope
assert_eq(Inputs:Refresh() and frame:IsShown(), false)
```

Tooltip: `Ask the Pope to consider you for tonight's sanctioned duel. Target another player to name them.`

- [ ] **Step 2: Run — FAIL.**

- [ ] **Step 3: Implement** `paintAvailability` reason line; `Refresh`/`Init` hide when `Sender:IsRegisteredPope(local)`. Dest line must call the same helper as `Net` default dest (`last STATE sender` else `Popes.List[1]`). If Net helper is not public, add `Net:DefaultInputDest()` returning a string or nil.

- [ ] **Step 4: `lua tests/run.lua`** exit 0.

- [ ] **Step 5: Commit** `feat: congregation Ask to fight with a visible refuse reason`

---

### Task 8: Favor plates announce themselves

**Files:**
- Modify: `addon/ChurchOfBeef/UI/Hud.lua`
- Modify: `addon/ChurchOfBeef/UI/FighterCard.lua` (stipulation label + Arabic record)
- Modify: `tests/test_hud.lua`, `tests/test_fighter_card.lua`

**Interfaces:**
- Consumes: spec items 27–28, 32–35
- Produces: `Hud.COPY.favorHint = "Click to pick this side."`; `recordText` uses Arabic `wins.."–"..losses`; `favorLabel` congregation text `Pick a side`; `stipulationLabel` `Tonight's rule`

- [ ] **Step 1: Pins** — `clickPlate` with nil `localCharacterId` sets a hint fontstring, does not call `PickFavor`. Hover script exists on `pickA`/`pickB`. `recordText({wins=0,losses=3}) == "0–3"`.

- [ ] **Step 2: Run — FAIL.**

- [ ] **Step 3: Implement.** Drop `BackdropTemplate`:

```lua
CreateFrame("Frame", FRAME_NAME, UIParent)
```

Same for Inputs if it inherits BackdropTemplate. Theme already paints the chassis.

- [ ] **Step 4: `lua tests/run.lua`** exit 0.

- [ ] **Step 5: Commit** `feat: favor plates say pick a side; Arabic records`

---

### Task 9: STATE display fields + latest-wins

**Files:**
- Modify: `addon/ChurchOfBeef/Net/Codec.lua`
- Modify: `addon/ChurchOfBeef/ChurchOfBeef.lua` `stateFields` / `_HandleState`
- Modify: `addon/ChurchOfBeef/Core/Runtime.lua` `Restore`
- Modify: `addon/ChurchOfBeef/UI/Hud.lua` `fighterFrom`
- Modify: `addon/ChurchOfBeef/UI/FighterCard.lua` `fighterFrom`
- Modify: `tests/test_net_codec.lua`, `tests/test_runtime.lua`, `tests/test_ceremony_chaos.lua`

**Interfaces:**
- Consumes: Store rows on the Pope
- Produces: STATE optional `cast` table: `{ { id, name, classFile, level, title, wins, losses, defenses, h2hWins, h2hLosses }, ... }` max 2 fighters + optional `candidate`. Codec must ignore unknown extra keys (fail-closed on kinds, open on optional fields). `Runtime:Restore` no-ops if incoming `sequence` < current `sequence` for the same `eventId`.

- [ ] **Step 1: Codec tests** — encode/decode round-trip with `cast`; older sequence Restore leaves fighters unchanged (`test_ceremony_chaos.lua` invert rewind pin).

- [ ] **Step 2: Run — FAIL.**

- [ ] **Step 3: Implement overlay in `stateFields` from `Store:GetCharacter`.** HUD/card prefer `cast` when local `GetCharacter` misses. Do not write congregation Store from `cast`.

- [ ] **Step 4: `lua tests/run.lua`** exit 0.

- [ ] **Step 5: Commit** `feat: STATE carries mute-card fields; Restore is latest-wins`

---

### Task 10: Inbound Proclaim + HUD/card agreement

**Files:**
- Modify: `addon/ChurchOfBeef/ChurchOfBeef.lua` `_HandleState`
- Modify: `addon/ChurchOfBeef/UI/Toasts.lua` (`clericalCopy` Void / Free / Sanction gloss)
- Modify: `addon/ChurchOfBeef/UI/Hud.lua` `livePair` / `pickPair`
- Modify: `tests/test_wire_glue.lua`, `tests/test_toasts.lua`, `tests/test_hud.lua`

**Interfaces:**
- Consumes: accepted STATE `riteType`, `state`, `cast` / subjects
- Produces: congregation `Toasts:Proclaim(kind, payload)` on transition edges only (not every HELLO echo). Kinds remain `sanction`, `verdict`, `cowardice`, `knighting`, `elevation`. Self-echo skip stays for the fighter card.

Sanction copy: keep `A Beef Gora is Sanctioned` plus `A sanctioned duel.` as a second clerical line if the payload has two names.  
Void: `This fight does not count.`  
Free: payload text or `The Pope ruled.`

HUD: if sanctioned pair or STATE fighters exist in ASSEMBLY, paint HUD (same as Pope `GetSanctioned()` path).

- [ ] **Step 1: Glue test** — apply inbound STATE Gora RITE with two cast names; spy `Toasts:Proclaim` called with `"sanction"` on congregation (`_inspecting` false, sender accepted). Second identical sequence does not Proclaim again.

- [ ] **Step 2: Run — FAIL.**

- [ ] **Step 3: Implement edge detect** (`lastProclaimedSeq`) on bootstrap. Align `Hud` `livePair` with ASSEMBLY fighters.

- [ ] **Step 4: `lua tests/run.lua`** exit 0.

- [ ] **Step 5: Commit** `feat: congregation sees sanction theater from Pope STATE`

---

### Task 11: Catch-up and Quiet login

**Files:**
- Modify: `addon/ChurchOfBeef/Core/DB.lua` (`restoreEventFromSv`)
- Modify: `addon/ChurchOfBeef/ChurchOfBeef.lua` (`OnLogin` / `InstallWire`)
- Modify: `addon/ChurchOfBeef/Net/BeefNet.lua` (optional public `RequestSnapshot` already exists)
- Modify: `tests/test_db.lua`, `tests/test_wire_glue.lua`

**Interfaces:**
- Consumes: `Sender:IsRegisteredPope(UnitName("player"))`
- Produces: congregation `DB:Init` does **not** `Runtime:Restore` from SV. Pope still restores. After `Net:Init`, if Runtime is QUIET and `Net:DefaultInputDest()` is a string, `Net:RequestSnapshot()`.

- [ ] **Step 1: `test_db.lua`** — seed `ChurchOfBeefDB.event = { state = "RITE", ... }`; stub not Pope; after Init, `Runtime:Snapshot().state == "QUIET"`.

- [ ] **Step 2: Run — FAIL.**

- [ ] **Step 3: Implement the Pope-only restore branch. Call `RequestSnapshot` once per login (flag `snapshotAsked`).**

- [ ] **Step 4: `lua tests/run.lua`** exit 0.

- [ ] **Step 5: Commit** `fix: congregation login stays Quiet until Pope STATE`

---

### Task 12: Pope Gora persist + write debounce

**Files:**
- Modify: `addon/ChurchOfBeef/Core/Gora.lua` (`Snapshot` / `Restore`)
- Modify: `addon/ChurchOfBeef/Core/DB.lua` (schema: add `gora` blob next to `event`; bump schema number)
- Modify: `addon/ChurchOfBeef/ChurchOfBeef.lua` (debounce `DB:Save` after successful Gora/Runtime/Store writes)
- Modify: `tests/test_gora.lua`, `tests/test_db.lua`

**Interfaces:**
- Consumes: in-memory `petitions`, `sanctioned`, `favorPicks`, `lastSanctioned`
- Produces: `Gora:Snapshot()` / `Gora:Restore(blob)` ; after Pope `DB:Init`, `Gora:GetSanctioned()` returns the pair; `DeclareVictor` does not return `"no sanctioned gora"` solely because of reload

- [ ] **Step 1: Test** — Sanction pair; `DB:Save`; `Gora` ResetForTests; `DB:Init`; `DeclareVictor` succeeds.

- [ ] **Step 2: Run — FAIL.**

- [ ] **Step 3: Implement Snapshot/Restore. Debounce Save with `C_Timer.After(0)` or next-frame flag; also keep `PLAYER_LOGOUT`. Do not persist congregation Gora.**

- [ ] **Step 4: `lua tests/run.lua`** exit 0.

- [ ] **Step 5: Commit** `fix: persist the sanctioned Gora across Pope reload`

---

### Task 13: Fail-soft Init

**Files:**
- Modify: `addon/ChurchOfBeef/ChurchOfBeef.lua` `initUi`
- Modify: `tests/test_wire_glue.lua` (or a small `test_bootstrap.lua` if glue already covers Init order)

**Interfaces:**
- Consumes: each `COB.*.Init`
- Produces: every Init is `pcall`’d; `Net:Init` always runs; one chat line on failure: `Church of Beef: <module> failed to start.`

- [ ] **Step 1: Test** — stub `Hud.Init` to error; `OnLogin` still calls `Net:Init` (spy).

- [ ] **Step 2: Run — FAIL** (Hud currently bare).

- [ ] **Step 3: Wrap all Inits in pcall. Keep Welcome from Task 3 in the list.**

- [ ] **Step 4: `lua tests/run.lua`** exit 0.

- [ ] **Step 5: Commit** `fix: UI Init cannot block BeefNet`

---

### Task 14: INPUT apply by server sender

**Files:**
- Modify: `addon/ChurchOfBeef/Net/BeefNet.lua` `_HandleFavor`, `_HandlePetition`, `_HandleConfession`
- Modify: `tests/test_net_v2.lua` / `tests/test_net_adversarial.lua`

**Interfaces:**
- Consumes: server `sender` string
- Produces: resolve `characterId` via `Store:EnsureCharacterByName({ name = sender })` on the **Pope** client; ignore or refuse payload id if `Names.Key(sender)` ≠ store row for that id

- [ ] **Step 1: Adversarial test** — INPUT favor with `characterId = 1` from sender `"Spoof"` when id 1 is `"Thedave"` → do not record as Thedave. Record as Spoof’s row or refuse.

- [ ] **Step 2: Run — FAIL.**

- [ ] **Step 3: Implement sender-keyed apply. Dedup by that character id.**

- [ ] **Step 4: `lua tests/run.lua`** exit 0.

- [ ] **Step 5: Commit** `fix: congregation INPUT is the server sender, not a payload id`

---

### Task 15: awaiting-Pope paint (flag only)

**Files:**
- Modify: `addon/ChurchOfBeef/Core/Runtime.lua` (already has `MarkPopeLost`)
- Modify: `addon/ChurchOfBeef/ChurchOfBeef.lua` or `UI/Hud.lua` / `UI/Toasts.lua`
- Modify: `tests/test_runtime.lua`, `tests/test_hud.lua`

**Interfaces:**
- Consumes: `Runtime:Snapshot().awaitingPope`
- Produces: when true, HUD shows muted `Awaiting the Pope.` (Event degraded). No toast. No sixth state. **No holdSeconds.** Detector in this task may be: missing accepted STATE after snapshot request failed — not a coded timer. Full disconnect detect can wait for the next plan if no clean event exists; still paint when the flag is set.

- [ ] **Step 1: Pin HUD copy when `awaitingPope`.**

- [ ] **Step 2: Implement paint branch.**

- [ ] **Step 3: `lua tests/run.lua`** exit 0.

- [ ] **Step 4: Commit** `feat: awaiting-the-Pope presentation without a hold timer`

---

### Task 16: In-game smoke (agents install; David walks)

**Files:** none (skill loop)

- [ ] Install `addon/ChurchOfBeef/` → Anniversary AddOns via the church-of-beef-dev skill. Never WTF.
- [ ] `/console scriptErrors 1` → `/reload` → `/beef` → `/beef help` → welcome once → card says NEW if unwritten.
- [ ] Two clients: Thedave starts event, sanctions; congregation sees names, Ask to fight, pick-a-side hover, sanction parchment. Pope `/reload`; still can DECLARE VICTOR.
- [ ] Do not tick `docs/phases/*`. Do not claim MVP.

---

## Spec coverage (self-review)

| Spec items | Task |
|------------|------|
| 1–8 | Task 1 |
| 9–13, 14 | Tasks 3, 2 |
| 15–17, 20–22, 49–50 | Task 4 |
| 18–19 | Task 5 |
| 23, 36 | Task 6 |
| 24–26, 30–31 | Task 7 |
| 27–28, 32–35, 67 (Hud inherit) | Task 8 |
| 38, 44 | Task 9 |
| 37, 39–43 | Task 10 |
| 45–46, 48 | Task 11 |
| 51, 54 | Task 12 |
| 66–68 | Task 13 |
| 29 | Task 14 |
| 47 | Task 15 |
| 80, 81 (prepare only) | Task 16 |

Not in this plan (later waves): 52–53, 55–65, 69–79, 82–100. That matches the spec’s first-slice sentence.

No TBD. Locked copy strings are in Tasks 3–4 and 7–8. `Net:DefaultInputDest()` is introduced in Task 7 and used in Task 11.
