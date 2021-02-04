#!/bin/bash

#  Remove_All_Printers.sh
#  Created by Adrian Williams on 2017-02-28

# Run as root; check for superuser elevation (EUID) and exit if check fails
if [[ $EUID -ne 0 ]]; then 
	/bin/echo "ERROR: Not running as root user. Terminating...."
	exit 1
fi

# Deletes existing Printers
for AdrianLovesPrint in `lpstat -p | awk '{print $2}'`
do
echo Deleting $AdrianLovesPrint
lpadmin -x $AdrianLovesPrint
done

exit 0