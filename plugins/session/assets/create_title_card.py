#!/usr/bin/env python3
"""Generate title card GIF for session plugin README."""

import sys
sys.path.insert(0, '/Users/huy/CODES/nqh/.claude/skills/slack-gif-creator')

from PIL import Image, ImageDraw, ImageFont
from core.gif_builder import GIFBuilder

# Dimensions for GitHub README
WIDTH = 560
HEIGHT = 280

# Colors
BG_COLOR = (24, 24, 28)
WINDOW_BORDER = (80, 80, 85)
GREEN = (135, 175, 95)
ORANGE = (215, 135, 95)
PURPLE = (175, 135, 195)
BLUE = (95, 175, 215)
WHITE = (230, 230, 230)
HINT_GRAY = (70, 70, 70)
TRAFFIC_LIGHT_BG = (60, 60, 65)

# Fonts
try:
    FONT = ImageFont.truetype("/System/Library/Fonts/SFMono-Regular.otf", 14)
    FONT_BOLD = ImageFont.truetype("/System/Library/Fonts/SFMono-Bold.otf", 14)
    FONT_LARGE = ImageFont.truetype("/System/Library/Fonts/SFMono-Bold.otf", 32)
    FONT_SMALL = ImageFont.truetype("/System/Library/Fonts/SFMono-Regular.otf", 11)
except:
    FONT = ImageFont.truetype("/System/Library/Fonts/Menlo.ttc", 14)
    FONT_BOLD = FONT
    FONT_LARGE = ImageFont.truetype("/System/Library/Fonts/Menlo.ttc", 32)
    FONT_SMALL = ImageFont.truetype("/System/Library/Fonts/Menlo.ttc", 11)

def draw_traffic_lights(draw, x, y):
    """Draw Mac-style traffic light buttons."""
    radius = 5
    spacing = 16
    for i, color in enumerate([(255, 95, 86), (255, 189, 46), (39, 201, 63)]):
        cx = x + i * spacing
        draw.ellipse([cx - radius, y - radius, cx + radius, y + radius], fill=color)

def draw_badge(draw, x, y, text, color):
    """Draw a colored badge with text."""
    # Measure text
    bbox = draw.textbbox((0, 0), text, font=FONT_BOLD)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]

    # Badge padding
    pad_x = 8
    pad_y = 4
    badge_width = text_width + pad_x * 2
    badge_height = text_height + pad_y * 2

    # Draw rounded rectangle (approximated with rectangle)
    draw.rectangle(
        [x, y, x + badge_width, y + badge_height],
        fill=color,
        outline=None
    )

    # Draw text
    draw.text((x + pad_x, y + pad_y - 2), text, fill=(20, 20, 20), font=FONT_BOLD)

    return badge_width

def draw_window(draw, x, y, width, height, title, badge_color, closed=False):
    """Draw a terminal window frame."""
    # Window border
    draw.rectangle([x, y, x + width, y + height if closed else HEIGHT + 50],
                   outline=WINDOW_BORDER, width=2)

    # Close bottom if needed
    if closed:
        pass  # Already closed by rectangle
    else:
        # Open bottom - redraw without bottom edge
        draw.line([(x, y), (x + width, y)], fill=WINDOW_BORDER, width=2)  # top
        draw.line([(x, y), (x, HEIGHT + 50)], fill=WINDOW_BORDER, width=2)  # left
        draw.line([(x + width, y), (x + width, HEIGHT + 50)], fill=WINDOW_BORDER, width=2)  # right

    # Traffic lights
    draw_traffic_lights(draw, x + 20, y + 18)

    # Badge with command name
    badge_x = x + 70
    badge_y = y + 8
    draw_badge(draw, badge_x, badge_y, title, badge_color)

def create_title_card():
    """Create the title card frame."""
    frame = Image.new('RGB', (WIDTH, HEIGHT), BG_COLOR)
    draw = ImageDraw.Draw(frame)

    # Window specs: (x_offset, y_offset, width, title, color, closed)
    # Keep windows within frame (WIDTH = 560, leave 20px margin on right)
    windows = [
        (20, 20, 420, "/restart", GREEN, False),
        (50, 55, 420, "/fork", ORANGE, False),
        (80, 90, 420, "/spawn", PURPLE, False),
        (110, 125, 420, "/id", BLUE, True),
    ]

    # Draw windows back to front
    for x, y, w, title, color, closed in windows:
        # Fill window background for closed window
        if closed:
            draw.rectangle([x + 2, y + 2, x + w - 2, y + 120], fill=BG_COLOR)
        draw_window(draw, x, y, w, 120, title, color, closed)

    # "SESSION PLUGIN" text in the front window
    text = "SESSION PLUGIN"
    bbox = draw.textbbox((0, 0), text, font=FONT_LARGE)
    text_width = bbox[2] - bbox[0]

    # Center in the front (id) window
    front_window_x = 110
    front_window_width = 420
    text_x = front_window_x + (front_window_width - text_width) // 2
    text_y = 185

    draw.text((text_x, text_y), text, fill=WHITE, font=FONT_LARGE)

    # Play hint - bottom left corner
    draw.text((15, HEIGHT - 20), "right click > Play Animation", fill=HINT_GRAY, font=FONT_SMALL)

    return frame

def main():
    # Create GIF builder
    builder = GIFBuilder(width=WIDTH, height=HEIGHT, fps=10)

    # Create title card
    title_card = create_title_card()

    # Hold title card for 30 frames (3 seconds at 10fps)
    for _ in range(30):
        builder.add_frame(title_card)

    # Save
    output_path = '/Users/huy/CODES/nqh-claude-plugins/plugins/session/assets/title_card.gif'
    builder.save(output_path, num_colors=64)
    print(f"Saved to {output_path}")

    # Also save as PNG for preview
    png_path = '/Users/huy/CODES/nqh-claude-plugins/plugins/session/assets/title_card.png'
    title_card.save(png_path)
    print(f"PNG preview saved to {png_path}")

if __name__ == "__main__":
    main()
