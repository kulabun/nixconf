#!/usr/bin/env bash
set -e -o pipefail

DEFAULT_LOCAL_ROOT="$HOME/indeed"
DEFAULT_REMOTE_ROOT="/home/$USER/indeed"
DEFAULT_REMOTE_USER="$USER"
DEFAULT_REMOTE_HOST="$USER.cvm.indeed.net"
CONFIG_PATH="$HOME/.cvm"

bold=$(tput bold)
normal=$(tput sgr0)

function cvm() (

	function cvm_init() {
		local changed=false
		[ -z "$LOCAL_ROOT" ] && read -r -p "${bold}Path to indeed folder on your laptop [$DEFAULT_LOCAL_ROOT]:${normal} " && changed=true
		[ -z "$LOCAL_ROOT" ] && LOCAL_ROOT=$DEFAULT_LOCAL_ROOT

		[ -z "$REMOTE_HOST" ] && read -r -p "${bold}Your cvm hostname [$DEFAULT_REMOTE_HOST]: ${normal}" && changed=true
		[ -z "$REMOTE_HOST" ] && REMOTE_HOST=$DEFAULT_REMOTE_HOST

		[ -z "$REMOTE_USER" ] && read -r -p "${bold}Your user name on $REMOTE_HOST [$DEFAULT_REMOTE_USER]: ${normal}" && changed=true
		[ -z "$REMOTE_USER" ] && REMOTE_USER=$DEFAULT_REMOTE_USER

		[ -z "$REMOTE_ROOT" ] && read -r -p "${bold}Path to indeed folder on $REMOTE_HOST [$DEFAULT_REMOTE_ROOT]: ${normal}" && changed=true
		[ -z "$REMOTE_ROOT" ] && REMOTE_ROOT=$DEFAULT_REMOTE_ROOT

		if $changed; then
			cat <<CONFIG >"$CONFIG_PATH"
LOCAL_ROOT=$LOCAL_ROOT
REMOTE_HOST=$REMOTE_HOST
REMOTE_USER=$REMOTE_USER
REMOTE_ROOT=$REMOTE_ROOT
CONFIG
		fi
	}

	function cvm_sync() {
		[[ ! "$PWD" =~ "$LOCAL_ROOT/".* ]] && return 1
		REMOTE_PATH=$(echo "$PWD" | sed "s#$LOCAL_ROOT#$REMOTE_ROOT#g")
		echo "Synchronizing $PWD to $REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH"
		rsync -aP --delete --exclude build/ --exclude node_modules/ --exclude .gradle/ "$PWD/." $USER@$REMOTE_HOST:$REMOTE_PATH
	}

	function cvm_connect() {
		ssh "$REMOTE_HOST"
	}

	function cvm_exec_in_synced_folder() {
		[[ ! "$PWD" =~ "$LOCAL_ROOT/".* ]] && return 1
		REMOTE_PATH=$(pwd | sed "s#$LOCAL_ROOT#$REMOTE_ROOT#g")

		cvm_sync

		echo "Executing '$*' at $REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH"
		ssh ${REMOTE_USER}@${REMOTE_HOST} "cd $REMOTE_PATH && echo $* | bash --login"
	}

	function cvm_exec() {
		echo "Executing '$*' at $REMOTE_USER@$REMOTE_HOST:~"
		ssh ${REMOTE_USER}@${REMOTE_HOST} "echo $* | bash --login"
	}

	[ -f "$CONFIG_PATH" ] && source "$CONFIG_PATH"
	cvm_init
	if [ $# -eq 0 ]; then
		cvm_connect
	elif [[ "$PWD" =~ "$LOCAL_ROOT/".* ]]; then
		cvm_exec_in_synced_folder "$@"
	else
		cvm_exec "$@"
	fi
)

cvm "$@"
