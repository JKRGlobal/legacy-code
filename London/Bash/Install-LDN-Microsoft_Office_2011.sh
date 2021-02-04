#!/bin/sh

#  Install-LDN-Microsoft_Office_2011.sh
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

# Mount software share

mkdir /Volumes/.Software
mount -t afp afp://deploy:D3pl0y11@LN01-DEP01.jkr.co.uk/Software /Volumes/.Software

# Create local software repository

mkdir /var/folders/deploy/

# Copy installers to local machine

cp -r /Volumes/.Software/Mac/Microsoft/Microsoft\ Office/Current/2011/1\ Installer/Microsoft\ Office\ 2011\ 14.1.0.pkg /var/folders/deploy/
cp -r /Volumes/.Software/Mac/Microsoft/Microsoft\ Office/Current/2011/3\ Updates/Microsoft\ Office\ 2011\ 14.4.7\ Update.pkg /var/folders/deploy/

# Kills all browsers and all Office applications

kill $(ps -A | grep [S]afari | awk '{print $1}')
kill $(ps -A | grep [F]irefox | awk '{print $1}')
kill $(ps -A | grep [O]utlook | awk '{print $1}')
kill $(ps -A | grep [W]ord | awk '{print $1}')
kill $(ps -A | grep [P]owerpoint | awk '{print $1}')
kill $(ps -A | grep [E]xcel | awk '{print $1}')

# Installs Office 2011 365 Base Install

installer -pkg /var/folders/deploy/Microsoft\ Office\ 2011\ 14.1.0.pkg -target /

# Installs Office 2011 14.4.5 update

installer -pkg /var/folders/deploy/Microsoft\ Office\ 2011\ 14.4.7\ Update.pkg -target /

# Unmount software share

umount /Volumes/.Software

# Delete local software repository

rm -rf /var/folders/deploy

exit 0

# 11/12/14  v1.0.1  Stephen Bygrave		Initial release