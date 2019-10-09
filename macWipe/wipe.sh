#!/bin/bash

# Mac Wipe
# For keeping inventory of surplused macs...

# These directions assume you have a USB stick named WIPE with wipe.sh and you are wired to the campus network!
# If you arn't wired or the computer doesn't have the SMBFS Library loaded the log will be saved to your USB.

# Directions:
#	1. Wire computer to the network
#	2. Boot to recovery mode CMD+R
#	3. Open Terminal
#	4. Insert your USB with wipe.sh script
#	5. Enter the following command in terminal: cd /Volumes/Wipe
#	6. Run wipe.sh from the current directory: . wipe.sh
#	7. Follow the directions from the script!
	
#	
# If SMB is not functioning the wipe log will be stored on the USB.
# You will have to upload the log to ecsu-group2/data_center/common/wipelogs
# The log will be named as the computers serial #
# 
# Example
# -bash-3.2# cd /Volumes/Wipe
# -bash-3.2# . wipe.sh
	
dateStamp=$(date +%B" "%d", "%Y)
serialNumber=$(ioreg -l | grep IOPlatformSerialNumber |  awk '{print $4}' | sed 's/.//;s/.$//' ) 
eraseMethod="Single-pass zeros"
macintoshHD=$(diskutil list | grep "Macintosh HD" | awk '{print $NF}' | sed 's/.\{2\}$//')
diskSize=$(diskutil info disk0 | grep "Disk Size")
diskType=$(diskutil info disk0 | grep "Solid State")
diskName=$(diskutil info disk0 | grep "Device / Media Name")

function clear(){
for i in {0..100}
do
	echo 
	done
}
clear
echo Welcome to Mac Wipe!
echo This script will wipe the Mac and save the log to the following smb location...
echo smb://ecsu-group2/data_center/common/wipelogs
echo If SMB is not available the log will be stored on the USB.
echo
echo
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
clear
echo Please enter your credentials...


function login (){
	
	read -p "Username: " uservar
	read -sp "Password: " passvar
	mkdir /Volumes/WipeLogs
	echo TRYING to run MOUNT_SMBFS....
	mount_smbfs "//$uservar:$passvar@ecsu-group2/data_center/common/wipelogs" /Volumes/WipeLogs
	returnCode=$?
}

login

z=0
smb=0
computer=0

#Check and set the switches..
while [ $z == 0 ]
do
	#If you enter the wrong credentials...
	if [[ $returnCode == 64 ]] 
	then
	#umount //$uservar@ecsu-group2/data_center/common/wipelogs 
	mount_smbfs "//$uservar:$passvar@ecsu-group2/data_center/common/wipelogs" /Volumes/WipeLogs
	z=1
	#If the computer doesn't have SMBFS library loaded...
		elif [[ $returnCode == 133 ]]
		then
		rm -rf /Volumes/WipeLogs
		echo 
		echo SMB Framework not available! storing wipe log on usb...
		echo 
		z=1
		smb=1
		computer=1
			# If error is unaccounted for...
			elif [[ $returnCode != 133 || $returnCode != 64 ]]
				then
				clear
				echo Please re-enter your credentials...
				clear
				login
			else
			z=1
fi
done

#DISK WIPE
function wipe(){
clear
directory=$(pwd)
echo Current Directory: $directory
echo Prepairing to erase: $macintoshHD
eraseStarted=$(date)
standard=$(diskutil eraseVolume JHFS+ Macintosh\ HD /dev/disk0s2)
echo $standard
echo %%%%%%%%%%%%%%%%%%%%%%%%%%
echo %Standard Erase Complete!%
echo %%%%%%%%%%%%%%%%%%%%%%%%%%
eraseFinished=$(date)
clear
y=0
if [[ computer == 0 ]]
then
while [ $y == 0 ]
do
	echo "Wiping disk, Secure Erase will take up to 4 hours."
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
clear
echo ..................................
echo -Erase Complete! Generating Log...
echo ----------------------------------
fi
}

function logCreated(){
echo @@@@@ Wipe Complete @@@@@
echo @ Log has been created! @
echo @@@@@@@@@@@@@@@@@@@@@@@@@
}

function disMount(){
clear
echo ==================================================================
echo Log has been uploaded to ecsu-group2/data_center/common/wipelogs!
echo ==================================================================
clear
mountLocation=$(df | grep "ecsu-group2/data_center/common/wipelogs" | awk '{print $1}')
cd / 
umount $mountLocation
}

if [[ smb == 0 ]]
then
wipe
disMount
logCreated
	else 
	cd /Volumes/Wipe
    wipe
	logCreated
	echo Please upload the file to ecsu-group2/data_center/common/wipelogs
fi
		
	
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
\f1\b0 $uservar@easternct.edu}
EOF
