#!/bin/bash

#  Install-User_Retoucher.sh
#  Created by Stephen Warneford-Bygrave on 2014-12-12

# Run as root; check for superuser elevation (EUID) and exit if check fails
if [[ $EUID -ne 0 ]]; then 
	/bin/echo "ERROR: Not running as root user. Terminating...."
	exit 1
fi

# Uses dscl command to create user
dscl . -create /Users/retoucher
dscl . -create /Users/retoucher dsAttrTypeNative:_defaultLanguage en
dscl . -create /Users/retoucher dsAttrTypeNative:_writers__defaultLanguage retoucher
dscl . -create /Users/retoucher dsAttrTypeNative:_writers_UserCertificate retoucher
dscl . -create /Users/retoucher RealName "Retoucher"
dscl . -create /Users/retoucher picture "/Library/User Pictures/jkr/jkr_logo.tif"
dscl . -create /Users/retoucher hint “Normal”
dscl . -passwd /Users/retoucher retoucher
dscl . -create /Users/retoucher UniqueID 701
dscl . -create /Users/retoucher PrimaryGroupID 20
dscl . -create /Users/retoucher UserShell /bin/bash
dscl . -create /Users/retoucher NFSHomeDirectory /Users/retoucher

# Copies User Template folder for new user and changes permissions
cp -r /System/Library/User\ Template/English.lproj /Users/retoucher
chown -R retoucher:staff /Users/retoucher

exit 0