#!/bin/bash 

#C1=$(($ch+5))
#BC2=$(($BC1+10))
#oldt="topo_$old"
#echo moving $topo
#cp ~/myprojects/topo/$topo $here/$new/

echo simulation name 
read name 

declare param=($(sh simparam.sh $name))

wave=${param[1]}
width=${param[2]}
height=${param[4]}

topo="l$wave"
topo+="_w"
topo+="$width"
echo $topo

(( inflowwidth= $width /2 ))
(( SIDE1= 450 - $inflowwidth ))
(( SIDE2= 450 + $inflowwidth ))

echo $SIDE1 $SIDE2


#  BC_Y_s(2)=295.0
#  BC_Y_n(2)=305.0

#sed -i.bak "160s|^.*$|  BC_Y_s(2)=$BC1|" mfix.dat

#sed -i.bak "161s|^.*$|  BC_Y_n(2)=$BC2|" mfix.dat
#sed -i "s/0test/$new/" submission.sh
#topo=$(sed -n '71 s/^[^=]*=*//p ' init_fvars.f)

#topo2=${topo:1:-2}

#echo $topo2
