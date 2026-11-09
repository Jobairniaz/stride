"""Generates Stride's launcher icons for iOS and Android from assets/3.png.

The source is the finished icon tile (blue gradient, runner, speed lines,
"Stride") drawn on a white margin. Platforms want different pieces of it:

* iOS wants a full-bleed square with no transparency (it rounds the corners).
* Android adaptive icons want the artwork and the background as separate
  layers on a 108dp canvas, plus a single-colour layer for themed icons.

So this script finds the tile, fits a smooth model of its background
gradient, separates the artwork from it (alpha + colour), and rebuilds
every size from those two layers. Pure Pillow, no numpy.

Run from the project root:  python3 tool/generate_app_icon.py
"""

import json
from pathlib import Path

from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parent.parent
SOURCE = ROOT / "assets/3.png"
MASTER = 1024  # working resolution of the extracted layers
# False: drop the "Stride" text and enlarge the runner + speed lines to fill
# ARTWORK_WIDTH of the icon. True: keep the tile exactly as drawn.
INCLUDE_WORDMARK = False
ARTWORK_WIDTH = 0.78


# --- 1. Locate the tile -----------------------------------------------------

def find_tile(img: Image.Image):
    """Bounding box and corner radius of the rounded tile on the white margin."""
    px = img.load()
    W, H = img.size
    dark = lambda x, y: min(px[x, y]) < 200
    left = next(x for x in range(W) if any(dark(x, y) for y in range(0, H, 2)))
    right = next(x for x in range(W - 1, -1, -1) if any(dark(x, y) for y in range(0, H, 2)))
    top = next(y for y in range(H) if any(dark(x, y) for x in range(0, W, 2)))
    bottom = next(y for y in range(H - 1, -1, -1) if any(dark(x, y) for x in range(0, W, 2)))
    # Corner radius: on the row k px below the top edge, the tile starts
    # inset by r - sqrt(r^2 - (r-k)^2). Solve for r from the measured inset.
    k = 12
    inset = next(x for x in range(left, right) if dark(x, top + k)) - left
    # (r - inset)^2 + (r - k)^2 = r^2  ->  r^2 - 2r(inset + k) + inset^2 + k^2 = 0
    s = inset + k
    r = s + (s * s - inset * inset - k * k) ** 0.5
    return (left, top, right + 1, bottom + 1), r


# --- 2. Fit the background gradient ---------------------------------------

def _features(u: float, v: float):
    d = (u - 0.5) ** 2
    return (1.0, v, v * v, d, d * v)


def _solve(A, b):
    n = len(b)
    M = [row[:] + [b[i]] for i, row in enumerate(A)]
    for c in range(n):
        p = max(range(c, n), key=lambda r: abs(M[r][c]))
        M[c], M[p] = M[p], M[c]
        for r in range(n):
            if r != c:
                f = M[r][c] / M[c][c]
                M[r] = [a - f * bb for a, bb in zip(M[r], M[c])]
    return [M[i][n] / M[i][i] for i in range(n)]


def fit_background(tile: Image.Image, inner_mask: Image.Image):
    """Least-squares fit of each channel as a smooth function of (u, v)."""
    px, mk = tile.load(), inner_mask.load()
    W, H = tile.size
    samples = []
    for y in range(0, H, 5):
        for x in range(0, W, 5):
            r, g, b = px[x, y]
            if mk[x, y] == 255 and r < 14 and g < 95 and 80 < b < 180 and g < 0.62 * b:
                samples.append((_features(x / W, y / H), (r, g, b)))

    coeffs = None
    for _ in range(3):  # refit, dropping outliers (anti-aliased glyph edges)
        coeffs = []
        for ch in range(3):
            A = [[0.0] * 5 for _ in range(5)]
            b = [0.0] * 5
            for f, c in samples:
                for i in range(5):
                    b[i] += f[i] * c[ch]
                    for j in range(5):
                        A[i][j] += f[i] * f[j]
            coeffs.append(_solve(A, b))
        samples = [
            (f, c) for f, c in samples
            if all(abs(sum(k * fi for k, fi in zip(coeffs[ch], f)) - c[ch]) < 6 for ch in range(3))
        ]
    return coeffs


def bg_color(coeffs, u, v):
    f = _features(u, v)
    return tuple(max(0, min(255, round(sum(k * fi for k, fi in zip(cf, f))))) for cf in coeffs)


def render_background(coeffs, size: int, u0=0.0, u1=1.0) -> Image.Image:
    """Background over tile coordinates [u0, u1] (values outside 0..1 extrapolate)."""
    img = Image.new("RGB", (size, size))
    px = img.load()
    span = u1 - u0
    for y in range(size):
        v = u0 + span * (y + 0.5) / size
        row = [bg_color(coeffs, u0 + span * (x + 0.5) / size, v) for x in range(size)]
        for x, c in enumerate(row):
            px[x, y] = c
    return img


# --- 3. Separate the artwork from the background ---------------------------

def extract_artwork(tile: Image.Image, inner_mask: Image.Image, coeffs) -> Image.Image:
    """Un-blends each pixel against the fitted background: p = a*F + (1-a)*B."""
    W, H = tile.size
    src, mk = tile.load(), inner_mask.load()
    out = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    dst = out.load()
    for y in range(H):
        v = (y + 0.5) / H
        for x in range(W):
            if mk[x, y] != 255:
                continue
            B = bg_color(coeffs, (x + 0.5) / W, v)
            p = src[x, y]
            # The artwork is white or light cyan; both sit far above the dark blue
            # in at least one channel, so the largest normalised lift is the alpha.
            a = max((p[c] - B[c]) / max(1, 255 - B[c]) for c in range(3))
            a = (a - 0.04) / 0.92  # drop the background's noise floor
            if a <= 0:
                continue
            a = min(1.0, a)
            F = tuple(max(0, min(255, round((p[c] - (1 - a) * B[c]) / a))) for c in range(3))
            dst[x, y] = (*F, round(a * 255))
    return out


# --- 4. Compose platform images ---------------------------------------------

def compose(bg: Image.Image, art: Image.Image, size: int, art_scale=1.0) -> Image.Image:
    """Artwork (full tile = art_scale of the canvas) centred over bg, resized to size."""
    canvas = bg.resize((MASTER, MASTER), Image.LANCZOS).convert("RGBA")
    a = art.resize((round(MASTER * art_scale),) * 2, Image.LANCZOS)
    off = (MASTER - a.width) // 2
    canvas.alpha_composite(a, (off, off))
    return canvas.resize((size, size), Image.LANCZOS)


def max_art_radius(art: Image.Image) -> float:
    """Farthest visible artwork pixel from the centre, as a fraction of the tile."""
    alpha = art.getchannel("A").load()
    W, H = art.size
    best = 0.0
    for y in range(0, H, 2):
        for x in range(0, W, 2):
            if alpha[x, y] > 64:
                best = max(best, ((x / W - 0.5) ** 2 + (y / H - 0.5) ** 2) ** 0.5)
    return best


def _content_rows(art: Image.Image):
    alpha = art.getchannel("A")
    return [alpha.crop((0, y, art.width, y + 1)).getbbox() is not None for y in range(art.height)]


def drop_wordmark(art: Image.Image) -> Image.Image:
    """Erases the "Stride" text: the lowest band of artwork below an empty gap."""
    rows = _content_rows(art)
    bottom = max(y for y, r in enumerate(rows) if r)
    y = bottom
    while rows[y]:  # walk up through the text block...
        y -= 1
    gap_end = y
    while not rows[y]:  # ...and through the empty gap above it
        y -= 1
    if gap_end - y < 8:
        raise SystemExit("Could not find the gap between the runner and the text.")
    out = art.copy()
    out.paste((0, 0, 0, 0), (0, y + 1, art.width, art.height))
    return out


def reframe(art: Image.Image, width_fraction: float) -> Image.Image:
    """Centres the artwork's bounding box and scales it to the given width."""
    # Drop the faint (<10% alpha) top highlight of the source tile: it belongs
    # to the background, and would both skew the centring and end up misplaced.
    art = art.copy()
    art.putalpha(art.getchannel("A").point(lambda a: 0 if a < 26 else a))
    box = art.getchannel("A").getbbox()
    glyph = art.crop(box)
    k = width_fraction * MASTER / glyph.width
    glyph = glyph.resize((round(glyph.width * k), round(glyph.height * k)), Image.LANCZOS)
    out = Image.new("RGBA", (MASTER, MASTER), (0, 0, 0, 0))
    out.alpha_composite(glyph, ((MASTER - glyph.width) // 2, (MASTER - glyph.height) // 2))
    return out


def main():
    src = Image.open(SOURCE).convert("RGB")
    box, radius = find_tile(src)
    tile = src.crop(box)
    print(f"tile {box}, corner radius ~{radius:.0f}px")

    # Keep well inside the rounded edge so its white anti-aliasing is ignored.
    e = 10
    inner = Image.new("L", tile.size, 0)
    ImageDraw.Draw(inner).rounded_rectangle(
        [e, e, tile.width - 1 - e, tile.height - 1 - e], radius=radius - e, fill=255)

    coeffs = fit_background(tile, inner)
    art = extract_artwork(tile, inner, coeffs).resize((MASTER, MASTER), Image.LANCZOS)
    if not INCLUDE_WORDMARK:
        art = reframe(drop_wordmark(art), ARTWORK_WIDTH)
    bg = render_background(coeffs, MASTER)
    art.save(ROOT / "tool/app_icon_artwork.png")
    compose(bg, art, MASTER).convert("RGB").save(ROOT / "tool/app_icon_1024.png")

    # iOS: full-bleed, opaque.
    ios_dir = ROOT / "ios/Runner/Assets.xcassets/AppIcon.appiconset"
    for e in json.loads((ios_dir / "Contents.json").read_text())["images"]:
        px = round(float(e["size"].split("x")[0]) * int(e["scale"].rstrip("x")))
        compose(bg, art, px).convert("RGB").save(ios_dir / e["filename"])

    # Android adaptive: 108dp layers; the launcher shows the middle 72dp and
    # only guarantees a 66dp circle. Map the tile to the visible 72dp, then
    # shrink if any artwork would fall outside the safe circle.
    scale = 72 / 108
    reach = max_art_radius(art) * scale  # fraction of the 108dp canvas
    safe = 33 / 108
    if reach > safe:
        scale *= safe / reach
    print(f"android artwork scale {scale:.3f} (tile spans {scale * 108:.1f}dp)")
    pad = (1 - scale) / 2 / scale  # how far beyond the tile the 108dp canvas reaches
    android_bg = render_background(coeffs, 512, -pad, 1 + pad)

    blank = Image.new("RGBA", (MASTER, MASTER), (0, 0, 0, 0))
    res = ROOT / "android/app/src/main/res"
    for name, f in {"mdpi": 1, "hdpi": 1.5, "xhdpi": 2, "xxhdpi": 3, "xxxhdpi": 4}.items():
        d = res / f"mipmap-{name}"
        d.mkdir(exist_ok=True)
        layer = round(108 * f)
        compose(blank, art, layer, scale).save(d / "ic_launcher_foreground.png")
        android_bg.resize((layer, layer), Image.LANCZOS).save(d / "ic_launcher_background.png")
        mono = compose(blank, art, layer, scale)
        white = Image.new("RGBA", mono.size, (255, 255, 255, 255))
        white.putalpha(mono.getchannel("A"))
        white.save(d / "ic_launcher_monochrome.png")

        # Legacy (pre-Android 8) icon: the tile itself with rounded corners.
        legacy = round(48 * f)
        S = legacy * 4
        m = round(S * 0.04)
        t = compose(bg, art, S - 2 * m)
        mask = Image.new("L", t.size, 0)
        ImageDraw.Draw(mask).rounded_rectangle([0, 0, t.width - 1, t.height - 1],
                                               radius=t.width * 0.22, fill=255)
        out = Image.new("RGBA", (S, S), (0, 0, 0, 0))
        out.paste(t, (m, m), mask)
        out.resize((legacy, legacy), Image.LANCZOS).save(d / "ic_launcher.png")

    (res / "mipmap-anydpi-v26").mkdir(exist_ok=True)
    (res / "mipmap-anydpi-v26/ic_launcher.xml").write_text(
        '<?xml version="1.0" encoding="utf-8"?>\n'
        '<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">\n'
        '    <background android:drawable="@mipmap/ic_launcher_background"/>\n'
        '    <foreground android:drawable="@mipmap/ic_launcher_foreground"/>\n'
        '    <monochrome android:drawable="@mipmap/ic_launcher_monochrome"/>\n'
        "</adaptive-icon>\n"
    )
    print("Icons written.")


if __name__ == "__main__":
    main()
