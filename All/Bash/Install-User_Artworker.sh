#!/bin/bash

#  Install-User_Artworker.sh
#  Created by Stephen Warneford-Bygrave on 2014-12-12

# Run as root; check for superuser elevation (EUID) and exit if check fails
if [[ $EUID -ne 0 ]]; then 
	/bin/echo "ERROR: Not running as root user. Terminating...."
	exit 1
fi

# Uses dscl command to create user
dscl . -create /Users/artworker
dscl . -create /Users/artworker dsAttrTypeNative:_defaultLanguage en
dscl . -create /Users/artworker dsAttrTypeNative:_writers__defaultLanguage artworker
dscl . -create /Users/artworker dsAttrTypeNative:_writers_UserCertificate artworker
dscl . -create /Users/artworker RealName "Artworker"
dscl . -create /Users/artworker picture "/Library/User Pictures/jkr/jkr_logo.tif"
dscl . -create /Users/artworker hint “Normal”
dscl . -passwd /Users/artworker artw0rk
dscl . -create /Users/artworker UniqueID 700
dscl . -create /Users/artworker PrimaryGroupID 20
dscl . -create /Users/artworker UserShell /bin/bash
dscl . -create /Users/artworker NFSHomeDirectory /Users/artworker

# Copies User Template folder for new user and changes permissions
cp -r /System/Library/User\ Template/English.lproj /Users/artworker
chown -R artworker:staff /Users/artworker

exit 0