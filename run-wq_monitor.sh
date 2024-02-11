#!/bin/bash

set -e
set -u

echo "The kernel is $(uname -r) from https://github.com/chaiken/linux/tree/wq-dump"

/usr/local/bin/drgn /home/debian/wq_monitor.py
