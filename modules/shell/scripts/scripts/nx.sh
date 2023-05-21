#!/usr/bin/env bash

function nx() {
	function is_nixos() {
		command -v nixos-rebuild >/dev/null
	}

	function has_home-manager() {
		command -v home-manager >/dev/null
	}

	function nix-exec() {
		cmd="$*"
		is_nixos && sudo nixos-rebuild "$cmd" --flake "/home/$USER/nixconf#$NIX_HOST" 
		has_home-manager && home-manager "$cmd" --flake "/home/$USER/nixconf#$NIX_HOST" --extra-experimental-features "nix-command flakes"
	}

	cmd="$1"
	case $cmd in
	update)
		nix-exec switch
		;;

	upgrade)
		nix flake update --commit-lock-file "/home/$USER/nixconf" --extra-experimental-features "nix-command flakes"
		nix-exec switch
		;;

	boot)
		is_nixos && nix-exec boot
		;;

	build)
		nix-exec build
		;;

	clean)
		is_nixos && sudo nix-collect-garbage -d
		has_home-manager && nix-collect-garbage -d
		;;

	index)
		nix-index
		;;

	info)
		nix-info -m
		;;

	locate)
		nix-locate
		;;

	edit)
		fd . "/home/$USER/nixconf" | fzf | xargs -L1 "$EDITOR"
		;;

	release-upgrade)
		[ $# -ne 2 ] && echo "Usage: nx release-upgrade <release>. Example: nx release-upgrade 22.11" && exit 1
		local release=$2

		sudo nix-channel --remove nixpkgs
		sudo nix-channel --remove nixos
		sudo nix-channel --remove home-manager

		sudo nix-channel --add "https://nixos.org/channels/nixos-${release}" nixos
		sudo nix-channel --update

		nix-channel --remove home-manager
		nix-channel --add "https://github.com/nix-community/home-manager/archive/release-${release}.tar.gz" home-manager
		nix-channel --update

		;;
	*)
		echo "$cmd is not a known command"
		;;
	esac
}

nx "$@"
