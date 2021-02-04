#!/bin/bash

#  Install-LDN-Xerox_All.sh
#  Created by Adrian Williams on 2017-02-27

# Run as root; check for superuser elevation (EUID) and exit if check fails
if [[ $EUID -ne 0 ]]; then 
	/bin/echo "ERROR: Not running as root user. Terminating...."
	exit 1
fi

# Deletes existing Printers
lpadmin -x "Xerox1"
lpadmin -x "Xerox_1"
lpadmin -x "Xerox_1APC"
lpadmin -x "Xerox_1APC_B&W"
lpadmin -x "Xerox_1APC_Colour"
lpadmin -x "Xerox2"
lpadmin -x "Xerox_2"
lpadmin -x "Xerox_2APC"
lpadmin -x "Xerox_2APC_B&W"
lpadmin -x "Xerox_2APC_Colour"
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
lpadmin -x "Xerox5"
lpadmin -x "Xerox_5"
lpadmin -x "Xerox_5WPC"
lpadmin -x "Xerox_5WPC_B&W"
lpadmin -x "Xerox_5WPC_Colour"
lpadmin -x "Xerox6"
lpadmin -x "Xerox_6"
lpadmin -x "Xerox_6WPC"
lpadmin -x "Xerox_6WPC_B&W"
lpadmin -x "Xerox_6WPC_Colour"

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
lpadmin -p "Xerox_1APC_Colour" -v lpd://192.168.211.1/print -D "Xerox_1APC_Colour" -E -P "/Library/Printers/PPDs/Contents/Resources/en.lproj/Xerox EX C60-C70 Printer (EU)" -o printer-is-shared=false
lpadmin -p "Xerox_1APC_B&W" -v lpd://192.168.211.1/black -D "Xerox_1APC_B&W" -E -P "/Library/Printers/PPDs/Contents/Resources/en.lproj/Xerox EX C60-C70 Printer (EU)" -o printer-is-shared=false
lpadmin -p "Xerox_2APC_Colour" -v lpd://192.168.211.2/print -D "Xerox_2APC_Colour" -E -P "/Library/Printers/PPDs/Contents/Resources/en.lproj/Xerox EX C60-C70 Printer (EU)" -o printer-is-shared=false
lpadmin -p "Xerox_2APC_B&W" -v lpd://192.168.211.2/black -D "Xerox_2APC_B&W" -E -P "/Library/Printers/PPDs/Contents/Resources/en.lproj/Xerox EX C60-C70 Printer (EU)" -o printer-is-shared=false
lpadmin -p "Xerox_3DPC_Colour" -v lpd://192.168.211.3/print -D "Xerox_3DPC_Colour" -E -P "/Library/Printers/PPDs/Contents/Resources/en.lproj/Xerox EX C60-C70 Printer (EU)" -o printer-is-shared=false
lpadmin -p "Xerox_3DPC_B&W" -v lpd://192.168.211.3/black -D "Xerox_3DPC_B&W" -E -P "/Library/Printers/PPDs/Contents/Resources/en.lproj/Xerox EX C60-C70 Printer (EU)" -o printer-is-shared=false
lpadmin -p "Xerox_4DPC_Colour" -v lpd://192.168.211.4/print -D "Xerox_4DPC_Colour" -E -P "/Library/Printers/PPDs/Contents/Resources/en.lproj/Xerox EX C60-C70 Printer (EU)" -o printer-is-shared=false
lpadmin -p "Xerox_4DPC_B&W" -v lpd://192.168.211.4/black -D "Xerox_4DPC_B&W" -E -P "/Library/Printers/PPDs/Contents/Resources/en.lproj/Xerox EX C60-C70 Printer (EU)" -o printer-is-shared=false
lpadmin -p "Xerox_5WPC_Colour" -v lpd://192.168.211.5/print -D "Xerox_5WPC_Colour" -E -P "/Library/Printers/PPDs/Contents/Resources/en.lproj/Xerox EX C60-C70 Printer (EU)" -o printer-is-shared=false
lpadmin -p "Xerox_5WPC_B&W" -v lpd://192.168.211.5/black -D "Xerox_5WPC_B&W" -E -P "/Library/Printers/PPDs/Contents/Resources/en.lproj/Xerox EX C60-C70 Printer (EU)" -o printer-is-shared=false
lpadmin -p "Xerox_6WPC_Colour" -v lpd://192.168.211.6/print -D "Xerox_6WPC_Colour" -E -P "/Library/Printers/PPDs/Contents/Resources/en.lproj/Xerox EX C60-C70 Printer (EU)" -o printer-is-shared=false
lpadmin -p "Xerox_6WPC_B&W" -v lpd://192.168.211.6/black -D "Xerox_6WPC_B&W" -E -P "/Library/Printers/PPDs/Contents/Resources/en.lproj/Xerox EX C60-C70 Printer (EU)" -o printer-is-shared=false

exit 0