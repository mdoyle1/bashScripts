#!/bin/bash
#Print profiles from terminal.

profileName=( "Faculty/Staff Profile" "Base Restrictions" )

for (( i=0; i< ${#profileName[@]}; i++ ))

do
MDMUUID=`profiles -vP | grep "name: ${profileName[i]}" -4 | awk -F": " '/attribute: profileIdentifier/{print $NF}'`
profiles -R -p $MDMUUID
unset MDMUUID
done

#Get the UUID of a specific configuration profile
#profiles -vP | grep "name: Faculty/Staff Profile" -4 | awk -F": " '/attribute: profileIdentifier/{print $NF}'