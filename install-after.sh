#!/bin/bash

LTS_LINUX=$(cat /VAR_LTS_LINUX_KERNEL)
sudo rm /VAR_LTS_LINUX_KERNEL

echo Enter your password
sudo id

sudo rm -r /etc/pacman.d/gnupg
sudo pacman-key --init
sudo pacman -S archlinux-keyring <<EEOF







EEOF
sudo pacman-key --populate archlinux

echo ----------------------------------------------------------------------------------
echo \|					Installing microcode					  \|
echo ----------------------------------------------------------------------------------

proc_type=$(lscpu)
if grep -E "GenuineIntel" <<< ${proc_type}; then
	echo "Intel"
	sudo pacman -S --noconfirm --needed intel-ucode
elif grep -E "AuthenticAMD" <<< ${proc_type}; then
	echo "Installing AMD microcode"
	sudo pacman -S --noconfirm --needed amd-ucode
fi

echo ----------------------------------------------------------------------------------
echo \|				   Installing graphics driver				  	  \|
echo ----------------------------------------------------------------------------------

gpu_type=$(lspci)
if grep -E "NVIDIA|GeForce" <<< ${gpu_type}; then
	if [ $LTS_LINUX == 'Y' ]; then
		sudo pacman -S --noconfirm --needed nvidia nvidia-lts nvidia-xconfig
	else
		sudo pacman -S --noconfirm --needed nvidia nvidia-xconfig
	fi
elif lspci | grep 'VGA' | grep -E "Radeon|AMD"; then
	sudo pacman -S --noconfirm --needed xf86-video-amdgpu
elif grep -E "Integrated Graphics Controller" <<< ${gpu_type}; then
	sudo pacman -S --noconfirm --needed libva-intel-driver libvdpau-va-gl lib32-vulkan-intel vulkan-intel libva-intel-driver libva-utils lib32-mesa
elif grep -E "Intel Corporation UHD" <<< ${gpu_type}; then
	sudo pacman -S --needed --noconfirm libva-intel-driver libvdpau-va-gl lib32-vulkan-intel vulkan-intel libva-intel-driver libva-utils lib32-mesa
fi

echo Do you want to install kde?
read KDE

if [ $KDE == 'y' ]; then
	KDE = Y
fi

if [ $KDE == 'Y' ]; then

echo ----------------------------------------------------------------------------------
echo \|					Installing KDE						  \|
echo ----------------------------------------------------------------------------------

sudo pacman -S plasma-meta kde-applications << EEOF













EEOF
sudo systemctl enable sddm
fi

sudo pacman -Syu zsh << EEOF
















EEOF

sed -i 's/\/bash install-after.sh//g' ~/.bashrc
echo Done! just reboot
