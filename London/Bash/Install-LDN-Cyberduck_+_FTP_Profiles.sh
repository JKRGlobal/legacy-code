#!/bin/sh

#  Install-LDN-Cyberduck_+_FTP_Profiles.sh
#
#
#  Created by Stephen Warneford-Bygrave on 21/11/2014.
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
mount -t afp afp://deploy:D3pl0y11@LN01-DEP01.jkr.co.uk/Software /Volumes/.Software

# Create local software repository

mkdir /var/folders/deploy/

# Copy installers to local machine

cp -r /Volumes/.Software/Mac/Cyberduck/Client/Current/4.5.2/1\ Installer/Cyberduck\ 4.5.2.pkg /var/folders/deploy/

# Installs VPN client

installer -pkg /var/folders/deploy/Cyberduck\ 4.5.2.pkg -target /

# Unmounts software share

umount /Volumes/.Software

# Delete local software repository

rm -rf /var/folders/deploy

# Parses directory services to find all users on the local system, omits system accounts, and sets users as variables

dscl . list /Users | grep -v '^_' | grep -v 'daemon' | grep -v 'Guest' | grep -v 'nobody' | grep -v 'root' | grep -v 'ladmin' | grep -v 'vtmgmt' | grep -v 'vtadmin' | while read user

# "Do" loop 

do

# Create Cyberduck bookmark folder

mkdir /Users/$user/Library/Application\ Support/Cyberduck/
mkdir /Users/$user/Library/Application\ Support/Cyberduck/Bookmarks/

# Create bookmarks and output to bookmark folder

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
<key>Access Timestamp</key>
<string>1416577067939</string>
<key>Hostname</key>
<string>jkrglobal.ftpstream.com</string>
<key>Nickname</key>
<string>jkr LDN – FTP</string>
<key>Port</key>
<string>22</string>
<key>Protocol</key>
<string>sftp</string>
<key>UUID</key>
<string>ef586a67-59ac-4ecf-bbc6-a4a93794f171</string>
<key>Username</key>
<string>"$user"</string>
</dict>
</plist>" > /Users/$user/Library/Application\ Support/Cyberduck/Bookmarks/jkr\ LDN.duck

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
<key>Access Timestamp</key>
<string>1416577067939</string>
<key>Hostname</key>
<string>jkrglobalnewyork.ftpstream.com</string>
<key>Nickname</key>
<string>jkr NYC – FTP</string>
<key>Port</key>
<string>22</string>
<key>Protocol</key>
<string>sftp</string>
<key>UUID</key>
<string>ef586a67-59ac-4ecf-bbc6-a4a93794f171</string>
<key>Username</key>
<string>"$user"</string>
</dict>
</plist>" > /Users/$user/Library/Application\ Support/Cyberduck/Bookmarks/jkr\ NYC.duck

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
<key>Access Timestamp</key>
<string>1416577067939</string>
<key>Hostname</key>
<string>jkrglobalasia.ftpstream.com</string>
<key>Nickname</key>
<string>jkr SNG – FTP</string>
<key>Port</key>
<string>22</string>
<key>Protocol</key>
<string>sftp</string>
<key>UUID</key>
<string>ef586a67-59ac-4ecf-bbc6-a4a93794f171</string>
<key>Username</key>
<string>"$user"</string>
</dict>
</plist>" > /Users/$user/Library/Application\ Support/Cyberduck/Bookmarks/jkr\ SNG.duck

# Change permissions on created files

chown -R $user:staff /Users/$user/Library/Application\ Support/Cyberduck/Bookmarks/
chmod 755 /Users/$user/Library/Application\ Support/Cyberduck/Bookmarks
chmod 644 /Users/$user/Library/Application\ Support/Cyberduck/Bookmarks/*

# Finish "do" loop

done

exit 0

# 21/11/14	v1.0.1	Stephen Bygrave		Initial release
# 26/01/15	v1.0.2	Stephen Bygrave		Changed location of installer