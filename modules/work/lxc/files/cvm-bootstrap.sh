#!/usr/bin/env bash
USER="klabun"
HOSTNAME="cvm"
HOME="/home/$USER"
SHELL="/usr/bin/zsh"

set -euo pipefail
IFS=$'\n\t'

function announce() {
	echo "=============================="
	echo "$1"
	echo "=============================="
}

function setup_hostname() {
	announce "Setting up hostname"
	echo "$HOSTNAME" | sudo tee /etc/hostname > /dev/null
	echo "127.0.0.1 $HOSTNAME" | sudo tee /etc/hosts > /dev/null
}

function setup_user() {
	sudo apt install -y zsh
	sudo chsh "$USER" -s "$SHELL"
}

function setup_timezone() {
	sudo ln -snf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
}

function system_update() {
	announce "Updating system"
	sudo apt update && sudo apt upgrade -y
	update-managed-repos
}

function setup_cargo() {
	announce "Installing Cargo Packages"
	curl https://sh.rustup.rs -sSf | sh -s -- -y

  source "$HOME/.cargo/env"
  cargo install --locked starship
	cargo install --locked exa
	cargo install --locked bat
	cargo install --locked ripgrep
}

function setup_bash() {
	announce "Setting up Bash"
	grep -q '# Default Bash Config' ~/.profile || cat <<EOF >>~/.profile
# Default Bash Config
# if running bash 
if [ -n "\$BASH_VERSION" ]; then 
  # include .bashrc if it exists 
  if [ -f "\$HOME/.bashrc" ]; then 
    . "\$HOME/.bashrc" 
  fi 
fi

# set PATH so it includes user's private bin if it exists
if [ -d "\$HOME/bin" ] ; then
  PATH="\$HOME/bin:\$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "\$HOME/.local/bin" ] ; then
  PATH="\$HOME/.local/bin:\$PATH"
fi
EOF
}

function install_mongodb_cli() {
  announce "Installing MongoDB CLI"
  wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -
  echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list
  sudo apt-get update
  sudo apt-get install -y mongocli
}

function install_sourcegraph_cli() {
  announce "Installing SourceGraph CLI"
  mkdir -p $HOME/.local/bin
  curl -L https://sourcegraph.com/.api/src-cli/src_linux_amd64 -o $HOME/.local/bin/src
  chmod +x $HOME/.local/bin/src
  echo 'export PATH='$HOME'/.local/bin:$PATH' >> $HOME/.zshrc

  read -p "SourceGraph Access Token: " SRC_ACCESS_TOKEN
  echo 'export SRC_ACCESS_TOKEN='$SRC_ACCESS_TOKEN >> $HOME/.zshrc
  echo 'export SRC_ENDPOINT=https://indeed.sourcegraph.com' >> $HOME/.zshrc
}

function install_nix() {
  announce "Installing Nix"
  sh <(curl -L https://nixos.org/nix/install) --daemon

  sudo mkdir -p /nix/var/nix/gcroots/per-user/$USER
  sudo chown klabun:klabun /nix/var/nix/gcroots/per-user/$USER

  nix-env -i lorri direnv
}

system_update
setup_bash
setup_hostname
setup_timezone
setup_user
setup_cargo
install_mongodb_cli
install_sourcegraph_cli
install_nix
