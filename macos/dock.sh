#!/bin/sh

dockutil --no-restart --remove all

dockutil --add '/Applications' --view grid --display folder --allhomes
dockutil --add '~/Downloads' --view grid --display folder --allhomes

killall Dock