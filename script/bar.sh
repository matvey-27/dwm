#!/usr/bin/env bash

# ====================
# КОНФИГУРАЦИЯ
# ====================

# Символы Unicode (работают в большинстве терминалов)
ICON_BATTERY="♡"       # Сердечко вместо батареи
ICON_CHARGING="⚡"      # Молния для зарядки
ICON_KEYBOARD="⌨"      # Символ клавиатуры
ICON_NETWORK="↯"       # Молния для сети
ICON_CPU="⌂"           # Дом для процессора
ICON_MEM="Σ"           # Сумма для памяти
ICON_CALENDAR="📅"     # Календарь (оставляем как есть)
ICON_CLOCK="🕒"        # Часы (оставляем как есть)
ICON_SEPARATOR="|"     # Разделитель

# Путь к батарее
BATTERY="BAT0"

# ====================
# ОСНОВНОЙ КОД (без изменений)
# ====================

has_battery() {
    [ -d "/sys/class/power_supply/$BATTERY" ]
}

get_battery_status() {
    local status=$(cat "/sys/class/power_supply/$BATTERY/status")
    local charge=$(cat "/sys/class/power_supply/$BATTERY/capacity")
    
    if [ "$status" = "Charging" ]; then
        echo "$ICON_CHARGING $charge%"
    else
        echo "$ICON_BATTERY $charge%"
    fi
}

get_datetime() {
    echo "$ICON_CALENDAR $(date +'%a %d %b') $ICON_CLOCK $(date +'%I:%M %p')"
}

get_keyboard_layout() {
    local layout=$(setxkbmap -query | grep layout | awk '{print $2}')
    case "$layout" in
        "us") echo "$ICON_KEYBOARD EN" ;;
        "ru") echo "$ICON_KEYBOARD RU" ;;
        *) echo "$ICON_KEYBOARD $layout" ;;
    esac
}

get_network_status() {
    local interface=$(ip route | grep default | awk '{print $5}' | head -n1)
    if [ -z "$interface" ]; then
        echo "$ICON_NETWORK DOWN"
        return
    fi
    
    local ssid=$(iwgetid -r)
    if [ -n "$ssid" ]; then
        local signal=$(awk '/wl/ {print $3}' /proc/net/wireless | cut -d. -f1)
        echo "$ICON_NETWORK $ssid (${signal}%)"
    else
        local speed=$(cat /sys/class/net/$interface/speed 2>/dev/null)
        [ -n "$speed" ] && speed="${speed}Mb/s" || speed="ETH"
        echo "$ICON_NETWORK $speed"
    fi
}

get_system_load() {
    local cpu_load=$(mpstat 1 1 | awk '/Average:/ {printf "%.0f", 100 - $12}')
    local mem_used=$(free -m | awk '/Mem:/ {printf "%.1f", $3/$2 * 100}')
    echo "$ICON_CPU ${cpu_load}% $ICON_MEM ${mem_used}%"
}

while true; do
    components=(
        "$(get_keyboard_layout)"
        "$(get_network_status)"
        "$(get_system_load)"
    )
    
    if has_battery; then
        components+=("$(get_battery_status)")
    fi
    
    components+=("$(get_datetime)")
    
    status_bar=$(printf " %s " "${components[*]}")
    xsetroot -name "$status_bar"
    sleep 30
done
