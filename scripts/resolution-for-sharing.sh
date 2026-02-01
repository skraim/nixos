#!/usr/bin/env bash

session="${DESKTOP_SESSION:-}"

case "$session" in
    hyprland)
        hyprctl keyword monitor desc:Xiaomi Corporation Mi Monitor,1920x1080,auto-right,auto
        ;;
    niri)
        niri msg output "Xiaomi Corporation Mi Monitor Unknown" mode 1920x1080
        ;;
    *)
        echo "Unsupported or unknown DESKTOP_SESSION: $session" >&2
        ;;
esac

