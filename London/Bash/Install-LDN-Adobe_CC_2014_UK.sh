#!/bin/bash

#  Install-LDN-Adobe_CC_2014_UK.sh
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
cp -r /Volumes/.Software/Mac/Adobe/Photoshop/Current/CC\ 2014/1\ Installer/Adobe\ Photoshop\ CC\ 2014\ UK\ -\ Named_Install.pkg /var/folders/deploy/
cp -r /Volumes/.Software/Mac/Adobe/Illustrator/Current/CC\ 2014/1\ Installer/Adobe\ Illustrator\ CC\ 2014\ UK\ -\ Named_Install.pkg /var/folders/deploy/
cp -r /Volumes/.Software/Mac/Adobe/InDesign/Current/CC\ 2014/1\ Installer/Adobe\ InDesign\ CC\ 2014\ UK\ -\ Named_Install.pkg /var/folders/deploy/
cp -r /Volumes/.Software/Mac/Adobe/Bridge/Current/CC/1\ Installer/Adobe\ Bridge\ CC\ UK\ -\ Named_Install.pkg /var/folders/deploy/
cp -r /Volumes/.Software/Mac/Adobe/Acrobat/Current/XI/1\ Installer/Adobe\ Acrobat\ Pro\ XI\ UK\ -\ Named_Install.pkg /var/folders/deploy/

# Quit browsers
kill $(ps -A | grep [S]afari | awk '{print $1}')
kill $(ps -A | grep [F]irefox | awk '{print $1}')
kill $(ps -A | grep [C]hrome | awk '{print $1}')

# Install Application
installer -pkg "/var/folders/deploy/Adobe Photoshop CC 2014 UK - Named_Install.pkg" -target /
installer -pkg "/var/folders/deploy/Adobe Illustrator CC 2014 UK - Named_Install.pkg" -target /
installer -pkg "/var/folders/deploy/Adobe InDesign CC 2014 UK - Named_Install.pkg" -target /
installer -pkg "/var/folders/deploy/Adobe Bridge CC UK - Named_Install.pkg" -target /
installer -pkg "/var/folders/deploy/Adobe Acrobat Pro XI UK - Named_Install.pkg" -target /

# Unmounts software share
umount "/Volumes/.Software"

# Delete local software repository
rm -rf "/var/folders/deploy"

exit
