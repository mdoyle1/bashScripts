#!/bin/bash

#Sets available printers to the variable array $printer
printers=( $(lpstat -v | awk '{print $3}' | tr -d :) )

#Enter the printer you are searching for...
srcPrinter="$4"

containsElement () {
	# Create local variables for the function.
	local array itemSrc="$1"
	# Shifts parameters to the left.
	shift
	for array 
	# Return 0 if item exists
	do [[ "$array" == "$itemSrc" ]] && return 0
	done
	# Return 1 if item doesn't exist
	return 1
}
check=$(echo $?)

# echo $? displays the last functions return value.

if [[ "$check" == "0" ]]; then
	echo "The printer has been mapped"
	else 
		echo "The printer is not available."
		fi
		