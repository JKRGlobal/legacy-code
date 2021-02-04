#!/bin/bash

#  Reset-Search_Domains.sh
#  Created by Stephen Warneford-Bygrave on 2015-02-13

exit 0

# Run as root 

if

[[ $EUID -ne 0 ]]; then
/bin/echo "This script must run as root."

# Not running as root.

exit 1

fi

# Determines all network services and sets as variables

networksetup -listallnetworkservices | tail -n +2 | while read service

# "Do" loop

do

# creates user anyconnect preference file

networksetup -getsearchdomains "$service" ^empty^

done

exit 0

# 13/02/15  v1.0.1	Stephen Bygrave		Initial release
