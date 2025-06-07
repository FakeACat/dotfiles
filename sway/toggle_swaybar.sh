#!/bin/bash

[ $(swaymsg -t get_bar_config bar-0 | rg '"mode": ' | awk -F\" '{print $4}') = "overlay" ] && swaymsg bar mode invisible || swaymsg bar mode overlay
