#!/bin/bash

#  Configure-Disable_Adobe_DC_and_Flash_Updates.sh
#  Created by Stephen Warneford-Bygrave on 2015-05-21

# while read -r readerapp; do
# 	readerapp=`find /Applications -type d -maxdepth 3 -name "Adobe Acrobat Reader*.app"`
# 	if [ ! -d "$readerapp" ]
# 		then exit 1
# 		elif [ "$readerapp" = "/Applications/Adobe Acrobat Reader DC.app" ]
# 			then echo $readerapp exists\!
# 			else echo Doesn't exist
# 		fi
# 	fi
# done < <(find /Applications -type d -maxdepth 3 -name 'Adobe Acrobat Reader*.app')

# exit 0

# Disable Acrobat Reader update notifications
echo "<dict>
<key>DC</key>
<dict>
<key>FeatureLockdown</key>
<dict>
<key>bUpdater</key>
<false/>
</dict>
</dict>
</dict>" > /Library/Preferences/com.adobe.Reader.plist

# Disable Flash update notifications
echo AutoUpdateDisable=1 > /Library/Application Support/Macromedia/mms.cfg

exit 0