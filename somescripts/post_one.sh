#!/bin/bash

echo "Making post processing script"
here=$(pwd)
label=${PWD##*/}

rm $label*

cp /home/akubo/myprojects/channelized-pdcs/postsub.sh $here
sed -i.bak "4s|^.*$|#SBATCH --job-name=conv_$label|" postsub.sh

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

amp=$(echo "$amp/100"  | bc -l)

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
git pull
cp post_one.f90 post_one_temp.f90

sed -i.bak "s|.*printstatus=.*|printstatus=$stat|" post_one_temp.f90
sed -i.bak "s|.*simlabel=.*|simlabel='$label'|" post_one_temp.f90
sed -i.bak "s|.*width=.*|width=$width|" post_one_temp.f90
sed -i.bak "s|.*lambda=.*|lambda=$wave|" post_one_temp.f90
sed -i.bak "s|.*depth=.*|depth=$depth|" post_one_temp.f90
sed -i.bak "s|.*amprat=.*|amprat=$amp|" post_one_temp.f90
sed -i.bak "s|.*call handletopo(.*|call handletopo('$topo', XXX, YYY, ZZZ)|" post_one_temp.f90
#sed -i.bak "14s|^.*$|timesteps=$timestep|" post.f90

while true; do 
echo "which of the following subroutines would you like to turn on?"
echo "froude, rigrad, ent, massalloc, xstream, ave, energy, tau"
read -p 'Subroutine: ' subroutine1
sed -i.bak "s|$subroutine1=.*|$subroutine1=.TRUE.|" post_one.f90

echo "would you like to turn on another? y/[N]"
read REPLY
if [[ $REPLY =~ ^[Yy]$ ]]; then
	continue
else [[ $REPLY =~ ^[Nn]$ ]]
	break
fi
done 

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
ifort -c -convert big_endian grangass.f90 

ifort var_3d.o grangass.o postmod.o formatmod.o headermod.o average.o column.o richardson.o massinchannel.o entrainment.o findhead.o constants.o openbin.o openascii.o allocate_arrays.o handletopo.o post_one_temp.f90  -convert big_endian -o post.exe


cp post_one_temp.f90 $here/post_one.f90
cp post.exe $here
rm post_one_temp.f90
cd $here

echo "submit to run"
#sbatch postsub.sh
echo "running"

echo done!


