#!/bin/sh

#  Uninstall-Pegasus.sh
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

# Parses directory services to find all users on the local system, omits system accounts, and sets users as variables

dscl . list /Users | grep -v '^_' | grep -v 'daemon' | grep -v 'Guest' | grep -v 'nobody' | grep -v 'root' | while read user

# "Do" loop to remove all Java files from all user's home dirs

do

rm -rf /Users/$user/Desktop/Pegasus\ Workbook\ \(UK\).app
rm -rf /Users/$user/Library/Application\ Support/Oracle/Java/Deployment/cache/6.0
rm -rf /Users/$user/Library/Application\ Support/Oracle/Java/Deployment/tmp/si
rm -rf /Users/$user/Library/Application\ Support/Preferences/com.pegasussys.crossapps.plist
rm -rf /Users/$user/pegasus

done

exit 0

# 11/03/15  v1.0.1  Stephen Bygrave		Initial release