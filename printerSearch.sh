#!/bin/bash

#printera and printerc should be installed if they arn't allready.
#create a function that checks to see if they already exist if they don't add them 
#if they do exit.

4="/Users/administrator/desktop/bashScripts/test/printer_a.txt"
5="/Users/administrator/desktop/bashScripts/test/printer_c.txt"

localPrinters=( $(ls /Users/administrator/desktop/bashScripts/test ) )
numberOfPrinters=${#localPrinters[@]}

containsElement () {
	local e match="$1"
	shift
	for e 
	do [[ "$e" == "$match" ]] && return 0
	done
	return 1
}

#if echos 0 the file exists if echos 1 the file doesn't exist
containsElement "$4" "${localPrinters[@]}"
echo $?

# checkPrinters () {
#	for (( i=0; i< $numberOfPrinters; i++ ))
#	do
	
#			if [[ ${localPrinters[i]} == $1 || $2 ]]; then 
#		echo Printer already installed
#			else 
#			lpadmin -x $printer
#			sleep 2
			#update newPrinters with the policys and loop through the policy
#			jamf mapPrinter -id "${newPrinters[$i]}"
#			fi	
#	done
#}