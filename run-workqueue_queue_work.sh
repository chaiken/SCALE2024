#!/bin/bash

set -e
set -u

readonly TLD=/home/debian/gitsrc/SCALE2024

echo "workqueue_queue_work.bt | grep -v ldisc"
"$TLD"/workqueue_queue_work.bt | grep -v ldisc

