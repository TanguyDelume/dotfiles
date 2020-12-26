#!/bin/bash

mkdir -p ~/.config/bspwm
mkdir -p ~/.config/sxhkd
mkdir -p ~/.config/compton
mkdir -p ~/.config/lemonbar

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


ln -sf ${DIR}/wall.sh ~/.config/wall.sh
ln -sf ${DIR}/lemonbar.config ~/.config/lemonbar/lemonbar.config
ln -sf ${DIR}/lemonbar_conky ~/.config/lemonbar/lemonbar_conky
ln -sf ${DIR}/run_lemonbar.sh ~/.config/lemonbar/run_lemonbar.sh
ln -sf ${DIR}/sxhkdrc ~/.config/sxhkd/sxhkdrc
ln -sf ${DIR}/bspwmrc ~/.config/bspwm/bspwmrc
ln -sf ${DIR}/compton.conf ~/.config/compton/compton.conf
ln -sf ${DIR}/zshrc ~/.zshrc
ln -sf ${DIR}/Xdefaults ~/.Xdefaults
