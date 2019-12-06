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

cat tempEPG.general | sed s/EP_P_t01.txt/'EP_P_t'$var'.txt'/ > testC2temp.general

rm tempEPG.general

echo "1"

#now make a copy of single write dx script

cp kubo_pretty.net temp2.net
cp kubo_pretty.cfg kubo_pretty_script.cfg


echo "2"
#replace the integer 9988 with actual timestep in script. run script.
echo $name1
cat temp2.net | sed "s/iso_9/$name1/"  > kubo_script_temp.net
cat temp2.net | sed "s/testC.general/testC2temp.general/" > kubo_pretty_script.net
#cat temp2.cfg | sed s/9988/$i/ > PlumeEP.cfg
done 
