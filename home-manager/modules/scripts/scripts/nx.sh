#!/usr/bin/env bash

cmd="$1"
case $cmd in
update)
	nix flake update --commit-lock-file "/home/$USER/nixconf" --extra-experimental-features "nix-command flakes"
	sudo nixos-rebuild boot --flake "/home/$USER/nixconf#$NIX_HOST"
	;;

boot)
	sudo nixos-rebuild boot --flake "/home/$USER/nixconf#$NIX_HOST"
	;;

build)
	sudo nixos-rebuild build --flake "/home/$USER/nixconf#$NIX_HOST"
	;;

clean)
	sudo nix-collect-garbage -d
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
