#!/usr/bin/env python3
"""
Generate demo GIF for session plugin.
Uses the slack-gif-creator skill utilities.
"""

import sys
sys.path.insert(0, '/Users/huy/CODES/nqh/.claude/skills/slack-gif-creator')

from PIL import Image, ImageDraw, ImageFont
from core.gif_builder import GIFBuilder

# Dimensions for GitHub README
WIDTH = 560
HEIGHT = 280
FPS = 15

# Timeline (frames)
TITLE_CARD_END = 30          # Hold title card (~2s)

# Command 1: restart
RESTART_TYPE_END = 42        # Typing done
RESTART_BANNER_START = 44
RESTART_HOLD_END = 70

# Command 2: fork
FORK_TYPE_END = 82
FORK_BANNER_START = 84
FORK_HOLD_END = 110

# Command 3: spawn
SPAWN_TYPE_END = 122
SPAWN_BANNER_START = 124
SPAWN_HOLD_END = 150

# Command 4: id
ID_TYPE_END = 158
ID_BANNER_START = 160
ID_HOLD_END = 180

TOTAL_FRAMES = ID_HOLD_END

# Colors (terminal-style)
BG_COLOR = (24, 24, 28)           # Dark terminal bg
BANNER_BG = (32, 32, 36)          # Slightly lighter
WHITE = (230, 230, 230)           # Not pure white
DIM_GRAY = (70, 70, 70)           # Very dim
FRAME_GRAY = (60, 60, 65)         # Double-line frame
PROMPT_GRAY = (140, 140, 140)

# Command colors (vibrant, saturated)
GREEN = (0, 255, 100)             # Pure bright green / restart
ORANGE = (255, 160, 80)           # Bright orange / fork
PURPLE = (200, 120, 255)          # Vibrant purple / spawn
BLUE = (0, 160, 255)              # Pure bright blue / id

# Load fonts
try:
    FONT = ImageFont.truetype("/System/Library/Fonts/SFMono-Regular.otf", 14)
    FONT_LARGE = ImageFont.truetype("/System/Library/Fonts/SFMono-Bold.otf", 18)
    FONT_SMALL = ImageFont.truetype("/System/Library/Fonts/SFMono-Regular.otf", 12)
except:
    FONT = ImageFont.truetype("/System/Library/Fonts/Menlo.ttc", 14)
    FONT_LARGE = ImageFont.truetype("/System/Library/Fonts/Menlo.ttc", 18)
    FONT_SMALL = ImageFont.truetype("/System/Library/Fonts/Menlo.ttc", 12)


def draw_double_frame(draw, x1, y1, x2, y2, color):
    """Draw double-line frame."""
    draw.rectangle([x1, y1, x2, y2], outline=color, width=2)
    draw.rectangle([x1+4, y1+4, x2-4, y2-4], outline=color, width=1)


def draw_title_card(draw):
    """Draw the title card frame."""
    draw_double_frame(draw, 30, 20, WIDTH-30, HEIGHT-20, FRAME_GRAY)

    # /session:* in orange, centered
    text = "/session:*"
    bbox = draw.textbbox((0, 0), text, font=FONT_LARGE)
    text_width = bbox[2] - bbox[0]
    x = (WIDTH - text_width) // 2
    y = HEIGHT // 2 - 20
    draw.text((x, y), text, fill=ORANGE, font=FONT_LARGE)

    # Hint text, right-aligned, dim
    hint = "Right-click → Play Animation"
    bbox = draw.textbbox((0, 0), hint, font=FONT_SMALL)
    hint_width = bbox[2] - bbox[0]
    x = WIDTH - 50 - hint_width
    y = HEIGHT - 55
    draw.text((x, y), hint, fill=DIM_GRAY, font=FONT_SMALL)


def draw_command(draw, cmd_name, progress, y=25):
    """
    Draw command with special typing:
    1. `/` appears first
    2. `session:` appears all at once
    3. command name typed char by char
    """
    prefix = "/session:"
    full_cmd = prefix + cmd_name

    # Calculate what's visible based on progress
    # Progress 0-0.1: just /
    # Progress 0.1-0.2: /session:
    # Progress 0.2-1.0: /session: + typing cmd_name

    if progress < 0.1:
        visible = "/"
    elif progress < 0.2:
        visible = prefix
    else:
        # Type the command name
        cmd_progress = (progress - 0.2) / 0.8
        chars = int(cmd_progress * len(cmd_name))
        visible = prefix + cmd_name[:chars]

    # Draw prompt
    prompt = "> "
    draw.text((30, y), prompt, fill=PROMPT_GRAY, font=FONT)
    prompt_w = draw.textlength(prompt, font=FONT)

    # Draw command
    draw.text((30 + prompt_w, y), visible, fill=WHITE, font=FONT)

    # Blinking cursor
    if progress < 1.0:
        cursor_x = 30 + prompt_w + draw.textlength(visible, font=FONT)
        draw.rectangle([cursor_x, y + 2, cursor_x + 8, y + 14], fill=WHITE)


def draw_banner(draw, title, color, messages=None, compact=False, progress=1.0):
    """Draw a command banner with fade-in. messages can be a list of strings."""
    if progress <= 0:
        return

    alpha = min(1.0, progress * 3)

    # Colors with alpha
    border_c = tuple(int(c * alpha) for c in color)
    title_c = tuple(int(c * alpha) for c in color)

    banner_width = 420
    banner_x = (WIDTH - banner_width) // 2
    border = 6

    if compact:
        banner_height = 50
        banner_y = 80

        # Outer border
        draw.rectangle(
            [banner_x, banner_y, banner_x + banner_width, banner_y + banner_height],
            fill=border_c
        )
        # Inner fill
        draw.rectangle(
            [banner_x + border, banner_y + border,
             banner_x + banner_width - border, banner_y + banner_height - border],
            fill=BANNER_BG
        )

        # Title centered
        bbox = draw.textbbox((0, 0), title, font=FONT)
        text_width = bbox[2] - bbox[0]
        x = (WIDTH - text_width) // 2
        y = banner_y + 16
        draw.text((x, y), title, fill=title_c, font=FONT)
    else:
        banner_height = 130
        banner_y = 55

        # Outer border
        draw.rectangle(
            [banner_x, banner_y, banner_x + banner_width, banner_y + banner_height],
            fill=border_c
        )
        # Inner fill
        draw.rectangle(
            [banner_x + border, banner_y + border,
             banner_x + banner_width - border, banner_y + banner_height - border],
            fill=BANNER_BG
        )

        # Title centered
        bbox = draw.textbbox((0, 0), title, font=FONT_LARGE)
        text_width = bbox[2] - bbox[0]
        x = (WIDTH - text_width) // 2
        y = banner_y + 25
        draw.text((x, y), title, fill=title_c, font=FONT_LARGE)

        # Messages below title (fade in sequentially)
        # First message = prompt (prominent), second = status (dim, spaced)
        if messages and progress > 0.3:
            if isinstance(messages, str):
                messages = [messages]

            line_y = banner_y + 60
            for i, msg in enumerate(messages):
                msg_alpha = min(1.0, (progress - 0.3 - i * 0.15) * 3)
                if msg_alpha > 0:
                    if i == 0:
                        # First line: prompt (white)
                        msg_c = tuple(int(c * msg_alpha) for c in WHITE)
                    else:
                        # Second line: status (dim gray, more spacing)
                        line_y += 8  # Extra spacing before dim line
                        msg_c = tuple(int(c * msg_alpha) for c in DIM_GRAY)

                    bbox = draw.textbbox((0, 0), msg, font=FONT_SMALL)
                    text_width = bbox[2] - bbox[0]
                    x = (WIDTH - text_width) // 2
                    draw.text((x, line_y), msg, fill=msg_c, font=FONT_SMALL)
                line_y += 18


def create_frame(frame_num):
    """Create a single frame based on timeline."""
    frame = Image.new('RGB', (WIDTH, HEIGHT), BG_COLOR)
    draw = ImageDraw.Draw(frame)

    # Title card
    if frame_num < TITLE_CARD_END:
        draw_title_card(draw)
        return frame

    # Command 1: restart
    if frame_num < RESTART_HOLD_END:
        type_frames = RESTART_TYPE_END - TITLE_CARD_END
        local_frame = frame_num - TITLE_CARD_END
        type_progress = min(1.0, local_frame / type_frames)
        draw_command(draw, "restart", type_progress)

        if frame_num >= RESTART_BANNER_START:
            banner_progress = (frame_num - RESTART_BANNER_START) / 12
            draw_banner(draw, "✓  SESSION RESUMED", GREEN,
                       "Continuing in new tab", progress=banner_progress)
        return frame

    # Command 2: fork
    if frame_num < FORK_HOLD_END:
        type_frames = FORK_TYPE_END - RESTART_HOLD_END
        local_frame = frame_num - RESTART_HOLD_END
        type_progress = min(1.0, local_frame / type_frames)
        draw_command(draw, "fork", type_progress)

        if frame_num >= FORK_BANNER_START:
            banner_progress = (frame_num - FORK_BANNER_START) / 12
            draw_banner(draw, "⑂  SESSION FORKED", ORANGE,
                       ["Prompt: Fix the auth bug we discussed...",
                        "New branch opened in new tab"],
                       progress=banner_progress)
        return frame

    # Command 3: spawn
    if frame_num < SPAWN_HOLD_END:
        type_frames = SPAWN_TYPE_END - FORK_HOLD_END
        local_frame = frame_num - FORK_HOLD_END
        type_progress = min(1.0, local_frame / type_frames)
        draw_command(draw, "spawn", type_progress)

        if frame_num >= SPAWN_BANNER_START:
            banner_progress = (frame_num - SPAWN_BANNER_START) / 12
            draw_banner(draw, "✦  SESSION SPAWNED", PURPLE,
                       ["Prompt: Build the new API endpoint...",
                        "Fresh session opened in new tab"],
                       progress=banner_progress)
        return frame

    # Command 4: id
    if frame_num < ID_HOLD_END:
        type_frames = ID_TYPE_END - SPAWN_HOLD_END
        local_frame = frame_num - SPAWN_HOLD_END
        type_progress = min(1.0, local_frame / type_frames)
        draw_command(draw, "id", type_progress)

        if frame_num >= ID_BANNER_START:
            banner_progress = (frame_num - ID_BANNER_START) / 12
            draw_banner(draw, "SESSION ID: 01JGK7XYZABC123", BLUE,
                       None, compact=True, progress=banner_progress)
        return frame

    return frame


def main():
    import imageio.v3 as imageio
    import numpy as np

    builder = GIFBuilder(width=WIDTH, height=HEIGHT, fps=FPS)

    print(f"Creating {TOTAL_FRAMES} frames...")

    for i in range(TOTAL_FRAMES):
        frame = create_frame(i)
        builder.add_frame(frame)

    # Use per-frame quantization (not global palette) to preserve green/blue
    print("Optimizing with per-frame palette...")
    optimized_frames = builder.optimize_colors(num_colors=64, use_global_palette=False)

    output_path = '/Users/huy/CODES/nqh-claude-plugins/plugins/session/assets/demo.gif'
    frame_duration = 1000 / FPS

    imageio.imwrite(
        output_path,
        optimized_frames,
        duration=frame_duration,
        loop=0,
    )

    import os
    size_kb = os.path.getsize(output_path) / 1024
    print(f"\n✓ GIF created: {output_path}")
    print(f"  Size: {size_kb:.1f} KB")
    print(f"  Frames: {len(optimized_frames)} @ {FPS} fps")
    print(f"  Duration: {len(optimized_frames) / FPS:.1f}s")


if __name__ == "__main__":
    main()
