#!/bin/bash

#  Install-NYC-Keynote.sh
#  Created by Stephen Warneford-Bygrave on 2015-09-23

# Run as root; check for superuser elevation (EUID) and exit if check fails
if [[ $EUID -ne 0 ]]; 
then 
	/bin/echo "This script must run as root."
	exit 1
fi

# Mount Software folder
mkdir /Volumes/.Software
mount -t afp afp://deploy:D3pl0y11@ny01-arc01/Software /Volumes/.Software

# Create local software repository
mkdir /var/folders/deploy/

# Copy installers to local machine
cp -r /Volumes/.Software/Mac/Apple/Keynote/Current/6.2.2/1\ Installer/Keynote-6.2.2.pkg /var/folders/deploy/

# Install font package
installer -pkg /var/folders/deploy/Keynote-6.2.2.pkg -target /

# Unmount Software folder
umount /Volumes/.Software

# Delete local software repository
rm -rf /var/folders/deploy

exit 0