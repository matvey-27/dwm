# dwm-custom-config

Набор конфигурационных файлов для оконного менеджера dwm, включающий настройки для автозапуска, статус-бара и клавишных комбинаций.

---

## Установка и зависимости

### **Общие зависимости**
Для корректной работы этого конфига необходимы следующие программы:

* **dwm**: Сам оконный менеджер.
* **rofi**: Лаунчер приложений, используемый вместо `dmenu`.
* **kitty**: Эмулятор терминала.
* **picom**: Композитный менеджер для эффектов прозрачности и теней.
* **feh**: Программа для установки обоев.
* **lxqt-policykit-agent**: Агент аутентификации для работы с правами администратора.
* **brightnessctl**: Утилита для управления яркостью экрана.
* **pactl** или **amixer**: Утилита для управления громкостью. `pactl` входит в состав `pulseaudio` или `pipewire-pulse`.
* **acpi**: Утилита для получения информации о состоянии батареи (для ноутбуков).
* **xset** и **setxkbmap**: Утилиты для настройки X-сервера и раскладки клавиатуры.
* **flameshot**: Инструмент для создания скриншотов.
* **xf86-input-synaptics** или **libinput**: Драйверы для тачпада.

### **Arch Linux**

Для установки всех необходимых зависимостей в Arch Linux используйте `pacman`.

```bash
sudo pacman -Syu dwm rofi kitty picom feh lxqt-policykit brightnessctl pulseaudio acpi xorg-xset xorg-xkb-utils flameshot xf86-input-synaptics
```

* **rofi**: Используется вместо `dmenu` для более продвинутого меню приложений.
* **pulseaudio** (или `pipewire-pulse`): Предоставляет утилиту `pactl`, которая используется в скрипте `bar.sh` для управления громкостью.
* **xorg-xset** и **xorg-xkb-utils**: Пакеты, содержащие `xset` и `setxkbmap`, которые используются для настройки клавиатуры.
* **xf86-input-synaptics**: Драйвер для тачпада.

### **Gentoo**

Для установки необходимых зависимостей в Gentoo используйте `emerge`.

```bash
sudo emerge --ask x11-wm/dwm x11-misc/rofi x11-terms/kitty x11-misc/picom media-gfx/feh lxqt-base/lxqt-policykit sys-power/brightnessctl media-sound/pulseaudio sys-power/acpi x11-apps/xset x11-drivers/xf86-input-synaptics
```

* **x11-misc/rofi**: Роль лаунчера приложений.
* **media-sound/pulseaudio**: Обеспечивает работу `pactl`.
* **x11-apps/xset**: Пакет, содержащий `xset` и `setxkbmap`.
* **x11-drivers/xf86-input-synaptics**: Драйвер для тачпада.
* В Gentoo некоторые программы могут быть в разных `EBUILDs`. Проверьте, чтобы у вас были включены нужные `USE-флаги`.

---

## Настройка

1.  **Клонируйте репозиторий dwm** и замените `config.h` на ваш.
2.  **Скопируйте скрипты** (`startDwm.sh`, `bar.sh`) в ваш домашний каталог (например, в `~/dwm/`).
3.  **Сделайте скрипты исполняемыми**:
    ```bash
    chmod +x ~/dwm/startDwm.sh ~/dwm/script/bar.sh
    ```
4.  **Установите dwm**:
    ```bash
    cd ~/dwm # (или в каталог, где находится ваш конфиг)
    sudo make clean install
    ```
5.  **Настройте автозапуск**: Добавьте вызов `startDwm.sh` в ваш `.xinitrc` или другой файл автозапуска.

    Пример `.xinitrc`:
    ```bash
    #!/bin/sh
    exec ~/dwm/startDwm.sh
    ```

---

## Настройка тачпада

Для настройки тачпада рекомендуется использовать драйвер **libinput**, который является современным и поддерживается большинством DE, включая GNOME. Однако, если вам нужен более тонкий контроль, можно использовать драйвер **xf86-input-synaptics**. 

**Внимание**: `xf86-input-synaptics` больше не обновляется. По возможности используйте **libinput**.

### Использование xf86-input-synaptics

1.  **Скопируйте конфигурационный файл** драйвера из системной директории:
    ```bash
    sudo cp /usr/share/X11/xorg.conf.d/70-synaptics.conf /etc/X11/xorg.conf.d/
    ```
2.  **Отредактируйте файл** `/etc/X11/xorg.conf.d/70-synaptics.conf`, добавив необходимые опции в секцию `InputClass`. Пример конфигурации для включения тап-чтобы-кликнуть и различных видов скроллинга:
    ```
    Section InputClass
        Identifier touchpad
        Driver synaptics
        MatchIsTouchpad on
            Option TapButton1 1
            Option TapButton2 3
            Option TapButton3 2
            Option VertEdgeScroll on
            Option VertTwoFingerScroll on
            Option HorizEdgeScroll on
            Option HorizTwoFingerScroll on
            Option CircularScrolling on
            Option CircScrollTrigger 2
            Option CoastingSpeed 0
            Option FingerLow 30
            Option FingerHigh 50
            ...
    EndSection
    ```
    Полный список доступных опций можно найти в man-странице `synaptics(4)`.

---

## Описание файлов

* **`config.h`**: Основной конфигурационный файл dwm. Содержит все горячие клавиши, настройки внешнего вида, правила для окон и т.д.
* **`startDwm.sh`**: Скрипт автозапуска, который выполняет следующие действия:
    * Устанавливает раскладку клавиатуры (`us`, `ru`) с переключением по `Win+Space` с помощью `setxkbmap`.
    * Устанавливает обои с помощью `feh`.
    * Запускает агент `lxqt-policykit-agent`.
    * Запускает `picom` для эффектов прозрачности и теней.
    * Запускает скрипт статус-бара `bar.sh`.
    * Запускает `dwm` в цикле `while true`, что обеспечивает автоматический перезапуск dwm в случае сбоя.
* **`bar.sh`**: Скрипт для создания и обновления статус-бара. Он собирает и отображает следующую информацию:
    * Раскладка клавиатуры (EN/RU).
    * Уровень громкости (с индикатором MUTE, VOL-, VOL, VOL+).
    * Состояние батареи (заряд, разряд, процент).
    * Текущая дата и время.

