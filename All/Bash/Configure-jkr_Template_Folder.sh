#!/bin/sh

#  Configure-jkr_Template_Folder.sh
#  
#
#  Created by Stephen Warneford-Bygrave on 21/04/2015.
#

# Run as root

if

[[ $EUID -ne 0 ]]; then
/bin/echo "This script must run as root."

# Not running as root.

exit 1

fi

# Create Template directory

mkdir /Library/Application\ Support/jkr\ Templates
chmod 755 /Library/Application\ Support/jkr\ Templates

# Link Template directory inside Adobe Illustrator

find /Applications -type d -maxdepth 3 -name 'Adobe Illustrator*.app' | while read aiapp

do
aidir="$(dirname "$aiapp")"
ln -s /Library/Application\ Support/jkr\ Templates "$aidir"/Cool\ Extras.localized/en_GB/jkr\ Templates
done

exit 0

# 21/04/2015  v1.0.1  Stephen Bygrave		Initial release