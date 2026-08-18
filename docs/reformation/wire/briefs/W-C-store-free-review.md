# W-C — Store free ruling (review)

**Lane:** W-C Store free ruling (license 3)
**Brief:** `docs/reformation/wire/briefs/W-C-store-free.md`
**Writer report (unverified):** `docs/reformation/wire/briefs/W-C-store-free-report.md`
**Diff:** `docs/reformation/wire/briefs/W-C-store-free.diff`
**Exclusive files:** `addon/ChurchOfBeef/Core/Store.lua`, `tests/test_store.lua`

**Spec:** PASS
**Quality:** Approved

Task-scoped gate only. Reviewer read the brief, the writer report, and the provided diff; then checked `RecordGoraResult`, `AppendCeremony`, `ensureCharacter` / `Restore`, and the revoked suite block. Did not mutate the working tree, did not re-run the harness, and did not treat writer counts as verified. One focused call-site check: `Recognition` still uses 3-arg `AppendCeremony`; `Gora:FreeRuling` (W-B, already in tree) already omits `won` and passes `fields.text`.

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no Gora / Codec / Net / UI / TOC / bootstrap / `run.lua` / OPEN_QUESTIONS / REFORMATION_LOG / commit | **Pass.** Provided diff touches only the two exclusive files. |
| `ruling == "free"` accepts absent or `nil` `won` | **Pass.** Free branch refuses only `won == true` or `won == false`, then forces `won = nil`. Suite writes free with omitted `won` and with explicit `won = nil`. |
| `won == true` / `won == false` refused; store unchanged | **Pass.** Error is `free ruling has no won flag` (brief wording). Refuse runs before tallies, h2h, rulings, or results. Suite asserts `nil` + error string and unchanged wins / losses / streak / result count. |
| No increment of wins, losses, or signed streak | **Pass.** Tallies still gate on `won == true` / `won == false`. After the free coerce, `won` is nil so neither branch runs. |
| Still append `rulings` and `results`; increment h2h `fights` (same as Void); no h2h W/L | **Pass.** `h2h.fights` increments unconditionally; h2h W/L still require boolean `won`. |
| Result row: `ruling = "free"`, `won = nil`, `text` trimmed or nil, `famousUpset` boolean default false | **Pass.** `text` is attached only on free. Trim / empty → nil via existing `trim`. |
| `fields.text` if present must be a string; non-string error | **Pass.** `nil, "text must be text"` — same style as `FlagMoment`'s location check. |
| `opponentId` rules unchanged | **Pass.** Same id / self / unknown-opponent checks, still before the won gate. |
| Void unchanged (`won` forced nil; no W/L) | **Pass.** Restructured from `ruling ~= "void"` to an explicit void arm; behavior is the same, including silently ignoring a boolean `won`. |
| Victor / Cowardice still require `won == true` or `false` | **Pass.** Else arm still returns `ruling needs a won flag`. Existing suite block left in place. |
| Revoke `free` + `won = true` as a victory | **Pass.** That block is gone; the same inputs are now a refuse. |
| `AppendCeremony(entryType, participantIds, now)` kept; optional 4th `text` | **Pass.** 3-arg callers remain valid (`Recognition.lua` is still three arguments). Nil / omitted → no `text` key. String trimmed; empty → omitted. Non-string → `nil, "text must be text"` before `takeId`. |
| No `narration` / `scripture` / generated prose | **Pass.** Store only persists caller `text`. Suite asserts those keys stay nil. |
| Restore keeps `ruling == "free"` + `won == nil` + optional `text`; does not invent `won = false`; leftover keys survive | **Pass.** `ensureCharacter` still does not walk `results` or default `won`. New suite mutates leftover keys on a snapshot and asserts they survive. |
| Named tests (free without won, refuse booleans, omit/blank text, void/victor/cowardice unchanged, 3-arg + 4-arg ceremony) | **Pass.** All present. Isolation `if standalone then` kept. |

Product law (CONTINUE license 3 / OPEN_QUESTIONS #10): a FREE RULING is not a fifth W/L outcome and not a silent Void. The store writes a bout (rulings + results + h2h fights) and optional Pope text, and writes no win/loss. That is what landed.

---

## Strengths

- The won gate is a clear three-way policy (`void` coerce / `free` refuse-boolean-then-coerce / else require-boolean) instead of another nested exception on the old `ruling ~= "void"` test. Victor, Cowardice, and Void keep one increment path; free does not duplicate tally math.
- Text is scoped to free result rows only. It is not written onto `rulings[]`, not copied onto victor/void/cowardice, and not invented as narration. Ceremony text is the optional 4th argument, validated before an id is consumed.
- Refuse paths mutate nothing. Text validation sits after the won gate and before `h2hFor` / appends, so a bad `text = 42` leaves the character untouched.
- The revoked victory product is actually gone, not just commented. New asserts cover the brief’s named cases: omitted won, explicit nil won, both booleans refused, trim, omit, whitespace, non-string, h2h fights++ without W/L, `famousUpset` default false, 3-arg ceremony, 4-arg trim/omit/refuse, Restore leftover keys.
- Field name `fields.text` matches the already-landed W-B `writeBoth` path. Recognition remains a 3-arg caller. No exclusive-file breach in the diff.

---

## Issues

### Critical

None.

### Important

None.

### Minor

1. **Junk non-boolean `won` on free is coerced, not refused.** `won = 0`, `won = "yes"`, or a table is neither `true` nor `false`, so the free arm accepts it and forces `won = nil`. That matches the brief’s explicit refuse clause (`true` / `false` only) and the writer’s self-review. It is slightly looser than the sentence “`won` must be absent or nil.” Live W-B omits the field. Not a product miss; not worth a rewrite unless a later lane wants a stricter type check.

2. **Refuse-path tests use proxies.** They assert result-count / W/L and `type(err) == "string"`, not the exact `"free ruling has no won flag"` string and not h2h `fights` on the refuse path. Safe because the gate sits before any write; still a slightly softer pin than the brief’s wording.

---

## Assessment

**Spec PASS. Quality Approved. Gate PASS.**

This is the license-3 store contract: free without a won flag, Pope text on the bout and on an optional ceremony argument, no W/L or streak, fight still counted, Void still silent-coerce, Victor/Cowardice still require a boolean. Restore does not invent `won = false`. Exclusive files only. No Gora edit.

Writer-reported `lua tests/test_store.lua` **330 / 0** and full-harness **5970 / 9** (W-A codec) were **not** re-run here. The Gora note in the writer report is consistent with the tree: W-B already calls this contract, so the brief’s “Gora may still expect `won == false`” leftover does not apply to this working tree.

No Critical or Important findings. Integrator can sign W-C on this diff; do not block on the two Minors.
