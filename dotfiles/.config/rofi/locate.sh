#!/usr/bin/env zsh
bla=$(echo "" | rofi -dmenu -p "Enter Text > "); rofi -dmenu echo $(locate -i -n 10 ${bla})
