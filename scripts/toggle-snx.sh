#!/usr/bin/env bash

SNX=$(ip -j a | jq -r '.[] | select(.ifname == "snx-xfrm")')
if [ -n "$SNX" ]; then
    snxctl disconnect
    printf '%s\n' 'vpn_status {"name":"SNX","state":"disconnected"}'
    exec notify-send -t 2000 -a "SNX" -i "$HOME/.icons/custom/vpn-off.svg" "Disconnected"
else
    vpn-disconnect.sh >/dev/null
    connect-snx.sh
fi
