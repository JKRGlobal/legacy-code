#!/bin/bash

#  Uninstall-LDN-Universal_Type_Client_6.sh
#  Created by Stephen Warneford-Bygrave on 2015-02-13

# Run as root; check for superuser elevation (EUID) and exit if check fails
if [[ $EUID -ne 0 ]]; then
	/bin/echo "ERROR: Not running as root user. Terminating...."
	exit 1
fi

# Kills all processes related to UTC on user's machine
kill $(ps -A | grep [U]niversal | awk '{print $1}')

# Mount software share
mkdir "/Volumes/.Software"
mount -t afp "afp://deploy:D3pl0y11@LN01-DEP01.jkr.co.uk/Software" "/Volumes/.Software"

# Create local software repository
mkdir "/var/folders/deploy/"

# Copy files to local machine
cp -r "/Volumes/.Software/Mac/Extensis/Universal Type Client/Current/6.0.2/5 Miscellaneous/UT-Client-removal-tool-v6.0.0.command" "/var/folders/deploy/"

# Runs the Extensis UTC cleanup script
"/var/folders/deploy/UT-Client-removal-tool-v6.0.0.command"

# Unmounts software share
umount "/Volumes/.Software"

# Delete local software repository
rm -rf "/var/folders/deploy"

exit 0
