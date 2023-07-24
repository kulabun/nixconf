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
	sudo --user "$USER" --login "$@"
}

function setup_hostname() {
	announce "Setting up hostname"
	echo "$HOSTNAME" >/etc/hostname
	echo "127.0.0.1 $HOSTNAME" >>/etc/hosts
}

function setup_user() {
	mkhomedir_helper "$USER"
	chown -R "$USER:$USER" "$HOME"

	usermod -d "$HOME" "$USER"

	apt install -y zsh
	chsh "$USER" -s "$SHELL"
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
	apt install -y \
		wget curl rsync unzip xwayland weston x11-apps mesa-utils \
		cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3 \
		git python3-pip zsh fzf jq neovim

	# work around for system-setup script. this package is blocked by cloudflare when on warp
	apt-get install -y libwebkit2gtk-4.0.37 llvm-14
}

function setup_cargo() {
	announce "Installing Cargo Packages"
	as_user curl https://sh.rustup.rs -sSf |
		as_user sh -s -- -y

	as_user cargo install --locked starship
	as_user cargo install --locked exa
	as_user cargo install --locked bat
	# as_user cargo install --locked zellij
	# as_user cargo install --locked alacritty
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

function setup_zsh() {
	announce "Setting up ZSH"
	grep -q 'source $HOME/config/zshrc' ~/.zshrc || echo 'source $HOME/config/zshrc' >>~/.zshrc
}

function setup_git() {
	announce "Setting up Git"
	grep -q '/home/klabun/config/git/config' ~/.gitconfig || echo <<EOF >>~/.gitconfig
[include]
    path = /home/klabun/config/git/config
EOF
}

# function install_slack() {
#   announce "Installing Slack"
#   apt install -y libappindicator3-1 libdbusmenu-glib4 libdbusmenu-gtk3-4 libnotify4 libxss1
#
#   wget https://downloads.slack-edge.com/releases/linux/4.32.127/prod/x64/slack-desktop-4.32.127-amd64.deb
#   apt install -y ./slack-desktop-*.deb
#   rm ./slack-desktop-*.deb
# }

function setup_sudo() {
	announce "Setting up Sudo"
	cat <<EOF >>/etc/sudoers
Defaults:%sudo env_keep += "XAUTHORITY DISPLAY"
Defaults:%sudo env_keep += "DBUS_SESSION_BUS_ADDRESS PULSE_SERVER"
Defaults:%sudo env_keep += "INDEED_* ANSIBLE_* INSTALL_*"
EOF
}

system_update
setup_bash
setup_hostname
setup_timezone
setup_user
setup_system_packages
setup_snap
setup_cargo
setup_sudo
setup_zsh
setup_git
install_chrome
# install_slack
install_cloudflare_warp
