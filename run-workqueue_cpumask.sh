#!/bin/bash

set -e
set -u

readonly HOSTNAME="$(hostname)"
readonly BOARDNAME=bullseye-dev64mq

# Pick explicit paths since $HOME with sudo is /root.
if [[ "$BOARDNAME" == "$HOSTNAME" ]]
then
    BIN=/home/debian/gitsrc/SCALE2024/workqueue_cpumask.bt
else
    BIN=/home/alison/gitsrc/SCALE2024/workqueue_cpumask.bt
fi

echo ""
echo ""
echo "$ workqueue_cpumask.bt | grep -v ldisc"
echo ""
echo "0xffffffff or 0xff means unbound"
"$BIN"  | grep -v ldisc

