#!/bin/bash

echo "Making post processing script"
here=$(pwd)
label=${PWD##*/}



cp /home/akubo/myprojects/channelized-pdcs/testsub.sh $here
sed -i.bak "4s|^.*$|#SBATCH --job-name=conv_$label|" testsub.sh

declare param=($(sh simparam.sh $label))

wave=${param[0]}
amp=${param[1]}
width=${param[2]}

height=${param[3]}

topo="l$wave"
topo+="_A"
topo+="$amp"
topo+="_W"
topo+="$width"
echo $topo
cp /home/akubo/myprojects/channelized-pdcs/topo/topofiles/$topo ./
# check topo 
if [ -s "$topo" ]
then
   echo " $topo file exists and is not empty "
else
   echo "topo error"
   exit 1
fi

echo $topo


#echo how many timesteps 
#timestep=$(checktime2.sh)
#echo $timesteps

echo editing post.f90
if [ -s "EP_P_t08.txt" ]
then
   echo "EP_P_t08 exists and is not empty"
   stat=0  
 else 
   echo "EP_P_t08.txt does not exist"
   stat=2  
fi

cd /home/akubo/myprojects/channelized-pdcs/postprocessing/adv_post
sed -i.bak "s|.*printstatus=.*|printstatus=$stat|" test.f90
sed -i.bak "s|.*simlabel=.*|simlabel='$label'|" test.f90
sed -i.bak "s|.*width=.*|width=$width|" test.f90
sed -i.bak "s|.*lambda=.*|lambda=$wave|" test.f90
sed -i.bak "s|.*depth=.*|depth=$depth|" test.f90
sed -i.bak "s|.*call handletopo(.*|call handletopo('$topo', XXX, YYY, ZZZ)|" test.f90
#sed -i.bak "14s|^.*$|timesteps=$timestep|" post.f90



echo start compliling 

echo compiling modules and subroutines
ifort -c -convert big_endian headermod.f90
ifort -c -convert big_endian formatmod.f90
ifort -c -convert big_endian postmod.f90
ifort -c -convert big_endian constants.f90
ifort -c -convert big_endian openbin.f90
ifort -c -convert big_endian allocate_arrays.f90
ifort -c -convert big_endian handletopo.f90
ifort -c -convert big_endian openascii.f90
ifort -c -convert big_endian var_3d.f90
ifort -c -convert big_endian findhead.f90
ifort -c -convert big_endian entrainment.f90
ifort -c -convert big_endian massinchannel.f90
ifort -c -convert big_endian column.f90
ifort -c -convert big_endian average.f90
ifort -c -convert big_endian richardson.f90

ifort var_3d.o postmod.o formatmod.o headermod.o average.o column.o richardson.o massinchannel.o entrainment.o findhead.o constants.o openbin.o openascii.o allocate_arrays.o handletopo.o test.f90  -convert big_endian -o test.exe


cp test.exe $here 
cp test.f90 $here
cd $here 

echo "submit to run"
sbatch testsub.sh
echo "running"

echo testing!


