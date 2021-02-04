#!/bin/bash

#  Install-LDN-Font_Studio_5.sh
#  Created by Stephen Warneford-Bygrave on 2015-09-30

# Run as root; check for superuser elevation (EUID) and exit if check fails
if [[ $EUID -ne 0 ]]; 
then 
	/bin/echo "This script must run as root."
	exit 1
fi

# Mount software share
mkdir /Volumes/.Software
mount -t afp afp://deploy:D3pl0y11@LN01-DEP01.jkr.co.uk/Software /Volumes/.Software

# Create local software repository
mkdir /var/folders/deploy/

# Copy files to local machine
cp -r /Volumes/.Software/Mac/FontLab/Studio/Current/5/1\ Installer/FontLab\ Studio\ 5\ Installer.pkg /var/folders/deploy/

# Installs the latest version of Sonos Remote Desktop
installer -pkg /var/folders/deploy/FontLab\ Studio\ 5\ Installer.pkg -target /

# Unmounts software share
umount /Volumes/.Software

# Delete local software repository
rm -rf /var/folders/deploy

exit 0