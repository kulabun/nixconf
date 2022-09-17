#!/usr/bin/env bash

LOCAL_ROOT="$HOME/indeed"
REMOTE_HOST="$USER.cvm.indeed.net"
REMOTE_USER="$USER"
REMOTE_ROOT="/home/$USER/indeed"

function cvm() (
	function cvm_sync() {
		REMOTE_PATH=$(echo "$PWD" | sed "s#$LOCAL_ROOT#$REMOTE_ROOT#g")
		rsync -aP --delete --exclude build/ --exclude node_modules/ --exclude .gradle/ "$PWD/." $USER@$REMOTE_HOST:$REMOTE_PATH
	}

	function cvm_connect() {
		ssh "$REMOTE_HOST"
	}

	function cvm_exec() {
		REMOTE_PATH=$(pwd | sed "s#$LOCAL_ROOT#$REMOTE_ROOT#g")
		# Run sync only if we are in a subfolder of $REMOTE_ROOT.
		[ $? -eq 0 ] && [ "$REMOTE_PATH" != "$REMOTE_ROOT" ] && cvm_sync
		ssh ${REMOTE_USER}@${REMOTE_HOST} "cd $REMOTE_PATH && echo $* | bash --login"
	}

	[ $# -eq 0 ] && cvm_connect
	[ $# -gt 0 ] && cvm_exec "$@"
)

cvm "$@"
