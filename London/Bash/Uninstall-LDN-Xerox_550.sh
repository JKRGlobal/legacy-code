#!/bin/bash

#  Remove all Xerox 550 printers and drivers.sh
#  Created by Stephen Warneford-Bygrave on 2015-10-15

# Run as root; check for superuser elevation (EUID) and exit if check fails
if [[ $EUID -ne 0 ]]; 
	then 
	/bin/echo "This script must run as root."
	exit 1
fi

# Remove all existing Xerox 550 print queues
lpadmin -x "Xerox3"
lpadmin -x "Xerox_3"
lpadmin -x "Xerox_3DPC"
lpadmin -x "Xerox_3DPC_B&W"
lpadmin -x "Xerox_3DPC_Colour"
lpadmin -x "Xerox4"
lpadmin -x "Xerox_4"
lpadmin -x "Xerox_4DPC"
lpadmin -x "Xerox_4DPC_B&W"
lpadmin -x "Xerox_4DPC_Colour"
lpadmin -x "Xerox6"
lpadmin -x "Xerox_6"
lpadmin -x "Xerox_6WPC"
lpadmin -x "Xerox_6WPC_B&W"
lpadmin -x "Xerox_6WPC_Colour"

# Unload and remove Fieryd
launchctl unload /Library/LaunchDaemons/com.efi.fieryd.plist
launchctl unload /Library/LaunchAgents/com.efi.fpdu.plist
rm /Library/LaunchAgents/com.efi.fpdu.plist
rm /Library/LaunchDaemons/com.efi.fieryd.plist
rm /usr/libexec/fieryd

# Remove older PPDs
find / -name Xerox\ Color\ EX\ 550-560 | tr '\n' '\0' | xargs -n 1 -0 sudo rm -f
rm -rf /Applications/Fiery\ Driver\ Updater.app
rm -rf /Library/Printers/Xerox/PDEs/EF018454
rm -rf /Library/Printers/Xerox/PDEs/EF809594

# Forget old Printer installers
pkgutil --forget xerox55010.9 
pkgutil --forget xerox55010.10
pkgutil --forget com.efi.FieryPrinterDriverInstaller
pkgutil --forget com.efi.FieryPrinterDriverPatch
pkgutil --forget com.efi.DriverHarmonyCXP
pkgutil --forget com.efi.DriverJobProperties
pkgutil --forget com.efi.ppdinstaller

exit 0
