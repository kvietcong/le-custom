#!/bin/bash
# This is a script made to produce live wallpapers for every screen.
# To run this script, all you need to do is execute it with a filename
# argument. (mpv and xwinwrap are required packages)
#
# Credit goes to Leafshade Software for the script and an incredible
# video to go with it.

# The PIDFILE is where all the process IDs are stored
PIDFILE="/var/run/user/$UID/bg.pid"

declare -a PIDs

# A private function to execute xwinwrap+mpv for a live wallpaper and add
# PIDs for later usage
_screen() {
    xwinwrap -ov -ni -nf -un -g "$1" -- \
        mpv --fullscreen --no-stop-screensaver \
        --hwdec=auto --vo=gpu --loop --no-audio --no-osd-bar \
        -wid WID --no-input-default-bindings "$2" & PIDs+=($!)
}

while read p; do
    [[ $(ps -p "$p" -o comm=) == "xwinwrap" ]] && kill -9 "$p";
done < $PIDFILE

sleep 0.25

# For every screen, go execute the _screen() function passing in a geometry
# and file name parameter
for i in $( xrandr -q | grep ' connected' | grep -oP '\d+x\d+\+\d+\+\d+')
do
    _screen "$i" "$1"
done

# Retrieve all the PIDs and output them onto the PIDFILE
printf "%s\n" "${PIDs[@]}" > $PIDFILE
