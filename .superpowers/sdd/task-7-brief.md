## Task 7: Version drop + PROTOCOL 2

**Files:** `Net/Codec.lua`; `Net/BeefNet.lua`; `Net/Snapshot.lua`; `tests/test_net_codec.lua`; `tests/test_net_v2.lua`; `tests/test_ceremony_chaos.lua`; `tests/test_net_snapshot.lua`; also invert `tests/test_net_validate.lua` if it pins `PROTOCOL == 1`.

**Depends on:** Task 6 done (BeefNet apply). Do not start until Task 6 report is DONE.

**Read with the brief:** `docs/superpowers/plans/2026-09-14-protocol-2-chaos.md` and `.superpowers/sdd/task-7-9-inventory.md` (live pin file:line inventory). `docs/superpowers/plans/2026-09-14-wave-2-pin-catalog.md` I-05.

### Pins

- Invert: `test_net_v2.lua` and `test_ceremony_chaos.lua` “version skew does not drop the live event.” Skew **must** drop Event chrome to Quiet presentation and show the §13.4 sentence once per session. No toast family.
- `Codec.PROTOCOL = 2`. `Net.PROTOCOL = 2`. Old v1 bodies are incompatible (`IsCompatible(1) == false`).
- `_WarnVersion` + drop. Copy: Bible §13.4 — “the Church's software has advanced” plus “update the addon.” One chat or Quiet parchment per session. No toast.
- Extra unknown colon parts still fail-closed. Allowlist only the new packed **names** field (Task 8 may add it; if Task 8 has not landed, PROTOCOL 2 with the same STATE_KEYS is OK — do not invent clerical kind / beat).
- Do not add clerical kind / beat (#27).
- Retarget every `1:` STATE/SNAPSHOT/INPUT/HELLO fixture that means “local protocol” to `2:`. Foreign-major fixtures must **not** use `2` (use `1` as the old/foreign major, or another unused number).

See `docs/superpowers/plans/2026-09-14-wave-2-pin-catalog.md` I-05.

### Do not

- Commit. Schema 8. Congregation Ensure. Inbound Proclaim.
- Touch `UI/Console.lua` / `UI/Hud.lua` / `ChurchOfBeef.lua` unless a fixture string lives there — prefer not.

`lua tests/run.lua` must exit 0.
