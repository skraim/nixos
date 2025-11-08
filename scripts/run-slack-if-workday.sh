#!/usr/bin/env bash

[ $(date +%u) -lt 6 ] && slack --enable-features=UseOzonePlatform --ozone-platform=wayland
