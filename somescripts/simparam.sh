#!/bin/bash 

simparam=$(grep -i "$1" /home/akubo/myprojects/channelized-pdcs/simulations.txt)

label=$(echo $simparam | cut -d\, -f1)
wave=$(echo $simparam | cut -d\, -f2)
amp=$(echo $simparam | cut -d\, -f3)
width=$(echo $simparam | cut -d\, -f4)
depth=$(echo $simparam | cut -d\, -f5)
height=$(echo $simparam | cut -d\, -f6)

#echo $label 
echo $wave
echo $amp
echo $width
echo $depth 
echo $height


