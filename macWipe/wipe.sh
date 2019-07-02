#!/bin/bash

# Mac Wipe

# These directions assume you have a USB stick named WIPE with wipe.sh and you are wired to the campus network!

# Directions:
#	1. Wire computer to the network
#	2. Boot to recovery mode CMD+R
#	3. Open Terminal
#	4. Insert your USB with wipe.sh script
#	5. Enter the following command in terminal: cd /Volumes/Wipe
#	6. Run wipe.sh from the current directory: . wipe.sh
#	7. Follow the directions from the script!

# Example
# -bash-3.2# cd /Volumes/Wipe
# -bash-3.2# . wipe.sh
serverLocation="YOUR SERVER GOES HERE"
dateStamp=$(date +%B" "%d", "%Y)
serialNumber=$(ioreg -l | grep IOPlatformSerialNumber |  awk '{print $4}' | sed 's/.//;s/.$//' ) 
eraseMethod="Single-pass zeros"
macintoshHD=$(diskutil list | grep "Macintosh HD" | awk '{print $NF}' | sed 's/.\{2\}$//')
diskSize=$(diskutil info disk0 | grep "Disk Size")
diskType=$(diskutil info disk0 | grep "Solid State")
diskName=$(diskutil info disk0 | grep "Device / Media Name")

echo Welcome to Mac Wipe! Make sure you are wired to the network...
echo Enter your computer\'s Z-Tag.

#GET Z-TAG INFO

x=0
while [ $x == 0 ]
do
	read -p "Z-Tag: " ztag
	read -p "Are you sure, Y or N? " -n 1 -r
	echo    # (optional) move to a new line
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		echo The Z-Tag you entered is $ztag
		x=1
	fi
done

#LOGIN WITH ERROR CHECKING

echo Please enter your credentials...
function login (){
	read -p "Username: " uservar
	read -sp "Password: " passvar
	echo 
	mount -t smbfs "//$uservar:$passvar@$serverLocation" ./
	returnCode=$?
}

login
z=0
while [ $z == 0 ]
do
	if [[ $returnCode == 64 ]] 
	then
	umount //$uservar@ecsu-group2/data_center/common/wipelogs 
	mount -t smbfs "//$uservar:$passvar@$serverLocation" ./
	z=1
		elif [[ $returnCode != 0 ]]
		then
		echo Please re-enter your credentials...
		login
			else
			z=1
fi
done

#DISK WIPE

echo "Wiping disk, Secure Erase will take up to 4 hours."
directory=$(pwd)
echo Current Directory: $directory
eraseStarted=$(date)
standard=$(diskutil eraseDisk JHFS+ Macintosh\ HD disk0)
echo $standard
echo
echo Standard Erase Complete!
y=0
while [ $y == 0 ]
do
	read -p "Proceed with Secure Erase, Y or N? " -n 1 -r
	echo    # (optional) move to a new line
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		secure=$(diskutil secureErase 0 /dev/$macintoshHD)	
		echo $secure
		y=1
		else 
			y=1
	fi
done
eraseFinished=$(date)
echo Erase Complete! Generating Log...

#CREATE RTF LOG

cat >> $serialNumber.rtf <<EOF
{\rtf1\ansi\ansicpg1252\cocoartf1671\cocoasubrtf500
{\fonttbl\f0\fswiss\fcharset0 Helvetica-Bold;\f1\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\margl1440\margr1440\vieww20040\viewh15280\viewkind0
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural\qc\partightenfactor0

\f0\b\fs48 \cf0 Eastern Connecticut State University\\

\fs36 Information Technology Services
\f1\b0 \\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\qc\partightenfactor0

\f0\b \cf0 \ul \ulc0 Apple Wipe Log
\f1\b0 \ulnone \\
$dateStamp\\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\b \cf0 \\
\\
Computer Serial Number: $serialNumber\\
\\
Z-Tag: $ztag \\
\\
Drive Info: \\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f1\b0\fs28 \cf0 $diskName\\
$diskType\\
$diskSize
\fs36 \\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\b \cf0 \\
Started: $eraseStarted\\

\f1\b0 Erase Method: $eraseMethod\\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\fs28 \cf0 $standard
\f0\b \\

\f1\b0 $secure
\f0\b\fs36 \\
Erase Finished: $eraseFinished\\
\\
Wiped By: 
\f1\b0 $uservar}
EOF
echo Log has been uploaded to $serverLocation!
mountLocation=$(df | grep "$serverLocation" | awk '{print $1}')
cd / 
umount $mountLocation
