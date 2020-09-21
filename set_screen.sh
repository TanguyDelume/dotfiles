#!/bin/bash

# detect secondary screen and set bspwm options for razer blade config

term_disco=$(xrandr | grep "HDMI-0 disconnected")
if [ -z "$term_disco" ]; then
	echo "two screen"
	xrandr --output HDMI-0 --primary --left-of eDP-1-1
	bspc monitor HDMI-0 -d I II III IV V VI VII VIII IX X
else
	echo "one screen"
	xrandr --output eDP-1-1 --primary
	bspc monitor eDP-1-1 -d I II III IV V VI VII VIII IX X
fi
