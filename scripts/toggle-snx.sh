#!/usr/bin/env bash

SNX=$(ip -j a | jq -r '.[] | select(.ifname == "snx-xfrm")')
if [ -n "$SNX" ]; then
    snxctl disconnect
    exec dunstify -t 2000 -a "SNX" "Disconnected"
else
    connect-snx.sh
fi
