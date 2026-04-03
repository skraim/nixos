#!/usr/bin/env bash

TS=$(ip -j a | jq -r '.[] | select(.ifname == "tailscale0") | .addr_info[] | select(.family == "inet")')
if [ -n "$TS" ]; then
    tailscale down
    exec notify-send -t 2000 -a "Tailscale" -i "$HOME/.icons/custom/vpn-off.svg" "Disconnected"
else
    tailscale up
    exec notify-send -t 2000 -a "Tailscale" -i "$HOME/.icons/custom/vpn-on.svg" "Connected"
fi
