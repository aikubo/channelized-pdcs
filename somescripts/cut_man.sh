#!/bin/sh

###ifort convert_KIL.f90 -convert big_endian -o converter.exe
###./converter.exe

module load OpenDX

echo sim name 
#cd $1

name=${PWD##*/} 
echo $name

#cp ~/myprojects/graphics/*.net $1
#cp ~/myprojects/graphics/*.general $1
#cp ~/myprojects/graphics/*.cfg $1
fid='EP_P'
name1="$name$var"

#now update general file

cp /home/akubo/myprojects/channelized-pdcs/opendx/cut_* ./
cp /home/akubo/myprojects/channelized-pdcs/opendx/UG.general ./
cp /home/akubo/myprojects/channelized-pdcs/opendx/testC.general ./

sed -i "s/iso_9/$name/" cut_x100.net
sed -i "s/iso_9/$name/" cut_x200.net
sed -i "s/iso_9/$name/" cut_x300.net

sed -i "s/iso_9/$name/" cut_Ux100.net
sed -i "s/iso_9/$name/" cut_Ux200.net
sed -i "s/iso_9/$name/" cut_Ux300.net

dx -nodisplay -execonly -script cut_x100.net
dx -nodisplay -execonly -script cut_x200.net
dx -nodisplay -execonly -script cut_x300.net

dx -nodisplay -execonly -script cut_Ux100.net
dx -nodisplay -execonly -script cut_Ux200.net
dx -nodisplay -execonly -script cut_Ux300.net

currentdate=$(date +”%m/%d/%Y”)
echo -e "$currentdate $name ran cut_man.sh \n" > status.txt
