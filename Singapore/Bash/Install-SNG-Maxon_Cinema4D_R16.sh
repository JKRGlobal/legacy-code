#!/bin/bash

#  Install-SNG-Maxon_Cinema4D_R16.sh
#  Created by Stephen Warneford-Bygrave on 2014-12-11

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
cp -r "/Volumes/.Software/Mac/Maxon/Cinema 4D/Current/R16/Cinema 4D-16.051.pkg" "/var/folders/deploy/"

# Installs Office 2011 365 Base Install
installer -pkg "/var/folders/deploy/Cinema 4D-16.051.pkg" -target /

# Unmount software share
umount "/Volumes/.Software"

# Delete local software repository
rm -rf "/var/folders/deploy"

exit 0
