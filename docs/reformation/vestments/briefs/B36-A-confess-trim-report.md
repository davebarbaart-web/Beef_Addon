# B36-A — SendConfession trims optional text (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §13.4 / §9 (confession text is optional). Anniversary `C_ChatInfo.SendAddonMessage(..., WHISPER, target)`. Brief `docs/reformation/vestments/briefs/B36-A-confess-trim.md`. B35-B Inputs already trims. `SendConfession` (~437–458) copied `fields.text` as-is after dest + newline refuse, so `"  forgive me  "` still encoded. Codec appends any nonempty string (including spaces). Trim text (`Names.Trim` or existing local `trim`). Empty after trim omits `body.text` and still sends. Newline refuse stays. Dest path stays. No dest on INPUT. No Pope lookup. Exclusive files only. No commit. Lane is not signed.

`SendConfession` now trims text via `Names.Trim` when that function exists, else the existing local `trim`. Empty after trim omits `body.text` and still whispers. `"  forgive me  "` encodes `1:INPUT:confession:3:forgive me`. `"   "` / `""` omit text (same payload as no-text). `"a\nb"` stays `"invalid text"`. Dest trim / no dest on INPUT stay. Isolation wrap stays.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_net_v2.lua` | TDD first. Nested `do`/`end` after B34-D. `"  forgive me  "` encodes trimmed. `"   "` / `""` omit text (same payload as no-text). Newline / optional-text / dest keep pins. Isolation wrap stays. No new main-chunk locals. |
| `addon/ChurchOfBeef/Net/BeefNet.lua` | `SendConfession` trims text (`Names.Trim` or local `trim`). Empty after trim omits `body.text` and still sends. Newline refuse and destName stay. No dest on INPUT. No Pope-name lookup. |
| `docs/reformation/vestments/briefs/B36-A-confess-trim-report.md` | This file |
| `docs/reformation/vestments/briefs/B36-A-confess-trim.diff` | B36-A-only unified diff of the exclusive files vs the pre-lane working tree |

Did not edit Codec.lua, Inputs, Confession, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add dest to the INPUT payload. Did not look up a Pope name. Did not commit.

`git diff` vs HEAD on these two files also includes earlier BeefNet batches (working tree already dirty). The brief diff is the B36-A-only delta.

## Contract

```lua
function Net:SendConfession(fields, target)
  -- destName(target); nil → false, "no target"
  -- raw text with "\n" → false, "invalid text"
  -- text = Names.Trim / local trim; empty omits body.text
  -- EncodeInput(body); then _TransmitWhisper(payload, target)
end
```

| `SendConfession` | Payload | Send |
|------------------|---------|------|
| `text = "  forgive me  "`, dest `"Pope"` | `1:INPUT:confession:3:forgive me` | Yes |
| `text = "forgive me"`, dest `"Pope"` | `1:INPUT:confession:3:forgive me` | Yes |
| `text = "   "`, dest `"Pope"` | `1:INPUT:confession:3` | Yes |
| `text = ""`, dest `"Pope"` | `1:INPUT:confession:3` | Yes |
| no `text`, dest `"Pope"` | `1:INPUT:confession:3` | Yes |
| `text = "a\nb"`, dest `"Pope"` | — | No (`false, "invalid text"`) |
| any text, dest `"   "` / `""` / nil | — | No (`false, "no target"`) |
| `text = "free text"`, dest `"  Host  "` | `1:INPUT:confession:3:free text` (target `"Host"`) | Yes |

Keep:

- Existing dest / newline / optional-text pins
- destName before encode
- `_TransmitWhisper` still trims dest
- No dest field on INPUT
- No `LookupPope` / `FindPope` / `COB.Popes` read
- Isolation wrap stays (Common + Runtime + Codec + Snapshot + Sender + BeefNet)
- No new main-chunk locals

### Unchanged

- Congregation `SendFavor` / `SendPetition` / `RequestSnapshot` dest pins (B33-D).
- `SendSnapshot` destName + Pope gate (B34-D).
- SendState / SendDecree stay Pope-gated and GUILD.
- Isolation wrap. No new main-chunk locals.

## TDD

1. Extended `tests/test_net_v2.lua` first (nested confess-trim `do`/`end` after B34-D: `"  forgive me  "` encodes trimmed; `"   "` / `""` omit text and match no-text; `"a\nb"` stays `"invalid text"`; dest `"   "` stays `"no target"`; `"  Host  "` spy target is `"Host"` with no dest on INPUT; isolation re-pins). Isolation wrap and existing dest / newline / optional-text pins untouched.
2. Red: `lua tests/test_net_v2.lua` — **721 passed, 6 failed** (padded text stayed `"  forgive me  "`; whitespace text still encoded; empty omit did not match whitespace payload).
3. `SendConfession` trims text via `Names.Trim` with local `trim` fallback. Empty after trim omits `body.text`. Newline refuse and destName unchanged.
4. Green: `lua tests/test_net_v2.lua` — **727 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_net_v2.lua   # 727 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_net_v2.lua` standalone | **727 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 11 nil pins under `if standalone then` at file load (Store, UI, DB, Popes, Officer, Ranks, Archive, Recognition, Gora, Decree, Confession). Nested B33-D, B34-D, and B36-A blocks each re-pin Store / UI / Popes / Gora / Confession. Wrap unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Codec / Inputs / Confession / glue / TOC / bootstrap were not edited.
- destName stays first. Newline refuse stays on the raw string (`"a\nb"` is `"invalid text"`).
- `"  forgive me  "` spy payload is `1:INPUT:confession:3:forgive me`. `"   "` / `""` omit text and match no-text.
- `"  Host  "` spy target is `"Host"`. INPUT payload has no dest.
- `LookupPope` stays nil. No Pope-name lookup.
- Isolation wrap stays. No new main-chunk locals.

## Leftovers

- **No client smoke / full harness.** Memory-only. Anniversary `SendAddonMessage(..., "WHISPER", target)` with trimmed confession text is not walked in-game this lane.
- **Inputs already trims (B35-B).** BeefNet now trims again. Defense in depth; a raw `SendConfession` caller no longer encodes spaces. Brief asked for the Net-side trim.
- **Newline check is pre-trim.** `"  \n  "` still refuses as `"invalid text"` (existing raw `find("\n")`). Brief only pinned `"a\nb"`.
- **Fallback path is source-only.** Isolated suite always loads `Common.lua`, so `Names.Trim` is present. Missing-Trim local `trim` is not exercised at runtime.
- Full `lua tests/run.lua` was not run.
- Gate W stays OPEN. Gate V stays OPEN.

## Status

**DONE_WITH_CONCERNS.** Isolated **727 / 0**. Isolation wrap **11**. Not signed. Do not claim Gate W, Gate V, or POLISH:PASS.
