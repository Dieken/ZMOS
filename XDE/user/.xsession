#!/bin/sh

set -euo pipefail

export LANG=en_US.UTF-8
export LC_CTYPE=zh_CN.UTF-8
export XMODIFIERS=@im=fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx

export MANWIDTH=tty
export CLICOLOR=1

warn() {
    echo "WARN: $1" >&2
    { i3-nagbar -f "pango:Hack,DejaVu Sans Mono,monospace 12" -t warning -m "~/.xsession: $1 Please check ~/.xsession-errors." & } || true
}


## redirect logs to ~/.xsession-errors
fifo=$HOME/.xsession-errors-fifo
rm -f "$fifo"
mkfifo -m 0600 "$fifo"
flog -t -T "%F %T " -l $((1024*1024)) -z $HOME/.xsession-errors < "$fifo" &
exec >"$fifo" 2>&1
rm -f "$fifo"


## load ~/.Xresources
resources=$HOME/.Xresources
[ -r "$resources" ] && xrdb -load "$resources"


## prepend user fonts, use `xset q` to check X font paths
#: ${XDG_DATA_HOME:=$HOME/.local/share}
#[ -e "$XDG_DATA_HOME/fonts/fonts.dir" ] && xset +fp "$XDG_DATA_HOME/fonts"


## start Fcitx and wait for it, or Ctrl-Space may not work
fcitx
i=0; while [ $((i+=1)) -le 100 ]; do
    sleep 0.1
    fcitx-remote >/dev/null 2>&1 && break
done


## detect virtual machine
case `kenv -q smbios.system.maker`/`kenv -q smbios.system.product` in
    *VirtualBox*) MACHINE=vbox ;;               # innotek GmbH/VirtualBox
    *VMware*) MACHINE=vmware ;;                 # VMware, Inc./VMware Virtual Platform
    *Microsoft*Virtual*) MACHINE=hyperv ;;      # Microsoft Corporation/Virtual Machine
    *) MACHINE=physical ;;
esac


## start /usr/local/etc/xdg/autostart/vboxclient.desktop
## https://bugs.freebsd.org/bugzilla/buglist.cgi?query_format=advanced&short_desc=VBoxClient&short_desc_type=allwordssubstr
vboxclient=/usr/local/bin/VBoxClient
if [ $MACHINE = vbox -a -x $vboxclient-all ]; then
    sed -e "s|/usr/bin/VBoxClient|$vboxclient|g" $vboxclient-all | sh || warn "$vboxclient-all failed!"
fi


## start /usr/local/etc/xdg/autostart/vmware-user.desktop
## https://github.com/vmware/open-vm-tools/issues/150
vmware_user=/usr/local/bin/vmware-user-suid-wrapper
if [ $MACHINE = vmware -a -x $vmware_user ]; then
    $vmware_user || warn "$vmware_user failed!"
fi


## start X compositing manager
picom -b || warn "picom failed!"


## affect i3-sensible-terminal
[ "$TERMINAL" ] || for term in urxvtcd mlterm lxterminal uxterm xterm; do
    which -s $term && export TERMINAL=$term && break
done


## start window manager
which -s "${1:-}" || exec i3    # awesome openbox-session icewm-session wmaker fvwm
exec "$1"

