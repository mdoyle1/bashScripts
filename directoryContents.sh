#!/bin/bash

#list directory contents to an array
desktopFiles+=('$(ls -d )')

#show the contents of the array
echo ${desktopFiles[@]}

#show the length of the array
numberOfItems=${#desktopFiles[@]}
