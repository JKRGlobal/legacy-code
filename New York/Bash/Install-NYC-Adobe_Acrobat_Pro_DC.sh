#!/bin/sh

#  Install-NYC-Adobe_Acrobat_Pro_DC.sh
#  
#
#  Created by Stephen Warneford-Bygrave on 10/04/2015.
#

# Run as root

if

[[ $EUID -ne 0 ]]; then
/bin/echo "This script must run as root."

# Not running as root.

exit 1

fi

# Mount Software folder

mkdir /Volumes/.Software
mount -t afp afp://deploy:D3pl0y11@ny01-arc01/Software /Volumes/.Software

# Create local software repository

mkdir /var/folders/deploy/

# Copy installers to local machine

cp -r /Volumes/.Software/Mac/Adobe/Acrobat/Current/DC/1\ Installer/Adobe\ Acrobat\ Pro\ DC\ US_Install.pkg /var/folders/deploy/

# Install Blue Jeans

installer -pkg /var/folders/deploy/Adobe\ Acrobat\ Pro\ DC\ US_Install.pkg -target /

# Unmount Software folder

umount /Volumes/.Software

# Delete local software repository

rm -rf /var/folders/deploy

exit 0

# 10/04/2015    v1.0.1  Stephen Bygrave     Initial release