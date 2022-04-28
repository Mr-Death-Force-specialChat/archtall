# WARNING
# THIS SUCKS A LOT WATCH A TUTORIAL INSTEAD
##### _but it works_

# archtall
arch install script...... i use arch btw


# how to
- boot into an live arch iso
- install git<br> ` pacman -Sy git `
- clone this repo<br> `git clone https://github.com/Mr-Death-Force-specialChat/archtall`
- run install.sh
   * `cd archtall`
   * `chmod u+x install.sh`
   * `./install.sh`
- use it... lul

# next

- ARE YOU SURE?
   * if yes press ENTER
   * if not press CTRL-C or CTRL-Z
- Get the disk from lsblk output (WARNING DO NOT PREFIX WITH /dev/ (EG. sda)
- Press enter if everything looks ok from the fdisk output if not press CTRL-C or CTRL-Z
- if prompted with `Proceed anyway? (y/N) ` press y+enter or exit
- if prompted with `ext4 journal size (or something else)` press ENTER
- put volname (EG. `lvm`)
- put volgroup name (EG. `VOLGROUP0`)
- type yes in all caps to encrypt volgroup0 ** WARNING: THIS WILL OVERWRITE THE DATA ON THE DISK IRRECOVERABLY **
- enter passphrase 3 times
   * setup (handled by cryptsetup)
   * verify (handled by cryptsetup)
   * unlock (handled by cryptsetup)
- enter root fs size (EG. 50GB for 50 gigabytes)
- wait for a while (pacstrap+chroot(kernels (lts+bleedinEdge)+etc(READ THE FUCKING SCRIPT))
- root password reset
   * enter passwd (handled by passwd)
- new user
   * enter username
   * enter passwd (handled by passwd)
   * enter passwd (handled by passwd)
- enter grub boot id (EG. `grub_uefi`)
- umount stuff
### out dated
** usless stuff here **<br>
** no need for this **
- umount `/mnt/boot/EFI`
- umount `/mnt/boot`
- umount `/mnt/home`
- umount `/mnt`
- reboot into ARCH
### now automatically does this umounting and rebooting

###### why?
