#!/bin/sh

#  Prepare-MR_All.sh
#
#
#  Created by Stephen Warneford-Bygrave on 13/02/2015.
#

# Run as root

if

[[ $EUID -ne 0 ]]; then
/bin/echo "This script must run as root."

# Not running as root.

exit 1

fi

# Define all variables

osvers=$(sw_vers -productVersion | awk -F. '{print $2}')

# Mount image prep share

mkdir /Volumes/.Prep
mount -t afp afp://deploy:D3pl0y11@LN01-DEP01.jkr.co.uk/Image\ Prep /Volumes/.Prep

# Copy default desktop image 

cp /Volumes/.Prep/Branding/CharismaByDesign.jpg /Library/Desktop\ Pictures/

# Unmount prep share

umount /Volumes/.Prep

# Set permissions on image

chown root:wheel /Library/Desktop\ Pictures/CharismaByDesign.jpg
chmod 644 /Library/Desktop\ Pictures/CharismaByDesign.jpg
xattr -d com.apple.FinderInfo /Library/Desktop\ Pictures/CharismaByDesign.jpg

# Set Desktop image

if [[ ${osvers} -ge 9 ]]; 

	then

        rm -rf /System/Library/CoreServices/DefaultDesktop.jpg
        ln -s /Library/Desktop\ Pictures/CharismaByDesign.jpg /System/Library/CoreServices/DefaultDesktop.jpg
        chown root:wheel /System/Library/CoreServices/DefaultDesktop.jpg
        chmod 755 /System/Library/CoreServices/DefaultDesktop.jpg
	
	else
		/usr/libexec/PlistBuddy -c "Add Background:ImageFilePath string /Library/Desktop\ Pictures/CharismaByDesign.jpg" /System/Library/User\ Template/English.lproj/Library/Preferences/com.apple.desktop.plist
		/usr/libexec/PlistBuddy -c "Add Background:default:ImageFilePath string /Library/Desktop\ Pictures/CharismaByDesign.jpg" /System/Library/User\ Template/English.lproj/Library/Preferences/com.apple.desktop.plist
 
fi

# Adds Microsoft Office registration

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
<key>14\FirstRun\MigrationForMASComplete</key>
<integer>1</integer>
<key>14\FirstRun\SetupComplete</key>
<integer>1</integer>
<key>14\UserInfo\UserAddress</key>
<string></string>
<key>14\UserInfo\UserInitials</key>
<string>JG</string>
<key>14\UserInfo\UserName</key>
<string>jkr Guest</string>
<key>14\UserInfo\UserOrganization</key>
<string>jkr</string>
</dict>
</plist>" > /System/Library/User\ Template/English.lproj/Library/Preferences/com.microsoft.office.plist

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
<key>SQMReportsEnabled</key>
<false/>
<key>ShipAssertEnabled</key>
<false/>
</dict>
</plist>" > /System/Library/User\ Template/English.lproj/Library/Preferences/com.microsoft.error_reporting.plist

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
<key>HowToCheck</key>
<string>Automatic</string>
<key>WhenToCheck</key>
<integer>2</integer>
</dict>
</plist>" > /System/Library/User\ Template/English.lproj/Library/Preferences/com.microsoft.autoupdate2.plist

/usr/bin/plutil -convert binary1 /System/Library/User\ Template/English.lproj/Library/Preferences/com.microsoft.office.plist
/usr/bin/plutil -convert binary1 /System/Library/User\ Template/English.lproj/Library/Preferences/com.microsoft.error_reporting.plist
/usr/bin/plutil -convert binary1 /System/Library/User\ Template/English.lproj/Library/Preferences/com.microsoft.autoupdate2.plist

# Create jkr Guest user

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

# Copies User Template folder for new user and changes permissions 

cp -R /System/Library/User\ Template/English.lproj /Users/jkrguest
chown -R jkrguest:staff /Users/jkrguest

exit 0

# 18/12/14	v1.0.1	Stephen Bygrave		Initial release
# 12/02/15	v1.0.2	Stephen Bygrave		Added in root statement and removed Sudo
# 26/03/15  v1.0.3  Stephen Bygrave     Added in MS Office Registration