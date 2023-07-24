#!/usr/bin/env bash
USER="klabun"
HOSTNAME="cvm-$HOSTNAME_SUFFIX"
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
	sudo --user "$USER" --login "$@"
}

function setup_user() {
	apt install -y zsh
	chsh "$USER" -s "$SHELL"
}

function setup_hostname() {
	announce "Setting up hostname"
	hostname "$HOSTNAME"
	echo "$HOSTNAME" >/etc/hostname
	echo "127.0.0.1 $HOSTNAME" >>/etc/hosts
}

function fix_permissions() {
  chmod 755 -R /opt/indeed/
}

function setup_timezone() {
	ln -snf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
}

function system_update() {
	announce "Updating system"
	apt update && apt upgrade -y
}

function setup_system_packages() {
	announce "Installing System Packages"
	apt install -y git zsh fzf jq neovim
}

function setup_cargo() {
	announce "Installing Cargo Packages"
	as_user curl https://sh.rustup.rs -sSf |
		as_user sh -s -- -y

	as_user cargo install --locked starship
	as_user cargo install --locked exa
	as_user cargo install --locked bat
	as_user cargo install --locked ripgrep
}

function setup_zsh() {
  announce "Setting up ZSH"
  grep -q 'source $HOME/config/zshrc' ~/.zshrc || echo 'source $HOME/config/zshrc' >> ~/.zshrc
}

function setup_git() {
  announce "Setting up Git"
  grep -q '/home/klabun/config/git/config' ~/.gitconfig || echo <<EOF >> ~/.gitconfig
[include]
    path = /home/klabun/config/git/config
EOF
}

function setup_nix() {
  announce "Setting up Nix"
  sh <(curl -L https://nixos.org/nix/install) --daemon

  nix-env -i lorri direnv
}

fix_permissions
system_update
setup_hostname
setup_timezone
setup_user
setup_system_packages
setup_cargo
setup_zsh
setup_git
setup_nix
