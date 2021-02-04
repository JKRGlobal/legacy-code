#!/bin/sh

#  Prepare-All.sh
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

# Define variables

osvers=$(sw_vers -productVersion | awk -F. '{print $2}')

# Disable saving to iCloud

defaults write /System/Library/User\ Template/English.lproj/Library/Preferences/NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Enable tap to click for this user and for the login screen

defaults write /System/Library/User\ Template/English.lproj/Library/Preferences/com.apple.driver.AppleBluetoothMultitouch.trackpad.plist Clicking -bool true
defaults -currentHost write /System/Library/User\ Template/English.lproj/Library/Preferences/ByHost/NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write /System/Library/User\ Template/English.lproj/Library/Preferences/NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Set power settings for desktops

pmset -c displaysleep 15
pmset -c disksleep 0
pmset -c sleep 0

# Set power settings for laptops

pmset -b displaysleep 10
pmset -b disksleep 30
pmset -b sleep 30

# Configure SSH access

systemsetup -setremotelogin on
dseditgroup -o create -q com.apple.access_ssh
dseditgroup -o edit -a ladmin -t user com.apple.access_ssh

# Turn off Gatekeeper and keep off

spctl --master-disable

defaults write /Library/Preferences/com.apple.security GKAutoRearm -bool false

# Enable users to administer printers

dseditgroup -o edit -n /Local/Default -a everyone -t group lpadmin

# Hide all users with UIDs lower than 500

defaults write /Library/Preferences/com.apple.loginwindow Hide500Users -bool YES

# Always display "Other Users" on login

defaults write /Library/Preferences/com.apple.loginwindow SHOWOTHERUSERS_MANAGED -bool TRUE

# Enable location based time zone

defaults write /Library/Preferences/com.apple.timezone.auto Active -bool true

# Disable Crash Diagnostics on 10.10 

if [[ ${osvers} -ge 10 ]]; then
 
  if [ ! -d /Library/Application\ Support/CrashReporter ]; then
    mkdir /Library/Application\ Support/CrashReporter
    chmod 775 /Library/Application\ Support/CrashReporter
    chown root:admin /Library/Application\ Support/CrashReporter
  fi
 
defaults write /Library/Application\ Support/CrashReporter/DiagnosticMessagesHistory AutoSubmit -boolean FALSE
defaults write /Library/Application\ Support/CrashReporter/DiagnosticMessagesHistory AutoSubmitVersion -int 4
defaults write /Library/Application\ Support/CrashReporter/DiagnosticMessagesHistory ThirdPartyDataSubmit -boolean FALSE
defaults write /Library/Application\ Support/CrashReporter/DiagnosticMessagesHistory ThirdPartyDataSubmitVersion -int 4
chmod a+r /Library/Application\ Support/CrashReporter/DiagnosticMessagesHistory.plist
chown root:admin /Library/Application\ Support/CrashReporter/DiagnosticMessagesHistory.plist
 
fi
 
# Turn off OS X and App Store automatic updates

softwareupdate --schedule off

# Update all software

softwareupdate --install --all

# Hides the "opt" folder

chflags hidden /opt

# Repair disk permissions

diskutil repairPermissions /

# Re-index Spotlight

mdutil -E /

exit 0

# 27/11/14	v1.0.1	Stephen Bygrave		Initial release
# 28/11/14	v1.0.2	Stephen Bygrave		Moved settings from LDN/NYC config
# 09/12/14	v1.0.3	Stephen Bygrave		Added setting to enable location based time zone
# 15/12/14	v1.0.4	Stephen Bygrave		Added conditional script to disable Crash Diagnostics on 10.10 