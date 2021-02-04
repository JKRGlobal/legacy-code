#!/bin/bash

#  Install-User_Realisation.sh
#  Created by Stephen Warneford-Bygrave on 2016-02-01

# Run as root; check for superuser elevation (EUID) and exit if check fails
if [[ $EUID -ne 0 ]]; then 
	/bin/echo "ERROR: Not running as root user. Terminating...."
	exit 1
fi

# Uses dscl command to create user
dscl . -create /Users/realisation
dscl . -create /Users/realisation dsAttrTypeNative:_defaultLanguage en
dscl . -create /Users/realisation dsAttrTypeNative:_writers__defaultLanguage realisation
dscl . -create /Users/realisation dsAttrTypeNative:_writers_UserCertificate realisation
dscl . -create /Users/realisation RealName "Realisation"
dscl . -create /Users/realisation picture "/Library/User Pictures/jkr/jkr_logo.tif"
dscl . -create /Users/realisation hint “Normal”
dscl . -passwd /Users/realisation realisation
dscl . -create /Users/realisation UniqueID 702
dscl . -create /Users/realisation PrimaryGroupID 20
dscl . -create /Users/realisation UserShell /bin/bash
dscl . -create /Users/realisation NFSHomeDirectory /Users/realisation

# Copies User Template folder for new user and changes permissions
cp -r /System/Library/User\ Template/English.lproj /Users/realisation
chown -R realisation:staff /Users/realisation

exit 0