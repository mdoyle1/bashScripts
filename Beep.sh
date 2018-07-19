#!/bin/bash

#Enforce Management Framework
#	sudo jamf manage

#Export the date to a file on the users desktop
date +%F\ %T >> ~/Desktop/Date.txt

#Display Message
sudo jamf displayMessage -message "Your Computer Is Now Manged!"

#create a script that makes a beep
echo "echo -ne '\007'" >> /Users/Shared/beep.sh

#Ask the user if they would like to run the beep.sh script
while [[ "$yesOrNo" != "yes" && "$yesOrNo" != "no" ]];do
read -p "Would you like to run beep.sh, yes or no? " answer1
declare yesOrNo="$answer1"
done

#Create a launch agent to execute a script every 5 seconds

if [[ $yesOrNo == "yes" ]]; then
echo ' <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
   "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
   <plist version="1.0">
   <dict>
	<key>Label</key>
	<string>com.beep.sound</string>
	<key>ProgramArguments</key>
	<array>
	     <string>bash</string>
	     <string>/Users/Shared/beep.sh</string>
	</array>
	<key>StartInterval</key>
	<integer>5</integer>
	<key>RunAtLoad</key>
	<true/>
	</dict>
   </plist>
' >> ~/Library/LaunchAgents/com.beep.sound.plist
sudo chown root:wheel ~/Library/LaunchAgents/com.beep.sound.plist
sudo chmod 644 ~/Library/LaunchAgents/com.beep.sound.plist
sudo launchctl start ~/Library/LaunchAgents/com.beep.sound.plist
else 
	echo "The agent will not be loaded"
fi
