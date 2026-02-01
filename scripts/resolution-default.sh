#!/usr/bin/env bash

session="${DESKTOP_SESSION:-}"

case "$session" in
  hyprland)
    hyprctl keyword monitor desc:Xiaomi Corporation Mi Monitor,3440x1440@99.99Hz,1600x-50,auto
    ;;
  niri)
    niri msg output "Xiaomi Corporation Mi Monitor Unknown" mode 3440x1440@100
    ;;
  *)
    echo "Unsupported or unknown DESKTOP_SESSION: $session" >&2
    ;;
esac
