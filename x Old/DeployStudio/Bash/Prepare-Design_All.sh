#!/bin/sh

#  Prepare-Design_All.sh
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

# Mount Software folder

mkdir /Volumes/.Software
mount -t afp afp://deploy:D3pl0y11@LN01-DEP01.jkr.co.uk/Software /Volumes/.Software

# Create Template Folder

mkdir /Library/Application\ Support/jkr Templates
chmod 755 /Library/Application\ Support/jkr\ Templates

# ILLUSTRATOR

while read -r aiapp; do
	
	aidir="$(dirname "$aiapp")"

# Create "Old" directory
	
    mkdir "$aidir"/Presets.localized/en_GB/Swatches/Color\ Books\ Old/
	
# Move existing colour books to "Old" directory
	
    mv "$aidir"/Presets.localized/en_GB/Swatches/Color\ Books/* "$aidir"/Presets.localized/en_GB/Swatches/Color\ Books\ Old/
	
# Copy new colour books
	
    cp -r /Volumes/.Software/Mac/Pantone/Colour\ Manager/Current/5\ Miscellaneous/AI\ Colour\ Books/ "$aidir"/Presets.localized/en_GB/Swatches/Color\ Books/
	
# Move "Old" directory inside colour book folder and rename to "Not Used"
	
    mv "$aidir"/Presets.localized/en_GB/Swatches/Color\ Books\ Old/ "$aidir"/Presets.localized/en_GB/Swatches/Color\ Books/Not\ Used/
	
# Change permissions on colour books
	
    chmod -R 775 "$aidir"/Presets.localized/en_GB/Swatches/Color\ Books/*
    chown -R root:admin "$aidir"/Presets.localized/en_GB/Swatches/Color\ Books/*
	
# Configure “Collect for Output”

    mv "$aidir"/Scripting.localized/Sample\ Scripts.localized/AppleScript.localized/Collect\ for\ Output.localized/CollectForOutput.scpt "$aidir"/Presets.localized/en_GB/Scripts/

# Link jkr templates folder to Illustrator

    ln -s /Library/Application\ Support/jkr\ Templates "$aidir"/Cool\ Extras.localized/en_GB/jkr\ Templates
	
done < <(find /Applications -type d -maxdepth 3 -name 'Adobe Illustrator*.app')

# PHOTOSHOP

while read -r psapp; do
	
	psdir="$(dirname "$psapp")"
	
# Create "Old" directories
	
    mkdir "$psdir"/Presets/Color\ Books\ Old/
    mkdir "$psdir"/Presets/Color\ Swatches\ Old/
	
# Move existing colour books / swatches to "Old" directory
	
    mv "$psdir"/Presets/Color\ Books/* "$psdir"/Presets/Color\ Books\ Old/
    mv "$psdir"/Presets/Color\ Swatches/* "$psdir"/Presets/Color\ Swatches\ Old/
	
# Copy new colour books / swatches
	
    cp -r /Volumes/.Software/Mac/Pantone/Colour\ Manager/Current/5\ Miscellaneous/PS\ Colour\ Books/ "$psdir"/Presets/Color\ Books/
    cp -r /Volumes/.Software/Mac/Pantone/Colour\ Manager/Current/5\ Miscellaneous/PS\ Colour\ Swatches/ "$psdir"/Presets/Color\ Swatches/
	
# Move "Old" directory inside colour book / swatch folder and rename to "Not Used"
	
    mv "$psdir"/Presets/Color\ Books\ Old/ "$psdir"/Presets/Color\ Books/Not\ Used/
    mv "$psdir"/Presets/Color\ Swatches\ Old/ "$psdir"/Presets/Color\ Swatches/Not\ Used/
	
# Change permissions on colour books / swatches
	
    chmod -R 775 "$psdir"/Presets/Color\ Books/*
    chown -R root:admin "$psdir"/Presets/Color\ Books/*
    chmod -R 775 "$psdir"/Presets/Color\ Swatches/*
    chown -R root:admin "$psdir"/Presets/Color\ Swatches/*

done < <(find /Applications -type d -maxdepth 3 -name 'Adobe Photoshop*.app')

# INDESIGN

while read -r idapp; do
	
	iddir="$(dirname "$idapp")"
	
# Create "Old" directory
	
    mkdir "$iddir"/Presets/Swatch\ Libraries\ Old/
	
# Move existing colour books to "Old" directory
	
    mv "$iddir"/Presets/Swatch\ Libraries/* "$iddir"/Presets/Swatch\ Libraries\ Old/
	
# Copy new colour books
	
    cp -r /Volumes/.Software/Mac/Pantone/Colour\ Manager/Current/5\ Miscellaneous/ID\&IC\ Colour\ Books/ "$iddir"/Presets/Swatch\ Libraries/
	
# Change permissions on colour books / swatches
	
    chmod -R 775 "$iddir"/Presets/Swatch\ Libraries/*
    chown -R root:admin "$iddir"/Presets/Swatch\ Libraries/*
	
done < <(find /Applications -type d -maxdepth 3 -name 'Adobe InDesign*.app')

# Unmount software folder

umount /Volumes/.Software

exit 0

# 27/11/14  v1.0.1  Stephen Bygrave		Initial release
# 09/12/24  v1.0.2  Stephen Bygrave		Changed Formatting
# 10/12/14  v1.0.3  Stephen Bygrave		Changed location of Colour Books
# 13/02/15  v1.0.4  Stephen Bygrave		Amended colour book location