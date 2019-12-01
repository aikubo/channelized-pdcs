#!/bin/bash

echo "Making post processing script"
here=$(pwd)
label=${PWD##*/}

rm $label*

cp /home/akubo/myprojects/channelized-pdcs/writeoutsub.sh $here
sed -i.bak "4s|^.*$|#SBATCH --job-name=write_$label|" writeoutsub.sh

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
cd /home/akubo/myprojects/channelized-pdcs/postprocessing/adv_post
git pull
#sed -i.bak "s|.*printstatus=.*|printstatus=$stat|" velocity.f90
sed -i.bak "s|.*simlabel=.*|simlabel='$label'|" velocity.f90
sed -i.bak "s|.*width=.*|width=$width|" velocity.f90
sed -i.bak "s|.*lambda=.*|lambda=$wave|" velocity.f90
sed -i.bak "s|.*depth=.*|depth=$depth|" velocity.f90
sed -i.bak "s|.*call handletopo(.*|call handletopo('$topo', XXX, YYY, ZZZ)|" velocity.f90
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

ifort var_3d.o postmod.o formatmod.o headermod.o average.o column.o richardson.o massinchannel.o entrainment.o findhead.o constants.o openbin.o openascii.o allocate_arrays.o handletopo.o velocity.f90  -convert big_endian -o wo.exe


cp wo.exe $here 
cd $here 

echo "submit to run"
sbatch writeoutsub.sh
echo "running"

echo done!


