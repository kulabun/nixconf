#!/usr/bin/env bash
USER="klabun"
HOSTNAME="klabun"
HOME="/home/$USER"
SHELL="/usr/bin/zsh"

set -euo pipefail
IFS=$'\n\t'

function announce() {
	echo "=============================="
	echo "$1"
	echo "=============================="
}

function as_user() {
	sudo --user $USER --login $*
}

function setup_hostname() {
	announce "Setting up hostname"
	echo "$USER" >/etc/hostname
	echo "$USER 127.0.0.1" >/etc/hosts
}

function setup_user() {
	mkhomedir_helper "$USER"
	chown "$USER:$USER" "$HOME"

	usermod -d "$HOME" "$USER"

	apt install -y zsh
	chsh "$USER" -s "$SHELL"
}

function system_update() {
	announce "Updating system"
	apt update && apt upgrade -y
}

function setup_system_packages() {
	announce "Installing System Packages"
	apt install -y \
		wget curl rsync unzip\
		xwayland weston x11-apps mesa-utils \
		cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3 \
		git python3-pip zsh fzf jq

  # work around for system-setup script. this package is blocked by cloudflare when on warp
  apt-get install -y libwebkit2gtk-4.0.37 llvm-14
}

function setup_cargo() {
	announce "Installing Cargo Packages"
	as_user curl https://sh.rustup.rs -sSf \
	  | as_user sh -s -- -y

	as_user cargo install --locked starship
	as_user cargo install --locked zellij
	as_user cargo install --locked alacritty
	as_user cargo install --locked ripgrep
}

function setup_snap() {
	announce "Installing Snap Packages"
	snap install intellij-idea-community --classic
}

function install_cloudflare_warp() {
	announce "Installing Cloudflare Warp"
	curl https://pkg.cloudflareclient.com/pubkey.gpg |
		gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg
	echo "deb [arch=amd64 signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" |
		tee /etc/apt/sources.list.d/cloudflare-client.list
	apt update
	apt install -y cloudflare-warp
}

function install_chrome() {
	announce "Installing Google Chrome"
	wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
	echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >>/etc/apt/sources.list.d/google-chrome.list
	apt update
	apt install -y google-chrome-stable
}

system_update
setup_hostname
setup_user
setup_system_packages
setup_snap
setup_cargo
install_chrome
install_cloudflare_warp
