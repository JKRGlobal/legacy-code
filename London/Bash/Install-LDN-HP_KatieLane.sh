#!/bin/bash

#  Install-LDN-HP_KatieLane.sh
#  Created by Stephen Warneford-Bygrave on 2015-01-08

# Run as root; check for superuser elevation (EUID) and exit if check fails
if [[ $EUID -ne 0 ]]; then 
	/bin/echo "ERROR: Not running as root user. Terminating...."
	exit 1
fi

# Define variables
osvers=$(sw_vers -productVersion | awk -F. '{print $2}')
if [[ ${osvers} -ge 10 ]]; then
	ppdloc=/Library/Printers/PPDs/Contents/Resources/ 
else
	ppdloc=/Library/Printers/PPDs/Contents/Resources/en.lproj
fi

# Deletes existing HR Printers
lpadmin -x "HR_Printer"
lpadmin -x "jkr_hr"
lpadmin -x "hr_printer"
lpadmin -x "HP_KatieLane"
lpadmin -x "HP_HR"
lpadmin -x "HP-KatieLane"

# Mount Software folder
mkdir /Volumes/.Software
mount -t afp afp://deploy:D3pl0y11@LN01-DEP01.jkr.co.uk/Software /Volumes/.Software

# Create local software repository
mkdir /var/folders/deploy/

# Copy HP installer
cp -r /Volumes/.Software/Mac/HP/All-In-One\ Driver/Current/3/1\ Installer/HewlettPackardPrinterDrivers.pkg /var/folders/deploy/

# Unmount Software folder
umount /Volumes/.Software

# Install driver
installer -pkg /var/folders/deploy/HewlettPackardPrinterDrivers.pkg -target /

# Configure printers using lpd
lpadmin -p "HP_KatieLane" -v lpd://192.168.211.12/ -D "HP_KatieLane" -E -P "$ppdloc/HP Laserjet P2055d.gz" -o printer-is-shared=false

exit 0