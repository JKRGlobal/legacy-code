#!/bin/sh

#  Install-NYC-UC_One.sh
#  
#
#  Created by Stephen Warneford-Bygrave on 15/04/2015.
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

# Copy application to local machine

cp -r /Volumes/.Software/Mac/Broadsoft/UC-One/Current/20.1.0.200/1\ Installer/UC-One\ v20.pkg /var/folders/deploy/

# Installs Software

installer -pkg /var/folders/deploy/UC-One\ v20.pkg -target /

# Unmounts software share

umount /Volumes/.Software

# Delete local software repository

rm -rf /var/folders/deploy

exit 0

# 15/04/2015	v1.0.1	Stephen Bygrave		Initial release