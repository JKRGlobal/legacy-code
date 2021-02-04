#!/bin/sh

#  Reset-Microsoft_Office_2011_Identity.sh
#
#
#  Created by Stephen Warneford-Bygrave on 30/01/2015.
#

# Run as user

# Kills all processes related to Office on user's machine

kill $(ps -A | grep [W]ord | awk '{print $1}') 
kill $(ps -A | grep [P]owerpoint | awk '{print $1}') 
kill $(ps -A | grep [E]xcel | awk '{print $1}')
kill $(ps -A | grep [O]utlook | awk '{print $1}') 
kill $(ps -A | grep [M]icrosoft\ AU\ Daemon | awk '{print $1}') 
kill $(ps -A | grep [O]ffice365ServiceV2 | awk '{print $1}') 

# Delete Outlook identity

rm -rf ~/Documents/Microsoft\ User\ Data/Office\ 2011\ Identities

# Delete preferences

rm -rf ~/Library/Saved\ Application\ State/com.microsoft.Outlook.savedState
rm -rf ~/Library/Preferences/com.microsoft.Outlook.plist

exit 0

# 30/01/15  v1.0.1  Stephen Bygrave		Initial release