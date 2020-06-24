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

########################################################################
## functions

########################################################################
## user config

rsync -acv -b --backup-dir backup-$TIMESTAMP \
    --exclude ".*.sw*" --exclude "*~" --exclude ".DS_Store" \
    "$XDE_HOME/user/" $HOME/

echo -e "\n\nDone, you'd better logout now!\n"

