#!/bin/bash

#JQ is required 
#Enter your Hue URL with code...

#Hue URL
HueURL=""

#Get list of lights...
getLights(){
curl -s -N $HueURL/lights
}

#Access light object status..
state(){
jq '.[] | .name, .state.on'
}

#Check light on off status.
lightStatus(){
getLights | state
}

#Array of light status...
LCreturn=( $(getLights | jq '.[] | .state.on') )

totalLights(){
getLights | jq 'length'
}

#Get a single light
getLight(){
curl -s -N $HueURL/lights/$1 | jq '.name'
}

#Script to turn lights Off
killLights(){
lightOff=$(totalLights)
for i in "${LCreturn[@]}" 
do
curl --request PUT --data '{"on":false}' "$HueURL/lights/$lightOff/state"
lightOff=$(( lightOff - 1 ))
done
}

#Script to turn lights On
lightsOn(){
lightOn=$(totalLights)
for i in "${LCreturn[@]}" 
do
lightsOn=$(curl --request PUT --data '{"on":true}' "$HueURL/lights/$lightOn/state")
lightOn=$(( lightOn - 1 ))
done
}

#Blink Lights
flashLights(){
COUNTER=10
until [ $COUNTER -lt 1 ]; do
	killLights
	sleep 1
	LightsOn
	let COUNTER-=1
done
}

#Set each light name to the array lights
#Use the internal field seperator 
oldifs="$IFS"
IFS=$'\n'
lights=($(echo $getLights | jq '.[] | .name, .state.on'))
IFS="$oldifs"
#show first light
echo ${lights[0]}
#lights array length
echo ${#lights[@]}



