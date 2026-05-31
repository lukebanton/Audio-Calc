#!/usr/bin/env python3
"""Regenerate PWA / home-screen icons from the source artwork."""

from PIL import Image
import os

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(ROOT, "Assets/icon.png")
PUBLIC = os.path.join(ROOT, "public")
XCODE_ICON = os.path.join(
    ROOT, "Audio Calc/Assets.xcassets/AppIcon.appiconset/AppIcon.png"
)


def generate_icons() -> None:
    im = Image.open(SRC).convert("RGB")

    outputs = [
        (180, "icon-homescreen.png"),
        (192, "icon-192.png"),
        (512, "icon-512.png"),
        (1024, "icon-1024.png"),
    ]

    for size, name in outputs:
        path = os.path.join(PUBLIC, name)
        im.resize((size, size), Image.LANCZOS).save(path, "PNG", optimize=True)
        print(f"Wrote {name}")

    im.resize((1024, 1024), Image.LANCZOS).save(XCODE_ICON, "PNG", optimize=True)
    print("Updated Xcode AppIcon.png")


if __name__ == "__main__":
    generate_icons()
