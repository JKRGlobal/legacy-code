#!/bin/sh

#  Configure-Local_Admin_Password.sh
#  
#
#  Created by Stephen Warneford-Bygrave on 24/02/2015.
#

# Run as root

if

[[ $EUID -ne 0 ]]; then
/bin/echo "This script must run as root."

# Not running as root.

exit 1

fi

# Uses directory services to change password (REMEMBER TO CHANGE PASSWORDS BELOW BEFORE SUBMITTING)

dscl . -passwd /Users/ladmin <oldpassword> <newpassword>

exit 0

# 24/02/15  v1.0.1  Stephen Bygrave		Initial release