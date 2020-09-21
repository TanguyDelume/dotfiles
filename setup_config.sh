#!/bin/bash

mdkir -p ~/.config/bspwm
mdkir -p ~/.config/sxhkd

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

ln -s ${DIR}/sxhkdrc ~/.config/sxhkd/sxhkdrc
ln -s ${DIR}/bspwmrc ~/.config/bspwm/bspwmrc
ln -s ${DIR}/zshrc ~/.zshrc
ln -s ${DIR}/Xdefaults ~/.Xdefaults
