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
  --env INDEED_TEAMS="resume" \
  --env INDEED_OFFICE="seaoff" \
  --env INSTALL_SOURCEGRAPH_CLI="" \
  --env INSTALL_JETBRAINS_TOOLBOX="" \
  --env ANSIBLE_SKIP_TAGS="wildcard_dns" \
  -- \
  sudo --login --user $USER $*
  # /usr/bin/zsh --login -c "$*"
