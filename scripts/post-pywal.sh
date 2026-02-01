#!/usr/bin/env bash

attempt=0
limit=5
status=1

session="${DESKTOP_SESSION:-}"

orig_img="$(< "${HOME}/.cache/wal/wal")"

img_dir="$(dirname "$orig_img")"
img_name="$(basename "$orig_img")"
blur_dir="${img_dir}/blured"
blur_img="${blur_dir}/${img_name}"

if [ "$session" = "niri" ]; then
    mkdir -p "$blur_dir"

    if [ ! -f "$blur_img" ]; then
        magick "$orig_img" -blur 0x80 "$blur_img"
    fi
fi

while [ "$status" -ne 0 ] && [ "$attempt" -le "$limit" ]; do
    sleep 0.5
    awww img "$orig_img"

    if [ "$session" = "niri" ]; then
        swaybg -i "$blur_img" &
    fi

    status=$?
    attempt=$((attempt + 1))
done

if [ "$attempt" -le "$limit" ]; then
    if [ "$session" = "hyprland" ]; then
        hyprctl reload
    fi

    systemctl --user restart dunst
fi
