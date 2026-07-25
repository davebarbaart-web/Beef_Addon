# Interface path rules for custom textures

**Last updated:** 2026-07-25  
**Track:** [44-custom-textures-media-packaging](README.md)

---

## 1. Where files live

Addon textures must sit under the client’s addon tree:

```text
<WoW>/_classic_era_or_anniversary_/Interface/AddOns/ChurchOfBeef/Media/...
```

(Exact Classic folder name depends on install: Anniversary / TBC Classic client — always the client you launch.)

Files do **not** need to be listed in the `.toc` to be loadable as textures (same pattern as custom sounds; see TOC notes in sound track). They must exist on disk before the client references them.

---

## 2. Path string conventions

`SetTexture` accepts a **file path or FileDataID** ([API](https://warcraft.wiki.gg/wiki/API_TextureBase_SetTexture)).

| Style | Example | Notes |
|-------|---------|-------|
| Backslash (Lua escape) | `"Interface\\AddOns\\ChurchOfBeef\\Media\\Icons\\cob_minimap"` | Most common in addon Lua |
| Forward slash | `"Interface/AddOns/ChurchOfBeef/Media/Icons/cob_minimap"` | Also accepted in modern docs/examples |
| Long-string | `[[Interface\AddOns\ChurchOfBeef\Media\Icons\cob_minimap]]` | Avoids escape noise |
| FileDataID | `134532` | Blizzard assets only — not for custom files |

**Extension rules (critical):**

- **BLP / TGA:** path usually written **without** extension (client resolves). Community practice for stock icons: `"Interface\\Icons\\INV_Misc_Coin_01"`.
- **PNG (Retail 10.0.7+):** must **include** `.png` explicitly ([SetTexture details](https://warcraft.wiki.gg/wiki/API_TextureBase_SetTexture)). Irrelevant if Anniversary has no PNG texture support — another reason to stick to TGA/BLP.

Matching on-disk casing to the path is safest on case-sensitive filesystems; Windows installs are case-insensitive, but don’t rely on that for packaging hygiene.

---

## 3. Reload vs restart

Retail/wiki patch notes: since **9.0.1**, new files under `Interface/AddOns/` generally need only **`/reload`**, not a full client restart ([SetTexture patch changes](https://warcraft.wiki.gg/wiki/API_TextureBase_SetTexture)). Classic clients have followed similar author workflows for years; if a texture fails to appear after replace, try reload then restart once.

Textures load **asynchronously** — `GetSize()` may return 0,0 until loaded ([same page](https://warcraft.wiki.gg/wiki/API_TextureBase_SetTexture)). V2 chrome should tolerate delayed load (fallback color texture already matches missing-media policy).

---

## 4. Using textures in UI

### Widget API

```lua
tex:SetTexture("Interface\\AddOns\\ChurchOfBeef\\Media\\Icons\\cob_minimap")
tex:SetSize(32, 32)
-- optional: crop atlas-like regions
tex:SetTexCoord(0, 1, 0, 1)
```

Wrap modes (`CLAMP`, `REPEAT`, …) and filter modes are documented on the same SetTexture page — relevant for tiled parchment, not for point icons.

### LibDBIcon / LDB

LibDBIcon reads the DataBroker object’s `icon` field as a texture path ([LibDBIcon — WowAce](https://www.wowace.com/projects/libdbicon-1-0)):

```lua
icon = "Interface\\AddOns\\ChurchOfBeef\\Media\\Icons\\cob_minimap"
-- or a stock Blizzard icon for V1:
-- icon = "Interface\\Icons\\INV_Misc_Food_Meat_Raw_08"
```

Custom path works the same as stock; no SharedMedia required.

### Inline chat / fontstring markup

`|Tpath:height[:width:...]|t` embeds a texture in text ([UI escape sequences](https://warcraft.wiki.gg/wiki/UI_escape_sequences)). Useful for V2 guild-chat flair or toast titles — keep icons square and small (`:0` = text height). Prefer paths players without the addon **won’t** see broken in plain guild announce (V1 plain-text announce stays text-only per spec).

---

## 5. SetPortraitToTexture caveat

Authors note that **`SetPortraitToTexture` circular cropping historically works with BLP**, and may **not** apply cleanly to TGA custom icons ([WoWInterface minimap archive](https://www.wowinterface.com/forums/archive/index.php/t-51853.html)). LibDBIcon instead uses the tracking-border overlay + square art with texcoords — Beef should **design square icons that look good under the standard minimap border**, not rely on portrait circularization.

---

## 6. Fallback policy (product)

Spec §10 / §11: missing fonts/textures → fall back; addon still loads. Path rules for V2:

1. Attempt branded path.
2. On failure / empty size after load timeout: `SetColorTexture` with brand scarlet/parchment tokens from track 23, or a known Blizzard solid (`Interface\\Buttons\\WHITE8X8`).
3. Never hard-error the `/beef` frame on a missing file.

---

## 7. What not to put in paths

| Anti-pattern | Why |
|--------------|-----|
| Absolute OS paths (`C:\...`) | Client only resolves under game/Interface tree |
| Registering every Beef texture into LSM | Scope creep; track 10; players’ SharedMedia lists explode |
| Depending on retail PNG | Anniversary packaging risk |
| Replacing files under `Interface\` outside AddOns | Patch overrides / ToS-adjacent; not needed for Beef |
