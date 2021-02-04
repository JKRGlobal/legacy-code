#!/bin/sh

#  Prepare-All_NYC.sh
#
#
#  Created by Stephen Warneford-Bygrave on 27/11/2014.
#

# Run as root

if

[[ $EUID -ne 0 ]]; then
/bin/echo "This script must run as root."

# Not running as root.

exit 1

fi

# Define all variables

osvers=$(sw_vers -productVersion | awk -F. '{print $2}')

# Copy assets and fonts from file server

mkdir /Volumes/.Prep
mount -t afp afp://deploy:D3pl0y11@LN01-DEP01.jkr.co.uk/Image\ Prep /Volumes/.Prep
mkdir /Library/User\ Pictures/jkr/
cp /Volumes/.Prep/Branding/apple.png /System/Library/PrivateFrameworks/LoginUIKit.framework/Versions/A/Frameworks/LoginUICore.framework/Versions/A/Resources/
cp /Volumes/.Prep/Branding/apple\@2x.png /System/Library/PrivateFrameworks/LoginUIKit.framework/Versions/A/Frameworks/LoginUICore.framework/Versions/A/Resources/
cp /Volumes/.Prep/Branding/apple_s1.png /System/Library/PrivateFrameworks/LoginUIKit.framework/Versions/A/Frameworks/LoginUICore.framework/Versions/A/Resources/
cp /Volumes/.Prep/Branding/apple_s1\@2x.png /System/Library/PrivateFrameworks/LoginUIKit.framework/Versions/A/Frameworks/LoginUICore.framework/Versions/A/Resources/
cp /Volumes/.Prep/Branding/appleLinen.png /System/Library/PrivateFrameworks/LoginUIKit.framework/Versions/A/Frameworks/LoginUICore.framework/Versions/A/Resources/
cp /Volumes/.Prep/Branding/appleLinen\@2x.png /System/Library/PrivateFrameworks/LoginUIKit.framework/Versions/A/Frameworks/LoginUICore.framework/Versions/A/Resources/
chmod 644 /System/Library/PrivateFrameworks/LoginUIKit.framework/Versions/A/Frameworks/LoginUICore.framework/Versions/A/Resources/apple*

cp /Volumes/.Prep/Branding/jkr_logo.tif /Library/User\ Pictures/jkr/
cp /Volumes/.Prep/Branding//valiant_logo.tif /Library/User\ Pictures/jkr/
chmod 644 /Library/User\ Pictures/jkr/*

mkdir /System/Library/User\ Template/English.lproj/Library/Safari/
cp /Volumes/.Prep/User\ Templates/default\ user/Bookmarks_NY.plist /System/Library/User\ Template/English.lproj/Library/Safari/Bookmarks.plist
chmod -R 644 /System/Library/User\ Template/English.lproj/Library/Safari/
chmod 755 /System/Library/User\ Template/English.lproj/Library/Safari/
chown -R root:wheel /System/Library/User\ Template/English.lproj/Library/Safari/

mkdir /System/Library/User\ Template/English.lproj/Library/Preferences/ByHost

umount /Volumes/.Prep

# Set login message

/usr/libexec/PlistBuddy /Library/Preferences/com.apple.loginwindow.plist -c "Add :LoginwindowText string If\ this\ computer\ has\ been\ found\,\ please\ email\ itsupport\@jkrglobal\.com\,\ or\ call\ 347 205 8200\."

# Set screensaver

defaults -currentHost write /System/Library/User\ Template/English.lproj/Library/Preferences/ByHost/com.apple.screensaver moduleDict -dict moduleName Computer\ Name path /System/Library/Frameworks/ScreenSaver.framework/Resources/Computer\ Name.saver type -int 0
defaults -currentHost write /System/Library/User\ Template/English.lproj/Library/Preferences/ByHost/com.apple.screensaver showClock -bool YES
defaults -currentHost write /System/Library/User\ Template/English.lproj/Library/Preferences/ByHost/com.apple.screensaver CleanExit YES
defaults -currentHost write /System/Library/User\ Template/English.lproj/Library/Preferences/ByHost/com.apple.screensaver idleTime -int 300
defaults -currentHost write /System/Library/User\ Template/English.lproj/Library/Preferences/ByHost/com.apple.screensaver PrefsVersion -int 100
defaults -currentHost write /System/Library/User\ Template/English.lproj/Library/Preferences/ByHost/com.apple.screensaver askForPassword -int 1
defaults -currentHost write /System/Library/User\ Template/English.lproj/Library/Preferences/ByHost/com.apple.screensaver askForPasswordDelay -int 0

# Set Finder “connect to” favourites

/usr/libexec/PlistBuddy -c 'add favoriteservers dict' /System/Library/User\ Template/English.lproj/Library/Preferences/com.apple.sidebarlists.plist
/usr/libexec/PlistBuddy -c 'delete favoriteservers:CustomListItems' /System/Library/User\ Template/English.lproj/Library/Preferences/com.apple.sidebarlists.plist
/usr/libexec/PlistBuddy -c 'add favoriteservers:CustomListItems array' /System/Library/User\ Template/English.lproj/Library/Preferences/com.apple.sidebarlists.plist
/usr/libexec/PlistBuddy -c 'add favoriteservers:Controller string "CustomListItems"' /System/Library/User\ Template/English.lproj/Library/Preferences/com.apple.sidebarlists.plist
/usr/libexec/PlistBuddy -c 'add favoriteservers:CustomListItems:0:Name string "NY01-MP02/Storage NY"' /System/Library/User\ Template/English.lproj/Library/Preferences/com.apple.sidebarlists.plist
/usr/libexec/PlistBuddy -c 'add favoriteservers:CustomListItems:0:URL string "afp://NY01-MP02.jkr.co.uk/Storage%20NY"' /System/Library/User\ Template/English.lproj/Library/Preferences/com.apple.sidebarlists.plist
/usr/libexec/PlistBuddy -c 'add favoriteservers:CustomListItems:1:Name string "NY01-MP02/User Shares NY"' /System/Library/User\ Template/English.lproj/Library/Preferences/com.apple.sidebarlists.plist
/usr/libexec/PlistBuddy -c 'add favoriteservers:CustomListItems:1:URL string "afp://NY01-MP02.jkr.co.uk/User%20Shares%20NY"' /System/Library/User\ Template/English.lproj/Library/Preferences/com.apple.sidebarlists.plist
/usr/libexec/PlistBuddy -c 'add favoriteservers:CustomListItems:2:Name string "NY01-MP02/jkr Asset Bank"' /System/Library/User\ Template/English.lproj/Library/Preferences/com.apple.sidebarlists.plist
/usr/libexec/PlistBuddy -c 'add favoriteservers:CustomListItems:2:URL string "afp://NY01-MP02.jkr.co.uk/jkr%20Asset%20Bank"' /System/Library/User\ Template/English.lproj/Library/Preferences/com.apple.sidebarlists.plist

# Configure default Dock settings

if [[ ${osvers} -ge 9 ]];
	then 
		dockloc="en.lproj"
	else
		dockloc="English.lproj"
fi

rm /System/Library/CoreServices/Dock.app/Contents/Resources/$dockloc/default.plist
/usr/libexec/PlistBuddy -c 'add persistent-apps array' /System/Library/CoreServices/Dock.app/Contents/Resources/$dockloc/default.plist
/usr/libexec/PlistBuddy -c 'add persistent-apps:0:tile-data:file-data:_CFURLString string "/Applications/Safari.app"' /System/Library/CoreServices/Dock.app/Contents/Resources/$dockloc/default.plist
/usr/libexec/PlistBuddy -c 'add persistent-apps:0:tile-data:file-data:_CFURLStringType integer "0"' /System/Library/CoreServices/Dock.app/Contents/Resources/$dockloc/default.plist
/usr/libexec/PlistBuddy -c 'add persistent-apps:1:tile-data:file-data:_CFURLString string "/Applications/Firefox.app"' /System/Library/CoreServices/Dock.app/Contents/Resources/$dockloc/default.plist
/usr/libexec/PlistBuddy -c 'add persistent-apps:1:tile-data:file-data:_CFURLStringType integer "0"' /System/Library/CoreServices/Dock.app/Contents/Resources/$dockloc/default.plist
/usr/libexec/PlistBuddy -c 'add persistent-apps:2:tile-data:file-data:_CFURLString string "/Applications/Google Chrome.app"' /System/Library/CoreServices/Dock.app/Contents/Resources/$dockloc/default.plist
/usr/libexec/PlistBuddy -c 'add persistent-apps:2:tile-data:file-data:_CFURLStringType integer "0"' /System/Library/CoreServices/Dock.app/Contents/Resources/$dockloc/default.plist
/usr/libexec/PlistBuddy -c 'add persistent-apps:3:tile-data:file-data:_CFURLString string "/Applications/iTunes.app"' /System/Library/CoreServices/Dock.app/Contents/Resources/$dockloc/default.plist
/usr/libexec/PlistBuddy -c 'add persistent-apps:3:tile-data:file-data:_CFURLStringType integer "0"' /System/Library/CoreServices/Dock.app/Contents/Resources/$dockloc/default.plist
/usr/libexec/PlistBuddy -c 'add persistent-others array' /System/Library/CoreServices/Dock.app/Contents/Resources/$dockloc/default.plist
/usr/libexec/PlistBuddy -c 'add version integer "1"' /System/Library/CoreServices/Dock.app/Contents/Resources/$dockloc/default.plist
chown root:wheel /System/Library/CoreServices/Dock.app/Contents/Resources/$dockloc/default.plist
chmod 644 /System/Library/CoreServices/Dock.app/Contents/Resources/$dockloc/default.plist

# creates user anyconnect preference file

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<AnyConnectPreferences>
<DefaultUser></DefaultUser>
<DefaultSecondUser></DefaultSecondUser>
<ClientCertificateThumbprint></ClientCertificateThumbprint>
<ServerCertificateThumbprint></ServerCertificateThumbprint>
<DefaultHostName>"https://nycvpn.jkrglobal.com:443/JKR-Office"</DefaultHostName>
<DefaultHostAddress></DefaultHostAddress>
<DefaultGroup></DefaultGroup>
<ProxyHost></ProxyHost>
<ProxyPort></ProxyPort>
<SDITokenType></SDITokenType>
<ControllablePreferences>
<BlockUntrustedServers>false</BlockUntrustedServers>
<AutoConnectOnStart>true</AutoConnectOnStart>
<LocalLanAccess>true</LocalLanAccess></ControllablePreferences>
</AnyConnectPreferences>" > /System/Library/User\ Template/English.lproj/.anyconnect

# Creates global anyconnect preference file

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<AnyConnectPreferences>
<DefaultUser></DefaultUser>
<DefaultSecondUser></DefaultSecondUser>
<ClientCertificateThumbprint></ClientCertificateThumbprint>
<ServerCertificateThumbprint></ServerCertificateThumbprint>
<DefaultHostName>"https://nycvpn.jkrglobal.com:443/JKR-Office"</DefaultHostName>
<DefaultHostAddress></DefaultHostAddress>
<DefaultGroup></DefaultGroup>
<ProxyHost></ProxyHost>
<ProxyPort></ProxyPort>
<SDITokenType>none</SDITokenType>
<ControllablePreferences></ControllablePreferences>
</AnyConnectPreferences>" > /opt/cisco/anyconnect/.anyconnect_global

# Create Cyberduck bookmark folder

mkdir /System/Library/User\ Template/English.lproj/Library/Application\ Support/Cyberduck/
mkdir /System/Library/User\ Template/English.lproj/Library/Application\ Support/Cyberduck/Bookmarks/

# Configure Cyberduck Bookmarks

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
<key>Access Timestamp</key>
<string>1416577067939</string>
<key>Hostname</key>
<string>jkrglobal.ftpstream.com</string>
<key>Nickname</key>
<string>jkr LDN – FTP</string>
<key>Port</key>
<string>22</string>
<key>Protocol</key>
<string>sftp</string>
<key>UUID</key>
<string>ef586a67-59ac-4ecf-bbc6-a4a93794f171</string>
</dict>
</plist>" > /Users/$user/Library/Application\ Support/Cyberduck/Bookmarks/jkr\ LDN.duck

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
<key>Access Timestamp</key>
<string>1416577067939</string>
<key>Hostname</key>
<string>jkrglobalnewyork.ftpstream.com</string>
<key>Nickname</key>
<string>jkr NYC – FTP</string>
<key>Port</key>
<string>22</string>
<key>Protocol</key>
<string>sftp</string>
<key>UUID</key>
<string>ef586a67-59ac-4ecf-bbc6-a4a93794f171</string>
</dict>
</plist>" > /Users/$user/Library/Application\ Support/Cyberduck/Bookmarks/jkr\ NYC.duck

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
<key>Access Timestamp</key>
<string>1416577067939</string>
<key>Hostname</key>
<string>jkrglobalasia.ftpstream.com</string>
<key>Nickname</key>
<string>jkr SNG – FTP</string>
<key>Port</key>
<string>22</string>
<key>Protocol</key>
<string>sftp</string>
<key>UUID</key>
<string>ef586a67-59ac-4ecf-bbc6-a4a93794f171</string>
</dict>
</plist>" > /Users/$user/Library/Application\ Support/Cyberduck/Bookmarks/jkr\ SNG.duck

# Create Local Administrator

dscl . create /Users/ladmin
dscl . create /Users/ladmin RealName "Local Administrator"
dscl . create /Users/ladmin hint “Normal”
dscl . create /Users/ladmin picture "/Library/User Pictures/jkr/jkr_logo.tif"
dscl . passwd /Users/ladmin hap4Ufar
dscl . create /Users/ladmin UniqueID 401
dscl . create /Users/ladmin PrimaryGroupID 80
dscl . create /Users/ladmin UserShell /bin/bash
dscl . create /Users/ladmin NFSHomeDirectory /Users/ladmin
cp -R /System/Library/User\ Template/English.lproj /Users/ladmin
chown -R ladmin:admin /Users/ladmin

# Configure ladmin environment

rm /Users/ladmin/Library/Preferences/com.apple.desktop.plist > /dev/null 2>&1
/usr/libexec/PlistBuddy /Users/ladmin/Library/Preferences/com.apple.desktop.plist -c 'Add Background:default:BackgroundColor array' > /dev/null 2>&1
/usr/libexec/PlistBuddy /Users/ladmin/Library/Preferences/com.apple.desktop.plist -c 'Add Background:default:BackgroundColor:0 real 0.25'
/usr/libexec/PlistBuddy /Users/ladmin/Library/Preferences/com.apple.desktop.plist -c 'Add Background:default:BackgroundColor:1 real 0.25'
/usr/libexec/PlistBuddy /Users/ladmin/Library/Preferences/com.apple.desktop.plist -c 'Add Background:default:BackgroundColor:2 real 0.25'
/usr/libexec/PlistBuddy /Users/ladmin/Library/Preferences/com.apple.desktop.plist -c 'Add Background:default:DrawBackgroundColor bool true'
/usr/libexec/PlistBuddy /Users/ladmin/Library/Preferences/com.apple.desktop.plist -c 'Add Background:default:ImageFilePath string /System/Library/PreferencePanes/DesktopScreenEffectsPref.prefPane/Contents/Resources/DesktopPictures.prefPane/Contents/Resources/Transparent.png'
/usr/libexec/PlistBuddy /Users/ladmin/Library/Preferences/com.apple.desktop.plist -c 'Add Background:default:NoImage bool true'
chown ladmin:staff /Users/ladmin/Library/Preferences/com.apple.desktop.plist

/usr/libexec/PlistBuddy -c 'add favoriteservers:CustomListItems:3:Name string "NY01-MP02/IT Files"' /Users/ladmin/Library/Preferences/com.apple.sidebarlists.plist
/usr/libexec/PlistBuddy -c 'add favoriteservers:CustomListItems:3:URL string "afp://NY01-MP02.jkr.co.uk/IT%20Files"' /Users/ladmin/Library/Preferences/com.apple.sidebarlists.plist
/usr/libexec/PlistBuddy -c 'add favoriteservers:CustomListItems:4:Name string "jkr-itserver/Software"' /Users/ladmin/Library/Preferences/com.apple.sidebarlists.plist
/usr/libexec/PlistBuddy -c 'add favoriteservers:CustomListItems:4:URL string "afp://jkr-itserver.jkr.co.uk/Software"' /Users/ladmin/Library/Preferences/com.apple.sidebarlists.plist
/usr/libexec/PlistBuddy -c 'add favoriteservers:CustomListItems:5:Name string "jkr-fileserver/IT Files"' /Users/ladmin/Library/Preferences/com.apple.sidebarlists.plist
/usr/libexec/PlistBuddy -c 'add favoriteservers:CustomListItems:5:URL string "afp://jkr-fileserver.jkr.co.uk/IT%20Files"' /Users/ladmin/Library/Preferences/com.apple.sidebarlists.plist 

# Configure default settings for UTC

echo "server.address=jkr-fontserver\nserver.port=8080" |  tee /Library/Preferences/com.extensis.UniversalTypeClient.conf

exit 0

# 27/11/14	v1.0.1	Stephen Bygrave		Initial release
# 28/11/14	v1.0.2	Stephen Bygrave		Moved settings to ALL config
# 10/12/14	v1.0.3	Stephen Bygrave		Amended script to use new "Image Prep" assets folder on DEP01
# 16/03/14	v1.0.4	Stephen Bygrave		Amended FTP locations