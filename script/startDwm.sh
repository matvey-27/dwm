#!/bin/sh

# переключени языка
# sudo pacman -S xorg-xkbcomp xorg-setxkbmap
setxkbmap -layout us,ru -option grp:win_space_toggle
feh --bg-fill ~/dwm/wallpaper/wallpaper1.jpg

dwmblocks &

while true; do
        dwm 2> ~/.dwm.log
done
