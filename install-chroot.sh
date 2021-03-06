#!/bin/bash

set -e

DGRUB=$(cat /VAR_DGRUB)
ROOT=$(cat /VAR_ROOT)
VOLGRP=$(cat /VAR_VOLGRP)
ENC_DISK=$(cat /VAR_ENCDISK)

rm /VAR_DGRUB
rm /VAR_ROOT
rm /VAR_VOLGRP
rm /VAR_ENCDISK

echo Install lts linux\? \(Y/n\)
read LTS_LINUX

if [ $LTS_LINUX == '' ] || [ $LTS_LINUX == 'y' ]; then
LTS_LINUX='Y'
else
LTS_LINUX='N'
fi

echo $LTS_LINUX>/VAR_LTS_LINUX_KERNEL

if [ $LTS_LINUX == 'Y' ]; then
pacman -S linux linux-headers linux-lts linux-lts-headers <<EEOF



EEOF
else
pacman -S linux linux-headers <<EEOF



EEOF
fi

pacman -S vim base-devel networkmanager lvm2 <<EEOF




EEOF

systemctl enable NetworkManager

if [ $ENC_DISK == 'Y' ]; then
sed -i 's/block filesystems/block encrypt lvm2 filesystems/g' /etc/mkinitcpio.conf
else
sed -i 's/block filesystems/block lvm2 filesystems/g' /etc/mkinitcpio.conf
fi
mkinitcpio -p linux
if [ $LTS_LINUX == 'Y' ]; then
mkinitcpio -p linux-lts
fi

sed -i 's/\#en_US.UTF-8/en_US.UTF-8/g' /etc/locale.gen
locale-gen

echo Root password
passwd
echo User name
read username

echo $username>USERNAME.DLME

useradd -m -g users -G wheel $username
passwd $username

if [ ! -f $(which sudo)  ]
then
	pacman -S sudo <<EEOF


EEOF
fi

visudo <<EEOF
/# %wheel ALL=(ALL:ALL) ALL
x
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

if [ ENC_DISK == 'Y' ]; then
sed -i 's/#GRUB_ENABLE_CRYPTODISK=y/GRUB_ENABLE_CRYPTODISK=y/g' /etc/default/grub
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet"/GRUB_CMDLINE_LINUX_DEFAULT="cryptdevice=\/dev\/'${ROOT}':'${VOLGRP}':allow-discards loglevel=3"/g' /etc/default/grub
else
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet"/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3"/g' /etc/default/grub
fi

grub-mkconfig -o /boot/grub/grub.cfg

exit
