#!/bin/sh

#  Install-LDN-HP_Reception.sh
#
#
#  Created by Stephen Warneford-Bygrave on 15/06/2015.
#

# Run as root

if

[[ $EUID -ne 0 ]]; then
/bin/echo "This script must run as root."

# Not running as root.

exit 1

fi

# Removes existing print queues for NYAdmin

lpadmin -x "HP_Reception"

# Mount software share

mkdir /Volumes/.Software
mount -t afp afp://deploy:D3pl0y11@LN01-DEP01.jkr.co.uk/Software /Volumes/.Software

# Create local software repository

mkdir /var/folders/deploy/

# Copy installers to local machine

cp -r /Volumes/.Software/Mac/HP/HP\ Laserjet\ P1102w/Current/1/1\ Installer/HP\ Laserjet\ 1102w.pkg /var/folders/deploy/

# Installs drivers

installer -pkg /var/folders/deploy/HP\ Laserjet\ 1102w.pkg -target /

# Unmount Software share

umount /Volumes/.Software

# Configures printer using lpd

lpadmin -p "HP_Reception" -v lpd://192.168.244.200/ -D "HP_Reception" -E -P "/Library/Printers/PPDs/Contents/Resources/hp1100w.ppd.gz" -o printer-is-shared=false

exit 0

# 15/06/2015  v1.0.1	Stephen Bygrave		Initial release