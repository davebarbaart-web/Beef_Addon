# First-night Wave 2 Implementation Plan

> **Addendum (14 Sep 2026 evening).** Tasks **1–14** are in the tree and independently reviewed **Approved / spec PASS**. Task **15** is a human two-client walk — not walked, not ticked. Close-out: `.superpowers/sdd/wave-2-closeout.md`. Checkboxes below are the morning plan, not live status. Do not re-implement. Do not claim §22.3 / `POLISH:PASS` / MVP.

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking. Do **not** implement the superseded `2026-09-14-church-of-beef-first-night-congregation.md`.

**Goal:** A zip-install recruit can understand Tuesday, ask to fight without a local Store row, and see **named** fighters on a second client. Thedave can find the desk, see the next verb, and `/reload` mid-Gora without losing the bout.

**Not in this slice:** inbound `Toasts:Proclaim` / `Sound` (OPEN_QUESTIONS **#27**), congregation `EnsureCharacterByName` (**#26** refuse path), mute-card replica on the wire, Archive UI, Presence-as-queue, schema version 8.

**Architecture:** Extend existing keepers. PROTOCOL 2 packed display names only. INPUT keyed to server sender. Unsigned desk names. Pope-only Gora persist. UI never records official outcomes. Core never `CreateFrame`.

**Tech Stack:** Lua 5.1, `ChurchOfBeef` / `COB`, `## Interface: 20506`, `lua tests/run.lua`, Anniversary install via `.agents/skills/church-of-beef-dev/SKILL.md`.

**Spec:** `docs/superpowers/specs/2026-09-14-church-of-beef-wave-2-review.md` plus rewritten items in `2026-09-14-church-of-beef-100-point-plan-design.md` (1–10, 12–15, 18–19, 23–32, 36, 38–39, 44–46, 48–51, 54, 66–68, 101–106, 108, 110–112, 114–116, 118).

## Global Constraints

- Bible v1.1.1 wins. Do not invent answers to #2, #3, #4, #5, #8 Council, #13, #14, #15, #22–#25, **#26**, **#27**.
- No congregation `EnsureCharacterByName` / `CreateHuman` / `LinkCharacter`. No points, Grant, standing, ELO, store-gossip, SUMMON, Forever TOC, HUD health.
- UI → Core → Data; Net → Core → Data.
- `lua tests/run.lua` exit 0 after every Core/Data/Net/glue change. Register every new `tests/test_*.lua` in `tests/run.lua` `suites`.
- TOC lists only existing files. Interface stays `20506`. `SCHEMA_VERSION` stays **7**.
- Never touch player `WTF/`. Agents do not tick Appendix A or claim `POLISH:PASS` / MVP complete.
- Quiet Mode: one welcome parchment first launch only; then minimap + Decree. No feed. Do not stack welcome on an already-posted Decree.
- Commits only when David asks.
- **Do not parallelize** tasks that edit `ChurchOfBeef.lua`, `UI/Hud.lua`, `Core/DB.lua`, `Net/Codec.lua`, or `UI/Console.lua`.

`wow_ui_stub` accepts `BackdropTemplate` and never throws. `wow_stub.lua` has **no `C_Timer`**. Pins that only exist in the stub are not client proof.

---

## File map

| File | This plan |
|------|-----------|
| `ChurchOfBeef.lua` | Slash; `initUi` pcall; login restore split; Pope `sendState`; name stash; desk door wire; no self-Ensure |
| `ChurchOfBeef.toc` | Welcome.lua if added |
| `Net/BeefNet.lua` | Header; `_WarnVersion`; sender-bind; dest helper; version drop |
| `Net/Codec.lua` | `PROTOCOL = 2`; packed names field; 240-byte tests via Send |
| `Net/Snapshot.lua` | Same names overlay; no extra schema beyond allowlisted field |
| `Core/DB.lua` | `ui.welcomeSeen`; congregation skip event apply at login; Pope `gora`; no version 8 |
| `Core/Gora.lua` | Snapshot/Restore; unsigned petition by sender key; ignore unknown opponent |
| `Core/Runtime.lua` | Latest-wins as specified (seq greater for ceremony; favor overlay `>=`) |
| `UI/Welcome.lua` | New. §19.5 parchment |
| `UI/Console.lua` | Show-gate; next-verb hint; refuse paint; petition fills slot; names ≠ verdict |
| `UI/Inputs.lua` | Ask to fight; hide on Pope; send-fail; no BackdropTemplate if client aborts |
| `UI/Hud.lua` | ASSEMBLY pair; inbound names; ruled state; no BackdropTemplate if client aborts |
| `UI/PlayerCard.lua` | Unrecorded line (not gold `NEW`); Gathering line when live; Pope desk door |
| `UI/Toasts.lua` | Void/cowardice/sanction gloss only; no “The Pope ruled.”; no inbound fire |
| `docs/phases/*`, `README.md` | Honesty leftovers |
| `.gitignore` | `ChurchOfBeef.zip` |

---

## Task 1: Boot safety

**Files:** `ChurchOfBeef.lua` `initUi`; `UI/Hud.lua`; `UI/Inputs.lua`; `tests/test_wire_glue.lua`; `tests/test_inputs.lua`

- [ ] **Pin:** every `Init` in `initUi` is inside `pcall`. After a forced Hud Init failure, `Net:Init` still runs. One chat line `Church of Beef: <module> failed to start.`
- [ ] **Pin:** invert `test_inputs.lua` BackdropTemplate assert if you drop the inherit. Add a Hud source pin for `_template` / inherit string. The stub will not catch a client abort.
- [ ] Wrap Minimap, RecordsBook, PlayerCard, Hud, and every other Init. Always reach `Net:Init()`.
- [ ] On the live 20506 client: if `CreateFrame(..., "BackdropTemplate")` errors, drop the inherit. Do not claim the template is missing until that happens.
- [ ] `lua tests/run.lua` exit 0.

## Task 2: Stop lying in leftovers

**Files:** `docs/phases/v1-checklist.md` (bottom table only), `docs/phases/dress-rehearsal.md`, `docs/phases/guild-night-playtest.md`, `docs/validation/A03-sender-integrity.md` (and A05, A06, A13 leftover **sentences**), `README.md`, `Net/BeefNet.lua` header, `.gitignore`

- [ ] Rewrite the **bottom leftover table** so Console / HUD / Records / favor / Popes / Decree wire are coded. Keep Status: NOT RUN on dress rehearsal and Appendix A Results.
- [ ] README: Decree ships.
- [ ] BeefNet header: STATE send is not “always false until #8.”
- [ ] Gitignore `ChurchOfBeef.zip`. Do not commit a regenerated zip unless David asks.
- [ ] OPEN_QUESTIONS #11 congregation `/beef` sentence is already the player card (Wave 2). Do not mark #11 resolved.
- [ ] No addon behavior change except the BeefNet header sentence.

## Task 3: Slash honesty + console gate

**Files:** `ChurchOfBeef.lua`; `UI/Console.lua`; `tests/test_wire_glue.lua`; `tests/test_console.lua`

- [ ] **Pin (invert):** `test_wire_glue.lua` currently pins unknown args toggling the card. Unknown args print help (or a one-line refuse), they do not `PlayerCard:Toggle`.
- [ ] `/beef help` one chat line: bull / `/beef` = your name; night = Ask to fight, then pick a side when two names appear. Do not advertise `/beef console` to congregation.
- [ ] If `Sender:IsRegisteredPope(UnitName("player"))`, a second chat line may say the desk is `/beef console`.
- [ ] Gate `Console:Show` for non-Popes **before** `Init()` builds the 560×600 desk. Existing `test_console.lua` `Show()` paths need `stubPope()` — that suite’s header forbids slash tests.
- [ ] Verbs already refuse `not a registered pope`. Keep that string.

## Task 4: Welcome parchment

**Files:** `UI/Welcome.lua` (new); `ChurchOfBeef.toc`; `Core/DB.lua` `applyDefaults`; `ChurchOfBeef.lua` `initUi`; `tests/test_welcome.lua` (register in `run.lua`); `tests/test_db.lua`

- [ ] **Pin:** missing `ui.welcomeSeen` fills `false`; unknown `ui` keys survive; `SCHEMA_VERSION == 7`.
- [ ] One §19.5 sheet, first launch only. MODE Quiet. No sound. Copy must not say “Director Console.” Copy must not say “click a name” in the same breath as Ask to fight — sequence from spec item 10.
- [ ] If a Decree is already showing or Runtime ≠ QUIET, do not stack: skip welcome or wait until the Decree is closed. One parchment.
- [ ] `pcall` Welcome Init. Flag `welcomeSeen` on close only.

## Task 5: Quiet card copy (not a fake rank)

**Files:** `UI/PlayerCard.lua`; `UI/Minimap.lua`; `tests/test_player_card.lua`; `tests/test_minimap.lua`

- [ ] Gold plate stays a real Church title or the live guild rank (OPEN_QUESTIONS #21). Newness is the relationship line: `The Pope has not written you yet. That is normal.`
- [ ] Do not paint `NEW` as a title word.
- [ ] When Runtime ≠ QUIET, the existing Gathering line (and minimap tooltip if the button is shown) says the gathering has started. No toast. Do not reopen welcome.
- [ ] Do not rename CHURCH RECORDS to History.

## Task 6: Sender-keyed INPUT + unsigned desk

**Files:** `Net/BeefNet.lua`; `Core/Gora.lua`; `UI/Console.lua`; `tests/test_net_v2.lua`; `tests/test_gora.lua`; `tests/test_wire_glue.lua`

- [ ] **Pin:** empty congregation Store → **zero** new `humans` / `characters` after login bind. Invert any Task that called `EnsureCharacterByName` on the pew.
- [ ] `_HandlePetition` / `_HandleFavor` / `_HandleConfession` ignore payload `characterId`. Key by `Names.Key(sender)`.
- [ ] Unknown sender: unsigned petition/favor row in Gora memory (name-key). No `CreateHuman`. Desk paints the name.
- [ ] Unknown named opponent: ignore opponent, still record the ask. Do not return `unknown opponent`.
- [ ] `RecordFavor` must not write `favorPicks[foreignId]` for a spoofed number.
- [ ] Do not resolve OPEN_QUESTIONS #26. If David later wants petition-as-recognition, that is a Pope-side `Ensure` on apply — not this task.

## Task 7: Version drop + PROTOCOL 2

**Files:** `Net/Codec.lua`; `Net/BeefNet.lua`; `Net/Snapshot.lua`; `tests/test_net_codec.lua`; `tests/test_net_v2.lua`; `tests/test_ceremony_chaos.lua`; `tests/test_net_snapshot.lua`

- [ ] **Pin (invert):** `test_net_v2.lua` and `test_ceremony_chaos.lua` “version skew does not drop the live event.” Skew must drop Event chrome to Quiet presentation and show the §13.4 sentence once per session. No toast family.
- [ ] `Codec.PROTOCOL = 2`. Old v1 bodies are incompatible. `_WarnVersion` + drop.
- [ ] Extra unknown colon parts still fail-closed. Allowlist only the new packed **names** field (Task 8). Invert “STATE extra wire field” pins **only** for that field.
- [ ] Do not add clerical kind / beat (that is #27).

## Task 8: Packed display names + 240-byte pin

**Files:** `Net/Codec.lua`; `Net/Snapshot.lua`; `ChurchOfBeef.lua` `stateFields` + inbound stash; `UI/Hud.lua`; `UI/FighterCard.lua`; `tests/test_net_codec.lua`; `tests/test_net_adversarial.lua`; `tests/test_hud.lua`; `tests/test_wire_glue.lua`

- [ ] Packed names for fighters / candidate only. Fail-closed if a name contains `:`.
- [ ] **Pin through `Net:Send` / `_TransmitWhisper`:** worst-case names + favor `#payload <= 240`. Codec round-trip alone is not enough.
- [ ] Inbound stash `lastCast` / names on bootstrap. `Runtime:Restore` stays Bible fields. Hud / FighterCard paint from stash when `GetCharacter` is empty. **No Store upsert.**
- [ ] Snapshot `BuildResponse` / `ApplyResponse` carry the same names field. `SNAPSHOT_RES_KEYS` allowlist it.
- [ ] Congregation HUD `livePair` / `pickPair` must show ASSEMBLY sanction (Pope already sanctions in ASSEMBLY). Align with `GetSanctioned()` on the Pope client.
- [ ] Fighter card must not re-show on post-verdict `RITE` + lastPair (spec #111).

## Task 9: Latest-wins without dropping favor

**Files:** `Core/Runtime.lua`; `Net/BeefNet.lua` or glue; `tests/test_ceremony_chaos.lua`

- [ ] Ceremony fields apply only if `sequence` is **greater**.
- [ ] Favor overlay applies when `eventId` matches and `sequence >= current`.
- [ ] Different `eventId` still applies.
- [ ] Equal sequence must not fire theater (theater is off this slice anyway).
- [ ] Invert the chaos rewind pin. Snapshot apply uses the same rule.

## Task 10: Login restore + Pope rebroadcast

**Files:** `ChurchOfBeef.lua`; `Core/DB.lua`; `tests/test_wire_glue.lua`; `tests/test_db.lua`

- [ ] Do **not** gate `restoreEventFromSv` on `UnitName` inside `DB:Init` (`ADDON_LOADED`). Pope would skip restore.
- [ ] On `PLAYER_LOGIN`, if not `IsRegisteredPope`, Restore QUIET / skip applying the SV event **before** `initUi`. Pope keeps the restored event.
- [ ] `RequestSnapshot` only after accepted Pope HELLO or live STATE this session, local still QUIET. Once per login. Tuesday no-response is not a failure.
- [ ] If local Pope and Runtime ≠ QUIET after `InstallWire`, `sendState()` once (#48).
- [ ] Congregation Decree: do not treat leftover SV / InspectProgress as Pope chrome this session if you touch Decree here — otherwise defer to a later P1 (#113). Prefer not expanding this task.

## Task 11: Pope-only Gora persist

**Files:** `Core/Gora.lua`; `Core/DB.lua`; `ChurchOfBeef.lua`; `tests/test_gora.lua`; `tests/test_db.lua`

- [ ] Snapshot/Restore `sanctioned`, petitions (including unsigned name-keys), `favorPicks`, `lastSanctioned`, `eventId`.
- [ ] `SCHEMA_VERSION` stays 7. Update `rootKeys` if you add root `gora`.
- [ ] Restore **after** event restore. If gora lands first, `_Expire()` sees QUIET and wipes the pair.
- [ ] Pope-only Save and Restore. Congregation must not write `gora = {}` over a shared-account SV.
- [ ] Debounce: `if C_Timer and C_Timer.After then` else save on the write path / `PLAYER_LOGOUT` only. Tests call `DB:Save()` directly.
- [ ] Wrap successful Gora/Runtime/Store writes. `ResetForTests` must not Save.

## Task 12: Ask to fight (no Store write)

**Files:** `UI/Inputs.lua`; `Net/BeefNet.lua`; `tests/test_inputs.lua`

- [ ] Face: **Ask to fight**. Header is not `EVENT INPUT`.
- [ ] Hide the strip on listed Pope (`IsRegisteredPope`). Invert `test_inputs.lua` source scan that forbids `IsRegisteredPope`.
- [ ] Dest line and send dest both call the same helper as `Net` `defaultDest()` (last STATE sender else `Popes.List[1]`).
- [ ] Reasons that can fire: not in a guild; send failed; you already asked (no TTL); this is a Knighting, not a fight (#107 can land here).
- [ ] After a successful send: strip says asked / waiting. Unknown opponent does not refuse.
- [ ] Do not mint `localCharacterId` via Store.

## Task 13: HUD copy (P1, after names work)

**Files:** `UI/Hud.lua`; `UI/FighterCard.lua`; `UI/Toasts.lua`; `tests/test_hud.lua`; `tests/test_toasts.lua`

- [ ] Hover: “Click to pick this side.” Footer **Pick a side** before the first pick.
- [ ] Arabic records optional this slice — do not block Task 14 on Romans.
- [ ] `Void.` → “This fight does not count.” Cowardice headline must say fled. Sanction: one plain “sanctioned duel” line under pomp. Free ruling: keep `"Free ruling."` or omit; **no** “The Pope ruled.”
- [ ] HUD after a ruling reads as ruled until Continue (#110). Hide favor or stamp the winner name from Pope STATE subjects if a winner id is already knowable **without** a new beat field. If it is not knowable, hide favor and show that the fight is ruled — do not invent a winner string.

## Task 14: Pope desk (Thedave can run the night)

**Files:** `UI/Console.lua`; `UI/PlayerCard.lua`; `ChurchOfBeef.lua`; `tests/test_console.lua`; `tests/test_player_card.lua`

- [ ] Desk door: listed Pope card has a control that `Console:Show`s, **or** `/beef` help already told him. Bare `/beef` on Thedave must not look like a failed kit.
- [ ] `PHASE_HINT` names the next verb (spec #102). No wizard.
- [ ] `after()` paints refuse strings on `GateStatus` (or target line). End-during-RITE is visible.
- [ ] Petition row fills the next empty Fighter A/B, or the row reads “use this petitioner.” No auto-sanction.
- [ ] Pair name buttons select subject only. `DECLARE VICTOR` is the commit. Invert any pin that `DeclareVictor`s from `PairVictorA`.
- [ ] Unsigned petition names from Task 6 appear in the strip.

## Task 15: Two-client smoke (do not tick phase docs)

**Files:** none required. Follow `.agents/skills/church-of-beef-dev/SKILL.md`.

Precondition: David confirms **Thedave** is the live writer, or he adds `popeOverrides` himself (#118). Agents do not invent names.

Walk, do not tick `docs/phases/*`:

1. Blank-ish congregation WTF: welcome once, then silence. Card does not say a fake rank `NEW`. Gold plate may show guild rank (#21).
2. `/beef help` does not dump console. `/beef console` on congregation does not build the desk.
3. `/beef` on Thedave reaches the desk (door or slash line).
4. Start gathering. Recruit sees Gathering-started copy on the card (if they open it) and **Ask to fight**.
5. Recruit asks without being in the Pope store. Desk shows the unsigned name. Store human count on the Pope does not increase.
6. Target another zip-fresh: ask still lands.
7. Sanction two named people. Congregation HUD shows **names** in ASSEMBLY or RITE — not empty plates.
8. Pope `/reload`. Desk still has the pair. `Declare Victor` does not refuse `no sanctioned gora`. Congregation still sees names after the rebroadcast.
9. Version-skew client (if you have an old zip): Quiet notice, no Event chrome.
10. Shared-account warning: do not log a congregation character into the same WTF tree as Thedave during this walk.

Inbound sanction parchment on the recruit is **not** required until #27.

---

## Coverage vs Wave 1 plan

| Wave 1 task | Wave 2 |
|-------------|--------|
| 6 self-Ensure | Deleted. Task 6 unsigned. |
| 9 mute-card cast | Names only. Task 8. |
| 10 inbound Proclaim | Out. #27. |
| 11 UnitName-in-DB:Init | Forbidden. Task 10 login split. |
| 12 schema 8 | Forbidden. Task 11. |
| (missing) Pope desk | Task 14. |
| 13 boot last | Task 1 first. |

## Done when

`lua tests/run.lua` exits 0, TOC is truthful, and Task 15 has been walked on two Anniversary clients. Nobody claims §22.3 or `POLISH:PASS`.
