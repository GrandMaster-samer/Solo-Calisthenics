#!/usr/bin/env python3
"""Builds the app's logo files from branding/source_logo.jpg (lime logo on black).

Run:  python3 tool/make_branding.py

The logo is separated from its black background (lime ink -> transparent PNG), then:
  assets/branding/logo_full.png      full logo with text, shown inside the app
  assets/branding/logo_mark.png      figure and bar only, shown inside the app
  branding/icon.png                  launcher icon (mark on the app's black)
  branding/icon_foreground.png       Android adaptive icon foreground (safe zone)
  branding/splash.png                launch screen image
  branding/splash_android12.png      launch screen image for Android 12+
Then run the icon and splash generators (see README).

When the original high-resolution logo is available, replace source_logo.jpg (and
adjust the crop boxes below) for sharper store-size icons.
"""
import os
from PIL import Image, ImageFilter

ROOT = os.path.join(os.path.dirname(__file__), '..')
SRC = os.path.join(ROOT, 'branding', 'source_logo.jpg')
BG = (14, 15, 18)  # app background #0E0F12

# Crop boxes in the source picture (left, top, right, bottom).
FULL_BOX = (470, 150, 940, 620)  # inside the rounded square: mark + text
MARK_BOX = (540, 160, 880, 440)  # mark only, above the text


def ink(img):
    """(colour, alpha mask) of the lime ink. Alpha comes from the green channel,
    which separates the lime ink from the black background cleanly."""
    g = img.getchannel('G')
    lo, hi = 22, 235
    alpha = g.point(lambda v: 0 if v <= lo else 255 if v >= hi else int((v - lo) * 255 / (hi - lo)))
    ink_px = [img.getpixel((x, y)) for x in range(0, img.width, 2) for y in range(0, img.height, 2)
              if img.getpixel((x, y))[1] > 200]
    colour = tuple(sorted(p[i] for p in ink_px)[len(ink_px) // 2] for i in range(3)) if ink_px else (198, 255, 61)
    return colour, alpha


def clean(img_box):
    src = Image.open(SRC).convert('RGB').crop(img_box)
    colour, alpha = ink(src)
    bbox = alpha.point(lambda v: 255 if v > 40 else 0).getbbox()
    return colour, alpha.crop(bbox)


def render(colour, alpha, width):
    """Upscale the mask (not the colours) so edges stay smooth, then fill with the ink."""
    h = round(alpha.height * width / alpha.width)
    a = alpha.resize((width, h), Image.LANCZOS).filter(ImageFilter.GaussianBlur(0.6))
    out = Image.new('RGBA', a.size, colour + (0,))
    out.putalpha(a)
    return out


def place(canvas_size, art, fraction, bg=None):
    """art scaled to fit `fraction` of the canvas, centred."""
    c = Image.new('RGBA', (canvas_size, canvas_size), (bg + (255,)) if bg else (0, 0, 0, 0))
    scale = fraction * canvas_size / max(art.size)
    a = art.resize((round(art.width * scale), round(art.height * scale)), Image.LANCZOS)
    c.alpha_composite(a, ((canvas_size - a.width) // 2, (canvas_size - a.height) // 2))
    return c


def main():
    colour, full = clean(FULL_BOX)
    _, mark = clean(MARK_BOX)
    print('ink colour', colour)
    full_img = render(colour, full, 1200)
    mark_img = render(colour, mark, 1200)
    full_img.save(os.path.join(ROOT, 'assets', 'branding', 'logo_full.png'), optimize=True)
    render(colour, mark, 600).save(os.path.join(ROOT, 'assets', 'branding', 'logo_mark.png'), optimize=True)
    b = os.path.join(ROOT, 'branding')
    place(1024, mark_img, 0.70, BG).convert('RGB').save(os.path.join(b, 'icon.png'))
    # The generator insets the adaptive foreground by 16% per side, and Android then masks
    # it to a circle of ~66% of the canvas: 0.68 here keeps the whole mark inside the circle.
    place(1024, mark_img, 0.68).save(os.path.join(b, 'icon_foreground.png'))
    place(768, mark_img, 0.90).save(os.path.join(b, 'splash.png'))
    # Android 12+: 1152 canvas, visible circle 768 wide.
    place(1152, mark_img, 0.52).save(os.path.join(b, 'splash_android12.png'))
    for f in ('logo_full.png', 'logo_mark.png'):
        p = os.path.join(ROOT, 'assets', 'branding', f)
        print(f, Image.open(p).size, os.path.getsize(p) // 1024, 'KB')


if __name__ == '__main__':
    main()
