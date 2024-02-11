#!/bin/bash

set -e
set -u

readonly TLD=/home/debian/gitsrc/SCALE2024

echo "workqueue_exec_time.bt | grep -v ldisc"
"$TLD"/workqueue_exec_time.bt | grep -v ldisc

