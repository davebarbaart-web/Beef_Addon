# Asset licenses — textures, sounds, fonts, third-party packs

**Last updated:** 2026-07-25  
**Track:** [45-licensing-maintainer-norms](README.md)

Code license and media license are separate. An ARR addon can ship MIT fonts; a GPL addon can still infringe if it bundles unlicensed voice packs.

## Layers of rights

| Layer | Who owns it | Safe Beef practice |
|-------|-------------|---------------------|
| **Blizzard game UI / audio / art** | Blizzard | Reference in-client via API / FileDataID / `Interface\...` paths; do **not** zip Blizzard music/textures into the addon for redistribution ([UI policy music note](https://us.forums.blizzard.com/en/wow/t/ui-add-on-development-policy/24534); [Legal FAQ](https://www.blizzard.com/legal/28d5ebbf-c245-4408-8ba9-043dd5f056bf/faq-prawny) on commercial reuse of game audio) |
| **Addon Lua / XML / TOC** | Addon author (subject to chosen LICENSE) | Choose LICENSE; credit embedded libs |
| **Bundled custom `.ogg` / `.tga` / `.blp` / fonts** | Asset creator / foundry license | Keep per-file license notes; prefer SIL OFL / CC0 / purchased redistributable packs |
| **LibSharedMedia registrations** | Library vs media packs differ | Lib code ≠ media inside SharedMedia* addons |
| **Third-party libs (Ace, LSM, LibDBIcon)** | Their authors | Keep LICENSE / notices; respect Ace stand-alone ban |

## LibSharedMedia vs SharedMedia packs

- **LibSharedMedia-3.0** is the registration API. Source headers historically cite LGPL-style library wording; CurseForge/WowAce project pages often list **All Rights Reserved** as the project license field — treat the *library embed norms* (LibStub ecosystem) as “embed with notices,” and do not re-host LSM as a competing stand-alone product without checking current LICENSE in the release you vendor.
- **SharedMedia / SharedMediaAdditionalFonts** add fonts/sounds/statusbars. Pack pages commonly mark **All Rights Reserved**, and READMEs stress “credits go to file owners / license files included in the package.” Fonts inside may individually be OFL, Apache, or proprietary — **the pack’s ARR does not relicense every font to you for arbitrary redistribution outside the pack’s terms**.

Beef V1 design already prefers **no custom media** (track 20); that also minimizes asset-license surface. V2 ceremonial SFX/art needs an explicit asset provenance checklist before bundling.

## ElvUI / plugin media pattern

ElvUI’s published license ([tukui.org/elvui](https://tukui.org/elvui)) copyrights “the contents of this addon, **excluding third-party resources**,” then applies ARR rules to ElvUI’s own work. That split is the scene norm: your code ARR, vendored libs under their licenses, media under theirs.

## Sounds and “meme packs”

Community soundboards are a copyright minefield (ripped TV/game/voice clips). Even if players love them, redistributing uncleared clips inside a CurseForge zip is an author liability under Overwolf Mod Authors Terms (you warrant you have rights to everything you upload). Prefer:

1. Original recordings / commissioned clips with written grant.
2. Clearly licensed free SFX (document URL + license in `ThirdPartyNotices` or `Assets/LICENSES`).
3. Blizzard SoundKit playback by ID (no redistributed file).

## Fonts

Common traps:

- “System font on my PC” ≠ redistributable in an addon.
- Google Fonts / OFL fonts are usually fine if you keep the OFL text and rename rules.
- SharedMedia font packs may forbid extracting fonts into your own addon without the pack’s terms.

## Practical packaging checklist for Beef

1. Keep `LICENSE` (project) separate from `ThirdPartyNotices.md` (Ace, LSM, fonts, SFX).
2. Never ship Blizzard rip extracts.
3. For any custom media: one row in a provenance table — filename, source URL, license, redistributable? (Y/N).
4. Prefer registering media via LibSharedMedia only when the file is cleared; otherwise call Blizzard kits.
5. Brand art (pope hat, cathedral, steak liturgy) is **trademark/brand territory** even under MIT code — protect names and logos in listing copy and LICENSE notes regardless of code license.
