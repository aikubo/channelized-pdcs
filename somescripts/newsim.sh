#!/bin/bash
#written by AKubo 1/2019
# updated 6/2019 
# updated 9/2019
#this script copies a directory, renames it, copys the corresponding topography file
# from ~/projects/topo
# then changes the open line in init_fvars
# then has the option to recompile mfix


datum=$(date +"%D %R")

remindnames 

echo new name of directory
read new

here=$(pwd)

echo copying
cp -R /home/akubo/myprojects/sinchannels/SIMDIR/  $here/$new

cd $here/$new
#-------------------------------------------------------------
echo copy topo file
echo $new 

declare param=($(sh simparam.sh $new))

#sh simparam.sh $name

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

cp ~/myprojects/channelized-pdcs/topo/topofiles/$topo $here/$new/

#-------------------------------------------------------------
echo copying submission script
cp ~/myprojects/channelized-pdcs/submission.sh $here/$new/

cd $here/$new/
sed -i "s/TEST/$new/" submission.sh

#-------------------------------------------------------------
echo editing init_fvar.f
sed -i.bak "71s|^.*$|OPEN(1010101,FILE='$topo')|" init_fvars.f

declare -a ch
ch=($(awk '{ print $1 }' $topo ))
bottom=${ch[150]}

echo "channel bottom at $bottom"

BC1=$bottom
BC2=$( echo "$BC1" "$height" | awk '{BC2 = $1 + $2; printf "%.f", BC2}' )

echo "topo height is at $ch"
 
echo the boundary of the input is
echo $BC1
echo $BC2

echo 'please confirm'
read confirm

if [ "$confirm" == 'Y' ] ;then
        echo Confirmed
else
        echo error with topography
	cd $here 
	rm -R $new
        exit 1
fi

sed -i.bak "164s|^.*$|  BC_Y_s(2)=$BC1|" mfix.dat
sed -i.bak "165s|^.*$|  BC_Y_n(2)=$BC2|" mfix.dat

# channel width 

center=$( echo "$width/2" | bc -l)

side1=$(echo "450-$center-1" | bc )
side2=$(echo "450+$center-1" | bc )
echo "$side1 $side2" 
side1=$(printf '%.2f\n' $side1)
side2=$(printf '%.2f\n' $side2)

sed -i.bak "166s|^.*$|  BC_Z_b(2)=$side1|" mfix.dat
sed -i.bak "167s|^.*$|  BC_Z_t(2)=$side2|" mfix.dat


#--------------------------------------------------------------
size=$(stat -c%z $topo)
echo Topography file has this size: $size

cd $here
chmod -R 775 $new
 
echo Directory size is $dirsize

cd $new
echo would you like to compile now? Y or N

read response

if [ "$response" == 'Y' ];then
        echo compiling mfix
#	sed -i '$ a $new' ~/projects/simslist
        sh ~/myprojects/mfix_model/model/make_kubomfix
	
	echo would you like to submit now? Y or N
	read answer 
	if [ "$answer" == 'Y' ];then
		subm=$(sbatch submission.sh)
		jobid=${subm:20}
		
		echo -e "$datum $new $subm" >> status.txt
        	echo -e "$datum $new $subm" >> /home/akubo/myprojects/channelized-pdcs/status_all.txt
	else 
		echo script complete
		echo -e "$datum $new prepared to run" >> status.txt
		echo -e "$datum $new prepared to run" >> /home/akubo/myprojects/channelized-pdcs/status_all.txt


	fi
fi

if [ "$response" == 'N' ];then
	echo script complete
	echo "$datum $new prepared to run but not compiled" >> status.txt
	echo "$datum $new prepared to run but not compiled" >> /home/akubo/myprojects/channelized-pdcs/status_all.txt

fi


