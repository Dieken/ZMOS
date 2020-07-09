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

rm -rf "$XDE_HOME/generated-user/"
cp -a "$XDE_HOME/user" "$XDE_HOME/generated-user"
{
    find "$XDE_HOME/generated-user" -type f -name "*.tmpl"
    find "$XDE_HOME/user-local" -type f
} | while read f; do
    t=${f#$XDE_HOME/*/}
    t=${t%.tmpl}
    mkdir -p "$XDE_HOME/generated-user/`dirname $t`"
    [ ${t%.append} = $t ] && rm -f "$XDE_HOME/generated-user/${t%.append}"
    t=${t%.append}
    if [ ${f%.tmpl} = $f ]; then
        cat "$f"
    else
        perl -pe 's/@@(\w+)@@/exists $ENV{$1} ? $ENV{$1} : $&/eg' "$f"
    fi >>"$XDE_HOME/generated-user/$t"
    chmod `stat -f %Lp "$f"` "$XDE_HOME/generated-user/$t"
done


rsync -acv -b --backup-dir "$PWD/backup-user-$TIMESTAMP" \
    --exclude "*.append" --exclude "*.sample" --exclude "*.tmpl" --exclude ".*.sw*" --exclude "*~" --exclude ".DS_Store" --exclude ".git*" \
    "$XDE_HOME/generated-user/" $HOME/

rm -rf "$XDE_HOME/generated-user/"

echo -e "\n\nDone, you'd better logout now!\n"

