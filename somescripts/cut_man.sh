#!/bin/sh

###ifort convert_KIL.f90 -convert big_endian -o converter.exe
###./converter.exe

module load OpenDX

echo sim name 
#cd $1
here=${PWD}
name=${PWD##*/} 
echo $name

#cp ~/myprojects/graphics/*.net $1
#cp ~/myprojects/graphics/*.general $1
#cp ~/myprojects/graphics/*.cfg $1


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

cd /home/akubo/myprojects/channelized-pdcs/postprocessing/adv_post

sed -i.bak "s|.*tsinplane=.*|tsinplane=$i|" topoonly.f90

cd $here 

#maketopo.sh 

#sleep 6m 

name1="$name$var"

#now update general file

cp testC.general tempEPG.general
file="file=./EP_P_t"
file+=$var
file+=".txt"
cat tempEPG.general | sed "s|.*EP_P_t.*|$file|" > testC2temp.general

rm tempEPG.general

cp cut_200.net temp4.net
cp cut_200.cfg cut_script.cfg
name1+="cut"
echo "8" 
name1+="cut"
cat temp4.net | sed "s/testC.general/testC2temp.general/" > cut_script.net
sed -i "s#iso_9#${name1}#g" cut_script.net

echo "9"

dx -nodisplay -execonly -script cut_script.net


done

echo done
#mkdir ~/myprojects/graphics/visuals/$sim
cp *tif* ~/myprojects/channelized-pdcs/opendx/visualizations

currentdate=$(date +”%m/%d/%Y”)
echo -e "$currentdate ran may figures \n" > status.txt
