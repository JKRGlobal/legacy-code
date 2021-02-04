#!/bin/bash

#  Install-LDN-Universal_Type_Client_5.sh
#  Created by Stephen Warneford-Bygrave on 2015-04-20

# Run as root; check for superuser elevation (EUID) and exit if check fails
if [[ $EUID -ne 0 ]]; 
then 
	/bin/echo "This script must run as root."
	exit 1
fi

# Kills all processes related to UTC on user's machine
kill $(ps -A | grep [U]niversal | awk '{print $1}')

# Mount software share
mkdir /Volumes/.Software
mount -t afp afp://deploy:D3pl0y11@LN01-DEP01.jkr.co.uk/Software /Volumes/.Software

# Create local software repository
mkdir /var/folders/deploy/

# Copy files to local machine
cp -r "/Volumes/.Software/Mac/Extensis/Universal Type Client/Current/5.2.1/1 Installer/Universal Type Client 5.2.1.pkg" /var/folders/deploy/
cp -r "/Volumes/.Software/Mac/Extensis/Universal Type Client/Current/5.2.1/5 Miscellaneous/UT-Client-removal-tool-v5.2.command" /var/folders/deploy/

# Runs the Extensis UTC cleanup script
/var/folders/deploy/UT-Client-removal-tool-v5.2.command

# Installs the latest version of UTC
installer -pkg "/var/folders/deploy/Universal Type Client 5.2.1.pkg" -target /

# Unmounts software share
umount /Volumes/.Software

# Delete local software repository
rm -rf /var/folders/deploy

# Creates a preference file that contains the server address and port
echo -e "server.address=jkr-fontserver\nserver.port=8080" |  tee /Library/Preferences/com.extensis.UniversalTypeClient.conf

exit 0