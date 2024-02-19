#!/bin/bash

# Observe which softirqs run most frequently.

set -e
set -u

readonly DRIVE=/dev/sda1
readonly MOUNT=/mnt/usb
readonly HOSTNAME="$(hostname)"
readonly BOARDNAME=bullseye-dev64mq

# The kernel symbols are on a USB stick.
if [[ "$BOARDNAME" == "$HOSTNAME" ]]
then
     sudo mount -o ro "$DRIVE" "$MOUNT"
fi

echo ""
echo ""
echo "$ sudo /usr/sbin/stackcount-bpfcc __do_softirq -D 10"
echo ""
sudo /usr/sbin/stackcount-bpfcc __do_softirq -D 10

if [[ "$BOARDNAME" == "$HOSTNAME" ]]
then
   sudo umount "$MOUNT"
fi
