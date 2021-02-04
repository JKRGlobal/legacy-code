#!/bin/sh

#  Install-SNG-Blue_Jeans_for_Mac.sh
#  
#
#  Created by Stephen Warneford-Bygrave on 25/03/2015.
#

# Run as root

if

[[ $EUID -ne 0 ]]; then
/bin/echo "This script must run as root."

# Not running as root.

exit 1

fi

# Mount Software folder

mkdir /Volumes/.Software
mount -t afp afp://deploy:D3pl0y11@SG01-MP01/Software_SG /Volumes/.Software

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

# 09/03/2015    v1.0.1  Stephen Bygrave     Initial release