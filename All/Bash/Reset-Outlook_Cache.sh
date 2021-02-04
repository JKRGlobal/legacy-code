#!/bin/bash

#  Reset-Outlook_Cache.sh
#  Created by Stephen Warneford-Bygrave on 2015-02-24

# Run as root; check for superuser elevation (EUID) and exit if check fails
if [[ $EUID -ne 0 ]]; then 
	/bin/echo "ERROR: Not running as root user. Terminating...."
	exit 1
fi

# Parses directory services to find all users on the local system, omits system accounts, and sets users as variables
dscl . list /Users | grep -v '^_' | grep -v 'daemon' | grep -v 'Guest' | grep -v 'nobody' | grep -v 'root' | while read user

# "Do" loop to delete Office cache from all user home directories
do
	rm -rf "/Users/$user/Library/Caches/Outlook/"*
	rm -rf "/Users/$user/Library/Containers/com.microsoft.Outlook/Data/Library/Caches/com.microsoft.Outlook/"*
	rm -rf "/Users/$user/Library/Group Containers/UBF8T346G9.Office/Outlook/Outlook 15 Profiles/Main Profile/Caches"/*
done

exit 0