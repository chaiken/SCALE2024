#!/bin/bash

set -e
set -u

readonly HOSTNAME="$(hostname)"
readonly BOARDNAME=bullseye-dev64mq

echo ""
echo "The kernel is $(uname -r) from https://github.com/chaiken/linux/tree/wq-dump"
echo ""

if [[ "$BOARDNAME" == "$HOSTNAME" ]]
then
    DRGN=/usr/local/bin/drgn
    BIN=/home/debian/wq_monitor.py
else
    DRGN=/usr/bin/drgn
    export BIN=/home/alison/gitsrc/linux-trees/linux/tools/workqueue/wq_monitor.py
fi

echo "$ ${DRGN} ${BIN}"

"$DRGN" "$BIN"
