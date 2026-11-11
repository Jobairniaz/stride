"""Generates Stride's Android notification (status bar) icon.

Android draws the small notification icon from its alpha channel only, tinted
by the system, so it must be a white silhouette on transparency. This reuses
the runner + speed lines extracted by generate_app_icon.py
(tool/app_icon_artwork.png) and writes drawable-*/ic_stat_stride.png at the
24dp size Android expects, with the artwork inside the 20dp live area.

Run from the project root (after generate_app_icon.py):
    python3 tool/generate_notification_icon.py
"""

from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parent.parent
ARTWORK = ROOT / "tool/app_icon_artwork.png"
NAME = "ic_stat_stride"
ICON_DP = 24
LIVE_DP = 22  # Material allows 2dp padding; 22dp keeps the speed lines legible
DENSITIES = {"mdpi": 1, "hdpi": 1.5, "xhdpi": 2, "xxhdpi": 3, "xxxhdpi": 4}


def silhouette(art: Image.Image) -> Image.Image:
    """White glyph cropped to its bounds, from the artwork's alpha."""
    alpha = art.getchannel("A").point(lambda a: 0 if a < 26 else a)
    alpha = alpha.crop(alpha.getbbox())
    glyph = Image.new("RGBA", alpha.size, (255, 255, 255, 255))
    glyph.putalpha(alpha)
    return glyph


def render(glyph: Image.Image, px: int, live: float) -> Image.Image:
    """Glyph fitted to the live area, centred on a px-square transparent canvas."""
    S = px * 8  # draw large, then downsample once for clean anti-aliasing
    k = live * S / max(glyph.size)
    g = glyph.resize((round(glyph.width * k), round(glyph.height * k)), Image.LANCZOS)
    canvas = Image.new("RGBA", (S, S), (255, 255, 255, 0))
    canvas.alpha_composite(g, ((S - g.width) // 2, (S - g.height) // 2))
    return canvas.resize((px, px), Image.LANCZOS)


def main():
    glyph = silhouette(Image.open(ARTWORK).convert("RGBA"))
    res = ROOT / "android/app/src/main/res"
    for name, f in DENSITIES.items():
        d = res / f"drawable-{name}"
        d.mkdir(exist_ok=True)
        px = round(ICON_DP * f)
        render(glyph, px, LIVE_DP / ICON_DP).save(d / f"{NAME}.png")
        print(f"{d.relative_to(ROOT)}/{NAME}.png  {px}x{px}")


if __name__ == "__main__":
    main()
