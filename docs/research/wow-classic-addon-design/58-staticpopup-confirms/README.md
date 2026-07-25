# Track 58 — StaticPopup & confirm dialogs

**Track id:** `58-staticpopup-confirms`  
**Last updated:** 2026-07-25  
**Sole focus:** How Church of Beef should present **confirm friction** for high-risk officer actions — Blizzard `StaticPopupDialogs` / `StaticPopup_Show`, `preferredIndex` slot hygiene, AceConfig `confirm` as a cousin pattern, and **custom insecure confirm frames** when stock popups are the wrong tool.  
**Out of scope:** General taint / secure-execution model ([29](../29-taint-secure-ui/) — except confirm-dialog depth here); dropdowns / UnitPopup / context menus ([36](../36-tooltips-menus/)); officer audit product policy ([40](../40-officer-moderation-audit/)); Ace options layout norms beyond `confirm` ([03](../03-ace-libs-options/), [11](../11-onboarding-settings-ux/)); microcopy craft ([32](../32-microcopy-tone-voice/), [53](../53-beef-lore-ui-bible/)). No addon implementation in this folder.

## Product truth (from V1 design spec)

| Locked default | Value |
|----------------|-------|
| Officer tab | Approve / reject, standing correction, **demote**, Council appoint, **Prophet bestowal** |
| Demotion | Manual, first-class; public “excommunication” is on-brand; same commit/sync path as promote |
| Prophet | Unique, bestowed — not grindable; replacing/bestowing is a ceremony-grade event |
| Council | Seat-limited appoint (default 4) |
| Spectacle | Guild-chat line on promote/demote from approving officer (throttled; opt-out) |
| Authority | Officer+ only; BeefNet rejects forged commits |

Sources: [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §4.1–§4.3, §7.3, §10.

## Index

| Note | Covers |
|------|--------|
| [staticpopupdialogs-api.md](staticpopupdialogs-api.md) | `StaticPopupDialogs` table, show/hide, text args, `data`/`data2`, edit boxes, optional flags |
| [preferredindex-and-slots.md](preferredindex-and-slots.md) | Slot pool, `preferredIndex = 3` / `STATICPOPUP_NUMDIALOGS`, confirm-path taint hygiene |
| [custom-confirm-frames.md](custom-confirm-frames.md) | When to own a Beef modal instead of StaticPopup; AceConfig `confirm` cousin |
| [beef-demote-prophet-confirms.md](beef-demote-prophet-confirms.md) | Per-action recipe: demote / Prophet / Council / wipe / approve |
| [annotated-urls.md](annotated-urls.md) | Primary URLs with steal/adapt notes |

## Top insights for Beef (read this first)

1. **StaticPopup is the default “yes/no” chrome of Classic.** Register a unique key on the global `StaticPopupDialogs` table, then `StaticPopup_Show("KEY", …)`. Layout, ESC, sound hooks, and up to **four** concurrent slots are FrameXML’s job ([AddOn Studio howto](https://addonstudio.org/wiki/WoW:Creating_simple_pop-up_dialog_boxes); [`StaticPopup_Show`](https://warcraft.wiki.gg/wiki/API_StaticPopup_Show)).

2. **Always set a high `preferredIndex` on addon dialogs.** Community norm is `preferredIndex = 3` (or `STATICPOPUP_NUMDIALOGS`) so Beef confirms prefer a safer slot and avoid some UI taint collisions with Blizzard’s early popup frames ([AddOn Studio](https://addonstudio.org/wiki/WoW:Creating_simple_pop-up_dialog_boxes); AceConfigDialog and WeakAuras both adopted this). Depth of *why* taint spreads → track [29](../29-taint-secure-ui/); this track only locks the confirm-dialog practice.

3. **Pass player identity via show args + `dialog.data`, not by rewriting the dialog table each click.** Use `%s` / `%s` in `text` with `StaticPopup_Show(which, name, rankText)` and set `dialog.data = { playerKey, fromRank, toRank, reason }` after a successful show ([howto — passing arguments](https://addonstudio.org/wiki/WoW:Creating_simple_pop-up_dialog_boxes); [API](https://warcraft.wiki.gg/wiki/API_StaticPopup_Show)).

4. **Custom confirm frame wins when StaticPopup is too thin.** Need a required reason field with validation UI, before/after rank heraldry, “announce will fire” preview, or stacking that must not fight Blizzard’s four slots → own insecure modal (Lua `CreateFrame`, dialog templates) as track [35](../35-xml-vs-lua-ui/) already sketched. AceConfig `confirm` is the **settings** cousin — it itself opens a StaticPopup under the hood ([AceConfigDialog source](https://github.com/WoWUIDev/Ace3/blob/master/AceConfig-3.0/AceConfigDialog-3.0/AceConfigDialog-3.0.lua)).

5. **Risk ladder for Beef commits:** Approve/reject → no modal (clear labels). Standing adjust → light confirm or inline. **Demote / Council / Prophet / standing wipe** → modal + player name in body + short reason (product rule from [40](../40-officer-moderation-audit/beef-product-patterns.md)). Prophet and wipe are ceremony-grade: `showAlert`, no timeout, Escape cancels, never one-click from a menu.

6. **Do not open Blizzard guild/character panels as a side effect of confirms.** Keep Beef windows on insecure roots; prefer custom frame or StaticPopup with the hygiene above ([29 footguns](../29-taint-secure-ui/social-addon-footguns.md)). Context menus may *open* a confirm — they must not *be* the only confirm ([36](../36-tooltips-menus/03-context-menus-officer-actions.md)).

## Boundary map

| Concern | Lives in |
|---------|----------|
| Confirm dialog API, slots, Beef recipes | **This track (58)** |
| Taint model, lockdown, dropdown pollution | [29](../29-taint-secure-ui/) |
| Menu → dialog handoff, UnitPopup ban | [36](../36-tooltips-menus/) |
| Reason required / audit / undo doctrine | [40](../40-officer-moderation-audit/) |
| Lua vs XML confirm chrome | [35](../35-xml-vs-lua-ui/) |
| AceConfig `confirm` field schema | [03](../03-ace-libs-options/), [11](../11-onboarding-settings-ux/) |
| Rite verbs / string do-don’t | [53](../53-beef-lore-ui-bible/) |

## Provenance

Search/extract dumps under [`.raw/`](.raw/). Prefer AddOn Studio / warcraft.wiki.gg / Ace3 docs / FrameXML pointers over listicles.
