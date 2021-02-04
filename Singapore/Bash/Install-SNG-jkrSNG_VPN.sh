#!/bin/bash

#  Install-SNG-jkrSNG_VPN.sh
#  Created by Stephen Warneford-Bygrave on 2016-04-17

# Run as root; check for superuser elevation (EUID) and exit if check fails
if [[ $EUID -ne 0 ]]; then
	/bin/echo "ERROR: Not running as root user. Terminating...."
	exit 1
fi

# Mount Software folder
mkdir /Volumes/.Software
mount -t afp afp://deploy:D3pl0y11@SG01-MP01/Software_SG /Volumes/.Software

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
dscl . list /Users | grep -v '^_' | grep -v 'daemon' | grep -v 'Guest' | grep -v 'nobody' | grep -v 'root' | grep -v 'ladmin' | grep -v 'vtadmin' | grep -v 'vtmgmt' | while read user

# "Do" loop to delete all existing Anyconnect configs and create new
do
	rm /Users/$user/.anyconnect
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
