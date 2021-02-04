#!/bin/bash

#  Install-LDN-Java8.sh
#  Created by Stephen Warneford-Bygrave on 2016-05-04

# Run as root; check for superuser elevation (EUID) and exit if check fails
if [[ $EUID -ne 0 ]]; then 
	/bin/echo "ERROR: Not running as root user. Terminating...."
	exit 1
fi

# Quit browsers
kill $(ps -A | grep [S]afari | awk '{print $1}')
kill $(ps -A | grep [F]irefox | awk '{print $1}')
kill $(ps -A | grep [C]hrome | awk '{print $1}')

# Mount Software folder
mkdir "/Volumes/.Software"
mount -t afp "afp://deploy:D3pl0y11@LN01-DEP01.jkr.co.uk/Software" "/Volumes/.Software"

# Create local software repository
mkdir "/var/folders/deploy/"

# Copy installers to local machine
cp -r "/Volumes/.Software/Mac/Java/JRE/Current/8u91/1 Installer/JavaAppletPlugin.pkg" "/var/folders/deploy/"

# Install Fiery Print drivers
installer -pkg "/var/folders/deploy/JavaAppletPlugin.pkg" -target /

# Unmount Software folder
umount "/Volumes/.Software"

# Delete local software repository
rm -rf "/var/folders/deploy"

exit 0