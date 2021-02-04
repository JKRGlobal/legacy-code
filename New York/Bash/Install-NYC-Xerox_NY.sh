#!/bin/bash

#  Install-NY-Xerox_NY.sh
#  Created by Adrian Williams on 2017-07-10

# Run as root; check for superuser elevation (EUID) and exit if check fails
if [[ $EUID -ne 0 ]]; then 
	/bin/echo "ERROR: Not running as root user. Terminating...."
	exit 1
fi

# Deletes existing NY Printers
lpadmin -x "Xerox_NY"
lpadmin -x "Xerox_560"
lpadmin -x "Xerox EX560"
lpadmin -x "Xerox EX_560"
lpadmin -x "Xerox_EX560"
lpadmin -x "Xerox_EX_560"
lpadmin -x "Xerox"

# Mount Software folder
mkdir /Volumes/.Software
mount -t afp afp://deploy:D3pl0y11@ny01-arc01/Software /Volumes/.Software

# Create local software repository
mkdir /var/folders/deploy/

# Copy installers to local machine
cp -r /Volumes/.Software/Mac/Xerox/EX560/Current/10.10/1\ Installer/Fiery\ Printer\ Driver.pkg /var/folders/deploy/

# Install Fiery Print drivers
installer -allowUntrusted -pkg /var/folders/deploy/Fiery\ Printer\ Driver.pkg -target /

# Unmount Software folder
umount /Volumes/.Software

# Delete local software repository
rm -rf /var/folders/deploy

# Configure printers using lpd
lpadmin -p "Xerox_NY" -v lpd://192.168.130.2/print -D "Xerox_NY" -E -P "/Library/Printers/PPDs/Contents/Resources/en.lproj/Xerox Color EX 550-560" -o printer-is-shared=false

exit 0