#!/bin/bash

#  Configure-NYC-jkr_Bookmarks.sh
#  Created by Stephen Warneford-Bygrave on 2015-03-18

# Run as root; check for superuser elevation (EUID) and exit if check fails
if [[ $EUID -ne 0 ]]; 
then 
	/bin/echo "This script must run as root."
	exit 1
fi

# Parses directory services to find all users on the local system, omits system accounts, and sets users as variables
dscl . list /Users | grep -v '^_' | grep -v 'daemon' | grep -v 'Guest' | grep -v 'nobody' | grep -v 'root' | grep -v 'vtadmin' | grep -v 'ladmin' | grep -v 'vtmgmt' | while read user

# Find all users and add as variables in order to find locations of Bookmarks.xml
do

	# Convert Bookmark plists to XML format
	plutil -convert xml1 /Users/$user/Library/Safari/Bookmarks.plist

	# Find and Replace contents of bookmarks.plist
	# sed -i'.bak' 's/http:\/\/ldnftp.jkrglobal.com\//https:\/\/jkrglobal.ftpstream.com\//g' /Users/$user/Library/Safari/Bookmarks.plist
	# sed -i'.bak' 's/https:\/\/ldnftp.jkrglobal.com\//https:\/\/jkrglobal.ftpstream.com\//g' /Users/$user/Library/Safari/Bookmarks.plist
	# sed -i'.bak' 's/http:\/\/jkrglobal.ftpstream.com\//https:\/\/jkrglobal.ftpstream.com\//g' /Users/$user/Library/Safari/Bookmarks.plist
	sed -i'.bak' 's/https:\/\/secure.sslpost.com\/app\/login\/?next=\/app\//https:\/\/ihcm.adp.com\//g' /Users/$user/Library/Safari/Bookmarks.plist

	# Convert bookmarks.plist back into binary
	plutil -convert binary1 /Users/$user/Library/Safari/Bookmarks.plist

done

exit 0