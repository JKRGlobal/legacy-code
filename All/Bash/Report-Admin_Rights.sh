#!/bin/bash

#  Report-Admin_Rights.sh
#  Created by Stephen Warneford-Bygrave on 2015-02-24

# Run as root; check for superuser elevation (EUID) and exit if check fails
if [[ $EUID -ne 0 ]]; then
	/bin/echo "ERROR: Not running as root user. Terminating...."
	exit 1
fi

# Uses directory services to check all users belonging to "Admin" group
members () { dscl . -list /Users | while read user; do printf "$user "; dsmemberutil checkmembership -U "$user" -G "$*"; done | grep "is a member" | cut -d " " -f 1; }; members admin

exit 0
