#!/usr/bin/env bash

PROMPT=""
DESC=""

echo "$PINENTRY_USER_DATA" >>$HOME/test.log

if [[ -n "$DISPLAY" ]]; then
	export DISPLAY
else
	export DISPLAY=:0
fi

getPassword() {
	rofi \
		-theme "$XDG_CONFIG_HOME"/rofi/menus/prompt.rasi \
		-dmenu \
		-password \
		-p " GPG Passphrase $(echo "$DESC" | awk -F"%0A" '{print $3}' | xargs):" \
		-input /dev/null
}

echo OK
while read cmd rest; do
	case "$cmd" in
	SETDESC)
		DESC=$rest
		if test ''${DESC: -3} != '%0A'; then
			DESC="$DESC%0A"
		fi
		echo OK
		;;
	GETINFO)
		case $rest in
		pid*) echo -e "D $$\nOK" ;;
		version) echo -e "D 1.0.0\nOK" ;;
		flavor*) echo -e "D curses:curses\nOK" ;;
		ttyinfo*) echo -e "D - - -\nOK" ;;
		esac
		;;
	GETPIN) echo -e "D $(getPassword)\nOK" ;;
	CONFIRM) echo ASSUAN_Not_Confirmed ;;
	SETPROMPT)
		PROMPT=$rest
		echo OK
		;;
	SETOK)
		OK=$rest
		echo OK
		;;
	SETERROR)
		ERROR=$rest
		echo OK
		;;
	OPTION) echo OK ;;
	BYE)
		echo OK
		exit
		;;
	*) echo OK ;;
	esac
done
