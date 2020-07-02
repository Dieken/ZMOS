#!/bin/sh

set -euo pipefail

export PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin

[ x`id -u` = x0 ] && {
    echo "ERROR: must not run as root!" >&2
    exit 1
}

########################################################################
## global variables

XDE_HOME=`dirname $0`
TIMESTAMP=`date +%Y%m%d-%H%M%S`

. "$XDE_HOME/xde.conf"
[ -e "$XDE_HOME/xde.conf.local" ] && . "$XDE_HOME/xde.conf.local"

########################################################################
## functions

########################################################################
## user config

rm -rf "$XDE_HOME/generated-user/" && mkdir "$XDE_HOME/generated-user/"
find "$XDE_HOME/user" -type f -name "*.tmpl" | while read f; do
    t=${f#$XDE_HOME/user/}
    t=${t%.tmpl}
    mkdir -p "$XDE_HOME/generated-user/`dirname $t`"
    perl -pe 's/@@(\w+)@@/exists $ENV{$1} ? $ENV{$1} : $&/eg' "$f" >"$XDE_HOME/generated-user/$t"
    chmod `stat -f %Lp "$f"` "$XDE_HOME/generated-user/$t"
done


rsync -acv -b --backup-dir "$PWD/backup-user-$TIMESTAMP" \
    --exclude "*.tmpl" --exclude ".*.sw*" --exclude "*~" --exclude ".DS_Store" --exclude ".git*" \
    "$XDE_HOME/user/" "$XDE_HOME/generated-user/" $HOME/

rm -rf "$XDE_HOME/generated-user/"

echo -e "\n\nDone, you'd better logout now!\n"

