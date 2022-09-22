#!/usr/bin/env bash

function _select_secret() {
	query="$1"
	gopass ls -f | fzf -q "$query"
}

function cmd_clip() {
	secret_name=$(_select_secret "$@")
	[ ! -z "$secret_name" ] && gopass --clip "$secret_name"
}

function cmd_edit() {
	secret_name=$(_select_secret "$@")
	[ ! -z "$secret_name" ] && gopass edit "$secret_name"
}

function cmd_show() {
	secret_name=$(_select_secret "$@")
	[ ! -z "$secret_name" ] && gopass show "$secret_name"
}

function cmd_generate() {
	secret_name=$(_select_secret "$@")
	[ ! -z "$secret_name" ] && gopass generate "$secret_name"
}

function cmd_delete() {
	secret_name=$(_select_secret "$@")
	[ ! -z "$secret_name" ] && gopass delete "$secret_name"
}

function cmd_list() {
	gopass ls --flat | less
}

function cmd_grep() {
	gopass ls --flat | grep "$@"
}

function cmd_create() {
	gopass create
}

case "$1" in
edit)
	shift
	cmd_edit "$@"
	;;
show)
	shift
	cmd_show "$@"
	;;
list | ls)
	shift
	cmd_list "$@"
	;;
grep)
	shift
	cmd_grep "$@"
	;;
generate)
	shift
	cmd_generate "$@"
	;;
delete | rm | remove)
	shift
	cmd_delete "$@"
	;;
create)
	shift
	cmd_create "$@"
	;;
*)
	shift
	cmd_clip "$@"
	;;
esac
