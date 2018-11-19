#!/bin/bash

#Student App Deployment 

#Apps to install upon enrollment...
enrollmentApps=(
"Adobe Acrobat DC":"acrobat" 
"Microsoft Word.app":"office2019" 
"System Center Endpoint Protection.app":"scepInstall"
"Adobe Audition CC 2018":"audition"
"Adobe Bridge CC 2018":"bridge"
"Adobe Dreamweaver CC 2018":"dreamweaver"
"Adobe Illustrator CC 2018":"illustrator"
"Adobe InDesign CC 2018":"indesign" 
"Adobe Lightroom Classic CC":"lightroom" 
"Adobe Media Encoder CC 2018""mediaEncoder"
"Adobe Photoshop CC 2018":"photoshop" 
"Adobe Prelude CC 2018":"prelude" 
"Adobe Premiere Pro CC 2018":"adobePremiere" 
"Google Chrome.app":"chrome" 
"Firefox.app":"firefox" 
)


#Function to check for and push apps...
function process_arr () {
	declare -a hash=("${!1}")
	for app in "${hash[@]}"; do
		
		if [[ -d "/Applications/${app%%:*}" ]]; then
		echo "The file exists, no install needed."
		else
			echo "The file doesn't exist."
		    jamf policy -event ${app#*:}
		fi
	done
}

process_arr enrollmentApps[@]


