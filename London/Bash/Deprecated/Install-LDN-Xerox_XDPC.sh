#!/bin/bash

#  Install-LDN-Xerox_XDPC.sh
#  Created by Adrian Williams on 2017-07-04

# Run as root; check for superuser elevation (EUID) and exit if check fails
if [[ $EUID -ne 0 ]]; then 
	/bin/echo "ERROR: Not running as root user. Terminating...."
	exit 1
fi

# Deletes existing Printers
lpadmin -x "Xerox3"
lpadmin -x "Xerox_3"
lpadmin -x "Xerox_3DPC"
lpadmin -x "Xerox_3DPC_B&W"
lpadmin -x "Xerox_3DPC_Colour"
lpadmin -x "Xerox4"
lpadmin -x "Xerox_4"
lpadmin -x "Xerox_4DPC"
lpadmin -x "Xerox_4DPC_B&W"
lpadmin -x "Xerox_4DPC_Colour"

# Mount Software folder
mkdir /Volumes/.Software
mount -t afp afp://deploy:D3pl0y11@LN01-DEP01.jkr.co.uk/Software /Volumes/.Software

# Create local software repository
mkdir /var/folders/deploy

# Copy installers to local machine
cp -r /Volumes/.Software/Mac/Xerox/C60_C70/Fiery\ Printer\ Driver.pkg /var/folders/deploy/

# Install Fiery Print drivers
installer -allowUntrusted -pkg /var/folders/deploy/Fiery\ Printer\ Driver.pkg -target /

# Unmount Software folder
umount /Volumes/.Software

# Delete local software repository
rm -rf /var/folders/deploy

# Configure printers using lpd
lpadmin -p "Xerox_3DPC_Colour" -v lpd://192.168.211.3/print -D "Xerox_3DPC_Colour" -E -P "/Library/Printers/PPDs/Contents/Resources/en.lproj/Xerox EX C60-C70 Printer (EU)" -o printer-is-shared=false
lpadmin -p "Xerox_3DPC_B&W" -v lpd://192.168.211.3/black -D "Xerox_3DPC_B&W" -E -P "/Library/Printers/PPDs/Contents/Resources/en.lproj/Xerox EX C60-C70 Printer (EU)" -o printer-is-shared=false
lpadmin -p "Xerox_4DPC_Colour" -v lpd://192.168.211.4/print -D "Xerox_4DPC_Colour" -E -P "/Library/Printers/PPDs/Contents/Resources/en.lproj/Xerox EX C60-C70 Printer (EU)" -o printer-is-shared=false
lpadmin -p "Xerox_4DPC_B&W" -v lpd://192.168.211.4/black -D "Xerox_4DPC_B&W" -E -P "/Library/Printers/PPDs/Contents/Resources/en.lproj/Xerox EX C60-C70 Printer (EU)" -o printer-is-shared=false

exit 0