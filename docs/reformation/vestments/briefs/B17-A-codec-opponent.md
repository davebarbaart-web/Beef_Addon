# B17-A — Petition INPUT may name an opponent

**Exclusive:** `addon/ChurchOfBeef/Net/Codec.lua`, `tests/test_net_codec.lua`

**Do not edit** BeefNet, Inputs, Gora, glue. Do not commit. No new codec kind. Closed TYPES stay STATE / SNAPSHOT / INPUT / DECREE. INPUT_KINDS stay petition / favor / confession.

## Law

Bible §10.2: a petition may **name a desired opponent**. That is a field on existing petition INPUT, not a fifth message type.

Add optional `opponent` (trimmed character **name** string) to `INPUT_KEYS`. Congregation clients do not have Pope Store ids; the wire carries a name. `Gora:Petition` still wants an id — BeefNet (B17-B) resolves it.

Keep:

- `{ kind = "petition", characterId = 3 }` still encodes `1:INPUT:petition:3` (four parts). Existing four-part pins stay.
- `text` still refused on petition. `pick` still refused on petition.
- `opponent` refused on favor and confession.
- Empty / whitespace-only `opponent` is omitted (four-part wire), not encoded as an empty field.
- `opponent` containing `:` (FIELD) or `"\n"` → encode `nil` / `"invalid opponent"`.
- Decode: petition with a 5th part is `opponent` (trimmed). More than 5 parts → refuse (`text not allowed` or `unknown field`). Favor 5th part stays `pick`. Confession 5th+ stays `text`.

Update the existing pin that `Decode("1:INPUT:petition:1:please")` is `"text not allowed"` — that 5th part is now a legal opponent name.

## Tests

Isolation stays Codec-only (existing suite). Pin encode/decode round-trip `opponent = "Chuckroast"` → `1:INPUT:petition:3:Chuckroast`. Four-part petition unchanged. Colon / newline opponent refused. Favor / confession with `opponent` refused. Isolation wrap stays.

`lua tests/test_net_codec.lua` exit 0.

Report `docs/reformation/vestments/briefs/B17-A-codec-opponent-report.md` + diff.
