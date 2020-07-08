#!/bin/bash

# create swap file
truncate -s 0 /swap/swapfile
chattr +C /swap/swapfile
btrfs property set /swap/swapfile compression none
dd if=/dev/zero of=/swap/swapfile bs=1G count=8 status=progress
mkswap swap/swapfile
swapon /swap/swapfile

echo "/swap/swapfile none swap defaults 0 0" >> /etc/fstab

ln -sf /usr/share/zoneinfo/Australia/Melbourne /etc/localtime
hwclock --systohc

sed -i 's/^# *\(en_AU.UTF-8\)/\1/' /etc/locale.gen
locale-gen 

 echo LANG=en_AU.UTF-8 >> /etc/locale.conf

 echo leonidas >> /etc/hostname

 # vim /etc/hosts
 #127.0.0.1 localhost
#::1       localhost
#127.0.0.1 leonidas.localdomain leonidas

passwd

pacman -S grub grub-btrfs efibootmgr networkmanager network-manager-applet wpa_supplicant dialog os-prober mtools dosfstools linux-headers git reflector bluez bluez-utils cups xdg-utils xdg-user-dirs

useradd -mG wheel reaper
passwd reaper

# vim /etc/mkinitcpio.conf
# modules(btrfs)
# mkinitcpio -p linux

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader=GRUB

grub-mkconfig -o /boot//grub/grub.cfg 


