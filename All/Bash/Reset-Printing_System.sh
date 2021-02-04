#!/bin/sh

#  Reset-Printing_System.sh
#
#
#  Created by Stephen Warneford-Bygrave on 08/01/2015.
#

# Run as root

if

[[ $EUID -ne 0 ]]; then
/bin/echo "This script must run as root."

# Not running as root.

exit 1

fi

# Uses lpstat to read printers installed and uses the names as a variable to delete printers

lpstat -p | awk '{print $2}' | while read printer
do
lpadmin -x $printer
done

# Stops CUPS

launchctl stop org.cups.cupsd 

# Deletes CUPS configuration files

mv /etc/cups/cupsd.conf /etc/cups/cupsd.conf.backup 
cp /etc/cups/cupsd.conf.default /etc/cups/cupsd.conf 
mv /etc/cups/printers.conf /etc/cups/printers.conf.backup 
launchctl start org.cups.cupsd

exit 0

# 08/01/15	v1.0.1	Stephen Bygrave		Initial release