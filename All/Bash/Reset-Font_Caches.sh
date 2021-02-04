#!/bin/bash

#  Reset-Font_Caches.sh
#  Created by Stephen Warneford-Bygrave on 2015-02-04

# Run as root; check for superuser elevation (EUID) and exit if check fails
if [[ $EUID -ne 0 ]]; then 
	/bin/echo "ERROR: Not running as root user. Terminating...."
	exit 1
fi

# Parses directories and sets users as variables
dscl . list /Users | grep -v '^_' | grep -v 'daemon' | grep -v 'Guest' | grep -v 'nobody' | grep -v 'root' | while read user

# "Do" loop to remove all Office files from all user home directories
do
	rm -rf /Users/$user/Library/Application\ Support/Microsoft/Office/Preferences/Office\ 2011/Office\ Font\ Cache
done

# Uses the font registration system utility to remove all databases on the system
atsutil databases -remove

exit 0