#!/usr/bin/env bash
CONTAINER=$1
shift 1

USER_ID=1000
RUNTIME="$HOME/.runtime"

lxc exec $CONTAINER \
  --user $USER_ID \
  --env XAUTHORITY=$RUNTIME/${XAUTHORITY##*/} \
  --env DISPLAY=$DISPLAY \
  --env HOME=$HOME \
  --env DBUS_SESSION_BUS_ADDRESS="unix:path=$RUNTIME/bus" \
  --env PULSE_SERVER="unix:$RUNTIME/pulse/native" \
  -- \
  sudo --login --user $USER $*
