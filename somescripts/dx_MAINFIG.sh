#!/bin/sh

###ifort convert_KIL.f90 -convert big_endian -o converter.exe
###./converter.exe

module load OpenDX

echo sim name 
#cd $1
here=${PWD}
name=${PWD##*/} 
echo $name

cp ~/myprojects/channelized-pdcs/opendx/kubo* $here
cp ~/myprojects/channelized-pdcs/opendx/*.general $here
#cp ~/myprojects/graphics/*.cfg $1


STR="0"
echo $STR
echo "The value is " $STR

for i in `seq 2 5`
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

cd /home/akubo/myprojects/channelized-pdcs/postprocessing/adv_post

sed -i.bak "s|.*tsinplane=.*|tsinplane=$i|" topoonly.f90

cd $here 

maketopo.sh 

sleep 7m 

name1="$name$var"

#now update general file

cp testC.general tempEPG.general
file="file=./EP_P_t"
file+=$var
file+=".txt"
cat tempEPG.general | sed "s|.*EP_P_t.*|$file|" > testC2temp.general

rm tempEPG.general

echo "1"

#now make a copy of single write dx script

cp ~/myprojects/7_INFLOW/BVY7/kubo_pretty_may.net ./temp2.net
cp ~/myprojects/7_INFLOW/BVY7/kubo_pretty_may.cfg ./kubo_pretty_script.cfg


echo "2"
#replace the integer 9988 with actual timestep in script. run script.
#cat temp2.net | sed "s/iso_9/$name1/"  > kubo_script_temp.net
cat temp2.net | sed "s/testC.general/testC2temp.general/" > kubo_pretty_script.net
sed -i "s#iso_9#$name1#g" kubo_pretty_script.net
#cat temp2.cfg | sed s/9988/$i/ > PlumeEP.cfg

echo "3"

dx -nodisplay -execonly -script kubo_pretty_script.net

done
echo "4"
currentdate=$(date +”%m/%d/%Y”)
echo -e "$currentdate ran may figures \n" > status.txt
