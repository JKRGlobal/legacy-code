#!/bin/bash

#  Install-SNG-Xerox_SNG2.sh
#  Created by Stephen Warneford-Bygrave on 2016-06-03

# Run as root; check for superuser elevation (EUID) and exit if check fails
if [[ $EUID -ne 0 ]]; then
	/bin/echo "ERROR: Not running as root user. Terminating...."
	exit 1
fi

# Check for printer driver locally. If check succeeds, them mount and install driver
if [[ ! -f "/Library/Printers/PPDs/Contents/Resources/FX ApeosPort-IV C3375 PS.gz" ]]; then
	echo "Driver not found. Installing..."

	# Mount Software folder; cleanup if mount fails
	mkdir "/Volumes/.Software"
	mount -t afp "afp://deploy:D3pl0y11@SG01-MP01/Software_SG" "/Volumes/.Software"
	if [[ $? -ne 0 ]]; then
		echo "ERROR: Software share not mounted. Terminating..."
		rmdir "/Volumes/.Software"
		exit 1
	fi

	# Set variable mount directory
	tmpmount=`/usr/bin/mktemp -d /tmp/mount.XXXX`

	# Attach installer dmg and install drivers
	hdiutil attach "/Volumes/.Software/Mac/Xerox/ApeosPort-IV C3375/Current/1 Installer/fxmacprnps1509am105iml.dmg" -mountpoint "$tmpmount"
	installer -pkg "$tmpmount/Fuji Xerox PS Plug-in Installer.pkg" -target /
	hdiutil detach "$tmpmount"

	# Cleanup
	rm -rf "$tmpmount"
	umount /Volumes/.Software
fi

# Deletes existing NY Printers
lpadmin -x "Xerox_SN"
lpadmin -x "Xerox_SNG"
lpadmin -x "Xerox_SNG2"

# Configure printers using lpd
lpadmin -p "Xerox_SNG2" -v lpd://192.168.10.211 -D "Xerox_SNG2" -E -P "/Library/Printers/PPDs/Contents/Resources/FX ApeosPort-IV C3375 PS.gz" -o printer-is-shared=false
echo "Xerox_SNG2 installed. Terminating..."
exit 0
