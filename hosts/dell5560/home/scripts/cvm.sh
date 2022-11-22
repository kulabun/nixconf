#!/usr/bin/env bash
set -Eeuo pipefail

function cvm() (
	local DEFAULT_LOCAL_ROOT=${INDEED_GLOBAL_DIR:-"$HOME/indeed"}
	local DEFAULT_REMOTE_ROOT="/home/$USER/indeed"
	local DEFAULT_REMOTE_USER="$USER"
	local DEFAULT_REMOTE_HOST="$USER.cvm.indeed.net"
	local CONFIG_PATH="$HOME/.cvm"
	local BROWSE_PORT=29999

	local bold=$(tput bold)
	local normal=$(tput sgr0)
	local red=$(tput setaf 1)

	function help() {
		cat <<HELP
CloudVM Command Line Tool

DESCRIPTION
  ${bold}cvm${normal} is a command line tool for interacting with Indeed's CloudVM
  infrastructure. It allows you to easily synchronize your local files with CloudVM,
  and to run commands on CloudVM as if you run them locally. The tool is designed
  to deliver a seamless experience, so you can forget about the fact that you are
  running your code on a remote machine.

  Supported features:
    - Sync code from local filesystem to CloudVM with 'cvm -s'
    - Execute commands on the CloudVM with automatic synchronization and returns output as it appears. Example 'cvm ./gradlew build'
    - Protects you from accidential run sync outside of $HOME/indeed directory
    - Start SSH session to CloudVM with 'cvm -i'
    - Terminal signals support, so Ctrl+C is delegated to CloudVM as you would expect
    - Replace local filesystem links in your commands output with links to CloudVM and starts webserver to serve those link on 'cvm --browse'
    - Setup docker context to use CloudVM as a remote docker host with 'cvm --docker'
    - Interactive configuration on initial start and with 'cvm --configure', remembers your settings
    - Colorful error messages

USAGE:
  cvm [FLAGS] <INPUT>

FLAGS:
  -h, --help          Prints this message
  -s, --sync          Sync current project with remote host
  -i, --interactive   SSH to CloudVM
  --configure         Configure CVM tool
  --setup-docker      Create docker context for your CloudVM and set it as default
  --browse            Start http server on CVM so you can access build results(unit tests, coverage, etc) from your browser

ARGS:
  INPUT             Command to execute on remote host(Cloud VM)

EXAMPLES:
  Sync current project to CloudVM and build Gradle project
  > cvm ./gradlew build
  OR
  > cvm gradle build

  Sync current project to CloudVM and build NodeJS project
  > cvm npm build

  Sync current project to CloudVM and run python3 script with SECRET_TOKEN environment variable
  > cvm SECRET_TOKEN=qwerty python3 main.py

  Sync current project to CloudVM and run python3 script with SECRET_TOKEN environment variable
  > cvm open

  SSH to CloudVM
  > cvm -i

  Sync current project to CloudVM
  > cvm --sync

HELP
	}

	function die() {
		[[ -n "$1" ]] && echo "${red}${bold}ERROR:${normal} $1"
		exit 1
	}

	function find_project_root() {
		local current_dir="$1"
		[[ ! "$current_dir" =~ "$LOCAL_ROOT/".* ]] && die "Current directory is not inside $LOCAL_ROOT"

		while [[ "$current_dir" != "/" ]]; do
			if [[ -f "$current_dir/.git" ]]; then
				echo "$current_dir"
				return
			fi
			parent_dir="$(dirname "$current_dir")"
			if [[ "$parent_dir" == "$LOCAL_ROOT" ]]; then
				echo "$current_dir"
				return
			fi
			current_dir="$parent_dir"
		done
	}

	function cvm_init() {
		local changed=false
		[ -z "$LOCAL_ROOT" ] && read -r -p "${bold}Path to indeed folder on your laptop [$DEFAULT_LOCAL_ROOT]:${normal} " LOCAL_ROOT && changed=true
		[ -z "$LOCAL_ROOT" ] && LOCAL_ROOT=$DEFAULT_LOCAL_ROOT

		[ -z "$REMOTE_HOST" ] && read -r -p "${bold}Your cvm hostname [$DEFAULT_REMOTE_HOST]: ${normal}" REMOTE_HOST && changed=true
		[ -z "$REMOTE_HOST" ] && REMOTE_HOST=$DEFAULT_REMOTE_HOST

		[ -z "$REMOTE_USER" ] && read -r -p "${bold}Your user name on $REMOTE_HOST [$DEFAULT_REMOTE_USER]: ${normal}" REMOTE_USER && changed=true
		[ -z "$REMOTE_USER" ] && REMOTE_USER=$DEFAULT_REMOTE_USER

		[ -z "$REMOTE_ROOT" ] && read -r -p "${bold}Path to indeed folder on $REMOTE_HOST [$DEFAULT_REMOTE_ROOT]: ${normal}" REMOTE_ROOT && changed=true
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
		local LOCAL_PATH
		LOCAL_PATH=$(find_project_root "$PWD") || die "Failed to find project root! Are you in $LOCAL_ROOT subfolder?"

		local REMOTE_PATH
		REMOTE_PATH=$(to_remote_path "$LOCAL_PATH") || die "Failed to find project root on remote host"

		echo "Synchronizing $LOCAL_PATH to $REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH"
		rsync -aP --delete --exclude build/ --exclude node_modules/ --exclude .gradle/ "$LOCAL_PATH/." "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH"
	}

	function to_remote_path() {
		local LOCAL_PATH="$1"
		local REMOTE_PATH=$(echo "$LOCAL_PATH" | sed "s#$LOCAL_ROOT#$REMOTE_ROOT#g")
		[[ ! "$REMOTE_PATH" =~ "$LOCAL_ROOT/".* ]] && die "Current CVM directory is not inside $REMOTE_ROOT"
		echo "$REMOTE_PATH"
	}

	function cvm_connect() {
		local REMOTE_PATH
		REMOTE_PATH=$(to_remote_path "$PWD") || die "Failed to convert local path to remote path"
		ssh -t "${REMOTE_USER}@${REMOTE_HOST}" "cd $REMOTE_PATH; bash --login"
	}

	function cvm_exec_in_synced_folder() {
		[[ ! "$PWD" =~ "$LOCAL_ROOT/".* ]] && return 1
		REMOTE_PATH=$(pwd | sed "s,$LOCAL_ROOT,$REMOTE_ROOT,g")
		LOCAL_PROJECT_ROOT=$(find_project_root "$PWD") || die "Failed to find project root! Are you in $LOCAL_ROOT subfolder?"

		cvm_sync

		echo "Executing '$*' at $REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH"
		# ssh -t ${REMOTE_USER}@${REMOTE_HOST} "cd $REMOTE_PATH && echo \"$*\" | bash --login && exit 0 || exit 1"
		ssh -t ${REMOTE_USER}@${REMOTE_HOST} "cd $REMOTE_PATH && echo \"$* 2>&1 | sed 's,file://$LOCAL_PROJECT_ROOT,http://$REMOTE_HOST:$BROWSE_PORT,g'\" | bash --login && exit 0 || exit 1"
		echo "run 'cvm --browse' to access links from your build output"
	}

	function cvm_exec() {
		echo "Executing '$*' at $REMOTE_USER@$REMOTE_HOST:~"
		# ssh -t runs ssh in interactive mode, so we can use Ctrl+C to interrupt remote process
		ssh -t ${REMOTE_USER}@${REMOTE_HOST} "echo $* | bash --login && exit 0 || exit 1"
	}

	function setup_docker() {
		docker context list | grep -q cvm && die "Docker context already configured"
		docker context create cvm --docker "host=ssh://$REMOTE_USER@$REMOTE_HOST"
		docker context use cvm
	}

	function browse() {
		local LOCAL_PATH
		LOCAL_PATH=$(find_project_root "$PWD") || die "Failed to find project root! Are you in $LOCAL_ROOT subfolder?"

		local REMOTE_PATH
		REMOTE_PATH=$(to_remote_path "$LOCAL_PATH") || die "Failed to find project root on remote host"

		cvm_exec "command -v ufw && sudo ufw allow $BROWSE_PORT/tcp 2>&1 >/dev/null; python3 -m http.server $BROWSE_PORT -d $REMOTE_PATH"
	}

	[[ $# -eq 0 ]] && help && exit 1

	[ -f "$CONFIG_PATH" ] && source "$CONFIG_PATH"
	cvm_init

	case "$1" in
	-h | --help)
		help
		;;
	-s | --sync)
		cvm_sync
		;;
	-i | --interactive)
		cvm_connect
		;;
	--completion)
		bash_completion
		;;
	--configure)
		rm "$CONFIG_PATH"
		cvm_init
		;;
	--setup-docker)
		setup_docker
		;;
	--browse)
		browse
		;;
	*)
		if [ $# -eq 0 ]; then
			# cvm_connect
			help
		elif [[ "$PWD" =~ "$LOCAL_ROOT/".* ]]; then
			cvm_exec_in_synced_folder "$@"
		else
			cvm_exec "$@"
		fi
		;;
	esac
)

cvm "$@"
