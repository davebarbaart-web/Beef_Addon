# Gate layers — taxonomy for Classic addon rollout

**Track:** [48 README](README.md)

Classic addons do not ship remote feature-flag SDKs. Risky behavior is gated by stacking **local** controls. Treat each layer as a different failure domain.

## The five layers

| Layer | What it answers | Typical mechanism | Who controls it |
|-------|-----------------|-------------------|-----------------|
| **1. Role / authority** | Who may mutate shared state? | Guild rank index, Master Looter, raid lead | Game + guild officers |
| **2. SavedVariables flags** | What does *this client* enable? | `db.ui.*`, AceDB options, debug modes | Local player (or officer settings sync) |
| **3. Protocol / version** | Can I trust this peer’s message? | Wire `protoMajor`, HELLO ping, version check UI | Authors + peer install skew |
| **4. Packaging build type** | Does this zip even contain the code? | `@alpha@`, `@debug@`, `@do-not-package@` | CI / packager |
| **5. Distribution channel** | Who downloads which zip? | CurseForge/WowUp Alpha–Beta–Release | Author tags + user channel setting |

## Why layers matter (failure modes)

| Mistake | What goes wrong |
|---------|-----------------|
| Only role-gate a new BeefNet message type | Every Release install still runs the new decoder; one bug hits the whole guild |
| Only SV-flag a risky commit path | Hand-edited SV or a “enable all” debug toggle bypasses product intent |
| Only channel-gate (Alpha zip) with no wire version | Mixed Alpha + Release peers still exchange incompatible payloads |
| Ship debug slash in Release “because COB.DEBUG is false” | Players (or stream overlays) can flip the global; packager strip is safer |
| Hide Officer tab but accept forged commits | UI soft-gate without receiver validation (forbidden by spec §6.2 / §8.2) |

## Mapping to Church of Beef

| Product surface | Primary layer | Secondary |
|-----------------|---------------|-----------|
| Officer tab / approve | **1** Role (rank-index) | UI hide (soft) |
| `RANK_COMMIT` apply | **1** + **3** (validate sender + proto) | — |
| Guild-chat announce | **1** (officer sender) + **2** (`ui.announce`) | Throttle |
| `/beef debug standing` | **4** strip + **2** `COB.DEBUG` | Never Release |
| V2 ceremonial dashboard | **2** default-off + **5** Alpha first | Optional **4** `@alpha@` logging |
| BeefNet V2 message types | **3** major bump + **5** Alpha cohort | Soft-warn on HELLO |
| Instance completion bonus (flaky) | **2** scoring flag / open question §16.4 | Officer manual credit fallback |

## Steal pattern from cousins (compressed)

| Cousin | Layer pattern |
|--------|---------------|
| **Gargul** | ML-only broadcast authority; chat announce toggles in settings; `/gl version` for install skew ([Version Check](https://github.com/papa-smurf/Gargul/wiki/Version-Check), [Announcing Loot](https://github.com/papa-smurf/Gargul/wiki/Announcing-Loot-in-Chat)) |
| **RCLootCouncil** | Personal options vs **Master Looter Options** (group-affecting); ML settings temporarily copied to group ([Options wiki](https://rclootcouncil.com/wiki/Options)) |
| **ATT** | Explicit Debug / Account Mode style toggles in settings; debug prints removed once solid (changelog culture on CurseForge files) |
| **Packager ecosystem** | Compile-time alpha/debug blocks so Release never contains author-only paths |

## Design rule of thumb

> **Authority gates are mandatory. Feature flags are optional comfort. Packaging and channels are how you survive guild nights.**

For Beef: never let an SV flag weaken officer validation. Prefer default-off UI flags for V2 spectacle. Prefer Alpha zips + protocol major for anything that can desync ladders.
