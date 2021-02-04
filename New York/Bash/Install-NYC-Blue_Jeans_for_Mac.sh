#!/bin/bash

#  Install-NYC-BlueJeans_for_Mac.sh
#  Created by Stephen Warneford-Bygrave on 2016-03-23

# Run as root; check for superuser elevation (EUID) and exit if check fails
if [[ $EUID -ne 0 ]]; then 
	/bin/echo "ERROR: Not running as root user. Terminating...."
	exit 1
fi

# Mount Software folder
mkdir /Volumes/.Software
mount -t afp afp://deploy:D3pl0y11@ny01-arc01/Software /Volumes/.Software

# Create local software repository
mkdir /var/folders/deploy/

# Copy installers to local machine
cp -r /Volumes/.Software/Mac/BlueJeans/Mac\ Client/Current/1.0.204/1\ Installer/Blue\ Jeans\ Scheduler\ for\ Mac\ 1.0.204.pkg /var/folders/deploy/

# Install Blue Jeans
installer -pkg /var/folders/deploy/Blue\ Jeans\ Scheduler\ for\ Mac\ 1.0.204.pkg -target /

# Unmount Software folder
umount /Volumes/.Software

# Delete local software repository
rm -rf /var/folders/deploy

exit 0