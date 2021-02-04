#!/bin/sh

#  Uninstall-Microsoft_Office_2011.sh
#
#
#  Created by Stephen Warneford-Bygrave on 11/12/2014.
#

# Run as root

if

[[ $EUID -ne 0 ]]; then
/bin/echo "This script must run as root."

# Not running as root.

exit 1

fi

# Kills all processes related to Office on user's machine

kill $(ps -A | grep [W]ord | awk '{print $1}')
kill $(ps -A | grep [P]owerpoint | awk '{print $1}')
kill $(ps -A | grep [E]xcel | awk '{print $1}')
kill $(ps -A | grep [O]utlook | awk '{print $1}')
kill $(ps -A | grep [M]icrosoft\ AU\ Daemon | awk '{print $1}')
kill $(ps -A | grep [O]ffice365ServiceV2 | awk '{print $1}')

# Delete Office Apps

rm -rf /Applications/Microsoft\ Office\ 2011

# Delete Installed MS Fonts

rm -rf /Library/Fonts/Microsoft

# Move disabled fonts

mv /Library/Fonts\ Disabled/* /Library/Fonts/

# Delete Library Files

rm -rf /Library/Application\ Support/Microsoft
rm -rf /Library/Internet\ Plug-Ins/SharePointBrowserPlugin.plugin
rm -rf /Library/Internet\ Plug-Ins/SharePointWebKitPlugin.webplugin
rm -rf /Library/LaunchDaemons/com.microsoft.office.licensing.helper.plist
rm -rf /Library/Preferences/com.microsoft.office.licensing.plist
rm -rf /Library/PrivilegedHelperTools/com.microsoft.office.licensing.helper

# Parses directory services to find all users on the local system, omits system accounts, and sets users as variables

dscl . list /Users | grep -v '^_' | grep -v 'daemon' | grep -v 'Guest' | grep -v 'nobody' | grep -v 'root' | while read user

# "Do" loop to remove all Office files from all user home directories

do
rm -rf /Users/$user/Documents/Microsoft\ User\ Data
rm -rf /Users/$user/Library/Application\ Support/Microsoft/Office
rm -rf /Users/$user/Library/FontCollections/Windows\ Office\ Compatible.collection
rm -rf /Users/$user/Library/Keychains/Microsoft_Intermediate_Certificates
rm -rf /Users/$user/Library/Preferences/com.microsoft.*
rm -rf /Users/$user/Library/Saved\ Application\ State/com.microsoft.autoupdate2.savedState
rm -rf /Users/$user/Library/Saved\ Application\ State/com.microsoft.Word.savedState
rm -rf /Users/$user/Library/Saved\ Application\ State/com.microsoft.Powerpoint.savedState
rm -rf /Users/$user/Library/Saved\ Application\ State/com.microsoft.Excel.savedState
rm -rf /Users/$user/Library/Saved\ Application\ State/com.microsoft.Outlook.savedState
done

exit 0

# 11/12/14  v1.0.1  Stephen Bygrave		Initial release