#!/bin/bash

#  Install-SNG-jkr_Fonts.sh
#  Created by Stephen Warneford-Bygrave on 2015-10-08

# Run as root; check for superuser elevation (EUID) and exit if check fails
if [[ $EUID -ne 0 ]]; then
	/bin/echo "ERROR: Not running as root user. Terminating...."
	exit 1
fi

# Mount Software folder
mkdir "/Volumes/.Software"
mount -t afp "afp://deploy:D3pl0y11@SG01-MP01/Software_SG" "/Volumes/.Software"
if [[ $? -ne 0 ]]; then
	echo "ERROR: Software share not mounted. Terminating..."
	rmdir "/Volumes/.Software"
	exit 1
fi

# Create local software repository
mkdir "/var/folders/deploy/"

# Copy installers to local machine
cp -r "/Volumes/.Software/Fonts/jkr Corporate/jkr Fonts-1.4.pkg" "/var/folders/deploy/"

# Install Fiery Print drivers
installer -pkg "/var/folders/deploy/jkr Fonts-1.4.pkg" -target /

# Unmount Software folder
umount "/Volumes/.Software"

# Delete local software repository
rm -rf "/var/folders/deploy"

exit 0
