#!/bin/bash

source $HOME/states

TUN=$(ip -j a | jq -r '.[] | select(.ifname == "tun0")')
if [ -n "$TUN" ]; then
    sudo gpclient disconnect
else
    sudo gpclient --ignore-tls-errors --fix-openssl connect --as-gateway $GP_GATEWAY --os Windows -u $GP_USER > /dev/null 2>&1 &
fi
