#!/bin/sh

# Интервал обновления в секундах (0.5 = 500мс)
UPDATE_INTERVAL=0.5

status() {
    # Получаем информацию о батарее
    bat_info=$(acpi -b 2>/dev/null)
    if [ $? -eq 0 ]; then
        bat=$(echo "$bat_info" | awk '{print $4}' | sed 's/,//g; s/%//g')
        bat_status=$(echo "$bat_info" | awk '{print $3}' | sed 's/,//g')
        case "$bat_status" in
            Charging) bat="CHG $bat%" ;;
            Discharging) bat="BAT $bat%" ;;
            *) bat="AC $bat%" ;;
        esac
    else
        bat="PWR N/A"
    fi

    # Определение раскладки клавиатуры (более надежный способ)
    layout=$(xset -q | grep -A 0 'LED mask' | awk '{print $NF}')
    case "$layout" in
        00000000) layout="EN" ;;
        00001000) layout="RU" ;;
        *) layout=$(setxkbmap -query 2>/dev/null | grep layout | awk '{print $2}' | cut -c-2) || layout="??" ;;
    esac

    # Получаем уровень громкости (универсальный способ)
    volume=""
    if command -v amixer >/dev/null; then
        volume=$(amixer get Master 2>/dev/null | grep -o "[0-9]*%" | head -n 1 | tr -d '%')
    elif command -v pactl >/dev/null; then
        volume=$(pactl list sinks 2>/dev/null | grep '^[[:space:]]Volume:' | head -n 1 | awk '{print $5}' | tr -d '%')
    fi
    
    if [ -n "$volume" ]; then
        if [ "$volume" -gt 70 ]; then
            volume="VOL+ $volume%"
        elif [ "$volume" -gt 30 ]; then
            volume="VOL $volume%"
        elif [ "$volume" -gt 0 ]; then
            volume="VOL- $volume%"
        else
            volume="MUTE"
        fi
    else
        volume="VOL N/A"
    fi

    # Форматирование даты и времени с секундами
    datetime=$(date '+%a %d.%m %H:%M:%S')

    # Собираем все компоненты
    echo -n "[ $layout ] [ $volume ] [ $bat ] [ $datetime ]"
}

while :; do
    xsetroot -name "$(status)"
    sleep $UPDATE_INTERVAL
done
