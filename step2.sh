#!/bin/bash
set -euo pipefail

# Setup locale
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf

# Set hostname
echo cpwdtoast > /etc/hostname

# Setup boot loader
pacman -S --noconfirm grub efibootmgr intel-ucode amd-ucode 
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
printf "\nGRUB_HIDDEN_TIMEOUT=0\nGRUB_TIMEOUT=0\n" > /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

# Workaround for some old computers
mkdir /boot/EFI/boot
cp /boot/EFI/grub/grubx64.efi /boot/EFI/boot/bootx64.efi

# Setup network
pacman -S --noconfirm networkmanager
systemctl enable NetworkManager.service

# Setup time
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
hwclock --systohc --utc

# Setup sudo
echo 'ALL ALL=(ALL:ALL) NOPASSWD: ALL' | EDITOR='tee -a' visudo

# Setup system user
useradd -m cpwd
passwd -d cpwd

# Setup yay
pacman -S --noconfirm git 
cd /home/cpwd
sudo -u cpwd git clone https://aur.archlinux.org/yay.git
cd yay
sudo -u cpwd makepkg -si --noconfirm
cd /root
rm -rf /home/cpwd/yay

# Setup audio 
pacman -S --noconfirm pulseaudio

# Setup login manager
sudo -u cpwd yay -S --noconfirm ly xorg-server
systemctl enable ly

# Clean up
rm /step2.sh
exit
