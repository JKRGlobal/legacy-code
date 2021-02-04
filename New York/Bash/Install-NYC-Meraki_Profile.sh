#!/bin/sh

#  Install-NYC-Meraki_Profile.sh
#  
#
#  Created by Stephen Warneford-Bygrave on 09/04/2015.
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

# Copy profile to local machine

cp -r /Volumes/.Software/Mac/Profiles/meraki_sm_mdm.mobileconfig /var/folders/deploy/

# Installs profile

/usr/bin/profiles -I -F /var/folders/deploy/meraki_sm_mdm.mobileconfig

# Unmounts software share

umount /Volumes/.Software

# Delete local software repository

rm -rf /var/folders/deploy

exit 0

# 09/04/2015	v1.0.1	Stephen Bygrave		Initial release