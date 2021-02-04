#!/bin/bash

#  Install-LDN-HP_NewBusiness.sh
#  Created by Stephen Warneford-Bygrave on 2015-6-17

# Run as root; check for superuser elevation (EUID) and exit if check fails
if [[ $EUID -ne 0 ]]; 
    then 
    /bin/echo "This script must run as root."
    exit 1
fi

# Define variables
osvers=$(sw_vers -productVersion | awk -F. '{print $2}')

# Deletes existing New Business Printers
lpadmin -x "HP_NewBusiness"
lpadmin -x "panda"
lpadmin -x "hp_panda"

# Setup Generic PPD if OS is >= 10.10
if [[ ${osvers} -ge 10 ]]; then
    lpadmin -p "HP_NewBusiness" -v lpd://192.168.211.15/ -D "HP_NewBusiness" -E -P "/System/Library/Frameworks/ApplicationServices.framework/Frameworks/PrintCore.framework/Resources/Generic.ppd" -o printer-is-shared=false -o HPOption_Duplexer=True -o Duplex=DuplexNoTumble
else
    if [ ! -f /Library/Printers/hp/PDEs/PDE.plugin ]; then

        # Mount Software folder
        mkdir /Volumes/.Software
        mount -t afp afp://deploy:D3pl0y11@LN01-DEP01.jkr.co.uk/Software /Volumes/.Software

        # Create local software repository
        mkdir /var/folders/deploy/

        # Copy installers to local machine
        cp -r /Volumes/.Software/Mac/HP/All-In-One\ Driver/Current/3/1\ Installer/HewlettPackardPrinterDrivers.pkg /var/folders/deploy/

        # Unmount Software folder
        umount /Volumes/.Software

        # Install driver
        installer -pkg /var/folders/deploy/HewlettPackardPrinterDrivers.pkg -target /

        # Configure printers using lpd
        lpadmin -p "HP_NewBusiness" -v lpd://192.168.211.15/ -D "HP_NewBusiness" -E -P "/Library/Printers/PPDs/Contents/Resources/en.lproj/HP Laserjet 5200.gz" -o printer-is-shared=false -o HPOption_Duplexer=True -o Duplex=DuplexNoTumble
    else

        # Configure printers using lpd
        lpadmin -p "HP_NewBusiness" -v lpd://192.168.211.15/ -D "HP_NewBusiness" -E -P "/Library/Printers/PPDs/Contents/Resources/en.lproj/HP Laserjet 5200.gz" -o printer-is-shared=false -o HPOption_Duplexer=True -o Duplex=DuplexNoTumble
    fi
fi

exit 0