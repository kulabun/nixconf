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

	locate)
		nix-locate
		;;

	edit)
		fd . "/home/$USER/nixconf" | fzf | xargs -L1 "$EDITOR"
		;;

	*)
		echo "$cmd is not a known command"
		;;
	esac
}

nx "$@"
