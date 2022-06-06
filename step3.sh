#!/bin/bash
set -euo pipefail

# Install yay
sudo pacman -Syu --noconfirm git 
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm

# Audio 
yay -Syu --noconfirm pulseaudio
pulseaudio --start

# Login manager
yay -Syu --noconfirm ly
sudo systemctl enable ly

echo Remember to reboot
