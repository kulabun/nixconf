#!/usr/bin/env bash
scale="$1"
cat <<EOF
# Run following commands to scale X for current session
  xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE $scale
  GDK_SCALE="$scale"
EOF
