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


