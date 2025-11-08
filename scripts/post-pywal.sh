#!/usr/bin/env bash

attempt=0
limit=5
status=1

while [ $status -ne 0 ] && [ "$attempt" -le "$limit" ]; do
    sleep 0.5
    hyprctl hyprpaper wallpaper ",$(< "${HOME}/.cache/wal/wal")"
    status=$?
    attempt=$((attempt+1))
done

if [ "$attempt" -le "$limit" ]; then
    hyprctl reload
    systemctl --user restart dunst
fi
