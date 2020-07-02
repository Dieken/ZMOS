# ZMOS User Guide

## Display Manager

### SLiM

Preview a theme:
```
slim -p /usr/local/share/slim/themes/debian-moreblue
```

Shortcuts:
* <kbd>F1</kbd>:   switch session (default is i3 window manager)
* <kbd>F11</kbd>:  take a screenshot to `/slim.png` (use ImageMagick7 `import` command)

Special user names:
* console: open xterm
* exit: quit slim
* halt: shutdown the machine
* reboot: reboot the machine
* suspend: power-suspend the machine

## Window Manager

### i3

Check https://i3wm.org/docs/refcard.html.

Important shortcuts:
* <kbd>Command/Win + Enter</kbd>: run `urxvtcd`
* <kbd>Command/Win + d</kbd>: run **d**menu (actually `rofi`)
* <kbd>Command/Win + Shift + d</kbd>: **D**elete current window (original <kbd>Command/Win + Shift + q</kbd> conflicts with VirtualBox)
* <kbd>Command/Win + Shift + e</kbd>: **e**xit i3
* <kbd>Command/Win + backslash</kbd>: split horizontally (original <kbd>Command + h</kbd> conflicts with macOS)
* <kbd>Command/Win + minus</kbd>: split vertically (original <kbd>Command + v</kbd> conflicts with macOS)

#### Rofi

`Rofi` is a window switcher and application launcher, check https://github.com/davatorium/rofi.

## Install font

Copy font to `~/.local/share/fonts/`, and run commands below:
```
fc-cache -fv

cd ~/.local/share/fonts
mkfontscale
mkfontdir -e /usr/local/share/fonts/encodings
xset fp rehash
```

References:
1. https://wiki.archlinux.org/index.php/Font_configuration
2. http://xpt.sourceforge.net/techdocs/nix/x/fonts/xf21-XOrgFontConfiguration/single/
3. https://github.com/jgneff/openjdk-freetype
4. http://rastertragedy.com/RTRCh2.htm#Sec21

## Terminal Emulator

### rxvt-unicode

Important shortcuts:
* <kbd>Ctrl + Alt + c</kbd>: copy (due to extension `selection-to-clipboard`, this is not required)
* <kbd>Ctrl + Alt + v</kbd>: paste
* <kbd>Alt + escape</kbd>: activate `keyboard-select`, see https://github.com/muennich/urxvt-perls/
* <kbd>Alt + s</kbd>: backward search, see https://github.com/muennich/urxvt-perls/
* <kbd>Ctrl + +</kbd>: increase font size
* <kbd>Ctrl + -</kbd>: decrease font size
* <kbd>Ctrl + 0</kbd>: reset font size
* <kbd>Ctrl + =</kbd>: show font size

### xterm

### mlterm

## Utilities

1. xsel
2. xclip
3. xdotools
4. xdpyinfo
5. xdriinfo
6. xev
7. xinput
8. xlsclients
9. xlsfonts
10. xmodmap
11. xprop
12. xrandr
13. xrdb
14. xset
15. xsetroot, hxsetroot
16. xvinfo
17. xwininfo

