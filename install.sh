#!/bin/bash

set -e

echo ARE YOU SURE?
echo press enter to install
echo press CTRL-C to exit
echo press CTRL-Z to force exit

read

echo sel disk
lsblk
echo WARNING!: This will overwrite the ENTIRE disk
echo NOTICE: Do not add /dev/

read DISK
DDISK="/dev/$DISK"
DGRUB="/dev/${DISK}1"
DBOOT="/dev/${DISK}2"
DROOT="/dev/${DISK}3"
GRUB="${DISK}1"
BOOT="${DISK}2"
ROOT="${DISK}3"
fdisk $DDISK <<EEOF
q

EEOF

echo press enter...
read

fdisk $DDISK <<EEOF
g
n


+500M
t

1
n


+500M
n



t

30
p
w

EEOF

mkfs.fat -F32 $DGRUB
mkfs.ext4 $DBOOT

echo Enter volume name \(EG. \"lvm\"\)
read PHYSVOL
echo Enter volume group name \(EG. \"VOLGROUP0\"\)
read VOLGRP
echo Encrypting disk
cryptsetup luksFormat $DROOT
cryptsetup open --type luks $DROOT $PHYSVOL

pvcreate --dataalignment 1m /dev/mapper/$PHYSVOL
vgcreate $VOLGRP /dev/mapper/$PHYSVOL

echo Root part size \(Format: XXGB = XX gigabytes\)
read ROOTSZ

lvcreate -L $ROOTSZ $VOLGRP -n root_part
lvcreate -l 100%FREE $VOLGRP -n home_part

modprobe dm_mod
vgscan
vgchange -ay

mkfs.ext4 /dev/$VOLGRP/root_part
mount /dev/$VOLGRP/root_part /mnt

mkdir /mnt/boot
mount $DBOOT /mnt/boot

mkfs.ext4 /dev/$VOLGRP/home_part

mkdir /mnt/home
mount /dev/$VOLGRP/home_part /mnt/home

mkdir /mnt/etc
genfstab -U -p /mnt >> /mnt/etc/fstab

echo Fstab:
cat /mnt/etc/fstab

pacstrap -i /mnt base << EEOF


EEOF

cp install-chroot.sh /mnt/install-chroot.sh
chmod u+x /mnt/install-chroot.sh
echo $DGRUB>/mnt/VAR_DGRUB
echo $ROOT>/mnt/VAR_ROOT
echo $VOLGRP>/mnt/VAR_VOLGRP

arch-chroot /mnt /install-chroot.sh

rm /mnt/install-chroot.sh
mv install-after.sh /mnt/install-after.sh
USERNAME=$(cat /mnt/USERNAME.DLME)
rm /mnt/USERNAME.DLME
echo "\n\n/install-after.sh" | tee -a /mnt/home/$USERNAME/.bashrc
chmod u+x /mnt/install-after.sh

umount /mnt/boot/EFI
umount /mnt/boot
umount /mnt/home
umount /mnt

echo Restarting in
echo 5 seconds...
sleep 1s
echo 4 seconds...
sleep 1s
echo 3 seconds...
sleep 1s
echo 2 seconds...
sleep 1s
echo 1 seconds...
sleep 1s
echo Rebooting...
reboot
