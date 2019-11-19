#!/bin/bash

####### set date, run directory, label ##################
datum=$(date +"%D %R")
here=$(pwd)
label=${PWD##*/}

#########################################################
########### topo file name and find timesteps ########
topo=$(sed -n '71 s/^[^=]*=*//p ' init_fvars.f)
topo2=${topo:1:-2}

echo how many timesteps 
timestep=10 #$(checktime2.sh)
echo $timestep

########################################################
git pull
cd ~/myprojects/channelized-pdcs/postprocessing/adv_post/
sed -i.bak "s/.*timesteps=.*/timesteps=$timestep/" makecolumn.f90

sed -i.bak "s/.*call handletopo.*/call handletopo('$topo2', XXX, YYY, ZZZ)/" makecolumn.f90

ifort -c -convert big_endian postmod.f90
ifort -c -convert big_endian constants.f90
ifort -c -convert big_endian openbin.f90
ifort -c -convert big_endian allocate_arrays.f90
ifort -c -convert big_endian handletopo.f90
ifort -c -convert big_endian openascii.f90
ifort -c -convert big_endian var_3d.f90
ifort -c -convert big_endian formatmod.f90
ifort -c -convert big_endian column.f90

ifort formatmod.o var_3d.o postmod.o constants.o openbin.o openascii.o allocate_arrays.o column.o handletopo.o makecolumn.f90  -convert big_endian -o slice.exe

mv slice.exe $here
cd $here

cp ~/myprojects/channelized-pdcs/slice.sh ./

sbatch slice.sh

echo "script complete"

