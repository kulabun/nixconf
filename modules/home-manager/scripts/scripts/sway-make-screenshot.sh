#!/usr/bin/env bash
SCREENSHOTS_DIR="$HOME/screenshots"
[ ! -d "$SCREENSHOTS_DIR" ] && mkdir -p "$SCREENSHOTS_DIR"

SCREENSHOT_PATH="$SCREENSHOTS_DIR/screenshot-$(date --iso-8601=seconds).png"
grim -g "$(slurp)" "$SCREENSHOT_PATH" && feh "$SCREENSHOT_PATH"
