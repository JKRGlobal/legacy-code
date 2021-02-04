#!/bin/bash

#  Install-SNG-Microsoft_Office_2011_365.sh
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
cp -r "/Volumes/.Software/Mac/Microsoft/Microsoft Office/Current/2011 365/1 Installer/Microsoft Office 2011 14.4.1 365.pkg" "/var/folders/deploy/"

# Kills all browsers and all Office applications
kill $(ps -A | grep [S]afari | awk '{print $1}')
kill $(ps -A | grep [F]irefox | awk '{print $1}')
kill $(ps -A | grep [C]hrome | awk '{print $1}')
kill $(ps -A | grep [O]utlook | awk '{print $1}')
kill $(ps -A | grep [W]ord | awk '{print $1}')
kill $(ps -A | grep [P]owerpoint | awk '{print $1}')
kill $(ps -A | grep [E]xcel | awk '{print $1}')

# Installs Office 2011 365 Base Install
installer -pkg "/var/folders/deploy/Microsoft Office 2011 14.4.1 365.pkg" -target /

# Unmount software share
umount "/Volumes/.Software"

# Delete local software repository
rm -rf "/var/folders/deploy"

exit 0
