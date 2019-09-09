#!/bin/sh


module load OpenDX

echo sim name 
#cd $1

name=${PWD##*/} 
echo $name

cp /home/akubo/myprojects/channelized-pdcs/opendx/SEPT* ./
cp /home/akubo/myprojects/channelized-pdcs/opendx/testC.general ./
cp /home/akubo/myprojects/channelized-pdcs/opendx/topo* ./


dx -nodisplay -execonly -script SEPTkubo_maptoplane.net

#mkdir ~/myprojects/graphics/visuals/$sim
#cp *tif* ~/myprojects/graphics/visuals/$sim
datum=$(date +"%D %R")

echo -e "$datum ran SEPTkubo_mapptoplane.net" >>   status.txt
echo -e "$datum ran SEPTkubo_mapptoplane.net" >> /home/akubo/myprojects/channelized-pdcs/status_all.txt

