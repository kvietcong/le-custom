#!/bin/bash
# This is a script to kill all live wall paper instances made
# with the setlivewallpaper script

for process in $(</var/run/user/$UID/bg.pid)
do
    printf "killing ${process}\n"
    kill "$process"
done
