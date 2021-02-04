#!/bin/bash

#  Install-LDN-Xerox_NY.sh
#  Created by Stephen Warneford-Bygrave on 2015-10-16

# Run as root; check for superuser elevation (EUID) and exit if check fails
if [[ $EUID -ne 0 ]]; 
	then 
	/bin/echo "This script must run as root."
	exit 1
fi

# Deletes existing NY Printers
lpadmin -x "Xerox_NY"
lpadmin -x "Xerox_560"
lpadmin -x "Xerox EX560"
lpadmin -x "Xerox EX_560"
lpadmin -x "Xerox_EX560"
lpadmin -x "Xerox_EX_560"

# Mount Software folder
mkdir /Volumes/.Software
mount -t afp afp://deploy:D3pl0y11@LN01-DEP01/Software /Volumes/.Software

# Create local software repository
mkdir /var/folders/deploy/

# Copy installers to local machine
if [[ ${osvers} -ge 10 ]]; then

cp -r /Volumes/.Software/Mac/Xerox/EX560/Current/10.10/1\ Installer/Fiery\ Printer\ Driver.pkg /var/folders/deploy/

else

cp -r /Volumes/.Software/Mac/Xerox/EX560/Current/10.9/1\ Installer/Fiery\ Printer\ Driver.pkg /var/folders/deploy/

fi

# Install Fiery Print drivers

installer -pkg /var/folders/deploy/Xerox\ Fiery\ Driver.pkg -target /

# Unmount Software folder

umount /Volumes/.Software

# Delete local software repository

rm -rf /var/folders/deploy

# Configure printers using lpd

lpadmin -p "Xerox_NY" -v lpd://192.168.1.115/print -D "Xerox_NY" -E -P "/Library/Printers/PPDs/Contents/Resources/en.lproj/Xerox Color EX 550-560" -o printer-is-shared=false

exit 0

# 15/12/2014	v1.0.1	Stephen Bygrave		Initial release
# 17/04/2015    v1.0.2  Stephen Bygrave     Updated for new drivers