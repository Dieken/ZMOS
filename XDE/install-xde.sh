#!/bin/sh

set -euo pipefail

export PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin

[ x`id -u` = x0 ] || {
    echo "ERROR: must run as root!" >&2
    exit 1
}

########################################################################
## global variables

XDE_HOME=`dirname $0`
TIMESTAMP=`date +%Y%m%d-%H%M%S`
PACKAGES=

########################################################################
## functions

i() {
    PACKAGES="$PACKAGES $@"
}

loader_sysrc() {
    sysrc -f /boot/loader.conf "$@"
}

########################################################################
## packages

# X server
i xorg

# VirtualBox additions
i xf86-video-vmware virtualbox-ose-additions

# X display manager: slim, xdm
i slim

# X session manager
#i xsm

# X window manager: i3, awesome, openbox, icewm, windowmaker, fvwm
i i3-gaps i3status
#i awesome awesome-vicious conky-awesome
#i openbox tint2 # fbpanel is another good panel
#i icewm
#i windowmaker
#i fvwm

# X compositing manager
#i picom

# X terminal emulator: rxvt-unicode, mlterm
i rxvt-unicode urxvt-font-size urxvt-perls

# X input method
i fcitx-qt5 zh-fcitx zh-fcitx-configtool zh-fcitx-libpinyin zh-fcitx-sunpinyin

# extra fonts
i noto hack-font
#i powerline-fonts nerd-fonts

# extra utilities
i augeas dbus flog rsync
i xsel-conrad xclip     # required by urxvt clipboard extension

# Finally, install all packages
pkg install $PACKAGES

########################################################################
## system config

sysrc vboxguest_enable=YES vboxservice_enable=YES
sysrc slim_enable=YES
sysrc dbus_enable=YES

# recommended by xorg-server
augtool -l /etc/sysctl.conf -s 'set /files/etc/sysctl.conf/kern.evdev.rcpt_mask 6'

# use 1920x1080 if not specified, loader.conf(5)
loader_sysrc -i -c efi_max_resolution || loader_sysrc efi_max_resolution=1080p

# use terminus-b32 if not specified, rc.conf(5)
allscreens_flags=`sysrc -i -n allscreens_flags-NULL`
[ "${allscreens_flags#*-f }" = "$allscreens_flags" ] && sysrc allscreens_flags+=" -f terminus-b32"

rsync -rlcv -b --backup-dir backup-$TIMESTAMP \
    --exclude ".*.sw*" --exclude "*~" --exclude ".DS_Store" \
    "$XDE_HOME/system/" /

echo -e "\n\nDone, you'd better reboot now!\n"

