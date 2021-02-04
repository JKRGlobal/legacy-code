#!/bin/bash

#  Install-LDN-Xerox_GuyLambert.sh
#  Created by Stephen Warneford-Bygrave on 2015-09-14

# Run as root
if [[ $EUID -ne 0 ]]; then
	/bin/echo "This script must run as root."
	exit 1
fi

# Deletes existing Printers
lpadmin -x "Xerox_GuyLambert"
lpadmin -x "Xerox-GuyLambert"
lpadmin -x "Xerox_GuyLambert"
lpadmin -x "Guy's Printer"
lpadmin -x "Guy's_Printer"

# Mount software share
mkdir /Volumes/.Software
mount -t afp afp://deploy:D3pl0y11@LN01-DEP01.jkr.co.uk/Software /Volumes/.Software

# Create local software repository
mkdir /var/folders/deploy/

# Copies Xerox installer to local machine
cp -r /Volumes/.Software/Mac/Xerox/Phaser\ 3500/Current/10.7/5\ Miscellaneous/Xerox\ Phaser\ 3500.gz /Library/Printers/PPDs/Contents/Resources/
mkdir -p /Library/Printers/Xerox/Icons
cp -r /Volumes/.Software/Mac/Xerox/Phaser\ 3500/Current/10.7/5\ Miscellaneous/Deployment/* /Library/Printers/Xerox/Icons/

# Unmount software share
umount /Volumes/.Software

# Delete local software repository
rm -rf /var/folders/deploy

# Uses lpd to configure and set up Reception printer
lpadmin -p "Xerox_GuyLambert" -v lpd://192.168.211.16 -D "Xerox_GuyLambert" -E -P "/Library/Printers/PPDs/Contents/Resources/Xerox Phaser 3500.gz" -o printer-is-shared=false

exit 0