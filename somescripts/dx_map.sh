#!/bin/sh

###ifort convert_KIL.f90 -convert big_endian -o converter.exe
###./converter.exe

module load OpenDX

#echo sim name 
#cd $1

name=${PWD##*/} 
name2="area_$name"
name3="dpu_$name"
echo $name2

#cp ~/myprojects/graphics/*.net $1
#cp ~/myprojects/graphics/*.general $1
#cp ~/myprojects/graphics/*.cfg $1

#now make a copy of single write dx script

#replace the integer 9988 with actual timestep in script. run script.
cat area.net | sed "s/iso_9/$name2/"  > area_temp.net
#cat kubo_script_temp.net | sed "s/testC.general/testC2temp.general/" > kubo_script.net
#cat temp2.cfg | sed s/9988/$i/ > PlumeEP.cfg

echo "3"

dx -nodisplay -execonly -script area_temp.net

echo "4"


#rm temp2.net
#rm temp2.cfg
cat dpu.net | sed "s/iso_9/$name3/"  > dpu_temp.net

dx -nodisplay -execonly -script dpu_temp.net

mkdir ~/myprojects/graphics/visuals/$name
cp *tif* ~/myprojects/graphics/visuals/$name


