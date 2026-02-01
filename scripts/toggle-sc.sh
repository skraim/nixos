#!/usr/bin/env bash

PPP=$(ip -j a | jq -r '.[] | select(.ifname == "ppp0")')
if [ -n "$PPP" ]; then
    nmcli connection down SC_VPN
    exec dunstify -t 2000 -a "SC_VPN" -i "$HOME/.icons/custom/vpn-off.svg" "Disconnected"
else
    nmcli connection up SC_VPN
    exec dunstify -t 2000 -a "SC_VPN" -i "$HOME/.icons/custom/vpn-on.svg" "Connected"
fi
