#!/bin/bash


pacman -Syy --noconfirm reflector

reflector -c Australia --sort rate --save /etc/pacman.d/mirrorlist

pacman -Syy

timedatectl set-ntp true

lsblk

gdisk /dev/nvme0n1

gdisk /dev/sda

lsblk

mkfs.fat -F32 -n EFI /dev/nvme0n1p1

mkfs.btrfs -d single --force --label Arch /dev/nvme0n1p2 /dev/sda1

mount -t btrfs LABEL=Arch /mnt

btrfs su cr /mnt/@root 
btrfs su cr /mnt/@home
btrfs su cr /mnt/@var
btrfs su cr /mnt/@srv
btrfs su cr /mnt/@opt
btrfs su cr /mnt/@tmp
btrfs su cr /mnt/@swap
btrfs su cr /mnt/@.snapshots

o=defaults,x-mount.mkdir

o_btrfs=$o,compress=lzo,ssd,noatime

umount /mnt/

mount -t btrfs -o subvol=@root,$o_btrfs LABEL=Arch /mnt

mkdir /mnt/{boot,home,var,svr,opt,tmp,swap,.snapshots}

mount -t btrfs -o subvol=@home,$o_btrfs LABEL=Arch /mnt/home
mount -t btrfs -o subvol=@srv,$o_btrfs LABEL=Arch /mnt/srv
mount -t btrfs -o subvol=@tmp,$o_btrfs LABEL=Arch /mnt/tmp
mount -t btrfs -o subvol=@opt,$o_btrfs LABEL=Arch /mnt/opt
mount -t btrfs -o subvol=@snapshots,$o_btrfs LABEL=Arch /mnt/.snapshots
mount -t btrfs -o subvol=@swap,nodatacow LABEL=Arch /mnt/swap
mount -t btrfs -o subvol=@var,nodatacow LABEL=Arch /mnt/var
mount /dev/nvme0n1p1 /mnt/boot

pacstrap /mnt base base-devel linux linux-firmware vim intel-ucode btrfs-progs

genfstab -U /mnt >> /mnt/etc/fstab 

arch-chroot /mnt

