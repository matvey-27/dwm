пакеты (archLinux Pacman)
```

sudo pacman -S flameshot
sudo pacman -S feh
sudo pacman -S xorg-xsetroot
sudo pacman -S sysstat iproute2
sudo pacman -S rofi firefox 

```


настройка языков 

```
sudo pacman -S xorg-xkbcomp xorg-setxkbmap
setxkbmap -layout us,ru -option grp:win_space_toggle
echo "setxkbmap -layout us,ru -option grp:alt_shift_toggle" >> ~/.xinitrc
```
