#!/bin/bash

#  Install-User_Freelancer.sh
#  Created by Stephen Warneford-Bygrave on 2014/12/12

# Run as root; check for superuser elevation (EUID) and exit if check fails
if [[ $EUID -ne 0 ]]; then 
	/bin/echo "ERROR: Not running as root user. Terminating...."
	exit 1
fi

# Uses dscl command to create user
dscl . -create /Users/freelancer
dscl . -create /Users/freelancer dsAttrTypeNative:_defaultLanguage en
dscl . -create /Users/freelancer dsAttrTypeNative:_writers__defaultLanguage freelancer
dscl . -create /Users/freelancer dsAttrTypeNative:_writers_UserCertificate freelancer
dscl . -create /Users/freelancer RealName "Freelancer"
dscl . -create /Users/freelancer picture "/Library/User Pictures/jkr/jkr_logo.tif"
dscl . -create /Users/freelancer hint “Normal”
dscl . -passwd /Users/freelancer freelancer
dscl . -create /Users/freelancer UniqueID 600
dscl . -create /Users/freelancer PrimaryGroupID 20
dscl . -create /Users/freelancer UserShell /bin/bash
dscl . -create /Users/freelancer NFSHomeDirectory /Users/freelancer

# Copies User Template folder for new user and changes permissions
cp -r /System/Library/User\ Template/English.lproj /Users/freelancer

# Creates Documents folder and changes perms to lock it down
mkdir /Users/freelancer/Documents
chown -R freelancer:staff /Users/freelancer
chmod -R 500 /Users/freelancer/Desktop
chmod -R 500 /Users/freelancer/Documents
chmod -R 500 /Users/freelancer/Movies
chmod -R 500 /Users/freelancer/Music
chmod -R 500 /Users/freelancer/Pictures

# Creates a text file on the desktop detailing these permission restrictions
echo "Filing Work:

On Freelance accounts, saving to Desktop & Documents folder is blocked to ensure all work is saved to the server.

Along with your brief, you will be given a workspace on the server to store your work. Design work MUST be kept in your workspace to ensure data is backed up and searchable. You can ask Traffic to set create workspaces for you.

If a workspace is not available, you can store your files in the \"Freelance NOD\" share until one is created. If you are not assigned a workspace until you leave, then please leaves your files there.

Files stores in \"Freelance NOD\" must be filed using the same folder structure as on the server with the stage and project code. 
" > "/Users/freelancer/Desktop/Saving Files.txt"

exit 0