#!/bin/bash

#  Install-LDN-Xerox_HannahSanders.sh
#  Created by Stephen Warneford-Bygrave on 2015-01-08

# Run as root
if
	[[ $EUID -ne 0 ]];
then
	/bin/echo "This script must run as root."
	exit 1
fi

# Deletes existing Printers
lpadmin -x "Xerox_HannahSanders"
lpadmin -x "Xerox_HannahSanders"

# Mount software share
mkdir /Volumes/.Software
mount -t afp afp://deploy:D3pl0y11@LN01-DEP01.jkr.co.uk/Software /Volumes/.Software

# Create local software repository
mkdir /var/folders/deploy/

# Copies Xerox installer to local machine
cp -r /Volumes/.Software/Mac/Xerox/Phaser\ 3600/Current/1/1\ Installer/Phaser\ 3600.pkg /var/folders/deploy/

# Run installer
installer -pkg /var/folders/deploy/Phaser\ 3600.pkg -target /

# Unmount software share
umount /Volumes/.Software

# Delete local software repository
rm -rf /var/folders/deploy

# Uses lpd to configure and set up Reception printer
lpadmin -p "Xerox_HannahSanders" -v lpd://192.168.211.14 -D "Xerox_HannahSanders" -E -P "/Library/Printers/PPDs/Contents/Resources/Xerox Phaser 3600.gz" -o printer-is-shared=false

exit 0