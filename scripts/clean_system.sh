#!/bin/sh
sudo pacman -Rns $(pacman -Qtdq) && paccache -rk2
