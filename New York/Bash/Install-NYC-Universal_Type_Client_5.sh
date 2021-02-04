#!/bin/sh

#  Install-NYC-Universal_Type_Client_5.sh
#  
#
#  Created by Stephen Warneford-Bygrave on 20/04/2015.
#

#!/bin/sh

# Run as root

if

[[ $EUID -ne 0 ]]; then
/bin/echo "This script must run as root."

# Not running as root.

exit 1

fi

# Kills all processes related to UTC on user's machine

kill $(ps -A | grep [U]niversal | awk '{print $1}')

# Mount software share

mkdir /Volumes/.Software
mount -t afp afp://deploy:D3pl0y11@ny01-arc01/Software /Volumes/.Software

# Create local software repository

mkdir /var/folders/deploy/

# Copy files to local machine

cp -r /Volumes/.Software/Mac/Extensis/Universal\ Type\ Client/Current/5.0.0/1\ Installer/Universal\ Type\ Client\ 5.0.0.pkg /var/folders/deploy/
cp -r /Volumes/.Software/Mac/Extensis/Universal\ Type\ Client/Current/5.0.0/5\ Miscellaneous/UT-Client-removal-tool.command /var/folders/deploy/

# Runs the Extensis UTC cleanup script

/var/folders/deploy/UT-Client-removal-tool.command

# Installs the latest version of UTC

installer -pkg /var/folders/deploy/Universal\ Type\ Client\ 5.0.0.pkg -target /

# Unmounts software share

umount /Volumes/.Software

# Delete local software repository

rm -rf /var/folders/deploy

# Creates a preference file that contains the server address and port

echo -e "server.address=NY01-MP02\nserver.port=8080" |  tee /Library/Preferences/com.extensis.UniversalTypeClient.conf

exit 0

# 20/04/2015	v1.0.1	Stephen Bygrave		Initial Release