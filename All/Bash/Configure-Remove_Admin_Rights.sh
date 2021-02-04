#!/bin/sh

#  Configure-Remove_Admin_Rights.sh
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

# Uses directory services to remove user from Admin group (REMEMBER TO CHANGE USER ACCOUNT BEFORE SUBMITTING)

sudo dseditgroup -o edit -d <username> -t user admin

exit 0

# 24/02/15  v1.0.1  Stephen Bygrave		Initial release