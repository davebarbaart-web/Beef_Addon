Spec PASS

# B17-A — Petition INPUT may name an opponent (review)

**Quality:** Approved-with-nits

**Lane:** B17-A Petition INPUT may name an opponent
**Brief:** `docs/reformation/vestments/briefs/B17-A-codec-opponent.md`
**Writer report:** `docs/reformation/vestments/briefs/B17-A-codec-opponent-report.md`
**Diff:** `docs/reformation/vestments/briefs/B17-A-codec-opponent.diff` (B17-A-only exclusive-pair packet; live `Codec.lua` also carries earlier codec batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/Net/Codec.lua`, `tests/test_net_codec.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `Net/Codec.lua` (`INPUT_KEYS.opponent`, encode after pick checks, decode petition 5th part), and `tests/test_net_codec.lua` (four-part `opponent == nil`, nested `do` named-opponent pins, moved `please` pin, colon / newline / favor / confession refuses, isolation wrap); then ran `lua tests/test_net_codec.lua` (**480 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: Bible §10.2 (a petition may name a desired opponent); §13.1 / §18.5 (congregation input; names, not Pope Store ids); Law 4; no new kind; four-part petition unchanged; `text` / `pick` still refused on petition; `opponent` refused on favor / confession; colon / newline invalid; 5th petition part decodes as opponent. Isolation Common + Codec only. Did not mutate `Codec.lua` or `test_net_codec.lua`. Did not commit. Did not edit BeefNet, Inputs, Gora, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| New INPUT kind or fifth TYPE | **Pass.** `INPUT_KINDS` is still petition / favor / confession (count **3**). `TYPES` is still STATE / SNAPSHOT / INPUT / DECREE (count **4**). No `EncodeOpponent`. Probe: `kind = "challenge"` is `"invalid kind"`. |
| Four-part `{ kind = "petition", characterId = 3 }` no longer `1:INPUT:petition:3` | **Pass. Verified.** Existing pin stays. Probe: same wire; decode `opponent == nil`, `text == nil`, `pick == nil`. |
| `text` / `pick` accepted on petition | **Pass. Verified.** Existing pins stay (`"text not allowed"`, `"pick not allowed"`). Probe: `text` + `opponent` still `"text not allowed"`; `pick` + `opponent` still `"pick not allowed"`. |
| `opponent` accepted on favor / confession | **Pass. Verified.** Pins: both `"opponent not allowed"`. Probe: confession `text` + `opponent` is also `"opponent not allowed"`. |
| Colon / newline opponent encodes | **Pass. Verified.** Raw-string check before trim. Pins: `"Chuck:roast"`, `"Chuck\nroast"`, trailing `"\n"`. Probe: same three → `"invalid opponent"`. Non-string `7` / `false` / `{}` also `"invalid opponent"`. |
| `Decode("1:INPUT:petition:1:please")` still `"text not allowed"` | **Pass.** Old refuse removed. New pin: `opponent == "please"`, `text == nil`. Probe: same. |
| Petition 6+ parts accepted; favor 5th / confession 5th+ rewritten | **Pass. Verified.** Sixth part pin `"text not allowed"`. Favor wire `1:INPUT:favor:8:9` still `pick == 9`. Confession `forgive:me:twice` still concatenates from part 5. Favor 6th pin stays `"text not allowed"`. |
| Empty / whitespace `opponent` written as an empty 5th field | **Pass. Verified.** `""` / `"   "` encode four-part. Probe: `"\t\t"` also omits. |
| `SendAddonMessage` / `CreateFrame` / `GuildPromote` | **Pass.** Source has no `SendAddonMessage` / `CreateFrame` / `GuildPromote` / `SetGuildRank`. Suite `sent` pin stays 0. Probe: named encode / decode leaves `sent == 0`. |
| Isolated suite not exit 0 | **Pass. Verified.** 480 passed, 0 failed. Writer-reported count matches. |
| Exclusive file breach | **Pass.** Packet is two `diff --git` hunks (`INPUT_KEYS` + encode + petition decode; four-part pin + nested `do` + moved `please` refuse). Sibling dirt in this workspace is other lanes (BeefNet, Inputs, Gora, TOC, bootstrap, `run.lua`). |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no BeefNet / Inputs / Gora / glue; no commit; no new kind | **Pass.** Named-risk check. |
| Isolation stays Codec-only (existing Common + Codec suite) | **Pass.** Two `dofile`s unchanged. Load wrap still **4** nil-module pins under `if standalone then`. |
| Optional `opponent` is a trimmed character **name** string on `INPUT_KEYS` | **Pass.** Key added. Encode: petition-only; string; trim; empty omitted. Decode 5th part trimmed. Numeric id refused. |
| `{ kind = "petition", characterId = 3 }` still encodes `1:INPUT:petition:3` | **Pass.** Named-risk check. |
| `text` still refused on petition; `pick` still refused on petition | **Pass.** Named-risk check. |
| `opponent` refused on favor and confession | **Pass.** Named-risk check. |
| Empty / whitespace-only `opponent` omitted (four-part), not an empty field | **Pass.** Named-risk check. |
| `opponent` containing `:` or `"\n"` → encode `nil` / `"invalid opponent"` | **Pass.** Checked on the raw string so a trailing newline cannot trim through. |
| Decode: petition 5th part is `opponent` (trimmed); more than 5 parts → `"text not allowed"` or `"unknown field"` | **Pass.** Sixth part is `"text not allowed"`. |
| Favor 5th part stays `pick`; confession 5th+ stays `text` | **Pass.** Named-risk check. |
| Update `Decode("1:INPUT:petition:1:please")` — 5th part is now a legal opponent name | **Pass.** Named-risk check. |
| Pin encode/decode round-trip `opponent = "Chuckroast"` → `1:INPUT:petition:3:Chuckroast` | **Pass.** Nested `do`: `EncodeInput`, unified `Encode`, `Decode`, `DecodeInput`. |
| Colon / newline opponent refused; favor / confession with `opponent` refused; isolation wrap stays | **Pass.** Named-risk check. |
| `lua tests/test_net_codec.lua` exit 0 | **Pass.** **480 / 0.** |

Bible §10.2 holds on the exclusive pair: a named opponent is a field on existing petition INPUT, not a fifth message type. §13.1 / §18.5 hold: the wire carries a name, not a Pope Store id. Law 4 holds: the codec does not announce, resolve, or invent a Gora.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Decode of an empty or whitespace 5th part omits `opponent` | **On contract.** Brief: 5th part is opponent (trimmed). `trim("")` is nil; encode omit is the same rule. Pin and probe both keep a successful four-part-shaped decode with `opponent == nil`. |
| No client / two-client smoke; full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. `SendPetition` / inbound resolve is B17-B. `UnitName("target")` is B17-C. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

BeefNet already has a later `opponent` body / `resolveOpponentId` path in this workspace. That is B17-B, not this gate. B17-INT glue is not required for a codec-only field.

---

## Isolation / encode / decode

**Isolation wrap — Pass.** Load list is still Common + Codec. No `dofile` of BeefNet / Store / Runtime / UI / Gora / Inputs. Standalone wrap is still 4 nils (Net, Store, Runtime, UI). Reviewer probe: those keys are nil at load. `COB.Names` is present because Common loads; the codec does not call `Names.Display` / `Names.Key`. Wrap is load-time only (unchanged).

**Encode — Pass.** After `text` / `pick` checks: non-petition `opponent` → `"opponent not allowed"`; non-string → `"invalid opponent"`; raw `:` or `"\n"` → `"invalid opponent"`; trim; omit if empty. Four-part petition is unchanged. Caller `opponent` / `type` are not mutated. `PROTOCOL` stays 1.

**Decode — Pass.** Petition `#parts > 5` → `"text not allowed"`. Fifth part: newline → `"invalid opponent"`; else trimmed name. Four-part omits. Favor still requires a 5th pick and refuses a 6th. Confession still `table.concat` from part 5, so colons in confession text stay legal.

---

## Strengths

- `opponent` is one key on `INPUT_KEYS` and one optional 5th wire part. No new TYPE, no new INPUT kind, no protocol major bump.
- Colon / newline are refused on the raw string before trim, so `"Chuckroast\n"` cannot become a legal name.
- The old `please` refuse was replaced, not deleted: that 5th part is now the named opponent the brief asked for, and `text` remains nil.
- Existing four-part, petition `text` / `pick`, favor 5th, confession colon-text, and `sent == 0` pins were left in place. New pins sit in a nested `do`.
- Isolation wrap and closed `TYPES` / `INPUT_KINDS` counts were not rewritten. Source still has no `SendAddonMessage` / `CreateFrame`.
- Writer-reported **480 / 0** matched the re-run. Writer-reported red (**455 / 23**) matches a suite that still treated `opponent` as `"unknown field"` and `please` as `"text not allowed"`.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **The 5th part is any colon-free, newline-free string.** Reviewer probe: `"please fight me at the pit tonight"` and `"Chuckroast-Whitemane"` both encode. Brief asked for a trimmed name string, not `Names.Display` / charset / length. Name → Store id is B17-B. Direct `Gora:Petition` still wants an id.

### Nit

1. **Decode newline refuse is unpinned.** Implementation returns `"invalid opponent"` for `1:INPUT:petition:1:Chuck\nroast` and a trailing newline. Encode newline is pinned; decode newline is probe-only.

2. **Decode of an embedded colon is `"text not allowed"`, not `"invalid opponent"`.** `1:INPUT:petition:1:Chuck:roast` is six parts. Brief allows `"text not allowed"` or `"unknown field"` for more than 5 parts.

3. **The post-petition `kind ~= "confession"` decode tail is now dead.** Favor and petition return earlier; `INPUT_KINDS` has no fourth kind. Harmless leftover.

4. **Mid-name CR encodes.** Brief named `:` and newline only. Probe: a CR between letters becomes a 5th part. Leading / trailing CR would trim off.

5. **Isolation wrap is load-only.** Four pins under `if standalone then` at file load. There is no end wrap after Runtime stubs. Brief said the wrap stays; it did.

6. **Exclusive-pair diff is not a vs-HEAD Codec delta.** Packet is the B17-A-only key + encode + petition decode + pins. `git diff HEAD` on the two files still includes earlier codec batches. Report already says this.

7. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **480 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **480 passed, 0 failed.** Isolation wrap: **4**.

Optional petition `opponent` is a trimmed name string on existing INPUT. No new kind. Four-part `{ kind = "petition", characterId = 3 }` is still `1:INPUT:petition:3`. `text` / `pick` still refuse on petition. `opponent` refuses on favor / confession. Colon / newline encode `"invalid opponent"`. A 5th petition part decodes as opponent (`please` is now a name). Isolation stays Common + Codec. Isolated `lua tests/test_net_codec.lua` **480 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
