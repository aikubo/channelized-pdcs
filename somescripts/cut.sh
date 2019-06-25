#!/bin/sh

###ifort convert_KIL.f90 -convert big_endian -o converter.exe
###./converter.exe

module load OpenDX

echo sim name 
#cd $1

name=${PWD##*/} 
echo $name

cp /home/akubo/myprojects/channelized-pdcs/opendx/cut* ./
cp /home/akubo/myprojects/channelized-pdcs/opendx/testC.general ./
#cp ~/myprojects/graphics/*.general $1
#cp ~/myprojects/graphics/*.cfg $1

if [ "$name" == "sin_20_l400_w50" ] 
	then 
	w=105
elif [ "$name" == "sin_20_18_l800_w50" ] 
	then
        w=85
else
        w=75
fi

echo $w

STR="0"
echo $STR
echo "The value is " $STR

for i in `seq 1 8`
do

   if [ $i -lt 10 ]
   then
   var="0$i"
   echo "The 1st variable is " $var
   elif [ $i -lt 100 ]
   then
   var="$i"
   echo "The 2nd variable is " $var
   else
   var=$i
   echo "The 3rd variable is " $var
   fi

   var2=$i


name1="$name$var"

#now update general file

cp testC.general tempEPG.general

cat tempEPG.general | sed s/EP_P_t08.txt/'EP_P_t'$var'.txt'/ > testC2temp.general

rm tempEPG.general

echo "1"

#now make a copy of single write dx script

cp cut.net temp2.net
cp cut.cfg kubo_script.cfg


echo "2"
#replace the integer 9988 with actual timestep in script. run script.
cat temp2.net | sed "s/iso_9/'cut'$name1/"  > temp3.net

cat temp3.net | sed "s/999/$w/g"  > kubo_script_temp.net

cat kubo_script_temp.net | sed "s/testC.general/testC2temp.general/" > kubo_script.net
#cat temp2.cfg | sed s/9988/$i/ > PlumeEP.cfg

echo "3"

dx -nodisplay -execonly -script kubo_script.net

echo "4"

#rm temp2.net
#rm temp2.cfg


done

echo done
cp cut* /home/akubo/myprojects/graphics/visuals/cuts/
#cp *tif* ~/myprojects/graphics/visuals/$sim

currentdate=$(date +”%m/%d/%Y”)
echo -e "$currentdate ran cut.net \n" > status.txt
