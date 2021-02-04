#!/bin/sh

#  Install-NYC-jkrSNG_VPN.sh
#  
#
#  Created by Stephen Warneford-Bygrave on 25/03/2015.
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
mount -t afp afp://deploy:D3pl0y11@ny01-arc01/Software /Volumes/.Software

# Create local software repository

mkdir /var/folders/deploy/

# Copy installers to local machine

cp -r /Volumes/.Software/Mac/Cisco/Anyconnect/Current/3/1\ Installer/vpn.pkg /var/folders/deploy/

# Installs VPN client

installer -pkg /var/folders/deploy/vpn.pkg -target /

# Unmounts software share

umount /Volumes/.Software

# Delete local software repository

rm -rf /var/folders/deploy

# Hides the "opt" folder

chflags hidden /opt

# Parses directory services to find all users on the local system, omits system accounts, and sets users as variables

dscl . list /Users | grep -v '^_' | grep -v 'daemon' | grep -v 'Guest' | grep -v 'nobody' | grep -v 'root' | grep -v 'ladmin' | grep -v 'valiant' | grep -v 'vtmgmt' | grep -v 'vtadmin' | while read user

# "Do" loop

do

# Delete all existing user anyconnect preference file

rm /Users/$user/.anyconnect

# creates user anyconnect preference file

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<AnyConnectPreferences>
<DefaultUser>"$user"</DefaultUser>
<DefaultSecondUser></DefaultSecondUser>
<ClientCertificateThumbprint></ClientCertificateThumbprint>
<ServerCertificateThumbprint></ServerCertificateThumbprint>
<DefaultHostName>"https://sngvpn.jkrglobal.com:443/JKR-Office"</DefaultHostName>
<DefaultHostAddress></DefaultHostAddress>
<DefaultGroup></DefaultGroup>
<ProxyHost></ProxyHost>
<ProxyPort></ProxyPort>
<SDITokenType></SDITokenType>
<ControllablePreferences>
<BlockUntrustedServers>false</BlockUntrustedServers>
<AutoConnectOnStart>true</AutoConnectOnStart>
<LocalLanAccess>true</LocalLanAccess></ControllablePreferences>
</AnyConnectPreferences>" > /Users/$user/.anyconnect

# Changes permissions on all anyconnect config files to set to allow editing by owner

chown $user:staff /Users/$user/.anyconnect
chmod 644 /Users/$user/.anyconnect

done

# Deletes existing anyconnect global preference file

rm /opt/cisco/anyconnect/.anyconnect_global

# Creates global anyconnect preference file

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<AnyConnectPreferences>
<DefaultUser></DefaultUser>
<DefaultSecondUser></DefaultSecondUser>
<ClientCertificateThumbprint></ClientCertificateThumbprint>
<ServerCertificateThumbprint></ServerCertificateThumbprint>
<DefaultHostName>"https://sngvpn.jkrglobal.com:443/JKR-Office"</DefaultHostName>
<DefaultHostAddress></DefaultHostAddress>
<DefaultGroup></DefaultGroup>
<ProxyHost></ProxyHost>
<ProxyPort></ProxyPort>
<SDITokenType>none</SDITokenType>
<ControllablePreferences></ControllablePreferences>
</AnyConnectPreferences>" > /opt/cisco/anyconnect/.anyconnect_global

exit 0

# 25/03/2015	v1.0.1	Stephen Warneford-Bygrave 	Initial release