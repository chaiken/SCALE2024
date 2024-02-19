#!/bin/bash

set -e
set -u

readonly KERNEL_PATH=/home/alison/gitsrc/linux-trees/linux/tools/workqueue
readonly WORKQUEUE=nvme-delete-wq
readonly SYSFS_PATH=/sys/devices/virtual/workqueue/${WORKQUEUE}
readonly DEFAULT_AFFINITY_SCOPE=$(cat /sys/devices/virtual/workqueue/${WORKQUEUE}/affinity_scope | cut -f 1 -d " ")
readonly DEFAULT_NICE=$(cat /sys/devices/virtual/workqueue/${WORKQUEUE}/nice)
readonly NEWNICE=-4

restore() {
    echo "Restoring default settings"
    echo "${DEFAULT_AFFINITY_SCOPE}" > /sys/devices/virtual/workqueue/${WORKQUEUE}/affinity_scope
    echo "${DEFAULT_NICE}" > /sys/devices/virtual/workqueue/${WORKQUEUE}/nice
    echo ""
    echo ""
}

main() {
#0
    echo ""
    echo "0.  Demo will not work before v6.7."
    echo "Kernel version  $(uname -r)"

#1
    echo ""
    echo "1. Workqueues which are configurable from sysfs:"
    echo "$ ls /sys/devices/virtual/workqueue"
    ls /sys/devices/virtual/workqueue
    echo ""

    read -sn1 -p "Press any key to continue"


#2
    echo ""
    echo ""
    echo "2. Consider tunable parameters for ${WORKQUEUE}:"
    echo "$ ls /sys/devices/virtual/${WORKQUEUE}"
    ls "$SYSFS_PATH"
    echo ""

    read -sn1 -p "Press any key to continue"

#3
    echo ""
    echo ""
    echo "3. Default affinity scope of unbound ${WORKQUEUE} workqueue:"
    echo "$ cat /sys/devices/virtual/workqueue/${WORKQUEUE}/affinity_scope"
    cat "$SYSFS_PATH"/affinity_scope
    echo ""

    read -sn1 -p "Press any key to continue"

#4
    echo ""
    echo ""
    echo "4. Default nice value of unbound ${WORKQUEUE} workqueue:"
    echo "$ cat /sys/devices/virtual/workqueue/${WORKQUEUE}/nice"
    cat "$SYSFS_PATH"/nice
    echo ""

    read -sn1 -p "Press any key to continue"

#5
    echo ""
    echo ""
    echo "5. Determine in which workqueue pools ${WORKQUEUE} runs by default"
    echo "Workqueue CPU -> pool"
    echo "====================="
    echo "[    workqueue     \     type   CPU  0  1  2  3  4  5  6  7 dfl]"
    echo "$ drgn tools/workqueue/wq_dump.py | grep ${WORKQUEUE}"
     drgn "$KERNEL_PATH"/wq_dump.py | grep ${WORKQUEUE}
    echo ""

    read -sn1 -p "Press any key to continue"

#6
    echo ""
    echo ""
    echo "6. Set nice to ${NEWNICE}"
    echo "$  echo ${NEWNICE} > /sys/devices/virtual/workqueue/${WORKQUEUE}/nice"
    echo "$NEWNICE" > /sys/devices/virtual/workqueue/${WORKQUEUE}/nice
    echo ""

   read -sn1 -p "Press any key to continue"

#7
    echo ""
    echo ""
    echo "7. In which workqueue pools does ${WORKQUEUE} run NOW?"
    echo "$ drgn tools/workqueue/wq_dump.py | grep ${WORKQUEUE}"
    echo ""
    echo ""
    echo "Workqueue CPU -> pool"
    echo "====================="
    echo "[    workqueue     \     type   CPU  0  1  2  3  4  5  6  7 dfl]"
    drgn "$KERNEL_PATH"/wq_dump.py | grep ${WORKQUEUE}
    echo ""

    readonly POOL=$(drgn "$KERNEL_PATH"/wq_dump.py |  grep ${WORKQUEUE}  |  awk {'print $3;'})

    read -sn1 -p "Press any key to continue"

#8
    echo ""
    echo ""
    echo "9. What are the properties of pool ${POOL}?"
    echo "$ drgn tools/workqueue/wq_dump.py | grep 'pool[${POOL}]'"
    drgn "$KERNEL_PATH"/wq_dump.py | grep "pool\[${POOL}\]"
    echo ""

    read -sn1 -p "Press any key to continue"

#9
    echo ""
    echo ""
    echo "8. What else runs in workqueue pool ${POOL}?"
    echo "$ drgn tools/workqueue/wq_dump.py | grep ${POOL}"
    drgn "$KERNEL_PATH/"/wq_dump.py | grep ${POOL}
    echo ""

    read -sn1 -p "Press any key to continue"

#10
    echo ""
    echo ""
    restore
}

main "$@"
