#!/bin/sh

#  Install-Collect_For_Output.sh
#
#
#  Created by Stephen Warneford-Bygrave on 27/11/2014.

# Run as root

if

[[ $EUID -ne 0 ]]; then
/bin/echo "This script must run as root."

# Not running as root.

exit 1

fi

# Setup "while" loop to create variables

while read -r aiapp; do
	
	aidir="$(dirname "$aiapp")"
	
	# Configure “Collect for Output”
	
	mv "$aidir"/Scripting.localized/Sample\ Scripts.localized/AppleScript.localized/Collect\ for\ Output.localized/CollectForOutput.scpt "$aidir"/Presets.localized/en_GB/Scripts/
	
done < <(find /Applications -type d -maxdepth 3 -name 'Adobe Illustrator*.app')

exit 0

# 27/11/14	v1.0.1	Stephen Bygrave		Initial release