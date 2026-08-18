# W-D — BeefNet: DECREE + FAVOR whisper + SendState (after W-A)

**Exclusive files:**
- `addon/ChurchOfBeef/Net/BeefNet.lua`
- `tests/test_net_v2.lua`

**Do not edit** Codec, Gora, Store, UI, TOC, bootstrap, Sender, run.lua, OPEN_QUESTIONS, REFORMATION_LOG.

**Do not commit.** Wait until W-A has landed `DECREE` + favor `pick` on Codec. If Codec cannot EncodeDecree / EncodeInput favor+pick yet, report BLOCKED.

## Law

CONTINUE W-D: `SendState` for Pope transitions (API already exists — keep Pope gate); DECREE send/recv (registered-Pope senders only); FAVOR whisper recv, Pope-side accept only, fail-closed.

Petition and confession INPUT stay **not** a live channel. Only `kind == "favor"` becomes live, and only on WHISPER.

## Send

Keep `SendState` / `SendSnapshot` Pope-gated via `_LocalPope()`.

Add:

```lua
Net:SendDecree(fields, nowSeconds)  -- EncodeDecree; GUILD; _LocalPope() or false, "not a registered pope"
Net:SendFavor(fields, target, nowSeconds)  -- EncodeInput favor+pick; WHISPER to target; NOT Pope-gated
```

`SendFavor` requires a whisper `target`. Congregation uses this. Size cap 240 still applies.

Do not add SendInput for petition/confession.

## Recv (`_HandleV2` / sibling)

- `DECREE` on GUILD: `Sender:IsRegisteredPope(sender)` (do not use `Accept(sender, "DECREE")` unless it already returns true — today it is false; call `IsRegisteredPope`). Then `COB.Decree:Set({ line, flavor })`. Wrong channel → discard. Non-Pope → `"not accepted"`. Do not Restore Runtime.
- `INPUT` + `kind == "favor"` on **WHISPER only**: if not `_LocalPope()` → `"not a registered pope"` / discard (congregation must not tally). If local Pope: `Gora:RecordFavor(characterId, pick)` when Gora offers it. Missing pick / RecordFavor error → do not invent a queue. Never Restore Runtime. Never fan out.
- INPUT petition / confession / favor-on-GUILD → still `"unknown message type"` (or explicit refuse). No inbox.

Update the file header: INPUT is live **only** for favor whisper-to-Pope.

## Tests (`test_net_v2.lua`)

- SendState still fails with empty Popes list.
- With a stubbed registered Pope (follow existing suite patterns / `popeOverrides` if the suite already does this): SendDecree enqueues/sends; inbound DECREE from that sender calls Decree:Set; inbound DECREE from a congregation name does not.
- Favor INPUT on WHISPER to a Pope client calls RecordFavor (stub Gora if needed).
- Favor INPUT on GUILD discarded.
- Petition/confession still unknown.
- Non-Pope SendDecree fails.

Use the suite’s existing `guild` / `whisper` / `reset` / wire spies. Do not invent a Pope name in `Data/Popes.lua`.

## Verify

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_net_v2.lua
lua tests/run.lua
```

No commit.
