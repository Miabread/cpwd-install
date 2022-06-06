#!/bin/bash
set -euo pipefail

# Set hostname
echo cpwdtoast > /etc/hostname

# Setup boot loader
pacman -S --noconfirm grub efibootmgr intel-ucode amd-ucode 
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
grub-mkconfig -o /boot/grub/grub.cfg
mkdir /boot/EFI/boot
cp /boot/EFI/grub/grubx64.efi /boot/EFI/boot/bootx64.efi

# Setup network
pacman -S --noconfirm networkmanager
systemctl enable NetworkManager.service

# Setup locale
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf

# Setup time
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
hwclock --systohc --utc

# Setup sudo
echo 'ALL ALL=(ALL:ALL) NOPASSWD: ALL' | EDITOR='tee -a' visudo

# Setup part3
useradd -m cpwd
curl https://jamesbeeprog.github.io/cpwd-install/step3.sh > /home/cpwd/step3.sh
chmod +x /home/cpwd/step3.sh

# Clean up
rm /step2.sh
exit
