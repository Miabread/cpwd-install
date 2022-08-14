#!/bin/bash
set -euxo pipefail

# Select disk
lsblk
read -e -p "Enter disk path: " DRIVE

# Partiton the disk
parted $DRIVE --script mklabel gpt
parted $DRIVE --script mkpart ESP fat32 1MiB 513MiB
parted $DRIVE --script set 1 boot on
parted $DRIVE --script mkpart primary ext4 513MiB 100%

# Format the parititons
mkfs.fat -F32 "${DRIVE}1"
mkfs.ext4 "${DRIVE}2"

# Mount them
mount "${DRIVE}2" /mnt
mkdir /mnt/boot
mount "${DRIVE}1" /mnt/boot

# Install base and kernal packages
pacstrap /mnt base linux linux-firmware base-devel

# Save mount layout
genfstab -U /mnt >> /mnt/etc/fstab

# Change into the computer
curl https://jamesbeeprog.github.io/cpwd-install/step2.sh > /mnt/step2.sh
arch-chroot /mnt /bin/bash /step2.sh
