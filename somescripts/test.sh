#!/bin/bash 
new="AVY0"
echo copy topo file
echo $new 

declare param=($(sh simparam.sh $new))
wave=${param[0]}
amp=${param[1]}
width=${param[2]}

height=${param[3]}

if [ $width -eq 201 ]
then
        depth=27
fi

if [ $width -eq 300 ]
then
        depth=39
fi

echo $depth

topo="l$wave"
topo+="_A"
topo+="$amp"
topo+="_W"
topo+="$width"
echo $topo

amp=$(echo "$amp/100" | bc -l)

echo $amp
#echo editing post.f90
#if [ -s "EP_P_t08.txt" ]
#then
#   echo "EP_P_t08 exists and is not empty"
#   stat=0
# else
#   echo "EP_P_t08.txt does not exist"
#   stat=2
#fi

#cd /home/akubo/myprojects/channelized-pdcs/postprocessing/adv_post
#sed -i.bak "s|.*printstatus=.*|printstatus=$stat|" post.f90
#C1=$(($ch+5))
#BC2=$(($BC1+10))
#oldt="topo_$old"
#echo moving $topo
#cp ~/myprojects/topo/$topo $here/$new/

#echo simulation name 
#read name 

#declare param=($(sh simparam.sh $name))
#wave=${param[1]}
#width=${param[2]}
#height=${param[4]}

#topo="l$wave"
#topo+="_w"
#topo+="$width"
#echo $topo

#topoline=$(grep -i 'OPEN(1010101,' init_fvars.f)
#echo $topoline
#topo=${topoline%'*}
#bottom=100
#height=3
#BC1=$bottom
#BC2=$( echo "$BC1" "$height" | awk '{BC2 = $1 + $2; printf "%.f", BC2}' )
#echo $BC2

#(( inflowwidth= $width /2 ))
#(( SIDE1= 450 - $inflowwidth ))
#(( SIDE2= 450 + $inflowwidth ))

#center=$( echo "$width/2" | bc -l)

#side1=$(echo "450-$center-1" | bc )
#side2=$(echo "450+$center-1" | bc ) 
#echo "$side1 $side2" 
#side1=$(printf '%.2f\n' $side1)
#side2=$(printf '%.2f\n' $side2)

#  BC_Y_s(2)=295.0
#  BC_Y_n(2)=305.0

#sed -i.bak "160s|^.*$|  BC_Y_s(2)=$BC1|" mfix.dat

#sed -i.bak "161s|^.*$|  BC_Y_n(2)=$BC2|" mfix.dat
#sed -i "s/0test/$new/" submission.sh
#topo=$(sed -n '71 s/^[^=]*=*//p ' init_fvars.f)

#topo2=${topo:1:-2}

#echo $topo2
