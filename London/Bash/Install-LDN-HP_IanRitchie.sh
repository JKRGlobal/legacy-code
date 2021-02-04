#!/bin/bash

#  Install-LDN-HP_IanRitchie.sh
#  Created by Stephen Warneford-Bygrave on 2015-12-02

# Run as root; check for superuser elevation (EUID) and exit if check fails
if [[ $EUID -ne 0 ]]; then 
	/bin/echo "ERROR: Not running as root user. Terminating...."
	exit 1
fi

# Define variables
osvers=$(sw_vers -productVersion | awk -F. '{print $2}')
if [[ ${osvers} -ge 10 ]]; then
	ppdloc=/Library/Printers/PPDs/Contents/Resources 
else
	ppdloc=/Library/Printers/PPDs/Contents/Resources/en.lproj
fi

# Deletes existing HR Printers
lpadmin -x "Xerox_GuyLambert"
lpadmin -x "Xerox-GuyLambert"
lpadmin -x "Xerox_GuyLambert"
lpadmin -x "Guy's Printer"
lpadmin -x "Guy's_Printer"
lpadmin -x "HP_GuyLambert"
lpadmin -x "HP_Spare"
lpadmin -x "HP_IanRitchie"
lpadmin -x "HP_JohnEwles"

# Mount Software folder
mkdir /Volumes/.Software
mount -t afp "afp://deploy:D3pl0y11@LN01-DEP01.jkr.co.uk/Software" "/Volumes/.Software"

# Create local software repository
mkdir "/var/folders/deploy/"

# Copy HP installer
cp -r "/Volumes/.Software/Mac/HP/HP Laserjet Pro 400/Current/12.34.45/1 Installer/HP LaserJet SW OSX Mavericks.pkg" "/var/folders/deploy/"

# Unmount Software folder
umount "/Volumes/.Software"

# Install driver
installer -pkg "/var/folders/deploy/HP LaserJet SW OSX Mavericks.pkg" -target /

# Configure printers using lpd
lpadmin -p "HP_IanRitchie" -v lpd://192.168.211.17/ -D "HP_IanRitchie" -E -P "$ppdloc/HP LaserJet 400 M401.gz" -o printer-is-shared=false

exit 0