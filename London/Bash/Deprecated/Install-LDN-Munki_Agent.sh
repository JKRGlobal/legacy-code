#!/bin/bash

#  Install-LDN-Munki_Tools_and_Agent.sh
#  Created by Stephen Warneford-Bygrave on 2015-09-01

# Run as root; check for superuser elevation (EUID) and exit if check fails
if [[ $EUID -ne 0 ]]; then 
	/bin/echo "ERROR: Not running as root user. Terminating...."
	exit 1
fi

# Define variables
manifest=default

# Mount Software folder
mkdir /Volumes/.Software
mount -t afp afp://deploy:D3pl0y11@LN01-DEP01.jkr.co.uk/Software /Volumes/.Software

# Create local software repository
mkdir /var/folders/deploy/

# Copy installers to local machine
cp -r "/Volumes/.Software/Mac/Munki/Munki Tools and Agent/Current/2.4.0.2561/1 Installer/munkitools-2.4.0.2561.pkg" /var/folders/deploy/

# Install Application
installer -pkg "/var/folders/deploy/munkitools-2.4.0.2561.pkg" -target /

# Unmounts software share
umount "/Volumes/.Software"

# Delete local software repository
rm -rf "/var/folders/deploy"

# Set "Default" manifest
/usr/bin/defaults write "/Library/Preferences/ManagedInstalls" ClientIdentifier -string "$manifest"

# Set ManagedInstalls preferences
/usr/bin/defaults delete "/Library/Preferences/ManagedInstalls.plist" SoftwareUpdateServerURL
/usr/bin/defaults write "/Library/Preferences/ManagedInstalls" DaysBetweenNotifications -int 0
/usr/bin/defaults write "/Library/Preferences/ManagedInstalls" InstallAppleSoftwareUpdates -bool true
/usr/bin/defaults write "/Library/Preferences/ManagedInstalls" LogFile -string "/Library/Managed Installs/managedsoftwareupdate.log"
/usr/bin/defaults write "/Library/Preferences/ManagedInstalls" LogToSyslog -bool true
/usr/bin/defaults write "/Library/Preferences/ManagedInstalls" LoggingLevel -int 2
/usr/bin/defaults write "/Library/Preferences/ManagedInstalls" ManagedInstallDir -string "/Library/Managed Installs"
/usr/bin/defaults write "/Library/Preferences/ManagedInstalls" SoftwareRepoURL -string "http://ldn-munkirepo/repo"
/usr/bin/defaults write "/Library/Preferences/ManagedInstalls" SuppressAutoInstall -bool false
/usr/bin/defaults write "/Library/Preferences/ManagedInstalls" SuppressStopButtonOnInstall -bool false
/usr/bin/defaults write "/Library/Preferences/ManagedInstalls" SuppressUserNotification -bool true
/usr/bin/defaults write "/Library/Preferences/com.apple.SoftwareUpdate" CatalogURL "http://ldn-reposado/index_live.sucatalog"

# Create file that sets Munki to run on first reboot
/usr/bin/touch "/Users/Shared/.com.googlecode.munki.checkandinstallatstartup"

exit 0