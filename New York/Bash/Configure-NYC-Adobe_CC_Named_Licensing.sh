#!/bin/bash

#  Configure-NYC-Adobe_CC_Named_Licensing.sh
#  Created by Stephen Warneford-Bygrave on 2015-09-02

# Run as root
if 
	[[ $EUID -ne 0 ]]; 
then
	/bin/echo "This script must run as root."
	exit 1
fi

# Define Variables
adobecclicenser=/usr/local/adobecclicenser/

# Check for license file; if found, just remove Adobe serialisation
if 
	[ ! -d "$adobecclicenser" ];
then
	echo "Licenser not found. Installing and removing license"

	# Mount Software folder
	mkdir /Volumes/.Software
	mount -t afp afp://deploy:D3pl0y11@ny01-arc01/Software /Volumes/.Software

	# Create local software repository
	mkdir /var/folders/deploy/

	# Copy installers to local machine
	cp -r /Volumes/.Software/Mac/Adobe/Adobe\ Licenser/Current/1.0/1\ Installer/Adobe\ CC\ Licenser.pkg /var/folders/deploy/

	# Install Application
	installer -pkg /var/folders/deploy/Adobe\ CC\ Licenser.pkg -target /

	# Unmounts software share
	umount /Volumes/.Software

	# Delete local software repository
	rm -rf /var/folders/deploy
else
	echo "Licenser found. Removing license"
fi

# Remove serial
/usr/local/adobecclicenser/RemoveVolumeSerial

exit 0