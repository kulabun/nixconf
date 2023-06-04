# Setup Ubuntu
```
lxd-seed
lxc profile create indeed
lxc profile edit indeed < $HOME/indeed/sys/etc/lxc/indeed.yml
lxc launch ubuntu:22.04 indeed --profile indeed

# Grap some tea and wait till it get bootstrapped
lxc exec indeed -- tail -F /var/log/cloud-init-output.log
```

## Setup CloudFlare WARP
```
warp-cli teams-enroll indeed
warp-cli connect
```

## Run Indeed system management script
```
wget -N https://boxy.sandbox.indeed.net/bootstrap -O /tmp/system-setup
bash /tmp/system-setup
```

## Run GUI Applications
```
lxc-run google-chrome
lxc-run intellij-idea-community
lxc-run alacritty
```

# Update Ubuntu
```
lxc stop indeed
lxd-seed
lxc profile edit indeed < $HOME/indeed/sys/etc/lxc/indeed.yml
lxc start indeed
lxc exec indeed -- apt update && apt upgrade -y && cargo update
```
