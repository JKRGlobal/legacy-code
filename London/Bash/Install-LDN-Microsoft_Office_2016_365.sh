#!/bin/bash

#  Install-LDN-Microsoft_Office_2016.sh
#  Created by Stephen Warneford-Bygrave on 2015-07-21

# Run as root
if
	[[ $EUID -ne 0 ]];
then
	/bin/echo "This script must run as root."
	exit 1
fi

# Mount software share
mkdir /Volumes/.Software
mount -t afp afp://deploy:D3pl0y11@LN01-DEP01.jkr.co.uk/Software /Volumes/.Software

# Create local software repository
mkdir /var/folders/deploy/

# Copy installers to local machine
cp -r /Volumes/.Software/Mac/Microsoft/Microsoft\ Office/Current/2016/1\ Installer/Microsoft_Office_2016_Installer.pkg /var/folders/deploy/
cp -r /Volumes/.Software/Mac/Microsoft/Microsoft\ Office/Current/2016/4\ Additional\ Information/Microsoft_Office_2016_Installer_Choices.xml /var/folders/deploy/

# Kills all browsers and all Office applications
kill $(ps -A | grep [S]afari | awk '{print $1}')
kill $(ps -A | grep [F]irefox | awk '{print $1}')
kill $(ps -A | grep [C]hrome | awk '{print $1}')
kill $(ps -A | grep [O]utlook | awk '{print $1}')
kill $(ps -A | grep [W]ord | awk '{print $1}')
kill $(ps -A | grep [P]owerpoint | awk '{print $1}')
kill $(ps -A | grep [E]xcel | awk '{print $1}')

# Installs Office 2016 Base Install and applys choices xml
installer -pkg /var/folders/deploy/Microsoft_Office_2016_Installer.pkg -applyChoiceChangesXML /var/folders/deploy/Microsoft_Office_2016_Installer_Choices.xml -target /

# Unmount software share
umount /Volumes/.Software

# Delete local software repository
rm -rf /var/folders/deploy

exit 0