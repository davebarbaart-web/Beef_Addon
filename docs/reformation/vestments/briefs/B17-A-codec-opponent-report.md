# B17-A — Petition INPUT may name an opponent (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §10.2 (a petition may name a desired opponent); §13.1 / §18.5 (congregation input; names, not Pope Store ids); Law 4; brief `docs/reformation/vestments/briefs/B17-A-codec-opponent.md`. No new codec kind. Closed TYPES stay STATE / SNAPSHOT / INPUT / DECREE. INPUT_KINDS stay petition / favor / confession. No `SendAddonMessage`. No `CreateFrame`. Isolation stays Common + Codec.

Optional `opponent` is a trimmed character **name** string on existing petition INPUT. Four-part `{ kind = "petition", characterId = 3 }` still encodes `1:INPUT:petition:3`. `text` / `pick` still refused on petition. `opponent` refused on favor / confession. Empty / whitespace-only `opponent` is omitted. Colon or newline in opponent → encode `nil` / `"invalid opponent"`. Decode 5th petition part is opponent (trimmed). `1:INPUT:petition:1:please` is now a legal opponent name. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 480 passed, 0 failed (`lua tests/test_net_codec.lua`). **4** isolation pins under `if standalone then` at file load (Net, Store, Runtime, UI).

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_net_codec.lua` | TDD first. Four-part petition pins `opponent == nil`. Nested `do` pin: `opponent = "Chuckroast"` ↔ `1:INPUT:petition:3:Chuckroast`; trim on encode/decode; empty / whitespace omitted; `1:INPUT:petition:1:please` is opponent `please` (old `text not allowed` pin updated); colon / newline / trailing newline / numeric id refuse `"invalid opponent"`; favor / confession with `opponent` refuse `"opponent not allowed"`; sixth part `"text not allowed"`. Isolation wrap stays. New pins nested in a `do` block. |
| `addon/ChurchOfBeef/Net/Codec.lua` | `opponent` added to `INPUT_KEYS`. Encode: petition-only; raw string may not contain `:` or `"\n"`; trim; empty omitted. Decode: petition 5th part is opponent; more than 5 parts → `"text not allowed"`. Favor 5th stays `pick`. Confession 5th+ stays `text`. |
| `docs/reformation/vestments/briefs/B17-A-codec-opponent-report.md` | This file |
| `docs/reformation/vestments/briefs/B17-A-codec-opponent.diff` | B17-A-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit BeefNet, Inputs, Gora, HUD, Store, TOC, bootstrap, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add a fifth TYPE or INPUT kind. Did not commit.

`git diff` vs HEAD on these two files also includes earlier Codec batches (working tree already dirty). The brief diff is the B17-A-only delta.

## Contract

```lua
Codec:EncodeInput({ kind = "petition", characterId = 3 })
  -- "1:INPUT:petition:3"

Codec:EncodeInput({ kind = "petition", characterId = 3, opponent = "Chuckroast" })
  -- "1:INPUT:petition:3:Chuckroast"

Codec:Decode("1:INPUT:petition:1:please")
  -- { kind = "petition", characterId = 1, opponent = "please" }
```

| Shape | Result |
|-------|--------|
| four-part petition | unchanged; `opponent == nil` |
| `opponent` name string | 5th wire part |
| empty / whitespace `opponent` | omitted (four-part) |
| `:` or `"\n"` in `opponent` | `nil, "invalid opponent"` |
| non-string `opponent` | `nil, "invalid opponent"` |
| `opponent` on favor / confession | `nil, "opponent not allowed"` |
| `text` on petition | still `"text not allowed"` |
| `pick` on petition | still `"pick not allowed"` |
| petition 6+ parts | `"text not allowed"` |
| favor 5th / confession 5th+ | still `pick` / `text` |

Keep:

- TYPES count is 4. INPUT_KINDS stay petition / favor / confession.
- No `SendAddonMessage` / `CreateFrame` / HELLO / snapshot schema.
- Isolation wrap stays (Common + Codec; Net / Store / Runtime / UI nil).
- Name → Store id resolve is B17-B, not this lane.

## TDD

1. Extended `tests/test_net_codec.lua` first (named-opponent round-trip; four-part unchanged; colon / newline refuse; favor / confession refuse; old `please` pin updated). Isolation wrap untouched. `text` / `pick` petition refuses left in place.
2. Red: `lua tests/test_net_codec.lua` — **455 passed, 23 failed** (`opponent` was `"unknown field"`; `1:INPUT:petition:1:please` was `"text not allowed"`).
3. `opponent` on `INPUT_KEYS`; encode after pick checks; decode petition 5th part. Colon / newline checked on the raw string so a trailing newline cannot trim through.
4. Green: `lua tests/test_net_codec.lua` — **480 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_net_codec.lua   # 480 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_net_codec.lua` standalone | **480 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 4 pins under `if standalone then` at file load (Net, Store, Runtime, UI). Wrap unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. BeefNet / Inputs / Gora / HUD / Store / glue / TOC were not edited.
- No new TYPE or INPUT kind. Four-part petition wire is unchanged.
- `text` still refused on petition. `pick` still refused on petition. `opponent` refused on favor / confession.
- Encode does not mutate the caller. Empty / whitespace opponent is omitted, not an empty 5th field.
- Isolation asserts stay under `if standalone then`. Net / Store / Runtime / UI are nil at file load.
- Name → id resolve is not this lane.

## Isolated count

**480 passed, 0 failed.** Isolation wrap: **4**.

## Concerns

- **No client smoke / full harness.** Encode/decode only. `SendPetition` / inbound resolve is B17-B. Congregation `UnitName("target")` is B17-C.
- **Decode of an empty or whitespace 5th part omits `opponent`.** Encode omit is specified; an empty wire field is the trim consequence, not a new error.
- Lane is unsigned. No Gate or POLISH claim.

## Status

**DONE_WITH_CONCERNS.** Isolated **480 / 0**. Isolation wrap **4**. Not signed.
