# License spectrum in the WoW addon scene

**Last updated:** 2026-07-25  
**Track:** [45-licensing-maintainer-norms](README.md)

## Source-viewable ≠ open source

Blizzard’s [UI Add-On Development Policy](https://us.forums.blizzard.com/en/wow/t/ui-add-on-development-policy/24534) requires that addon code be **completely visible** (no obfuscation/compilation) and free of charge. Community moderators repeatedly correct the misconception that “I can read the `.lua`” means “I can reuse it.”

WoWInterface consensus ([Are all addon "open source"?](https://www.wowinterface.com/forums/showthread.php?t=48644)):

- **Open source** = a grant of rights (MIT, GPL, etc.).
- **Source viewable** = Blizzard policy + client architecture.
- **No LICENSE file** ⇒ under Berne Convention, default is **All Rights Reserved**. Copying chunks into another distributed addon without permission is copyright infringement.

## What authors actually pick

| Pattern | Typical use | Examples | Practical effect |
|---------|-------------|----------|------------------|
| **All Rights Reserved** (+ optional private-mod clause) | Flagship UI / meters / loot / brand-heavy tools | [ElvUI](https://tukui.org/elvui), [Details!](https://www.curseforge.com/wow/addons/details), [DBM](https://github.com/DeadlyBossMods/DeadlyBossMods/blob/master/LICENSE), [Gargul](https://github.com/papa-smurf/Gargul/blob/master/LICENSE) | Download & play free; no public forks under the same name; ask for snippet permission |
| **GPL-2.0** | Collaborative frameworks with large contributor bases | [WeakAuras2](https://github.com/WeakAuras/WeakAuras2) | Forks/derivatives must stay GPL; encourages PRs and companion ecosystem |
| **LGPLv3** | Libraries / guild tools that want embed + share-alike on the lib itself | [RCLootCouncil](https://www.curseforge.com/wow/addons/rclootcouncil) | More permissive for linking than full GPL; still copyleft on the LGPL’d work |
| **Ace Style BSD** | Ace3 / WowAce library ecosystem | [Ace3](https://www.wowace.com/projects/Ace3), [Open Hub text](https://openhub.net/licenses/AceStyleBSD) | Embed OK with notices; **stand-alone redistribution of the lib forbidden** without written OK |
| **MIT / X11** | Small libs, tools, “please reuse” utilities | e.g. some WeakAuras-adjacent libs (LibRangeCheck MIT) | Maximal reuse; authors historically warned that pure MIT invites stale third-party mirrors |

CurseForge’s project create flow exposes a license dropdown (MIT, GPL, BSD, All Rights Reserved, Custom) as a required metadata field — see packaging research under track 05 — so the choice is explicit at upload time, not optional folklore.

## Why ARR dominates player-facing addons

From long-running author threads ([AddOn Licencing](https://wowinterface.com/forums/showthread.php?p=190341)):

1. **Update channel integrity.** WoW patches break addons often. Redistributors create “zombie” downloads that users blame on the original author.
2. **Feedback & discoverability.** Download counts, comments, and bug reports only help if there is one canonical project.
3. **Name / folder identity.** ElvUI-style licenses forbid renaming folders and publicizing modifications (GitHub excepted for ElvUI). Prevents “ElvUI Fixed” impostors.
4. **Permission-by-ask still works.** ARR reserves the right to grant one-off reuse; authors often allow snippets when asked + credited.

MIT advocates argue reuse and credit are enough; the counter is that desktop OSS norms (fork freely, package everywhere) map poorly onto a game that patches weekly and a culture that treats project pages as the product.

## GPL cluster (when it shows up)

GPL appears where the *point* of the project is a shared platform:

- WeakAuras wants aura strings, companion apps, and community packs to remix under clear rules → **GPL-2.0**.
- RCLootCouncil wants guild tooling collaboration → **LGPLv3**.

Copyleft is rare for brand/comedy/social addons because it *forces* public derivatives — the opposite of controlling liturgy, stream identity, and project naming.

## Ace Style BSD (library special case)

Ace3’s limited BSD permits redistribution **embedded** in other addons with copyright notices, but: “Redistribution of a stand alone version is strictly prohibited without prior written authorization.” That is the WowAce library bargain: embed freely, do not re-host Ace as your own project.

Beef implication: embedding Ace3 / LibStub / CallbackHandler / LibDBIcon is normal and expected; Beef’s *own* top-level license should not pretend Ace code is MIT unless the Ace notices stay intact.

## Blizzard constraints that sit *above* your LICENSE

Regardless of MIT/GPL/ARR:

1. Addon must remain free to download/use (no paywalled features in the addon).
2. Code must remain readable.
3. No in-game donation prompts / ads (website/Patreon OK off-client).
4. Do not redistribute Blizzard copyrighted game audio/art as if you own it (policy music note on the same UI policy thread).

These are distribution rules for the WoW ecosystem; they do not replace choosing a copyright license for *your* code.
