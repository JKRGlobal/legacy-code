#!/bin/bash

#  Install-LDN-Epson_Workshop.sh
#  Created by Adrian Williams on 2017-07-01

# Run as root
if
	[[ $EUID -ne 0 ]];
then
	/bin/echo "This script must run as root."
	exit 1
fi

# Define variables
osvers=$(sw_vers -productVersion | awk -F. '{print $2}')

if
	[[ ${osvers} -ge 10 ]];
then
	ppdloc=/Library/Printers/PPDs/Contents/Resources/Oris.ppd
else
	ppdloc=/Library/Printers/PPDs/Contents/Resources/en.lproj/Oris.ppd
fi

# Removes existing Oris print queues
lpadmin -x "Epson_Gloss_1440"
lpadmin -x "Epson_Gloss_720"
lpadmin -x "Epson_Matte_720"
lpadmin -x "Epson_Satin_1440"
lpadmin -x "Epson_Satin_720"
lpadmin -x "Epson2_Gloss_1440"
lpadmin -x "Epson2_Gloss_720"
lpadmin -x "Epson2_Matte_720"
lpadmin -x "Epson2_Satin_1440"
lpadmin -x "Epson2_Satin_720"
lpadmin -x "Epson_Proof_1440"
lpadmin -x "Epson_Proof_720"
lpadmin -x "Epson2_Proof_1440"
lpadmin -x "Epson2_Proof_720"
lpadmin -x "Epson_7800_Gloss_720"
lpadmin -x "Epson_7800_Matte_720"
lpadmin -x "Epson_7800_Proof_720"
lpadmin -x "Epson_7800_Proof_1440"
lpadmin -x "Epson_7800_Satin_720"
lpadmin -x "Epson_7800_Satin_1440"
lpadmin -x "Epson_7900_Colour_Correct_Gloss_720"
lpadmin -x "Epson_7900_Colour_Correct_Gloss_720_SHEET"
lpadmin -x "Epson_7900_Colour_Correct_Gloss_1440"
lpadmin -x "Epson_7900_Gloss_720"
lpadmin -x "Epson_7900_Gloss_1440"
lpadmin -x "Epson_7900_Matte_720"
lpadmin -x "Epson_7900_Proof_720"
lpadmin -x "Epson_7900_Proof_1440"
lpadmin -x "Epson_7900_Satin_720"
lpadmin -x "Epson_7900_Satin_1440"
lpadmin -x "Epson_7800_A_Gloss_720"
lpadmin -x "Epson_7800_A_Matte_720"
lpadmin -x "Epson_7800_A_Proof_720"
lpadmin -x "Epson_7800_A_Proof_1440"
lpadmin -x "Epson_7800_A_Satin_720"
lpadmin -x "Epson_7800_A_Satin_1440"
lpadmin -x "Epson_7900_A_Colour_Correct_Gloss_720"
lpadmin -x "Epson_7900_A_Colour_Correct_Gloss_1440"
lpadmin -x "Epson_7900_A_Gloss_720"
lpadmin -x "Epson_7900_A_Gloss_1440"
lpadmin -x "Epson_7900_A_Matte_720"
lpadmin -x "Epson_7900_A_Proof_720"
lpadmin -x "Epson_7900_A_Proof_1440"
lpadmin -x "Epson_7900_A_Satin_720"
lpadmin -x "Epson_7900_A_Satin_1440"
lpadmin -x "Proof_ISOv2"
lpadmin -x "Epson_7900_B_ISOv2"
lpadmin -x "Epson_7900_Proof_ISOv2"
lpadmin -x "Epson_7900_B_Proof_ISOv2"
lpadmin -x "Epson_7900_Mars_Proof_ISOv2"
lpadmin -x "Epson_7900_B_Colour_Correct_Gloss_720"
lpadmin -x "Epson_7900_B_Colour_Correct_Gloss_1440"
lpadmin -x "Epson_7900_B_Gloss_720"
lpadmin -x "Epson_7900_B_Gloss_1440"
lpadmin -x "Epson_7900_B_Matte_720"
lpadmin -x "Epson_7900_B_Proof_720"
lpadmin -x "Epson_7900_B_Proof_1440"
lpadmin -x "Epson_7900_B_Satin_720"
lpadmin -x "Epson_7900_B_Satin_1440"
lpadmin -x "Epson_7900_B_Colour_Correct_OrisProof"
lpadmin -x "Epson_7900_A_Colour_Correct_Gloss_720_GRACoL"
lpadmin -x "Epson[A]Matte"
lpadmin -x "Epson(A)Matte"
lpadmin -x "Epson[B]Matte"
lpadmin -x "Epson(B)Matte"
lpadmin -x "Epson[A]Gloss"
lpadmin -x "Epson(A)Gloss"
lpadmin -x "Epson[B]Gloss"
lpadmin -x "Epson(B)Gloss"
lpadmin -x "Epson[A]Satin"
lpadmin -x "Epson(A)Satin"
lpadmin -x "Epson[B]Satin"
lpadmin -x "Epson(B)Satin"
lpadmin -x "Epson-A-OrisPaper"
lpadmin -x "Epson-B-OrisPaper"

# Mount software share
mkdir /Volumes/.Software
mount -t afp afp://deploy:D3pl0y11@LN01-DEP01.jkr.co.uk/Software /Volumes/.Software

# Copy Oris PPD file to local machine 
cp /Volumes/.Software/Mac/Oris/Oris\ RIP/Current/1/1\ Installer/Oris.ppd $ppdloc

# Unmount software share
umount /Volumes/.Software

# Configures main print queues for 7900a/b using lpd
lpadmin -p "Epson(A)Matte" -v lpd://192.168.211.11/Epson-A-Matte_P7000 -D "Epson(A)Matte" -E -P $ppdloc -o printer-is-shared=false
lpadmin -p "Epson[B]Matte" -v lpd://192.168.211.11/E7900B_Matte_720 -D "Epson[B]Matte" -E -P $ppdloc -o printer-is-shared=false
lpadmin -p "Epson(A)Gloss" -v lpd://192.168.211.11/Epson-A-Gloss_P7000 -D "Epson(A)Gloss" -E -P $ppdloc -o printer-is-shared=false
lpadmin -p "Epson[B]Gloss" -v lpd://192.168.211.11/E7900B_Gloss_720 -D "Epson[B]Gloss" -E -P $ppdloc -o printer-is-shared=false
lpadmin -p "Epson(A)Satin" -v lpd://192.168.211.11/Epson-A-Satin_P7000 -D "Epson(A)Satin" -E -P $ppdloc -o printer-is-shared=false
lpadmin -p "Epson[B]Satin" -v lpd://192.168.211.11/E7900B_Satin_720 -D "Epson[B]Satin" -E -P $ppdloc -o printer-is-shared=false
lpadmin -p "Epson-A-OrisPaper" -v lpd://192.168.211.11/Epson-A-OrisPaper_P7000 -D "Epson-A-OrisPaper" -E -P $ppdloc -o printer-is-shared=false
lpadmin -p "Epson-B-OrisPaper" -v lpd://192.168.211.11/E7900B_OrisPaper_ISOv2 -D "Epson-B-OrisPaper" -E -P $ppdloc -o printer-is-shared=false

exit 0