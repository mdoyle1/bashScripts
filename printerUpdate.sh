#!/bin/bash

oldPrinters=(
#old IP 1
#old IP 2
#old IP 3
)

newPrinters=(
#new IP 1 
#new IP 2
#new IP 3
)



for (( i=0; i< ${#oldPrinters[@]}; i++ ))

do
printer=$(lpstat -v | grep lpd://${oldPrinters[$i]} | awk '{print $3}' | tr -d :)
	if [[ -z "$printer" ]]; then 
	echo Printer Doesn\'t Exist!
		else 
		lpadmin -x $printer
		sleep 2
		#update newPrinters with the policys and loop through the policy
		jamf mapPrinter -id "${newPrinters[$i]}"
		fi	
done
