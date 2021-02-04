#!/bin/bash

#  Reset-NVRAM.sh
#  Created by Stephen Warneford-Bygrave on 2015-10-01

# Run as root; check for superuser elevation (EUID) and exit if check fails
if [[ $EUID -ne 0 ]]; 
then 
	/bin/echo "This script must run as root."
	exit 1
fi

# Clear NVRAM
/usr/sbin/nvram -c

exit 0