#!/bin/bash

#  Install-SNG-Adobe_After_Effects_CC_2015.sh
#  Created by Stephen Warneford-Bygrave on 2016-04-17

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
mount -t afp "afp://deploy:D3pl0y11@SG01-MP01/Software_SG" "/Volumes/.Software"

# Set variable mount directory
TMP_MOUNT=`/usr/bin/mktemp -d /tmp/mount.XXXX`

# Install Application
hdiutil attach "/Volumes/.Software/Mac/Adobe/Adobe After Effects/Current/CC 2015/1. Installer/Adobe After Effects CC 2015.dmg" -mountpoint "$TMP_MOUNT"
installer -pkg "$TMP_MOUNT/Adobe After Effects CC 2015/Build/Adobe After Effects CC 2015_Install.pkg" -target /
installer -pkg "$TMP_MOUNT/Adobe After Effects CC 2015 Update/Build/Adobe After Effects CC 2015 Update_Install.pkg" -target /
hdiutil detach "$TMP_MOUNT"

# Cleanup
rm -rf "$TMP_MOUNT"
umount /Volumes/.Software

exit 0