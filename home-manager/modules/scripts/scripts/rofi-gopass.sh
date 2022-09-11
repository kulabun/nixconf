#!/usr/bin/env bash
gopass ls --flat | rofi -dmenu -p pass | xargs --no-run-if-empty gopass --clip
