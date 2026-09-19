#!/usr/bin/env bash

PPP=$(ip -j a | jq -r '.[] | select(.ifname == "ppp0")')
if [ -n "$PPP" ]; then
    nmcli connection down SC_VPN
    printf '%s\n' 'vpn_status {"name":"SC_VPN","state":"disconnected"}'
    exec notify-send -t 2000 -a "SC_VPN" -i "$HOME/.icons/custom/vpn-off.svg" "Disconnected"
else
    vpn-disconnect.sh >/dev/null
    nmcli connection up SC_VPN
    printf '%s\n' 'vpn_status {"name":"SC_VPN","state":"connected"}'
    exec notify-send -t 2000 -a "SC_VPN" -i "$HOME/.icons/custom/vpn-on.svg" "Connected"
fi
