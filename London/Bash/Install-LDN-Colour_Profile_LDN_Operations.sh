#!/bin/sh

# Run as root

if

[[ $EUID -ne 0 ]]; then
/bin/echo "This script must run as root."

# Not running as root.

exit 1

fi

# Mount software share

mkdir /Volumes/.Prep
mount -t afp afp://deploy:D3pl0y11@LN01-DEP01.jkr.co.uk/Software /Volumes/.Prep

# Copy profile from share to local machine

cp /Volumes/.Prep/Mac/Adobe/Colour\ Profiles/Operations/jkr-ldn-operations.csf /Library/Application\ Support/Adobe/Color/Settings/Recommended/
cp /Volumes/.Prep/Mac/Adobe/Colour\ Profiles/Operations/jkr-ldn-operations-web.csf /Library/Application\ Support/Adobe/Color/Settings/Recommended/

# Unmount software share

umount /Volumes/.Prep

# Change permissions on colour profile

chmod 644 /Library/Application\ Support/Adobe/Color/Settings/Recommended/jkr-ldn-operations.csf
chmod 644 /Library/Application\ Support/Adobe/Color/Settings/Recommended/jkr-ldn-operations-web.csf

exit 0