#!/bin/bash

echo "Making post processing script"
here=$(pwd)
label=${PWD##*/}
cp $here/post.f90 /home/akubo/myprojects/channelized-pdcs/postprocessing/adv_post
cp /home/akubo/myprojects/channelized-pdcs/postsub.sh $here


topo=$(sed -n '71 s/^[^=]*=*//p ' init_fvars.f)
topo2=${topo:1:-2}

echo how many timesteps 
timestep=$(checktime2.sh)
echo $timesteps

sed -i.bak "25s|^.*$|call handletopo('$topo2', XXX, YYY, ZZZ)|" post.f90
sed -i.bak "14s|^.*$|timesteps=$timestep|" post.f90

sed -i.bak "4s|^.*$|#SBATCH --job-name=conv_$label|" postsub.sh

echo start compliling 
cd /home/akubo/myprojects/channelized-pdcs/postprocessing/adv_post

echo compiling modules and subroutines
ifort -c -convert big_endian postmod.f90
ifort -c -convert big_endian constants.f90
ifort -c -convert big_endian openbin.f90
ifort -c -convert big_endian allocate_arrays.f90
ifort -c -convert big_endian handletopo.f90
ifort -c -convert big_endian openascii.f90
ifort -c -convert big_endian var_3d.f90

echo compiling post
ifort var_3d.o postmod.o constants.o openbin.o openascii.o allocate_arrays.o handletopo.o post.f90 -traceback -C  -convert big_endian -o post.exe

cp post.exe $here 

cd $here 

echo "submit to run"
sbatch postsub.sh
echo "running"

echo done!


