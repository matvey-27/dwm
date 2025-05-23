#!/bin/sh

# Настройки
setxkbmap -layout us,ru -option grp:win_space_toggle
feh --bg-fill ~/dwm/wallpaper/wallpaper1.jpg

# Запускаем статусбар
~/dwm/script/bar.sh &

picom --config ~/.config/picom.conf &

# Запускаем DWM и перезапускаем при падении
while true; do
    # Ждем завершения dwm перед перезапуском
    dwm 2> ~/.dwm.log
    sleep 1
done
