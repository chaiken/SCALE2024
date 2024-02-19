#!/bin/bash

# Observe which softirqs run most frequently.

set -e
set -u

readonly DRIVE=/dev/sda1
readonly MOUNT=/mnt/usb

sudo mount -o ro "$DRIVE" "$MOUNT"

sudo /usr/sbin/stackcount-bpfcc __do_softirq -D 10

sudo umount "$MOUNT"
