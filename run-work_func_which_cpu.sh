#!/bin/bash

set -e
set -u

readonly HOSTNAME="$(hostname)"
readonly BOARDNAME=bullseye-dev64mq

# Pick explicit paths since $HOME with sudo is /root.
if [[ "$BOARDNAME" == "$HOSTNAME" ]]
then
    BIN=/home/debian/gitsrc/SCALE2024/work_func_which_cpu.bt
else
    BIN=/home/alison/gitsrc/SCALE2024/workqueue_exec_time.bt
fi

echo ""
echo ""
echo "$ work_func_which_cpu.bt | grep -v ldisc"
"$BIN"  | grep -v ldisc

