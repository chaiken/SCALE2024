#!/bin/bash

set -e
set -u

readonly SYSFS_PATH=/sys/devices/platform/soc@0/30800000.bus/30be0000.ethernet/net/eth0/threaded
readonly DEVICE=/dev/sda1
readonly MOUNTPOINT=/mnt/usb
readonly OFF=0
readonly ON=1

# preliminary, because kernel symbols are on a USB stick
if  [[ -z $(mount | grep "$MOUNTPOINT") ]]
then
    mount -o ro "$DEVICE" "$MOUNTPOINT"
fi

#0
echo ""
echo "Demo will not work before v5.12."
echo "0.  Kernel version  $(uname -r)"
echo "Demo kernel is available from https://github.com/chaiken/linux"
echo ""

read -sn1 -p "Press any key to continue"

echo "***WITHOUT threaded NAPI***"

#1
echo ""
echo ""
echo "1. Find network devices whose NET_RX softirqs can be moved to another thread:"
echo "$ sudo find /sys/ -name threaded"
sudo find /sys/ -name threaded |  grep -v virtual
echo ""
echo "$ cat ${SYSFS_PATH}"
cat "$SYSFS_PATH"
echo ""
echo ""

read -sn1 -p "START NETPERF!!"


#2
echo ""
echo ""
echo "2. See if any threads whose names include 'napi' are running:"
echo "$ ps ax | grep napi"
# Intentionally mask failing return value.
readonly result1="$(ps ax |  grep napi |  grep -v grep  |  grep -v bash |  grep -v demo)"
echo "$result1"
echo ""

read -sn1 -p "Press any key to continue"

#3
echo ""
echo ""
echo "3. See if any threads called 'napi' are burning CPU time:"
echo "$ top -n 1| grep napi"
# Intentionally mask failing return value.
readonly result2="$(top -n 1  | grep napi)"
echo "$result2"
echo ""

read -sn1 -p "Press any key to continue"

#4
echo ""
echo ""
echo "4. Check on NET_RX softirqs:"
echo "$ softirqs-bpfcc"
/usr/sbin/softirqs-bpfcc 2 10
echo ""

read -sn1 -p "RESTART NETPERF!"

echo "----------------------------------------------------"

echo "***WITH threaded NAPI***"
echo ""
echo ""

#5
echo "5. echo "$ON" > ${SYSFS_PATH}"
echo "$ON" > "${SYSFS_PATH}"
echo ""

#6
echo ""
echo ""
echo "6. See if any threads whose names include 'napi' are running NOW:"
echo "$ ps ax | grep napi"
# Intentionally mask failing return value.
readonly result3="$(ps ax |  grep napi |  grep -v grep  |  grep -v bash |  grep -v demo)"
echo "$result3"
echo ""

#7
echo ""
echo ""
echo "7. See if any threads called 'napi' are burning CPU time:"
echo "$ top -n 1| grep napi"
# Intentionally mask failing return value.
readonly result4="$(top -n 1  | grep napi)"
echo "$result4"
echo ""

read -sn1 -p "Press any key to continue"

#8
echo ""
echo ""
echo "8. Check on NET_RX softirqs:"
echo "$ softirqs-bpfcc"
/usr/sbin/softirqs-bpfcc 2 10

#9
echo ""
echo ""
echo "Turn threaded NAPI off, although spawned thread remains until reboot."
echo "$ echo ${OFF} > ${SYSFS_PATH}"
echo "$OFF" > "${SYSFS_PATH}"
echo ""

umount "$DEVICE"; sync
