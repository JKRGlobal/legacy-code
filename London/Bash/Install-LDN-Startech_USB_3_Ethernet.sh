#!/bin/bash

#  Install-LDN-Startech_USB_3_Ethernet.sh
#  Created by Stephen Warneford-Bygrave on 2015-02-23

# Run as root
if
	[[ $EUID -ne 0 ]]; 
then
	/bin/echo "This script must run as root."
	exit 1
fi

# Mount Software folder
mkdir /Volumes/.Software
mount -t afp afp://deploy:D3pl0y11@LN01-DEP01.jkr.co.uk/Software /Volumes/.Software

# Create local software repository
mkdir /var/folders/deploy/

# Copy installers to local machine
cp -r /Volumes/.Software/Mac/StarTech/USB\ 3\ Driver/Current/1/1\ Installer/Startech\ USB3\ Ethernet\ Driver.pkg /var/folders/deploy/

# Install Fiery Print drivers
installer -pkg /var/folders/deploy/Startech\ USB3\ Ethernet\ Driver.pkg -target /

# Unmount Software folder
umount /Volumes/.Software

# Delete local software repository
rm -rf /var/folders/deploy

exit 0