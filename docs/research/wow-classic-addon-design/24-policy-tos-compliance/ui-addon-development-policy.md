# UI Add-On Development Policy (official 8 rules)

**Track:** `24-policy-tos-compliance`  
**Last updated:** 2026-07-25  
**Purpose:** Capture Blizzard’s formal UI addon design/distribution rules that still appear on official forums and in archival policy pages.

## Status of the document

Blizzard published the **World of Warcraft User Interface Add-On Development Policy** around March 2009, with a May 2009 enforcement start and later music/copyright clarifications (July 2009). The numbered rules remain posted on official UI/Macro forum sticky threads:

- [UI Add-On Development Policy (US)](https://us.forums.blizzard.com/en/wow/t/ui-add-on-development-policy/24534) — Kaivax sticky; includes music note + full policy text
- [WoW User Interface Add-On Development Policy (EU)](https://eu.forums.blizzard.com/en/wow/t/wow-user-interface-add-on-development-policy/1642) — same eight rules
- [Archived community-site copy (2010-11-24)](https://web.archive.org/web/20101124173826/http://www.worldofwarcraft.com/policy/ui.html) — clean verbatim archive of `worldofwarcraft.com/policy/ui.html`

Community threads (e.g. MDT paywall debates) still treat these rules as the operative “addons must be free” standard ([Blizzard TOS on Addon](https://us.forums.blizzard.com/en/wow/t/blizzard-tos-on-addon/797705)).

**Caveat:** Blizzard’s enforcement has been uneven historically (paid guide databases, Patreon-gated content packs). Uneven enforcement does **not** rewrite the written policy. Design Church of Beef as if the written rules apply.

## The eight rules (verbatim substance)

Quoted/summarized from the [2010 archive](https://web.archive.org/web/20101124173826/http://www.worldofwarcraft.com/policy/ui.html) and matching [US](https://us.forums.blizzard.com/en/wow/t/ui-add-on-development-policy/24534) / [EU](https://eu.forums.blizzard.com/en/wow/t/wow-user-interface-add-on-development-policy/1642) forum posts.

### 1) Add-ons must be free of charge

All add-ons must be distributed free of charge. Developers may **not**:

- create “premium” versions with additional for-pay features
- charge money to download an add-on
- charge for **services related to the add-on**
- otherwise require monetary compensation to download or access an add-on

**Implication:** Paywalled route databases, required Patreon for core function, and “free husk + paid brain” packages are written violations even when some authors try the loophole ([forum discussion quoting the rule](https://us.forums.blizzard.com/en/wow/t/blizzard-tos-on-addon/797705)).

### 2) Add-on code must be completely visible

Programming code must not be hidden or obfuscated, and must be freely accessible/viewable by the general public.

**Implication:** No bytecode packers, encrypted Lua, or “binary companion required for core logic.” Plain `.lua` / `.xml` / `.toc` distribution (CurseForge/Wago/WowInterface style) is the compliant shape.

### 3) Add-ons must not negatively impact realms or other players

No function which, in Blizzard’s sole discretion, negatively impacts realm performance or other players’ experience. Examples named: excessive chat-system use, unnecessary disk loading, slow frame rates.

**Implication:** Chat/addon-message spam, heavy OnUpdate polls, and thrashing SavedVariables are policy problems as well as UX problems. BeefNet pacing (track 14) is also a **policy** hygiene issue under rule 3.

### 4) Add-ons may not include advertisements

Add-ons may not be used to advertise any goods or services.

**Implication:** No in-game banner frames, affiliate CTAs, sponsored “partner” popups, or product plugs inside the addon UI/chat.

### 5) Add-ons may not solicit donations

Add-ons may not include requests for donations. Effort is acknowledged, but donation asks must be limited to the **addon website or distribution site**, not appear in the game.

**Implication:** A CurseForge “Support the author” page is fine; a `/beef donate` popup or persistent tip jar frame is not.

### 6) Add-ons must not contain offensive or objectionable material

WoW is rated “T” (ESRB) / similar elsewhere. Addons must not include material that would not be allowed under those ratings.

**Implication:** Church of Beef’s absurdist religion tone is generally fine if it stays PG-13 / Teen-adjacent; avoid hate speech, extreme sexual content, or material that would fail a T rating. Comedy “holy beef” imagery is not the same as prohibited content — but streamer memes that cross into CoC-violating speech should not be hard-coded into the addon.

### 7) Add-ons must abide by World of Warcraft ToU and EULA

All add-ons must follow the Terms of Use and End User License Agreement.

**Implication:** The UI policy is a *specialization* of the EULA, not a replacement. Automation, RMT, wagering, harassment, and data-mining bans still apply (see [eula-tos-automation.md](eula-tos-automation.md)).

### 8) Blizzard may disable add-on functionality

Blizzard reserves the right to disable any add-on functionality at its sole discretion to maintain integrity and player experience.

**Implication:** Do not build features that depend on Blizzard never closing an API loophole. Prefer intentional, documented APIs; expect clamps (Classic CHANNEL ban history is the cautionary tale — covered in track 14, not duplicated here).

## Music / copyright clarification (2009-07-15)

Still attached to the US sticky: addons that **remove or replace** existing sound files have been allowed, but redistributing Blizzard’s copyrighted in-game music/audio files without authorization is illegal ([US policy thread](https://us.forums.blizzard.com/en/wow/t/ui-add-on-development-policy/24534)).

**Implication for Beef SFX (track 20):** ship original or properly licensed SharedMedia assets; do not bundle ripped Blizzard soundtrack files into the addon zip.

## Enforcement posture (research note)

| Observation | Source type | Weight |
|-------------|-------------|--------|
| Written policy forbids premium / paid services related to addons | Official sticky | High — design against it |
| Some ecosystem products historically charged for “databases” or guides | Community forums | Medium — known gray market; still risky |
| Voluntary donations **outside** the game are commonly accepted community practice | Community + rule 5 text | High — OK on website, not in UI |
| Blizzard can disable functionality without a public trial | Rule 8 | High — don’t fight the platform |

## Church of Beef one-liner

Treat the eight rules as **distribution and presentation law** for Church of Beef: free, open source, no ads, no in-game tip jar, Teen-safe tone, EULA-compliant behavior, and no dependence on forbidden automation.