# WARNING
# THIS WILL NOT WORK AND WILL NOT PROPERLY INSTALL ARCH

# archtall
arch install script...... i use arch btw


# how to
- boot into an live arch iso
- install git<br> ` pacman -Sy git `
- clone this repo<br> `git clone https://github.com/Mr-Death-Force-specialChat/archtall`
- run install.sh<br> `cd archtall`<br>`chmod u+x install.sh`<br>`./install.sh`
- use it... lul
<br>
<br>
- ARE YOU SURE?<br>	if yes press ENTER if not press CTRL-C or CTRL-Z
- Get the disk from lsblk output (WARNING DO NOT PREFIX WITH /dev/<br>	EG. sda
- Press enter if everything looks ok from the fdisk output if not press CTRL-C or CTRL-Z
- if prompted with `Proceed anyway? (y/N) ` press y+enter or exit
- if prompted with `ext4 journal size (or something else)` press ENTER
- put volname (EG. `lvm`)
- put volgroup name (EG. `VOLGROUP0`)
- type yes in all caps to encrypt volgroup0 THIS WILL OVERWRITE THE DATA IRRECOVERABLY
- enter passphrase 3 times (setup, verify, unlock)
- enter root fs size (EG. 50GB for 50 gigabytes)
- wait for a while (pacstrap+chroot(kernels (lts+bleedinEdge)+etc(READ THE FUCKING SCRIPT))
- root password reset
- new user<br>	enter username<br>	enter passwd<br>	enter passwd
- enter grub boot id (EG. `grub_uefi`)
- umount stuff
<br>
<br>
- umount `/mnt/boot/EFI`
- umount `/mnt/boot`
- umount `/mnt/home`
- umount `/mnt`
- reboot into ARCH

###### why?
