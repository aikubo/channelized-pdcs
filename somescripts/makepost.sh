#!/bin/bash

echo "Making post processing script"
here=$(pwd)
label=${PWD##*/}

cp /home/akubo/myprojects/channelized-pdcs/postsub.sh $here
sed -i.bak "4s|^.*$|#SBATCH --job-name=conv_$label|" postsub.sh

cd /home/akubo/myprojects/channelized-pdcs/postprocessing/adv_post
declare param=($(sh simparam.sh $label))

wave=${param[0]}
width=${param[1]}
height=${param[2]}
depth=${param[3]}

topo="l$wave"
topo+="_w"
topo+="$width"
echo $topo
#echo how many timesteps 
#timestep=$(checktime2.sh)
#echo $timesteps

echo editing post.f90
sed -i.bak "s|.*simlabel=.*|simlabel='$label'|" post.f90
sed -i.bak "s|.*width=.*|width=$width|" post.f90
sed -i.bak "s|.*lambda=.*|lambda=$wave|" post.f90
sed -i.bak "s|.*depth=.*|depth=$depth|" post.f90
sed -i.bak "s|.*call handletopo(.*|call handletopo('$topo', XXX, YYY, ZZZ)|" post.f90
#sed -i.bak "14s|^.*$|timesteps=$timestep|" post.f90

echo start compliling 

echo compiling modules and subroutines
ifort -c -convert big_endian headermod.f90
ifort -c -convert big_endian richardson.f90
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


ifort var_3d.o postmod.o formatmod.o headermod.o average.o column.f90 richardson.o massinchannel.o entrainment.o findhead.o constants.o openbin.o openascii.o allocate_arrays.o handletopo.o post.f90  -convert big_endian -o post.exe


cp post.exe $here 
cp post.f90 $here
cd $here 

echo "submit to run"
sbatch postsub.sh
echo "running"

echo done!


