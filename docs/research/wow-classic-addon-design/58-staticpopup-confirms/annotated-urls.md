# Annotated URLs — StaticPopup & confirms

Primary sources for track 58. Prefer these when implementing or reviewing officer confirm UX.

## StaticPopup API & howto

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://addonstudio.org/wiki/WoW:Creating_simple_pop-up_dialog_boxes | **Primary howto:** `StaticPopupDialogs` fields, show/hide, text params, edit box, `OnCancel` reasons, `data`/`data2`, notes on keeping Accept open; documents `preferredIndex = 3` taint comment. |
| https://warcraft.wiki.gg/wiki/API_StaticPopup_Show | Canonical `StaticPopup_Show(which [, text_arg1, text_arg2, data, insertedFrame])` signature, return frame-or-nil, FrameXML pointer. |
| https://warcraft.wiki.gg/wiki/Creating_simple_pop-up_dialog_boxes | Wiki.gg mirror of the howto (extract flaky; AddOn Studio copy is the working primary). |
| https://wowwiki-archive.fandom.com/wiki/Creating_simple_pop-up_dialog_boxes | Archive mirror with full optional-feature list (`showAlert`, `cancels`, `notClosableByLogout`, etc.). |
| https://www.townlong-yak.com/framexml/go/StaticPopup | FrameXML symbol index for `StaticPopup_*` (verify Anniversary build drift). |

## preferredIndex / ecosystem practice

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://addonstudio.org/wiki/WoW:Creating_simple_pop-up_dialog_boxes | Source of the widespread `preferredIndex = 3` comment citing WowAce taint guidance. |
| https://github.com/WoWUIDev/Ace3/blob/master/AceConfig-3.0/AceConfigDialog-3.0/AceConfigDialog-3.0.lua | AceConfigDialog confirm path: rebuilds `ACECONFIGDIALOG30_CONFIRM_DIALOG`, sets `preferredIndex = STATICPOPUP_NUMDIALOGS`, shows StaticPopup, bumps strata. |
| https://github.com/hurricup/WoW-Ace3/blob/master/AceConfig-3.0/AceConfigDialog-3.0/AceConfigDialog-3.0.lua | Alternate Ace3 mirror of the same confirmPopup pattern. |
| https://www.curseforge.com/wow/addons/weakauras-2/files/817403 | Changelog archaeology: `preferredIndex = 3` → later `STATICPOPUP_NUMDIALOGS` as taint hygiene. |
| https://github.com/Kkthnx-WoW/KkthnxUI/blob/master/KkthnxUI/Core/StaticPopups.lua | Real addon StaticPopupDialogs entries consistently using `preferredIndex = 3`. |
| https://github.com/Tauri-WoW-Community-Devs/oqueue/blob/master/PopupDialogs.lua | `preferredIndex = STATICPOPUPS_NUMDIALOGS` + `hasEditBox` reason/ban pattern. |

## AceConfig confirm (settings cousin)

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables | Official `confirm` / `confirmText` semantics for options tables (`true` / function / inherit). |
| https://eu.forums.blizzard.com/en/wow/t/dialog-box-by-ace3/18170 | Practitioners: standalone dialogs → StaticPopup or AceGUI widgets; options tables ≠ message box API. |

## Custom frames & cousin UX

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://www.wowace.com/projects/ace3/pages/ace-gui-3-0-widgets | AceGUI Frame/Button/EditBox if a custom confirm is built with Ace (V2+); V1 plain frames still preferred for Officer tab. |
| https://github.com/papa-smurf/Gargul/wiki/Awarding-Items | Loot-award **confirm dialogue** — steal “name the subject + block one-click,” not loot chrome. |
| https://us.forums.blizzard.com/en/wow/t/staticpopupdialogs-text-field/16453 | Caution: stuffing dynamic `text = errStr` by rewriting the dialog table each call is fragile; prefer format args / stable registration. |

## Taint / lockdown (confirm depth only — full track 29)

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://www.wowace.com/projects/notaint?page=2 | Community notes listing `StaticPopup_Show` among taint triggers — treat as hint, not gospel. |
| [`../29-taint-secure-ui/social-addon-footguns.md`](../29-taint-secure-ui/social-addon-footguns.md) | Beef-facing StaticPopup slot collision + custom-frame alternative. |
| [`../29-taint-secure-ui/annotated-urls.md`](../29-taint-secure-ui/annotated-urls.md) | Broader secure/taint bibliography — do not duplicate here. |

## Product truth (repo)

| Path | Why |
|------|-----|
| [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §4.1–§4.3, §7.3, §10 | Demote first-class; Prophet unique; officer tab actions; guild announce. |
| [`../40-officer-moderation-audit/beef-product-patterns.md`](../40-officer-moderation-audit/beef-product-patterns.md) | Confirm + reason on demote/Prophet/wipe; dual-ack later. |
| [`../36-tooltips-menus/03-context-menus-officer-actions.md`](../36-tooltips-menus/03-context-menus-officer-actions.md) | Menu opens dialog; StaticPopup/`preferredIndex` for nuclear actions. |
| [`../35-xml-vs-lua-ui/beef-officer-ladder-ui.md`](../35-xml-vs-lua-ui/beef-officer-ladder-ui.md) | Confirm = small dialog / Lua modal. |
| [`../53-beef-lore-ui-bible/string-do-dont.md`](../53-beef-lore-ui-bible/string-do-dont.md) | Confirm demote/Council/Prophet; rite verbs. |
| [`../03-ace-libs-options/05-options-ui-norms.md`](../03-ace-libs-options/05-options-ui-norms.md) | `confirm` on destructive executes in settings. |

## Explicitly not primary for this track

| Topic | Prefer instead |
|-------|----------------|
| Secure templates / taint.log / lockdown matrix | [29](../29-taint-secure-ui/) |
| UIDropDownMenu / UnitPopup / LibDD | [36](../36-tooltips-menus/) |
| Officer notification spam channels | [49](../49-officer-notifications/) |
| Full microcopy / liturgy lines | [32](../32-microcopy-tone-voice/), [53](../53-beef-lore-ui-bible/) |

## Provenance dumps

Raw parallel-cli outputs for audit:

- `.raw/search-staticpopup.json`
- `.raw/search-ace-confirm.json`
- `.raw/search-custom-vs-static.json`
- `.raw/search-taint-preferredindex.json`
- `.raw/extract-staticpopup-howto.json`
- `.raw/extract-ace-confirm.json`
- `.raw/extract-wowpedia-popup.json` (client challenge / blocked — prefer AddOn Studio)
- `.raw/extract-framexml-staticpopup.json`
