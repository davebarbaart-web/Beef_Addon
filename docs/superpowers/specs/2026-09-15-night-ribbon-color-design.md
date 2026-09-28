# Night kind ribbons — color and legibility

**Date:** 2026-09-15  
**Status:** Approved by David in conversation; implementation licensed by this spec.  
**Authority:** David (Design Lead). Product law stays Bible §19.3 / Law 10 / `Theme.lua`.  
**Surfaces:** `COB.NightRows` (card + Nights parchment) and the leftover `/beef` week-plate bookmark (`DecreeRibbon` / `GatheringLabel`).

---

## 1. Intent

Every night kind currently wears the same oxblood bookmark and gold type. Types are indistinguishable, stub titles clip, and oxblood is reserved for rulings/finality — not “any tag.”

**Locked choices**

- Title stays on the chip (including Discord stub titles).
- Named Theme rite colors (not a reuse-only remap, not new art).
- Parchment ink on a dark cloth, every kind.
- Full-cloth vertex tint; chip sized to the word.

---

## 2. Theme roles

Add four dark ecclesiastical cloths. Ink on the chip is always `parchment` (`#E4D6B0`). Oxblood is unchanged and must not tint a night kind.

| Role | Cloth | RGB | Hex |
|---|---|---|---|
| `gathering` | umber | 74, 52, 36 | `#4A3424` |
| `knighting` | bronze | 72, 56, 28 | `#48381C` |
| `gora` | steel | 36, 48, 58 | `#24303A` |
| `notice` | pewter | 52, 50, 46 | `#34322E` |

No neon, no greens, no class colors, no item-quality rainbow. Unknown `Theme:Color` still returns nil. No new font roles. No new ribbon files — `ribbon_bookmark` is vertex-tinted; missing art falls back to a flat fill of the same role.

---

## 3. Kind → role

| Row | Role |
|---|---|
| Church `kind == "knighting"` | `knighting` |
| Church `kind == "gora"` | `gora` |
| Other Church nights (`gathering` or unknown) | `gathering` |
| `source == "stub"` | `notice` |

Church copy on the chip stays Gathering / Knighting / Gora. Stubs still put the raid/PvP title on the chip.

Leftover week-plate bookmark (no night list, or live ceremony name above the list):

| Painted copy | Role |
|---|---|
| `KNIGHTING` | `knighting` |
| `GORA` | `gora` |
| `DECREE`, `GATHERING`, `CONFESSION`, `PROCLAMATION` | `gathering` |

Kind type is parchment. Hidden when nights are listed and Quiet (existing show/hide).

---

## 4. Geometry

- Height **20px**.
- Width: `GetStringWidth` + 12px padding each side. Floor **80**. Max **140** (`variant == "card"`) or **180** (parchment). Stub `GetStringWidth` may be nil — fall back to `#text * 7`.
- One line, centered. `SetMaxLines(1)`. No wrap inside the chip.
- Row layout unchanged: date left, chip beside it, where on the second line (or beside the chip when the card is narrow). Going / Discord cue stay on the right.

---

## 5. Implementation

- `Theme.PALETTE` + header comment for the four roles.
- `NightRows.KindRole(row)` and `NightRows.DressRibbon(tex, fs, role, text, variant)` — PlayerCard leftover calls DressRibbon so width/tint/ink stay one language.
- `paintRow` tints per `KindRole`; never oxblood-on-every-row.
- Card vs parchment type faces unchanged (stock `GameFont*` vs Theme serif).

**Out of scope:** proclamations, Console, Records, new textures, kind-word changes, Quiet Mode.

---

## 6. Tests

- Theme: four roles exact RGB; unknown still nil; oxblood unchanged.
- NightRows: Gathering umber, Knighting bronze, Gora steel, stub pewter; kind `_cobColorRole == "parchment"`; ribbon height 20; width in [80, max]; source does not force every ribbon oxblood.
- PlayerCard leftover: `GatheringLabel` parchment ink; DECREE/GATHERING → gathering cloth; live GORA → gora cloth.

Harness green. Install + `/reload` + `/beef`. **POLISH:CANDIDATE** only.
