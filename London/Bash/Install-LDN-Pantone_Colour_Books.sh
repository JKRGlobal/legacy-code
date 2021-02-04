#!/bin/bash

#  Install-LDN-Pantone_Colour_Books_V3.sh
#  Created by Ellie Shiel on 2017-03-27

# Run as root; check for superuser elevation (EUID) and exit if check fails
if [[ $EUID -ne 0 ]]; then 
	/bin/echo "ERROR: Not running as root user. Terminating...."
	exit 1
fi

# Mount jkr LDN Software share and exit if share doesn't mount
mkdir /Volumes/.Software
mount -t afp afp://deploy:D3pl0y11@LN01-DEP01.jkr.co.uk/Software/ /Volumes/.Software/
if [[ $? -ne 0 ]]; then 
	echo "ERROR: Software share not mounted. Terminating..."
	rmdir /Volumes/.Software
	exit 1
fi


	# Install Colour Books in Illustrator
	while read -r aiapp; do

		aidir="$(dirname "$aiapp")"

		# Create "Old" directory
	    mkdir "$aidir"/Presets.localized/en_GB/Swatches/Color\ Books\ Not\ Used/
		
		# Move existing colour books to "Old" directory
	    find "$aidir"/Presets.localized/en_GB/Swatches/Color\ Books -iname '*.acb'  -exec mv {} "$aidir"/Presets.localized/en_GB/Swatches/Color\ Books\ Not\ Used/ \;
	    find "$aidir"/Presets.localized/en_GB/Swatches/Color\ Books -iname '*.acbi' -exec mv {} "$aidir"/Presets.localized/en_GB/Swatches/Color\ Books\ Not\ Used/ \;
		
		# Copy new colour books
		echo "Copying Colour Books to Illustrator..."
	    cp -r /Volumes/.Software/Mac/Pantone/Colour\ Manager/Current/5\ Miscellaneous/AI\ Colour\ Books/ "$aidir"/Presets.localized/en_GB/Swatches/Color\ Books/
		
		# Change permissions on colour books
	    chmod -R 775 "$aidir"/Presets.localized/en_GB/Swatches/Color\ Books/
	    chown -R root:admin "$aidir"/Presets.localized/en_GB/Swatches/Color\ Books/
		
		# Remove old "Not Used" directories
	    rm -rf "$aidir"/Presets.localized/en_GB/Swatches/Color\ Books/Not\ Used/
	    rm -rf "$aidir"/Presets.localized/en_GB/Swatches/Color\ Books/Old/
	    rm -rf "$aidir"/Presets.localized/en_GB/Swatches/Color\ Books/legacy/

	done < <(find /Applications -type d -maxdepth 3 -name 'Adobe Illustrator*.app')


	# Install Colour Books in Photoshop
	while read -r psapp; do
		
		psdir="$(dirname "$psapp")"

		# Copy new colour books / swatches
		echo "Copying Colour Books to Photoshop..."
	    cp -r /Volumes/.Software/Mac/Pantone/Colour\ Manager/Current/5\ Miscellaneous/PS\ Colour\ Books/ "$psdir"/Presets/Color\ Books/
	    cp -r /Volumes/.Software/Mac/Pantone/Colour\ Manager/Current/5\ Miscellaneous/PS\ Colour\ Swatches/ "$psdir"/Presets/Color\ Swatches/
		
		# Change permissions on colour books / swatches
	    chmod -R 775 "$psdir"/Presets/Color\ Books/
	    chown -R root:admin "$psdir"/Presets/Color\ Books/
	    chmod -R 775 "$psdir"/Presets/Color\ Swatches/
	    chown -R root:admin "$psdir"/Presets/Color\ Swatches/
		
		# Remove old "Not Used" directories
	    rm -rf "$psdir"/Presets/Color\ Books/Not\ Used/
	    rm -rf "$psdir"/Presets/Color\ Books/Old/
	    rm -rf "$psdir"/Presets/Color\ Books/legacy/
	    rm -rf "$psdir"/Presets/Color\ Books\ Not\ Used/
	    rm -rf "$psdir"/Presets/Color\ Swatches/Not\ Used/
	    rm -rf "$psdir"/Presets/Color\ Swatches/Old/
	    rm -rf "$psdir"/Presets/Color\ Swatches/legacy/
	    rm -rf "$psdir"/Presets/Color\ Swatches\ Not\ Used/

	done < <(find /Applications -type d -maxdepth 3 -name 'Adobe Photoshop*.app')


   # Install Colour Books in InDesign
	while read -r idapp; do
		
		iddir="$(dirname "$idapp")"
		
		# Create "Old" directory
	    mkdir "$iddir"/Presets/Swatch\ Libraries\ Not\ Used/
		
		# Move existing colour books to "Old" directory
	    find "$iddir"/Presets/Swatch\ Libraries -iname '*.acb'  -exec mv {} "$iddir"/Presets/Swatch\ Libraries\ Not\ Used/ \;
	    find "$iddir"/Presets/Swatch\ Libraries -iname '*.acbl'  -exec mv {} "$iddir"/Presets/Swatch\ Libraries\ Not\ Used/ \;
		
		# Copy new colour books
		echo "Copying Colour Books to InDesign..."
	    cp -r /Volumes/.Software/Mac/Pantone/Colour\ Manager/Current/5\ Miscellaneous/ID\&IC\ Colour\ Books/ "$iddir"/Presets/Swatch\ Libraries/
		
		# Change permissions on colour books / swatches
	    chmod -R 775 "$iddir"/Presets/Swatch\ Libraries/
	    chown -R root:admin "$iddir"/Presets/Swatch\ Libraries/
			
		# Remove old "Not Used" directories
	    rm -rf "$iddir"/Presets/Swatch\ Libraries/Not\ Used/
	    rm -rf "$iddir"/Presets/Swatch\ Libraries/Old/
	    rm -rf "$iddir"/Presets/Swatch\ Libraries/legacy/
		
	done < <(find /Applications -type d -maxdepth 3 -name 'Adobe InDesign*.app')


# # INCOPY

# while read -r icapp; do
	
# 	icdir="$(dirname "$icapp")"
	
# 	# Create "Old" directory
	
#     mkdir "$icdir"/Presets/Swatch\ Libraries\ Not\ Used/
	
# 	# Move existing colour books to "Old" directory
	
#     find "$icdir"/Presets/Swatch\ Libraries -iname '*.acb'  -exec mv {} "$icdir"/Presets/Swatch\ Libraries\ Not\ Used/ \;
#     find "$icdir"/Presets/Swatch\ Libraries -iname '*.acbl'  -exec mv {} "$icdir"/Presets/Swatch\ Libraries\ Not\ Used/ \;
	
# 	# Copy new colour books
	
#     cp -r /Volumes/.Software/Mac/Pantone/Colour\ Manager/Current/5\ Miscellaneous/ID\&IC\ Colour\ Books/ "$icdir"/Presets/Swatch\ Libraries/
	
# 	# Change permissions on colour books / swatches
	
#     chmod -R 775 "$icdir"/Presets/Swatch\ Libraries/
#     chown -R root:admin "$icdir"/Presets/Swatch\ Libraries/
		
# 	# Remove old "Not Used" directories
	
#     rm -rf "$icdir"/Presets/Swatch\ Libraries/Not\ Used/
#     rm -rf "$icdir"/Presets/Swatch\ Libraries/Old/
#     rm -rf "$icdir"/Presets/Swatch\ Libraries/legacy/
	
# done < <(find /Applications -type d -maxdepth 3 -name 'Adobe InCopy*.app')

# Unmount software folder

umount /Volumes/.Software

exit 0