#!/bin/bash

set -e
set -u

readonly BOARD_IP=10.0.0.2

#0
echo ""
echo "0. Run netperf to generate network traffic on the remote:"
echo "$ netperf -H '$BOARD_IP' -t TCP_RR -r 4096 --  -o max_latency,mean_latency"
echo "TCP_RR is the test name"
netperf -H "$BOARD_IP" -t TCP_RR -r 4096 --  -o max_latency,mean_latency

