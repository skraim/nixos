#!/usr/bin/env bash

source "$HOME"/.config/rofi/applets/shared/theme.bash
theme="$type/$style"
efonts="JetBrains Mono Nerd Font 12"

otp_url=$(grim -g "$(slurp)" - | zbarimg - -q --raw)

[[ -n $otp_url ]] || exit

otp_key=$(rofi \
    -theme-str "element-text {font: \"$efonts\";}" \
    -theme-str 'textbox-prompt-colon {str: " ";}' \
    -theme-str "window {width: 600px;}" \
    -theme-str "entry {placeholder: \"Enter OTP Key\";}" \
    -theme-str "listview {lines: 0;}" \
    -dmenu \
    -mesg "E.g. otp/[personal,work]/example.com" \
    -theme ${theme})

[[ -n $otp_key ]] || exit

echo "$otp_url" | pass otp insert $otp_key
