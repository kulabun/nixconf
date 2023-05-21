#!/usr/bin/env bash
set -Eeuo pipefail

function cvm() (
  # Constants
  local DEFAULT_LOCAL_ROOT=${INDEED_GLOBAL_DIR:-"$HOME/indeed"}
  local DEFAULT_REMOTE_ROOT="/home/$USER/indeed"
  local DEFAULT_REMOTE_USER="$USER"
  local DEFAULT_REMOTE_HOST="$USER.cvm.indeed.net"
  local CONFIG_PATH="$HOME/.cvm"
  local BROWSE_PORT=29999
  local VERBOSE=false

  # Formatting constants
  local bold=$(tput bold)
  local normal=$(tput sgr0)
  local red=$(tput setaf 1)

  # Print help
  function help() {
    cat <<HELP
CVM Command Line Tool

DESCRIPTION
  ${bold}cvm${normal} is a command line tool for interacting with Indeed's CloudVM.
  It allows you to easily synchronize your local files with CloudVM,
  and to run commands on CloudVM as if you run them locally. The tool is designed
  to deliver a seamless experience, so you can forget about the fact that you are
  running your code on a remote machine.

  Supported features:
    - Synchronize local project files with CloudVM
    - Run commands on CloudVM and stream output to your terminal
    - Access project build artifacts on CloudVM from your laptop
    - Delegate terminal signals to CloudVM (e.g. Ctrl+C)
    - Docker context configuration
    - Open interactive shell on CloudVM in the same directory you are at locally

USAGE:
  cvm [FLAGS] <INPUT>

FLAGS:
  -h, --help          Prints this message
  -s, --sync          Sync current project with remote host
  -i, --interactive   SSH to CloudVM and open shell in the same directory you are at locally
  --setup             Setup CVM tool and your environment
  --browse            Start http server on CVM so you can access build results(unit tests, coverage, etc) from your browser

ARGS:
  INPUT               Command to execute on remote host(Cloud VM)

EXAMPLES:
  Run hobo container on CloudVM with all the changes from local filesystem
  > cvm ./gradlew hoboRun

  Sync changes and build NodeJS project on CloudVM
  > cvm npm build

  Sync changes, set environment variable and run Python project on CloudVM
  > cvm SECRET_TOKEN=qwerty python3 main.py

  SSH to CloudVM
  > cvm -i

  Sync current project to CloudVM
  > cvm --sync

  Start http-server in currect project's root
  > cvm --browse
HELP
  }

  # Terminate shell or subshell
  function die() {
    [[ -n "$1" ]] && echo "${red}${bold}ERROR:${normal} $1"
    exit 1
  }

  # Check if setup function need to be rerun
  function setup_required {
    ! {
      [[ -v LOCAL_ROOT ]] &&
        [[ -v REMOTE_HOST ]] &&
        [[ -v REMOTE_USER ]] &&
        [[ -v REMOTE_ROOT ]]
    }
  }

  # Initial setup
  function cvm_setup() {
    unset LOCAL_ROOT REMOTE_HOST REMOTE_USER REMOTE_ROOT
    local changed=false

    [[ -v LOCAL_ROOT ]] || read -r -p "${bold}Path to indeed folder on your laptop [$DEFAULT_LOCAL_ROOT]:${normal} " LOCAL_ROOT && changed=true
    [[ -z "$LOCAL_ROOT" ]] && LOCAL_ROOT=$DEFAULT_LOCAL_ROOT

    [[ -v REMOTE_HOST ]] || read -r -p "${bold}Your cvm hostname [$DEFAULT_REMOTE_HOST]: ${normal}" REMOTE_HOST && changed=true
    [[ -z "$REMOTE_HOST" ]] && REMOTE_HOST=$DEFAULT_REMOTE_HOST

    [[ -v REMOTE_USER ]] || read -r -p "${bold}Your user name on $REMOTE_HOST [$DEFAULT_REMOTE_USER]: ${normal}" REMOTE_USER && changed=true
    [[ -z "$REMOTE_USER" ]] && REMOTE_USER=$DEFAULT_REMOTE_USER

    [[ -v REMOTE_ROOT ]] || read -r -p "${bold}Path to indeed folder on $REMOTE_HOST [$DEFAULT_REMOTE_ROOT]: ${normal}" REMOTE_ROOT && changed=true
    [[ -z "$REMOTE_ROOT" ]] && REMOTE_ROOT=$DEFAULT_REMOTE_ROOT

    if $changed; then
      cat <<CONFIG >"$CONFIG_PATH"
LOCAL_ROOT=$LOCAL_ROOT
REMOTE_HOST=$REMOTE_HOST
REMOTE_USER=$REMOTE_USER
REMOTE_ROOT=$REMOTE_ROOT
CONFIG
    fi

    local answer=" "
    while [[ ! "$answer" =~ ^[YyNn]?$ ]]; do
      read -r -p "${bold}Do you want to setup docker context for your CloudVM? [Y/n]: ${normal}" answer
      [[ "$answer" =~ ^[Yy]?$ ]] && setup_docker
    done
  }

  # Create docker context for CloudVM and set it as default
  function setup_docker() {
    if ! (docker context list | grep -q cvm); then
      docker context create cvm --docker "host=ssh://$REMOTE_USER@$REMOTE_HOST" >/dev/null
    fi
    docker context use cvm >/dev/null
    echo "You can revert your docker context to default by running 'docker context use default'"
  }

  # Find the root of the project by looking for a .git directory or fallback to the directory right under $HOME/indeed
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

  # Sync project from local to remote
  function cvm_sync() {
    local LOCAL_PATH
    LOCAL_PATH=$(find_project_root "$PWD") || die "Failed to find project root! Are you in $LOCAL_ROOT subfolder?"

    local REMOTE_PATH
    REMOTE_PATH=$(to_remote_path "$LOCAL_PATH") || die "Failed to find project root on remote host"

    echo "Synchronizing $LOCAL_PATH to $REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH"
    rsync -aP --delete --exclude .idea/ --exclude .vscode/ --exclude out/ --exclude build/ --exclude node_modules/ --exclude .gradle/ "$LOCAL_PATH/." "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH"
  }

  # Convert local path to remote path
  function to_remote_path() {
    local LOCAL_PATH="$1"
    local REMOTE_PATH=$(echo "$LOCAL_PATH" | sed "s#$LOCAL_ROOT#$REMOTE_ROOT#g")
    [[ ! "$REMOTE_PATH" =~ "$LOCAL_ROOT/".* ]] && die "Current CVM directory is not inside $REMOTE_ROOT"
    echo "$REMOTE_PATH"
  }

  # Just open ssh connection to remote host
  function cvm_connect() {
    local REMOTE_PATH
    REMOTE_PATH=$(to_remote_path "$PWD" || echo "~")
    ssh -t "${REMOTE_USER}@${REMOTE_HOST}" "cd $REMOTE_PATH; bash --login"
  }

  # Sync project and executes command on remote host
  function cvm_exec_in_synced_folder() {
    [[ ! "$PWD" =~ "$LOCAL_ROOT/".* ]] && return 1
    REMOTE_PATH=$(pwd | sed "s,$LOCAL_ROOT,$REMOTE_ROOT,g")
    LOCAL_PROJECT_ROOT=$(find_project_root "$PWD") || die "Failed to find project root! Are you in $LOCAL_ROOT subfolder?"

    cvm_sync

    $VERBOSE && echo "Executing '$*' at $REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH"
    ssh -t ${REMOTE_USER}@${REMOTE_HOST} "cd $REMOTE_PATH && echo \"$* 2>&1 | sed 's,file://$LOCAL_PROJECT_ROOT,http://$REMOTE_HOST:$BROWSE_PORT,g'\" | bash --login && exit 0 || exit 1"
    echo -e "\n${bold}Hint:${normal} run 'cvm --browse' to access links from your build output"
  }

  # Executes command on remote host
  function cvm_exec() {
    $VERBOSE && echo "Executing '$*' at $REMOTE_USER@$REMOTE_HOST:~"
    # ssh -t runs ssh in interactive mode, so we can use Ctrl+C to interrupt remote process
    ssh -t ${REMOTE_USER}@${REMOTE_HOST} "echo $* | bash --login && exit 0 || exit 1"
  }

  # Starts web server in project root
  function browse() {
    local LOCAL_PATH
    LOCAL_PATH=$(find_project_root "$PWD") || die "Failed to find project root! Are you in $LOCAL_ROOT subfolder?"

    local REMOTE_PATH
    REMOTE_PATH=$(to_remote_path "$LOCAL_PATH") || die "Failed to find project root on remote host"

    echo "Starting web server at $REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH. Press Ctrl+C to stop"
    cvm_exec "command -v ufw 2>&1 >/dev/null && sudo ufw allow $BROWSE_PORT/tcp 2>&1 >/dev/null; python3 -m http.server $BROWSE_PORT -d $REMOTE_PATH"
  }

  # At least one flag or command is required
  [[ $# -eq 0 ]] && help && exit 1

  # Load saved configuration and run setup if configuration is missing or is incomplete
  [ -f "$CONFIG_PATH" ] && source "$CONFIG_PATH"
  setup_required && cvm_setup

  # Parse flags
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
  --setup)
    cvm_setup
    ;;
  --browse)
    browse
    ;;
  --*)
    help
    echo -e "\n"
    die "Unknown option: $1"
    ;;
  *)
    if [ $# -eq 0 ]; then
      help
    elif [[ "$PWD" =~ "$LOCAL_ROOT/".* ]]; then
      # If we are in a project folder, then sync it to remote and execute command there
      cvm_exec_in_synced_folder "$@"
    else
      # If we are not in project folder, then skip sync and just execute command on remote host
      cvm_exec "$@"
    fi
    ;;
  esac
)

cvm "$@"
