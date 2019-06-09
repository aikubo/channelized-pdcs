#!/bin/bash 
# written by AK 
# this script prepares a fortran script for post processing 
# the fortran program, post.f90 produces EPG_t.txt SHUY_t.txt for open dx and calculations of the gradients 
# and richardson numbers
# updated to copy most recent files from git repository


echo TOPO file name? 


currentdate=$(date +”%m/%d/%Y”)
echo $currentdate 


here=$(pwd)
cp /home/akubo/myprojects/channelized-pdcs/postprocessing/post.f90 $here
cp /home/akubo/myprojects/channelized-pdcs/postprocessing/*.f90 $here

#cp /home/akubo/myprojects/channelized-pdcs/opendx/*.net $here
#cp /home/akubo/myprojects/channelized-pdcs/opendx/*.general $here
#cp /home/akubo/myprojects/channelized-pdcs/opendx/*.cfg $here

topo=$(sed -n '71 s/^[^=]*=*//p ' init_fvars.f)

topo2=${topo:1:-2}

echo $topo2

echo timesteps?
read time


sed -i.bak "78s|^.*$|OPEN(602, FILE='$topo2')|" post.f90
sed -i.bak "167s|^.*$|timesteps=$time|" post.f90



ifort post.f90 -convert big_endian -o post.exe

echo conversion script prepared
echo would you like to submit?Y/N
read answer


 if [ "$answer" == 'Y' ];then
                sbatch conversion.sh
		echo -e "$currentdate postprocessing submitted to cluster\n" > status.txt
        else
                echo script complete
		echo -e "$currentdate post processing compiled not submitted\n" > status.txt
        fi


