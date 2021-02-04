#!/bin/bash

#	Install-Pegasus.sh
#	Created by Stephen Warneford-Bygrave on 2016-03-18

# Run as normal user; check for superuser elevation (EUID) and exit if check succeeds
if [[ $EUID -eq 0 ]]; then
	/bin/echo "ERROR: Running as super user. This script needs to be run as a user that is currently logged in. Terminating...."
	exit 1
fi

# Check to see current user and assign as a variable
usr=`whoami`

# # Check to see whether Pegasus is already installed
# if ls "/Users/$USR/Library/Application Support/Oracle/Java/Deployment/cache/6.0/bundles/Pegasus Workbook"* 1> /dev/null 2>&1; then
# 	/bin/echo "Pegasus already installed. Terminating..."
# 	exit 1
# fi

# Set log file
logfile="/Users/$usr/Library/Logs/jkrScripts.log"

# Check to see if machine has an internet connection
/bin/echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1

if [ $? -ne 0 ]; then
	/usr/bin/osascript -e 'tell app "System Events" to display alert "To run the Pegasus installer, an internet connection is required." message "Please connect to the internet and try running the installer again." buttons {"OK"} default button 1 as warning'
	/bin/echo "No internet connection detected. Terminating..." > $logfile
	exit 1
fi

# Check to see whether Pegasus config exists; If it does, remove it.
if [ -f "/Users/$usr/Library/Preferences/com.pegasussys.crossapps.plist" ]; then
	/bin/echo "Pegasus config exists. Removing old config..."
	/usr/bin/defaults delete "/Users/$usr/Library/Preferences/com.pegasussys.crossapps.plist"
fi

# Echo out Config plist
/bin/echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
	<dict>
		<key>/com/pegasussys/crossApps/</key>
		<dict>
			<key>pegasusSoftware/</key>
			<dict>
				<key>environments/</key>
				<dict>
					<key>env.datalib.001</key>
					<string>JKRDATA</string>
					<key>env.datalib.002</key>
					<string>JKUDATA</string>
					<key>env.datalib.003</key>
					<string>JKGDATA</string>
					<key>env.modslib.001</key>
					<string>.</string>
					<key>env.modslib.002</key>
					<string>.</string>
					<key>env.modslib.003</key>
					<string>.</string>
					<key>env.name.001</key>
					<string>Pegasus Workbook (UK)</string>
					<key>env.name.002</key>
					<string>Pegasus Workbook (US)</string>
					<key>env.name.003</key>
					<string>Pegasus Workbook (SG)</string>
					<key>env.pgmlib.001</key>
					<string>.</string>
					<key>env.pgmlib.002</key>
					<string>.</string>
					<key>env.pgmlib.003</key>
					<string>.</string>
					<key>env.ssl.001</key>
					<string>true</string>
					<key>env.ssl.002</key>
					<string>true</string>
					<key>env.ssl.003</key>
					<string>true</string>
					<key>env.url.001</key>
					<string>pegasussystems.co.uk</string>
					<key>env.url.002</key>
					<string>65.195.121.185</string>
					<key>env.url.003</key>
					<string>pegasussystems.asia</string>
				</dict>
				<key>xa.environmentConverted</key>
				<string>true</string>
			</dict>
		</dict>
	</dict>
</plist>" > "/Users/$usr/Library/Preferences/com.pegasussys.crossapps.plist"

# Convert plist to binary
/usr/bin/plutil -convert xml1 "/Users/$usr/Library/Preferences/com.pegasussys.crossapps.plist"

# Read new preferences file
/usr/bin/defaults read "/Users/$usr/Library/Preferences/com.pegasussys.crossapps.plist"

# Check country and assign as variable
location=`/usr/bin/curl -s http://whatismycountry.com/ | sed -n 's|.*,\(.*\)</h3>|\1|p'`

if [[ $location = "United States" ]]; then
	pegurl="65.195.121.185"
	pegtitle="Pegasus Workbook (US)"
elif [[ $location = "Singapore" ]]; then
	pegurl="www.pegasussystems.asia"
	pegtitle="Pegasus Workbook (SG)"
elif [[ $location = "Thailand" ]]; then
	pegurl="www.pegasussystems.asia"
	pegtitle="Pegasus Workbook (SG)"
else
	pegurl="www.pegasussystems.co.uk"
	pegtitle="Pegasus Workbook (UK)"
fi

# Create temp directory
usrtmp=`/usr/bin/mktemp -d "/tmp/test.XXXX"`

# Echo out Java Web Start file
/bin/echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<jnlp spec=\"1.0+\"
	codebase=\"http://"$pegurl"/pegwebstart\"
	href=\"pegasus.jnlp\">
	<information os=\"Windows\">
		<title>"$pegtitle"</title>
		<vendor>Pegasus Systems Ltd.</vendor>
		<homepage href=\"http://www.pegasussystems.com\" />
		<description>"$pegtitle"</description>
		<icon kind=\"shortcut\" href=\"greenwing.ico\"	 width=\"48\" height=\"48\" />
		<icon href=\"peg_splash.jpg\" kind=\"splash\" />
		<shortcut>
			<desktop/>
		</shortcut>
		<offline-allowed/>
	</information>
	<information os=\"Mac\ OS\ X\">
		<title>"$pegtitle"</title>
		<vendor>Pegasus Systems Ltd.</vendor>
		<homepage href=\"http://www.pegasussystems.com\" />
		<description>"$pegtitle"</description>
		<icon href=\"greenwing.icns\" width=\"256\" height=\"256\" />
		<icon href=\"peg_splash.jpg\" kind=\"splash\" />
		<shortcut>
			<desktop/>
		</shortcut>
		<offline-allowed/>
	</information>
	<information os=\"Linux\">
		<title>"$pegtitle"</title>
		<vendor>Pegasus Systems Ltd.</vendor>
		<homepage href=\"http://www.pegasussystems.com\" />
		<description>"$pegtitle"</description>
		<icon kind=\"shortcut\" href=\"greenwing.ico\"	 width=\"48\" height=\"48\" />
		<icon href=\"peg_splash.jpg\" kind=\"splash\" />
		<shortcut>
			<desktop/>
		</shortcut>
		<offline-allowed/>
	</information>
	<security>
		<all-permissions/>
	</security>
	<resources>
		<j2se version=\"1.5+\" initial-heap-size=\"64m\" max-heap-size=\"128m\"/>
		<jar href=\"central.jar\"	download=\"eager\"/>
		<jar href=\"crossapps.jar\"	download=\"eager\"/>
		<jar href=\"database.jar\"	download=\"eager\"/>
		<jar href=\"expenses.jar\"	download=\"eager\"/>
		<jar href=\"finance.jar\"	download=\"eager\"/>
		<jar href=\"fonts.jar\"	download=\"eager\"/>
		<jar href=\"images.jar\"	download=\"eager\"/>
		<jar href=\"mediaworkbook.jar\"	download=\"eager\"/>
		<jar href=\"pegasus.jar\"	download=\"eager\" main=\"true\" />
		<jar href=\"prodworkbook.jar\"	download=\"eager\"/>
		<jar href=\"reportmanager.jar\"	download=\"eager\"/>
		<jar href=\"reports1.jar\"	download=\"eager\"/>
		<jar href=\"reports2.jar\"	download=\"eager\"/>
		<jar href=\"reports3.jar\"	download=\"eager\"/>
		<jar href=\"reports4.jar\"	download=\"eager\"/>
		<jar href=\"resources.jar\"	download=\"eager\"/>
		<jar href=\"timesheets.jar\"	download=\"eager\"/>
		<jar href=\"lib/animation.jar\"	download=\"eager\"/>
		<jar href=\"lib/apple-extensions.jar\"	download=\"eager\"/>
		<jar href=\"lib/binding.jar\"	download=\"eager\"/>
		<jar href=\"lib/forms.jar\"	download=\"eager\"/>
		<jar href=\"lib/foxtrot.jar\"	download=\"eager\"/>
		<jar href=\"lib/itext.jar\"	download=\"eager\"/>
		<jar href=\"lib/javadatepicker.jar\"	download=\"eager\"/>
		<jar href=\"lib/jh.jar\"	download=\"eager\"/>
		<jar href=\"lib/jPDFViewer.jar\"	download=\"eager\"/>
		<jar href=\"lib/jt400.jar\"	download=\"eager\"/>
		<jar href=\"lib/l2fprod-common-tasks.jar\"	download=\"eager\"/>
		<jar href=\"lib/looks.jar\"	download=\"eager\"/>
		<jar href=\"lib/uif.jar\"	download=\"eager\"/>
		<jar href=\"lib/validation.jar\"	download=\"eager\"/>
		<jar href=\"lib/poi.jar\"	download=\"eager\"/>
		<jar href=\"lib/jep.jar\"	download=\"eager\"/>
		<jar href=\"lib/outlookbar.jar\"	download=\"eager\"/>
		<jar href=\"lib/activation.jar\"	download=\"eager\"/>
		<jar href=\"lib/axiom-api.jar\" download=\"eager\"/>
		<jar href=\"lib/axiom-impl.jar\" download=\"eager\"/>
		<jar href=\"lib/axis2-adb.jar\" download=\"eager\"/>
		<jar href=\"lib/axis2-kernel.jar\" download=\"eager\"/>
		<jar href=\"lib/commons-codec.jar\" download=\"eager\"/>
		<jar href=\"lib/commons-httpclient.jar\" download=\"eager\"/>
		<jar href=\"lib/commons-logging.jar\" download=\"eager\"/>
		<jar href=\"lib/mail.jar\" download=\"eager\"/>
		<jar href=\"lib/neethi.jar\" download=\"eager\"/>
		<jar href=\"lib/wsdl4j.jar\" download=\"eager\"/>
		<jar href=\"lib/XmlSchema.jar\" download=\"eager\"/>
		<jar href=\"lib/smartsolutions_encryptor.jar\" download=\"eager\"/>
		<jar href=\"lib/stax-api.jar\" download=\"eager\"/>
		<jar href=\"lib/wstx-asl.jar\" download=\"eager\"/>
		<jar href=\"lib/ofx4j-pegasus.jar\" download=\"eager\"/>
		<jar href=\"lib/nanoxml.jar\" download=\"eager\"/>
		<jar href=\"lib/ssce.jar\" download=\"eager\"/>
		<jar href=\"lib/batik-awt-util.jar\" download=\"eager\"/>
		<jar href=\"lib/batik-dom.jar\" download=\"eager\"/>
		<jar href=\"lib/batik-svg-dom.jar\" download=\"eager\"/>
		<jar href=\"lib/batik-svggen.jar\" download=\"eager\"/>
		<jar href=\"lib/batik-util.jar\" download=\"eager\"/>
		<jar href=\"lib/batik-xml.jar\" download=\"eager\"/>
		<jar href=\"lib/icepdf-core.jar\" download=\"eager\"/>
		<jar href=\"lib/icepdf-pro.jar\" download=\"eager\"/>
		<jar href=\"lib/icepdf-pro-intl.jar\" download=\"eager\"/>
		<jar href=\"lib/icepdf-viewer.jar\" download=\"eager\"/>
		<jar href=\"lib/levigo-jbig2-imageio.jar\" download=\"eager\"/>
	</resources>
	<application-desc main-class=\"com.pegasussys.pegasus.PegasusMain\"/>
</jnlp>" >> "$usrtmp/Pegasus_Installer.jnlp"

# Run Pegasus installer
/usr/bin/javaws "$usrtmp/Pegasus_Installer.jnlp"

# Cleanup
rm -rf $usrtmp

exit 0
