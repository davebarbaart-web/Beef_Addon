#!/usr/bin/env python3
"""Render the full Church of Beef UI suite at representative screen sizes."""

from __future__ import annotations

import os
import importlib.util
import json
import subprocess
import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont


ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "docs" / "design" / "renders" / "responsive"
CASES = (
    ("compact_800x600", 800, 600),
    ("stream_1024x768", 1024, 768),
    ("widescreen_1920x1080", 1920, 1080),
)


def load_renderer():
    path = ROOT / "scripts" / "render-preview.py"
    spec = importlib.util.spec_from_file_location("cob_render_preview", path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


RENDERER = load_renderer()


def run_case(name: str, width: int, height: int) -> Path:
    destination = OUT / name
    destination.mkdir(parents=True, exist_ok=True)
    env = os.environ.copy()
    env.update(
        COB_PREVIEW_DIR=str(destination.relative_to(ROOT)),
        COB_PREVIEW_WIDTH=str(width),
        COB_PREVIEW_HEIGHT=str(height),
        # Responsive review values layout over supersampling. One pixel here
        # represents one WoW UI unit and keeps the widescreen pass lightweight.
        COB_PREVIEW_SCALE="1",
    )
    subprocess.run(["lua", "tests/preview_dump.lua"], cwd=ROOT, env=env, check=True)
    subprocess.run([sys.executable, "scripts/render-preview.py"], cwd=ROOT, env=env, check=True)
    return destination / "contact-sheet.png"


def validate_bounds(destination: Path, width: int, height: int) -> int:
    theme = json.loads((destination / "theme.json").read_text())
    scenes = sorted(path for path in destination.glob("*.json") if path.name != "theme.json")
    violations = []
    for path in scenes:
        scene = json.loads(path.read_text())
        screen = scene.get("screen") or {}
        if screen.get("width") != width or screen.get("height") != height:
            violations.append(f"{path.stem}: wrong screen metadata")
            continue
        widgets = {widget["id"]: widget for widget in scene.get("widgets") or []}
        rects = RENDERER.resolve_rects(scene, theme)

        def inside_scroll_child(widget):
            parent_id = widget.get("parent")
            while parent_id in widgets:
                parent = widgets[parent_id]
                if parent.get("type") == "ScrollFrame":
                    return True
                parent_id = parent.get("parent")
            return False

        for widget in widgets.values():
            if widget.get("name") == "UIParent" or inside_scroll_child(widget):
                continue
            left, top, right, bottom = rects[widget["id"]]
            if left < -1 or top < -1 or right > width + 1 or bottom > height + 1:
                label = widget.get("name") or widget.get("text") or widget.get("type")
                violations.append(
                    f"{path.stem}: {label!r} outside {width}x{height}: "
                    f"({left:.1f}, {top:.1f}, {right:.1f}, {bottom:.1f})"
                )
    if violations:
        raise RuntimeError("responsive bounds failed:\n" + "\n".join(violations))
    print(f"bounds passed: {len(scenes)} scenarios at {width}x{height}")
    return len(scenes)


def compose_matrix(sheets: list[tuple[str, int, int, Path]]) -> Path:
    target_w = 1200
    label_h = 34
    prepared = []
    for name, width, height, path in sheets:
        image = Image.open(path).convert("RGB")
        target_h = max(1, round(image.height * target_w / image.width))
        prepared.append((name, width, height, image.resize((target_w, target_h), Image.Resampling.LANCZOS)))

    canvas_h = sum(label_h + image.height for _, _, _, image in prepared)
    canvas = Image.new("RGB", (target_w, canvas_h), (18, 16, 14))
    draw = ImageDraw.Draw(canvas)
    font = ImageFont.load_default()
    y = 0
    for name, width, height, image in prepared:
        draw.rectangle((0, y, target_w, y + label_h), fill=(42, 38, 34))
        draw.text((12, y + 10), f"{name} | {width} x {height}", fill=(228, 214, 176), font=font)
        y += label_h
        canvas.paste(image, (0, y))
        y += image.height

    output = OUT / "contact-sheet.png"
    canvas.save(output)
    print("wrote", output)
    return output


def main() -> int:
    OUT.mkdir(parents=True, exist_ok=True)
    sheets = []
    verified = []
    for name, width, height in CASES:
        sheet = run_case(name, width, height)
        scenario_count = validate_bounds(sheet.parent, width, height)
        sheets.append((name, width, height, sheet))
        verified.append({"name": name, "width": width, "height": height, "scenarios": scenario_count})
    compose_matrix(sheets)
    (OUT / "summary.json").write_text(
        json.dumps({"status": "PASS", "cases": verified}, indent=2) + "\n"
    )
    scenario_count = verified[0]["scenarios"] if verified else 0
    print(f"responsive preview suite passed: {len(verified)} sizes × {scenario_count} scenarios")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
