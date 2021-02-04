#!/bin/bash

#  Configure-SNG-Adobe_CC_Serial_Licensing.sh
#  Created by Stephen Warneford-Bygrave on 2015-11-18

# Run as root; check for superuser elevation (EUID) and exit if check fails
if [[ $EUID -ne 0 ]]; then 
	/bin/echo "ERROR: Not running as root user. Terminating...."
	exit 1
fi

# Define Variables
adobecclicenser=/usr/local/adobecclicenser/

# Check for license file; if found, just serialise Adobe
if 
	[ ! -d "$adobecclicenser" ]; then
	echo "Licenser not found. Installing and adding license"

	# Mount Software folder
	mkdir /Volumes/.Software
	mount -t afp afp://deploy:D3pl0y11@SG01-MP01/Software_SG /Volumes/.Software

	# Create local software repository
	mkdir /var/folders/deploy/

	# Copy installers to local machine
	cp -r /Volumes/.Software/Mac/Adobe/z\ Miscellaneous/Adobe\ CC\ Licenser.pkg /var/folders/deploy/

	# Install Application
	installer -pkg /var/folders/deploy/Adobe\ CC\ Licenser.pkg -target /

	# Unmounts software share
	umount /Volumes/.Software

	# Delete local software repository
	rm -rf /var/folders/deploy
else
	echo "Licenser found. Adding license"
fi

# Add serial
/usr/local/adobecclicenser/AdobeSerialization

exit 0