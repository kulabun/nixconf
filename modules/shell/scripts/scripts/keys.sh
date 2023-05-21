#!/usr/bin/env bash

SECRETS_STORE="${SECRETS_STORE:-$HOME/secrets}"
AGE_SECRETS_PATH="$SECRETS_STORE/age"
SSH_SECRETS_PATH="$SECRETS_STORE/ssh"
GPG_SECRETS_PATH="$SECRETS_STORE/gpg"
DEFAULT_USER_HOST="$USER@$NIX_HOST"

function cmd_help() {
	cat <<EOF
    keys c age github
    keys c ssh --rsa github
    keys create ssh github
EOF
}

function create_age_key() {
	NAME="$1"
	KEY_FILE="$AGE_SECRETS_PATH/$NAME"
	[ -f "$KEY_FILE" ] && die "Key file already exists: $KEY_FILE"
	age-keygen | age -p >"$KEY_FILE"
}

function die() {
	echo "ERROR: $*" >&2
	exit 1
}

function create_ssh_key_rsa() {
	[ $# -ne 2 ] && die "Invalid number of arguments for create_ssh_key_rsa"
	NAME="$1"
	COMMENT="$2"
	ssh-keygen -o -t rsa -a 100 -b 8192 -f "$SSH_SECRETS_PATH/$NAME" -C "$COMMENT"
}

function create_ssh_key_ed25519() {
	[ $# -ne 2 ] && die "Invalid number of arguments for create_ssh_key_ed25519"
	NAME="$1"
	COMMENT="$2"
	ssh-keygen -o -a 250 -t ed25519 -f "$SSH_SECRETS_PATH/$NAME" -C "$COMMENT"
}

function cmd_create_ssh_key() {
	while [ $# -gt 0 ]; do
		case "$1" in
		--rsa)
			[ -n "$ALGO" ] && die "Only one algorithm can be used: --rsa or --ed25519"
			ALGO="rsa"
			shift
			;;
		--ed25519)
			[ -n "$ALGO" ] && die "Only one algorithm can be used: --rsa or --ed25519"
			ALGO="ed25519"
			shift
			;;
		--comment | -c)
			[ -n "$COMMENT" ] && die "Comment is already set"
			[ $# -lt 2 ] && die "Comment agrument is missing"
			COMMENT="$2"
			shift 2
			;;
		*)
			[ -n "$NAME" ] && die "Name is already set"
			NAME="$1"
			shift
			;;
		esac
	done
	[ -z "$ALGO" ] && ALGO="ed25519"
	[ -z "$COMMENT" ] && COMMENT="$DEFAULT_USER_HOST"
	[ -z "$NAME" ] && die "Name is not set"

	[ "$ALGO" = "ed25519" ] && create_ssh_key_ed25519 "$NAME" "$COMMENT"
	[ "$ALGO" = "rsa" ] && create_ssh_key_rsa "$NAME" "$COMMENT"
}

function cmd_create_age_key() {
	while [ $# -gt 0 ]; do
		case "$1" in
		*)
			[ -n "$NAME" ] && die "Name is already set"
			NAME="$1"
			shift
			;;
		esac
	done
	[ -z "$NAME" ] && die "Name is not set"
	create_age_key "$NAME"
}

function cmd_create() {
	case "$1" in
	age)
		shift
		cmd_create_age_key "$@"
		;;
	ssh)
		shift
		cmd_create_ssh_key "$@"
		;;
	*) ;;
	esac
}

function main() {
	case "$1" in
	create | c)
		shift
		cmd_create "$@"
		;;
	*)
		die "Unknown subcommand: $1"
		;;
	esac
}

main "$@"
