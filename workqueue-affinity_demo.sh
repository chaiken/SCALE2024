#!/bin/bash

set -e
set -u

readonly KERNEL_PATH=/home/alison/gitsrc/linux-trees/linux/tools/workqueue
readonly SYSFS_PATH=/sys/devices/virtual/workqueue/blkcg_punt_bio

#0
echo "$ ls /sys/devices/virtual/blkcg_punt_bio"
ls "$SYSFS_PATH"
echo ""

sleep 5

#1
echo "Default affinity scope of unbound blkcg_punt_bio workqueue:"
echo "$ cat /sys/devices/virtual/workqueue/blkcg_punt_bio/affinity_scope"
cat "$SYSFS_PATH"/affinity_scope 
echo ""

sleep 5

#2
echo "Determine which in which workqueue pools blkcg_punt_bio runs"
echo "Workqueue CPU -> pool"
echo "====================="
echo "[    workqueue     \     type   CPU  0  1  2  3  4  5  6  7 dfl]"
echo "$ drgn tools/workqueue/wq_dump.py | grep blkcg"
sudo drgn "$KERNEL_PATH"/wq_dump.py | grep blkcg
echo ""

sleep 5

#3
echo "$ sudo bash -c 'echo 15 > /sys/devices/virtual/workqueue/blkcg_punt_bio/cpumask'"
sudo bash -c 'echo 15 > /sys/devices/virtual/workqueue/blkcg_punt_bio/cpumask'
echo ""
