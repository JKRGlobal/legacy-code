#!/bin/bash

#  Install-NYC-Munki_Agent.sh
#  Created by Stephen Warneford-Bygrave on 2015-09-08

# Run as root
if
	[[ $EUID -ne 0 ]];
then
	/bin/echo "This script must run as root."
	exit 1
fi

# Define Variables 
# !!!CHANGE THIS BEFORE RUNNING SCRIPT!!!
manifest=loaner

# Mount Software folder
mkdir /Volumes/.Software
mount -t afp afp://deploy:D3pl0y11@ny01-arc01/Software /Volumes/.Software

# Create local software repository
mkdir /var/folders/deploy/

# Copy installers to local machine
cp -r /Volumes/.Software/Mac/Munki/Munki\ Agent/Current/0.4/1\ Installer/jkr_NYC_Munki_Agent.pkg /var/folders/deploy/

# Install Application
installer -pkg /var/folders/deploy/jkr_NYC_Munki_Agent.pkg -target /

# Unmounts software share
umount /Volumes/.Software

# Delete local software repository
rm -rf /var/folders/deploy

# Set "Default" manifest
/usr/bin/defaults write "/Library/Preferences/ManagedInstalls" ClientIdentifier -string "$manifest"

# Run a check for software, update anything that's needed, and run the check again to push reports
/usr/local/munki/managedsoftwareupdate --checkonly --munkipkgsonly

exit 0