#!/bin/bash 

simparam=$(grep -i "$1" /home/akubo/myprojects/channelized-pdcs/simulations.txt)

flux=$(echo $simparam | cut -d\, -f4)
label=$(echo $simparam | cut -d\, -f1)
wave=$(echo $simparam | cut -d\, -f2)
width=$(echo $simparam | cut -d\, -f3)
height=$(echo $simparam | cut -d\, -f5)

echo $label 
echo $wave
echo $width 
echo $flux
echo $height


