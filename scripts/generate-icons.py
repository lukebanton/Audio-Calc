#!/usr/bin/env python3
"""Regenerate PWA / home-screen icons from the source artwork."""

from PIL import Image
import os

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(ROOT, "Assets/Apple-Style iPhone App Icon.png")
PUBLIC = os.path.join(ROOT, "public")
XCODE_ICON = os.path.join(
    ROOT, "Audio Calc/Assets.xcassets/AppIcon.appiconset/AppIcon.png"
)

# Outer dark padding to remove, then zoom factor (Icon Composer scale-up)
OUTER_MARGIN = 0.15
ZOOM = 1.38


def generate_icons() -> None:
    im = Image.open(SRC).convert("RGB")
    w, h = im.size

    m = int(w * OUTER_MARGIN)
    inner = im.crop((m, m, w - m, h - m))

    iw, ih = inner.size
    zw, zh = int(iw * ZOOM), int(ih * ZOOM)
    zoomed = inner.resize((zw, zh), Image.LANCZOS)
    left = (zw - iw) // 2
    top = (zh - ih) // 2
    final = zoomed.crop((left, top, left + iw, top + ih))

    outputs = [
        (180, "apple-touch-icon-180.png"),
        (192, "icon-192.png"),
        (512, "icon-512.png"),
        (1024, "icon-1024.png"),
    ]

    for size, name in outputs:
        path = os.path.join(PUBLIC, name)
        final.resize((size, size), Image.LANCZOS).save(path, "PNG", optimize=True)
        print(f"Wrote {name}")

    final.resize((1024, 1024), Image.LANCZOS).save(XCODE_ICON, "PNG", optimize=True)
    print("Updated Xcode AppIcon.png")


if __name__ == "__main__":
    generate_icons()
