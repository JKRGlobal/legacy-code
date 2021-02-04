#!/bin/bash

#  Install-LDN-Adobe_CC_2014_US.sh
#  Created by Stephen Warneford-Bygrave on 2015-09-02

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
cp -r /Volumes/.Software/Mac/Adobe/Creative\ Cloud/Current/CC\ 2014/1\ Installer/Adobe\ CC\ 2014\ US.pkg /var/folders/deploy/

# Quit browsers
kill $(ps -A | grep [S]afari | awk '{print $1}')
kill $(ps -A | grep [F]irefox | awk '{print $1}')
kill $(ps -A | grep [C]hrome | awk '{print $1}')

# Install Application
installer -pkg /var/folders/deploy/Adobe\ CC\ 2014\ US.pkg -target /

# Unmounts software share
umount /Volumes/.Software

# Delete local software repository
rm -rf /var/folders/deploy

exit 0