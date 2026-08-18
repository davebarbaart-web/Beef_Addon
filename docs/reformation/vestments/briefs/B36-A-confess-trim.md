# B36-A — SendConfession trims optional text

**Exclusive:** `addon/ChurchOfBeef/Net/BeefNet.lua`, `tests/test_net_v2.lua`

**Do not edit** Codec.lua, Inputs, Confession, glue. Do not commit. Do not add dest to the INPUT payload. Do not look up a Pope name.

## Law

Bible §13.4 / §9: confession text is optional. Anniversary `C_ChatInfo.SendAddonMessage(..., WHISPER, target)`. B35-B Inputs already trims. `SendConfession` (~437–458) copies `fields.text` as-is after dest + newline refuse, so `"  forgive me  "` still encodes. Codec appends any nonempty string (including spaces).

Trim text (`Names.Trim` or existing local `trim`). Empty after trim **omits** `body.text` and still sends. Newline refuse stays (`"a\nb"` still `"invalid text"`). Dest path stays. No dest on INPUT. Do not edit Codec.

## Tests

After the B34-D block. `"  forgive me  "` encodes trimmed (`1:INPUT:confession:3:forgive me` if id 3). `"   "` / `""` omit text (same payload as no-text). Existing dest / newline / optional-text pins stay. Isolation wrap stays.

`lua tests/test_net_v2.lua` exit 0.

Report `docs/reformation/vestments/briefs/B36-A-confess-trim-report.md` + diff.
