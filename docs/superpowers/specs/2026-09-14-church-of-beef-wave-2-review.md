# Church of Beef — Wave 2 planning review

**Date:** 2026-09-14  
**Status:** Adversarial revision of the 100-point spec and first-night plan. Subordinate to Bible v1.1.1.  
**Supersedes for sequencing:** the first-slice claim in `2026-09-14-church-of-beef-100-point-plan-design.md` §13, and the implementation plan `2026-09-14-church-of-beef-first-night-congregation.md`.  
**Executable plan:** `docs/superpowers/plans/2026-09-14-church-of-beef-first-night-wave-2.md`.

Wave 1 planning was right about the *audience*: this checkout is a Pope-client Gathering kit. Wave 2 is about the *solutions* Wave 1 licensed. Several of those solutions invent product, break the wire, or mint Church history on the wrong client.

The zip-install recruit who has never heard of a Gora is still the test user. So is Thedave on opening night: he knows the Church, not this desk.

---

## 1. What Wave 1 got right (do not reopen)

- Approach **C** (split tracks, newcomer-weighted). Approach A repeats the demo failure.
- The newcomer test in spec §2.
- Leftover docs and the 2026-08-20 zip still lie.
- Welcome parchment is Bible §19.5, one sheet, first launch, then silence.
- `/beef console` is administration; congregation is theater (§18.5).
- INPUT must key to the **server sender**, not a payload id.
- Congregation must not Restore Event Mode from SavedVariables.
- Gora desk is memory-only; Pope `/reload` then refuses `no sanctioned gora`.
- `initUi` must always reach `Net:Init()`.
- Agents do not tick Appendix A, dress rehearsal, or `POLISH:PASS`.
- Parked list (SUMMON, Curtain, Forever, Witness, confession UI) stays parked.

---

## 2. What Wave 1 got wrong (the holes that would ship)

Four Grok 4.6 extra-high reviews ([spec vs code](35aac5a9-82a4-4b5f-b5de-06509a6acb68), [first-night feasibility](54b73234-5525-4d9e-b07b-d4454a9dc1a8), [Pope + recruit night-two UX](91cd7220-4c6e-4af7-8412-51b7bd53282f), [law + wire](f9aede96-0f30-4ee2-a6c6-97634e02027a)) convicted the same three blockers and a fourth the 100 points barely named.

### 2.1 Congregation `EnsureCharacterByName` is a second writer

Wave 1 item 23 / first-night Task 6: bind by calling `Store:EnsureCharacterByName(UnitName("player"))` on the pew.

That function is the Pope recognition spine (`Store.lua`). On a miss it `CreateCharacter` + `CreateHuman` + `LinkCharacter`. `rankId` stays nil. The row, the link, and a history “linked” event are real. They persist through account-level `ChurchOfBeefDB`.

That violates Law 5 / §13.1, identity-records (no self-service linking), OPEN_QUESTIONS **#18** (target + Knight/Sanction *is* recognition), and Wave 1’s own item 36.

It also fails the product:

- The card becomes **entered / UNRANKED**. Item 15’s “you are new until the Pope writes you” never shows (`PlayerCard.lua`).
- Local id `1` is not the Pope’s id `1`. `_HandleFavor` does not even `knownCharacter` — a mismatched number steals a real member’s pick.
- `Gora:Petition` still refuses `unknown character` on the **Pope** store. Local mint does not unlock the ask.
- Same-account alt / Pope share one SV. Congregation `Save()` of an empty `gora` after `_Expire()` can wipe the Pope’s persisted desk.

**Lawful default until David answers OPEN_QUESTIONS #26:** no congregation Store write. INPUT ignore payload `characterId`; Pope apply by `Names.Key(sender)`. Unknown sender appears on the desk as an **unsigned** name. No `CreateHuman`. Named unknown opponent must not refuse the ask (drop or ignore the opponent id). Favor keys by sender name-key in Gora memory until a Pope verb writes the row.

### 2.2 “Allowed without a new protocol” is false

Live STATE (`Codec.lua`): closed `STATE_KEYS`, extra colon part → `"unknown field"`, `PROTOCOL = 1`, `MAX_BODY = 240`. Subjects are store integers. Verdicts (`DeclareVictor` / `Void` / `FreeRuling` / `CowardiceRecorded`) **do not** transition Runtime. After a ruling, STATE is still `RITE` + `Gora` + last pair. There is no clerical kind on the wire.

Consequences Wave 1 ignored:

- Same-PROTOCOL extra fields: old clients discard STATE **without** `_WarnVersion`. They sit on whatever `DB` restored.
- Mute-card replica (name, class, level, title, W/L, defenses, H2H) + stipulation will not reliably fit 240. Colon in a name or stipulation injects fields.
- Inbound `Toasts:Proclaim` cannot choose Victor vs Void vs Free vs Cowardice vs Knighting from Bible §20.2 fields. Item 37 is fiction without a beat.
- `CONSEQUENCE` hide-card vs `lastPair` HUD: congregation card **re-shows** on the next RITE STATE (`ChurchOfBeef.lua` wrap). Night-one spectacle: the tape comes back after the ruling.
- `RequestSnapshot` while QUIET returns `nil, "no event"`. Wave 1 item 45 whispers Thedave every Tuesday login (`Popes.List[1]`).
- Latest-wins as `seq > current` **drops every favor STATE and every HELLO refresh** (`RecordFavor` does not increment sequence).
- Equal-seq inbound Proclaim double-fires the Pope’s self-echo.

**Lawful default until David answers OPEN_QUESTIONS #27:** PROTOCOL bump to 2. Packed **display names** only (fighters / candidate). 240-byte harness pin through `Net:Send`. Paint-only — never upsert congregation Store. Inbound Proclaim / Sound **wait on #27**. Do not infer kind. Do not put W/L, H2H, title, stipulation, or free-ruling prose on the wire this pass.

Say “no new **TYPE** / no store-gossip / no generic theater opcode.” Do not say “no new protocol.”

### 2.3 The first-night plan would go green and still fail a second client

`wow_ui_stub` accepts `BackdropTemplate` and never throws. `C_Timer` is missing from `wow_stub.lua`. Nine tasks edit `ChurchOfBeef.lua`; four edit `Hud.lua`. Schema bump to 8 is unnecessary (`applyDefaults` already fills missing keys). `test_net_v2.lua` and `test_ceremony_chaos.lua` pin the opposite of version-drop. `test_wire_glue.lua` pins unknown slash toggling the card.

Task order was copy → mint identity → grow STATE → persist → boot safety. A Hud inherit abort dies before `Net:Init`.

### 2.4 The Pope desk was treated as already done

Wave 1 got the recruit as far as **Ask to fight**. It left Thedave without a door or a next verb.

- Bare `/beef` and minimap left-click open **his card**. There is no Pope control on that card. `/beef console` is the desk the plan will hide from congregation copy — and never paint for a listed Pope.
- `PHASE_HINT` names the rite (“Gathering live — no rite open.”) not the next click. `KNIGHT THIS BEEF` and `Gora:Sanction` already work in ASSEMBLY, so “Open a Knighting/Gora rite” is optional for the actual act.
- Verb refusals (`"Set Fighter A and Fighter B first"`, `"start from quiet"`, `"event ends from assembly or consequence"`) die in `after()`. `GateStatus` only shows `"not a registered pope"`. He mashes **End the gathering** during a Gora RITE and gets nothing.
- Petition row click is `SelectCharacter` only. He still has to press Fighter A/B. On a mic that is a missed beat.
- `PairVictorA` / `PairVictorB` call `DeclareVictor` as soon as `goraLive`. The names **are** the verdict. Stream fat-finger records a winner mid-duel.
- Presence is a census (`"Unrecorded"`, count). It cannot answer §18.1. Do not invent an online bit (#13).

A first public night fails if David cannot run the desk. That is P0, not Wave 6 polish.

---

## 3. Newcomer copy Wave 1 locked that would still fail

| Locked Wave 1 string | Why it fails |
|----------------------|--------------|
| Welcome / help: “Ask to fight, then click a name to pick a side.” | Favor plates exist only when `pickPair()` has a Gora RITE pair (or Pope `GetSanctioned()`). During ASSEMBLY the only Event chrome is the Inputs strip. They will click guild names. |
| Disable reasons: “Event is not live.” / “The Pope has not written you yet.” / “No Pope in range.” | Strip hides when not live; item 23 bind would always set an id; `listedPope()` is `Thedave` even when offline. After Wave 1 the strip is **enabled** with `To: Thedave` and a silent whisper fail. |
| `UNRECORDED` → gold plate `NEW` | Reads as a seventh rank. OPEN_QUESTIONS **#21**: in-guild zip recruits paint the live guild rank name and never hit the unrecorded branch. |
| `Void.` → “The Pope ruled.” (when free text missing) | Law 4 — software in the Pope’s mouth. Keep `"Free ruling."` or omit the sheet. |
| Rank `relationship` → Bible sentences for Fresh/Cooked/Council | Those ranks have **headings, no sentences**. Painting Knight/Lord lines onto Fresh Beef invents canon. |
| “Your card / History” as the Quiet pair | New product language. Not a first-night blocker. Keep `CHURCH RECORDS` unless David names the pair. |

Also missed:

- Successful ask is invisible; dismiss is invisible; two zip-fresh targeting each other die on `unknown opponent`.
- Ask to fight stays up during Knighting (`eventLive()` is any non-QUIET).
- Start the gathering does not change the card Gathering line, Decree header, or minimap tooltip. Night is a 64px strip at `BOTTOM, 80`.
- Welcome + Decree + Inputs can stack on first login *during* a night.
- After End the gathering, the Decree still looks like a posted meetup.
- Sanction headline is still “A Beef Gora is Sanctioned.” Mute Twitch has five seconds (`THEATER_HOLD = 5`).
- HUD `lastPair` through CONSEQUENCE still looks like the fight is on.

---

## 4. Open questions filed (do not resolve in code)

Appended to `docs/design/OPEN_QUESTIONS.md`:

- **#26 Petition-as-recognition** — Pope `Ensure` on INPUT sender vs unsigned desk name.
- **#27 Clerical beat on STATE** — PROTOCOL 2 closed beat vs Pope-local spectacle.

Also amended **#11**: congregation `/beef` is the player card. That does **not** resolve #11.

Until David answers:

| Question | Night-one default (not an answer — the refuse path) |
|----------|------------------------------------------------------|
| #26 | Unsigned desk row. No Store write. Ask still sends. Named unknown opponent is ignored, not a refuse. |
| #27 | Names on PROTOCOL 2. Inbound Proclaim / Sound off. Pope still wraps locally. |
| #13 | No online bit. Presence stays census. Target line + Knighting strip + petition strip are the working lists. |
| #17 | No Archive / Notebook / reminder UI. |

---

## 5. Honest first slice (replaces Wave 1 §13)

Approach C stands. The recommended first implementation is **not** items 1–50 + 51 + 54 + 66–68 as written.

**Do now (Wave 2 first-night plan):**

0. Boot: `pcall` every Init; drop `BackdropTemplate` pending a 20506 verify; always `Net:Init()`.
1. Stop lying: leftover table, dress-rehearsal, guild-night, A0x leftover *sentences*, README Decree, #11 clause, BeefNet header, zip + gitignore.
2. Welcome + slash honesty + console gate + unrecorded copy that is **not** a fake rank. Welcome vs Decree: do not stack two parchments.
3. INPUT by server sender; unsigned petitions; no congregation `Ensure`.
4. PROTOCOL 2 + packed display names + 240-byte pin + Snapshot overlay + inbound name stash (paint-only) + latest-wins that does not drop favor.
5. Congregation starts QUIET; Pope `/reload` rebroadcasts STATE **and** restores the Gora desk (Pope-only persist; no schema 8).
6. Ask to fight + hide Inputs on listed Pope + send-fail / not-in-guild copy on the strip.
7. Pope desk: a door on his card; next-verb hint; paint refuses; petition row fills an empty fighter slot (does not sanction); pair **names** select, `DECLARE VICTOR` commits.
8. Quiet/Event copy: Gathering line when live; welcome/help sequence that does not say “click a name” before a fight bar exists.
9. Two-client smoke. **#87 Thedave is a human precondition**, not Wave 6 trivia.

**Do not do in this slice:**

- Congregation Store mint (#23 as written).
- Mute-card replica on the wire (#38 as written).
- Inbound Proclaim until #27.
- Login snapshot every Tuesday (#45 as written).
- Invented `MarkPopeLost` timer (#47 / #73).
- Rank-sentence invention (#16), Quiet rename (#17), superlative subtitles (#21).
- Archive UI / reminder widgets (#91–#92) — conflict with #17.
- Presence-as-queue (#55 mixing #13).
- Schema version 8.
- Parallel edits of `ChurchOfBeef.lua`.

**Pull to P0 (were P1 or missing):** hide Inputs on Pope; Thedave confirmation; Pope desk door / next verb / refuse / petition≠pair / names≠verdict; not-in-guild + send-fail copy; welcome vs Decree order; Gathering line when live.

**Push later:** Arabic/Roman dual-encode (blank names kill the night, not Roman numerals); Knighting/confession persist; GuildPromote; keybinds; renders regen; Wave 7–8.

---

## 6. File collisions (do not parallelize)

| File | Must be serial |
|------|----------------|
| `ChurchOfBeef.lua` | Slash, bind, persist, STATE overlay, initUi, login restore, desk door |
| `UI/Hud.lua` | Backdrop, names, favor copy, awaiting, ASSEMBLY pair |
| `Core/DB.lua` | welcomeSeen, event restore split, gora persist |
| `Net/BeefNet.lua` | Header, version drop, sender-bind, dest helper |
| `Net/Codec.lua` + `Net/Snapshot.lua` | PROTOCOL 2, names field, 240 pin |
| `UI/Inputs.lua` | Ask to fight, hide-on-Pope, Backdrop, send-fail |
| `UI/Console.lua` | Show-gate, hints, refuses, petition slot, pair names |

Safe in parallel with the rest: leftover **docs** (if BeefNet stays a header sentence) and copy-only `Data/Ranks.lua` **if** #16 stays dropped.

---

## 7. Success criteria for Wave 2 planning (not §22.3)

This review succeeds when the next implementer:

1. Cannot ship congregation `EnsureCharacterByName` by following the plan.
2. Cannot grow STATE without a PROTOCOL bump and a 240-byte pin.
3. Cannot infer a Proclaim kind from `state` + `riteType`.
4. Gives Thedave a desk door and a next verb before claiming “second human can join.”
5. Files #26 / #27 instead of answering them.
6. Still does not claim MVP complete or `POLISH:PASS`.

§22.3 remains a human night after the Wave 2 first-night plan is walked on two clients.
