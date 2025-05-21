настройка языков 

```
sudo pacman -S xorg-xkbcomp xorg-setxkbmap
setxkbmap -layout us,ru -option grp:win_space_toggle
echo "setxkbmap -layout us,ru -option grp:alt_shift_toggle" >> ~/.xinitrc
```

настройка 
