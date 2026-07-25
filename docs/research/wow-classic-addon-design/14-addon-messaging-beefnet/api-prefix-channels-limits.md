# API: prefixes, channels, size limits

**Maps to:** BeefNet prefix `COB`, channel `GUILD`, small payloads (spec §8.2).

## Registration and receive path

| Step | API / event | Notes for Beef |
|------|-------------|----------------|
| Register once | `C_ChatInfo.RegisterAddonMessagePrefix("COB")` | Prefix max **16** characters; `COB` is short and identifiable. Register early (addon load / enable), before expecting traffic. |
| Receive | `CHAT_MSG_ADDON` | Payload: `prefix, text, channel, sender, …` — filter on `prefix == "COB"` and `channel == "GUILD"` (ignore stray whisper tests). |
| Inspect | `IsAddonMessagePrefixRegistered` / `GetRegisteredAddonMessagePrefixes` | Useful for diagnostics; not required every frame. |

Unregistered prefixes: send may still enqueue on some clients, but **recipients will not deliver** into `CHAT_MSG_ADDON` for that prefix. The wiki example that “whispers itself” before registering fails to receive until after register — register first.

Primary: [RegisterAddonMessagePrefix](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.RegisterAddonMessagePrefix) · [CHAT_MSG_ADDON](https://warcraft.wiki.gg/wiki/CHAT_MSG_ADDON) · [SendAddonMessage](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage)

## Send envelope

| Constraint | Documented value | Beef implication |
|------------|------------------|------------------|
| Prefix length | ≤ 16 | `COB` locked |
| Message length | ≤ **255** characters | Colon-delimited records; chunk `SYNC_STATE` before packing grows past one frame |
| NULL bytes | Forbidden (ASCII 0) | Keep printable / simple separators |
| Default chatType if omitted | `PARTY` | Always pass `"GUILD"` explicitly |
| Not in guild | System message / fail | Match spec §11 empty-state; do not spam retries |

Older notes also warn that **prefix + message combined** historically needed to stay ≤ ~254 with a delimiter in the on-wire framing (pre-`C_ChatInfo` lore). Stay well under 255 for the body; leave headroom for a type tag + version byte.

## Channel matrix (Classic vs Retail)

| chatType | Classic | Retail | BeefNet V1 |
|----------|---------|--------|------------|
| `GUILD` | Yes | Yes | **Primary** — all BeefNet types |
| `OFFICER` | Yes | Yes | Optional later for officer-only suggestion traffic; not required if officer gate is client-side on `GUILD` |
| `WHISPER` | Yes | Yes | Escape hatch / directed repair; not default (N× whispers worse than 1 guild fanout for sync) |
| `PARTY` / `RAID` / `INSTANCE_CHAT` | Yes | Yes | Irrelevant to guild ladder; do not mix into BeefNet |
| `CHANNEL` (custom) | **No** (1.13.3+) | Yes | **Forbidden design** on Classic / Anniversary |
| `SAY` / `YELL` | Yes (heavy throttle; char limits) | No | Not for BeefNet |

Blizzard rationale for removing `CHANNEL`: invisible addon traffic to large arbitrary groups undermined Classic social dynamics ([Wowhead / Kaivax 1.13.3](https://www.wowhead.com/classic/news/wow-classic-patch-1-13-3-lua-api-change-disabling-addons-from-communicating-in-299371)).

## Per-prefix message allowance (client-documented)

From [SendAddonMessage — Message throttling](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage#Message_throttling):

- Each registered prefix gets an allowance of **10** messages.
- Each send decrements by 1; at 0, send fails with `AddonMessageThrottle` (enum on modern clients; Classic return shapes vary by era).
- Allowance regenerates at **~1 message per second**, up to 10.
- Defaults may be **server-retuned** at any time.
- Documented exception: this restriction **does not apply to whispers outside instanced content** — do not abuse as a GUILD bypass for ladder sync.
- Sending “too much” across many prefixes can still **disconnect** the client — another reason CTL exists.

## Result codes worth caring about (Retail enum; Classic may be boolean)

| Concern | Meaning for Beef |
|---------|------------------|
| Success | Enqueued locally — **not** a delivery guarantee (Classic silent-drop culture) |
| AddonMessageThrottle | Back off; CTL should have prevented this |
| NotInGuild / NotInGroup | Pause BeefNet; show empty ladder |
| InvalidPrefix / InvalidMessage | Programmer error — fix payload |
| TargetOffline | Whisper-only |

## `SendAddonMessageLogged`

For **user-generated** free-form text (RP profiles, etc.), Blizzard wants the Logged variant so GMs can audit. BeefNet V1 carries structured rank/standing metadata, not player-authored essays — prefer normal `SendAddonMessage`. If a future feature pipes free-form confession text over addon channels, revisit Logged.

## Practical payload sketch (design, not code)

Assume one official record roughly:

`RANK_COMMIT:v:rev:name:rankId:standing:ts:officer`

At ~40–80 bytes per record, a **255-byte** frame holds a handful of records, not a 200-member dump. Full guild sync must be **multi-frame** (`SYNC_STATE` chunks with sequence / “more” flags) or **diff-only** (records newer than requester’s watermark). See [sync-state-and-anti-spam.md](sync-state-and-anti-spam.md).
