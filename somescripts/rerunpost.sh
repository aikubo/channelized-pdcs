#!/bin/bash

echo "Making post processing script"

# do a little cleaning ############
rm scr* 
find . -size 0 -delete

####### set date, run directory, label ##################
datum=$(date +"%D %R")
here=$(pwd)
label=${PWD##*/}
#######echo how many timesteps 
timestep=$(checktime2.sh)
echo $timestep

echo "would you like to rerun for all timesteps?"
read response 
	if [ "$response" == 'N'];then
		echo "tstart"
		read tstart 
		echo "tstop"
		read tstop

		sed -i "s/.*tstart=.*/tstart=$tstart/" post.f90
		sed -i "s/.*tstop=.*/tstart=$tstop/" post.f90
	fi

############## echo compile each module in post directory #################
echo start compliling 
cp $here/post.f90 /home/akubo/myprojects/channelized-pdcs/postprocessing/adv_post
cd /home/akubo/myprojects/channelized-pdcs/postprocessing/adv_post

echo compiling modules and subroutines
ifort -c -convert big_endian postmod.f90
ifort -c -convert big_endian formatmod.f90
ifort -c -convert big_endian constants.f90
ifort -c -convert big_endian openbin.f90
ifort -c -convert big_endian allocate_arrays.f90
ifort -c -convert big_endian handletopo.f90
ifort -c -convert big_endian openascii.f90
ifort -c -convert big_endian var_3d.f90

########## compile post.f90 and move it back to run directory ##########
echo compiling post
ifort var_3d.o postmod.o constants.o formatmod.o openbin.o openascii.o allocate_arrays.o handletopo.o post.f90 -traceback  -convert big_endian -o post.exe

echo finished compiling post 

cp post.exe $here 

cd $here 

######### submit run (or not) then update status files ###################
echo "submit to run"

echo "would you like to submit (Y/N)?"

read response


# following loop adds files to both the status file in the run directory
# and the master status file in the git directory
if [ "$response" == 'Y' ];then
	subm=$(sbatch postsub.sh)
	echo "running"
	echo -e "$datum - $label post $subm for rerun" >> status.txt
	echo -e "$datum - $label post $subm for rerun " >> /home/akubo/myprojects/channelized-pdcs/status_all.txt
else 
	echo "prepared but not submitted"
	echo -e "$datum - $label post.exe compiled but not submitted for rerun" >> status.txt
	echo -e "$datum - $label post.exe compiled but not submitted for rerun" >> /home/akubo/myprojects/channelized-pdcs/status_all.txt

fi 


echo done!


