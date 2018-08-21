#!/bin/bash

#Checks for Java Version 1.8
REQUESTED_JAVA_VERSION="1.8"
if POSSIBLE_JAVA_HOME="$(/usr/libexec/java_home -v $REQUESTED_JAVA_VERSION 2>/dev/null)"; then
	echo "Java SDK is installed"
else
	echo "Did not find any installed JDK for version $REQUESTED_JAVA_VERSION"
    #Install JAVA JDK8 and JRE through jamf policy
	jamf policy -event jdk8
fi

#Installs Sassv25
/Users/Shared/SPSS_Statistics_Installer.bin  -f "/Users/Shared/installer.properties"

cd /
/Applications/IBM/SPSS/Statistics/25/SPSSStatistics.app/Contents/bin/licenseactivator "YOUR ACTIVATION CODE GOES HERE"
sleep 5

rm -rf /Users/Shared/SPSS_Statistics_Installer.bin
rm -rf /Users/Shared/installer.properties