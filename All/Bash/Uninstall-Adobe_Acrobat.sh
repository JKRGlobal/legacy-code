#!/bin/sh

#  Uninstall-Adobe_Acrobat.sh
#  
#
#  Created by Stephen Warneford-Bygrave on 10/04/2015.
#

# Run as root

if

[[ $EUID -ne 0 ]]; then
/bin/echo "This script must run as root."

# Not running as root.

exit 1

fi

# Parses directory services to find all users on the local system, omits system accounts, and sets users as variables

dscl . list /Users | grep -v '^_' | grep -v 'daemon' | grep -v 'Guest' | grep -v 'nobody' | grep -v 'root' | while read user

# "Do" loop to remove all Java files from all user's home dirs

do

rm -rf /Users/$user/Library/Application\ Support/Adobe/Acrobat*
rm -rf /Users/$user/Library/Application\ Support/Adobe/acrobat*
rm -rf /Users/$user/Library/Preferences/com.adobe.Acrobat*
rm -rf /Users/$user/Library/Preferences/com.adobe.acrobat*
rm -rf /Users/$user/Library/Preferences/Acrobat*
rm -rf /Users/$user/Library/Preferences/acrobat*

done

rm -rf /Library/Application\ Support/Adobe/Acrobat*
rm -rf /Library/Application\ Support/Adobe/acrobat*
rm -rf /Library/Internet\ Plug-Ins\AdobePDFViewer.plugin
rm -rf /Library/Internet\ Plug-Ins\AdobePDFViewerNPAPI.plugin
rm -rf /Library/Preferences/com.adobe.Acrobat*
rm -rf /Library/Preferences/com.adobe.acrobat*
rm -rf /Library/Preferences/Acrobat*
rm -rf /Library/Preferences/acrobat*
rm -rf /Applications/Adobe\ Acrobat*
rm -rf /Library/Automator/Save\ as\ Adobe\ PDF.action
rm -rf /Library/PDF\ Services/Save\ as\ Adobe\ PDF.app

exit 0

# 10/04/2015  v1.0.1  Stephen Bygrave		Initial release