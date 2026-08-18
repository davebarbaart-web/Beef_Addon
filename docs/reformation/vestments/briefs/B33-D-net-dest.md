# B33-D — BeefNet refuses a whitespace whisper dest

**Exclusive:** `addon/ChurchOfBeef/Net/BeefNet.lua`, `tests/test_net_v2.lua`

**Do not edit** Codec.lua, glue. Do not commit. Do not add dest to the INPUT payload. Do not look up a Pope name.

## Law

Anniversary `C_ChatInfo.SendAddonMessage(prefix, message, chatType, target)` — target is the whisper dest. `_TransmitWhisper` / `SendPetition` / `SendConfession` / `RequestSnapshot` accept `" "` because `target ~= ""`.

Trim dest (`Names.Trim` or `^%s+` / `%s+$`). Empty after trim is `"no target"` and does not transmit. Existing `""` / nil pins stay. Codec kinds unchanged. No extra codec field.

## Tests

`SendPetition` / `SendConfession` / `RequestSnapshot` / `_TransmitWhisper` with `"   "` return false, `"no target"`, and do not call transmit. `"  Host  "` may trim before transmit (pin transmit saw `"Host"` if you spy). Isolation wrap stays.

`lua tests/test_net_v2.lua` exit 0.

Report `docs/reformation/vestments/briefs/B33-D-net-dest-report.md` + diff.
