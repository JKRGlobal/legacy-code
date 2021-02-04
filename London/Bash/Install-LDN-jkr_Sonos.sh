#!/bin/sh

#  Install-LDN-jkr_Sonos.sh
#  Created by Stephen Warneford-Bygrave on 17/08/2015.

# Run as root; check for superuser elevation (EUID) and exit if check fails
if [[ $EUID -ne 0 ]]; then
	/bin/echo "ERROR: Not running as root user. Terminating...."
	exit 1
fi

# Mount software share
mkdir "/Volumes/.Software"
mount -t afp "afp://deploy:D3pl0y11@LN01-DEP01.jkr.co.uk/Software" "/Volumes/.Software"

# Create local software repository
mkdir "/var/folders/deploy/"

# Copy files to local machine
cp -r "/Volumes/.Software/Mac/Sonos/Remote Desktop/Current/1 Installer/jkr Sonos.pkg" "/var/folders/deploy/"

# Installs the latest version of Sonos Remote Desktop
installer -pkg "/var/folders/deploy/jkr Sonos.pkg" -target /

# Unmounts software share
umount "/Volumes/.Software"

# Delete local software repository
rm -rf "/var/folders/deploy"

exit 0
