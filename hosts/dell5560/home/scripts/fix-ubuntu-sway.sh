#!/usr/bin/env bash
sudo sed -i "s,Exec=.*,Exec=zsh -l -c 'systemd-cat --identifier=sway sway',g" /usr/share/wayland-sessions/sway.desktop
sudo sed -i 's,Exec=.*,Exec=/home/klabun/bin/mock %U,g' /usr/share/applications/Zoom.desktop
sudo sed -i 's,Exec=.*,Exec=/usr/bin/slack --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-webrtc-pipewire-capturer %U,g' /usr/share/applications/slack.desktop

