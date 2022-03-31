#!/bin/bash

set -e

DGRUB=$(cat /VAR_DGRUB)
ROOT=$(cat /VAR_ROOT)
VOLGRP=$(cat /VAR_VOLGRP)

rm /VAR_DGRUB
rm /VAR_ROOT
rm /VAR_VOLGRP

pacman -S linux linux-headers linux-lts linux-lts-headers <<EEOF



EEOF

pacman -S vim base-devel networkmanager lvm2 <<EEOF




EEOF

systemctl enable NetworkManager

sed -i 's/block filesystems/block encrypt lvm2 filesystems/g' /etc/mkinitcpio.conf

mkinitcpio -p linux
mkinitcpio -p linux-lts

sed -i 's/\#en_US.UTF-8/en_US.UTF-8/g' /etc/locale.gen
locale-gen

echo Root password
passwd
echo User name
read username
useradd -m -g users -G wheel $username
passwd $username

if [ ! -f $(which sudo)  ]
then
	pacman -S sudo <<EEOF


EEOF
fi

visudo <<EEOF
/# %wheel ALL=(ALL) ALL
x
:w
:q

EEOF

pacman -S grub efibootmgr dosfstools mtools os-prober <<EEOF


EEOF

mkdir /boot/EFI
mount $DGRUB /boot/EFI

echo Bootloader id \(Entry name\)
read BOOTID

grub-install --target=x86_64-efi --bootloader-id=$BOOTID --recheck

if [ ! -d "/boot/grub/locale" ]
then
	mkdir /boot/grub/locale
fi

cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo

sed -i 's/#GRUB_ENABLE_CRYPTODISK=y/GRUB_ENABLE_CRYPTODISK=y/g' /etc/default/grub
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet"/GRUB_CMDLINE_LINUX_DEFAULT="cryptdevice=\/dev\/${ROOT}:${VOLGRP}:allow-discards loglevel=3"/g' /etc/default/grub

grub-mkconfig -o /boot/grub/grub.cfg
