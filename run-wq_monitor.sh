#!/bin/bash

set -e
set -u

readonly HOSTNAME="$(hostname)"
readonly BOARDNAME=bullseye-dev64mq

echo "The kernel is $(uname -r) from https://github.com/chaiken/linux/tree/wq-dump"
echo ""
echo "$ /usr/bin/drgn $HOME/wq_monitor.py"

if [[ "$BOARDNAME" == "$HOSTNAME" ]]
then
    export BIN=/home/debian/gitsrc/linux-trees/linux/tools/workqueue/wq_monitor.py
else
    export BIN=/home/alison/gitsrc/linux-trees/linux/tools/workqueue/wq_monitor.py
fi

/usr/bin/drgn "$BIN"
