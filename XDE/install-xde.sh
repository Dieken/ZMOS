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
MACHINE=physical

. "$XDE_HOME/xde.conf"
[ -e "$XDE_HOME/xde.conf.local" ] && . "$XDE_HOME/xde.conf.local"

case `kenv -q smbios.system.maker`/`kenv -q smbios.system.product` in
    *VirtualBox*) MACHINE=vbox ;;               # innotek GmbH/VirtualBox
    *VMware*) MACHINE=vmware ;;                 # VMware, Inc./VMware Virtual Platform
    *Microsoft*Virtual*) MACHINE=hyperv ;;      # Microsoft Corporation/Virtual Machine
esac

########################################################################
## functions

i() {
    PACKAGES="$PACKAGES $@"
}

loader_sysrc() {
    sysrc -f /boot/loader.conf "$@"
}

ifvm () {
    [ $MACHINE = physical ] && return
    case $1 in
        all|$MACHINE) shift; "$@" ;;
    esac
}

########################################################################
## packages

# X server
i xorg

# VirtualBox additions
ifvm vmware i xf86-video-vmware xf86-input-vmmouse open-vm-tools
ifvm vbox i xf86-video-vmware virtualbox-ose-additions

# X display manager: slim, xdm
i slim slim-themes

# X session manager
#i xsm

# X window manager: i3, awesome, openbox, icewm, windowmaker, fvwm
i i3-gaps i3status rofi rofi-calc rofi-pass     # rofi is better than dmenu
#i awesome awesome-vicious conky-awesome
#i openbox tint2 # fbpanel is another good panel
#i icewm
#i windowmaker
#i fvwm

# X compositing manager: picom, compton
i picom

# X terminal emulator: rxvt-unicode, mlterm
i rxvt-unicode urxvt-font-size urxvt-perls

# X input method
i fcitx-qt5 zh-fcitx zh-fcitx-configtool zh-fcitx-libpinyin zh-fcitx-sunpinyin

# extra fonts
i dejavu hack-font noto zh-CJKUnifonts
#i powerline-fonts nerd-fonts

# extra utilities
i augeas dbus flog ImageMagick7 perl5 rsync
i xdg-utils
i mkfontscale                   # https://www.freebsd.org/doc/en_US.ISO8859-1/books/handbook/x-fonts.html

# Finally, install all packages
pkg install $PACKAGES

########################################################################
## system config

# required by /usr/local/bin/vmware-vmblock-fuse and other fuse filesystems
loader_sysrc fuse_load=YES

ifvm vbox sysrc vboxguest_enable=YES vboxservice_enable=YES vboxservice_flags="--disable-timesync"

sysrc dbus_enable=YES
sysrc moused_enable=YES     # required by system-vmware/usr/local/etc/X11/xorg.conf.d/XDE-vmware.conf.tmpl
sysrc slim_enable=YES

# recommended by xorg-server
augtool -l /etc/sysctl.conf -s 'set /files/etc/sysctl.conf/kern.evdev.rcpt_mask 6'

# use large resolution, loader.conf(5)
loader_sysrc efi_max_resolution="$SCREEN_RESOLUTION"

# use terminus-b32 if not specified, rc.conf(5)
allscreens_flags=`sysrc -i -n allscreens_flags-NULL`
[ "${allscreens_flags#*-f }" = "$allscreens_flags" ] && sysrc allscreens_flags+=" -f terminus-b32"


rm -rf "$XDE_HOME/generated-system/" && mkdir "$XDE_HOME/generated-system/"
find "$XDE_HOME/system" "$XDE_HOME/system-$MACHINE" -type f -name "*.tmpl" | while read f; do
    t=${f#$XDE_HOME/*/}
    t=${t%.tmpl}
    mkdir -p "$XDE_HOME/generated-system/`dirname $t`"
    perl -pe 's/@@(\w+)@@/exists $ENV{$1} ? $ENV{$1} : $&/eg' "$f" >"$XDE_HOME/generated-system/$t"
done


rsync -rlcv -b --backup-dir "$PWD/backup-system-$TIMESTAMP" \
    --exclude "*.sample" --exclude "*.tmpl" --exclude ".*.sw*" --exclude "*~" --exclude ".DS_Store" --exclude ".git*" \
    "$XDE_HOME/system/" "$XDE_HOME/system-$MACHINE/" "$XDE_HOME/generated-system/" /

ifvm vmware chmod 555 /usr/local/etc/rc.d/xde-vmware-vmblock-fuse

rm -rf "$XDE_HOME/generated-system/"

echo -e "\n\nDone, you'd better reboot now!\n"

