# 100-point live status — 2026-09-14

> **Addendum (same day).** Items **12–14** (slash honesty + console gate) and boot-safety (`initUi` pcall / always `Net:Init`) are now in the tree. **#26** / **#27** remain unanswered; unsigned desk and inbound Proclaim are still not the night-one *code* default until Tasks 6 and 7–8 land. Counts below are a morning snapshot — do not treat “Wave 2 Lua is not in the tree” as current.
>
> **Addendum (same evening).** Wave 2 Tasks **1–14** are in the tree (SDD reviews Approved through 13; 14 implementer done). Night-one refuse paths for **#26** (unsigned desk, no pew Ensure) and **#27** (inbound Proclaim off) **are code**. Item **118** / Task 15 is still David + two clients. Counts and “Not started in code” below are a morning snapshot — stale. Do not retally this file as law.

Read-only snapshot of `docs/superpowers/specs/2026-09-14-church-of-beef-100-point-plan-design.md` items **1–118** against this checkout. No implementation. No OPEN_QUESTIONS answers.

**Sources:** Wave 2 review (`docs/superpowers/specs/2026-09-14-church-of-beef-wave-2-review.md`), first-night plan (`docs/superpowers/plans/2026-09-14-church-of-beef-first-night-wave-2.md`), `OPEN_QUESTIONS.md` **#26** / **#27**. Spot-checks in `addon/ChurchOfBeef/` when a row claimed “already exists.”

**Wave 2 REWRITE / DROP (win over the original sentence):**

| # | Note |
|---|------|
| 11 | DROP from first-night. TOC `## Notes` already parseable. |
| 16 | DROP. Do not invent Fresh / Cooked / Council Bible sentences. |
| 17 | PARK. Keep `CHURCH RECORDS`. |
| 21 | PARK. Do not dress a tenth superlative category. |
| 23 | REWRITE. No congregation `EnsureCharacterByName`. Unsigned desk. **#26** unsolved. |
| 37 | Inbound Proclaim / Sound wait on **#27**. Not in the first-night slice. |
| 38 | REWRITE. PROTOCOL 2 packed **display names** only. No mute-card replica. |
| 73 | PARK with #47. No hold-timer detector. |
| 91–92 | DROP until David reopens #17. |

**#26 / #27:** filed, unanswered. Night-one refuse paths (unsigned desk; inbound spectacle off) are plan text only. **Not started in code.**

**In Wave 2 plan** = listed in the Wave 2 first-night coverage (1–10, 12–15, 18–19, 23–32, 36, 38–39, 44–46, 48–51, 54, 66–68, 101–106, 108, 110–112, 114–116, 118) **or** named in Task 12 (#107) / Task 13 toast copy (#40–42), and the work is not already in the tree. Item 118 stays **David** (human precondition). Item 36 is already true in tree.

**Done in tree** = the honesty leftover or keep is already on disk (spot-checked). Not a §22.3 pass.

---

## Counts

| Status | Count |
|--------|------:|
| Done in tree | 7 |
| In Wave 2 plan | 52 |
| Parked | 6 |
| David | 14 |
| Not started | 39 |
| **Total** | **118** |

---

## Items 1–118

| # | Item | Status | Spot-check |
|---|------|--------|------------|
| 1 | Rewrite leftover table in `docs/phases/v1-checklist.md` | **Done in tree** | Bottom leftovers table already lists #8 Council remainder, SUMMON, confession UI, live HUD health, cold-tools UI, two-client smoke — not “Console/HUD unhosted.” Stale “do not tick while #8 / favor remain leftovers” sentence still sits above §22.3; that is not the leftover table. |
| 2 | Rewrite `dress-rehearsal.md`; keep NOT RUN | **In Wave 2 plan** | Honesty map still describes empty `/beef` shell, unhosted Console/HUD, `#8` always false, Sound unwired. Status: NOT RUN. |
| 3 | Rewrite `guild-night-playtest.md` | **In Wave 2 plan** | Honesty (2026-08-15) still says `/beef` is Records Book, favor uncoded, congregation `/beef` stays the book. |
| 4 | Refresh A03 / A05 / A06 / A13 leftover lines | **In Wave 2 plan** | A03 already names Thedave. A05 still says `SetRaidTarget` is absent; A06 still says `TargetUnit` is absent. Live `UI/Markers.lua` calls both. Results stay NOT RUN. |
| 5 | Fix README “Decree is forthcoming” | **Done in tree** | README Quiet paragraph: “The Decree ships as that Quiet Mode parchment.” |
| 6 | Amend OPEN_QUESTIONS #11 congregation `/beef` | **Done in tree** | #11 already: congregation `/beef` is the player card. Not marked resolved (correct). |
| 7 | BeefNet header: STATE not “always false until #8” | **Done in tree** | Header: outbound STATE/SNAPSHOT/DECREE gated on listed Pope (`Data/Popes.lua` + `popeOverrides`). |
| 8 | Delete or regenerate `ChurchOfBeef.zip`; gitignore | **In Wave 2 plan** | `.gitignore` already has `/ChurchOfBeef.zip`. Repo-root zip still on disk. |
| 9 | §19.5 welcome parchment, first launch only | **In Wave 2 plan** | No `UI/Welcome.lua`. Not in TOC. |
| 10 | Welcome copy + one-surface vs Decree | **In Wave 2 plan** | No welcome surface. Wave 2: do not say “click a name” before a HUD exists. |
| 11 | DROP TOC Notes / Gora word | **Done in tree** | TOC: `## Notes: Ceremony, sanctioned Gora, and memory…`. Interface `20506`. |
| 12 | `/beef help` one chat line | **In Wave 2 plan** | Slash has `minimap` / `console` only. No `help`. |
| 13 | Unknown slash args must not toggle the card | **In Wave 2 plan** | `ChurchOfBeef.lua`: “Unrecognised arguments open the player card.” |
| 14 | Gate `/beef console` for non-Popes | **In Wave 2 plan** | `Console:Show` always `Init`s and `Show`s. Verbs refuse `not a registered pope`; the desk is not gated. |
| 15 | Unrecorded copy: not gold `NEW` | **In Wave 2 plan** | `PlayerCard.COPY.unrecorded = "UNRECORDED"`; line “Not yet in the Church's record.” |
| 16 | DROP invented rank sentences | **Parked** | `Data/Ranks.lua` still paints headings (`Recruitment`, `Engagement`, …). Leave them. |
| 17 | PARK “Your card / History” | **Parked** | Card button stays `CHURCH RECORDS`. |
| 18 | `_WarnVersion` §13.4 sentence | **In Wave 2 plan** | Live copy: “a guildmate is running BeefNet v%s; this client speaks v%d…” |
| 19 | Version mismatch drops Event chrome | **In Wave 2 plan** | `test_net_v2.lua` / `test_ceremony_chaos.lua` still pin live event surviving skew. |
| 20 | Empty Chronicle gloss | **Not started** | Records empty leaf is only “Nothing has been written yet.” |
| 21 | PARK Iron Chin / Martyr subtitles | **Parked** | Categories already exist as records. Do not dress a tenth. |
| 22 | Align minimap / Decree / card on meetup notice | **Not started** | Minimap: “GUILD GATHERING” + Decree line. Card plate: `GATHERING` + Decree line or “No gathering is posted.” Not the shared “meetup notice — where and when” line. |
| 23 | REWRITE: no congregation Ensure; unsigned desk | **In Wave 2 plan** | `bindLocalCharacter` walks Snapshot only (no `Ensure` today). INPUT still keys `decoded.characterId`. **#26** not started in code. |
| 24 | Ask-to-fight reasons that can fire | **In Wave 2 plan** | Strip hides when not live; no face-line for send-fail / already-asked / Knighting. |
| 25 | Face **Ask to fight** | **In Wave 2 plan** | Button text `Petition`; header `EVENT INPUT`. |
| 26 | Tooltip; unknown opponent must not refuse | **In Wave 2 plan** | `_HandlePetition` returns `"unknown opponent"` when the name is not in Store. (This is spec item 26, not OPEN_QUESTIONS #26.) |
| 27 | HUD hover “Click to pick this side” | **In Wave 2 plan** | `clickPlate` has no `OnEnter`. Name plates have click only. |
| 28 | Favor click must not silent-return | **In Wave 2 plan** | `clickPlate` returns if no `localCharacterId` or no pair. Footer stays `FAVOR`. |
| 29 | INPUT by server sender; ignore payload id | **In Wave 2 plan** | `_HandleFavor` / `_HandlePetition` / `_HandleConfession` use `decoded.characterId`. |
| 30 | Hide Inputs on listed Pope | **In Wave 2 plan** | Strip has no `IsRegisteredPope` hide. |
| 31 | Dest label matches send dest | **In Wave 2 plan** | Face can show `No recipient` while Net default dest is last STATE sender else `Popes.List[1]`. |
| 32 | Footer **Pick a side** / Crowd | **In Wave 2 plan** | `favorLabel` is `FAVOR`. |
| 33 | Dual-encode Arabic records | **Not started** | HUD / card use Romans (`romanPairText` / `romanPair`). Wave 2: optional, do not block names. |
| 34 | Label HUD defenses / H2H | **Not started** | Fighter card labels “Defenses”; HUD paints unlabeled Romans. |
| 35 | Fighter-card Stipulation = tonight’s rule | **Not started** | Label is still `Stipulation`. |
| 36 | Do not mint ranks / second writer | **Done in tree** | Congregation bind does not `Ensure` / `SetRank`. Wave 2 Task 6 must not add a pew mint. |
| 37 | Inbound Proclaim / Sound wait on **#27** | **Not started** | Pope wraps stay local (`proclaim` in `InstallWire`). No inbound kind. Do not infer from `state`+`riteType`. **#27** unanswered. |
| 38 | PROTOCOL 2 packed display names only | **In Wave 2 plan** | `Codec.PROTOCOL = 1`. Closed `STATE_KEYS`. No names field. `MAX_BODY` 240. |
| 39 | HUD agrees on ASSEMBLY sanction | **In Wave 2 plan** | `livePair()` is `GetSanctioned()` or Gora **RITE** subjects only — not ASSEMBLY. |
| 40 | `Void.` → “This fight does not count.” | **In Wave 2 plan** | Toasts: `"Void."`. Free ruling already `"Free ruling."` or Pope text (keep). Task 13. |
| 41 | Sanction: one plain “sanctioned duel” line | **In Wave 2 plan** | Headline still “A Beef Gora is Sanctioned.” Task 13. |
| 42 | Cowardice headline must read as fled | **In Wave 2 plan** | “Cowardice recorded: … So ruled by the Beef Pope.” No “fled.” Task 13. |
| 43 | Keep `RISE, BEEF KNIGHT` / `LORD` | **Done in tree** | Toasts already those headlines. Optional mute clause not required. |
| 44 | Latest-wins (seq greater; favor `>=`) | **In Wave 2 plan** | `Runtime:Restore` applies the snapshot wholesale. `RecordFavor` does not bump sequence. |
| 45 | `RequestSnapshot` only after HELLO/STATE this session | **In Wave 2 plan** | Bootstrap never calls `RequestSnapshot`. No Tuesday-from-`List[1]` either (good); gated ask is missing. |
| 46 | Congregation must not apply SV Runtime at login | **In Wave 2 plan** | `DB:Init` always `restoreEventFromSv` for everyone. |
| 47 | Paint `awaitingPope` only if flag set | **Not started** | Flag + `MarkPopeLost` exist. No HUD/copy paint. No detector (correct). Complements parked #73. |
| 48 | Pope login/`/reload` `sendState()` after `InstallWire` | **In Wave 2 plan** | HELLO rebroadcast exists. No post-`InstallWire` self send for a restored live event. |
| 49 | Player card and Records Book must not stack | **In Wave 2 plan** | `OpenRecords` hides the card. `RecordsBook:Show` does not hide the card. `/beef` Toggle does not hide the book. |
| 50 | Records Book return to the card | **In Wave 2 plan** | Book has Close only. No Home / Your card. |
| 51 | Persist live Gora desk (Pope `/reload`) | **In Wave 2 plan** | Gora desk is memory-only. No `Gora:Snapshot` / `Restore`. |
| 52 | Persist Knighting line | **Not started** | `Knighting` `line` is a local. Wave 2 pushed later. |
| 53 | Persist Confession inbox | **Not started** | Inbox memory-only. No congregation confession UI (#17). |
| 54 | Snapshot Store + event after Pope writes | **In Wave 2 plan** | Persist is `PLAYER_LOGOUT` / `DB:Save` only. No write-path debounce. |
| 55 | Needs-Knighting from store rank only | **Not started** | Presence is a census (`Unrecorded`, counts). Do not mix with #13. |
| 56 | Stop fail-opening “everyone in Store is present” | **Not started** | `presentCharacterIds`: if roster ready but not complete, every store character is marked present. |
| 57 | After A04: `GuildPromote` on Pope client only | **David** | Console header: “No GuildPromote.” Wait for A04 Result. Agents do not invent the write. |
| 58 | Desk-visible mark refuse | **Not started** | `Markers` `pcall`s `SetRaidTarget`; no GateStatus / target-line refuse. |
| 59 | Skip `TargetUnit` in combat lockdown | **Not started** | `Markers` always `pcall(TargetUnit, …)`. No `InCombatLockdown` guard. |
| 60 | Guard double-click re-knight / re-elevate | **Not started** | Core can refuse `"already knighted"`. Desk has no stream double-click guard. |
| 61 | Surface `Gora:Recommend` as glanceable context | **Not started** | API exists. Console does not paint it. No pairing score. |
| 62 | Pope verb `FlagFamousUpset` | **Not started** | `Store:FlagFamousUpset` unused by Console. |
| 63 | Keybinds or a named OPEN_QUESTION | **Not started** | Zero `SetBinding`. Do not invent a bind UI. |
| 64 | Wire `Roster:SetOnChanged` to open Console | **Not started** | Setter exists. No Console/card caller. |
| 65 | `Roster:GetMembers()` copy; stop live `.members` | **Not started** | No `GetMembers`. Console reads `Roster.members` live. |
| 66 | `pcall` every `Init` | **In Wave 2 plan** | Minimap, RecordsBook, PlayerCard, Hud run bare in `initUi`. |
| 67 | Hud/Inputs inherit; drop only if 20506 throws | **In Wave 2 plan** | Both use `BackdropTemplate`. Stub never throws. |
| 68 | Fail-soft `initUi`; always `Net:Init()` | **In Wave 2 plan** | Bare Hud Init can abort before Net. |
| 69 | Coalesce HELLO-triggered STATE | **Not started** | `_OnPeerHello` calls `sendState()` per peer HELLO. |
| 70 | Coalesce `RecordFavor` → STATE to token bucket | **Not started** | `wrapAfter(RecordFavor, sendState)` is immediate. |
| 71 | Congregation whispers on outbound budget | **Not started** | `_TransmitWhisper` sends immediately (size-checked only). |
| 72 | Evict-oldest inbound table; do not reset Pope tokens | **Not started** | At 200 keys: `self.inbound = {}`. |
| 73 | PARK disconnect detector / hold timer | **Parked** | OPEN_QUESTIONS #13. Do not code “no STATE for N seconds.” |
| 74 | `Store:Restore` fail-closed on Prophet / Grant keys | **Not started** | Restore loads rows; no Grant/Prophet refuse (Archive has the check). |
| 75 | `restoreFromSv` must check Restore returns | **Not started** | `store:Restore(db.store)` return ignored. |
| 76 | Empty Snapshot arrays must not wipe on ordinary Init | **Not started** | `isSnapshot` + Restore can apply empty `humans`/`characters` tables. |
| 77 | Quarantine leftover `Gora:Challenge` / TTL 1800 | **Not started** | `Challenge` / `GetPending` / `CHALLENGE_TTL = 1800` still in `Gora.lua`. |
| 78 | Remove unused `Group.CountGuildmates` | **Not started** | Defined in `Common.lua`. No TOC caller. |
| 79 | `writeBoth` fail-closed (both or neither) | **Not started** | First `RecordGoraResult` can succeed; second failure leaves an asymmetric bout. |
| 80 | Walk two-client smoke (Gate W) | **David** | `docs/phases/two-client-smoke.md` NOT RUN. After Wave 2 23–38 land. |
| 81 | Walk `solo-smoke.md` | **David** | NOT RUN. |
| 82 | Appendix A Results A01–A04 | **David** | Ledger NOT RUN. Agents do not tick. |
| 83 | Walk A05 / A06 / A08 / A13 live | **David** | Sheets NOT RUN; Markers / Sound / login banner already exist. |
| 84 | Small guild-night playtest after #80 | **David** | NOT RUN. |
| 85 | Dress rehearsal (release gate) | **David** | NOT RUN. §22.3. |
| 86 | Gate U screenshot / taste pass | **David** | `POLISH:PASS` is human. |
| 87 | Confirm Thedave is the live writer | **David** | `Data/Popes.lua` lists `Thedave`. Agents do not invent names or edit WTF. |
| 88 | Answer or defer #13 / #14 for night one | **David** | Do not invent in code. |
| 89 | Keep `## Version: 0.1.0` as alpha | **David** | TOC already `0.1.0`. No store Release until #85 and OPEN_QUESTIONS #1. |
| 90 | §22.3 streamed Gathering | **David** | Agents never claim this. |
| 91 | DROP Archive export/import UI | **Parked** | OPEN_QUESTIONS #17. Core codec stays. |
| 92 | DROP reminder widgets | **Parked** | Widget shape unlicensed. |
| 93 | Pope Notebook Core API (no UI) | **Not started** | No Notebook module. |
| 94 | Gate `CanonizeMoment` to cold / QUIET | **Not started** | Write exists; no QUIET check. |
| 95 | Stamp honorifics as events | **Not started** | `AddHonorific` appends a string list. |
| 96 | `SetRank` appends membership history | **Not started** | Sets `rankId` / `elevationAt` only. History kinds stay `created` / `linked` / `inactive`. |
| 97 | Regenerate responsive renders; drop dashboard/dock | **Not started** | `docs/design/renders/responsive/*/dashboard.png` (and dock) still present. |
| 98 | Protect ImageGen stems from geometry overwrite | **Not started** | `scripts/make-geometry-placeholders.py` still writes papal / victor / gora / minimap. |
| 99 | Provenance table; no variable `[wght]` TTFs | **Not started** | No provenance table in-tree. Shipped fonts are Regular `.ttf` (no `[wght]` in Media). SOUNDKIT only. |
| 100 | In-client smoke of card / Console / Inputs / seals | **David** | Geometry ships. David walk. `POLISH:CANDIDATE` only. |
| 101 | Listed Pope desk door on card and/or slash line | **In Wave 2 plan** | Card: CLOSE + CHURCH RECORDS only. Bare `/beef` is the card. |
| 102 | `PHASE_HINT` names the next verb | **In Wave 2 plan** | “Gathering live — no rite open.” / “Gora rite open.” — rite, not next click. |
| 103 | Paint verb refusals on `GateStatus` | **In Wave 2 plan** | `after()` refreshes only on success. `GateStatus` is `not a registered pope` or empty. |
| 104 | Petition row fills next empty Fighter A/B | **In Wave 2 plan** | Row click is `SelectCharacter` only. |
| 105 | Pair names select; `DECLARE VICTOR` commits | **In Wave 2 plan** | `PairVictorA` / `PairVictorB` call `DeclareVictor` immediately. |
| 106 | After a successful ask: asked / waiting | **In Wave 2 plan** | `Inputs:Petition` sends; face does not paint asked/waiting. |
| 107 | Hide Ask during live Knighting | **In Wave 2 plan** | `eventLive()` is any non-QUIET. Task 12 may land this. |
| 108 | When Runtime ≠ QUIET, Gathering line says started | **In Wave 2 plan** | Card / minimap still follow Decree line only. No toast. |
| 109 | After End the gathering, posted Decree not “live” | **Not started** | EndEvent does not clear or past-tense the Gathering line. |
| 110 | HUD after a ruling reads as ruled | **In Wave 2 plan** | `displayPair()` keeps `lastPair` through CONSEQUENCE with `VS` + `FAVOR`. |
| 111 | Congregation fighter card must not resurrect on post-verdict RITE | **In Wave 2 plan** | `_HandleState` wrap re-`showFighterCard` when RITE + two fighter ids (self-echo skipped on Pope only). |
| 112 | Not-in-guild / offline-Pope / send-fail on Inputs face | **In Wave 2 plan** | Availability is live + characterId + listed Pope name. Silent whisper fail. |
| 113 | Congregation Decree restore display-only until accepted DECREE | **Not started** | `DB:Init` restores decree for everyone. Wave 2 Task 10 defers. |
| 114 | Byte-budget harness through `Net:Send` | **In Wave 2 plan** | Codec tests do not pin `#payload <= 240` via `Send`. |
| 115 | `SCHEMA_VERSION` stays **7** | **In Wave 2 plan** | Live version is 7. Welcome / gora must use `applyDefaults` — do not stamp 8. |
| 116 | Gora persist Pope-only; restore after event | **In Wave 2 plan** | No `gora` blob. Shared-account wipe hole is why congregation must not `Save()` empty gora. |
| 117 | Desk line if shipping #56 empty-unknown with live petitions | **Not started** | Do not ship #56 the same night without “roster unread — showing all written names.” |
| 118 | #87 is a precondition for any two-client claim | **David** | Agents do not invent names. Same human confirmation as #87. |

---

## Wave 2 first-night vs this checkout

Lua slice (Tasks 1, 3–14) is **not in the tree**. Honesty leftovers are mixed: leftover table, README Decree, OPEN_QUESTIONS #11, BeefNet header, TOC Notes, and `.gitignore` zip rule already match the product; dress-rehearsal, guild-night, A05/A06 leftover sentences, and the on-disk zip do not.

Lawful defaults that must stay refuse paths until David answers:

- **#26** — unsigned desk name; no Store write on pew or silent Pope `Ensure` on INPUT.
- **#27** — names on PROTOCOL 2 only; inbound `Toasts:Proclaim` / `Sound` off.

The superseded plan `2026-09-14-church-of-beef-first-night-congregation.md` is not a status source.
