#!/bin/bash

set -e
set -u

readonly KERNEL_PATH=/home/alison/gitsrc/linux-trees/linux/tools/workqueue
readonly WORKQUEUE=raid5wq
readonly SYSFS_PATH=/sys/devices/virtual/workqueue/${WORKQUEUE}
readonly DEFAULT_AFFINITY_SCOPE=$(cat /sys/devices/virtual/workqueue/${WORKQUEUE}/affinity_scope | cut -f 1 -d " ")
readonly DEFAULT_CPUMASK=$(cat /sys/devices/virtual/workqueue/${WORKQUEUE}/cpumask)

restore() {
    echo "Restoring default settings"
    echo "${DEFAULT_AFFINITY_SCOPE}" > /sys/devices/virtual/workqueue/${WORKQUEUE}/affinity_scope
    echo "${DEFAULT_CPUMASK}" > /sys/devices/virtual/workqueue/${WORKQUEUE}/cpumask
}

main() {
#0
    echo ""
    echo ""
    echo "$ ls /sys/devices/virtual/${WORKQUEUE}"
    ls "$SYSFS_PATH"
    echo ""

    sleep 5

#1
    echo "Default affinity scope of unbound ${WORKQUEUE} workqueue:"
    echo "$ cat /sys/devices/virtual/workqueue/${WORKQUEUE}/affinity_scope"
    cat "$SYSFS_PATH"/affinity_scope
    echo ""

    sleep 5

#2
    echo "Default cpumask of unbound ${WORKQUEUE} workqueue:"
    echo "$ cat /sys/devices/virtual/workqueue/${WORKQUEUE}/cpumask"
    cat "$SYSFS_PATH"/cpumask
    echo ""

    sleep 5

#3
    echo "Determine in which workqueue pools ${WORKQUEUE} runs by default"
    echo "Workqueue CPU -> pool"
    echo "====================="
    echo "[    workqueue     \     type   CPU  0  1  2  3  4  5  6  7 dfl]"
    echo "$ drgn tools/workqueue/wq_dump.py | grep ${WORKQUEUE}"
     drgn "$KERNEL_PATH"/wq_dump.py | grep ${WORKQUEUE}
    echo ""

    sleep 5

#4
    echo "cpumask 15 = 1 + 2 + 4 + 8 --> cores 0-3"
    echo "$  bash -c 'echo 15 > /sys/devices/virtual/workqueue/${WORKQUEUE}/cpumask'"
     bash -c 'echo 15 > /sys/devices/virtual/workqueue/${WORKQUEUE}/cpumask'
    echo ""

   sleep 5

#5
    echo "In which workqueue pools does ${WORKQUEUE} run now?"
    echo "$ drgn tools/workqueue/wq_dump.py | grep ${WORKQUEUE}"
    echo "Workqueue CPU -> pool"
    echo "====================="
    echo "[    workqueue     \     type   CPU  0  1  2  3  4  5  6  7 dfl]"
     drgn "$KERNEL_PATH"/wq_dump.py | grep ${WORKQUEUE}
    echo ""

    readonly POOL=$(drgn "$KERNEL_PATH"/wq_dump.py |  grep ${WORKQUEUE}  |  awk {'print $3;'})

    sleep 5

#6
    echo "What else runs in workqueue pool ${POOL}?"
    echo "$ drgn tools/workqueue/wq_dump.py | grep ${POOL}"
    echo ""

    sleep 5

#7
    restore
}

main "$@"
