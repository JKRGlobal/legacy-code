#!/bin/bash

#  Uninstall-Munki_Agents.sh
#  Created by Stephen Warneford-Bygrave on 2015-06-12

# Run as root
if
	[[ $EUID -ne 0 ]];
then
	/bin/echo "This script must run as root."
	exit 1
fi

# Unload Munki Daemon
launchctl unload /Library/LaunchDaemons/com.googlecode.munki.*

# Uninstall Munki
rm -rf /Applications/Managed\ Software\ Center.app
rm -rf /Applications/Utilities/Managed\ Software\ Update.app
rm -f /Library/LaunchDaemons/com.googlecode.munki.*
rm -f /Library/LaunchAgents/com.googlecode.munki.*
rm -rf /Library/Managed\ Installs
rm -rf /Library/Preferences/ManagedInstalls.plist
rm -rf /usr/local/munki
rm /etc/paths.d/munki

# Uninstall Sal Agent
rm -rf /usr/local/sal

# Uninstall MunkiReport-PHP Agent
rm /Library/Preferences/MunkiReport.plist
rm /usr/local/bin/filevault_2_status_check.sh

# Remove pkg receipts
pkgutil --forget com.googlecode.munki.admin
pkgutil --forget com.googlecode.munki.app
pkgutil --forget com.googlecode.munki.core
pkgutil --forget com.googlecode.munki.launchd
pkgutil --forget jkrldnmunkireportsagent
pkgutil --forget jkrldnmunkireportagent
pkgutil --forget jkrldnmunkiwebadminagent
pkgutil --forget jkrldnmunkiagent
pkgutil --forget jkrldnsalagent
pkgutil --forget com.jkr.jkrldnmunkireportsagent
pkgutil --forget com.jkr.jkrldnmunkireportagent
pkgutil --forget com.jkr.jkrldnmunkiwebadminagent
pkgutil --forget com.jkr.jkrldnmunkiagent
pkgutil --forget com.jkr.jkrldnsalagent

exit 0