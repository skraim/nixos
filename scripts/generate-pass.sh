#!/usr/bin/env bash

source "$HOME"/.config/rofi/applets/shared/theme.bash
theme="$type/$style"
efonts="JetBrains Mono Nerd Font 12"

prefix=${PASSWORD_STORE_DIR-~/.password-store}
password_files=( "$prefix"/general/**/*.gpg )
password_files=( "${password_files[@]#"$prefix"/}" )
password_files=( "${password_files[@]%.gpg}" )
pass_key=$(rofi \
    -theme-str "element-text {font: \"$efonts\";}" \
    -theme-str 'textbox-prompt-colon {str: " ";}' \
    -theme-str "window {width: 600px;}" \
    -theme-str "entry {placeholder: \"Enter Pass Key\";}" \
    -theme-str "listview {lines: 0;}" \
    -dmenu \
    -mesg "E.g. general/[personal,work]/example.com" \
    -theme ${theme})

[[ -n $pass_key ]] || exit

pass generate -f $pass_key
