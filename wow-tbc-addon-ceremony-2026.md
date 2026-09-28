# TBC Anniversary addon constraints (research extract)

Source: Parallel deep research `trun_91f36069f09644808119d4546045a5d4` (2026-09-14).
Not product law. Church of Beef law is `docs/design/Game_Design_Bible_v1.1.1.md`.
Full metadata: `wow-tbc-addon-ceremony-2026.json`.

## Executive insights

- **Client Targeting**: `20506` appears in TBC Anniversary addon release filenames, but the project page does not itself identify it as Blizzard's official Interface value [executive_insights[0]] [9] -> verify the live client and package metadata before release.
- **Guild Transport**: `C_ChatInfo.SendAddonMessage` supports `GUILD`, `OFFICER`, `WHISPER`, party, raid, instance, `SAY`, and `YELL`; custom `CHANNEL` is disabled on Classic [executive_insights[1]] [2] -> use a registered, versioned `GUILD` protocol and an officer-only control path.
- **Bandwidth Budget**: A registered prefix starts with an allowance of 10 messages and recovers at 1 message per second [executive_insights[1]] [2] -> send compact state changes, not chat-like prose or per-frame updates.
- **Persistence Boundary**: Account-level variables are under `WTF/[account]/SavedVariables`, while character-specific data is under the realm/character path [executive_insights[2]] [11] -> keep ceremony definitions and preferences account-wide, but identity and opt-in state separate.
- **Combat Safety**: Addon Lua is tainted, protected actions require secure execution, and insecure changes to protected state are blocked during combat lockdown [executive_insights[3]] [10] [executive_insights[3]] [10] -> make the ceremony UI informational and non-protected.
- **Two-Client Reliability**: A successful send means a message was queued, not that it was delivered [executive_insights[1]] [2] -> use sequence numbers, acknowledgements, timeout, retry, and local fallback.
- **Distribution Discipline**: BigWigs packager creates distributable zips and supports CurseForge, Wago, WowInterface, and GitHub releases [executive_insights[4]] [5] -> produce reproducible per-client artifacts.
- **Forever Readiness**: Blizzard's official page gives a beta start of September 17, 2026 [executive_insights[5]] [3]; supplied launch evidence gives November 4, 2026 [executive_insights[6]] [12] -> treat Forever as a separate compatibility target until tested.

## Synthesis

The safest design is deliberately conservative across three dimensions. First, transport: guild broadcast is convenient but throttled and not delivery-confirmed, so a coordinator plus acknowledgements is stronger than peer-to-peer guesses. Second, state: account SavedVariables are useful for definitions and preferences, but live ceremony state belongs in a versioned runtime protocol, not in files that may diverge. Third, UI authority: ordinary social frames are portable, while protected actions introduce combat lockdown and taint constraints with little benefit to a ceremony feature.

The main tension is between ceremony immediacy and platform safety. A rich ritual experience wants automatic sequencing, visible timers, and synchronized actions; WoW's security model requires player agency for protected behavior. The correct compromise is automatic synchronization of information and explicit player clicks for optional social actions, never automation of gameplay. The same boundary also improves portability: an informational, non-protected addon is more likely to survive differences among Classic Era, TBC Anniversary, and Forever.

The release strategy follows the same principle. One source tree can support several client families, but only through separately tested TOCs, explicit capability checks, and clearly labeled artifacts. Ship TBC Anniversary first with the verified live-client value, keep Classic Era compatibility independent, and make Forever a beta branch until Blizzard's actual client behavior is known.
