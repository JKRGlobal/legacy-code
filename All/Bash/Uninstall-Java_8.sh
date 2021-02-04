#!/bin/sh

#  Uninstall-Java_8.sh
#  
#
#  Created by Stephen Warneford-Bygrave on 11/03/2015.
#

# Run as root

if

[[ $EUID -ne 0 ]]; then
/bin/echo "This script must run as root."

# Not running as root.

exit 1

fi

# Delete Java files from system

rm -rf /Library/Application\ Support/Oracle
rm -rf /Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin
rm -rf /Library/LaunchAgents/com.oracle.java.Java-Updater.plist
rm -rf /Library/LaunchDaemons/com.oracle.java.Helper-Tool.plist
rm -rf /Library/PreferencePanes/JavaControlPanel.prefPane
rm -rf /Library/Preferences/com.oracle.java.Helper-Tool.plist
rm -rf /private/var/root/Library/Application\ Support/Oracle
rm -rf /private/var/root/Library/Preferences/com.oracle.javadeployment.plist

# Parses directory services to find all users on the local system, omits system accounts, and sets users as variables

dscl . list /Users | grep -v '^_' | grep -v 'daemon' | grep -v 'Guest' | grep -v 'nobody' | grep -v 'root' | while read user

# "Do" loop to remove all Java files from all user's home dirs

do

rm -rf /Users/$user/Library/Application\ Support/JREInstaller
rm -rf /Users/$user/Library/Application\ Support/mac-1.*
rm -rf /Users/$user/Library/Application\ Support/Oracle
rm -rf /Users/$user/Library/Application\ Support/Sponsors.framework
rm -rf /Users/$user/Library/Preferences/com.ask.APNSetup.plist
rm -rf /Users/$user/Library/Preferences/com.oracle.javadeployment.plist

done

exit 0

# 11/03/15  v1.0.1  Stephen Bygrave		Initial release