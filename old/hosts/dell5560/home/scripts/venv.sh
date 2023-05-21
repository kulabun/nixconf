#!/usr/bin/env bash
function venv() {
	if [ ! -f ".venv" ]; then
		echo "creating venv"
		python3 -m venv .venv
	fi
	echo "activating venv"
	source ".venv/bin/activate"
}

venv "$@"
