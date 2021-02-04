#!/bin/sh

#  Uninstall-Blue_Jeans_for_Mac.sh
#  
#
#  Created by Stephen Warneford-Bygrave on 06/03/2015.
#

if

[[ $EUID -ne 0 ]]; then
/bin/echo "This script must run as root."

# Not running as root.

exit 1

fi

# Kills Blue Jeans process and deletes application

killall "Blue Jeans for Mac"

rm -rf /Applications/Blue\ Jeans\ for\ Mac.app

# Parses directory services to find all users on the local system, omits system accounts, and sets users as variables

dscl . list /Users | grep -v '^_' | grep -v 'daemon' | grep -v 'Guest' | grep -v 'nobody' | grep -v 'root' | while read user

# "Do" loop to delete Office cache from all user home directories

do

rm -rf /Users/$user/Library/Preferences/com.bluejeans.bluejeansformac.plist

done

exit 0

# 06/03/15  v1.0.1  Stephen Bygrave		Initial release