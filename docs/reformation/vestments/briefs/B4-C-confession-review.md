Spec PASS

# B4-C — Private confession inbox (review)

**Quality:** Approved-with-nits

**Lane:** B4-C Private confession inbox (Core)
**Brief:** `docs/reformation/vestments/briefs/B4-C-confession.md`
**Writer report:** `docs/reformation/vestments/briefs/B4-C-confession-report.md`
**Diff:** `docs/reformation/vestments/briefs/B4-C-confession.diff`
**Exclusive files:** `addon/ChurchOfBeef/Core/Confession.lua`, `tests/test_confession.lua`

Task-scoped gate only. Reviewer read the brief, the report, `Confession.lua`, and `tests/test_confession.lua`; then ran `lua tests/test_confession.lua` (158 passed, 0 failed, exit 0). Did not mutate the working tree except this review file. Did not edit `Confession.lua` or the suite. Did not commit.

This review does not sign the lane.

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Memory-only; never SavedVariables / Store write / DB | **Pass.** Inbox and `nextSeq` are file-local. Source has no `ChurchOfBeefDB`, no Store write, no DB. Suite plants `{ sentinel = 1 }` and re-reads it after Receive / GetQueue / CallForward / Dismiss. |
| Event-scoped expire (same idea as Gora petitions) | **Pass.** `liveEventId` matches Gora: missing Runtime / missing Snapshot / `QUIET` / non-id `eventId` → nil → wipe. Leftover `entry.eventId` drops while a later event is live. OpenRite / CONSEQUENCE / Continue keep. EndEvent and a Snapshot without `eventId` wipe. |
| `Receive` — latest text replaces; one row per character | **Pass.** Map keyed by `characterId`. Second line overwrites `text` and does not mint a row. Quiet / no live id → `nil, "no event"`. |
| `characterId` is a positive integer; Store-missing desktop ids may queue; Store present + `GetCharacter` nil → `unknown character` | **Pass.** `isId` is number / integer / `>= 1`. Name string and `0` are `invalid character id`. Human id with no character row is `unknown character`. `COB.Store = nil` still queues id `99`. |
| `text` optional; non-string or embedded `"\n"` → `invalid text`; empty / whitespace → store no text | **Pass.** Newline (including a lone `"\n"`) refuses and does not rewrite the standing line. `12` refuses. Omitted / `"   "` store `text = nil`. |
| `GetQueue` returns copies, oldest-first | **Pass.** `copyRow` omits `eventId` / `seq`. Suite mutates a returned row's `text` / `called` / `characterId`; the inbox does not move. First arrival stays first after replace. |
| `CallForward` marks only; no announce | **Pass.** Sets `called = true`. Returns true/false. No chat, addon message, Proclaim, or Play. Planted `COB.Toasts` / `COB.Sound` stay at zero. Does not reorder. |
| `Dismiss` removes that character | **Pass.** True on a live row; false when absent or after wipe. Re-Receive after Dismiss is a new newest row. |
| `ResetForTests` is `_IN_TEST` only | **Pass.** Out-of-harness returns false and leaves a planted row. Under the flag, reset clears the inbox and `nextSeq`. |
| No `CreateFrame` | **Pass.** Source grep and a replaced `CreateFrame` stay at zero across the verbs. |
| No Toasts / Net / Sound | **Pass.** Source has no `COB.Toasts`, `COB.Net`, `COB.Sound`, or `PlaySound`. Isolation pins those modules nil when standalone. |
| No fan-out | **Pass.** No `SendChatMessage`, `SendAddonMessage`, `Broadcast`, `FanOut`, or Proclaim. CallForward is a boolean mark. |
| No penance / sin categories / rewards | **Pass.** No `Penance`, `Grant`, dialogue, or progression. Public row is `{ characterId, text, called }`. |
| Isolated suite; isolation under `if standalone then` | **Pass.** Load list is wow_stub + Common + Store + Runtime + Confession. **19** nil-module pins sit inside `if standalone then`. |
| `lua tests/test_confession.lua` exit 0 | **Pass. Verified.** 158 passed, 0 failed. |
| Exclusive files only; no TOC / `run.lua` / Store / Gora / BeefNet / Toasts / commit | **Pass.** Provided diff is the two exclusive files. Current TOC and `tests/run.lua` still omit this module (integrator work, as the brief required). |

Bible §9 / §13.4 and Law 4 hold on this pair: the module organizes a private queue and does not write the Pope's response or publish free-typed text.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Integrator must list TOC / `run.lua` and wire B4-A / B4-D / B4-G | **Not a miss.** Brief forbade those edits. |
| GetQueue has no present-and-alive filter | **Not a miss.** Brief asked copies, oldest-first — not Gora's `GetPetitions(presentAndAlive)` gate. |
| Replace keeps first-arrival order and the `called` mark | **Acceptable reading; untested mark.** See Minor. |
| `called` is this lane's mark; B4-D may ignore it | **Not a miss.** Brief named the mark. Console paint is name + text. |
| No client `/reload` smoke | **Expected.** Memory-only Core; no Quiet chrome. |

---

## Named risks

| Risk | Verdict |
|---|---|
| Memory-only / no SV | **Clean.** File-local map. No SV symbol. Sentinel pin holds. |
| Event-scoped expire | **Clean.** Gora-shaped `liveEventId` + leftover drop. Suite covers Quiet, OpenRite, CONSEQUENCE, Continue, EndEvent, missing `eventId`, and a fresh StartEvent. |
| GetQueue copies | **Clean.** Shallow copy is enough (integers, boolean, string). Mutation pin is real. |
| CallForward mark-only | **Clean.** No send / Proclaim / Play path exists to miss. |
| Newline refuse | **Clean.** Plain `find("\n")` before trim. Standing text survives the refuse. |
| Isolated green | **Clean.** Re-run here: 158 / 0, exit 0. |

---

## Strengths

- Expire is a copy of the Gora petition rule, not a second clock or a invented TTL. QUIET and a missing event id wipe; the same `eventId` survives rite changes.
- Getters hand out `{ characterId, text, called }` only. Live `eventId` / `seq` stay inside the module. Mutating a queue row cannot rewrite the inbox.
- Receive is one row per character with in-place text replace. That is congregation-crash dedupe (§20.3), not a list of past sins.
- CallForward cannot fan out. The planted Toasts / Sound traps and the source greps agree.
- Isolation stayed gated. The suite can join `tests/run.lua` later without the nil-module pins exploding.
- Store is a read (`GetCharacter`) or absent. Desktop ids still queue. That matches the brief's two-world rule.

---

## Issues

### Critical

None.

### Important

None.

### Minor

1. **Replace keeps `called`.** `Receive` on an existing id overwrites `text` (and refreshes `eventId`) and leaves `called` as-is. The brief said "latest text replaces," not "re-queue." The suite never CallForwards and then Receives, so a later consumer that treats `called` as "currently at the fountain" can stay stuck on after a new line. Writer already named this.

2. **Receive's return is a copy in source, not in the suite.** The mutation pin is `GetQueue()[1]`. `Receive` also `copyRow`s. An implementer could return the live entry from Receive and still pass.

3. **`Confession:_Expire` is an extra public colon method.** Not in the brief API. Same shape as Gora. Harmless if nobody else calls it; it is still surface.

4. **Expire wipe does not reset `nextSeq`.** `ResetForTests` does. After EndEvent the inbox is empty, so order is fine. Sloppy versus the harness reset, not a scope bug.

5. **No length cap.** Brief did not ask for one. Wire size is a B4-A problem. This inbox will hold whatever string Receive accepted.

6. **Client `/reload` was not run.** Expected for a memory-only Core module with no chrome.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.** Gate PASS for this lane's contract. Do not sign.

The exclusive pair does what the brief asked: a process-memory confession inbox, event-scoped like Gora petitions, copies out, CallForward as a mark, Dismiss, `_IN_TEST` reset, newline refuse, no frames / Toasts / Net / Sound / fan-out / penance. Isolated `lua tests/test_confession.lua` was re-run here and finished **158 passed, 0 failed**. Nits are an untested keep-`called` on replace, an unpinned Receive copy, and a leftover public `_Expire` — not trust-breakers.

Do not claim **POLISH:PASS**. Do not claim V1 / MVP complete.
