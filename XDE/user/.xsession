#!/bin/sh

set -euo pipefail

export LANG=en_US.UTF-8
export LC_CTYPE=zh_CN.UTF-8
export XMODIFIERS=@im=fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx

export MANWIDTH=tty
export CLICOLOR=1

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

## start Fcitx and wait for it, or Ctrl-Space may not work
fcitx
i=0; while [ $((i+=1)) -le 100 ]; do
    sleep 0.1
    fcitx-remote >/dev/null 2>&1 && break
done

## autostart /usr/local/etc/xdg/autostart/vboxclient.desktop
## https://bugs.freebsd.org/bugzilla/buglist.cgi?query_format=advanced&short_desc=VBoxClient&short_desc_type=allwordssubstr
vboxclient=/usr/local/bin/VBoxClient
if [ -x $vboxclient-all ]; then
    sed -e "s|/usr/bin/VBoxClient|$vboxclient|g" $vboxclient-all | sh || echo "WARN: $vboxclient-all failed!" >&2
fi

## affect i3-sensible-terminal
for term in urxvtcd mlterm lxterminal uxterm xterm; do
    which -s $term && export TERMINAL=$term && break
done

## start window manager
which -s "${1:-}" || exec i3    # awesome openbox-session icewm-session wmaker fvwm
exec "$1"

