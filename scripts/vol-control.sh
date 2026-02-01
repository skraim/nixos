#!/usr/bin/env bash

if [[ "$1" == "inc" ]]; then
    wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+
elif [[ "$1" == "dec" ]]; then
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
elif [[ "$1" == "mute" ]]; then
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
fi

mute_status=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $3}')
if [[ "$mute_status" == "[MUTED]" ]]; then
    dunstify -r 1 -a "Volume" -i "$HOME/.icons/custom/volume-mute.svg" "Muted" -t 2000
else
    new_volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2}')
    percent_volume=$(printf "%.0f" $(echo "$new_volume * 100" | bc))
    dunstify -r 1 -h int:value:$((percent_volume)) -a "Volume" -i "$HOME/.icons/custom/volume.svg" "$percent_volume%" -t 2000
fi
