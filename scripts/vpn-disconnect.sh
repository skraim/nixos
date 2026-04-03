#!/usr/bin/env bash
set -euo pipefail

disconnected=false
gateway=""

if command -v tailscale >/dev/null 2>&1; then
    if ip -j a | jq -e '.[] | select(.ifname == "tailscale0") | .addr_info[] | select(.family == "inet")' >/dev/null 2>&1; then
        tailscale down
        disconnected=true
    fi
fi

if command -v snxctl >/dev/null 2>&1; then
    if snxctl status 2>/dev/null | grep -q "Connected since:"; then
        gateway="$(snxctl status | awk -F': +' '/Server name:/ {print $2; exit}')"
        snxctl disconnect
        disconnected=true
    fi
fi

if command -v nmcli >/dev/null 2>&1; then
    mapfile -t vpn_uuids < <(
        nmcli -t -f UUID,TYPE connection show --active \
        | awk -F: '$2 == "vpn" {print $1}'
    )

    if (( ${#vpn_uuids[@]} > 0 )); then
        for uuid in "${vpn_uuids[@]}"; do
            if [[ -z "$gateway" ]]; then
                gateway="$(
                    nmcli connection show "$uuid" \
                    | awk '
                        /vpn.data:/ {
                            if (match($0, /gateway = ([^,]+)/, m)) {
                                print m[1]
                                exit
                            }
                        }
                    '
                )"
            fi

            nmcli connection down "$uuid"
            disconnected=true
        done
    fi
fi

if [[ "$disconnected" = false ]]; then
    exit 1
fi

msg_main="VPN disconnected."
msg_gw=""
[[ -n "$gateway" ]] && msg_gw+="Gateway: $gateway"

exec notify-send \
    -a "VPN" \
    -t 2000 \
    -i "$HOME/.icons/custom/vpn-off.svg" \
    "$msg_main" \
    "$msg_gw"
