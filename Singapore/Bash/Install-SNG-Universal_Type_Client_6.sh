#!/bin/bash

#  Install-SNG-Universal_Type_Client_6.sh
#  Created by Stephen Warneford-Bygrave on 2016-02-17

# Run as root; check for superuser elevation (EUID) and exit if check fails
if [[ $EUID -ne 0 ]]; then 
	/bin/echo "ERROR: Not running as root user. Terminating...."
	exit 1
fi

# Kills all processes related to UTC on user's machine
kill $(ps -A | grep [U]niversal | awk '{print $1}')

# Mount software share
mkdir "/Volumes/.Software"
mount -t afp "afp://deploy:D3pl0y11@SG01-MP01/Software_SG" "/Volumes/.Software"

# Create local software repository
TMP_DEPLOY=`/usr/bin/mktemp -d /tmp/deploy.XXXX`

# Copy files to local machine
cp -r "/Volumes/.Software/Mac/Extensis/Universal Type Client/Current/6.0.1/1 Installer/Universal Type Client 6.0.1.pkg" "$TMP_DEPLOY"
cp -r "/Volumes/.Software/Mac/Extensis/Universal Type Client/Current/6.0.1/5 Miscellaneous/UT-Client-removal-tool-v6.0.0.command" "$TMP_DEPLOY"

# Runs the Extensis UTC cleanup script
"$TMP_DEPLOY/UT-Client-removal-tool-v6.0.0.command"

# Installs the latest version of UTC
installer -pkg "$TMP_DEPLOY/Universal Type Client 6.0.1.pkg" -target /

# Cleanup
umount "/Volumes/.Software"
rm -rf "$TMP_DEPLOY"

exit 0