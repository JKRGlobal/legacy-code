#!/bin/bash

#  Reset-DNS_Caches.sh
#  Created by Stephen Warneford-Bygrave on 2014-11-25

# Run as root; check for superuser elevation (EUID) and exit if check fails
if [[ $EUID -ne 0 ]]; 
then 
	/bin/echo "This script must run as root."
	exit 1
fi

# Define variables
swvers=$(/usr/bin/sw_vers -productVersion)

if
	[[ ${osvers} = 10.10 ]] || [[ ${osvers} = 10.10.0 ]] || [[ ${osvers} = 10.10.1 ]] || [[ ${osvers} = 10.10.2 ]] || [[ ${osvers} = 10.10.3 ]]; then

	# Flushes cache using dscacheutil (10.10-10.10.3)
	echo "This machine is 10.10.0 - 10.10.3. Using discoveryd"
	/usr/sbin/discoveryutil mdnsflushcache
	/usr/sbin/discoveryutil udnsflushcaches
	/bin/launchctl unload -w /System/Library/LaunchDaemons/com.apple.discoveryd.plist
	/bin/launchctl load -w /System/Library/LaunchDaemons/com.apple.discoveryd.plist
else

	# Flushes cache using dscacheutil (10.7-9, 10.10.4+)
	echo "This machine is 10.7-10.9, or 10.10.4+"
	/usr/bin/dscacheutil -flushcache
	/usr/bin/killall -HUP mDNSResponder
	/bin/launchctl unload -w /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist
	/bin/launchctl load -w /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist
fi

exit 0