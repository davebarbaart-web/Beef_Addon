Spec PASS

# B36-A — SendConfession trims optional text (review)

**Quality:** Approved-with-nits

**Lane:** B36-A SendConfession trims optional text
**Brief:** `docs/reformation/vestments/briefs/B36-A-confess-trim.md`
**Writer report:** `docs/reformation/vestments/briefs/B36-A-confess-trim-report.md`
**Diff:** `docs/reformation/vestments/briefs/B36-A-confess-trim.diff` (B36-A-only exclusive-pair packet; live `BeefNet.lua` / `test_net_v2.lua` vs HEAD also carry earlier BeefNet batches)
**Exclusive files:** `addon/ChurchOfBeef/Net/BeefNet.lua`, `tests/test_net_v2.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `Net/BeefNet.lua` (`destName` ~86, local `trim` ~77, `SendConfession` ~435–471, `_TransmitWhisper` destName, `C_ChatInfo.SendAddonMessage(..., "WHISPER", target)`), live `tests/test_net_v2.lua` (nested confess-trim `do`/`end` immediately after the B34-D block, `"  forgive me  "` → `1:INPUT:confession:3:forgive me`, `"   "` / `""` omit and match no-text, `"a\nb"` stays `"invalid text"`, dest `"   "` stays `"no target"`, `"  Host  "` spy `"Host"` with no dest on INPUT, isolation re-pins), and live `Net/Codec.lua` (`INPUT_KEYS` / `EncodeInput` — no dest token; confession still appends any nonempty string including spaces); then ran `lua tests/test_net_v2.lua` (**727 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: Bible §13.4 / §9 (confession text is optional player-typed free text for the Pope console); Anniversary `C_ChatInfo.SendAddonMessage(prefix, message, [chatType], [target])` — target is the whisper dest. B35-B Inputs already trims. `SendConfession` copied `fields.text` as-is after dest + newline refuse, so `"  forgive me  "` still encoded. Trim text (`Names.Trim` or existing local `trim`). Empty after trim omits `body.text` and still sends. Newline refuse stays. Dest path stays. No dest on INPUT. No Codec edit. No Pope-name lookup. Exclusive files only. Did not mutate `BeefNet.lua` or `test_net_v2.lua`. Did not commit. Did not edit Codec, Inputs, Confession, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG.

This review does not sign the lane. Do not claim Gate W / Gate V / **POLISH:PASS**.

---

## Named risks

| Risk | Verdict |
|---|---|
| `"  forgive me  "` still encodes padded text (Codec appends any nonempty string) | **Pass. Verified.** Live `SendConfession` trims via `Names.Trim` (else local `trim`) before `EncodeInput`. Nested: payload is `1:INPUT:confession:3:forgive me`; decode `text` is `"forgive me"`. Reviewer probe: `EncodeInput` body `text` is `"forgive me"`; `C_ChatInfo` message is the trimmed payload. |
| Empty after trim still sets `body.text` or refuses the send | **Pass. Verified.** Nested: `"   "` / `""` send, payload `1:INPUT:confession:3`, decode `text` nil, match no-text. Reviewer probe: same omit on `C_ChatInfo`; fallback (`Names.Trim` nil / `Names` nil) still omits `"   "` and sends. |
| Newline refuse dropped or moved after trim | **Pass.** Live check is still raw `fields.text:find("\n", 1, true)` before trim. Nested: `"a\nb"` is `false, "invalid text"`, `#wire` unchanged. Reviewer probe: `"  \n  "` / `"\t\n  \r"` stay `"invalid text"` and do not whisper. |
| dest lands on the INPUT payload / Codec edited | **Pass. Verified.** Body is kind + `characterId` + optional trimmed `text`. Packet does not touch `Codec.lua`. Live `INPUT_KEYS` has no dest. `rg '\bdest\b'` on Codec is empty. Nested: decode `dest` is nil; `"  Host  "` payload stays `1:INPUT:confession:3:free text`. Reviewer probe: `fields.dest = "Sneaky"` still wires that payload; encode body has no dest. |
| Pope-name lookup | **Pass. Verified.** `SendConfession` source has no `LookupPope` / `FindPope` / `COB.Popes`. File-wide BeefNet grep of those names is empty. Suite pins `Net.LookupPope` / `Net.FindPope` nil and unstubbed `IsRegisteredPope` false. Nested block re-pins `COB.Popes` nil. Reviewer probe: same three stay nil. Whisper dest stays caller-supplied. |
| Dest path rewritten; whitespace dest now sends | **Pass.** `destName(target)` stays first. Nested: `"   "` dest is `false, "no target"`, `#wire` unchanged; `"  Host  "` spy target is `"Host"`. Existing dest / optional-text pins above the nest stay. `_TransmitWhisper` still trims. |
| `Names.Display` / `Names.Key` on free text | **Pass. Verified.** Confess path names `Names.Trim` only. Reviewer probe: Display call count 0; `"  forgive-me  "` stays `"forgive-me"` (Display would strip to `"forgive"`); `"  forgive  me  "` keeps the inner space. |
| New main-chunk locals / not nested after B34-D / isolation wrap rewritten | **Pass.** Nest starts at the B36-A banner immediately after B34-D's `end`. Packet adds no new main-chunk `local` outside the `do`/`end`. Isolation wrap stays **11** under the first `if standalone then`. |
| Isolated suite not exit 0 / exclusive breach | **Pass. Verified.** 727 passed, 0 failed. Writer-reported count matches. Packet is the two named files. Sibling dirt (Codec / Inputs / Confession / glue) is other lanes, not this packet. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Codec.lua, Inputs, Confession, glue; no commit; no dest on INPUT | **Pass.** Named-risk check. Reviewer did not commit. |
| `SendConfession` trims text (`Names.Trim` or existing local `trim`) | **Pass.** Live body + nested `"  forgive me  "` + reviewer Trim wrap / fallback probes. |
| Empty after trim omits `body.text` and still sends | **Pass.** Nested `"   "` / `""` / no-text match. Reviewer fallback omit. |
| Newline refuse stays (`"a\nb"` still `"invalid text"`) | **Pass.** Named-risk check. |
| Dest path stays; no dest on INPUT | **Pass.** Named-risk check. |
| No Pope-name lookup | **Pass.** Named-risk check. |
| Tests after the B34-D block. `"  forgive me  "` encodes trimmed (`1:INPUT:confession:3:forgive me` if id 3). `"   "` / `""` omit text (same payload as no-text). Existing dest / newline / optional-text pins stay. Isolation wrap stays | **Pass.** Nest after B34-D. Keep pins re-run inside the nest. |
| `lua tests/test_net_v2.lua` exit 0 | **Pass.** **727 / 0.** |

Bible §13.4 / §9 hold on the exclusive pair: confession text is optional player-typed free text for the Pope console. Trim does not invent copy. Empty after trim omits `body.text` and the whisper still goes to the injected dest. BeefNet still does not look up a Pope and does not fan-out. Law 5 holds: congregation `SendConfession` remains dest-injected, not self-authoritative. Law 4 holds: software does not narrate. dest is the Anniversary whisper `target` argument, not an INPUT field.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client / two-client smoke; Anniversary `SendAddonMessage(..., "WHISPER", target)` with trimmed confession text is unsmoked | **Not a miss.** Brief asked the isolated suite. Reviewer `C_ChatInfo` spy proves the trimmed payload and dest; it does not prove the client whisper. |
| Inputs already trims (B35-B). BeefNet now trims again | **Required.** Brief asked for the Net-side trim so a raw `SendConfession` caller no longer encodes spaces. |
| Newline check is pre-trim. `"  \n  "` still refuses as `"invalid text"` | **On contract.** Brief pinned `"a\nb"` and said newline refuse stays. Reviewer probe: padded / tab-newline still refuse and do not whisper. |
| Fallback path is source-only; isolated suite always loads Common | **On contract as a leftover.** Brief required `Names.Trim` or local `trim`. Reviewer probe (Trim nil / `Names` nil) trims, omits empty, and still sends. Suite does not pin that runtime. |
| Full `lua tests/run.lua` was not run | **Not a miss.** Brief asked the isolated suite. |
| Gate W / Gate V stay OPEN; not signed | **On contract.** This review does not sign the lane. |

B36-INT glue is not required. Text trim lives in the exclusive pair.

---

## Isolation / dest / text

**Isolation wrap — Pass.** Load list is still Common + Runtime + Codec + Snapshot + Sender + BeefNet. No `dofile` of Store / UI / DB / Popes / Officer / Ranks / Archive / Recognition / Gora / Decree / Confession. Standalone wrap is still **11** nils. Nested B33-D, B34-D, and B36-A blocks each re-pin Store / UI / Popes / Gora / Confession (**5**). Wrap is load-time only (unchanged).

**Text trim — Pass.** `SendConfession` assigns `body.text` only when `Names.Trim` (or local `trim`) returns a string. Empty after trim is nil and the field is omitted. Codec is unchanged and still appends any nonempty string; the omit happens before encode. Nested `"  forgive me  "` spies `"forgive me"`; `"   "` / `""` omit and still send when dest is `"Pope"`. Reviewer probe: tab pad trims; inner space and hyphen stay; Display is not used.

**Dest — Pass.** `destName` stays first. Empty dest is `"no target"` before newline / trim / encode. `_TransmitWhisper` still trims. Nested dest keep pins still pass. Reviewer `debug.getupvalue`: `destName` and local `trim` are upvalues of `SendConfession`.

---

## Strengths

- The delta is the brief: one `SendConfession` trim. destName, newline refuse, `_TransmitWhisper`, and Codec were left alone.
- B35-B leftover (padded confession text still encoded on a raw Net call; whitespace text still set `body.text`) is closed on the same id-3 fixture. Omit-and-send sits next to dest refuse and newline refuse, so a blanket nil or a new text-required refuse would fail.
- `Names.Trim` is the existing Common helper. Fallback is the file-local `trim` already used by `destName`. Free text does not call `Display` / `Key`, so a hyphen in a confession is not treated as a realm.
- Nested `do`/`end` sits after B34-D. Isolation wrap stays **11**. No new main-chunk locals outside the nest. Writer-reported **727 / 0** matched the re-run.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Client Anniversary `SendAddonMessage(..., "WHISPER", target)` with trimmed confession text is unsmoked.** The suite and reviewer spy prove the trim / omit / refuse contract. They do not prove the client whisper.

### Nit

1. **Fallback `Names.Trim` / local `trim` is source-pinned, not suite-exercised.** Isolated load always has Common. Reviewer probe (Trim nil / `Names` nil) matches `Names.Trim`. A comment token would still pass the source find.

2. **Tabs / inner spaces / hyphen text / padded newline are not pinned.** Reviewer probe: tab pad trims and sends; `"forgive  me"` keeps the inner space; `"forgive-me"` is not Display-stripped; `"  \n  "` stays `"invalid text"`. Brief named `"  forgive me  "` / `"   "` / `""` / `"a\nb"`.

3. **Newline check stays pre-trim.** Required by "newline refuse stays." `"  \n  "` never reaches omit-and-send.

4. **Nested confess-trim `do`/`end` re-pins dest / newline / optional-text already covered above the nest.** Brief said those pins stay. They still pass earlier.

5. **Exclusive-pair diff is not a vs-HEAD BeefNet delta.** Packet is the B36-A-only trim + nested pins. Report already says this. Sibling dirt is other lanes.

6. **Nested dest `do`/`end` still adds locals** toward the Lua 5.1 200-local cap. `luac -l -p` main chunk reports **161** locals (B34-D review was 159). Under the cap. Report's "no new main-chunk locals" is the nest tactic, not a zero add.

7. **Isolation wrap is load-only.** Eleven pins under `if standalone then` at file load. Brief said the wrap stays; it did.

8. **No `/reload` / two-client padded-or-whitespace confession smoke and no full `lua tests/run.lua`.** Isolated **727 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**1. Spec PASS.** Brief: trim text (`Names.Trim` or local `trim`); empty after trim omits `body.text` and still sends; newline refuse stays; dest path stays; no dest on INPUT; no Codec edit. Live `BeefNet.lua` ~435–471 matches. Brief test pins sit in the nest after B34-D.

**2. Quality: Approved-with-nits.** Must-fix none. Important leftover: client whisper unsmoked. Nits listed above.

**3. Isolation count:** **727 passed, 0 failed.** Isolation wrap: **11**.

**4. Law:** Bible §13.4 / §9 hold. Confession text is optional free text for the Pope console; empty omit still whispers. dest is the Anniversary whisper `target`, not a codec field. No Pope-name lookup. Law 4 / Law 5 hold. wow-api `classic_anniversary`: `C_ChatInfo.SendAddonMessage(prefix, message, [chatType], [target])` — target applies to targeted channels.

**Leftovers:**
- Client Anniversary `SendAddonMessage(..., "WHISPER", target)` with trimmed confession text is unsmoked (Important, not must-fix).
- Double trim with B35-B Inputs is required, not a miss.
- Newline refuse stays pre-trim; `"  \n  "` is `"invalid text"`.
- Fallback is source-pinned (reviewer probe agrees).
- Tab / inner space / hyphen text are unpinned (reviewer probed; they trim / keep / do not Display-strip).
- Nested confess-trim `do`/`end` still counts toward the 200-local cap (161).
- Exclusive-pair packet is not a vs-HEAD BeefNet delta.
- Isolation wrap is load-only.
- Full `lua tests/run.lua` was not run.
- Gate W stays OPEN. Gate V stays OPEN.

`SendConfession` trims via `Names.Trim` (fallback local `trim`). Empty after trim omits `body.text` and still sends. `"  forgive me  "` encodes `1:INPUT:confession:3:forgive me`. `"   "` / `""` omit and match no-text. `"a\nb"` stays `"invalid text"`. No dest on INPUT. No Codec edit. Isolated `lua tests/test_net_v2.lua` **727 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane. Do not claim Gate W, Gate V, or POLISH:PASS.
