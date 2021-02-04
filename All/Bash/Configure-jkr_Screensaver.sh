#!/bin/sh

#  Configure-jkr_Screensaver.sh
#  
#
#  Created by Stephen Warneford-Bygrave on 15/05/2015.
#

# Run as root

if

[[ $EUID -ne 0 ]]; then
/bin/echo "This script must run as root."

# Not running as root.

exit 1

fi

# cp <screensaver> /System/Library/Screen\ Savers/

# Parses directory services to find all users on the local system, omits system accounts, and sets users as variables

dscl . list /Users | grep -v '^_' | grep -v 'daemon' | grep -v 'Guest' | grep -v 'nobody' | grep -v 'root' | while read user

# "Do" loop to change all User's screen savers

do

/usr/libexec/plistbuddy -c 'set moduleDict:path "/System/Library/Screen Savers/FloatingMessage.saver"' /Users/$user/Library/Preferences/ByHost/com.apple.screensaver.*

/usr/libexec/plistbuddy -c 'set moduleDict:moduleName "Message"' /Users/$user/Library/Preferences/ByHost/com.apple.screensaver.*

done

exit 0

# 15/05/2015  v1.0.1  Stephen Bygrave		Initial release