#!/usr/bin/env python3
"""Honest geometric placeholders for Theme slots until ChatGPT masters land.

Writes RGBA PNGs into assets/incoming/ with the 8% empty margin the importer
requires. Not church art — gold rings, iron studs, parchment fields, and
simple engraved marks so Classic never has to dress a bag-slot as a seal.

Usage:
  python3 scripts/make-geometry-placeholders.py
  python3 scripts/import-assets.py
"""
from __future__ import annotations

import math
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "assets" / "incoming"

GOLD = (201, 165, 74, 255)
IRON = (42, 38, 34, 255)
CHARCOAL = (28, 26, 23, 255)
PARCHMENT = (228, 214, 176, 255)
PARCHMENT_MID = (217, 201, 163, 255)
OXBLOOD = (110, 31, 31, 255)
SILVER = (154, 150, 142, 255)


def canvas(w: int, h: int) -> Image.Image:
    return Image.new("RGBA", (w, h), (0, 0, 0, 0))


def margin_box(w: int, h: int, frac: float = 0.12):
    mx = int(w * frac)
    my = int(h * frac)
    return mx, my, w - mx - 1, h - my - 1


def parchment_field(w: int, h: int, name: str) -> None:
    im = canvas(w, h)
    draw = ImageDraw.Draw(im)
    x0, y0, x1, y1 = margin_box(w, h)
    draw.rectangle((x0, y0, x1, y1), fill=PARCHMENT)
    # Inner aged wash — keeps the field from reading as a flat UI panel.
    inset = 6
    draw.rectangle((x0 + inset, y0 + inset, x1 - inset, y1 - inset), fill=PARCHMENT_MID)
    # Gold inner rule
    draw.rectangle((x0 + 3, y0 + 3, x1 - 3, y1 - 3), outline=GOLD, width=2)
    im.save(OUT / name)


def iron_field(w: int, h: int, name: str) -> None:
    im = canvas(w, h)
    draw = ImageDraw.Draw(im)
    x0, y0, x1, y1 = margin_box(w, h)
    draw.rectangle((x0, y0, x1, y1), fill=CHARCOAL)
    draw.rectangle((x0 + 2, y0 + 2, x1 - 2, y1 - 2), outline=GOLD, width=2)
    im.save(OUT / name)


def ring_seal(w: int, name: str, fill, ring=GOLD, horns: bool = False) -> None:
    im = canvas(w, w)
    draw = ImageDraw.Draw(im)
    x0, y0, x1, y1 = margin_box(w, w, 0.14)
    # Outer ring
    draw.ellipse((x0, y0, x1, y1), outline=ring, width=max(4, w // 28))
    inner = 10
    draw.ellipse((x0 + inner, y0 + inner, x1 - inner, y1 - inner), fill=fill)
    if horns:
        cx = (x0 + x1) / 2
        cy = (y0 + y1) / 2 - w * 0.04
        r = (x1 - x0) * 0.22
        # Two horn arcs — reads as a bull, not a bag slot.
        draw.arc((cx - r * 2.1, cy - r * 1.6, cx - r * 0.15, cy + r * 0.8),
                 start=200, end=340, fill=ring, width=max(3, w // 40))
        draw.arc((cx + r * 0.15, cy - r * 1.6, cx + r * 2.1, cy + r * 0.8),
                 start=200, end=340, fill=ring, width=max(3, w // 40))
    im.save(OUT / name)


def nail(w: int, name: str) -> None:
    im = canvas(w, w)
    draw = ImageDraw.Draw(im)
    x0, y0, x1, y1 = margin_box(w, w, 0.22)
    draw.ellipse((x0, y0, x1, y1), fill=IRON, outline=GOLD, width=2)
    cx = (x0 + x1) / 2
    cy = (y0 + y1) / 2
    r = 2
    draw.ellipse((cx - r, cy - r, cx + r, cy + r), fill=GOLD)
    im.save(OUT / name)


def pin(w: int, name: str) -> None:
    nail(w, name)


def bullhorn(w: int, h: int, name: str) -> None:
    im = canvas(w, h)
    draw = ImageDraw.Draw(im)
    x0, y0, x1, y1 = margin_box(w, h, 0.14)
    mid_x = (x0 + x1) / 2
    mid_y = (y0 + y1) / 2
    width = max(3, h // 18)
    # Left horn
    draw.arc((x0, y0, mid_x + (x1 - x0) * 0.08, y1), start=200, end=340, fill=GOLD, width=width)
    # Right horn
    draw.arc((mid_x - (x1 - x0) * 0.08, y0, x1, y1), start=200, end=340, fill=GOLD, width=width)
    # Center boss
    r = max(4, h // 10)
    draw.ellipse((mid_x - r, mid_y - r, mid_x + r, mid_y + r), outline=GOLD, width=2)
    im.save(OUT / name)


def glyph(w: int, name: str, kind: str) -> None:
    im = canvas(w, w)
    draw = ImageDraw.Draw(im)
    x0, y0, x1, y1 = margin_box(w, w, 0.20)
    width = 2
    if kind == "record":
        # Crossed axes
        draw.line((x0, y0, x1, y1), fill=GOLD, width=width)
        draw.line((x1, y0, x0, y1), fill=GOLD, width=width)
    elif kind == "defenses":
        # Shield chevron
        mx = (x0 + x1) / 2
        draw.polygon([(mx, y0), (x1, y0 + (y1 - y0) * 0.35), (mx, y1), (x0, y0 + (y1 - y0) * 0.35)],
                     outline=GOLD)
    elif kind == "headtohead":
        my = (y0 + y1) / 2
        mx = (x0 + x1) / 2
        draw.polygon([(x0, my), (mx - 2, y0), (mx - 2, y1)], outline=GOLD)
        draw.polygon([(x1, my), (mx + 2, y0), (mx + 2, y1)], outline=GOLD)
    else:
        # Scroll
        draw.rectangle((x0, y0 + 3, x1, y1 - 3), outline=GOLD, width=width)
        draw.line((x0 + 3, (y0 + y1) / 2, x1 - 3, (y0 + y1) / 2), fill=GOLD, width=1)
    im.save(OUT / name)


def ribbon(w: int, h: int, name: str) -> None:
    im = canvas(w, h)
    draw = ImageDraw.Draw(im)
    x0, y0, x1, y1 = margin_box(w, h, 0.14)
    draw.rectangle((x0, y0, x1, y1 - (h * 0.08)), fill=OXBLOOD)
    # Swallowtail
    mx = (x0 + x1) / 2
    draw.polygon([(x0, y1 - (h * 0.08)), (mx, y1), (x1, y1 - (h * 0.08))], fill=OXBLOOD)
    draw.rectangle((x0, y0, x1, y1 - (h * 0.08)), outline=GOLD, width=1)
    im.save(OUT / name)


def roundel(w: int, name: str) -> None:
    ring_seal(w, name, CHARCOAL, GOLD, horns=True)


def rays(w: int, name: str) -> None:
    im = canvas(w, w)
    draw = ImageDraw.Draw(im)
    cx = w / 2
    cy = w / 2
    r0 = w * 0.16
    r1 = w * 0.36
    for i in range(12):
        a = math.radians(i * 30)
        x0 = cx + r0 * math.cos(a)
        y0 = cy + r0 * math.sin(a)
        x1 = cx + r1 * math.cos(a)
        y1 = cy + r1 * math.sin(a)
        draw.line((x0, y0, x1, y1), fill=(201, 165, 74, 160), width=2)
    im.save(OUT / name)


def banner(w: int, h: int, name: str) -> None:
    parchment_field(w, h, name)


def plate(w: int, h: int, name: str, fill) -> None:
    im = canvas(w, h)
    draw = ImageDraw.Draw(im)
    x0, y0, x1, y1 = margin_box(w, h, 0.14)
    draw.rectangle((x0, y0, x1, y1), fill=fill)
    draw.rectangle((x0 + 2, y0 + 2, x1 - 2, y1 - 2), outline=GOLD, width=2)
    im.save(OUT / name)


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    ring_seal(320, "COB_seal_papal.png", CHARCOAL, GOLD, horns=True)
    ring_seal(320, "COB_seal_victor.png", CHARCOAL, GOLD, horns=True)
    ring_seal(320, "COB_seal_cowardice.png", OXBLOOD, GOLD, horns=False)
    ring_seal(320, "COB_sigil_gora.png", CHARCOAL, GOLD, horns=True)
    ring_seal(96, "COB_sigil_favor.png", CHARCOAL, GOLD, horns=False)
    nail(80, "COB_ornament_nail.png")
    pin(80, "COB_frame_proclamation_pin_tl.png")
    pin(80, "COB_frame_proclamation_pin_tr.png")
    pin(80, "COB_frame_proclamation_pin_bl.png")
    pin(80, "COB_frame_proclamation_pin_br.png")
    bullhorn(640, 160, "COB_ornament_bullhorn.png")
    glyph(80, "COB_glyph_record.png", "record")
    glyph(80, "COB_glyph_defenses.png", "defenses")
    glyph(80, "COB_glyph_headtohead.png", "headtohead")
    glyph(80, "COB_glyph_stipulation.png", "stipulation")
    parchment_field(640, 320, "COB_parchment_decree.png")
    parchment_field(320, 320, "COB_frame_proclamation_center.png")
    parchment_field(320, 320, "COB_frame_proclamation.png")
    parchment_field(1280, 640, "COB_parchment_tome_records.png")
    iron_field(640, 160, "COB_frame_fightercard.png")
    ribbon(80, 320, "COB_ornament_ribbon_bookmark.png")
    roundel(80, "COB_roundel_minimap.png")
    rays(640, "COB_ornament_rays_sunburst.png")
    banner(640, 160, "COB_frame_banner_knighting.png")
    plate(320, 80, "COB_ornament_plate_verb.png", IRON)
    plate(320, 80, "COB_ornament_plate_verb_hover.png", (60, 52, 40, 255))
    plate(320, 80, "COB_ornament_plate_verb_pressed.png", CHARCOAL)
    print("wrote", len(list(OUT.glob("COB_*.png"))), "masters to", OUT)


if __name__ == "__main__":
    main()
