#!/bin/sh

#  Install-NY-jkr_Fonts.sh
#  
#
#  Created by Stephen Warneford-Bygrave on 18/02/2015.
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

cp -r /Volumes/.Software/Fonts/jkr\ Haas\ Grotesk.pkg /var/folders/deploy/

# Install font package

installer -pkg /var/folders/deploy/jkr\ Haas\ Grotesk.pkg -target /

# Unmount Software folder

umount /Volumes/.Software

# Delete local software repository

rm -rf /var/folders/deploy

exit 0

# 18/02/2015    v1.0.1  Stephen Bygrave     Initial release