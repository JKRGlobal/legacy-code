#!/bin/bash

#  Install-User_jkrGuest.sh
#  Created by Stephen Warneford-Bygrave on 2016-02-19

# Run as root; check for superuser elevation (EUID) and exit if check fails
if [[ $EUID -ne 0 ]]; then 
	/bin/echo "ERROR: Not running as root user. Terminating...."
	exit 1
fi

# Uses dscl command to create user
dscl . -create /Users/jkrguest
dscl . -create /Users/jkrguest dsAttrTypeNative:_guest true
dscl . -create /Users/jkrguest dsAttrTypeNative:_defaultLanguage en
dscl . -create /Users/jkrguest dsAttrTypeNative:_writers__defaultLanguage jkrguest
dscl . -create /Users/jkrguest dsAttrTypeNative:_writers_UserCertificate jkrguest
dscl . -create /Users/jkrguest AuthenticationHint ''
dscl . -passwd /Users/jkrguest ""
dscl . -create /Users/jkrguest RealName "jkr Guest"
dscl . -create /Users/jkrguest picture "/Library/User Pictures/jkr/jkr_logo.tif"
dscl . -create /Users/jkrguest UniqueID 801
dscl . -create /Users/jkrguest PrimaryGroupID 20
dscl . -create /Users/jkrguest UserShell /bin/bash
dscl . -create /Users/jkrguest NFSHomeDirectory /Users/jkrguest
security add-generic-password -a jkrguest -s com.apple.loginwindow.guest-account -D "application password" /Library/Keychains/System.keychain
security set-keychain-settings guest.keychain

# Copies User Template folder for new user and changes permissions 
cp -r /System/Library/User\ Template/English.lproj /Users/jkrguest
chown -R jkrguest:staff /Users/jkrguest

# Creates LaunchAgent to stop Keychain errors
mkdir /System/Library/User\ Template/English.lproj/Library/LaunchAgents
echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
<key>Label</key>
<string>com.jkr.createKeychain</string>
<key>ProgramArguments</key>
<array>
<string>/bin/bash</string>
<string>-c</string>
<string>/usr/bin/security create-keychain -p ${USER} ${HOME}/Library/Keychains/guest.keychain;/usr/bin/security unlock-keychain -p ${USER} ${HOME}/Library/Keychains/guest.keychain;/usr/bin/security default-keychain -s ${HOME}/Library/Keychains/guest.keychain</string>
</array>
<key>RunAtLoad</key>
<true/>
</dict>
</plist>" > /System/Library/User\ Template/English.lproj/Library/LaunchAgents/com.jkr.createKeychain.plist

exit 0