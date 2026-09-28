#!/usr/bin/env python3
"""Composite Church of Beef preview scene graphs to 1024×768 PNGs.

Reads docs/design/renders/preview/*.json + theme.json written by
tests/preview_dump.lua. Stock Blizzard art is not on disk (it lives in the
client CASC); keyed approximations stand in. Shipped OFL fonts under
addon/ChurchOfBeef/Media/Fonts/ are loaded for Theme roles.

Font stand-ins (never Blizzard fonts):
  Theme display  → addon/.../UnifrakturMaguntia-Book.ttf
  Theme label/body → addon/.../EBGaramond[wght].ttf (variable default instance)
  Fonts\\MORPHEUS.TTF → macOS Palatino (display-ish)
  Fonts\\FRIZQT__.TTF → macOS Palatino, else Helvetica
  GameFont* templates → same Friz stand-in at:
    NormalHuge≈20, NormalLarge≈16, Normal≈12, NormalSmall≈10,
    HighlightSmall≈11, Highlight≈12

Stock-texture approximations (keyed on the last path token):
  QuestBG                         aged parchment (#D9C9A3 + seeded noise)
  UI-Tooltip-Background           near-black flat
  WHITE8X8                        flat vertex color
  UI-StatusBar                    horizontal gray gradient
  UI-EmptySlot / UI-EmptySlot-White / UI-Quickslot2 / UI-Quickslot-Depress
                                  drawn ring
  UI-DialogBox-Corner             small iron corner L
  UI-Tooltip-Border               1px iron edge
  MiniMap-TrackingBorder          outer ring
  UI-Minimap-Background           dark disc
  UI-Minimap-ZoomButton-Highlight soft bright ring
  star4                           radial light burst (screen blend)
  Spellbook-Icon                  book-ish square
  UI-CheckBox-Up / Check / UI-RadioButton / UI-SliderBar-Button-Horizontal
                                  small engraved marks
  UI-Panel-Button-*               iron plate
  UI-QuestLogSortTab-Middle       ribbon strip
  Media/... .tga                  real TGA if present, else labeled box

Same JSON → same PNG (parchment noise is seeded).
"""

from __future__ import annotations

import json
import math
import os
import random
import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont, ImageFilter

ROOT = Path(__file__).resolve().parents[1]
_preview_env = Path(os.environ.get("COB_PREVIEW_DIR", "docs/design/renders/preview"))
PREVIEW = _preview_env if _preview_env.is_absolute() else ROOT / _preview_env
ADDON = ROOT / "addon" / "ChurchOfBeef"
FONTS_DIR = ADDON / "Media" / "Fonts"

SCREEN_W = max(320, int(os.environ.get("COB_PREVIEW_WIDTH", "1024")))
SCREEN_H = max(240, int(os.environ.get("COB_PREVIEW_HEIGHT", "768")))
SCALE = max(1, min(2, int(os.environ.get("COB_PREVIEW_SCALE", "2"))))
CANVAS_W, CANVAS_H = SCREEN_W * SCALE, SCREEN_H * SCALE

STRATA_ORDER = {
    "BACKGROUND": 0,
    "LOW": 1,
    "MEDIUM": 2,
    "HIGH": 3,
    "DIALOG": 4,
    "FULLSCREEN": 5,
    "FULLSCREEN_DIALOG": 6,
    "TOOLTIP": 7,
}
LAYER_ORDER = {
    "BACKGROUND": 0,
    "BORDER": 1,
    "ARTWORK": 2,
    "OVERLAY": 3,
    "HIGHLIGHT": 4,
}

ANCHOR_UV = {
    "TOPLEFT": (0.0, 0.0),
    "TOP": (0.5, 0.0),
    "TOPRIGHT": (1.0, 0.0),
    "LEFT": (0.0, 0.5),
    "CENTER": (0.5, 0.5),
    "RIGHT": (1.0, 0.5),
    "BOTTOMLEFT": (0.0, 1.0),
    "BOTTOM": (0.5, 1.0),
    "BOTTOMRIGHT": (1.0, 1.0),
}

GAMEFONT_SIZE = {
    "GameFontNormalHuge": 20,
    "GameFontNormalLarge": 16,
    "GameFontNormal": 12,
    "GameFontHighlight": 12,
    "GameFontHighlightSmall": 11,
    "GameFontNormalSmall": 10,
    "GameFontDisableSmall": 10,
}

# Last path token → approximation key.
STOCK_KEYS = {
    "QuestBG": "parchment",
    "UI-Tooltip-Background": "tooltip_bg",
    "WHITE8X8": "white8",
    "UI-StatusBar": "statusbar",
    "UI-EmptySlot": "ring_dark",
    "UI-EmptySlot-White": "ring_light",
    "UI-Quickslot2": "ring_light",
    "UI-Quickslot-Depress": "ring_press",
    "UI-DialogBox-Corner": "corner_l",
    "UI-Tooltip-Border": "edge",
    "MiniMap-TrackingBorder": "minimap_border",
    "UI-Minimap-Background": "minimap_disc",
    "UI-Minimap-ZoomButton-Highlight": "minimap_hi",
    "star4": "sunburst",
    "Spellbook-Icon": "book",
    "UI-CheckBox-Up": "checkbox",
    "UI-CheckBox-Check": "check",
    "UI-RadioButton": "radio",
    "UI-SliderBar-Button-Horizontal": "slider",
    "UI-Panel-Button-Up": "plate",
    "UI-Panel-Button-Highlight": "plate_hi",
    "UI-Panel-Button-Down": "plate_dn",
    "UI-QuestLogSortTab-Middle": "ribbon",
}


def _clamp(v, lo=0, hi=255):
    return lo if v < lo else hi if v > hi else v


def _rgb01(c, default=(1.0, 1.0, 1.0, 1.0)):
    if not c:
        return default
    if isinstance(c, (list, tuple)):
        r = c[0] if len(c) > 0 else 1
        g = c[1] if len(c) > 1 else 1
        b = c[2] if len(c) > 2 else 1
        a = c[3] if len(c) > 3 else 1
        return (r or 0, g or 0, b or 0, 1 if a is None else a)
    return (
        c.get("r", 1) or 0,
        c.get("g", 1) or 0,
        c.get("b", 1) or 0,
        1 if c.get("a") is None else (c.get("a") or 0),
    )


def _rgba(c, default=(255, 255, 255, 255)):
    r, g, b, a = _rgb01(c, (default[0] / 255, default[1] / 255, default[2] / 255, default[3] / 255))
    return (
        _clamp(int(round(r * 255))),
        _clamp(int(round(g * 255))),
        _clamp(int(round(b * 255))),
        _clamp(int(round(a * 255))),
    )


def _token(path):
    if not path:
        return ""
    p = str(path).replace("/", "\\")
    return p.rsplit("\\", 1)[-1]


def _looks_media(path):
    if not path:
        return False
    p = str(path).replace("\\", "/").lower()
    return "/media/" in p or p.endswith(".tga") or p.endswith(".blp")


def _media_disk(path):
    if not path:
        return None
    p = str(path).replace("\\", "/")
    marker = "ChurchOfBeef/Media/"
    idx = p.find("Media/")
    if "ChurchOfBeef" in p and idx >= 0:
        rel = p[idx + len("Media/") :]
        cand = ADDON / "Media" / rel
        if cand.is_file():
            return cand
    return None


# ---------------------------------------------------------------------------
# Fonts
# ---------------------------------------------------------------------------

_FONT_CACHE = {}
_SYSTEM_PALATINO = None
_SYSTEM_FRIZ = None


def _first_existing(paths):
    for p in paths:
        if p and Path(p).is_file():
            return str(p)
    return None


def _system_standins():
    global _SYSTEM_PALATINO, _SYSTEM_FRIZ
    if _SYSTEM_PALATINO is not None:
        return
    _SYSTEM_PALATINO = _first_existing([
        "/System/Library/Fonts/Supplemental/Palatino.ttc",
        "/System/Library/Fonts/Palatino.ttc",
        "/Library/Fonts/Palatino.ttc",
        "/System/Library/Fonts/Times.ttc",
        "/System/Library/Fonts/Supplemental/Times New Roman.ttf",
    ])
    _SYSTEM_FRIZ = _first_existing([
        "/System/Library/Fonts/Supplemental/Palatino.ttc",
        "/System/Library/Fonts/Helvetica.ttc",
        "/System/Library/Fonts/HelveticaNeue.ttc",
        "/System/Library/Fonts/Supplemental/Arial.ttf",
        "/Library/Fonts/Arial.ttf",
    ]) or _SYSTEM_PALATINO


def resolve_font_path(font_path, template, theme):
    _system_standins()
    if font_path:
        fp = str(font_path).replace("\\", "/")
        disk = _media_disk(font_path)
        if disk:
            return str(disk)
        low = fp.lower()
        if "unifraktur" in low:
            cand = FONTS_DIR / "UnifrakturMaguntia" / "UnifrakturMaguntia-Book.ttf"
            if cand.is_file():
                return str(cand)
        if "ebgaramond" in low or "alegreya" in low:
            cand = FONTS_DIR / "EBGaramond" / "EBGaramond[wght].ttf"
            if cand.is_file():
                return str(cand)
        if "morpheus" in low:
            return _SYSTEM_PALATINO
        if "frizqt" in low:
            return _SYSTEM_FRIZ
    theme_paths = (theme or {}).get("fontPath") or {}
    if template:
        # GameFont* → Friz stand-in
        return _SYSTEM_FRIZ
    if theme_paths.get("body"):
        disk = _media_disk(theme_paths["body"])
        if disk:
            return str(disk)
    return _SYSTEM_FRIZ or _SYSTEM_PALATINO


def font_size_for(widget, theme):
    size = widget.get("fontSize")
    if isinstance(size, (int, float)) and size > 0:
        return int(round(size))
    tmpl = widget.get("template") or ""
    if tmpl in GAMEFONT_SIZE:
        return GAMEFONT_SIZE[tmpl]
    sizes = (theme or {}).get("fontSize") or {}
    role = widget.get("fontRole")
    if role == "display":
        return int(sizes.get("name") or sizes.get("headline") or 18)
    if role == "label":
        return int(sizes.get("label") or 12)
    if role == "body":
        return int(sizes.get("body") or 12)
    return 12


def load_font(path, size):
    key = (path, int(size))
    if key in _FONT_CACHE:
        return _FONT_CACHE[key]
    font = None
    if path:
        try:
            font = ImageFont.truetype(path, int(size))
        except OSError:
            try:
                font = ImageFont.truetype(path, int(size), index=0)
            except OSError:
                font = None
    if font is None:
        font = ImageFont.load_default()
    _FONT_CACHE[key] = font
    return font


# ---------------------------------------------------------------------------
# Texture approximations
# ---------------------------------------------------------------------------

def _stable_hash(*parts):
    h = 2166136261
    for p in parts:
        for ch in str(p):
            h ^= ord(ch)
            h = (h * 16777619) & 0xFFFFFFFF
    return h


def _seeded_rng(*parts):
    return random.Random(0xC0B2026 ^ _stable_hash(*parts))


def make_parchment(w, h, vertex, x0=0, y0=0):
    base = (0xD9, 0xC9, 0xA3, 255)
    if vertex and vertex[3] > 0:
        base = (
            (base[0] + vertex[0]) // 2,
            (base[1] + vertex[1]) // 2,
            (base[2] + vertex[2]) // 2,
            vertex[3],
        )
    img = Image.new("RGBA", (w, h), base)
    px = img.load()
    rng = _seeded_rng("parchment", w, h, x0, y0)
    for y in range(h):
        edge_y = min(y, h - 1 - y) / max(h * 0.12, 1)
        for x in range(w):
            edge_x = min(x, w - 1 - x) / max(w * 0.12, 1)
            edge = min(1.0, edge_x, edge_y)
            n = rng.randint(-10, 10)
            shade = 18 if edge < 0.35 else 0
            r, g, b, a = px[x, y]
            px[x, y] = (
                _clamp(r + n - shade),
                _clamp(g + n - shade),
                _clamp(b + int(n * 0.6) - shade),
                a,
            )
    return img


def make_flat(w, h, color):
    return Image.new("RGBA", (w, h), color)


def make_statusbar(w, h, vertex):
    img = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    px = img.load()
    vr, vg, vb, va = vertex or (160, 160, 160, 255)
    for x in range(w):
        t = x / max(w - 1, 1)
        g = int(70 + 90 * t)
        r = _clamp(int(vr * (0.45 + 0.55 * t) * g / 160))
        gg = _clamp(int(vg * (0.45 + 0.55 * t) * g / 160))
        b = _clamp(int(vb * (0.45 + 0.55 * t) * g / 160))
        for y in range(h):
            vshine = 18 if 1 <= y <= max(h // 3, 1) else 0
            px[x, y] = (_clamp(r + vshine), _clamp(gg + vshine), _clamp(b + vshine), va)
    return img


def make_ring(w, h, color, width=0.14, fill=None):
    img = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    pad = max(1, int(min(w, h) * 0.06))
    box = [pad, pad, w - 1 - pad, h - 1 - pad]
    if fill:
        d.ellipse(box, fill=fill)
    d.ellipse(box, outline=color, width=max(2, int(min(w, h) * width)))
    return img


def make_corner_l(w, h, color):
    img = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    t = max(2, int(min(w, h) * 0.18))
    d.rectangle([0, 0, w - 1, t], fill=color)
    d.rectangle([0, 0, t, h - 1], fill=color)
    return img


def make_edge(w, h, color):
    img = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    if w >= h:
        d.rectangle([0, 0, w - 1, max(1, h - 1)], outline=color, width=1)
    else:
        d.rectangle([0, 0, max(1, w - 1), h - 1], outline=color, width=1)
    return img


def make_disc(w, h, color):
    img = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    ImageDraw.Draw(img).ellipse([1, 1, w - 2, h - 2], fill=color)
    return img


def make_soft_ring(w, h, color):
    img = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    d.ellipse([1, 1, w - 2, h - 2], outline=color, width=max(2, min(w, h) // 8))
    return img.filter(ImageFilter.GaussianBlur(radius=max(1, min(w, h) // 16)))


def make_minimap_tracking_border(w, h):
    """Approximate Blizzard's offset 53px tracking-button chrome.

    The visible ring occupies the top-left 32px button slot; the remaining
    texture area is transparent padding. Centering a ring in the full 53px
    texture incorrectly covers and displaces the custom 20px roundel.
    """
    img = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    slot = max(8, min(w, h, int(round(min(w, h) * 0.62))))
    ImageDraw.Draw(img).ellipse(
        [1, 1, slot - 2, slot - 2],
        outline=(180, 160, 90, 255),
        width=max(2, slot // 8),
    )
    return img


def make_sunburst(w, h, vertex):
    img = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    px = img.load()
    vr, vg, vb, va = vertex or (255, 230, 160, 180)
    cx, cy = w / 2.0, h / 2.0
    maxr = math.hypot(cx, cy) or 1
    for y in range(h):
        for x in range(w):
            dx, dy = x - cx, y - cy
            r = math.hypot(dx, dy) / maxr
            ang = math.atan2(dy, dx)
            ray = abs(math.cos(ang * 4)) ** 3
            fall = max(0.0, 1.0 - r)
            a = int(va * fall * (0.25 + 0.75 * ray))
            if a <= 0:
                continue
            px[x, y] = (vr, vg, vb, _clamp(a))
    return img


def make_book(w, h, vertex):
    img = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    ink = vertex or (80, 50, 30, 255)
    d.rounded_rectangle([2, 2, w - 3, h - 3], radius=max(2, min(w, h) // 10), fill=(90, 40, 28, 255), outline=ink)
    d.line([(w // 2, 4), (w // 2, h - 5)], fill=(200, 180, 130, 255), width=2)
    return img


def make_mark(w, h, kind, color):
    img = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    pad = max(1, min(w, h) // 6)
    box = [pad, pad, w - 1 - pad, h - 1 - pad]
    if kind == "checkbox":
        d.rectangle(box, outline=color, width=2)
    elif kind == "check":
        d.line([(pad, h // 2), (w // 2, h - pad), (w - pad, pad)], fill=color, width=2)
    elif kind == "radio":
        d.ellipse(box, outline=color, width=2)
        inner = [pad + 3, pad + 3, w - pad - 4, h - pad - 4]
        if inner[2] > inner[0] and inner[3] > inner[1]:
            d.ellipse(inner, fill=color)
    elif kind == "slider":
        d.ellipse(box, fill=color, outline=(20, 18, 16, 255))
    return img


def make_plate(w, h, vertex, variant="up"):
    img = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    base = vertex or (42, 38, 34, 255)
    if variant == "hi":
        base = tuple(_clamp(c + 40) for c in base[:3]) + (base[3],)
    elif variant == "dn":
        base = tuple(_clamp(c - 20) for c in base[:3]) + (base[3],)
    d.rounded_rectangle([0, 0, w - 1, h - 1], radius=3, fill=base, outline=(201, 165, 74, 220))
    return img


def make_ribbon(w, h, vertex):
    img = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    color = vertex or (110, 31, 31, 255)
    ImageDraw.Draw(img).rectangle([0, 2, w - 1, h - 3], fill=color)
    return img


def make_placeholder(w, h, label, vertex):
    img = Image.new("RGBA", (w, h), (50, 44, 38, 230))
    d = ImageDraw.Draw(img)
    ink = vertex or (201, 165, 74, 255)
    d.rectangle([0, 0, w - 1, h - 1], outline=ink)
    if label and w >= 24 and h >= 10:
        font = load_font(_SYSTEM_FRIZ, max(8, min(11, h // 2)))
        d.text((3, 1), label[:18], font=font, fill=ink)
    return img


def approx_texture(path, w, h, vertex, x0=0, y0=0):
    w = max(1, int(w))
    h = max(1, int(h))
    token = _token(path)
    key = STOCK_KEYS.get(token)
    if path and _looks_media(path):
        disk = _media_disk(path)
        if disk and disk.suffix.lower() == ".tga":
            try:
                src = Image.open(disk).convert("RGBA")
                return src.resize((w, h), Image.Resampling.LANCZOS)
            except OSError:
                pass
        return make_placeholder(w, h, token or "media", vertex)

    if key == "parchment":
        return make_parchment(w, h, vertex, x0, y0)
    if key == "tooltip_bg":
        return make_flat(w, h, (12, 10, 9, 235))
    if key == "white8":
        return make_flat(w, h, vertex or (255, 255, 255, 255))
    if key == "statusbar":
        return make_statusbar(w, h, vertex)
    if key == "ring_dark":
        return make_ring(w, h, vertex or (40, 36, 32, 255), fill=(20, 18, 16, 180))
    if key == "ring_light":
        return make_ring(w, h, vertex or (201, 165, 74, 255))
    if key == "ring_press":
        return make_ring(w, h, vertex or (80, 70, 50, 255), fill=(30, 26, 22, 220))
    if key == "corner_l":
        return make_corner_l(w, h, vertex or (42, 38, 34, 255))
    if key == "edge":
        return make_edge(w, h, vertex or (42, 38, 34, 255))
    if key == "minimap_border":
        return make_minimap_tracking_border(w, h)
    if key == "minimap_disc":
        return make_disc(w, h, (18, 16, 14, 255))
    if key == "minimap_hi":
        return make_soft_ring(w, h, (255, 240, 180, 180))
    if key == "sunburst":
        return make_sunburst(w, h, vertex)
    if key == "book":
        # A leaf stretched across a Records page is parchment, not a giant icon.
        if w > 80 or h > 80:
            return make_parchment(w, h, vertex or (228, 214, 176, 255), x0, y0)
        return make_book(w, h, vertex)
    if key in ("checkbox", "check", "radio", "slider"):
        return make_mark(w, h, key, vertex or (201, 165, 74, 255))
    if key == "plate":
        return make_plate(w, h, vertex, "up")
    if key == "plate_hi":
        return make_plate(w, h, vertex, "hi")
    if key == "plate_dn":
        return make_plate(w, h, vertex, "dn")
    if key == "ribbon":
        return make_ribbon(w, h, vertex)
    if path:
        return make_placeholder(w, h, token, vertex)
    if vertex:
        return make_flat(w, h, vertex)
    return make_flat(w, h, (0, 0, 0, 0))


# ---------------------------------------------------------------------------
# Layout
# ---------------------------------------------------------------------------

def _anchor_xy(rect, point):
    l, t, r, b = rect
    ux, uy = ANCHOR_UV.get(point or "CENTER", (0.5, 0.5))
    return l + (r - l) * ux, t + (b - t) * uy


def _apply_anchor(box, wp, x, y, ew, eh):
    l, t, r, b, cx, cy = box
    if wp == "TOPLEFT":
        l, t = x, y
    elif wp == "TOP":
        cx, t = x, y
    elif wp == "TOPRIGHT":
        r, t = x, y
    elif wp == "LEFT":
        l, cy = x, y
    elif wp == "CENTER":
        cx, cy = x, y
    elif wp == "RIGHT":
        r, cy = x, y
    elif wp == "BOTTOMLEFT":
        l, b = x, y
    elif wp == "BOTTOM":
        cx, b = x, y
    elif wp == "BOTTOMRIGHT":
        r, b = x, y
    elif wp == "ALL":
        pass
    return [l, t, r, b, cx, cy]


def _finish_box(box, ew, eh, fallback, grow_w=False, grow_h=False):
    l, t, r, b, cx, cy = box
    if l is not None and r is not None:
        ew = r - l
    if t is not None and b is not None:
        eh = b - t
    if ew is None:
        if grow_w:
            ew = 0
        else:
            ew = fallback[2] - fallback[0] if fallback else 0
    if eh is None:
        if grow_h:
            eh = 0
        else:
            eh = fallback[3] - fallback[1] if fallback else 0
    ew = max(0, ew)
    eh = max(0, eh)
    if l is None:
        if r is not None:
            l = r - ew
        elif cx is not None:
            l = cx - ew / 2
        else:
            l = fallback[0] if fallback else 0
    if r is None:
        r = l + ew
    if t is None:
        if b is not None:
            t = b - eh
        elif cy is not None:
            t = cy - eh / 2
        else:
            t = fallback[1] if fallback else 0
    if b is None:
        b = t + eh
    return (l, t, r, b)


def resolve_rects(scene, theme):
    widgets = {w["id"]: w for w in scene.get("widgets") or []}
    screen = scene.get("screen") or {}
    sw = screen.get("width") or SCREEN_W
    sh = screen.get("height") or SCREEN_H
    rects = {}

    # UIParent (or first root) is the screen.
    roots = scene.get("roots") or []
    if roots:
        rects[roots[0]] = (0.0, 0.0, float(sw), float(sh))
    for w in widgets.values():
        if w.get("name") == "UIParent":
            rects[w["id"]] = (0.0, 0.0, float(w.get("width") or sw), float(w.get("height") or sh))

    resolving = set()

    def parent_rect(wid):
        w = widgets.get(wid)
        if not w:
            return (0.0, 0.0, float(sw), float(sh))
        pid = w.get("parent")
        if pid in rects:
            return rects[pid]
        if pid:
            return resolve_one(pid)
        return (0.0, 0.0, float(sw), float(sh))

    def resolve_one(wid):
        if wid in rects:
            return rects[wid]
        if wid in resolving:
            return (0.0, 0.0, 0.0, 0.0)
        resolving.add(wid)
        w = widgets.get(wid)
        if not w:
            resolving.discard(wid)
            return (0.0, 0.0, float(sw), float(sh))

        pref = parent_rect(wid)
        points = w.get("points") or []
        ew = w.get("width")
        eh = w.get("height")
        if isinstance(ew, (int, float)):
            ew = float(ew)
        else:
            ew = None
        if isinstance(eh, (int, float)):
            eh = float(eh)
        else:
            eh = None

        for p in points:
            if p.get("point") == "ALL":
                rel = p.get("relativeTo") or w.get("parent")
                rects[wid] = resolve_one(rel) if rel else pref
                resolving.discard(wid)
                return rects[wid]

        box = [None, None, None, None, None, None]
        if not points:
            # Unanchored template labels (BasicFrame TitleText) sit across
            # the top of the parent; other unanchored widgets sit at origin.
            if w.get("type") in ("FontString", "EditBox") and w.get("text"):
                pad = 8.0
                rects[wid] = (pref[0] + pad, pref[1] + pad, pref[2] - pad, pref[1] + pad)
            else:
                rects[wid] = (pref[0], pref[1], pref[0] + (ew or 0), pref[1] + (eh or 0))
            resolving.discard(wid)
            return rects[wid]

        for p in points:
            wp = p.get("point") or "TOPLEFT"
            rp = p.get("relativePoint") or wp
            rel = p.get("relativeTo") or w.get("parent")
            ox = float(p.get("x") or 0)
            oy = float(p.get("y") or 0)
            # WoW +y is up; preview canvas +y is down.
            sx_off, sy_off = ox, -oy
            if rel:
                rrect = resolve_one(rel)
            else:
                rrect = pref
            rx, ry = _anchor_xy(rrect, rp)
            box = _apply_anchor(box, wp, rx + sx_off, ry + sy_off, ew, eh)

        # Measure FontStrings so a BOTTOM-relative neighbor sits under the
        # text, not on the same 0-height pin.
        is_text = w.get("type") in ("FontString", "EditBox")
        wrap_w = None
        if box[0] is not None and box[2] is not None:
            wrap_w = box[2] - box[0]
        elif isinstance(ew, (int, float)) and ew > 0:
            wrap_w = ew
        if is_text and w.get("text"):
            mw, mh = measure_widget_text(w, theme, wrap_w)
            if ew is None:
                ew = mw
            if eh is None:
                eh = mh
        grow_w = is_text and (box[0] is None or box[2] is None) and not ew
        grow_h = is_text and (box[1] is None or box[3] is None) and not eh

        rects[wid] = _finish_box(box, ew, eh, pref, grow_w=grow_w, grow_h=grow_h)
        resolving.discard(wid)
        return rects[wid]

    for wid in widgets:
        resolve_one(wid)
    return rects


# ---------------------------------------------------------------------------
# Composite
# ---------------------------------------------------------------------------

def screen_blend(dst, src, box):
    l, t, r, b = box
    l, t, r, b = int(l), int(t), int(r), int(b)
    if r <= l or b <= t:
        return
    src = src.resize((r - l, b - t), Image.Resampling.BILINEAR)
    region = dst.crop((l, t, r, b)).convert("RGBA")
    sp = src.load()
    dp = region.load()
    w, h = src.size
    for y in range(h):
        for x in range(w):
            sr, sg, sb, sa = sp[x, y]
            if sa <= 0:
                continue
            dr, dg, db, da = dp[x, y]
            nr = 255 - ((255 - sr) * (255 - dr)) // 255
            ng = 255 - ((255 - sg) * (255 - dg)) // 255
            nb = 255 - ((255 - sb) * (255 - db)) // 255
            a = _clamp(sa + da - (sa * da) // 255)
            dp[x, y] = (nr, ng, nb, a)
    dst.paste(region, (l, t))


def paste_normal(dst, src, box):
    l, t = int(round(box[0])), int(round(box[1]))
    r, b = int(round(box[2])), int(round(box[3]))
    if r <= l or b <= t:
        return
    src = src.resize((r - l, b - t), Image.Resampling.BILINEAR)
    dst.alpha_composite(src, (l, t))


def wrap_text(text, font, max_w, word_wrap):
    if text is None:
        return []
    text = str(text)
    if not text:
        return []
    if not word_wrap or max_w <= 0:
        return text.split("\n")
    lines = []
    for para in text.split("\n"):
        words = para.split(" ")
        cur = ""
        for i, word in enumerate(words):
            trial = word if cur == "" else cur + " " + word
            bbox = font.getbbox(trial) if hasattr(font, "getbbox") else (0, 0, len(trial) * 6, 10)
            tw = bbox[2] - bbox[0]
            if tw <= max_w or cur == "":
                cur = trial
            else:
                lines.append(cur)
                cur = word
        lines.append(cur)
    return lines


def text_size(font, s):
    if hasattr(font, "getbbox"):
        b = font.getbbox(s)
        return b[2] - b[0], b[3] - b[1]
    return font.getsize(s)


def measure_widget_text(widget, theme, wrap_width=None):
    text = widget.get("text")
    if not text:
        return 0.0, 0.0
    size = max(8, font_size_for(widget, theme))
    font = load_font(resolve_font_path(widget.get("fontPath"), widget.get("template"), theme), size)
    wrap = widget.get("wordWrap")
    max_w = wrap_width if wrap_width and wrap_width > 1 else 10000
    if wrap is None:
        wrap = wrap_width is not None and wrap_width > 8
    lines = wrap_text(text, font, max_w, wrap)
    if not lines:
        return 0.0, 0.0
    ascent, descent = (size, size // 4)
    if hasattr(font, "getmetrics"):
        ascent, descent = font.getmetrics()
    line_h = max(size + max(2, size // 8), ascent + descent + 2)
    block_w = 0
    for line in lines:
        tw, _ = text_size(font, line)
        if tw > block_w:
            block_w = tw
    return float(block_w), float(line_h * len(lines))


def _clip_layer(layer, clip):
    if not clip:
        return layer
    mask = Image.new("L", layer.size, 0)
    ImageDraw.Draw(mask).rectangle(
        [int(clip[0]), int(clip[1]), int(max(clip[2], clip[0] + 1)), int(max(clip[3], clip[1] + 1))],
        fill=255,
    )
    out = Image.new("RGBA", layer.size, (0, 0, 0, 0))
    out.paste(layer, (0, 0), mask)
    return out


def draw_text_widget(canvas, widget, rect, theme, clip=None):
    text = widget.get("text")
    if text is None or text == "":
        return
    l, t, r, b = rect
    w = max(0.0, r - l)
    h = max(0.0, b - t)
    size = max(8, font_size_for(widget, theme) * SCALE)
    font = load_font(resolve_font_path(widget.get("fontPath"), widget.get("template"), theme), size)
    wrap = widget.get("wordWrap")
    if wrap is None:
        wrap = w > 8
    max_w = w if w > 1 else CANVAS_W
    lines = wrap_text(text, font, max_w, wrap)
    if not lines:
        return
    ascent, descent = (0, 0)
    if hasattr(font, "getmetrics"):
        ascent, descent = font.getmetrics()
    line_h = max(size + max(2, size // 8), ascent + descent + 2)
    block_h = line_h * len(lines)
    block_w = 0
    for line in lines:
        tw, _ = text_size(font, line)
        if tw > block_w:
            block_w = tw
    jh = (widget.get("justifyH") or "LEFT").upper()
    jv = (widget.get("justifyV") or "TOP").upper()
    if not widget.get("points") and not widget.get("justifyH"):
        jh = "CENTER"
    if w <= 1:
        if jh == "RIGHT":
            l, r = r - block_w, r
        elif jh == "CENTER":
            l, r = l - block_w / 2, l + block_w / 2
        else:
            r = l + block_w
        w = r - l
    if h <= 1:
        if jv == "BOTTOM":
            t, b = b - block_h, b
        elif jv in ("MIDDLE", "CENTER"):
            t, b = t - block_h / 2, t + block_h / 2
        else:
            b = t + block_h
        h = b - t
    if jv in ("MIDDLE", "CENTER"):
        y0 = t + max(0, (h - block_h) / 2)
    elif jv == "BOTTOM":
        y0 = t + max(0, h - block_h)
    else:
        y0 = t

    # Uncolored text inherits its template's stock color: GameFontNormal* is
    # the classic UI gold, GameFontHighlight* is white. Only non-template
    # strings fall back to Theme parchment.
    tmpl = widget.get("template") or ""
    if tmpl.startswith("GameFontHighlight"):
        default_color = (255, 255, 255, 255)
    elif tmpl.startswith("GameFont"):
        default_color = (255, 209, 0, 255)
    else:
        default_color = (228, 214, 176, 255)
    color = _rgba(widget.get("textColor"), default_color)
    layer = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
    d = ImageDraw.Draw(layer)
    for i, line in enumerate(lines):
        tw, _ = text_size(font, line)
        if jh == "RIGHT":
            x = r - tw
        elif jh == "CENTER":
            x = l + (w - tw) / 2
        else:
            x = l
        d.text((x, y0 + i * line_h), line, font=font, fill=color)
    canvas.alpha_composite(_clip_layer(layer, clip))


def widget_alpha(widget, widgets, cache):
    wid = widget["id"]
    if wid in cache:
        return cache[wid]
    a = widget.get("alpha")
    a = 1.0 if a is None else float(a)
    if widget.get("ignoreParentAlpha"):
        cache[wid] = a
        return a
    pid = widget.get("parent")
    if pid and pid in widgets:
        a *= widget_alpha(widgets[pid], widgets, cache)
    cache[wid] = a
    return a


def draw_backdrop(canvas, widget, rect):
    l, t, r, b = [int(round(v)) for v in rect]
    if r <= l or b <= t:
        return
    fill = widget.get("backdropColor")
    border = widget.get("backdropBorderColor")
    info = widget.get("backdrop") or {}
    bg = info.get("bgFile")
    if bg:
        vertex = _rgba(fill, (255, 255, 255, 230))
        src = approx_texture(bg, r - l, b - t, vertex, l, t)
        paste_normal(canvas, src, (l, t, r, b))
    elif fill:
        ImageDraw.Draw(canvas).rectangle([l, t, r - 1, b - 1], fill=_rgba(fill, (28, 26, 23, 230)))
    if border or info.get("edgeFile"):
        color = _rgba(border, (42, 38, 34, 255))
        ImageDraw.Draw(canvas).rectangle([l, t, r - 1, b - 1], outline=color, width=max(1, SCALE))


def draw_texture(canvas, widget, rect, theme):
    l, t, r, b = rect
    w, h = max(1, int(round(r - l))), max(1, int(round(b - t)))
    if w <= 0 or h <= 0:
        return
    vertex = _rgba(widget.get("vertexColor") or widget.get("statusBarColor"), (255, 255, 255, 255))
    color_tex = widget.get("colorTexture")
    path = widget.get("texture") or widget.get("statusBarTexture")
    if color_tex:
        src = make_flat(w, h, _rgba(color_tex, vertex))
    else:
        src = approx_texture(path, w, h, vertex, int(l), int(t))
        tex_coord = widget.get("texCoord")
        if isinstance(tex_coord, list) and len(tex_coord) == 4:
            u0, u1, v0, v1 = tex_coord
            if all(isinstance(v, (int, float)) for v in tex_coord):
                crop = (
                    max(0, min(w - 1, int(round(u0 * w)))),
                    max(0, min(h - 1, int(round(v0 * h)))),
                    max(1, min(w, int(round(u1 * w)))),
                    max(1, min(h, int(round(v1 * h)))),
                )
                if crop[2] > crop[0] and crop[3] > crop[1]:
                    src = src.crop(crop).resize((w, h), Image.Resampling.LANCZOS)
        if vertex != (255, 255, 255, 255) and path and _token(path) != "WHITE8X8":
            # Tint grayscale-ish stock by multiplying vertex (skip parchment).
            if STOCK_KEYS.get(_token(path)) not in ("parchment",):
                src = _multiply_vertex(src, vertex)
    if widget.get("type") == "StatusBar":
        src = _fill_statusbar(src, widget)
    blend = (widget.get("blendMode") or "BLEND").upper()
    box = (l, t, r, b)
    if blend in ("ADD", "SCREEN"):
        screen_blend(canvas, src, box)
    else:
        paste_normal(canvas, src, box)


def _multiply_vertex(img, vertex):
    vr, vg, vb, va = vertex
    r, g, b, a = img.split()
    def scale(ch, v):
        return ch.point(lambda p: (p * v) // 255)
    r = scale(r, vr)
    g = scale(g, vg)
    b = scale(b, vb)
    if va < 255:
        a = a.point(lambda p: (p * va) // 255)
    return Image.merge("RGBA", (r, g, b, a))


def _fill_statusbar(img, widget):
    mn = widget.get("minValue")
    mx = widget.get("maxValue")
    val = widget.get("value")
    if not isinstance(mn, (int, float)):
        mn = 0
    if not isinstance(mx, (int, float)):
        mx = 100
    if not isinstance(val, (int, float)):
        val = mx
    span = float(mx) - float(mn)
    if span <= 0:
        frac = 0
    else:
        frac = max(0.0, min(1.0, (float(val) - float(mn)) / span))
    w, h = img.size
    cut = max(0, int(w * frac))
    if cut >= w:
        return img
    out = img.copy()
    dark = Image.new("RGBA", (w - cut, h), (20, 18, 16, 160))
    out.paste(dark, (cut, 0))
    return out


def draw_button_chrome(canvas, widget, rect, theme):
    path = widget.get("normalTexture")
    if not path:
        return
    l, t, r, b = rect
    w, h = max(1, int(round(r - l))), max(1, int(round(b - t)))
    src = approx_texture(path, w, h, None, int(l), int(t))
    paste_normal(canvas, src, rect)


def inherited_strata(widget, widgets):
    w = widget
    depth = 0
    while w and depth < 24:
        raw = w.get("strata")
        if raw:
            return STRATA_ORDER.get(str(raw).upper(), 2)
        pid = w.get("parent")
        w = widgets.get(pid) if pid else None
        depth += 1
    return 2


def sort_key(widget, widgets):
    strata = inherited_strata(widget, widgets)
    level = widget.get("frameLevel")
    if not isinstance(level, (int, float)):
        level = 0
        pid = widget.get("parent")
        depth = 0
        while pid and pid in widgets and depth < 24:
            depth += 1
            pid = widgets[pid].get("parent")
        level = depth
    layer = LAYER_ORDER.get((widget.get("layer") or "").upper(), 2)
    return (strata, level, layer, widget.get("id") or 0)


def render_scene(scene, theme):
    rects = resolve_rects(scene, theme)
    widgets = {w["id"]: w for w in scene.get("widgets") or []}
    canvas = Image.new("RGBA", (CANVAS_W, CANVAS_H), (18, 16, 14, 255))

    def scale_rect(rect):
        l, t, r, b = rect
        return (l * SCALE, t * SCALE, r * SCALE, b * SCALE)

    # Clip to ancestor frames that clip children, else the screen.
    def clip_for(wid):
        w = widgets.get(wid)
        clip = None
        while w:
            # WoW ScrollFrames clip their scroll child intrinsically even when
            # SetClipsChildren was never called. Model that so compact Console
            # previews show the viewport, not the full 1050-unit desk well.
            if (w.get("clipsChildren") or w.get("type") == "ScrollFrame") and w["id"] in rects:
                candidate = scale_rect(rects[w["id"]])
                if clip is None:
                    clip = candidate
                else:
                    clip = (
                        max(clip[0], candidate[0]),
                        max(clip[1], candidate[1]),
                        min(clip[2], candidate[2]),
                        min(clip[3], candidate[3]),
                    )
            pid = w.get("parent")
            w = widgets.get(pid) if pid else None
        return clip

    alpha_cache = {}
    ordered = sorted(widgets.values(), key=lambda w: sort_key(w, widgets))

    # Frames / backdrops first within a layer, textures next, text last.
    type_rank = {
        "Frame": 0, "ScrollFrame": 0, "Button": 1, "CheckButton": 1,
        "Slider": 1, "StatusBar": 2, "Texture": 2, "EditBox": 3, "FontString": 4,
    }
    ordered.sort(key=lambda w: sort_key(w, widgets) + (type_rank.get(w.get("type"), 3),))

    for w in ordered:
        if w.get("name") == "UIParent":
            continue
        if w.get("shown") is False:
            continue
        rect = rects.get(w["id"])
        if not rect:
            continue
        srect = scale_rect(rect)
        if srect[2] <= srect[0] or srect[3] <= srect[1]:
            # Allow point-sized fontstrings to grow.
            if w.get("type") not in ("FontString", "EditBox"):
                continue
        a = widget_alpha(w, widgets, alpha_cache)
        if a <= 0:
            continue
        ty = w.get("type")
        if w.get("name") == "Minimap" and ty == "Frame":
            mw = max(1, int(srect[2] - srect[0]))
            mh = max(1, int(srect[3] - srect[1]))
            disc = Image.new("RGBA", (mw, mh), (0, 0, 0, 0))
            ImageDraw.Draw(disc).ellipse([1, 1, mw - 2, mh - 2], fill=(36, 32, 28, 255), outline=(90, 78, 52, 255))
            # Seeded grain so the disc is readable against the stage.
            rng = _seeded_rng("minimap", mw, mh)
            px = disc.load()
            for y in range(mh):
                for x in range(mw):
                    r, g, b, a = px[x, y]
                    if a == 0:
                        continue
                    n = rng.randint(-12, 12)
                    px[x, y] = (_clamp(r + n), _clamp(g + n), _clamp(b + n), a)
            paste_normal(canvas, disc, srect)
        if ty in ("Frame", "ScrollFrame", "Button", "CheckButton", "EditBox", "Slider", "StatusBar"):
            if w.get("backdrop") or w.get("backdropColor"):
                draw_backdrop(canvas, w, srect)
        if ty in ("Button", "CheckButton"):
            draw_button_chrome(canvas, w, srect, theme)
        if ty in ("Texture", "StatusBar"):
            draw_texture(canvas, w, srect, theme)
        if ty in ("FontString", "EditBox", "Button", "CheckButton"):
            if ty in ("Button", "CheckButton"):
                has_child_label = any(
                    c.get("parent") == w["id"]
                    and c.get("type") == "FontString"
                    and c.get("text")
                    for c in widgets.values()
                )
                if has_child_label or not (w.get("text") or w.get("fontStringText")):
                    continue
                w = dict(w)
                w["text"] = w.get("text") or w.get("fontStringText")
                if not w.get("textColor"):
                    w["textColor"] = {"r": 1, "g": 0.82, "b": 0, "a": 1}
                if not w.get("justifyH"):
                    w["justifyH"] = "CENTER"
                if not w.get("justifyV"):
                    w["justifyV"] = "MIDDLE"
            draw_text_widget(canvas, w, srect, theme, clip_for(w["id"]))

    return canvas.resize((SCREEN_W, SCREEN_H), Image.Resampling.LANCZOS)


def contact_sheet(paths):
    if not paths:
        return
    cols = 4
    rows = math.ceil(len(paths) / cols)
    thumb_w, thumb_h = SCREEN_W // 4, SCREEN_H // 4
    label_h = 22
    sheet = Image.new("RGB", (cols * thumb_w, rows * (thumb_h + label_h)), (18, 16, 14))
    d = ImageDraw.Draw(sheet)
    _system_standins()
    font = load_font(_SYSTEM_FRIZ, 12)
    for i, path in enumerate(paths):
        col, row = i % cols, i // cols
        im = Image.open(path).convert("RGB").resize((thumb_w, thumb_h), Image.Resampling.LANCZOS)
        x, y = col * thumb_w, row * (thumb_h + label_h)
        sheet.paste(im, (x, y))
        d.rectangle([x, y + thumb_h, x + thumb_w, y + thumb_h + label_h], fill=(28, 26, 23))
        d.text((x + 6, y + thumb_h + 4), path.stem, font=font, fill=(228, 214, 176))
    out = PREVIEW / "contact-sheet.png"
    sheet.save(out)
    print("wrote", out)


def main():
    theme_path = PREVIEW / "theme.json"
    theme = {}
    if theme_path.is_file():
        theme = json.loads(theme_path.read_text())
    _system_standins()

    scenes = sorted(p for p in PREVIEW.glob("*.json") if p.name != "theme.json")
    if not scenes:
        print("no preview JSON in", PREVIEW)
        return 1
    written = []
    for path in scenes:
        scene = json.loads(path.read_text())
        img = render_scene(scene, theme)
        out = PREVIEW / (path.stem + ".png")
        img.save(out)
        print("wrote", out, out.stat().st_size, "bytes")
        written.append(out)
    contact_sheet(written)
    return 0


if __name__ == "__main__":
    sys.exit(main())
