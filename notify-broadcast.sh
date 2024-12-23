#!/bin/bash

HELP="Call notify-send (used by Dunst) for all current X users.
Passed arguments (message, icon etc) are sent on as-is.
This script must be run as root."

case $1 in
--help|-h)
    echo "$HELP"
    exit
    ;;
esac

required_commands=(notify-send) # array

error_exit() {
    echo "$0 error: $1" >&2
    exit 1
}

missing_commands=
for i in "${required_commands[@]}"
do
    hash "$i" >/dev/null || missing_commands+=" $i"
done
[[ $missing_commands ]] && error_exit "This script requires the following commands: $missing_commands
Please install the packages containing the missing commands
and rerun the script."

[[ $(id -u) -eq 0 ]] || error_exit "This script must be run as root."

declare -A displays users
users=()
displays=()

for i in $(users); do # "users" command output
    [[ $i = root ]] && continue
    users[$i]=1
done # unique names

for u in "${!users[@]}"; do
    for i in $(ps e -u "$u" | sed -rn 's/.* DISPLAY=(:[0-9]*).*/\1/p'); do
        displays[$i]=$u
    done
done

for d in "${!displays[@]}"; do
    sudo -u "${displays[$d]}" DISPLAY="$d" notify-send "$@"
done

exit 0
