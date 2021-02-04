#!/bin/bash

#  Install-User_jkr.sh
#  Created by Stephen Warneford-Bygrave on 2016-02-19

# Run as root; check for superuser elevation (EUID) and exit if check fails
if [[ $EUID -ne 0 ]]; then 
	/bin/echo "ERROR: Not running as root user. Terminating...."
	exit 1
fi

# Uses dscl command to create user
dscl . -create /Users/jkr
dscl . -create /Users/jkr dsAttrTypeNative:_defaultLanguage en
dscl . -create /Users/jkr dsAttrTypeNative:_writers__defaultLanguage jkr
dscl . -create /Users/jkr dsAttrTypeNative:_writers_UserCertificate jkr
dscl . -create /Users/jkr AuthenticationHint ''
dscl . -passwd /Users/jkr ""
dscl . -create /Users/jkr RealName "jkr"
dscl . -create /Users/jkr picture "/Library/User Pictures/jkr/jkr_logo.tif"
dscl . -create /Users/jkr UniqueID 800
dscl . -create /Users/jkr PrimaryGroupID 20
dscl . -create /Users/jkr UserShell /bin/bash
dscl . -create /Users/jkr NFSHomeDirectory /Users/jkr
security add-generic-password -a jkr -s com.apple.loginwindow.guest-account -D "application password" /Library/Keychains/System.keychain

# Copies User Template folder for new user and changes permissions 
cp -r /System/Library/User\ Template/English.lproj /Users/jkr
chown -R jkr:staff /Users/jkr

exit 0