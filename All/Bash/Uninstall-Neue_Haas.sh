#!/bin/sh

#  Uninstall-Neue_Haas.sh
#  
#
#  Created by Stephen Warneford-Bygrave on 17/02/2015.
#

# Run as root

if

[[ $EUID -ne 0 ]]; then
/bin/echo "This script must run as root."

# Not running as root.

exit 1

fi

# Delete fonts from main library

rm -rf /Library/Fonts/NHaasGrotesk*

# Parse dscl to set usernames as variables

dscl . list /Users | grep -v '^_' | grep -v 'daemon' | grep -v 'Guest' | grep -v 'nobody' | grep -v 'root' | while read user

# "Do" loop to delete fonts from user libraries

do

rm -rf /Users/$user/Library/Fonts/NHaasGrotesk*

done

exit 0

# 17/02/15  v1.0.1  Stephen Bygrave     Initial release