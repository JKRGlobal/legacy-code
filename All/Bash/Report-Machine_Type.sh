#!/bin/sh

#  Report-Machine_Type.sh
#
#
#  Created by Stephen Warneford-Bygrave on 08/12/2014.
#

# Run as root

if

[[ $EUID -ne 0 ]]; then
/bin/echo "This script must run as root."

# Not running as root.

exit 1

fi

# Get machine model

model=`/usr/sbin/ioreg -c IOPlatformExpertDevice | grep "model" | awk -F\" '{ print $4 }'`

# echo the workflow ID or title prefixed by "RuntimeSelectWorkflow:" according to the machine model

if [[ "${model}" == MacBook* ]]
then
	echo "RuntimeSelectWorkflow: 33870266-811F-495E-B241-75B9409DB11A"
fi

exit 0

# 08/12/14	v1.0.1	Stephen Bygrave		Initial release