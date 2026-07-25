# CurseForge / Overwolf — ownership and platform rights

**Last updated:** 2026-07-25  
**Track:** [45-licensing-maintainer-norms](README.md)

## Corporate ownership of the platform

CurseForge (the distribution platform) was acquired by **Overwolf** from Twitch (announced mid-2020). That is ownership of the *service*, not of every uploaded addon. Author IP is governed by the [CurseForge Mod Authors Terms](https://legal.overwolf.com/docs/curseforge/mod-authors-terms/).

## What authors keep vs what they grant

From the Mod Authors Terms (and consistent secondary summaries such as [LegalClarity’s Overwolf write-up](https://legalclarity.org/who-owns-curseforge-from-twitch-to-overwolf/)):

| Right | Holder |
|-------|--------|
| Title / ownership of the Mod’s IP | **Mod Author** (and their licensors) — §5.3 |
| License to use CurseForge tooling | Overwolf → Author (limited, revocable) — §2.2 |
| License to operate the Mod on the platform | **Author → Overwolf**: unrestricted, worldwide, royalty-free license to use, store, reproduce, distribute, display, perform, operate, modify, adapt, and create derivative works **for platform purposes** — §2.3 |
| Marketing / advertising / distributing the Mod **through CurseForge**, and sharing End User usage data | Granted **exclusively** to Overwolf — §2.3(b)(e); Author appoints Overwolf as agent for those purposes |
| Right to reject / remove / delist Mods | Overwolf sole discretion — §2.4 |
| Right to withdraw Mod / terminate | Author may withdraw Mods and stop using the Platform — §12.2; may still distribute **outside** CurseForge — §12.3 |
| Post-termination retention | Overwolf may **retain** (not distribute/display) copies as needed for already-downloaded End User functionality — §12.3 |

### Plain-language reading for Beef

1. Uploading to CurseForge does **not** sell Church of Beef to Overwolf.
2. It **does** give Overwolf a broad operational license so the website, app, CDN, search, and Rewards Program can function.
3. On CurseForge specifically, Overwolf controls exclusive platform marketing/distribution rights you granted — you are not free to undercut that exclusive slice *on their platform*, but you remain free to ship the same addon on WoWInterface, Wago, GitHub Releases, etc.
4. You warrant that you have rights to everything in the zip (code + assets). Infringing media is your problem; Overwolf can remove and withhold rewards.

Author community pushback historically asked Overwolf to narrow grants to non-exclusive distribution licenses ([CurseForge Ideas CF-I-222](https://curseforge-ideas.overwolf.com/ideas/CF-I-222)); treat the **live legal page** as authoritative, not the idea board.

## Project ownership vs account ownership

Practical CF maintainer facts:

- **Project Owner** on CurseForge/WowAce controls file uploads, authors list, license field, and transfer.
- Adding co-authors is the healthy bus-factor move for guild tools.
- “Abandoned” badges can mean true abandonment **or** failed account migration — verify before treating a listing as orphaned (see [03-fork-culture](03-fork-culture-and-maintainer-norms.md)).
- Rewards Program / CurseForge Pro monetization is **platform** economics; it does not change Blizzard’s “addons free of charge / no in-game donation prompts” rules (track 24).

## Multi-site distribution

Norm for serious authors:

- CurseForge (and/or WowAce) as primary for WowUp/CurseForge App users.
- Optional Wago Addons / WoWInterface mirrors with the **same** LICENSE and versioning.
- GitHub as source of truth for issues/PRs when the license allows public collaboration.

Beef should pick a primary CF project early (stable project ID, packager metadata) and decide whether dual-hosting is worth the sync cost. Dual-hosting does not require dual ownership — same author account(s) everywhere.
