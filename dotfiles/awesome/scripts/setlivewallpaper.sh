#!/bin/bash
# This is a script made to produce live wallpapers for every screen.
#
# Credit goes to Leafshade Software for the script and an incredible
# video to go with it.

PIDFILE="/var/run/user/$UID/bg.pid"

declare -a PIDs

_screen() {
   xwinwrap -ov -ni -g "$1" -- mpv --fullscreen --no-stop-screensaver \
       --hwdec=auto --vo=gpu --loop --no-audio --no-osd-bar \
       -wid WID --no-input-default-bindings "$2" & PIDs+=($!)
}

while read p; do
    [[ $(ps -p "$p" -o comm=) == "xwinwrap" ]] && kill -9 "$p";
done < $PIDFILE

sleep 0.5

for i in $( xrandr -q | grep ' connected' | grep -oP '\d+x\d+\+\d+\+\d+')
do
    _screen "$i" "$1"
done

printf "%s\n" "${PIDs[@]}" > $PIDFILE
