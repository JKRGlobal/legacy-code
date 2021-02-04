#!/bin/bash

#  Install-LDN-HP_NYAdmin.sh
#  Created by Stephen Warneford-Bygrave on 2015-01-08

# Run as root; check for superuser elevation (EUID) and exit if check fails
if [[ $EUID -ne 0 ]]; 
	then 
	/bin/echo "This script must run as root."
	exit 1
fi

# Removes existing print queues for NYAdmin
lpadmin -x "HP_NYAdmin"

# Mount software share
mkdir /Volumes/.Software
mount -t afp afp://deploy:D3pl0y11@LN01-DEP01.jkr.co.uk/Software /Volumes/.Software

# Copies printer PPDs to local system 
cp -r /Volumes/.Software/Mac/HP/HP\ Laserjet\ Pro\ 400/Current/1/1\ Installer/HP\ LaserJet\ 400\ M401.gz /Library/Printers/PPDs/Contents/Resources/en.lproj/
cp -r /Volumes/.Software/Mac/HP/HP\ Laserjet\ Pro\ 400/Current/1/5\ Miscellaneous/Deployment/* /Library/Printers/hp/

# Unmount Software share
umount /Volumes/.Software

# Configures printer using lpd
lpadmin -p "HP_NYAdmin" -v lpd://192.168.17.150/ -D "HP_NYAdmin" -E -P "/Library/Printers/PPDs/Contents/Resources/en.lproj/HP LaserJet 400 M401.gz" -o printer-is-shared=false

exit 0