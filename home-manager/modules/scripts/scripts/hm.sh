#!/usr/bin/env bash
cmd="$1"
case $cmd in
update)
	nix flake update --commit-lock-file "/home/$USER/nixconf" --extra-experimental-features "nix-command flakes"
	home-manager switch --flake "/home/$USER/nixconf#$NIX_HOST" --extra-experimental-features "nix-command flakes"
	;;

switch)
	home-manager switch --flake "/home/$USER/nixconf#$NIX_HOST" --extra-experimental-features "nix-command flakes"
	;;

build)
	home-manager build --flake "/home/$USER/nixconf#$NIX_HOST" --extra-experimental-features "nix-command flakes"
	;;

clean)
	nix-collect-garbage -d
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
